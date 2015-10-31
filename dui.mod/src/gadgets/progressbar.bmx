
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
	bbdoc: duct ui progress bar gadget.
End Rem
Type duiProgressBar Extends duiGadget
	
	Global m_renderer:duiGenericRenderer = New duiGenericRenderer
	
	Field m_capx:Float
	
	Field m_value:Int
	Field m_text:String
	
	Rem
		bbdoc: Create a progress bar.
		returns: Itself.
	End Rem
	Method Create:duiProgressBar(name:String, text:String, x:Float, y:Float, w:Float, h:Float, parent:duiGadget)
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
		If IsVisible() = True
			Local relx:Float = m_x + x
			Local rely:Float = m_y + y
			BindRenderingState(0)
			m_renderer.RenderCells(relx, rely, Self, True, True, False)
			Local fw:Float = (m_width - 10) * Float(m_value / 100.0)
			m_renderer.RenderCell(4, relx + fw, rely, Self, -fw)
			BindRenderingState(1)
			m_renderer.RenderCell(4, relx, rely - 2, Self,, -4)
			BindTextRenderingState()
			duiFontManager.RenderString(m_text, m_font, m_capx + x, rely + 2)
			Super.Render(x, y)
		End If
	End Method
	
	Rem
		bbdoc: Refresh the the progress bar.
		returns: Nothing.
	End Rem
	Method Refresh()
		m_capx = (m_x + (m_width / 2)) - (duiFontManager.StringWidth(m_text, m_font) / 2)
	End Method
	
'#end region Render & update methods
	
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
		If doevent
			New duiEvent.Create(dui_EVENT_GADGETACTION, Self, m_value, 0, 0, Null)
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
	Function RefreshSkin(theme:duiTheme)
		m_renderer.Create(theme, "progressbar")
	End Function
	
End Type

