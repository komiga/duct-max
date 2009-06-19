
Rem
	progressbar.bmx (Contains: dui_TProgressBar, )
End Rem

Rem
	bbdoc: The dui progress bar gadget type.
End Rem
Type dui_TProgressBar Extends dui_TGadget
	
	Global gImage:TImage[9]
	
	Field gCapX:Int
	Field gColour:Int[][] = [[255, 255, 255], [255, 0, 0] ]
	
	Field gValue:Int
	Field gText:String
		
		Rem
			bbdoc: Create a progress bar.
			returns: The created progress bar.
		End Rem
		Method Create:dui_TProgressBar(_name:String, _text:String, _x:Float, _y:Float, _w:Float, _h:Float, _parent:dui_TGadget)
			
			PopulateGadget(_name, _x, _y, _w, _h, _parent)
			
			SetText(_text)
			
			Return Self
			
		End Method
		
		Rem
			bbdoc: Render the progress bar.
			returns: Nothing.
		End Rem
		Method Render(_x:Float, _y:Float)
			Local rX:Float, rY:Float, fw:Float
			
			If IsVisible() = True
				
				SetDrawingState(0)
				
				rX = gX + _x
				rY = gY + _y
				
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
				fw = (gW - 10) * Float(gValue / 100.0)
				
				' Empty part
				DrawImageRect(gImage[4], (rX + 5) + fw, rY + 5, (gW - 10) - fw, gH - 10)
				
				' Filled part
				SetDrawingState(1)
				DrawImageRect(gImage[4], rX + 5, ry + 2, fw, gH - 4)
				
				SetTextDrawingState(True)
				DrawText(GetText(), gCapX + _x, rY + 3)
				
				Super.Render(_x, _y)
				
			End If
			
		End Method
		
		Rem
			bbdoc: Refresh the the progress bar.
			returns: Nothing.
		End Rem
		Method Refresh()
			
			gCapX = (gX + (gW / 2)) - (dui_TFont.GetFontStringWidth(gText, GetFont()) / 2)
			
		End Method
		
		Rem
			bbdoc: Set the progress bar's text.
			returns: Nothing.
		End Rem
		Method SetText(_text:String)
			
			gText = _text
			Refresh()
			
		End Method
		Rem
			bbdoc: Get the progress bar's text.
			returns: The progress bar's text.
		End Rem
		Method GetText:String()
			
			Return gText
			
		End Method
		
		Rem
			bbdoc: Set the current progress/value.
			returns: Nothing.
			about: @_value is clamped to 0 to 100.
		End Rem
		Method SetValue(_value:Int, _doevent:Int)
			
			gValue = IntMax(IntMin(_value, 0), 100)
			
			If _doevent = True Then New dui_TEvent.Create(dui_EVENT_GADGETACTION, Self, GetValue(), 0, 0, Null)
			
		End Method
		
		Rem
			bbdoc: Get the current progress.
			returns: The progress bar's progress/value.
		End Rem
		Method GetValue:Int()
			
			Return gValue
			
		End Method
		
		Rem
			bbdoc: Set one of the gadget's colours.
			returns: Nothing.
			about: Sets the colour of the gadget.<br>
			@_index can be: <br>
			0 = Gadget colour<br>
			1 = Fill colour
		End Rem
		Method SetColour(_r:Int, _g:Int, _b:Int, _index:Int = 0)
			
			If _index = 0 Or _index = 1
				gColour[_index] = [_r, _g, _b]
			End If
			
		End Method
		
		Rem
			bbdoc: Refresh the progress bar's skin.
			returns: Nothing.
		End Rem
		Function RefreshSkin()
			Local x:Int, y:Int, index:Int, map:Int
			Local image:TImage, mainmap:TPixmap, pixmap:TPixmap[9]
			
			image = LoadImage(TDUIMain.SkinUrl + "/graphics/progress.png")
			mainmap = LockImage(image)
			
			For index = 0 To 8
				gImage[index] = CreateImage(5, 5)
				pixmap[index] = LockImage(gImage[index])
			Next
			
			For y = 0 To 14
				For x = 0 To 14
					
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

















