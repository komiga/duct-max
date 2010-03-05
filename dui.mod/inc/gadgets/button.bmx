
Rem
	button.bmx (Contains: duiButton, )
End Rem

Rem
	bbdoc: duct ui button gadget.
End Rem
Type duiButton Extends duiGadget
	
	Global m_renderer:duiGenericRenderer = New duiGenericRenderer
	
	Field m_text:String
	Field m_capx:Float, m_capy:Float
	
	Field m_buttontexture:dProtogTexture
	Field m_background:Int = True
	
	Rem
		bbdoc: Create a button.
		returns: The new button (itself).
		about: @texture can be either a dProtogTexture or a String (it will be loaded automatically).
	End Rem
	Method Create:duiButton(name:String, text:String, texture:Object, x:Float, y:Float, width:Float, height:Float, parent:duiGadget, background:Int = True)
		_Init(name, x, y, width, height, parent, False)
		
		SetText(text, False)
		SetBackground(background)
		LoadTexture(texture, False)
		Refresh()
		Return Self
	End Method
	
'#region Render & update methods
	
	Rem
		bbdoc: Render the button.
		returns: Nothing.
	End Rem
	Method Render(x:Float, y:Float)
		Local relx:Float, rely:Float
		
		If IsVisible() = True
			relx = m_x + x
			rely = m_y + y
			
			BindDrawingState()
			If m_background = True
				m_renderer.RenderCells(relx, rely, Self)
			End If
			
			If m_buttontexture <> Null
				m_buttontexture.Bind()
				m_buttontexture.RenderToPos(New dVec2.Create(m_capx + x, m_capy + y), False)
				m_buttontexture.UnBind()
			Else
				BindTextDrawingState()
				duiFontManager.RenderString(m_text, m_font, m_capx + x, m_capy + y, True, True)
			End If
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
		'New duiEvent.Create(dui_EVENT_GADGETACTION, Self, 0, 0, 0, Null)
	End Method
	
	Rem
		bbdoc: Update the MouseRelease state.
		returns: Nothing.
	End Rem
	Method UpdateMouseRelease(x:Int, y:Int)
		Super.UpdateMouseRelease(x, y)
		If dui_MouseIn(m_x + x, m_y + y, m_width, m_height) = True
			Local search:duiSearchPanel = duiSearchPanel(m_parent)
			If search <> Null
				' Set the data of the search box to its null value
				search.Deactivate()
				search.SelectItem(Null)
				search.Hide()
			Else
				New duiEvent.Create(dui_EVENT_GADGETACTION, Self, 0, 0, 0, Null)
			End If
		End If
	End Method
	
	Rem
		bbdoc: Refresh the button.
		returns: Nothing.
	End Rem
	Method Refresh()
		If m_buttontexture <> Null
			m_capx = (m_x + (m_width / 2)) - m_buttontexture.m_width / 2
			m_capy = (m_y + (m_height / 2)) - m_buttontexture.m_height / 2
		Else
			'halfx = duiFontManager.StringWidth(m_text, m_font) / 2
			'halfy = duiFontManager.StringHeight(m_text, m_font) / 2
			m_capx = m_x + (m_width / 2)
			m_capy = m_y + (m_height / 2)
		End If
	End Method
	
'#end region (Render & update methods)
	
'#region Field accessors
	
	Rem
		bbdoc: Set the button text.
		returns: Nothing.
	End Rem
	Method SetText(text:String, dorefresh:Int = True)
		m_text = text
		If dorefresh = True
			Refresh()
		End If
	End Method
	
	Rem
		bbdoc: Get the button's text.
		returns: The button text.
	End Rem
	Method GetText:String()
		Return m_text
	End Method
	
	Rem
		bbdoc: Load the button's texture.
		returns: Nothing.
		about: If @url is a string the texture will be loaded from it.<br/>
		If @url is a dProtogTexture, the texture will be set directly to it.
	End Rem
	Method LoadTexture(url:Object, dorefresh:Int = True)
		Local texture:dProtogTexture
		
		texture = dProtogTexture(url)
		If texture = Null And String(url)
			texture = New dProtogTexture.Create(LoadPixmap(String(url)), 0)
		End If
		SetTexture(texture, dorefresh)
	End Method
	
	Rem
		bbdoc: Set the button's texture.
		returns: Nothing.
		about: If the given texture is Null, and if @dorefresh is True (obviously) the refresh will still occur.
	End Rem
	Method SetTexture(texture:dProtogTexture, dorefresh:Int = True)
		If texture <> Null
			m_buttontexture = texture
		End If
		If dorefresh = True
			Refresh()
		End If
	End Method
	
	Rem
		bbdoc: Get the button's texture.
		returns: The button's texture (which may be Null).
	End Rem
	Method GetTexture:dProtogTexture()
		Return m_buttontexture
	End Method
	
	Rem
		bbdoc: Turn the background drawing for the button on or off.
		returns: Nothing.
	End Rem
	Method SetBackground(background:Int)
		m_background = background
	End Method
	
'#end region (Field accessors)
	
	Rem
		bbdoc: Refresh the skin for the button gadget.
		returns: Nothing.
	End Rem
	Function RefreshSkin(theme:duiTheme)
		m_renderer.Create(theme, "button")
	End Function
	
End Type

