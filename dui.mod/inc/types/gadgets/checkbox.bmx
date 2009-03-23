
' 
' checkbox.bmx (Contains: dui_TCheckBox, )
' 
' 

Rem
	bbdoc: The dui checkbox gadget Type.
End Rem
Type dui_TCheckBox Extends dui_TGadget
	
	Const LEFT_ALIGN:Int = 0
	Const RIGHT_ALIGN:Int = 1
	
	Global gImage:TImage
	
	Field gTicked:Int
	Field gText:String
	Field gAlign:Int
	
	Field gCapX:Int, gImgX:Int, gOrigX:Int
		
		Rem
			bbdoc: Create a checkbox gadget.
			returns: The created checkbox (itself).
		End Rem
		Method Create:dui_TCheckBox(_name:String, _text:String, _x:Float, _y:Float, _align:Int, _parent:dui_TGadget)
			
			PopulateGadget(_name, _x, _y, 0.0, 0.0, _parent)
			
			gOrigX = _x
			SetText(_text)
			SetAlign(_align)
			
			gH = gImage.height
			
			Return Self
			
		End Method
		
		Rem
			bbdoc: Render the checkbox.
			returns: Nothing.
		End Rem
		Method Render(_x:Float, _y:Float)
			Local rY:Float
			
			If IsVisible() = True
				
				SetDrawingState()
				
				rY = gY + _y
				
				If GetState() = True
					DrawImage(gImage, gImgX + _x, rY, 1)
				Else
					DrawImage(gImage, gImgX + _x, rY, 0)
				End If
				
				SetTextDrawingState()
				DrawText(gText, gCapX + _x, rY)
				
				Super.Render(_x, _y)
									
			End If
			
		End Method
		
		Rem
			bbdoc: Update the MouseOver state.
			returns: Nothing.
		End Rem
		Method UpdateMouseOver(_x:Int, _y:Int)
			
			TDUIMain.SetCursor(dui_CURSOR_MOUSEOVER)
			Super.UpdateMouseOver(_x, _y)
			
		End Method
		
		Rem
			bbdoc: Update the MouseDown state.
			returns: Nothing.
		End Rem
		Method UpdateMouseDown(_x:Int, _y:Int)
			
			TDUIMain.SetCursor(dui_CURSOR_MOUSEDOWN)
			Super.UpdateMouseDown(_x, _y)
			
		End Method
		
		Rem
			bbdoc: Update the MouseRelease state.
			returns: Nothing.
		End Rem
		Method UpdateMouseRelease(_x:Int, _y:Int)
			
			Super.UpdateMouseRelease(_x, _y)
			
			If dui_MouseIn(gX + _x, gY + _y, gW, gH) = True
				Toggle()
				New dui_TEvent.Create(dui_EVENT_GADGETACTION, Self, GetState(), 0, 0, Null)
			End If
			
		End Method
		
		Rem
			bbdoc: Set the alignment of the checkbox.
			returns: Nothing.
			about: The alignment can be LEFT_ALIGN (0) or RIGHT_ALIGN (1). This refreshes the gadget.
		End Rem
		Method SetAlign(_align:Int)
			
			If _align = 0 Or _align = 1
				
				gAlign = _align
				Refresh()
				
			End If
			
		End Method
		
		Rem
			bbdoc: Refresh the checkbox.
			returns: Nothing.
		End Rem
		Method Refresh()
			
			Select gAlign
				Case LEFT_ALIGN
					gImgX = gOrigX
					gCapX = gOrigX + gImage.width + 5
					gX = gOrigX
					
				Case RIGHT_ALIGN
					gImgX = gOrigX - gImage.width
					gCapX = gImgX - (5 + dui_TFont.GetFontStringWidth(gText, gFont))
					gX = gCapX
					
			End Select
			
			gW = gImage.width + 5 + dui_TFont.GetFontStringWidth(gText, gFont)
			
		End Method
		
		Rem
			bbdoc: Set the gadget position.
			returns: Nothing.
		End Rem
		Method SetPosition(_x:Float, _y:Float)
			
			gOrigX = _x
			gY = _y
			Refresh()
			
		End Method
		
		Rem
			bbdoc: Move the gadget by an offset.
			returns: Nothing.
		End Rem
		Method MoveGadget(_xoff:Float, _yoff:Float)
			
			gOrigX = gOrigX + _xoff
			gY = gY + _yoff
			Refresh()
			
		End Method
		
		Rem
			bbdoc: Set the textfor the checkbox.
			returns: Nothing.
		End Rem
		Method SetText(_text:String)
			
			gText = _text
			Refresh()
			
		End Method
		
		Rem
			bbdoc: Toggle the ticked state of the checkbox.
			returns: Nothing.
		End Rem
		Method Toggle()
			
			SetState(gTicked ~ 1)
			
		End Method
		
		Rem
			bbdoc: Set the toggled state of the checkbox.
			returns: Nothing.
		End Rem
		Method SetState(_ticked:Int)
			
			gTicked = _ticked
			
		End Method
		
		Rem
			bbdoc: Get the ticked state of the checkbox.
			returns: Nothing.
		End Rem
		Method GetState:Int()
			
			Return gTicked
			
		End Method
		
		Rem
			bbdoc: Refresh the checkbox skin.
			returns: Nothing.
		End Rem
		Function RefreshSkin()
			
			gImage = LoadAnimImage(TDUIMain.SkinUrl + "/graphics/checkbox.png", 15, 15, 0, 2)
			
		End Function
		
End Type

























