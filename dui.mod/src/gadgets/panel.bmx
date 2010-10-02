
Rem
Copyright (c) 2010 Tim Howard

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
End Rem

Rem
	bbdoc: duct ui panel gadget.
End Rem
Type duiPanel Extends duiGadget
	
	Global m_renderer:duiGenericRenderer = New duiGenericRenderer
	
	Field m_border:Int = True
	
	Field m_movable:Int
	Field m_moving:Int = False
	Field m_movex:Float, m_movey:Float
	
	Rem
		bbdoc: Create a panel.
		returns: Itself.
		about: @parent can be either a duiGadget or a duiScreen (in which case it will be added as a child of the screen).
	End Rem
	Method Create:duiPanel(name:String, x:Float, y:Float, w:Float, h:Float, movable:Int = True, parent:Object = Null)
		If duiScreen(parent)
			duiScreen(parent).AddGadget(Self)
		End If
		_Init(name, x, y, w, h, duiGadget(parent), False)
		SetMovable(movable)
		Return Self
	End Method
	
'#region Render & update methods
	
	Rem
		bbdoc: Render the panel and its children.
		returns: Nothing.
	End Rem
	Method Render(x:Float, y:Float)
		If IsVisible()
			Local relx:Float = m_x + x
			Local rely:Float = m_y + y
			BindRenderingState()
			If m_border
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
		If IsVisible()
			If duiMain.IsPanelFocused(Self) And dui_MouseIn(m_x + x, m_y + y, m_width, m_height)
				duiMain.SetFocusedPanel(Self)
				For Local child:duiGadget = EachIn New TListReversed.Create(m_children)
					child.Update(m_x + x, m_y + y)
				Next
			End If
			m_state = STATE_IDLE
			If duiMain.IsGadgetActive(Self)
				If dui_MouseIn(m_x + x, m_y + y, m_width, m_height)
					UpdateMouseOver(MouseX(), MouseY())
					If MouseDown(1)
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
		'duiMain.SetCursor(dui_CURSOR_MOUSEOVER)
		Super.UpdateMouseOver(x, y)
	End Method
	
	Rem
		bbdoc: Update the MouseDown state.
		returns: Nothing.
	End Rem
	Method UpdateMouseDown(x:Int, y:Int)
		duiMain.SetCursor(dui_CURSOR_MOUSEDOWN)
		Super.UpdateMouseDown(x, y)
		'New duiEvent.Create(dui_EVENT_GADGETACTION, Self, 0, MouseX() - m_x, MouseY() - m_y, Null)
		If IsMovable()
			If Not m_moving
				m_movex = x - m_x
				m_movey = y - m_y
				m_moving = True
				New duiEvent.Create(dui_EVENT_GADGETACTION, Self, 0, x - m_x, y - m_y, Null)
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
		If m_moving
			m_moving = False
		End If
		New duiEvent.Create(dui_EVENT_GADGETSELECT, Self, 0, x - m_x, y - m_y, Null)
	End Method
	
'#end region Render & update methods
	
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
	
'#end region Field accessors
	
	Rem
		bbdoc: Refresh the panel skin.
		returns: Nothing.
	End Rem
	Function RefreshSkin(theme:duiTheme)
		m_renderer.Create(theme, "panel")
	End Function
	
End Type

