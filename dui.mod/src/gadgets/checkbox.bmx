
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
	bbdoc: duct ui checkbox gadget.
End Rem
Type duiCheckBox Extends duiGadget
	
	Global m_sectionrenderer:duiSectionRenderer = New duiSectionRenderer
	Global m_sectionheight:Float, m_sectionwidth:Float
	
	Field m_ticked:Int
	Field m_text:String
	Field m_align:Int
	
	Field m_capx:Float, m_texturex:Float, m_origx:Float
	
	Rem
		bbdoc: Create a checkbox gadget.
		returns: Itself.
	End Rem
	Method Create:duiCheckBox(name:String, text:String, x:Float, y:Float, align:Int, parent:duiGadget)
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
		If IsVisible()
			Local rely:Float = m_y + y
			BindRenderingState()
			If m_ticked
				m_sectionrenderer.RenderSectionToSectionSize("ticked", m_texturex + x, rely, True)
			Else
				m_sectionrenderer.RenderSectionToSectionSize("unticked", m_texturex + x, rely, True)
			End If
			BindTextRenderingState()
			duiFontManager.RenderString(m_text, m_font, m_capx + x, rely)
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
		Super.UpdateMouseRelease(x, y)
		If dui_MouseIn(m_x + x, m_y + y, m_width, m_height)
			Toggle()
			New duiEvent.Create(dui_EVENT_GADGETACTION, Self, m_ticked, 0, 0, Null)
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
				m_capx = m_texturex - (5 + duiFontManager.StringWidth(m_text, m_font))
				m_x = m_capx
		End Select
		m_width = m_sectionwidth + 5 + duiFontManager.StringWidth(m_text, m_font)
	End Method
	
'#end region Render & update methods
	
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
	
'#end region Field accessors
	
	Rem
		bbdoc: Refresh the checkbox skin.
		returns: Nothing.
	End Rem
	Function RefreshSkin(theme:duiTheme)
		m_sectionrenderer.Create(theme, "checkbox")
		Local section:duiThemeSection = m_sectionrenderer.AddSectionFromStructure("unticked", True)
		If section = Null
			Throw "(duiCheckBox.RefreshSkin) Failed to get section 'unticked'"
		End If
		m_sectionheight = section.m_height
		m_sectionwidth = section.m_width
		section = m_sectionrenderer.AddSectionFromStructure("ticked", True)
		If section = Null
			Throw "(duiCheckBox.RefreshSkin) Failed to get section 'ticked'"
		End If
		If m_sectionheight < section.m_height
			m_sectionheight = section.m_height
		End If
		If m_sectionwidth < section.m_width
			m_sectionwidth = section.m_width
		End If
	End Function
	
End Type

