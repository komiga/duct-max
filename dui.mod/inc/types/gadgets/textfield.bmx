
Rem
	textfield.bmx (Contains: dui_TTextField, )
End Rem

Rem
	bbdoc: The dui textfield gadget type.
End Rem
Type dui_TTextField Extends dui_TGadget
	
	Const IDLE_MODE:Int = 0		' Gadget is not accepting text input
	Const INPUT_MODE:Int = 1	' Gadget will accept text input		
	
	Global gImage:TImage[9], gSearchImage:TImage
	Global gBlinkTimer:TMSTimer = New TMSTimer.Create(500), gcursoron:Int
	
	Field gText:String					' Text content
	Field gMode:Int						' In input mode (gadget remians active regardless of mouse presses)
	Field gCursorPos:Int				' Cursor position
	Field gCX:Int						' Cursor's x location, where 0 is the start of the text
	Field gTX:Int						' Text's x location, where 0 is the start of the visible area
	
	Field gSearch:Int					' Set text field to search field
		
		Rem
			bbdoc: Create a textfield gadget.
			returns: The created textfield (itself).
		End Rem
		Method Create:dui_TTextField(_name:String, _text:String, _x:Float, _y:Float, _w:Float, _h:Float, _search:Int, _parent:dui_TGadget)
			
			PopulateGadget(_name, _x, _y, _w, _h, _parent)
			
			SetText(_text)
			gSearch = _search
			
			'SetTextColour(0, 0, 0)
			
			Return Self
			
		End Method
		
		Rem
			bbdoc: Render the textfield.
			returns: Nothing.
		End Rem
		Method Render(_x:Float, _y:Float)
			Local rX:Float, rY:Float
			
			If IsVisible() = True
				
				SetDrawingState()
				
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
				DrawImageRect(gImage[4], rX + 5, rY + 5, gW - 10, gH - 10)
				
				TDrawState.Push(False, False, False, False, False, True, False, True)
				
				If gSearch = True
					DrawImage(gSearchImage, rX + (gW - 16), rY + ((gH - 2) / 2) - 4)
					dui_SetViewport(rX + 2, rY + 2, gW - 20, gH - 4)
				Else
					dui_SetViewport(rX + 2, rY + 2, gW - 4, gH - 4)
				End If
				
				SetTextDrawingState()
				DrawText(GetText(), rX + gTx + 2, rY + 3)
				
				If gMode = INPUT_MODE
					
					If gBlinkTimer.Update() = True
						gcursoron:~ 1
					End If
					
					If gcursoron = True
						SetLineWidth(1.5)
						DrawLine(gCX + rX + gTX + 2, rY + 2, gCX + rX + gTX + 2, rY + (gH - 4))
					End If
					
				End If
				
				TDrawState.Pop(False, False, False, False, False, True, False, True)
				
				Super.Render(_x, _y)
				
			End If
			
		End Method
		
		Rem
			bbdoc: Update the textfield.
			returns: Nothing.
		End Rem
		Method Update(_x:Int, _y:Int)
			
			Super.Update(_x, _y)
			
			If gMode = INPUT_MODE And MouseDown(1) = True
				
				UpdateMouseDown(_x, _y)
				
			End If
			
		End Method
		
		Rem
			bbdoc: Update the MouseOver state.
			returns: Nothing.
		End Rem
		Method UpdateMouseOver(_x:Int, _y:Int)
			
			If gSearch = True And dui_MouseIn(gX + _x + (gW - gSearchImage.width - 7), gY + _y, gSearchImage.width + 7, gSearchImage.height + 7) = False Or gSearch = False And dui_MouseIn(gX + _x, gY + _y, gW, gH) = True
				TDUIMain.SetCursor(dui_CURSOR_TEXTOVER)
			End If
			
			Super.UpdateMouseOver(_x, _y)
			
		End Method
		
		Rem
			bbdoc: Update the MouseDown state.
			returns: Nothing.
		End Rem
		Method UpdateMouseDown(_x:Int, _y:Int)
			
			'TDUIMain.SetCursor(dui_CURSOR_TEXTOVER)
			Super.UpdateMouseDown(_x, _y)
			
			If gMode = IDLE_MODE Then FlushKeys()
			
			' Set the text input mode
			gMode = INPUT_MODE
			
			' Test the mouse location to see what was clicked
			If dui_MouseIn(gX + _x, gY + _y, gW, gH) = True
				
				' First, test that it's part of the text
				If gSearch = False Or dui_MouseIn(gX + _x, gY + _y, gW - 20, gH)
					TDUIMain.SetCursor(dui_CURSOR_TEXTOVER)
					SetCursorPositionByX(MouseX() - _x)
				Else If gSearch = True And dui_MouseIn(gX + _x + (gW - 17), gY + _y, 12, 17)
					TDUIMain.SetCursor(dui_CURSOR_MOUSEDOWN)
				End If
				
			End If
			
		End Method
		
		Rem
			bbdoc: Update the MouseRelease state.
			returns: Nothing.
		End Rem
		Method UpdateMouseRelease(_x:Int, _y:Int)
			
			Super.UpdateMouseRelease(_x, _y)
			
			If dui_MouseIn(gX + _x, gY + _y, gW, gH) = False
				gState = IDLE_STATE
				gMode = IDLE_MODE
				TDUIMain.ClearActiveGadget()
				'Deactivate()
			End If
			
			If gMode = INPUT_MODE
				TDUIMain.SetActiveGadget(Self)
				gBlinkTimer.Reset(- gBlinkTimer.GetMS())
				gcursoron = False
			End If
			
			If TDUIMain.IsGadgetActive(Self) = True
				
				If gSearch = True
					
					If dui_MouseIn(gX + _x + (gW - gSearchImage.width - 7), gY + _y, gSearchImage.width + 7, gSearchImage.height + 7) = True
						
						Deactivate()
						
					Else
						
						If gState <> IDLE_STATE Then TDUIMain.SetCursor(dui_CURSOR_TEXTOVER)
						
					End If
					
				Else
					
					If gState <> IDLE_STATE Then TDUIMain.SetCursor(dui_CURSOR_TEXTOVER)
					
				End If
				
			End If
			
		End Method
		
		Rem
			bbdoc: Send a key to the textfield for input.
			returns: Nothing.
			about: @_type can be either<br>
			0 - An action key (KEY_ constants, things like cursor left, right; backspace and delete, enter and escape)<br>
			1 - An ascii character key (e.g. a value from GetChar - this does not convert from KEY_ constants to actual input)
		End Rem
		Method SendKey(_key:Int, _type:Int = 0)
			
			'If gMode = INPUT_MODE
				
				If _type = 0
					
					Select _key
						Case KEY_LEFT SetCursorPosition(gCursorPos - 1)
						Case KEY_RIGHT SetCursorPosition(gCursorPos + 1)
						Case KEY_END MoveCursorToEnd()
						Case KEY_HOME MoveCursorToStart()
						
						'Case KEY_TAB InsertTextAtIndex("~t", GetCursorPosition(), True)
						
						Case KEY_BACKSPACE TextBackspace()
						Case KEY_DELETE TextDelete()
						Case KEY_RETURN, KEY_ESCAPE
							If gMode = INPUT_MODE
								
								DeActivate()
								
							End If
							
					End Select
					
				Else If _type = 1
					
					If _key > 31
						
						InsertTextAtIndex(Chr(_key), GetCursorPosition(), True)
						
					End If
					
				End If
				
			'End If
			
		End Method
		
		Rem
			bbdoc: Refresh the textfield.
			returns: Nothing.
		End Rem
		Method Refresh()
			Local pos:Int
			
			' Set the cursor's position relative to the text
			gCX = dui_TFont.GetFontStringWidth((GetText()[0..GetCursorPosition()]), GetFont())
			If GetCursorPosition() = 0 Then gCX:+1
			
			' Also update the starting location of the text so that gCX is in view
			pos = gCX + gTX
			
			' gCX is too far right
			If gSearch = True
				
				If pos + gSearchImage.width > (gW - gSearchImage.width - 5)
					gTX = (gW - gSearchImage.width - 5) - gCX
					gTX:-10 ' EXPERIMENTAL!!
					'gTX:-gSearchImage.width - 4
				End If
				
			Else
				
				If pos > (gW - 10)
					gTX = (gW - 10) - gCX
					gTX:-10 ' EXPERIMENTAL!!
				End If
				
			End If
			
			' gCX is too far left
			If pos < 10
				If GetCursorPosition() = 0
					gTX = 0
				Else
					gTX = -gCX
					gTX:+10 ' EXPERIMENTAL!!
				End If
			End If
			
			If gMode = INPUT_MODE
				
				gcursoron = True
				gBlinkTimer.Reset(300)
				
			End If
			
		End Method
		
		Rem
			bbdoc: Set the textfield's text.
			returns: Nothing.
		End Rem
		Method SetText(_text:String, _cursorend:Int = True)
			
			gText = _text
			If _cursorend = True Then MoveCursorToEnd()
			
		End Method
		
		Rem
			bbdoc: Clear the textfield.
			returns: Nothing.
		End Rem
		Method Clear()
			
			SetText("", True)
			
		End Method
		
		Rem
			bbdoc: Get the text in the textfield.
			returns: The text in the textfield.
		End Rem
		Method GetText:String()
		
			Return gText
			
		End Method
		
		Rem
			bbdoc: Insert text into the textfield at an index (not zero-based).
			returns: Nothing.
		End Rem
		Method InsertTextAtIndex(_text:String, _index:Int, _setpos:Int = True)
			
			SetText(gText[0.._index] + _text + gText[_index..GetCharCount()], False)
			If _setpos = True Then SetCursorPosition(_index + _text.Length)
			
		End Method
		
		Rem
			bbdoc: Make a text-editing action: Backspace.
			returns: Nothing.
		End Rem
		Method TextBackspace()
			
			If GetCursorPosition() > 0
				
				RemoveText(GetCursorPosition() - 1, GetCursorPosition())
				
			End If
			
		End Method
		
		Rem
			bbdoc: Make a text-editing action: Delete a character.
			returns: Nothing.
		End Rem
		Method TextDelete()
			
			If GetCursorPosition() < GetCharCount()
				
				RemoveText(GetCursorPosition(), GetCursorPosition() + 1)
				
			End If
			
		End Method
		
		Rem
			bbdoc: Make a text-editing action: Remove a section of text.
			returns: Nothing.
		End Rem
		Method RemoveText(_start:Int, _end:Int)
			Local txleft:String, txright:String
			
			_start = ClampPosition(_start, False)
			_end = ClampPosition(_end, False)
			
			' Get left and right portions of remaining text
			txleft = gText[0.._start]
			txright = gText[_end..GetCharCount()]
			
			' Piece them together
			gText = txleft + txright
			
			' Update the cursor position
			SetCursorPosition(_start)
			
		End Method
		
		Rem
			bbdoc: Move the cursor to the end (last position) of the textfield.
			returns: Nothing.
		End Rem
		Method MoveCursorToEnd()
			
			SetCursorPosition(GetCharCount())
			
		End Method
		
		Rem
			bbdoc: Move the cursor to the start (first position) of the textfield.
			returns: Nothing.
		End Rem
		Method MoveCursorToStart()
			
			SetCursorPosition(0)
			
		End Method
		
		Rem
			bbdoc: Move the text cursor relative to it's position.
			returns: Nothing.
			about: Positions are clamped.<br>
			e.g. textfield.MoveCursor(-1); Will move the cursor back one.
		End Rem
		Method MoveCursor(_amount:Int)
			
			SetCursorPosition(GetCursorPosition() + _amount)
			
		End Method
		
		Rem
			bbdoc: Set the text cursor position.
			returns: Nothing.
			about: @_cursor will be clamped to the size of the text in the textfield if it is invalid.
		End Rem
		Method SetCursorPosition(_cursor:Int)
			
			gCursorPos = _cursor
			gCursorPos = ClampPosition(GetCursorPosition(), False)
			
			Refresh()
			
		End Method
		
		Rem
			bbdoc: Set the cursor position by an x screen position.
			returns: Nothing.
		End Rem
		Method SetCursorPositionByX(_x:Int)
			Local xmouse:Int, cutout:String, scursor:Int
			Local leftdist:Int, rightdist:Int
			
			' Set up relative mouse position
			xmouse = _x - (gX + 3)
			
			' Check to see if the mouse is positioned somewhere in the text
			If xmouse < dui_TFont.GetFontStringWidth(gText, gFont)
				
				' Step through string until the mouse is on the left of the string width
				scursor = -1
				
				Repeat
					scursor:+1
					cutout = gText[0..scursor]
				Until xMouse < dui_TFont.GetFontStringWidth(cutout, gFont)
				
				gCursorPos = scursor
				
				' At this point, you can narrow it down based on distance.
				If gCursorPos > 0
					
					' Get distance from mouse to the text
					leftdist = dui_TFont.GetFontStringWidth(cutout, gFont) - xMouse
					rightdist = xMouse - dui_TFont.GetFontStringWidth(gText[0..(scursor - 1)], gFont)
					
					If leftdist <= rightdist
						' Set cursor at this point
						gCursorPos = scursor
						
					Else
						' Set cursor at previous location
						gCursorPos = scursor - 1
						
					End If
					
				End If
				
			Else
				
				gCursorPos = GetCharCount()
				
			End If
			
			' Just to make sure we aren't at an invalid position
			SetCursorPosition(GetCursorPosition())
			
			' Update the cursor's exact location
			Refresh()
			
		End Method
		
		Rem
			bbdoc: Get the cursor position.
			returns: The position of the textfield cursor.
		End Rem
		Method GetCursorPosition:Int()
			
			Return gCursorPos
			
		End Method
		
		Rem
			bbdoc: Get the number of characters in the textfield.
			returns: The number of characters in the textfield.
		End Rem
		Method GetCharCount:Int()
			
			Return GetText().Length
			
		End Method
		
		Rem
			bbdoc: Clamp a cursor position to the size of the text in the textfield.
			returns: The clamped value.
		End Rem
		Method ClampPosition:Int(_value:Int, _zerobased:Int = False)
			Local size:Int
			
			size = GetCharCount()
			If _zerobased = True Then size:-1
			
			Return IntMax(IntMin(_value, 0), size)
			
		End Method
		
		Rem
			bbdoc: Deactivate the textfield.
			returns: Nothing.
		End Rem
		Method Deactivate()
			
			TDUIMain.ClearActiveGadget()
			gState = IDLE_STATE
			gMode = IDLE_MODE
			
			' Check to see if text field forms part of search box
			Local search:dui_TSearchPanel = dui_TSearchPanel(gParent)
			If search <> Null
				
				'New dui_TEvent.Create(dui_EVENT_GADGETACTION, search.gSearchBox, 0, 0, 0, GetText())
				search.gSearchBox.Search(GetText())
				
			Else
				
				New dui_TEvent.Create(dui_EVENT_GADGETACTION, Self, 0, 0, 0, GetText())
				
			End If
			
		End Method
		
		Rem
			bbdoc: Set the milliseconds before a blink of the text cursor occurs.
			returns: Nothing.
		End Rem
		Function SetBlinkTime(_blinktime:Int = 500)
			
			gBlinkTimer.SetLength(_blinktime)
			
		End Function
		
		Rem
			bbdoc: Get the milliseconds before a blink of the text cursor occurs.
			returns: The milliseconds between cursor blinks.
		End Rem
		Function GetBlinkTime:Int()
			
			Return gBlinkTimer.GetLength()
			
		End Function
		
		Rem
			bbdoc: Refresh the skin for the textfield.
			returns: Nothing.
		End Rem
		Function RefreshSkin()
			Local index:Int, x:Int, y:Int, map:Int
			Local image:TImage, mainmap:TPixmap, pixmap:TPixmap[9]
			
			image = LoadImage(TDUIMain.SkinUrl + "/graphics/textfield.png")
			mainmap = LockImage(image)
			
			For Local index:Int = 0 To 8
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
			
			gSearchImage = LoadImage(TDUIMain.SkinUrl + "/graphics/search.png")
			
		End Function
		
End Type






























