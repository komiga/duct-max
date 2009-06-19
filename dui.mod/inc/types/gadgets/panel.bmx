
Rem
	panel.bmx (Contains: dui_TPanel, )
End Rem

Rem
	bbdoc: The dui panel gadget Type.
End Rem
Type dui_TPanel Extends dui_TGadget

	Global gImage:TImage[9]
	
	Field gBorder:Int = True
	
	Field gMovable:Int
	Field gPMoving:Int = False
	Field gIMoveX:Float, gIMoveY:Float
		
		Rem
			bbdoc: Create a panel.
			returns: The created panel (itself).
			about: @_parent can be either a dui_TGadget or a dui_TScreen
		End Rem
		Method Create:dui_TPanel(_name:String, _x:Float, _y:Float, _w:Float, _h:Float, _movable:Int = True, _parent:Object = Null)
			
			If dui_TScreen(_parent) Then dui_TScreen(_parent).AddGadget(Self)
			PopulateGadget(_name, _x, _y, _w, _h, dui_TGadget(_parent))
			
			SetMovable(_movable)
					
			Return Self
			
		End Method
		
		Rem
			bbdoc: Render the panel and it's children.
			returns: Nothing.
		End Rem
		Method Render(_x:Float, _y:Float)
			Local rX:Float, rY:Float
			
			If IsVisible() = True
				
				SetDrawingState()
				
				' Set up rendering locations
				rX = gX + _x
				rY = gY + _y
				
				If gBorder = True
					' Draw four corners
					DrawImage(gImage[0], rX, rY)
					DrawImage(gImage[2], (rX + gW) - 5, rY)
					DrawImage(gImage[6], rX, (rY + gH) - 5)
					DrawImage(gImage[8], (rX + gW) - 5, (rY + gH) - 5)
					
					' Draw four sides
					DrawImageRect(gImage[1], rX + 5, rY, gW - 10, 5)
					DrawImageRect(gImage[7], rX + 5, (rY + gH) - 5, gW - 10, 5)
					DrawImageRect(gImage[3], rX, rY + 5, 5, gH - 10)
					DrawImageRect(gImage[5], (rX + gW) - 5, rY + 5, 5, gH - 10)
					
					' Draw centre
					DrawImageRect(gImage[4], rX + 5, rY + 5, gW - 10, gH - 10)
					
				Else
					
					' Draw centre
					DrawImageRect(gImage[4], rX, rY, gW, gH)
					
				End If
				
				Super.Render(_x, _y)
				
			End If
			
		End Method
		
		Rem
			bbdoc: Update the panel and it's children
			returns: Nothing.
		End Rem
		Method Update(_x:Int, _y:Int)
			
			' Check for existing mouse down states
			If gState = MOUSEDOWN_STATE
			
				If MouseDown(1)
					UpdateMouseDown(MouseX(), MouseY()) 
					Return
					
				End If
				
				If Not MouseDown(1)
					UpdateMouseRelease(MouseX(), MouseY()) 
					Return
					
				End If
				
			End If
			
			If IsVisible() = True
				
				' Only update the children if this panel has focus
				If TDUIMain.IsPanelFocused(Self) And dui_MouseIn(gX + _x, gY + _y, gW, gH)
					
					' Set the focused panel
					TDUIMain.SetFocusedPanel(Self)
					
					' Update the kids
					For Local child:dui_TGadget = EachIn New TListReversed.Create(gChildren)
						
						child.Update(gX + _x, gY + _y)
						
					Next
					
				End If
				
				gState = IDLE_STATE
				
				' Check for other active gadgets
				If TDUIMain.IsGadgetActive(Self)
					
					' Test for mouse over the gadget
					If dui_MouseIn(gX + _x, gY + _y, gW, gH)
						
						UpdateMouseOver(MouseX(), MouseY())
						
						' Check for a mouse action
						If MouseDown(1) Then UpdateMouseDown(MouseX(), MouseY()) 
						
					End If
					
				End If
				
			End If
			
		End Method
		
		Rem
			bbdoc: Update the MouseOver state.
			returns: Nothing.
		End Rem
		Method UpdateMouseOver(_x:Int, _y:Int)
			
			'TDUIMain.SetCursor(dui_CURSOR_MOUSEOVER)
			Super.UpdateMouseOver(_x, _y)
		
		End Method
		
		Rem
			bbdoc: Update the MouseDown state.
			returns: Nothing.
		End Rem
		Method UpdateMouseDown(_x:Int, _y:Int)
			
			TDUIMain.SetCursor(dui_CURSOR_MOUSEDOWN)
			Super.UpdateMouseDown(_x, _y)
			
			'New dui_TEvent.Create(dui_EVENT_GADGETACTION, Self, 0, MouseX() - gX, MouseY() - gY, Null)
			
			If IsMovable() = True
				If gPMoving = False
					gIMoveX = _x - gX
					gIMoveY = _y - gY
					gPMoving = True
					New dui_TEvent.Create(dui_EVENT_GADGETACTION, Self, 0, _x - gX, _y - gY, Null)
					
				Else
					gX = _x - gIMoveX
					gY = _y - gIMoveY
					
				End If
			End If
			
		End Method
		
		Rem
			bbdoc: Update the MouseRelease state.
			returns: Nothing.
		End Rem
		Method UpdateMouseRelease(_x:Int, _y:Int)
			
			Super.UpdateMouseRelease(_x, _y)
			
			New dui_TEvent.Create(dui_EVENT_GADGETSELECT, Self, 0, _x - gX, _y - gY, Null)
			If gPMoving = True Then gPMoving = False
			
		End Method
		
		Rem
			bbdoc: Turn On drawing for the panel's borders.
			returns: Nothing.
			about: See also #BorderOff.
		End Rem
		Method BorderOn()
			
			gBorder = True
			
		End Method
		
		Rem
			bbdoc: Turn off drawing for the panel's borders.
			returns: Nothing.
			about: See also #BorderOn.
		End Rem
		Method BorderOff()
			
			gBorder = False
			
		End Method
		
		Rem
			bbdoc: Set the movable state on or off.
			returns: Nothing.
		End Rem
		Method SetMovable(_movable:Int)
			
			gMovable = _movable
			gPMoving = False
			
		End Method
		
		Rem
			bbdoc: Check if the panel is movable.
			returns: True if the panel is movable, or False if it is not.
		End Rem
		Method IsMovable:Int()
			
			Return gMovable
			
		End Method
		
		Rem
			bbdoc: Refresh the panel skin.
			returns: Nothing.
		End Rem
		Function RefreshSkin()
			Local x:Int, y:Int, index:Int, map:Int
			Local image:TImage, mainmap:TPixmap, pixmap:TPixmap[9]
			
			image = LoadImage(TDUIMain.SkinUrl + "/graphics/panel.png", DYNAMICIMAGE | FILTEREDIMAGE | MIPMAPPEDIMAGE)
			mainmap = LockImage(image)
			
			For index = 0 To 8
				gImage[index] = CreateImage(5, 5,, FILTEREDIMAGE)
				pixmap[index] = LockImage(gImage[index])
			Next
			
			For y = 0 To 14
				For x = 0 To 14
					
					' Get correct pixmap to write to
					map = ((y / 5) * 3) + (x / 5)
					
					pixmap[map].WritePixel((x Mod 5), (y Mod 5), mainmap.ReadPixel(x, y))
					
				Next
			Next
			
			For index = 0 To 8
				UnlockImage(gImage[index])
			Next
			UnlockImage(image)
			
		End Function
		
End Type




















	