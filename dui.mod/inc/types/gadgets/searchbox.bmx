
Rem
	searchbox.bmx (Contains: dui_SearchBox, )
End Rem

Rem
	bbdoc: The dui search box gadget type.
End Rem
Type dui_SearchBox Extends dui_Gadget

	Global m_renderer:dui_GenericRenderer = New dui_GenericRenderer
	
	Field m_text:String
	Field m_data:Int
	Field m_nullvalue:Int
	
	Field m_searchfunction(searchbox:dui_SearchBox, text:String)
	Field m_searchpanel:dui_SearchPanel
	
	Rem
		bbdoc: Create a search box gadget.
		returns: The created search box.
	End Rem
	Method Create:dui_SearchBox(name:String, x:Float, y:Float, w:Float, h:Float, panelwidth:Float, panelheight:Float, itemheight:Int, nullvalue:Int, parent:dui_Gadget)
		_Init(name, x, y, w, h, parent, False)
		
		m_searchpanel = New dui_SearchPanel.Create(name + ":SearchPanel", panelwidth, panelheight, itemheight, Self)
		SetNullValue(nullvalue)
		SetSelectedText(Null)
		Return Self
	End Method
	
	Rem
		bbdoc: Called when a search is performed.
		returns: Nothing.
		about: Extend this method or use the search callback (see #SetSearchCallback).
	End Rem
	Method OnSearch(text:String)
	End Method
	
'#region Render & update methods
	
	Rem
		bbdoc: Render the search box.
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
			m_renderer.RenderSectionToSectionSize("glass", relx + m_width - 16, rely + ((m_height - 2) / 2) - 4)
			
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
		
		relx = m_x + x
		rely = m_y + y
		
		ay = rely + m_height + 2
		If ay + m_searchpanel.m_height > TDUIMain.m_height
			ay = (rely - 2) - m_searchpanel.m_height
		End If
		Open(relx, ay)
		
		Super.UpdateMouseRelease(x, y)
	End Method
	
'#end region (Render & update methods)
	
'#region Field accessors
	
	Rem
		bbdoc: Set the text for the search box.
		returns: Nothing.
	End Rem
	Method SetText(text:String)
		m_text = text
	End Method
	Rem
		bbdoc: Get the text for the search box.
		returns: The search box's text.
	End Rem
	Method GetText:String()
		Return m_text
	End Method
	
	Rem
		bbdoc: Set the data for the search box.
		returns: Nothing.
	End Rem
	Method SetData(data:Int)
		m_data = data
	End Method
	Rem
		bbdoc: Get the data for the search box.
		returns: The search box's data.
	End Rem	
	Method GetData:Int()
		Return m_data
	End Method
	
	Rem
		bbdoc: Set the null value for a null/empty search.
		returns: Nothing.
	End Rem
	Method SetNullValue(nullvalue:Int)
		m_nullvalue = nullvalue
	End Method
	Rem
		bbdoc: Get the null value (used for null/empty searches).
		returns: The null value.
	End Rem
	Method GetNullValue:Int()
		Return m_nullvalue
	End Method
	
	Rem
		bbdoc: Set the selected text.
		returns: Nothing.
	End Rem
	Method SetSelectedText(text:String, data:Int = 0)
		If text = Null
			text = "[None]"
			data = m_nullvalue
		End If
		
		SetText(text)
		SetData(data)
	End Method
	
	Rem
		bbdoc: Set the search function callback.
		returns: Nothing.
		about: You can either set this function or extend this type and the #OnSearch method.
	End Rem
	Method SetSearchCallback(callback(searchbox:dui_SearchBox, text:String))
		m_searchfunction = callback
	End Method
	
'#end region (Field accessors)
	
'#region Collections
	
	Rem
		bbdoc: Clear the search box.
		returns: Nothing.
	End Rem
	Method ClearItems()
		m_searchpanel.m_results.ClearItems()
	End Method
	
	Rem
		bbdoc: Add an item to the search box.
		returns: Nothing.
	End Rem
	Method AddItem(text:String, data:Int)
		m_searchpanel.m_results.AddItemByData([text], data, Null)
	End Method
	
'#end region (Collections)
	
'#region Function
	
	Rem
		bbdoc: Search for the given text.
		returns: Nothing.
		about: This calls the search function callback.
	End Rem
	Method Search(text:String)
		If m_searchfunction <> Null
			m_searchfunction(Self, text)
		End If
		OnSearch(text)
	End Method
	
	Rem
		bbdoc: Open the search panel.
		returns: Nothing.
		about: Opens the search panel, and generates a dui_EVENT_GADGETOPEN event.
	End Rem
	Method Open(x:Float, y:Float)
		m_searchpanel.Activate(x, y)
		New dui_Event.Create(dui_EVENT_GADGETOPEN, Self, 1, 0, 0, m_searchpanel)
	End Method
	
	Rem
		bbdoc: Close the search panel.
		returns: Nothing.
		about: Closes the search panel, and generates a dui_EVENT_GADGETCLOSE event.
	End Rem
	Method Close()
		m_searchpanel.Hide()
		m_searchpanel.Deactivate()
	End Method
	
'#end region (Function)
	
	Rem
		bbdoc: Refresh the searchbox skin.
		returns: Nothing.
	End Rem
	Function RefreshSkin(theme:dui_Theme)
		m_renderer.Create(theme, "searchbox")
		m_renderer.AddSectionFromStructure("glass", True)
	End Function
	
End Type















