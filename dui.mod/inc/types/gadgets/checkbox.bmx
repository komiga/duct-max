
Rem
	checkbox.bmx (Contains: dui_CheckBox, )
End Rem

Rem
	bbdoc: The dui checkbox gadget type.
End Rem
Type dui_CheckBox Extends dui_Gadget
	
	Global m_sectionrenderer:dui_SectionRenderer = New dui_SectionRenderer
	Global m_sectionheight:Float, m_sectionwidth:Float
	
	Field m_ticked:Int
	Field m_text:String
	Field m_align:Int
	
	Field m_capx:Float, m_texturex:Float, m_origx:Float
	
	Rem
		bbdoc: Create a checkbox gadget.
		returns: The created checkbox (itself).
	End Rem
	Method Create:dui_CheckBox(name:String, text:String, x:Float, y:Float, align:Int, parent:dui_Gadget)
		_Init(name, x, y, 0.0, 0.0, parent, False)
		
		m_origx = x
		SetText(text)
		SetAlign(align)
		m_height = m_sectionheight
		Return Self
	End Method
	
'#region Render & update methods
	
	Rem
		bbdoc: Render the checkbox.
		returns: Nothing.
	End Rem
	Method Render(x:Float, y:Float)
		Local rely:Float
		
		If IsVisible() = True
			rely = m_y + y
			
			BindDrawingState()
			If m_ticked = True
				m_sectionrenderer.RenderSectionToSectionSize("ticked", m_texturex + x, rely, True)
			Else
				m_sectionrenderer.RenderSectionToSectionSize("unticked", m_texturex + x, rely, True)
			End If
			
			BindTextDrawingState()
			dui_FontManager.RenderString(m_text, m_font, m_capx + x, rely)
			
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
		Super.UpdateMouseRelease(x, y)
		If dui_MouseIn(m_x + x, m_y + y, m_width, m_height) = True
			Toggle()
			New dui_Event.Create(dui_EVENT_GADGETACTION, Self, m_ticked, 0, 0, Null)
		End If
	End Method
	
	Rem
		bbdoc: Refresh the checkbox.
		returns: Nothing.
	End Rem
	Method Refresh()
		Select m_align
			Case dui_ALIGN_LEFT
				m_texturex = m_origx
				m_capx = m_origx + m_sectionwidth + 5
				m_x = m_origx
			Case dui_ALIGN_RIGHT
				m_texturex = m_origx - m_sectionwidth
				m_capx = m_texturex - (5 + dui_FontManager.StringWidth(m_text, m_font))
				m_x = m_capx
		End Select
		
		m_width = m_sectionwidth + 5 + dui_FontManager.StringWidth(m_text, m_font)
	End Method
	
'#end region (Render & update methods)
	
'#region Field accessors
	
	Rem
		bbdoc: Set the alignment of the checkbox.
		returns: Nothing.
		about: The alignment can be dui_ALIGN_LEFT or dui_ALIGN_RIGHT. This will refresh the gadget.
	End Rem
	Method SetAlign(align:Int)
		If align = dui_ALIGN_LEFT Or align = dui_ALIGN_RIGHT
			m_align = align
			Refresh()
		End If
	End Method
	
	Rem
		bbdoc: Set the gadget position.
		returns: Nothing.
		about: This will refresh the gadget.
	End Rem
	Method SetPosition(x:Float, y:Float)
		m_origx = x
		m_y = y
		Refresh()
	End Method
	
	Rem
		bbdoc: Move the gadget by the parameters given.
		returns: Nothing.
		about: This will refresh the gadget.
	End Rem
	Method MoveGadget(xoff:Float, yoff:Float)
		Super.MoveGadget(xoff, yoff)
		m_origx = m_origx + xoff
		Refresh()
	End Method
	
	Rem
		bbdoc: Set the textfor the checkbox.
		returns: Nothing.
	End Rem
	Method SetText(text:String)
		m_text = text
		Refresh()
	End Method
	Rem
		bbdoc: Get the checkbox's text.
		returns: The checkbox's text.
	End Rem
	Method GetText:String()
		Return m_text
	End Method
	
	Rem
		bbdoc: Set the ticked state of the checkbox.
		returns: Nothing.
	End Rem
	Method SetTicked(ticked:Int)
		m_ticked = ticked
	End Method
	Rem
		bbdoc: Get the ticked state of the checkbox.
		returns: Nothing.
	End Rem
	Method GetTicked:Int()
		Return m_ticked
	End Method
	Rem
		bbdoc: Toggle the ticked state of the checkbox.
		returns: Nothing.
	End Rem
	Method Toggle()
		SetTicked(m_ticked ~ 1)
	End Method
	
'#end region (Field accessors)
	
	Rem
		bbdoc: Refresh the checkbox skin.
		returns: Nothing.
	End Rem
	Function RefreshSkin(theme:dui_Theme)
		Local section:dui_ThemeSection
		
		m_sectionrenderer.Create(theme, "checkbox")
		
		section = m_sectionrenderer.AddSectionFromStructure("unticked", True)
		If section = Null
			Throw("(dui_CheckBox.RefreshSkin) Failed to get section 'unticked'")
		End If
		m_sectionheight = section.m_height
		m_sectionwidth = section.m_width
		section = m_sectionrenderer.AddSectionFromStructure("ticked", True)
		If section = Null
			Throw("(dui_CheckBox.RefreshSkin) Failed to get section 'ticked'")
		End If
		If m_sectionheight < section.m_height
			m_sectionheight = section.m_height
		End If
		If m_sectionwidth < section.m_width
			m_sectionwidth = section.m_width
		End If
	End Function
	
End Type

