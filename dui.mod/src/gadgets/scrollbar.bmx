
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
	bbdoc: duct ui scrollbar gadget.
End Rem
Type duiScrollBar Extends duiGadget
	
	Const NO_PART:Int = 0			' No part has yet been touched
	Const BAR_PART:Int = 1			' The scrollbar itself
	Const DEC_PART:Int = 2			' The increment button
	Const INC_PART:Int = 3			' The decrement button
	Const BIGDEC_PART:Int = 4		' The area before the bar
	Const BIGINC_PART:Int = 5		' The area after the bar
	
	Global m_renderer:duiScrollBarRenderer = New duiScrollBarRenderer
	
	Field m_align:Int					' Alignment (horizontal or vertical)
	
	Field m_value:Int					' Value of the scrollbar
	Field m_range:Int					' The number of values covered by the bar (e.g. a 15 line textbox should have a range of 15)
	
	Field m_max:Int						' Maximum value
	Field m_unit:Float					' Length of a single unit
	Field m_biginc:Int = 10					' Size of a big increment/decrement
	Field m_smallinc:Int = 1					' Size of a normal increment/decrement
	
	Field m_start:Float					' Location of the start of the scrollbar
	Field m_length:Float					' Length of the scrollbar (including ends)
	
	Field m_part:Int						' Part of the scrollbar that has been activated
	Field m_grab:Int						' Location of the bar that you grabbed (used to set the new position accordingly)
	
	Rem
		bbdoc: Create a scrollbar.
		returns: Itself.
	End Rem
	Method Create:duiScrollBar(name:String, x:Float, y:Float, length:Float, align:Int, maxval:Int, range:Int, parent:duiGadget)
		m_align = align
		If m_align = dui_ALIGN_HORIZONTAL
			_Init(name, x, y, length, 15, parent, False)
		Else If m_align = dui_ALIGN_VERTICAL
			_Init(name, x, y, 15, length, parent, False)
		End If
		SetMax(maxval)
		SetRange(range)
		Return Self
	End Method
	
'#region Render & update methods
	
	Rem
		bbdoc: Render the scrollbar.
		returns: Nothing.
	End Rem
	Method Render(x:Float, y:Float)
		If IsVisible()
			'Local relx:Float = m_x + x
			'Local rely:Float = m_y + y
			BindRenderingState()
			m_renderer.RenderFull(x, y, Self)
			Super.Render(x, y)
		End If
	End Method
	
	Rem
		bbdoc: Update the scrollbar.
		returns: Nothing.
	End Rem
	Method Update(x:Int, y:Int)
		'If Not m_state
		'	m_oz = MouseZ()
		'End If
		Super.Update(x, y)
	End Method
	
	Rem
		bbdoc: Update the MouseOver state.
		returns: Nothing.
	End Rem
	Method UpdateMouseOver(x:Int, y:Int)
		duiMain.SetCursor(dui_CURSOR_MOUSEOVER)
		Super.UpdateMouseOver(x, y)
		Local mz:Int = MouseZ()
		If mz <> m_oz
			If mz > m_oz
				MoveUp(0,, True)
			Else
				MoveDown(0,, True)
			End If
			m_oz = mz
		End If
	End Method
	
	Rem
		bbdoc: Update the MouseDown state.
		returns: Nothing.
	End Rem
	Method UpdateMouseDown(x:Int, y:Int)
		duiMain.SetCursor(dui_CURSOR_MOUSEDOWN)
		Super.UpdateMouseDown(x, y)
		Local relx:Float = m_x + x
		Local rely:Float = m_y + y
		Select m_align
			Case dui_ALIGN_VERTICAL
				If m_part = NO_PART
					' Decrement button
					If dui_MouseIn(relx, rely, m_width, 15)
						m_part = DEC_PART
					End If
					' Increment button
					If dui_MouseIn(relx, (rely + m_height) - 15, m_width, 15)
						m_part = INC_PART
					End If
					' Scrollbar
					If dui_MouseIn(relx, (m_start + y), m_width, m_length)
						m_part = BAR_PART
						m_grab = MouseY() - (m_start + y)
					End If
				End If
				
				' Check for bigger increments by clicking scroll area
				If m_part = NO_PART And dui_MouseIn(relx, rely + 15, m_width, m_height - 30)
					' Area before the scrollbar
					If MouseY() < m_start + y
						m_part = BIGDEC_PART
					Else
					' Area after the scrollbar
						m_part = BIGINC_PART
					End If
				End If
				If m_part = BAR_PART
					SetBarPosition((MouseY() - y) - m_grab)
				End If
			Case dui_ALIGN_HORIZONTAL
				If m_part = NO_PART
					' Increment button
					If dui_MouseIn(relx, rely, 15, m_height)
						m_part = DEC_PART
					End If
					' Decrement button
					If dui_MouseIn(relx + (m_width - 15), rely, 15, m_height)
						m_part = INC_PART
					End If
					' Scrollbar
					If dui_MouseIn(m_start + x, rely, m_length, m_height)
						m_part = BAR_PART
						m_grab = MouseX() - (m_start + x)
					End If
				End If
				
				' Check for bigger increments by clicking scroll area
				If m_part = NO_PART And dui_MouseIn(relx + 15, rely, m_height - 30, m_height)
					' Area before the scrollbar
					If MouseX() < m_start + x
						m_part = BIGDEC_PART
					Else
					' Area after the scrollbar
						m_part = BIGINC_PART
					End If
				End If
				If m_part = BAR_PART
					SetBarPosition((MouseX() - x) - m_grab)
				End If
		End Select
		
	End Method
	
	Rem
		bbdoc: Update the MouseRelease state.
		returns: Nothing.
	End Rem
	Method UpdateMouseRelease(x:Int, y:Int)
		Super.UpdateMouseRelease(x, y)
		If dui_MouseIn(m_x + x, m_y + y, m_width, m_height)
			Select m_part
				Case DEC_PART
					MoveUp(0, 0, True)
				Case INC_PART
					MoveDown(0, 0, True)
				Case BIGDEC_PART
					MoveUp(1, 0, True)
				Case BIGINC_PART
					MoveDown(1, 0, True)
			End Select
		End If
		m_part = NO_PART
	End Method
	
'#end region Render & update methods
	
'#region Field accessors
	
	Rem
		bbdoc: Get the value of the scroll bar
		returns: The value of the scroll bar
	End Rem
	Method GetValue:Int()
		Return m_value
	End Method
	
	Rem
		bbdoc: Set the entire length of the scrollbar area (includes buttons).
		returns: Nothing.
	End Rem
	Method SetLength(length:Float)
		Select m_align
			Case dui_ALIGN_VERTICAL
				m_height = length
			Case dui_ALIGN_HORIZONTAL
				m_width = length
		End Select
		UpdateBarLength()
	End Method
	
	Rem
		bbdoc: Set the range of the scrollbar.
		about: The range of a scrollbar is the number of values the bar actually covers.<br/>
		For example, if the bar was used to scroll lines of text, the range of the bar would be the number of lines visible in the text gadget.
	End Rem
	Method SetRange(range:Int)
		m_range = range
		If m_range < 1
			m_range = 1
		End If
		If (m_value + m_range) > m_max
			m_value = m_max - m_range
		End If
		If m_value < 0
			m_value = 0
		End If
		UpdateBarLength()
	End Method
	Rem
		bbdoc: Get the range of the scrollbar.
		returns: The range of the scrollbar.
	End Rem
	Method GetRange:Int()
		Return m_range
	End Method
	
	Rem
		bbdoc: Set the max value for the scrollbar.
		returns: Nothing.
	End Rem
	Method SetMax(_max:Int)
		m_max = _max
		If m_max < 1
			m_max = 1
		End If
		If (m_value + m_range) > m_max
			m_value = m_max - m_range
		End If
		If m_value < 0
			m_value = 0
		End If
		UpdateBarLength()
	End Method
	Rem
		bbdoc: Get the max value for the scrollbar.
		returns: The max value for the scrollbar.
	End Rem
	Method GetMax:Int()
		Return m_max
	End Method
	
	Rem
		bbdoc: Set the increment.
		returns: Nothing.
		about: This is the value added/subtracted when the user presses either of the scrollbar buttons.
	End Rem
	Method SetInc(inc:Int)
		m_smallinc = inc
		If m_smallinc < 0
			m_smallinc = 0
		End If
	End Method
	Rem
		bbdoc: Get the small increment for the scrollbar.
		returns: The small increment.
	End Rem
	Method GetInc:Int()
		Return m_smallinc
	End Method
	
	Rem
		bbdoc: Set the big increment.
		returns: Nothing.
		about: This is the value added/subtracted when the user clicks in the empty area between the bar and the buttons at either end.		
	End Rem
	Method SetBigInc(inc:Int)
		m_biginc = inc
		If m_biginc < 0
			m_biginc = 0
		End If
	End Method
	Rem
		bbdoc: Get the big increment for the scrollbar.
		returns: The big increment.
	End Rem
	Method GetBigInc:Int()
		Return m_biginc
	End Method
	
'#end region Field accessors
	
'#region Bar positioning and updating
	
	Rem
		bbdoc: Set the exact value of the scroll bar
		about: Sets the value of the scroll bar, and positions the bar at the right position.
	End Rem
	Method SetValue(value:Int, doevent:Int = True)
		m_value = value
		If (m_value + m_range) > m_max
			m_value = m_max - m_range
		End If
		If m_value < 0
			m_value = 0
		End If
		UpdateBarPos()
		If doevent
			New duiEvent.Create(dui_EVENT_GADGETACTION, Self, m_value, 0, 0, Null)
		End If
	End Method
	
	Rem
		bbdoc: Scroll up.
		returns: Nothing.
		about: If @inctype is 0, the small increment is used, if it is 1, the big increment is used.<br/>
		If @cinc is greater than 0, it is used instead of the other set increments.
	End Rem
	Method MoveUp(inctype:Int = 0, cinc:Int = 0, doevent:Int = True)
		Local inc:Int
		If cinc > 0
			inc = Abs(cinc)
		Else If inctype = 0
			inc = m_smallinc
		Else If inctype = 1
			inc = m_biginc
		End If
		MoveRelative(-inc)
	End Method
	
	Rem
		bbdoc: Scroll down.
		returns: Nothing.
		about: If @inctype is 0, the small increment is used, if it is 1, the big increment is used.<br/>
		If @cinc is greater than 0, it is used instead of the other set increments.
	End Rem
	Method MoveDown(inctype:Int = 0, cinc:Int = 0, doevent:Int = True)
		Local inc:Int
		If cinc > 0
			inc = cinc
		Else If inctype = 0
			inc = m_smallinc
		Else If inctype = 1
			inc = m_biginc
		End If
		MoveRelative(inc, doevent)
	End Method
	
	Rem
		bbdoc: Move relative to the current position (currentlocation + inc).
		returns: Nothing.
	End Rem
	Method MoveRelative(inc:Int, doevent:Int = True)
		SetValue(m_value + inc, doevent)
	End Method
	
	Rem
		bbdoc: Move the scrollbar's position to the top of the bar.
		returns: Nothing.
	End Rem
	Method MoveToTop(doevent:Int = True)
		SetValue(0, doevent)
	End Method
	
	Rem
		bbdoc: Set the scrollbar's position to the end of the bar.
		returns: Nothing.
	End Rem
	Method MoveToEnd(doevent:Int = True)
		SetValue(m_max, doevent)
	End Method
	
	Rem
		bbdoc: Set the position of the bar.
		returns: Nothing.
	End Rem
	Method SetBarPosition(pos:Int)
		m_start = pos
		' Set the reference value, either m_y or m_x, and entire gadget length
		Local ref:Float, templength:Int
		Select m_align
			Case dui_ALIGN_VERTICAL
				ref = m_y
				templength = m_height
			Case dui_ALIGN_HORIZONTAL
				ref = m_x
				templength = m_width
		End Select
		
		' Check that the bar hasn't gone too high/left
		If m_start < ref + 15
			m_start = ref + 15
			m_value = 0
		' Check that the bar doesn't go too low/right
		Else If m_start > (ref + templength) - (m_length + 15)
			m_start = (ref + templength) - (m_length + 15)
			m_value = m_max - m_range
		' Set the value of the scroll bar according to the position
		Else
			m_value = Int((m_start - (ref + 15)) / m_unit)
		End If
		New duiEvent.Create(dui_EVENT_GADGETACTION, Self, m_value, 0, 0, Null)
	End Method
	
	Rem
		bbdoc: Update the scrollbar length.
		returns: Nothing.
		about: This calls #UpdateBarPos.
	End Rem
	Method UpdateBarLength()
		Local templength:Int
		Select m_align
			Case dui_ALIGN_VERTICAL
				templength = (m_height - 30)
			Case dui_ALIGN_HORIZONTAL
				templength = (m_width - 30)
		End Select
		
		' Set the size of a unit
		m_unit = templength / Float(m_max)
		' Set the length of the bar, in units
		m_length = m_unit * m_range
		' Ensure length meets requirements
		If m_length < 6
			m_length = 6
		End If
		If m_length > templength
			m_length = templength
		End If
		UpdateBarPos()
	End Method
	
	Rem
		bbdoc: Update the bar position.
		returns: Nothing.
	End Rem
	Method UpdateBarPos()
		Select m_align
			Case dui_ALIGN_VERTICAL
				m_start = m_y + 15 + (m_unit * m_value)
			Case dui_ALIGN_HORIZONTAL
				m_start = m_x + 15 + (m_unit * m_value)
		End Select
	End Method
	
'#end region Bar positioning and updating
	
	Rem
		bbdoc: Refresh the skin images for the scrollbar.
		returns: Nothing.
	End Rem
	Function RefreshSkin(theme:duiTheme)
		m_renderer.Create(theme, "scrollbar")
	End Function
	
End Type

