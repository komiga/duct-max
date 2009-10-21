
Rem
	date.bmx (Contains: dui_Date, )
End Rem

Rem
	bbdoc: The dui date gadget type.
End Rem
Type dui_Date Extends dui_Gadget
	
	Global m_renderer:dui_GenericRenderer = New dui_GenericRenderer
	
	Field m_text:String		' Caption
	Field m_date:Int		' Date value, in Julian days
	
	Rem
		bbdoc: The date panel.
		about: A date has a date panel gadget containing the calendar.
	End Rem
	Field m_datepanel:dui_DatePanel
	
	Rem
		bbdoc: Create a date gadget.
		returns: The created date gadget (itself).
	End Rem
	Method Create:dui_Date(name:String, x:Float, y:Float, w:Float, h:Float, starty:Int, endy:Int, parent:dui_Gadget)
		_Init(name, x, y, w, h, parent, True)
		m_datepanel = New dui_DatePanel.Create(name + ":Panel", 180.0, 180.0, starty, endy, Self)
		
		Return Self
	End Method
	
'#region Render & update methods
	
	Rem
		bbdoc: Render the date gadget.
		returns: Nothing.
	End Rem
	Method Render(x:Float, y:Float)
		Local relx:Float, rely:Float
		
		If IsVisible() = True
			relx = m_x + x
			rely = m_y + y
			
			BindDrawingState()
			m_renderer.RenderCells(relx, rely, Self)
			
			BindTextDrawingState()
			dui_FontManager.RenderString(m_text, m_font, relx + 5, rely + 3)
			
			BindDrawingState()
			m_renderer.RenderSectionToSectionSize("arrow", (relx + m_width) - 12, (rely + m_height) - 10)
			
			Super.Render(x, y)
		End If
	End Method
	
	Rem
		bbdoc: Update the MouseOver state.
		returns: Nothing.
	End Rem
	Method UpdateMouseOver(x:Int, y:Int)
		TDUIMain.SetCursor(dui_CURSOR_MOUSEOVER)
		Super.UpdateMouseOver(x, y)
	End Method
	
	Rem
		bbdoc: Update the MouseDown state.
		returns: Nothing.
	End Rem
	Method UpdateMouseDown(x:Int, y:Int)
		TDUIMain.SetCursor(dui_CURSOR_MOUSEDOWN)
		Super.UpdateMouseDown(x, y)
	End Method
	
	Rem
		bbdoc: Update the MouseRelease state.
		returns: Nothing.
	End Rem
	Method UpdateMouseRelease(x:Int, y:Int)
		Local relx:Int, rely:Int, ay:Int
		
		If dui_MouseIn(m_x + x, m_y + y, m_width, m_height) = True
			relx = m_x + x
			rely = m_y + y
			
			ay = rely + m_height + 2
			If ay + m_datepanel.m_height > TDUIMain.m_height
				ay = (rely - 2) - m_datepanel.m_height
			End If
			
			Open(relx, ay)
		End If
		Super.UpdateMouseRelease(x, y)
	End Method
	
'#end region (Render & update methods)
	
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
	
'#end region (Field accessors)
	
'#region Gadget Function
	
	Rem
		bbdoc: Open the date panel
		about: Opens the date panel, and generates a dui_EVENT_GADGETOPEN event.
	End Rem
	Method Open(x:Int, y:Int)
		m_datepanel.Activate(x, y)
		New dui_Event.Create(dui_EVENT_GADGETOPEN, Self, 1, 0, 0, m_datepanel)
	End Method
	
	Rem
		bbdoc: Close the combo box menu
		about: Closes the combo box, and generates a dui_EVENT_GADGETCLOSE event with the combobox's menu as the source.
	End Rem
	Method Close()
		m_datepanel.Hide()
		m_datepanel.Deactivate()
	End Method
	
'#end region (Gadget Function)
	
	Rem
		bbdoc: Refresh the skin for the date gadget.
		returns: Nothing.
	End Rem
	Function RefreshSkin(theme:dui_Theme)
		m_renderer.Create(theme, "date")
		m_renderer.AddSectionFromStructure("arrow", True)
	End Function
	
End Type















