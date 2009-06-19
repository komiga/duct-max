
Rem
	slider.bmx (Contains: dui_TSlider, )
End Rem

Rem
	bbdoc: The dui slider gadget Type.
End Rem
Type dui_TSlider Extends dui_TGadget
	
	Const NO_PART:Int = 0			' No part has yet been touched
	Const BAR_PART:Int = 1			' The slider itself
	Const BIGDEC_PART:Int = 4		' The area before the bar
	Const BIGINC_PART:Int = 5		' The area after the bar
	
	Const VERT_ALIGN:Int = 0		' Vertical slider
	Const HORIZ_ALIGN:Int = 1		' Horizontal slider
	
	Global gBarImage:TImage[6]	' Three images that form the slider itself
	Global gBackImage:TImage	' The slider area
	
	Field gAlign:Int		' Alignment (horizontal or vertical)
	
	Field gSX:Float			' Slider track x position
	Field gSY:Float			' Slider track y position
	Field gSLen:Int			' Slider track length
	
	Field gValue:Int		' Value of the slider
	Field gStartVal:Int		' The starting value
	Field gEndVal:Int		' The end value
	
	Field gUnit:Float		' Length of a single unit, in pixels
	Field gInc:Int = 1		' Size of a normal increment/decrement, in units
	
	Field gStart:Int		' Location of the start of the slider button
	Field gLength:Int = 15	' Length of the slider (including ends)
	
	Field gPart:Int			' Part of the slider that has been activated
	Field gGrab:Int			' The position where you grabbed the slider
	Field gOZ:Int
		
		Rem
			bbdoc: Create a slider gadget.
			returns: The created slider (itself).
		End Rem
		Method Create:dui_TSlider(_name:String, _x:Float, _y:Float, _length:Float, _align:Int, _startval:Int, _endval:Int, _inc:Int, _parent:dui_TGadget)
			
			' Populate gadgets, updating locations and length to maintain a good size slider			
			If _align
				gAlign = HORIZ_ALIGN
				PopulateGadget(_name, _x, _y, _length, 15, _parent)
				gSX = _x + 7
				gSY = _y
			Else
				gAlign = VERT_ALIGN
				PopulateGadget(_name, _x, _y, 15, _length, _parent)
				gSX = _x
				gSY = _y + 7
			End If
			gSLen = _length - 14
			
			SetRange(_startval, _endval)
			SetIncrement(_inc)
			
			Return Self
			
		End Method
		
		Rem
			bbdoc: Render the slider.
			returns: Nothing.
		End Rem
		Method Render(_x:Float, _y:Float)
			Local rx:Float, ry:Float, rsx:Float, rsy:Float
			
			If IsVisible() = True
				
				SetDrawingState()
				
				rx = gX + _x
				ry = gY + _y
				
				rsx = gSX + _x
				rsy = gSY + _y
							
				Select gAlign
					Case VERT_ALIGN
						
						' Background
						DrawImageRect(gBackImage, rsx + 5, rsy, 5, gSLen)
						DrawImageRect(gBackImage, rsx + 2, rsy + (gSLen / 2) - 1, 11, 2)
						
						' Draw scrollbar
						DrawImage(gBarImage[0], rx, gStart + _y)
						DrawImageRect(gBarImage[2], rX, gStart + _y + 3, gW, gLength - 6)
						DrawImage(gBarImage[1], rx, gStart + _y + (gLength - 3))
						
					Case HORIZ_ALIGN
						
						' Background
						DrawImageRect(gBackImage, rsx, rsy + 5, gSLen, 5)
						DrawImageRect(gBackImage, rsx + (gSLen / 2) - 1, rsy + 2, 2, 11)
						
						' Draw scrollbar
						DrawImage(gBarImage[3], gStart + _x, ry)
						DrawImageRect(gBarImage[5], gStart + _x + 3, ry, gLength - 6, gH)
						DrawImage(gBarImage[4], gStart + _x + (gLength - 3) , ry)
						
				End Select
				
				Super.Render(_x, _y)
				
			End If
			
		End Method
		
		Rem
			bbdoc: Update the slider.
			returns: Nothing.
		End Rem
		Method Update(_x:Int, _y:Int)
			
			If Not gState
				
				gOZ = MouseZ()
				
			End If
			
			Super.Update(_x, _y)
			
		End Method
		
		Rem
			bbdoc: Update the MouseOver state.
			returns: Nothing.
		End Rem
		Method UpdateMouseOver(_x:Int, _y:Int)
			Local mz:Int
			
			TDUIMain.SetCursor(dui_CURSOR_MOUSEOVER)
			Super.UpdateMouseOver(_x, _y)
			
			mz = MouseZ()
			If mz <> gOZ
				If mz > gOZ
					SetValue(gValue + gInc)
				Else
					SetValue(gValue - gInc)
				End If
				
				gOZ = mz
				
			End If
			
		End Method
		
		Rem
			bbdoc: Update the MouseDown state.
			returns: Nothing.
		End Rem
		Method UpdateMouseDown(_x:Int, _y:Int)
			Local rx:Int, ry:Int
			
			TDUIMain.SetCursor(dui_CURSOR_MOUSEDOWN)
			Super.UpdateMouseDown(_x, _y)
			
			rX = gX + _x
			rY = gY + _y
			
			Select gAlign
				Case VERT_ALIGN
					
					' Check for the part of the gadget to update
					If gPart = NO_PART
						
						' Scrollbar
						If dui_MouseIn(rx, (gStart + _y), gW, gLength) = True
							gPart = BAR_PART
							gGrab = gStart + 7
							'SetValueByPos(MouseY() - (_y + gSY), True)
							
						Else If dui_MouseIn(rx, ry, gW, gH) = True
							
							' Area before the slider
							If MouseY() < gStart + _y
								gPart = BIGINC_PART
							Else
								' Area after the slider
								gPart = BIGDEC_PART
							End If
							
						End If
						
					Else If gPart = BAR_PART
						
						SetValueByPos(MouseY() - (_y + gSY), True)
						
					End If
					
				Case HORIZ_ALIGN
					
					' Check for the part of the gadget to update
					If gPart = NO_PART
						
						' Scrollbar
						If dui_MouseIn(gStart + _x, ry, gLength, gH) = True
							gPart = BAR_PART
							gGrab = gStart + 7
							'SetValueByPos(MouseX() - (_x + gSX), True)
							
						Else If dui_MouseIn(rx, ry, gW, gH) = True
							
							' Area before the scrollbar
							If MouseX() < gStart + _x
								gPart = BIGDEC_PART
							Else
								' Area after the scrollbar
								gPart = BIGINC_PART
							End If
							
						End If
						
					Else If gPart = BAR_PART
						
						SetValueByPos(MouseX() - (_x + gSX), True)
						
					End If
					
			End Select
			
		End Method
		
		Rem
			bbdoc: Update the MouseRelease state.
			returns: Nothing.
		End Rem
		Method UpdateMouseRelease(_x:Int, _y:Int)
			
			Super.UpdateMouseRelease(_x, _y)
			
			If dui_MouseIn(gX + _x, gY + _y, gW, gH) = True
				
				Select gPart
					
					Case BIGDEC_PART
						SetValue(gValue - gInc)
						
					Case BIGINC_PART
						SetValue(gValue + gInc)
						
				End Select
				
			End If
			
			gPart = NO_PART
			
		End Method
		
		Rem
			bbdoc: Update the length of a unit.
			returns: Nothing.
			about: This calls #UpdateBarPos. This updates the graphical change for the given increment.
		End Rem
		Method UpdateUnitLength()
			Local _range:Int
			
			' Get the range, then the unit length
			_range = gEndVal - gStartVal
			
			gUnit = Float(gSLen) / (Float(_range) / Float(gInc))
				
			UpdateBarPos()
		
		End Method
		
		Rem
			bbdoc: Update the slider bar position.
			returns: Nothing.
		End Rem
		Method UpdateBarPos()
			
			Select gAlign
				Case VERT_ALIGN
					gStart = ((gSY + gSLen) - (gUnit * Float(GetValue()))) - (gLength / 2)
					
				Case HORIZ_ALIGN
					gStart = (gSX + (gUnit * Float(GetValue()))) - (gLength / 2)
				
			End Select
			
		End Method
		
		Rem
			bbdoc: Set the exact value of the slider.
			returns: Nothing.
			about: @_value will be clamped to StartValue to EndValue. This will only trigger the event given @_doevent is True and if the set value is greater or less than the old.<br> This will call #UpdateBarPos.
		End Rem
		Method SetValue(_value:Int, _doevent:Int = True)
			Local ovalue:Int = gValue
			
			gValue = IntMax(IntMin(_value, GetStartValue()), GetEndValue())
			If gValue <> ovalue
				UpdateBarPos()
				
				If _doevent = True Then New dui_TEvent.Create(dui_EVENT_GADGETACTION, Self, gValue, 0, 0, Null)
				
			End If
			
		End Method
		
		Rem
			bbdoc: Set the value of the slider by a screen position.
			returns: Nothing.
			about: This will determine the closest value to the given position and select it
		End Rem
		Method SetValueByPos(_pos:Int, _doevent:Int = True)
			Local _value:Int
			
			' Rough value is the position value, divided by length of unit
			_value = _pos / gUnit
			
			' Adjust if the higher unit is actually closer
			If _pos - (_value * gUnit) > (gUnit / 2) Then _value = _value + 1
			
			' Finally, adjust if the bar is vertical
			If gAlign = VERT_ALIGN Then _value = GetEndValue() - (_value - GetStartValue())
			
			' Set the value 
			SetValue(_value, _doevent)
			
		End Method
		
		Rem
			bbdoc: Get the value of the slider.
			returns: The value of the slider.
		End Rem
		Method GetValue:Int()
			
			Return gValue
			
		End Method
		
		Rem
			bbdoc: Set the range of the slider.
			returns: Nothing.
			about: This will call #UpdateUnitLength.
		End Rem
		Method SetRange(_startvalue:Int, _endvalue:Int)
			
			gStartVal = _startvalue
			If _endvalue >= _startvalue Then gEndVal = _endvalue Else gEndVal = _startvalue
			
			UpdateUnitLength()
			
		End Method
		
		Rem
			bbdoc: Get the start value.
			returns: The progress bar's start value.
		End Rem
		Method GetStartValue:Int()
			
			Return gStartVal
			
		End Method
		
		Rem
			bbdoc: Get the end value.
			returns: The progrss bar's end value.
		End Rem
		Method GetEndValue:Int()
			
			Return gEndVal
			
		End Method
		
		Rem
			bbdoc: Set the increment for the slider.
			returns: Nothing.
			about The increment is the amount the slider value is changed when the slider is dragged. This will call #UpdateUnitLength.
		End Rem
		Method SetIncrement(inc:Int)
		
			gInc = Abs(inc)
			
			UpdateUnitLength()
			
		End Method
		
		Rem
			bbdoc: Refresh the skin for the slider.
			returns: Nothing.
		End Rem
		Function RefreshSkin()
			
			Local pixmap:TPixmap[3], image:TImage, mainmap:TPixmap
			Local x:Int, y:Int, index:Int
			
			' Load in back area image
			gBackImage = LoadImage(TDUIMain.SkinUrl + "/graphics/scrollback.png")
			
			' Get the vertical scrollbar image
			image = LoadImage(TDUIMain.SkinUrl + "/graphics/vscrollbar.png")
			mainmap = LockImage(image)
			
			For index = 0 To 1
				gBarImage[index] = CreateImage(15, 3)
				pixmap[index] = LockImage(gBarImage[index])
			Next
			gBarImage[2] = CreateImage(15, 1)
			pixmap[2] = LockImage(gBarImage[2])
			
			For y = 0 To 6
				For x = 0 To 14
				
					If y < 3
						pixmap[0].WritePixel(x, y, mainmap.ReadPixel(x, y))
					End If
					
					If y = 3
						pixmap[2].WritePixel(x, y - 3, mainmap.ReadPixel(x, y))
					End If
					
					If y > 3
						pixmap[1].WritePixel(x, y - 4, mainmap.ReadPixel(x, y))
					End If
					
				Next
			Next
			
			For index = 0 To 2
				UnlockImage(gBarImage[index])
			Next
			UnlockImage(image)
			
			' Horizontal scrollbar image
			image = LoadImage(TDUIMain.SkinUrl + "/graphics/hscrollbar.png")
			mainmap = LockImage(image)
			
			For index = 0 To 1
				gBarImage[index + 3] = CreateImage(3, 15)
				pixmap[index] = LockImage(gBarImage[index + 3])
			Next
			gBarImage[5] = CreateImage(1, 15)
			pixmap[2] = LockImage(gBarImage[5])
			
			For x = 0 To 6
				For y = 0 To 14
				
					If x < 3
						pixmap[0].WritePixel(x, y, mainmap.ReadPixel(x, y))
					End If
					
					If x = 3
						pixmap[2].WritePixel(x - 3, y, mainmap.ReadPixel(x, y))
					End If
					
					If x > 3
						pixmap[1].WritePixel(x - 4, y, mainmap.ReadPixel(x, y))
					End If
					
				Next
			Next
			
			For index = 3 To 5
				UnlockImage(gBarImage[index])
			Next
			UnlockImage(image)
			
		End Function
		
End Type
























