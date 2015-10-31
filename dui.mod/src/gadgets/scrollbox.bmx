
Rem
Copyright (c) 2010 Coranna Howard <me@komiga.com>

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
	bbdoc: duct ui scrollbox gadget.
End Rem
Type duiScrollBox Extends duiGadget
	
	Const V_SCROLL:Int = 1				'Vertical scroll only
	Const H_SCROLL:Int = 2				'Horizontal scroll only
	Const B_SCROLL:Int = 3				'Both scroll
	
	Field m_oldx:Int					'x origin point, used to give the impression of scrolling
	Field m_oldy:Int					'y origin point
	Field m_background:Int = 1			'draw a border around scrollbox area
	Field m_hscroll:duiScrollBar		'horizontal scrollbar
	Field m_vscroll:duiScrollBar		'vertical scrollbar
	
	Rem
		bbdoc: Create a scrollbox gadget.
		returns: Itself.
	End Rem
	Method Create:duiScrollBox(name:String, x:Float, y:Float, w:Float, h:Float, scroll:Int, mw:Int, mh:Int, parent:duiGadget)
		_Init(name, x, y, w, h, parent, False)
		Select scroll
			Case V_SCROLL
				m_vscroll = New duiScrollBar.Create(name + ":VScroll", (x + w) - 15, y, h, 0, mh, h - 18, parent)
				m_width = w - 18
			Case H_SCROLL
				m_hscroll = New duiScrollBar.Create(name + ":HScroll", x, (y + h) - 15, w, 1, mw, w - 18, parent)
				m_height = h - 18
			Case B_SCROLL
				m_vscroll = New duiScrollBar.Create(name + ":VScroll", (x + w) - 15, y, h - 15, 0, mh, h - 18, parent)
				m_hscroll = New duiScrollBar.Create(name + ":HScroll", x, (y + h) - 15, w - 15, 1, mw, w - 18, parent)
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
		If IsVisible()
			Local relx:Float = m_x + x
			Local rely:Float = m_y + y
			BindRenderingState()
			dProtogPrimitives.RenderRectangleToSize(relx - 1.0, rely - 1.0, m_width + 1.0, m_height + 1.0, m_background)
			dProtogDrawState.Push(False, False, False, True, False, False)
			dui_SetViewport(relx + BOUNDARY, rely + BOUNDARY, m_width - DOUBLEBOUNDARY, m_height - DOUBLEBOUNDARY)
			For Local child:duiGadget = EachIn m_children
				child.Render(relx + m_oldx, rely + m_oldy)
			Next
			dProtogDrawState.Pop(False, False, False, True, False, False)
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
		If IsVisible()
			For Local child:duiGadget = EachIn New TListReversed.Create(m_children)
				child.Update(m_x + x + m_oldx, m_y + y + m_oldy)
			Next
			If m_vscroll Then m_oldy = -m_vscroll.GetValue()
			If m_hscroll Then m_oldx = -m_hscroll.GetValue()
			m_state = STATE_IDLE
			If duiMain.IsGadgetActive(Self)
				If dui_MouseIn(m_x + x, m_y + y, m_width, m_height)
					UpdateMouseOver(x, y)
					If MouseDown(1) Then UpdateMouseDown(x, y)
				End If
			End If
		End If
	End Method
	
'#end region Render & update methods
	
'#region Field accessors
	
	Rem
		bbdoc: Set the background on or off for the scrollbox.
		returns: Nothing.
	End Rem
	Method SetBackground(background:Int)
		m_background = background
	End Method
	
'#end region Field accessors
	
End Type

