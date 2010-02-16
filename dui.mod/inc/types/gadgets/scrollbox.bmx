
Rem
	scrollbox.bmx (Contains: dui_ScrollBox, )
End Rem

Rem
	bbdoc: The dui scrollbox gadget type.
End Rem
Type dui_ScrollBox Extends dui_Gadget
	
	Const V_SCROLL:Int = 1				'Vertical scroll only
	Const H_SCROLL:Int = 2				'Horizontal scroll only
	Const B_SCROLL:Int = 3				'Both scroll
	
	Field m_oldx:Int					'x origin point, used to give the impression of scrolling
	Field m_oldy:Int					'y origin point
	Field m_background:Int = 1			'draw a border around scrollbox area
	Field m_hscroll:dui_ScrollBar		'horizontal scrollbar
	Field m_vscroll:dui_ScrollBar		'vertical scrollbar
	
	Rem
		bbdoc: Create a scrollbox gadget.
		returns: The created scrollbox.
	End Rem
	Method Create:dui_ScrollBox(name:String, x:Float, y:Float, w:Float, h:Float, _scroll:Int, _mw:Int, _mh:Int, parent:dui_Gadget)
		_Init(name, x, y, w, h, parent, False)
		Select _scroll
			Case V_SCROLL
				' Create the vertical scrollbar
				m_vscroll = New dui_ScrollBar.Create(name + ":VScroll", (x + w) - 15, y, h, 0, _mh, h - 18, parent)
				' Reduce the width of the scroll box
				m_width = w - 18
			Case H_SCROLL
				' Create the horizontal scrollbar
				m_hscroll = New dui_ScrollBar.Create(name + ":HScroll", x, (y + h) - 15, w, 1, _mw, w - 18, parent)
				' Reduce the height of the scroll box
				m_height = h - 18
			Case B_SCROLL
				' Create both scrollbars
				m_vscroll = New dui_ScrollBar.Create(name + ":VScroll", (x + w) - 15, y, h - 15, 0, _mh, h - 18, parent)
				m_hscroll = New dui_ScrollBar.Create(name + ":HScroll", x, (y + h) - 15, w - 15, 1, _mw, w - 18, parent)
				' Reduce the dimensions of the scroll box
				m_width = w - 18
				m_height = h - 18
		End Select
		Return Self
	End Method
	
'#region Render & update methods
	
	Rem
		bbdoc: Render the scrollbox.
		returns: Nothing.
	End Rem
	Method Render(x:Float, y:Float)
		Local relx:Float, rely:Float
		
		If IsVisible() = True
			relx = m_x + x
			rely = m_y + y
			
			BindDrawingState()
			TProtogPrimitives.DrawRectangleToSize(relx - 1, rely - 1, m_width + 1, m_height + 1, m_background)
			
			TProtogDrawState.Push(False, False, False, True, False, False)
			dui_SetViewport(relx + BOUNDARY, rely + BOUNDARY, m_width - DOUBLEBOUNDARY, m_height - DOUBLEBOUNDARY)
			
			For Local child:dui_Gadget = EachIn m_children
				child.Render(relx + m_oldx, rely + m_oldy)
			Next
			
			TProtogDrawState.Pop(False, False, False, True, False, False)
		End If
	End Method
	
	Rem
		bbdoc: Update the scrollbox.
		returns: Nothing.
	End Rem
	Method Update(x:Int, y:Int)
		If m_state = STATE_MOUSEDOWN
			If MouseDown(1)
				UpdateMouseDown(x, y)
				Return
			End If
			If Not MouseDown(1)
				UpdateMouseRelease(x, y)
				Return
			End If
		End If
		
		If IsVisible() = True
			For Local child:dui_Gadget = EachIn New TListReversed.Create(m_children)
				child.Update(m_x + x + m_oldx, m_y + y + m_oldy)
			Next
			
			If m_vscroll Then m_oldy = -m_vscroll.GetValue()
			If m_hscroll Then m_oldx = -m_hscroll.GetValue()
			
			m_state = STATE_IDLE
			If TDUIMain.IsGadgetActive(Self) = True
				If dui_MouseIn(m_x + x, m_y + y, m_width, m_height)
					UpdateMouseOver(x, y)
					If MouseDown(1) Then UpdateMouseDown(x, y)
				End If
			End If
		End If
	End Method
	
'#end region (Render & update methods)
	
'#region Field accessors
	
	Rem
		bbdoc: Set the background on or off for the scrollbox.
		returns: Nothing.
	End Rem
	Method SetBackground(background:Int)
		m_background = background
	End Method
	
'#end region (Field accessors)
	
End Type

