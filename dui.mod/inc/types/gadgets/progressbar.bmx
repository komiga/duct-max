
Rem
	progressbar.bmx (Contains: dui_ProgressBar, )
End Rem

Rem
	bbdoc: The dui progress bar gadget type.
End Rem
Type dui_ProgressBar Extends dui_Gadget
	
	Global m_renderer:dui_GenericRenderer = New dui_GenericRenderer
	
	Field m_capx:Float
	
	Field m_value:Int
	Field m_text:String
	
	Rem
		bbdoc: Create a progress bar.
		returns: The created progress bar.
	End Rem
	Method Create:dui_ProgressBar(name:String, text:String, x:Float, y:Float, w:Float, h:Float, parent:dui_Gadget)
		_Init(name, x, y, w, h, parent, False)
		SetText(text)
		Return Self
	End Method
	
'#region Render & update methods
	
	Rem
		bbdoc: Render the progress bar.
		returns: Nothing.
	End Rem
	Method Render(x:Float, y:Float)
		Local relx:Float, rely:Float, fw:Float
		
		If IsVisible() = True
			relx = m_x + x
			rely = m_y + y
			
			BindDrawingState(0)
			m_renderer.RenderCells(relx, rely, Self, True, True, False)
			
			fw = (m_width - 10) * Float(m_value / 100.0)
			m_renderer.RenderCell(4, relx + fw, rely, Self, -fw)
			
			BindDrawingState(1)
			m_renderer.RenderCell(4, relx, rely - 2, Self,, -4)
			
			BindTextDrawingState()
			dui_FontManager.RenderString(m_text, m_font, m_capx + x, rely + 2)
			
			Super.Render(x, y)
		End If
	End Method
	
	Rem
		bbdoc: Refresh the the progress bar.
		returns: Nothing.
	End Rem
	Method Refresh()
		m_capx = (m_x + (m_width / 2)) - (dui_FontManager.StringWidth(m_text, m_font) / 2)
	End Method
	
'#end region (Render & update methods)
	
'#region Field accessors
	
	Rem
		bbdoc: Set the progress bar's text.
		returns: Nothing.
		about: This will refresh the progress bar.
	End Rem
	Method SetText(text:String)
		m_text = text
		Refresh()
	End Method
	Rem
		bbdoc: Get the progress bar's text.
		returns: The progress bar's text.
	End Rem
	Method GetText:String()
		Return m_text
	End Method
	
	Rem
		bbdoc: Set the current progress/value.
		returns: Nothing.
		about: @_value is clamped to 0 to 100.
	End Rem
	Method SetValue(value:Int, doevent:Int)
		m_value = IntMax(IntMin(value, 0), 100)
		
		If doevent = True
			New dui_Event.Create(dui_EVENT_GADGETACTION, Self, m_value, 0, 0, Null)
		End If
	End Method
	
	Rem
		bbdoc: Get the current progress.
		returns: The progress bar's progress/value.
	End Rem
	Method GetValue:Int()
		Return m_value
	End Method
	
'#end region (Field accessors)
	
	Rem
		bbdoc: Refresh the progress bar's skin.
		returns: Nothing.
	End Rem
	Function RefreshSkin(theme:dui_Theme)
		m_renderer.Create(theme, "progressbar")
	End Function
	
End Type

















