
Rem
	button.bmx (Contains: dui_TButton, )
End Rem

Rem
	bbdoc: The dui button gadget Type.
End Rem
Type dui_TButton Extends dui_TGadget
	
	Global gImage:TImage[9]	
	
	Field gText:String
	Field gCapX:Float, gCapY:Float
	
	Field gButtonImage:TImage
	Field gBackground:Int = True
		
		Rem
			bbdoc: Create a button.
			returns: The created button (itself).
			about: @_image can be either a TImage or a String (it will be loaded for you).
		End Rem
		Method Create:dui_TButton(_name:String, _text:String, _image:Object, _x:Float, _y:Float, _w:Float, _h:Float, _parent:dui_TGadget, _background:Int = True)
			
			PopulateGadget(_name, _x, _y, _w, _h, _parent, False)
			
			SetText(_text, False)
			SetBackground(_background)
			
			LoadImage(_image, False)
			
			Refresh()
			
			Return Self
			
		End Method
		
		Rem
			bbdoc: Render the button.
			returns: Nothing.
		End Rem
		Method Render(_x:Float, _y:Float)
			Local rX:Float, rY:Float
			
			If IsVisible() = True
				
				SetDrawingState()
				
				rX = gX + _x
				rY = gY + _y
				
				If gBackground = True
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
					
				End If
				
				If gButtonImage <> Null
					DrawImage(gButtonImage, gCapX + _x, gCapY + _y)
				Else
					SetTextDrawingState()
					DrawText(gText, gCapX + _x, gCapY + _y)
				End If
				
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
			
			'New dui_TEvent.Create(dui_EVENT_GADGETACTION, Self, 0, 0, 0, Null)
			
		End Method
		
		Rem
			bbdoc: Update the MouseRelease state.
			returns: Nothing.
		End Rem
		Method UpdateMouseRelease(_x:Int, _y:Int)
			Local search:dui_TSearchPanel
			
			Super.UpdateMouseRelease(_x, _y)
			
			If dui_MouseIn(gX + _x, gY + _y, gW, gH) = True
				search = dui_TSearchPanel(gParent)
				If search <> Null
					
					' Set the data of the search box to its null value
					search.Deactivate()
					search.SelectItem(Null)
					search.Hide()
					
				Else
					
					New dui_TEvent.Create(dui_EVENT_GADGETACTION, Self, 0, 0, 0, Null)
					
				End If
				
			End If
			
		End Method
		
		Rem
			bbdoc: Refresh the button.
			returns: Nothing.
		End Rem
		Method Refresh()
			Local halfx:Float, halfy:Float
			
			If gButtonImage <> Null
				halfx = gButtonImage.width / 2
				halfy = gButtonImage.height / 2
			Else
				halfx = dui_TFont.GetFontStringWidth(gText, GetFont()) / 2
				halfy = dui_TFont.GetFontHeight(GetFont()) / 2
			End If
			
			gCapX = (gX + (gW / 2)) - halfx
			gCapY = (gY + (gH / 2)) - halfy
			
		End Method
		
		Rem
			bbdoc: Set the button text.
			returns: Nothing.
		End Rem
		Method SetText(_text:String, _dorefresh:Int = True)
			
			gText = _text
			If _dorefresh = True Then Refresh()
			
		End Method
		
		Rem
			bbdoc: Get the button's text.
			returns: The button text.
		End Rem
		Method GetText:String()
			
			Return gText
			
		End Method
		
		Rem
			bbdoc: Set the button image.
			returns: Nothing.
		End Rem
		Method SetImage(_image:TImage, _dorefresh:Int = True)
			
			If _image <> Null
				gButtonImage = _image
				If _dorefresh = True Then Refresh()
			End If
			
		End Method
		
		Rem
			bbdoc: Get the button image.
			returns: The button image (the image might be Null - not set).
		End Rem
		Method GetImage:TImage()
			
			Return gButtonImage
			
		End Method
		
		Rem
			bbdoc: Load the button image.
			returns: Nothing.
			about: This will set the button image to TImage( @_url ) or by loading @_url as an image (if it is a string).
		End Rem
		Method LoadImage(_url:Object, _dorefresh:Int = True)
			Local _image:TImage
			
			_image = TImage(_url)
			If _image = Null And String(_url)
				_image = brl.max2d.LoadImage(String(_url))
			End If
			
			SetImage(_image, _dorefresh)
			
		End Method
		
		Rem
			bbdoc: Turn the background drawing for the button on or off.
			returns: Nothing.
		End Rem
		Method SetBackground(_background:Int)
			
			gBackground = _background
			
		End Method
		
		Rem
			bbdoc: Refresh the skin for the button gadget.
			returns: Nothing.
		End Rem
		Function RefreshSkin()
			Local x:Int, y:Int, index:Int, map:Int
			Local image:TImage, mainmap:TPixmap, pixmap:TPixmap[9]
			
			' Load in skin image
			image = LoadImage(TDUIMain.SkinUrl + "/graphics/button.png")
			mainmap = LockImage(image)
			
			For index = 0 To 8
				gImage[index] = CreateImage(5, 5)
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




































	