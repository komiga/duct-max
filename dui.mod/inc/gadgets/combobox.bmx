
Rem
	combobox.bmx (Contains: duiComboBox, )
End Rem

Rem
	bbdoc: duct ui combobox gadget.
End Rem
Type duiComboBox Extends duiGadget
	
	Global m_renderer:duiGenericRenderer = New duiGenericRenderer
	
	Field m_defaulttext:String, m_text:String
	Field m_menu:duiMenu
	
	Rem
		bbdoc: Create a combobox.
		returns: The created combobox (itself).
	End Rem
	Method Create:duiComboBox(name:String, text:String, x:Float, y:Float, w:Float, h:Float, menuwidth:Float, menuheight:Float, itemheight:Float, parent:duiGadget)
		_Init(name, x, y, w, h, parent, False)
		
		SetBoxText(text)
		m_defaulttext = text
		
		'If itemheight = 0 Then itemheight = 20
		'If menuheight = 0 Then menuheight = 200
		'If menuwidth = 0 Then menuwidth = w
		
		m_menu = New duiMenu.Create(name + ":Menu", x, y + h + 2.0, menuwidth, menuheight, itemheight)
		m_menu.m_combobox = Self
		Refresh()
		
		Return Self
	End Method
	
'#region Render & update methods
	
	Rem
		bbdoc: Render the combobox.
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
			duiFontManager.RenderString(m_text, m_font, relx + 5, rely + 3)
			
			BindDrawingState()
			m_renderer.RenderSectionToSectionSize("arrow", (relx + m_width) - 12, (rely + m_height) - 10, True)
			
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
		Local relx:Int, rely:Int, ay:Int
		
		If dui_MouseIn(m_x + x, m_y + y, m_width, m_height) = True
			relx = m_x + x
			rely = m_y + y
			
			' Set up the menu's location
			ay = rely + m_height + 2
			If ay + m_menu.m_height > duiMain.GetScreenHeight()
				ay = (rely - 2) - m_menu.m_height
			End If
			
			' Open the combobox list
			Open(relx, ay)
		End If
		
		Super.UpdateMouseRelease(x, y)
	End Method
	
	Rem
		bbdoc: Update the text (action was made) and post an event.
		returns: Nothing.
	End Rem
	Method UpdateText()
		If GetSelectedItemIndex() > - 1
			SetBoxText(GetSelectedItemText())
		Else
			SetBoxText(m_defaulttext)
		End If
		
		New duiEvent.Create(dui_EVENT_GADGETSELECT, Self, GetSelectedItemData(), 0, GetSelectedItemIndex(), GetSelectedItemExtra())
	End Method
	
'#end region (Render & update methods)
	
'#region Field accessors
	
	Rem
		bbdoc: Set the text drawn on the combobox (the selected text).
		returns: Nothing.
	End Rem
	Method SetBoxText(text:String)
		m_text = text
	End Method
	
	Rem
		bbdoc: Set the default text.
		returns: Nothing.
	End Rem
	Method SetDefaultText(text:String)
		m_defaulttext = text
	End Method
	
'#end region (Field accessors)
	
'#region Collections
	
	Rem
		bbdoc: Add an item to the combobox by data.
		returns: The created item, or Null if it was not created (unknown reason).
	End Rem
	Method AddItemByData:duiTableItem(text:String, _data:Int = 0, _extra:Object = Null, dorefresh:Int = True)
		Return m_menu.AddItemByData(text, _data, _extra, dorefresh)
	End Method
	
	Rem
		bbdoc: Add an item to the combobox.
		returns: True if the item was added, or False if it was not added (item is Null).
	End Rem
	Method AddItem:Int(_item:duiTableItem, dorefresh:Int = True)
		Return m_menu.AddItem(_item, dorefresh)
	End Method
	
	Rem
		bbdoc: Remove an item from the combobox.
		returns: True if the item was removed, or False if it was not removed (invalid index).
	End Rem
	Method RemoveItemAtIndex:Int(index:Int)
		Return m_menu.RemoveItemAtIndex(index)
	End Method
	
	Rem
		bbdoc: Clear all the items in the combobox.
		returns: Nothing.
	End Rem
	Method ClearItems()
		m_menu.ClearItems()
		SetBoxText(m_defaulttext)
		
		'New duiEvent.Create(dui_EVENT_GADGETSELECT, Self, GetSelectedItemData(), 0, GetSelectedItemIndex(), Null)
	End Method
	
	Rem
		bbdoc: Get the number of items in the combobox.
		returns: The number of items in the combobox.
	End Rem
	Method GetItemCount:Int()
		Return m_menu.GetItemCount()
	End Method
	
	Rem
		bbdoc: Select an item in the combobox.
		returns: Nothing.
	End Rem
	Method SelectItem(index:Int)
		If m_menu.m_table.HasIndex(index)
			m_menu.SelectItem(index)
			UpdateText()
		End If
	End Method
	
	Rem
		bbdoc: Get the selected item.
		returns: The selected item (could be Null).
	End Rem
	Method GetSelectedItem:duiTableItem()
		Return m_menu.GetSelectedItem()
	End Method
	
	Rem
		bbdoc: Get the selected item in the combobox.
		returns: The index of the selected item in the menu (-1 if the combobox is empty).
	End Rem
	Method GetSelectedItemIndex:Int()
		Return m_menu.GetSelectedItemIndex()
	End Method
	
	Rem
		bbdoc: Get the text of the selected item.
		returns: The text of the selected item.
	End Rem
	Method GetSelectedItemText:String()
		Return m_menu.GetSelectedItemContent()
	End Method
	
	Rem
		bbdoc: Get the data of the selected item.
		returns: The data of the selected item.
	End Rem
	Method GetSelectedItemData:Int()
		Return m_menu.GetSelectedItemData()
	End Method
	
	Rem
		bbdoc: Get the extra object of the selected item.
		returns: The extra object of the selected item.
	End Rem
	Method GetSelectedItemExtra:Object()
		Return m_menu.GetSelectedItemExtra()
	End Method
	
	Rem
		bbdoc: Get an item at the index given.
		returns: The item at the index, or Null if the index was invalid
	End Rem
	Method GetItemAtIndex:duiTableItem(index:Int)
		Return m_menu.GetItemAtIndex(index)
	End Method
	
	Rem
		bbdoc: Get the text of an item.
		returns: The text of the item at @index (could be Null, but that doesn't mean it failed to grab the content).
	End Rem
	Method GetItemContent:String(index:Int)
		Return m_menu.GetItemContent(index)
	End Method
	
	Rem
		bbdoc: Get the data of an item at the index given.
		returns: The data of the item at the index.
	End Rem
	Method GetItemData:Int(index:Int)
		Return m_menu.GetItemData(index)
	End Method
	
	Rem
		bbdoc: Get the extra object of an item at the index given.
		returns: The extra object of the item at the index.
	End Rem
	Method GetItemExtra:Object(index:Int)
		Return m_menu.GetItemExtra(index)
	End Method
	
	Rem
		bbdoc: Set the text of an item at the index given.
		returns: True if the content was set, or False if it was not set (invalid index).
	End Rem
	Method SetItemContent:String(index:Int, _value:String)
		Return m_menu.SetItemContent(index, _value)
	End Method
	
	Rem
		bbdoc: Set the data of an item at the index given.
		returns: True if the data was set, or False if it was not set (invalid index).
	End Rem
	Method SetItemData:Int(index:Int, _data:Int)
		Return m_menu.SetItemData(index, _data)
	End Method
	
	Rem
		bbdoc: Set the extra object of an item at the index given.
		returns: True if the extra object was set, or False if it was not set (invalid index).
	End Rem
	Method SetItemExtra:Int(index:Int, _extra:Object)
		Return m_menu.SetItemExtra(index, _extra)
	End Method
	
'#end region (Collections)
	
'#region Gadget function
	
	Rem
		bbdoc: Open the combobox selection menu.
		returns: Nothing.
		about: Opens the combobox menu, and generates a dui_EVENT_GADGETOPEN event with the combobox's menu as the extra object.
	End Rem
	Method Open(x:Float, y:Float)
		m_menu.Activate(x, y)
		New duiEvent.Create(dui_EVENT_GADGETOPEN, Self, 1, 0, 0, m_menu)
	End Method
	
	Rem
		bbdoc: Close the combobox selection menu.
		returns: Nothing.
		about: Closes the combo box menu, and generates a dui_EVENT_GADGETCLOSE event with the combobox's menu as the source.
	End Rem
	Method Close()
		m_menu.Hide()
		m_menu.Deactivate()
	End Method
	
'#end region (Gadget function)
	
	Rem
		bbdoc: Refresh the skin for the combobox.
		returns: Nothing.
	End Rem
	Function RefreshSkin(theme:duiTheme)
		m_renderer.Create(theme, "combobox")
		m_renderer.AddSectionFromStructure("arrow", True)
	End Function
	
End Type

