
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
	bbdoc: duct ui date gadget.
End Rem
Type duiDate Extends duiGadget
	
	Global m_renderer:duiGenericRenderer = New duiGenericRenderer
	
	Field m_text:String
	Field m_date:Int
	
	Rem
		bbdoc: The date panel.
		about: A date has a date panel gadget containing the calendar.
	End Rem
	Field m_datepanel:duiDatePanel
	
	Rem
		bbdoc: Create a date gadget.
		returns: Itself.
	End Rem
	Method Create:duiDate(name:String, x:Float, y:Float, w:Float, h:Float, starty:Int, endy:Int, parent:duiGadget)
		_Init(name, x, y, w, h, parent, True)
		m_datepanel = New duiDatePanel.Create(name + ":Panel", 180.0, 180.0, starty, endy, Self)
		Return Self
	End Method
	
'#region Render & update methods
	
	Rem
		bbdoc: Render the date gadget.
		returns: Nothing.
	End Rem
	Method Render(x:Float, y:Float)
		If IsVisible()
			Local relx:Float = m_x + x
			Local rely:Float = m_y + y
			BindRenderingState()
			m_renderer.RenderCells(relx, rely, Self)
			BindTextRenderingState()
			duiFontManager.RenderString(m_text, m_font, relx + 5, rely + 3)
			BindRenderingState()
			m_renderer.RenderSectionToSectionSize("arrow", (relx + m_width) - 12, (rely + m_height) - 10)
			Super.Render(x, y)
		End If
	End Method
	
	Rem
		bbdoc: Update the MouseOver state.
		returns: Nothing.
	End Rem
	Method UpdateMouseOver(x:Int, y:Int)
		duiMain.SetCursor(dui_CURSOR_MOUSEOVER)
		Super.UpdateMouseOver(x, y)
	End Method
	
	Rem
		bbdoc: Update the MouseDown state.
		returns: Nothing.
	End Rem
	Method UpdateMouseDown(x:Int, y:Int)
		duiMain.SetCursor(dui_CURSOR_MOUSEDOWN)
		Super.UpdateMouseDown(x, y)
	End Method
	
	Rem
		bbdoc: Update the MouseRelease state.
		returns: Nothing.
	End Rem
	Method UpdateMouseRelease(x:Int, y:Int)
		If dui_MouseIn(m_x + x, m_y + y, m_width, m_height) = True
			Local relx:Float = m_x + x
			Local rely:Float = m_y + y
			Local ay:Int = rely + m_height + 2
			If ay + m_datepanel.m_height > duiMain.m_height
				ay = (rely - 2) - m_datepanel.m_height
			End If
			Open(relx, ay)
		End If
		Super.UpdateMouseRelease(x, y)
	End Method
	
'#end region Render & update methods
	
'#region Field accessors
	
	Rem
		bbdoc: Set the calendar date
	End Rem
	Method SetCalendarDate(day:Int, month:Int, year:Int)
		SetDate(dui_JulianDayAsInt(day, Month, year))
	End Method
	
	Rem
		bbdoc: Set the date using julian days
	End Rem
	Method SetDate(date:Int)
		m_date = date
		m_text = dui_JulianDateAsString(date, dui_FULL_DATE)
	End Method
	
	Rem
		Get the date
	End Rem	
	Method GetDate:Int()
		Return m_date
	End Method
	
'#end region Field accessors
	
'#region Gadget Function
	
	Rem
		bbdoc: Open the date panel
		about: Opens the date panel, and generates a dui_EVENT_GADGETOPEN event.
	End Rem
	Method Open(x:Int, y:Int)
		m_datepanel.Activate(x, y)
		New duiEvent.Create(dui_EVENT_GADGETOPEN, Self, 1, 0, 0, m_datepanel)
	End Method
	
	Rem
		bbdoc: Close the combo box menu
		about: Closes the combo box, and generates a dui_EVENT_GADGETCLOSE event with the combobox's menu as the source.
	End Rem
	Method Close()
		m_datepanel.Hide()
		m_datepanel.Deactivate()
	End Method
	
'#end region Gadget Function
	
	Rem
		bbdoc: Refresh the skin for the date gadget.
		returns: Nothing.
	End Rem
	Function RefreshSkin(theme:duiTheme)
		m_renderer.Create(theme, "date")
		m_renderer.AddSectionFromStructure("arrow", True)
	End Function
	
End Type

