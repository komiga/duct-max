
Rem
	searchpanel.bmx (Contains: dui_SearchPanel, )
End Rem

Rem
	bbdoc: The dui search panel gadget type.
End Rem
Type dui_SearchPanel Extends dui_Gadget
	
	Global m_renderer:dui_GenericRenderer = New dui_GenericRenderer
	
	Field m_searchbox:dui_SearchBox	' Search box
	Field m_searchfield:dui_TextField		' Search text field
	Field m_results:dui_Table			' Search results
	Field m_nullbutton:dui_Button			' Null button, to set chosen data to -1
	
	Rem
		bbdoc: Create a search panel gadget.
		returns: The created search panel.
	End Rem
	Method Create:dui_SearchPanel(name:String, width:Float, height:Float, itemheight:Float, search:dui_SearchBox)
		If width = 0.0
			width = search.m_width
		End If
		If height = 0.0
			height = 200.0
		End If
		_Init(name, 0, 0, width, height, Null, False)
		
		' Add to the extra list BEFORE its children
		TDUIMain.AddExtra(Self)
		
		m_nullbutton = New dui_Button.Create(name + ":NullButton", "None", Null, 5, 5, 40, 20, Self)
		m_searchfield = New dui_TextField.Create(name + ":SearchField", "", 50, 5, width - 55, 20, True, Self)
		m_results = New dui_Table.Create(name + ":ResultsTable", 5, 30, height - 35, "", width - 28, itemheight, False, Self)
		
		m_searchbox = search
		Hide()
		Return Self
	End Method
	
'#region Render & update methods
	
	Rem
		bbdoc: Render the search panel.
		returns: Nothing.
	End Rem
	Method Render(x:Float, y:Float)
		Local relx:Float, rely:Float
		
		If IsVisible() = True
			relx = m_x + x
			rely = m_y + y
			
			BindDrawingState()
			m_renderer.RenderCells(relx, rely, Self)
			Super.Render(x, y)
		End If
	End Method
	
	Rem
		bbdoc: Update the search panel.
		returns: Nothing.
	End Rem
	Method Update(x:Int, y:Int)
		Super.Update(x, y)
		If TDUIMain.IsGadgetActive(Self) = True And MouseDown(1) = True And IsVisible() = True
			UpdateMouseDown(x, y)
		End If
	End Method
	
	Rem
		bbdoc: Update the MouseDown state.
		returns: Nothing.
	End Rem
	Method UpdateMouseDown(x:Int, y:Int)
		Super.UpdateMouseDown(x, y)
		If IsVisible() = True
			New dui_Event.Create(dui_EVENT_GADGETCLOSE, Self, 0, 0, 0, Self)
			Hide()
		End If
	End Method
	
'#end region (Render & update methods)
	
'#region Function
	
	Rem
		bbdoc: Activate the search panel.
		returns: Nothing.
	End Rem
	Method Activate(x:Float, y:Float)
		SetPosition(x, y)
		Show()
		TDUIMain.SetActiveGadget(Self)
		New dui_Event.Create(dui_EVENT_GADGETOPEN, Self, 1, 0, 0, Null)
	End Method
	
	Rem
		bbdoc: Deactivate the search panel.
		returns: Nothing.
	End Rem
	Method Deactivate()
		TDUIMain.ClearActiveGadget()
		m_state = STATE_IDLE
		New dui_Event.Create(dui_EVENT_GADGETCLOSE, m_searchbox, 0, 0, 0, Null)
	End Method
		
	Rem
		bbdoc: Select an item in the search panel by the text given.
		returns: Nothing.
	End Rem
	Method SelectItem(text:String, _data:Int = 0)
		m_searchbox.SetSelectedText(text, _data)
	End Method
	
'#end region (Function)
	
	Rem
		bbdoc: Refresh the search panel skin.
		returns: Nothing.
	End Rem
	Function RefreshSkin(theme:dui_Theme)
		m_renderer.Create(theme, "searchpanel")
	End Function
	
End Type

