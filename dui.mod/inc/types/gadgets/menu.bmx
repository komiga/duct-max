
Rem
	menu.bmx (Contains: dui_Menu, )
End Rem

Rem
	bbdoc: The dui menu gadget type.
	about: Passing indexes as dui_SELECTED_ITEM is a shortcut to use the selected item index.
End Rem
Type dui_Menu Extends dui_Gadget
	
	Global m_renderer:dui_GenericRenderer = New dui_GenericRenderer
	
	Field m_combobox:dui_ComboBox		' Parent combo box gadget (for setting the caption)
	Field m_table:dui_Table			' Table gadget to store the item list
	Field m_maxheight:Int					' Maximum height (do not expand beyond this height)
	
	Rem
		bbdoc: Create a menu.
		returns: The created menu (itself).
	End Rem
	Method Create:dui_Menu(name:String, x:Float, y:Float, w:Float, h:Float, _ih:Float)
		_Init(name, x, y, w, h, Null, False)
		Hide()
		m_table = New dui_Table.Create(name + ":Table", 5.0, 5.0, h - 10.0, "Select", w - 25, _ih, False, Self)
		m_table.SetAlpha(0.3, 1)
		m_table.SetItemHighlight(False)
		m_maxheight = h
		Refresh()
		
		TDUIMain.AddExtra(Self)
		Return Self
	End Method
	
'#region Render & update methods
	
	Rem
		bbdoc: Render the menu.
		returns: Nothing.
	End Rem
	Method Render(x:Float, y:Float)
		If IsVisible() = True
			BindDrawingState()
			m_renderer.RenderCells(x + m_x, y + m_y, Self)
			
			Super.Render(x, y)
		End If
	End Method
	
	Rem
		bbdoc: Update the menu.
		returns: Nothing.
	End Rem
	Method Update(x:Int, y:Int)
		Super.Update(x, y)
		If IsVisible() = True And TDUIMain.IsGadgetActive(Self) = True And MouseDown(1) = True
			UpdateMouseDown(x, y)
		End If
	End Method
	
	Rem
		bbdoc: Update the MouseOver state.
		returns: Nothing.
	End Rem
	Method UpdateMouseDown(x:Int, y:Int)
		Super.UpdateMouseDown(x, y)
		If IsVisible() = True
			' Hide the gadget and generate a close event
			New dui_Event.Create(dui_EVENT_GADGETCLOSE, Self, 0, 0, 0, Self)
			Hide()
		End If
	End Method
	
	Rem
		bbdoc: Refresh the menu.
		returns: Nothing.
	End Rem
	Method Refresh()
		' Refreshes the height of the menu gadget to accomodate items in the table
		m_height = (GetItemCount() * (m_table.m_itemheight + 2)) + 8
		If m_height > m_maxheight Then m_height = m_maxheight
		' Refresh the table size
		m_table.m_height = m_height - 10
		m_table.Refresh()
	End Method
	
'#end region (Render & update methods)
	
'#region Collections
	
	Rem
		bbdoc: Create an item by data and add it to the menu.
		returns: The item it created and added to the menu, or False if the item was not added (created item was Null or other unknown reason).
	End Rem
	Method AddItemByData:dui_TableItem(text:String, _data:Int = 0, _extra:Object = Null, dorefresh:Int = True)
		Local item:dui_TableItem
		
		item = m_table.AddItemByData([text], _data, _extra, dorefresh)
		If dorefresh = True Then Refresh()
		Return item
	End Method
	
	Rem
		bbdoc: Add an item to the menu.
		returns: True if the item was added, or False if it was not added (item is Null).
	End Rem
	Method AddItem:Int(_item:dui_TableItem, dorefresh:Int = True)
		Local succ:Int
		
		succ = m_table.AddItem(_item, dorefresh)
		If dorefresh = True Then Refresh()
		Return succ
	End Method
	
	Rem
		bbdoc: Remove an item from the menu.
		returns: True if the item was removed, or False if it was not removed (invalid index).
	End Rem
	Method RemoveItemAtIndex:Int(index:Int)
		Local success:Int, sindex:Int
		
		success = m_table.RemoveItemAtIndex(index)
		If success = True
			If index = dui_SELECTED_ITEM Or index = m_table.GetSelectedItemIndex()
				If m_table.GetItemCount() = 0 Then sindex = -1
			End If
			Refresh()
		End If
		Return success
	End Method
	
	Rem
		bbdoc: Clear the items in the menu.
		returns: Nothing.
	End Rem
	Method ClearItems()
		m_table.ClearItems()
		SelectItem(- 1)
	End Method
	
	Rem
		bbdoc: Get the number of items in the menu.
		returns: The number of items in the menu.
	End Rem
	Method GetItemCount:Int()
		Return m_table.GetItemCount()
	End Method
	
	Rem
		bbdoc: Select an item in the menu.
		returns: Nothing.
	End Rem
	Method SelectItem(index:Int)
		m_table.SelectItem(index)
		New dui_Event.Create(dui_EVENT_GADGETSELECT, Self, GetSelectedItemData(), 0, index, GetSelectedItemExtra())
	End Method
	
	Rem
		bbdoc: Get the selected item.
		returns: The selected item (could be Null).
	End Rem
	Method GetSelectedItem:dui_TableItem()
		Return m_table.GetSelectedItem()
	End Method
	
	Rem
		bbdoc: Get the selected item in the menu.
		returns: The index of the selected item in the menu (-1 if the menu is empty).
	End Rem
	Method GetSelectedItemIndex:Int()
		Return m_table.GetSelectedItemIndex()
	End Method
	
	Rem
		bbdoc: Get the text of the selected item.
		returns: The text of the selected item.
	End Rem
	Method GetSelectedItemContent:String()
		Return m_table.GetSelectedItemContentAtColumn(0)
	End Method
	
	Rem
		bbdoc: Get the data of the selected item.
		returns: The data of the selected item.
	End Rem
	Method GetSelectedItemData:Int()
		Return m_table.GetSelectedItemData()
	End Method
	
	Rem
		bbdoc: Get the extra object of the selected item.
		returns: The extra object of the selected item.
	End Rem
	Method GetSelectedItemExtra:Object()
		Return m_table.GetSelectedItemExtra()
	End Method
	
	Rem
		bbdoc: Get an item at the index given.
		returns: The item at the index, or Null if the index was invalid
	End Rem
	Method GetItemAtIndex:dui_TableItem(index:Int)
		Return m_table.GetItemAtIndex(index)
	End Method
	
	Rem
		bbdoc: Get the text of an item.
		returns: The text of the item at @index (could be Null, but that doesn't mean it failed to grab the content).
	End Rem
	Method GetItemContent:String(index:Int)
		Return m_table.GetItemContentAtIndex(index, 0)
	End Method
	
	Rem
		bbdoc: Get the data of an item at the index given.
		returns: The data of the item at the index.
	End Rem
	Method GetItemData:Int(index:Int)
		Return m_table.GetItemDataAtIndex(index)
	End Method
	
	Rem
		bbdoc: Get the extra object of an item at the index given.
		returns: The extra object of the item at the index.
	End Rem
	Method GetItemExtra:Object(index:Int)
		Return m_table.GetItemExtraAtIndex(index)
	End Method
	
	Rem
		bbdoc: Set the text of an item at the index given.
		returns: True if the content was set, or False if it was not set (invalid index).
	End Rem
	Method SetItemContent:String(index:Int, _value:String)
		Return m_table.SetItemContentAtIndex(index, 0, _value)
	End Method
	
	Rem
		bbdoc: Set the data of an item at the index given.
		returns: True if the data was set, or False if it was not set (invalid index).
	End Rem
	Method SetItemData:Int(index:Int, _data:Int)
		Return m_table.SetItemDataAtIndex(index, _data)
	End Method
	
	Rem
		bbdoc: Set the extra object of an item at the index given.
		returns: True if the extra object was set, or False if it was not set (invalid index).
	End Rem
	Method SetItemExtra:Int(index:Int, _extra:Object)
		Return m_table.SetItemExtraAtIndex(index, _extra)
	End Method
	
'#end region (Collections)
	
'#region Gadget function
	
	Rem
		bbdoc: Activate the menu.
		returns: Nothing.
		about: This will disable all actions (except for menu actions) until something is selected.
	End Rem
	Method Activate(x:Float, y:Float)
		m_x = x
		m_y = y
		Show()
		TDUIMain.SetActiveGadget(Self)
		'm_table.m_selected = -1
		New dui_Event.Create(dui_EVENT_GADGETOPEN, Self, 1, 0, 0, Null)
	End Method
	
	Rem
		bbdoc: Used internally (or maybe not), should not be used.
		returns: Nothing.
	End Rem
	Method TableSelect()
		If m_combobox <> Null
			m_combobox.UpdateText()
		End If
		Deactivate()
		Hide()
	End Method
	
	Rem
		bbdoc: Deactivate the menu drop-down.
		returns: Nothing.
	End Rem
	Method Deactivate()
		TDUIMain.ClearActiveGadget()
		m_state = STATE_IDLE
		If m_combobox <> Null
			m_combobox.UpdateText()
			New dui_Event.Create(dui_EVENT_GADGETCLOSE, m_combobox, 0, 0, 0, Self)
		End If
		New dui_Event.Create(dui_EVENT_GADGETCLOSE, Self, 0, 0, 0, Null)
	End Method
	
'#end region (Gadget function)
	
	Rem
		bbdoc: Refresh the skin for the menu.
		returns: Nothing.
	End Rem
	Function RefreshSkin(theme:dui_Theme)
		m_renderer.Create(theme, "menu")
	End Function
	
End Type

