
' 
' scrollbox.bmx (Contains: dui_TScrollBox, )
' 
' 

Rem
	bbdoc: The dui scrollbox gadget type.
End Rem
Type dui_TScrollBox Extends dui_TGadget
	
	Const V_SCROLL:Int = 1				'Vertical scroll only
	Const H_SCROLL:Int = 2				'Horizontal scroll only
	Const B_SCROLL:Int = 3				'Both scroll

	Field gOX:Int							'x origin point, used to give the impression of scrolling
	Field gOY:Int							'y origin point
	Field gBackground:Int = 1			'draw a border around scrollbox area
	Field gHScroll:dui_TScrollBar = Null	'horizontal scrollbar
	Field gVScroll:dui_TScrollBar = Null	'vertical scrollbar
		
		Rem
			bbdoc: Create a scrollbox gadget.
			returns: The created scrollbox.
		End Rem
		Method Create:dui_TScrollBox(_name:String, _x:Float, _y:Float, _w:Float, _h:Float, _scroll:Int, _mw:Int, _mh:Int, _parent:dui_TGadget)
				
			PopulateGadget(_name, _x, _y, _w, _h, _parent)
			
			Select _scroll
				Case V_SCROLL
					' Create the vertical scrollbar
					gVScroll = New dui_TScrollBar.Create(_name + ":VScroll", (_x + _w) - 15, _y, _h, 0, _mh, _h - 18, _parent)
					' Reduce the width of the scroll box
					gW = _w - 18
					
				Case H_SCROLL
					' Create the horizontal scrollbar
					gHScroll = New dui_TScrollBar.Create(_name + ":HScroll", _x, (_y + _h) - 15, _w, 1, _mw, _w - 18, _parent)
					' Reduce the height of the scroll box
					gH = _h - 18
					
				Case B_SCROLL
					' Create both scrollbars
					gVScroll = New dui_TScrollBar.Create(_name + ":VScroll", (_x + _w) - 15, _y, _h - 15, 0, _mh, _h - 18, _parent)
					gHScroll = New dui_TScrollBar.Create(_name + ":HScroll", _x, (_y + _h) - 15, _w - 15, 1, _mw, _w - 18, _parent)
					
					' Reduce the dimensions of the scroll box
					gW = _w - 18
					gH = _h - 18
					
			End Select
			
			Return Self
			
		End Method
		
		Rem
			bbdoc: Render the scrollbox.
			returns: Nothing.
		End Rem
		Method Render(_x:Float, _y:Float)
			Local rx:Float, ry:Float
			
			If IsVisible() = True
				
				'set up rendering locations
				rx = gX + _x
				ry = gY + _y
				
				SetDrawingState()
				Select gBackground
					Case 1
						
						' Draw box
						'DrawLine(rx - 1, ry - 1, rx + gW + 1, ry - 1)
						'DrawLine(rx + gW + 1, ry, rx + gW + 1, ry + gH + 1)
						'DrawLine(rx + gW + 1, ry + gH + 1, rx - 1, ry + gH + 1)
						'DrawLine(rx - 1, ry + gH, rx - 1, ry)
						dui_DrawLineRect(rx - 1, ry - 1, gW + 1, gH + 1)
						
					Case 2
						
						' Draw box
						DrawRect(rx - 1, ry - 1, gW + 2, gH + 2)
						
				End Select
				
				'draw children
				TDrawState.Push(False, False, False, False, False, True, False, False)
						
				dui_SetViewport(rx + BOUNDARY, ry + BOUNDARY, gW - DOUBLEBOUNDARY, gH - DOUBLEBOUNDARY)
				
				For Local child:dui_TGadget = EachIn gChildren
					
					child.Render(rx + gOX, ry + gOY)
					
				Next
				
				TDrawState.Pop(False, False, False, False, False, True, False, False)
				
			End If
			
		End Method
		
		Rem
			bbdoc: Update the scrollbox.
			returns: Nothing.
		End Rem
		Method Update(_x:Int, _y:Int)
			
			If gState = MOUSEDOWN_STATE
				
				If MouseDown(1)
					UpdateMouseDown(_x, _y)
					Return
				End If
				
				If Not MouseDown(1)
					UpdateMouseRelease(_x, _y)
					Return
				End If
				
			End If
			
			If IsVisible() = True
				
				For Local child:dui_TGadget = EachIn New TListReversed.Create(gChildren)
					
					child.Update(gX + _x + gOX, gY + _y + gOY)
					
				Next
				
				If gVScroll Then gOY = 0 - gVScroll.GetValue()
				If gHScroll Then gOX = 0 - gHScroll.GetValue()
				
				gState = IDLE_STATE
				
				If TDUIMain.IsGadgetActive(Self) = True
					
					If dui_MouseIn(gX + _x, gY + _y, gW, gH)
						
						UpdateMouseOver(_x, _y)
						
						If MouseDown(1) Then UpdateMouseDown(_x, _y)
						
					End If
					
				End If
				
			End If
			
		End Method
		
		Rem
			bbdoc: Set the background on or off for the scrollbox.
			returns: Nothing.
		End Rem
		Method SetBackground(_background:Int)
			
			gBackground = _background
			
		End Method
		
		Rem
			bbdoc: Set the colour of one of the scrollbars.
			returns: Nothing.
		End Rem
		Method SetScrollColour(_r:Int, _g:Int, _b:Int, _which:Int)
			
			If _which = 0
				gVScroll.SetColour(_r, _g, _b)
			Else
				gHScroll.SetColour(_r, _g, _b)
			End If
			
		End Method
		
		Rem
			bbdoc: Set the colour of one of the scrollbars using a hex string (e.g. "FF0000")
			returns: Nothing.
		End Rem
		Method HexScrollColour(_color:String, _which:Int)
			
			If _which = 0
				gVScroll.HexColour(_color)
			Else
				gHScroll.HexColour(_color)
			End If
			
		End Method
		
		Rem
			bbdoc: Set the alpha of one of the scrollbars.
			returns: Nothing.
		End Rem
		Method SetScrollAlpha(_alpha:Float, _which:Int)
			
			If _which = 0
				gVScroll.SetAlpha(_alpha)
			Else
				gHScroll.SetAlpha(_alpha)
			End If
			
		End Method
		
End Type






































