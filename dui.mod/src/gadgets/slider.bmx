
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
	bbdoc: duct ui slider gadget.
End Rem
Type duiSlider Extends duiGadget
	
	Const NO_PART:Int = 0			' No part has yet been touched
	Const BAR_PART:Int = 1			' The slider itself
	Const BIGDEC_PART:Int = 4		' The area before the bar
	Const BIGINC_PART:Int = 5		' The area after the bar
	
	Global m_renderer:duiSliderRenderer = New duiSliderRenderer
	
	Field m_align:Int			' Alignment (horizontal or vertical)
	
	Field m_sliderx:Float		' Slider track x position
	Field m_slidery:Float		' Slider track y position
	Field m_sliderlength:Int	' Slider track length
	
	Field m_value:Int			' Value of the slider
	Field m_startvalue:Int		' The starting value
	Field m_endvalue:Int		' The end value
	
	Field m_unit:Float			' Length of a single unit, in pixels
	Field m_smallinc:Int = 1	' Size of a normal increment/decrement, in units
	
	Field m_start:Int			' Location of the start of the slider button
	Field m_length:Int = 15		' Length of the slider (including ends)
	
	Field m_part:Int			' Part of the slider that has been activated
	Field m_grab:Int			' The position where you grabbed the slider
	
	Rem
		bbdoc: Create a slider gadget.
		returns: Itself.
	End Rem
	Method Create:duiSlider(name:String, x:Float, y:Float, length:Float, align:Int, startval:Int, endval:Int, inc:Int, parent:duiGadget)
		If align = dui_ALIGN_HORIZONTAL
			m_align = dui_ALIGN_HORIZONTAL
			_Init(name, x, y, length, 15, parent, False)
			m_sliderx = x + 7
			m_slidery = y
		Else If align = dui_ALIGN_VERTICAL
			m_align = dui_ALIGN_VERTICAL
			_Init(name, x, y, 15, length, parent, False)
			m_sliderx = x
			m_slidery = y + 7
		End If
		m_sliderlength = length - 14
		SetRange(startval, endval)
		SetIncrement(inc)
		Return Self
	End Method
	
'#region Render & update methods
	
	Rem
		bbdoc: Render the slider.
		returns: Nothing.
	End Rem
	Method Render(x:Float, y:Float)
		If IsVisible() = True
			'relsx = m_sliderx + x
			'relsy = m_slidery + y
			BindRenderingState()
			m_renderer.RenderFull(x, y, Self)
			Super.Render(x, y)
		End If
	End Method
	
	Rem
		bbdoc: Update the slider.
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
				SetValue(m_value + m_smallinc)
			Else
				SetValue(m_value - m_smallinc)
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
		Local relx:Int = m_x + x
		Local rely:Int = m_y + y
		Select m_align
			Case dui_ALIGN_VERTICAL
				If m_part = NO_PART
					If dui_MouseIn(relx, (m_start + y), m_width, m_length)
						m_part = BAR_PART
						m_grab = m_start + 7
						'SetValueByPos(MouseY() - (y + m_slidery), True)
					Else If dui_MouseIn(relx, rely, m_width, m_height)
						If MouseY() < m_start + y
							m_part = BIGINC_PART
						Else
							m_part = BIGDEC_PART
						End If
					End If
				Else If m_part = BAR_PART
					SetValueByPos(MouseY() - (y + m_slidery), True)
				End If
			Case dui_ALIGN_HORIZONTAL
				If m_part = NO_PART
					If dui_MouseIn(m_start + x, rely, m_length, m_height)
						m_part = BAR_PART
						m_grab = m_start + 7
						'SetValueByPos(MouseX() - (x + m_sliderx), True)
					Else If dui_MouseIn(relx, rely, m_width, m_height)
						If MouseX() < m_start + x
							m_part = BIGDEC_PART
						Else
							m_part = BIGINC_PART
						End If
					End If
				Else If m_part = BAR_PART
					SetValueByPos(MouseX() - (x + m_sliderx), True)
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
				Case BIGDEC_PART
					SetValue(m_value - m_smallinc)
				Case BIGINC_PART
					SetValue(m_value + m_smallinc)
			End Select
		End If
		m_part = NO_PART
	End Method
	
	Rem
		bbdoc: Update the length of a unit.
		returns: Nothing.
		about: This calls #UpdateBarPos. This updates the graphical change for the given increment.
	End Rem
	Method UpdateUnitLength()
		Local range:Int = m_endvalue - m_startvalue
		m_unit = Float(m_sliderlength) / (Float(range) / Float(m_smallinc))
		UpdateBarPos()
	End Method
	
	Rem
		bbdoc: Update the slider bar position.
		returns: Nothing.
	End Rem
	Method UpdateBarPos()
		Select m_align
			Case dui_ALIGN_VERTICAL
				m_start = ((m_slidery + m_sliderlength) - (m_unit * Float(m_value))) - (m_length / 2)
			Case dui_ALIGN_HORIZONTAL
				m_start = (m_sliderx + (m_unit * Float(m_value))) - (m_length / 2)
		End Select
	End Method
	
'#end region Render & update methods
	
'#region Field accessors
	
	Rem
		bbdoc: Set the exact value of the slider.
		returns: Nothing.
		about: @_value will be clamped to StartValue to EndValue. This will only trigger the event given @doevent is True and if the set value is greater or less than the old.<br> This will call #UpdateBarPos.
	End Rem
	Method SetValue(value:Int, doevent:Int = True)
		Local ovalue:Int = m_value
		m_value = IntMax(IntMin(value, m_startvalue), m_endvalue)
		If m_value <> ovalue
			UpdateBarPos()
			If doevent
				New duiEvent.Create(dui_EVENT_GADGETACTION, Self, m_value, 0, 0, Null)
			End If
		End If
	End Method
	
	Rem
		bbdoc: Set the value of the slider by a screen position.
		returns: Nothing.
		about: This will determine the closest value to the given position and select it
	End Rem
	Method SetValueByPos(pos:Int, doevent:Int = True)
		Local value:Int = pos / m_unit
		If pos - (value * m_unit) > (m_unit / 2)
			value:+ 1
		End If
		If m_align = dui_ALIGN_VERTICAL
			value = m_endvalue - (value - m_startvalue)
		End If
		SetValue(value, doevent)
	End Method
	
	Rem
		bbdoc: Get the value of the slider.
		returns: The value of the slider.
	End Rem
	Method GetValue:Int()
		Return m_value
	End Method
	
	Rem
		bbdoc: Set the range of the slider.
		returns: Nothing.
		about: This will call #UpdateUnitLength.
	End Rem
	Method SetRange(startvalue:Int, endvalue:Int)
		m_startvalue = startvalue
		If endvalue < startvalue
			m_endvalue = startvalue
		Else
			m_endvalue = endvalue
		End If
		UpdateUnitLength()
	End Method
	
	Rem
		bbdoc: Set the slider's start value.
		returns: Nothing.
	End Rem
	Method SetStartValue(startvalue:Int)
		If startvalue >= m_endvalue
			m_startvalue = m_endvalue
		Else
			m_startvalue = startvalue
		End If
	End Method
	Rem
		bbdoc: Get the start value.
		returns: The slider's start value.
	End Rem
	Method GetStartValue:Int()
		Return m_startvalue
	End Method
	
	Rem
		bbdoc: Set the slider's end value.
		returns: Nothing.
	End Rem
	Method SetEndValue(endvalue:Int)
		If endvalue < m_startvalue
			m_endvalue = m_startvalue
		Else
			m_endvalue = endvalue
		End If
	End Method
	
	Rem
		bbdoc: Get the end value.
		returns: The slider's end value.
	End Rem
	Method GetEndValue:Int()
		Return m_endvalue
	End Method
	
	Rem
		bbdoc: Set the increment for the slider.
		returns: Nothing.
		about The increment is the amount the slider value is changed when the slider is dragged. This will call #UpdateUnitLength.
	End Rem
	Method SetIncrement(inc:Int)
		m_smallinc = Abs(inc)
		UpdateUnitLength()
	End Method
	
'#end region Field accessors
	
	Rem
		bbdoc: Refresh the skin for the slider.
		returns: Nothing.
	End Rem
	Function RefreshSkin(theme:duiTheme)
		m_renderer.Create(theme, "slider")
	End Function
	
End Type

