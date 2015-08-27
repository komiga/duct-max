
Rem
Copyright (c) 2010 plash <plash@komiga.com>

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
	bbdoc: duct ui date panel gadget.
End Rem
Type duiDatePanel Extends duiGadget
	
	Global m_renderer:duiGenericRenderer = New duiGenericRenderer
	
	Field m_date:duiDate
	Field m_month:duiComboBox
	Field m_year:duiComboBox
	Field m_calender:duiTable
	
	Field m_monthitem:Int, m_yearitem:Int
	Field m_start:Int, m_end:Int
	
	Rem
		bbdoc: Create a date panel.
		returns: Itself.
	End Rem
	Method Create:duiDatePanel(name:String, w:Float, h:Float, starty:Int, endy:Int, date:duiDate)
		_Init(name, 0.0, 0.0, w, h, Null, False)
		SetRange(starty, endy, False)
		' Add to the extra list BEFORE its child combo boxes
		duiMain.AddExtra(Self)
		m_date = date
		m_month = New duiComboBox.Create(name + ":MonthCombobox", "", 5.0, 5.0, 95.0, 20.0, 95.0, 270.0, 18.0, Self)
		For Local index:Int = 1 To 12
			m_month.AddItemByData(dui_MonthAsString(index, True), index,, False)
		Next
		m_year = New duiComboBox.Create(name + ":YearComboBox", "", 105.0, 5.0, 70.0, 20.0, 80.0, 200.0, 18.0, Self)
		m_calender = New duiTable.Create(name + ":ResultsTable", 5.0, 30.0, 145.0, "S", 22.0, 18.0, True, Self)
		m_calender.AddColumn("M", 22, False)
		m_calender.AddColumn("T", 22, False)
		m_calender.AddColumn("W", 22, False)
		m_calender.AddColumn("T", 22, False)
		m_calender.AddColumn("F", 22, False)
		m_calender.AddColumn("S", 22, False)
		' Table heading
		m_calender.SetColorParams(0.0, 0.0, 0.0, 2)
		m_calender.SetAlpha(0.5, 2)
		m_calender.SetTextColorParams(1.0, 1.0, 1.0, 2)
		Hide()
		Refresh()
		Return Self
	End Method
	
'#region Render & update methods
	
	Rem
		bbdoc: Render the date panel.
		returns: Nothing.
	End Rem
	Method Render(x:Float, y:Float)
		If IsVisible()
			BindRenderingState()
			m_renderer.RenderCells(m_x, m_y, Self)
			Super.Render(x, y)
		End If
	End Method
	
	Rem
		bbdoc: Update the date panel.
		returns: Nothing.
	End Rem
	Method Update(x:Int, y:Int)
		If m_monthitem <> m_month.GetSelectedItemIndex() Or m_yearitem <> m_year.GetSelectedItemIndex()
			RefreshCalendar()
		End If
		Super.Update(x, y)
		If duiMain.IsGadgetActive(Self) And MouseDown(1) And IsVisible()
			UpdateMouseDown(x, y)
		End If
	End Method
	
	Rem
		bbdoc: Update the MouseDown state.
		returns: Nothing.
	End Rem
	Method UpdateMouseDown(x:Int, y:Int)
		Local relx:Int = m_x + x
		Local rely:Int = m_y + y
		Super.UpdateMouseDown(x, y)
		If IsVisible()
			' Hide the gadget and generate a close event
			New duiEvent.Create(dui_EVENT_GADGETCLOSE, Self, 0, 0, 0, Self)
			Hide()
		End If
	End Method
		
	Rem
		bbdoc: Refresh the date panel.
		retruns: Nothing.
	End Rem
	Method Refresh()
		' Refresh the year list
		m_year.ClearItems()
		For Local index:Int = m_start To m_end
			m_year.AddItemByData(String(index),, , False)
		Next
		' Set the month to January, and year to first available
		m_month.SelectItem(0)
		m_year.SelectItem(0)
		' Refresh calendar
		RefreshCalendar(True)
		m_month.m_menu.Refresh()
		m_year.m_menu.Refresh()
	End Method
	
	Rem
		bbdoc: Refresh the calender.
		returns: Nothing.
	End Rem
	Method RefreshCalendar(dorefresh:Int = True)
		m_monthitem = m_month.GetSelectedItemIndex()
		m_yearitem = m_year.GetSelectedItemIndex()
		m_calender.ClearItems()
		Local calender:Int[][] = dui_Calendar(m_monthitem + 1, m_yearitem + m_start)
		For Local week:Int = 0 To 5
			m_calender.AddItemByData([""],,, False)
			' Set the content
			For Local day:Int = 0 To 6
				If calender[day][week] <> 0
					m_calender.SetItemContentAtIndex(week, day, calender[day][week])
				End If
			Next
		Next
		
		If dorefresh = True
			m_calender.Refresh()
		End If
	End Method
	
'#end region Render & update methods
	
'#region Gadget function
	
	Rem
		bbdoc: Select a day in the month.
		returns: Nothing.
	End Rem
	Method SelectDay(day:Int)
		If day > 0 And day < 32
			m_date.SetCalendarDate(day, m_monthitem + 1, m_yearitem + m_start)
		End If
	End Method
	
	Rem
		bbdoc: Activate the date panel menu.
		returns: Nothing.
	End Rem
	Method Activate(x:Int, y:Int)
		m_x = x
		m_y = y
		Show()
		duiMain.SetActiveGadget(Self)
		m_calender.m_selected = -1
		New duiEvent.Create(dui_EVENT_GADGETOPEN, Self, 1, 0, 0, Null)
	End Method
	
	Rem
		bbdoc: Deactivate the date panel menu.
		returns: Nothing.
	End Rem
	Method Deactivate()
		duiMain.ClearActiveGadget()
		m_state = STATE_IDLE
		New duiEvent.Create(dui_EVENT_GADGETCLOSE, m_date, 0, 0, 0, Null)
	End Method
	
	Rem
		bbdoc: Set the year range of the date panel (?)
		returns: Nothing.
	End Rem
	Method SetRange(start:Int, _end:Int, dorefresh:Int = True)
		m_start = start
		m_end = _end
		
		If _end < start
			m_end = start
		End If
		
		If dorefresh = True
			Refresh()
		End If
	End Method
	
'#end region Gadget function
	
	Rem
		bbdoc: Refresh the skin for the date panel.
		returns: Nothing.
	End Rem
	Function RefreshSkin(theme:duiTheme)
		m_renderer.Create(theme, "datepanel")
	End Function
	
End Type

