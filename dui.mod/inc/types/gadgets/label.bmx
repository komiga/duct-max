
Rem
	label.bmx (Contains: dui_Label, )
End Rem

Rem
	bbdoc: The dui label gadget type.
End Rem
Type dui_Label Extends dui_Gadget
	
	Field m_text:String
	Field m_xalign:Int, m_yalign:Int		' Alignment
	Field m_origx:Int, m_origy:Int			' Original position
	
	Rem
		bbdoc: Create a label gadget.
		returns: The created label gadget (itself).
	End Rem
	Method Create:dui_Label(name:String, text:String, x:Float, y:Float, w:Float, h:Float, xalign:Int, yalign:Int, parent:dui_Gadget)
		_Init(name, x, y, w, h, parent, False)
		SetXAlign(xalign, False)
		SetYAlign(yalign, False)
		SetText(text, False)
		Refresh()
		Return Self
	End Method
	
'#region Render & update methods
	
	Rem
		bbdoc: Render the label.
		returns: Nothing.
	End Rem
	Method Render(x:Float, y:Float)
		If IsVisible() = True
			BindTextDrawingState()
			dui_FontManager.RenderString(m_text, m_font, m_x, m_y)
			Super.Render(x, y)
		End If
	End Method
	
	Rem
		bbdoc: Refresh the label.
		returns: Nothing.
	End Rem
	Method Refresh()
		m_width = dui_FontManager.StringWidth(m_text, m_font)
		m_height = dui_FontManager.StringHeight(m_text, m_font)
		
		Select m_xalign
			Case 0		' Left
				m_x = m_origx
			Case 1		' Central
				m_x = m_origx - (m_width / 2)
			Case 2		' Right
				m_x = m_origx - m_width
		End Select
		
		Select m_yalign
			Case 0		' Top
				m_y = m_origy
			Case 1		' Central
				m_y = m_origy - (m_height / 2)
			Case 2		' Bottom
				m_y = m_origy - m_height
		End Select
	End Method
	
'#end region (Render & update methods)
	
'#region Field accessors
	
	Rem
		bbdoc: Set the label's position.
		returns: Nothing.
	End Rem
	Method SetPosition(x:Float, y:Float)
		Super.SetPosition(x, y)
		m_origx = x
		m_origy = y
	End Method
	
	Rem
		bbdoc: Set the label's text.
		returns: Nothing.
	End Rem
	Method SetText(text:String, dorefresh:Int = True)
		m_text = text
		If dorefresh = True
			Refresh()
		End If
	End Method
	
	Rem
		bbdoc: Get the label's text.
		returns: The label's text.
	End Rem
	Method GetText:String()
		Return m_text
	End Method
	
	Rem
		bbdoc: Set the x alignment.
		returns: Nothing.
		about: @align can be:<br/>
		0 - Left<br/>
		1 - Central<br/>
		2 - Right<br/>
	End Rem
	Method SetXAlign(align:Int, dorefresh:Int = True)
		m_xalign = align
		If dorefresh = True
			Refresh()
		End If
	End Method
	
	Rem
		bbdoc: Set the y alignment.
		returns: Nothing.
		about: @align can be:<br/>
		0 - Top<br/>
		1 - Central<br/>
		2 - Bottom<br/>
	End Rem
	Method SetYAlign(align:Int, dorefresh:Int = True)
		m_yalign = align
		If dorefresh = True
			Refresh()
		End If
	End Method
	
'#end region (Field accessors)
	
End Type

