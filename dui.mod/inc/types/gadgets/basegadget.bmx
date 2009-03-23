
' 
' basegadget.bmx (Contains: _dui_TBaseGadget, dui_TGadget, )
' 
' 

Rem
	bbdoc: The dui gadget Type.
End Rem
Type dui_TGadget
	
	Const IDLE_STATE:Int = 0			'Gadget is idle
	Const MOUSEOVER_STATE:Int = 1		'Mouse is over the gadget
	Const MOUSEDOWN_STATE:Int = 2		'Mouse button is down
	Const MOUSERELEASE_STATE:Int = 3	'Mouse button is released
	
	Const BOUNDARY:Int = 2
	Const DOUBLEBOUNDARY:Int = 4
	
	Global DefaultColour:Int[][] = [[255, 255, 255], [0, 0, 0], [255, 255, 255] ]
	Global DefaultTextColour:Int[][] = [[0, 0, 0], [255, 255, 255], [0, 0, 0] ]
	Global DefaultAlpha:Float[] = [1.0, 1.0, 1.0]
	Global DefaultTextAlpha:Float[] = [1.0, 1.0, 1.0]
	
	Field gName:String
	
	Field gX:Float, gY:Float
	Field gW:Float, gH:Float
	
	Field gParent:dui_TGadget
	Field gChildren:TList = New TList
	
	Field gColour:Int[] = [DefaultColour[0][0], DefaultColour[0][1], DefaultColour[0][2] ]
	Field gTextColour:Int[] = [DefaultTextColour[0][0], DefaultTextColour[0][1], DefaultTextColour[0][2] ]
	Field gAlpha:Float = DefaultAlpha[0]
	Field gTextAlpha:Float = DefaultTextAlpha[0]
	Field gFont:dui_TFont
	
	Field visible:Int = True
	Field gState:Int
	
		Rem
			bbdoc: Populate the gadget with base values.
			returns: Nothing.
		End Rem
		Method PopulateGadget(_name:String, _x:Float, _y:Float, _w:Float, _h:Float, _parent:dui_TGadget, _dorefresh:Int = True)
			
			SetName(_name)
			SetPosition(_x, _y)
			SetDimensions(_w, _h, _dorefresh)
			
			SetFont(dui_TFont.default_font, _dorefresh)
			
			SetParent(_parent)
			
		End Method
		
		Rem
			bbdoc: Render the gadget.
			returns: Nothing.
		End Rem
		Method Render(_x:Float, _y:Float)
			
			TDrawState.Push()
			
			dui_SetViewport(gX + _x + BOUNDARY, gY + _y + BOUNDARY, gW - DOUBLEBOUNDARY, gH - DOUBLEBOUNDARY)
			
			For Local child:dui_TGadget = EachIn gChildren
				
				child.Render(gX + _x, gY + _y)
				
			Next
			
			TDrawState.Pop()
			
		End Method
		
		Rem
			bbdoc: Update the gadget.
			returns: Nothing.
		End Rem
		Method Update(_x:Int, _y:Int)
			
			' Check for existing mouse down states
			If gState = MOUSEDOWN_STATE
				
				If MouseDown(1) = True
					UpdateMouseDown(_x, _y)
					Return
				End If
				
				If MouseDown(1) = False
					UpdateMouseRelease(_x, _y)
					Return
				End If
				
			End If
			
			If IsVisible() = True
			
				' Always update child gadgets every frame
				For Local child:dui_TGadget = EachIn New TListReversed.Create(gChildren)
					
					child.Update(gX + _x, gY + _y)
					
				Next
				
				' Set to the idle state
				gState = IDLE_STATE
				
				' Check for other active gadgets
				If TDUIMain.IsGadgetActive(Self) = True
				
					' Test for mouse over the gadget
					If dui_MouseIn(gX + _x, gY + _y, gW, gH) = True
						
						UpdateMouseOver(_x, _y)
						
						' Check for button press
						If MouseDown(1) Then UpdateMouseDown(_x, _y)
						
					End If
					
				End If
				
			End If
			
		End Method
		
		Rem
			bbdoc: Update the MouseOver state.
			returns: Nothing.
		End Rem
		Method UpdateMouseOver(_x:Int, _y:Int)
			
			gState = MOUSEOVER_STATE
			
			' Attempt to set it as the focus gadget for mouseover
			'TDUIMain.SetFocusedGadget(Self, MouseX() - (gX + _x), MouseY() - (gY + _y))
			TDUIMain.SetFocusedGadget(Self, _x - GetAbsoluteX(), _y - GetAbsoluteY())
			
		End Method
		
		Rem
			bbdoc: Update the MouseDown state.
			returns: Nothing.
		End Rem
		Method UpdateMouseDown(_x:Int, _y:Int)
			
			TDUIMain.SetActiveGadget(Self)
			gState = MOUSEDOWN_STATE
			
		End Method
		
		Rem
			bbdoc: Update the MouseRelease state.
			returns: Nothing.
		End Rem
		Method UpdateMouseRelease(_x:Int, _y:Int)
			
			TDUIMain.ClearActiveGadget()
			gState = MOUSERELEASE_STATE
			
		End Method
		
		Rem
			bbdoc: Send a key code for interpretation to the gadget (experimental).
			returns: Nothing.
		End Rem
		Method SendKey(_key:Int, _type:Int = 0)
			
			' Base gadget does nothing for the key
			
		End Method
		
		Rem
			bbdoc: Set the standard drawing state.
			returns: Nothing.
			about: This will set the drawing color and alpha to the gadget's color and alpha. See also #SetTextDrawingState.
			@_index is used for some gadgets.
		End Rem
		Method SetDrawingState(_index:Int = 0)
			
			'brl.max2d.SetBlend(ALPHABLEND)
			brl.max2d.SetColor(gColour[0], gColour[1], gColour[2])
			brl.max2d.SetAlpha(gAlpha)
			
		End Method
		
		Rem
			bbdoc: Set the text drawing state.
			returns: Nothing.
			about: This will set the drawing color and alpha to the gadget's text color and alpha. See also #SetDrawingState.
			@_index is used for some gadgets.
		End Rem
		Method SetTextDrawingState(_setfont:Int = True, _index:Int = 0)
			
			brl.max2d.SetColor(gTextColour[0], gTextColour[1], gTextColour[2])
			brl.max2d.SetAlpha(gTextAlpha)
			If _setfont = True Then dui_TFont.SetDrawingFont(gFont)
			
		End Method
		
		Rem
			bbdoc: Get the absolute x position of the gadget.
			returns: The absolute x position of the gadget.
		End Rem
		Method GetAbsoluteX:Float()
			
			If gParent <> Null
				Return gX + gParent.GetAbsoluteX()
			Else
				Return gX
			End If
			
		End Method
		
		Rem
			bbdoc: Get the absolute y position of the gadget.
			returns: The absolute y position of the gadget.
		End Rem
		Method GetAbsoluteY:Float()
			
			If gParent <> Null
				Return gY + gParent.GetAbsoluteY()
			Else
				Return gY
			End If
			
		End Method
		
		Rem
			bbdoc: Set the name of the gadget.
			returns: Nothing.
		End Rem
		Method SetName(_name:String)
			
			gName = _name
			
		End Method
		
		Rem
			bbdoc: Get the name of the gadget.
			returns: The gadget's name.
		End Rem
		Method GetName:String()
			
			Return gName
			
		End Method
		
		Rem
			bbdoc: Set the position of the gadget.
			returns: Nothing.
			about: The position is relative to the parent of the gadget.
		End Rem
		Method SetPosition(_x:Float, _y:Float)
			
			gX = _x
			gY = _y
			
		End Method
		
		Rem
			bbdoc: Move the gadget.
			returns: Nothing.
			about: Moves the gadget to a new position relative to its current position.
		End Rem
		Method MoveGadget(_xoff:Float, _yoff:Float)
			
			SetPosition(gX + _xoff, gY + _yoff)
			
		End Method
		
		Rem
			bbdoc: Set the dimensions of the gadget
			returns: Nothing.
			about: This refreshes the gadget (positions, text, etc).
		End Rem
		Method SetDimensions(_w:Float, _h:Float, _dorefresh:Int = True)
			
			gW = _w
			gH = _h
			If _dorefresh = True Then Refresh()
			
		End Method
		
		'Rem
		'	bbdoc: Change the dimensions on an offset.
		'	returns: Nothing.
		'	about: Sets the dimensions, relative to its current dimensions. The dimension version of #MoveGadget.
		'End Rem
		'Method ChangeDimensions(woff:Int, hoff:Int)
		'	
		'	gW = gW + woff
		'	gH = gH + hoff
		'	Refresh()
		'	
		'End Method
		
		Rem
			bbdoc: Set the gadget's font
			returns: Nothing.
		End Rem
		Method SetFont(_font:dui_TFont, _dorefresh:Int = True)
			
			gFont = _font
			If _dorefresh = True Then Refresh()
			
		End Method
		
		Rem
			bbdoc: Get the gadget's font.
			returns: The gadget's font.
		End Rem
		Method GetFont:dui_TFont()
			
			'If gFont = Null
			'	Return dui_TFont.default_font
			'Else
				Return gFont
			'End If
			
		End Method
		
		Rem
			bbdoc: Set the gadget's parent.
			returns: Nothing.
		End Rem
		Method SetParent(_parent:dui_TGadget)
			
			If _parent <> Null
				
				' AddChild sets the parent for this gadget
				_parent.AddChild(Self)
				
			End If
			
		End Method
		
		Rem
			bbdoc: Get the gadget's parent.
			returns: The gadget's parent.
		End Rem
		Method GetParent:dui_TGadget()
			
			Return gParent
			
		End Method
		
		Rem
			bbdoc: Set the colour of the gadget.
			returns: Nothing.
			about: @_index is used in some gadgets.
		End Rem
		Method SetColour(_r:Int, _g:Int, _b:Int, _index:Int = 0)
			
			gColour = [_r, _g, _b]
			
		End Method
		
		Rem
			bbdoc: Set the colour of the gadget using a hexidecimal string.
			returns: Nothing.
		End Rem
		Method HexColour(_col:String, _index:Int = 0)
			
			Local r:Int, g:Int, b:Int
			dui_HexColour(_col, r, g, b)
			SetColour(r, g, b, _index)
			
		End Method
		
		Rem
			bbdoc: Set the text colour.
			returns: Nothing.
		End Rem
		Method SetTextColour(_r:Int, _g:Int, _b:Int, _index:Int = 0)
			
			gTextColour = [_r, _g, _b]
			
		End Method
		
		Rem
			bbdoc: Set the text colour using a hexadecimal string.
			returns: Nothing.
		End Rem
		Method HexTextColour(_col:String, _index:Int = 0)
			
			Local r:Int, g:Int, b:Int
			dui_HexColour(_col, r, g, b)
			SetTextColour(r, g, b, _index)
			
		End Method
		
		Rem
			bbdoc: Set the gadget's alpha.
			returns: Nothing.
		End Rem
		Method SetAlpha(_a:Float, _index:Int = 0)
			
			gAlpha = _a
			
		End Method
		
		Rem
			bbdoc: Get the gadget's alpha.
			returns: The gadget's alpha value.
		End Rem
		Method GetAlpha:Float(_index:Int = 0)
			
			Return gAlpha
			
		End Method
		
		Rem
			bbdoc: Set the gadget's text alpha.
			returns: Nothing.
		End Rem
		Method SetTextAlpha(_a:Float, _index:Int = 0)
			
			gTextAlpha = _a
			
		End Method
		
		Rem
			bbdoc: Get the gadget's text alpha.
			returns: The gadget's text alpha value.
		End Rem
		Method GetTextAlpha:Float(_index:Int = 0)
			
			Return gTextAlpha
			
		End Method
		
		Rem
			bbdoc: Add a child to the gadget.
			returns: Nothing.
		End Rem
		Method AddChild(_gadget:dui_TGadget)
			
			If _gadget <> Null
				gChildren.AddLast(_gadget)
				_gadget.gParent = Self
			End If
			
		End Method
		
		Rem
			bbdoc: Set the gadget visibility.
			returns: Nothing.
			about: @_visible can be True (shown) or False (hidden).
		End Rem
		Method SetVisible(_visible:Int)
			
			' Invert _visible
			visible = _visible
			
		End Method
		
		Rem
			bbdoc: Toggle gadget visibilty.
			returns: Nothing.
		End Rem
		Method ToggleVisibility()
			
			' SetVisible 
			SetVisible(visible~1)
			
		End Method
		
		Rem
			bbdoc: Hide the gadget.
			returns: Nothing.
			about: Neither this gadget nor its children will be drawn.
		End Rem
		Method Hide()
			
			SetVisible(False)
			
		End Method
		
		Rem
			bbdoc: Show the gadget and children.
			returns: Nothing.
			about: This gadget and its children will be drawn.
		End Rem
		Method Show()
			
			SetVisible(True)
			
		End Method
		
		Rem
			bbdoc: Check if the gadget is visible.
			returns: True if the gadget is visible, or False if it is not visible.
		End Rem
		Method IsVisible:Int()
			
			Return visible
			
		End Method
		
		Rem
			bbdoc: Retrieve a gadget by its name.
			returns: A dui_TGadget or Null if the gadget by the given name was not found.
		End Rem
		Method GetChildByName:dui_TGadget(_name:String)
			
			If _name <> Null
				
				_name = _name.ToLower()
				
				For Local _gadget:dui_TGadget = EachIn gChildren
					
					If _gadget.gName.ToLower() = _name Then Return _gadget
					
				Next
				
			End If
			
			Return Null
			
		End Method
		
		Rem
			bbdoc: Refresh the gadget.
			returns: Nothing.
		End Rem
		Method Refresh()
			
		End Method
		
End Type










