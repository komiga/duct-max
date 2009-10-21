
Rem
	panel.bmx (Contains: dui_Panel, )
End Rem

Rem
	bbdoc: The dui panel gadget type.
End Rem
Type dui_Panel Extends dui_Gadget
	
	Global m_renderer:dui_GenericRenderer = New dui_GenericRenderer
	
	Field m_border:Int = True
	
	Field m_movable:Int
	Field m_moving:Int = False
	Field m_movex:Float, m_movey:Float
	
	Rem
		bbdoc: Create a panel.
		returns: The new panel (itself).
		about: @parent can be either a dui_Gadget or a dui_Screen (in which case it will be added as a child of the screen).
	End Rem
	Method Create:dui_Panel(name:String, x:Float, y:Float, w:Float, h:Float, movable:Int = True, parent:Object = Null)
		If dui_Screen(parent)
			dui_Screen(parent).AddGadget(Self)
		End If
		
		_Init(name, x, y, w, h, dui_Gadget(parent), False)
		SetMovable(movable)
		Return Self
	End Method
	
'#region Render & update methods
	
	Rem
		bbdoc: Render the panel and its children.
		returns: Nothing.
	End Rem
	Method Render(x:Float, y:Float)
		Local relx:Float, rely:Float
		
		If IsVisible() = True
			relx = m_x + x
			rely = m_y + y
			
			BindDrawingState()
			If m_border = True
				m_renderer.RenderCells(relx, rely, Self)
			Else
				m_renderer.RenderCell(4, relx, rely, Self)
			End If
			Super.Render(x, y)
		End If
	End Method
	
	Rem
		bbdoc: Update the panel and its children
		returns: Nothing.
	End Rem
	Method Update(x:Int, y:Int)
		If m_state = STATE_MOUSEDOWN
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
			If TDUIMain.IsPanelFocused(Self) = True And dui_MouseIn(m_x + x, m_y + y, m_width, m_height) = True
				TDUIMain.SetFocusedPanel(Self)
				For Local child:dui_Gadget = EachIn New TListReversed.Create(m_children)
					child.Update(m_x + x, m_y + y)
				Next
			End If
			
			m_state = STATE_IDLE
			If TDUIMain.IsGadgetActive(Self) = True
				If dui_MouseIn(m_x + x, m_y + y, m_width, m_height)
					UpdateMouseOver(MouseX(), MouseY())
					If MouseDown(1) = True
						UpdateMouseDown(MouseX(), MouseY())
					End If
				End If
			End If
		End If
	End Method
	
	Rem
		bbdoc: Update the MouseOver state.
		returns: Nothing.
	End Rem
	Method UpdateMouseOver(x:Int, y:Int)
		'TDUIMain.SetCursor(dui_CURSOR_MOUSEOVER)
		Super.UpdateMouseOver(x, y)
	End Method
	
	Rem
		bbdoc: Update the MouseDown state.
		returns: Nothing.
	End Rem
	Method UpdateMouseDown(x:Int, y:Int)
		TDUIMain.SetCursor(dui_CURSOR_MOUSEDOWN)
		Super.UpdateMouseDown(x, y)
		
		'New dui_Event.Create(dui_EVENT_GADGETACTION, Self, 0, MouseX() - m_x, MouseY() - m_y, Null)
		If IsMovable() = True
			If m_moving = False
				m_movex = x - m_x
				m_movey = y - m_y
				m_moving = True
				New dui_Event.Create(dui_EVENT_GADGETACTION, Self, 0, x - m_x, y - m_y, Null)
			Else
				m_x = x - m_movex
				m_y = y - m_movey
			End If
		End If
	End Method
	
	Rem
		bbdoc: Update the MouseRelease state.
		returns: Nothing.
	End Rem
	Method UpdateMouseRelease(x:Int, y:Int)
		Super.UpdateMouseRelease(x, y)
		If m_moving = True
			m_moving = False
		End If
		
		New dui_Event.Create(dui_EVENT_GADGETSELECT, Self, 0, x - m_x, y - m_y, Null)
	End Method
	
'#end region (Render & update methods)
	
'#region Field accessors
	
	Rem
		bbdoc: Turn On drawing for the panel's borders.
		returns: Nothing.
		about: See also #BorderOff.
	End Rem
	Method BorderOn()
		m_border = True
	End Method
	
	Rem
		bbdoc: Turn off drawing for the panel's borders.
		returns: Nothing.
		about: See also #BorderOn.
	End Rem
	Method BorderOff()
		m_border = False
	End Method
	
	Rem
		bbdoc: Set the movable state on or off.
		returns: Nothing.
	End Rem
	Method SetMovable(movable:Int)
		m_movable = movable
		m_moving = False
	End Method
	
	Rem
		bbdoc: Check if the panel is movable.
		returns: True if the panel is movable, or False if it is not.
	End Rem
	Method IsMovable:Int()
		Return m_movable
	End Method
	
'#end region (Field accessors)
	
	Rem
		bbdoc: Refresh the panel skin.
		returns: Nothing.
	End Rem
	Function RefreshSkin(theme:dui_Theme)
		m_renderer.Create(theme, "panel")
	End Function
	
End Type
















