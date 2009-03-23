
' 
' scrollbar.bmx (Contains: dui_TScrollBar, )
' 
' 

Rem
	bbdoc: The dui scrollbar gadget Type.
End Rem
Type dui_TScrollBar Extends dui_TGadget
	
	Const NO_PART:Int = 0			' No part has yet been touched
	Const BAR_PART:Int = 1			' The scrollbar itself
	Const DEC_PART:Int = 2			' The increment button
	Const INC_PART:Int = 3			' The decrement button
	Const BIGDEC_PART:Int = 4		' The area before the bar
	Const BIGINC_PART:Int = 5		' The area after the bar
	
	Const VERT_ALIGN:Int = 0		' Vertical scrollbar
	Const HORIZ_ALIGN:Int = 1		' Horizontal scrollbar
	
	Global gButtonImage:TImage[4]		' Images for the scrollbar's buttons
	Global gBarImage:TImage[6]			' Three images that form the scroll bar itself
	Global gBackImage:TImage			' The scroll area 
	
	Field gAlign:Int					' Alignment (horizontal or vertical)
	
	Field gValue:Int					' Value of the scrollbar
	Field gRange:Int					' The number of values covered by the bar (e.g. a 15 line textbox should have a range of 15)
	
	Field gMax:Int						' Maximum value
	Field gUnit:Float					' Length of a single unit
	Field gBig:Int = 10					' Size of a big increment/decrement
	Field gInc:Int = 1					' Size of a normal increment/decrement
	
	Field gStart:Float					' Location of the start of the scrollbar
	Field gLength:Float					' Length of the scrollbar (including ends)
	
	Field gPart:Int						' Part of the scrollbar that has been activated
	Field gGrab:Int						' Location of the bar that you grabbed (used to set the new position accordingly)
	
	Field gOZ:Int
		
		Rem
			bbdoc: Create a scrollbar.
			returns: The created scrollbar.
		End Rem
		Method Create:dui_TScrollBar(_name:String, _x:Float, _y:Float, _length:Float, _align:Int, _maxval:Int, _range:Int, _parent:dui_TGadget)
			
			gAlign = _align
			If gAlign = HORIZ_ALIGN
				PopulateGadget(_name, _x, _y, _length, 15, _parent)
			Else If gAlign = VERT_ALIGN
				PopulateGadget(_name, _x, _y, 15, _length, _parent)
			End If
			
			SetMax(_maxval)
			SetRange(_range)
			
			Return Self
			
		End Method
		
		Rem
			bbdoc: Render the scrollbar.
			returns: Nothing.
		End Rem
		Method Render(_x:Float, _y:Float)
		  Local rX:Float, rY:Float
			
			If IsVisible() = True
				
				SetDrawingState()
				
				rX = gX + _x
				rY = gY + _y
				
				Select gAlign
					Case VERT_ALIGN
					
						' Background
						DrawImageRect(gBackImage, rX, rY + 10, gW, gH - 20)
						
						' Top
						DrawImage(gButtonImage[0], rX, rY)
						' Bottom
						DrawImage(gButtonImage[1], rX, (rY + gH) - 15)
						
						' Draw scrollbar
						DrawImage(gBarImage[0], rX, gStart + _y)
						DrawImageRect(gBarImage[2], rX, gStart + _y + 3, gW, gLength - 6)
						DrawImage(gBarImage[1], rX, gStart + _y + (gLength - 3))
						
					Case HORIZ_ALIGN
					
						'Background
						DrawImageRect(gBackImage, rX + 10, rY, gW - 20, gH)
					
						' Left
						DrawImage(gButtonImage[2], rX, rY)
						' Right
						DrawImage(gButtonImage[3], (rX + gW) - 15, rY)
						
						' Draw scrollbar
						DrawImage(gBarImage[3], gStart + _x, rY)
						DrawImageRect(gBarImage[5], gStart + _x + 3, rY, gLength - 6, gH)
						DrawImage(gBarImage[4], gStart + _x + (gLength - 3) , rY)
						
				End Select
						
				Super.Render(_x, _y)
				
			End If
			
		End Method
		
		Rem
			bbdoc: Update the scrollbar.
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
					SetValue(gValue - gInc)
				Else
					SetValue(gValue + gInc)
				End If
				
				gOZ = mz
				
			End If
			
		End Method
		
		Rem
			bbdoc: Update the MouseDown state.
			returns: Nothing.
		End Rem
		Method UpdateMouseDown(_x:Int, _y:Int)
		  Local rX:Int, rY:Int
			
			TDUIMain.SetCursor(dui_CURSOR_MOUSEDOWN)
			Super.UpdateMouseDown(_x, _y)
			
			rX = gX + _x
			rY = gY + _y
			
			Select gAlign
				Case VERT_ALIGN
					
					' Check for the part of the gadget to update
					If gPart = NO_PART
						' Check for decrement button
						If dui_MouseIn(rX, rY, gW, 15) Then gPart = DEC_PART
						
						' Increment button
						If dui_MouseIn(rX, (rY + gH) - 15, gW, 15) Then gPart = INC_PART
						
						' Scrollbar
						If dui_MouseIn(rX, (gStart + _y), gW, gLength)
							gPart = BAR_PART
							gGrab = MouseY() - (gStart + _y)
						End If
						
					End If
					
					' Check for bigger increments by clicking scroll area
					If gPart = NO_PART And dui_MouseIn(rX, rY + 15, gW, gH - 30) = True
						
						' Area before the scrollbar
						If MouseY() < gStart + _y
							gPart = BIGDEC_PART
						Else
						' Area after the scrollbar
							gPart = BIGINC_PART
						End If
						
					End If
					
					If gPart = BAR_PART Then SetBarPosition((MouseY() - _y) - gGrab)
					
				Case HORIZ_ALIGN
					
					' Check for the part of the gadget to update
					If gPart = NO_PART
						' Check for increment button
						If dui_MouseIn(rX, rY, 15, gH) Then gPart = DEC_PART
						
						' Decrement button
						If dui_MouseIn(rX + (gW - 15), rY, 15, gH) Then gPart = INC_PART
						
						' Scrollbar
						If dui_MouseIn(gStart + _x, rY, gLength, gH)
							gPart = BAR_PART
							gGrab = MouseX() - (gStart + _x)
						End If
						
					End If
					
					'check for bigger increments by clicking scroll area
					If gPart = NO_PART And dui_MouseIn(rX + 15, rY, gW - 30, gH)
						
						'area before the scrollbar
						If MouseX() < gStart + _x
							gPart = BIGDEC_PART
						Else
						'area after the scrollbar
							gPart = BIGINC_PART
						End If
						
					End If
					
					If gPart = BAR_PART Then SetBarPosition((MouseX() - _x) - gGrab)
					
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
					Case DEC_PART
						SetValue(gValue - gInc)
						
					Case INC_PART
						SetValue(gValue + gInc)
						
					Case BIGDEC_PART
						SetValue(gValue - gBig)
						
					Case BIGINC_PART
						SetValue(gValue + gBig)
						
				End Select
				
			End If
			
			gPart = NO_PART
			
		End Method
		
		Rem
			bbdoc: Set the exact value of the scroll bar
			about: Sets the value of the scroll bar, and positions the bar at the right position.
		End Rem
		Method SetValue(_value:Int, _doevent:Int = True)
			
			gValue = _value
			If (gValue + gRange) > gMax Then gValue = gMax - gRange
			If gValue < 0 Then gValue = 0
			
			UpdateBarPos()
			
			If _doevent = True Then New dui_TEvent.Create(dui_EVENT_GADGETACTION, Self, gValue, 0, 0, Null)
			
		End Method
		
		Rem
			bbdoc: Get the value of the scroll bar
			returns: The value of the scroll bar
		End Rem
		Method GetValue:Int()
			
			Return gValue
			
		End Method
		
		Rem
			bbdoc: Set the position of the bar.
			returns: Nothing.
		End Rem
		Method SetBarPosition(pos:Int)
			
			gStart = pos
			
			' Set the reference value, either gY or gX, and entire gadget length
			Local ref:Float, glen:Int
			
			Select gAlign
				Case VERT_ALIGN
					ref = gY
					glen = gH
				Case HORIZ_ALIGN
					ref = gX
					glen = gW
			End Select
						
			' Check that the bar hasn't gone too high/left
			If gStart < ref + 15
				
				gStart = ref + 15
				gValue = 0
				
			' Check that the bar doesn't go too low/right
			Else If gStart > (ref + glen) - (gLength + 15)
				
				gStart = (ref + glen) - (gLength + 15)		
				gValue = gMax - gRange
				
			' Set the value of the scroll bar according to the position
			Else
				
				gValue = Int((gStart - (ref + 15)) / gUnit)
				
			End If
			
			New dui_TEvent.Create(dui_EVENT_GADGETACTION, Self, gValue, 0, 0, Null)
			
		End Method
			
		Rem
			bbdoc: Set the entire length of the scrollbar area (includes buttons).
			returns: Nothing.
		End Rem
		Method SetLength(_length:Float)
			
			Select gAlign
				Case VERT_ALIGN
					gH = _length
					
				Case HORIZ_ALIGN
					gW = _length
					
			End Select
			
			UpdateBarLength()
			
		End Method
		
		Rem
			bbdoc: Set the range of the scrollbar.
			about: The range of a scrollbar is the number of values the bar actually covers.<br>
			For example, if the bar was used to scroll lines of text, the range of the bar would be the number of lines visible in the text gadget.
		End Rem
		Method SetRange(_range:Int)
			
			gRange = _range
			If gRange < 1 Then gRange = 1
			If (gValue + gRange) > gMax Then gValue = gMax - gRange
			If gValue < 0 Then gValue = 0
			
			UpdateBarLength()
			
		End Method
		
		Rem
			bbdoc: Get the range of the scrollbar.
			returns: The range of the scrollbar.
		End Rem
		Method GetRange:Int()
			
			Return gRange
		
		End Method
		
		Rem
			bbdoc: Set the max value for the scrollbar.
			returns: Nothing.
		End Rem
		Method SetMax(_max:Int)
			
			gMax = _max
			If gMax < 1 Then gMax = 1
			If (gValue + gRange) > gMax Then gValue = gMax - gRange
			If gValue < 0 Then gValue = 0
					
			UpdateBarLength()
			
		End Method
		
		Rem
			bbdoc: Get the max value for the scrollbar.
			returns: The max value for the scrollbar.
		End Rem
		Method GetMax:Int()
			
			Return gMax
		
		End Method
		
		Rem
			bbdoc: Set the increment.
			returns: Nothing.
			about: This is the value added/subtracted when the user presses either of the scrollbar buttons.
		End Rem
		Method SetInc(_inc:Int)
			
			gInc = _inc
			If gInc < 0 Then gInc = 0
			
		End Method
		
		Rem
			bbdoc: Set the big increment.
			returns: Nothing.
			about: This is the value added/subtracted when the user clicks in the empty area between the bar and the buttons at either end.		
		End Rem
		Method SetBigInc(_inc:Int)
			
			gBig = _inc
			If gBig < 0 Then gBig = 0
			
		End Method
		
		Rem
			bbdoc: Update the scrollbar length.
			returns: Nothing.
			about: This calls #UpdateBarPos.
		End Rem
		Method UpdateBarLength()
		
			'set gadget area length
			Local gLen:Int
			
			Select gAlign
				Case VERT_ALIGN gLen = (gH - 30)
				Case HORIZ_ALIGN gLen = (gW - 30)
			End Select
		
			'set the size of a unit
			gUnit = gLen / Float(gMax)
					
			'set the length of the bar, in units
			gLength = gUnit * gRange
			
			'ensure length meets requirements
			If gLength < 6 Then gLength = 6
			If gLength > gLen Then gLength = gLen
			
			UpdateBarPos()
			
		End Method
		
		Rem
			bbdoc: Update the bar position.
			returns: Nothing.
		End Rem
		Method UpdateBarPos()
			
			Select gAlign
				Case VERT_ALIGN gStart = gY + 15 + (gUnit * gValue)			
				Case HORIZ_ALIGN gStart = gX + 15 + (gUnit * gValue)
			End Select
			
		End Method
		
		Rem
			bbdoc: Refresh the skin images for the scrollbar.
			returns: Nothing.
		End Rem
		Function RefreshSkin()
			Local _x:Int, _y:Int, index:Int
			Local image:TImage, mainmap:TPixmap, pixmap:TPixmap[3]
			
			' Load in back area image
			gBackImage = LoadImage(TDUIMain.SkinUrl + "/graphics/scrollback.png")
			
			' Load in four button images
			gButtonImage[0] = LoadImage(TDUIMain.SkinUrl + "/graphics/scrollup.png")
			gButtonImage[1] = LoadImage(TDUIMain.SkinUrl + "/graphics/scrolldown.png")
			gButtonImage[2] = LoadImage(TDUIMain.SkinUrl + "/graphics/scrollleft.png")
			gButtonImage[3] = LoadImage(TDUIMain.SkinUrl + "/graphics/scrollright.png")
			
			' Get the vertical scrollbar image
			image = LoadImage(TDUIMain.SkinUrl + "/graphics/vscrollbar.png")
			mainmap = LockImage(image)
			
			For index = 0 To 1
				
				gBarImage[index] = CreateImage(15, 3)
				pixmap[index] = LockImage(gBarImage[index])
				
			Next
			gBarImage[2] = CreateImage(15, 1)
			pixmap[2] = LockImage(gBarImage[2])
			
			For _y = 0 To 6
				For _x = 0 To 14
					
					If _y < 3
						pixmap[0].WritePixel(_x, _y, mainmap.ReadPixel(_x, _y))
					End If
					
					If _y = 3
						pixmap[2].WritePixel(_x, _y - 3, mainmap.ReadPixel(_x, _y))
					End If
					
					If _y > 3
						pixmap[1].WritePixel(_x, _y - 4, mainmap.ReadPixel(_x, _y))
					End If
					
				Next
			Next
			
			'unlock images
			For index = 0 To 2
				UnlockImage(gBarImage[index])
			Next
			UnlockImage(image)
			
			'horizontal scrollbar image
			image = LoadImage(TDUIMain.SkinUrl + "/graphics/hscrollbar.png")
			mainmap = LockImage(image)
			
			'create the three images
			For index = 0 To 1
				gBarImage[index + 3] = CreateImage(3, 15)
				pixmap[index] = LockImage(gBarImage[index + 3])
			Next
			gBarImage[5] = CreateImage(1, 15)
			pixmap[2] = LockImage(gBarImage[5])
			
			' Copy the pixels across
			For _x = 0 To 6
				For _y = 0 To 14
					
					If _x < 3
						pixmap[0].WritePixel(_x, _y, mainmap.ReadPixel(_x, _y))
					End If
					
					If _x = 3
						pixmap[2].WritePixel(_x - 3, _y, mainmap.ReadPixel(_x, _y))
					End If
					
					If _x > 3
						pixmap[1].WritePixel(_x - 4, _y, mainmap.ReadPixel(_x, _y))
					End If
					
				Next
			Next
			
			For index = 3 To 5
				UnlockImage(gBarImage[index])
			Next
			UnlockImage(image)
			
		End Function
		
End Type























	