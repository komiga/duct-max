
Rem
	menu.bmx (Contains: dui_TMenu, )
End Rem

Rem
	bbdoc: The dui menu gadget type.
	about: Passing indexes as dui_SELECTED_ITEM is a shortcut to use the selected item index.
End Rem
Type dui_TMenu Extends dui_TGadget
	
	Global gImage:TImage[9]
				
	Field gCombo:dui_TComboBox		' Parent combo box gadget (for setting the caption)
	Field gTable:dui_TTable			' Table gadget to store the item list
	Field gMaxH:Int					' Maximum height (do not expand beyond this height)
	
	Rem
		bbdoc: Create a menu.
		returns: The created menu (itself).
	End Rem
	Method Create:dui_TMenu(_name:String, _x:Float, _y:Float, _w:Float, _h:Float, _ih:Float)
		PopulateGadget(_name, _x, _y, _w, _h, Null, False)
		Hide()
		gTable = New dui_TTable.Create(_name + ":Table", 5.0, 5.0, _h - 10.0, "Select", _w - 25, _ih, False, Self)
		gTable.SetAlpha(0.3, 1)
		gTable.SetItemHighlight(False)
		gMaxH = _h
		Refresh()
		
		TDUIMain.AddExtra(Self)
		Return Self
	End Method
	
	Rem
		bbdoc: Render the menu.
		returns: Nothing.
	End Rem
	Method Render(_x:Float, _y:Float)
		Local rX:Float, rY:Float
		
		If IsVisible() = True
			
			SetDrawingState()
			
			rX = gX + _x
			rY = gY + _y
				
			' Draw four corners
			DrawImage(gImage[0], rX, rY)
			DrawImage(gImage[2], (rX + gW) - 5, rY)
			DrawImage(gImage[6], rX, (rY + gH) - 5)
			DrawImage(gImage[8], (rX + gW) - 5, (rY + gH) - 5)
			
			' Draw four sides
			DrawImageRect(gImage[1], rX + 5, rY, gW - 10, 5)
			DrawImageRect(gImage[7], rX + 5, (rY + gH) - 5, gW - 10, 5)
			DrawImageRect(gImage[3], rX, rY + 5, 5, gH - 10)
			DrawImageRect(gImage[5], (rX + gW) - 5, rY + 5, 5, gH - 10)
			
			' Draw centre
			DrawImageRect(gImage[4], rX + 5, rY + 5, gW - 10, gH - 10)
			Super.Render(_x, _y)
		End If
	End Method
	
	Rem
		bbdoc: Update the menu.
		returns: Nothing.
	End Rem
	Method Update(_x:Int, _y:Int)
		Super.Update(_x, _y)
		' Check to see if the mouse is down, regardless of location
		If IsVisible() = True And TDUIMain.IsGadgetActive(Self) And MouseDown(1)
			UpdateMouseDown(_x, _y)
		End If
	End Method
	
	Rem
		bbdoc: Update the MouseOver state.
		returns: Nothing.
	End Rem
	Method UpdateMouseDown(_x:Int, _y:Int)
		Super.UpdateMouseDown(_x, _y)
		If IsVisible() = True
			' Hide the gadget and generate a close event
			New dui_TEvent.Create(dui_EVENT_GADGETCLOSE, Self, 0, 0, 0, Self)
			Hide()
		End If
	End Method
	
	Rem
		bbdoc: Refresh the menu.
		returns: Nothing.
	End Rem
	Method Refresh()
		' Refreshes the height of the menu gadget to accomodate items in the table
		gH = (GetItemCount() * (gTable.gIH + 2)) + 8
		If gH > gMaxH Then gH = gMaxH
		' Refresh the table size
		gTable.gH = gH - 10
		gTable.Refresh()
	End Method
	
	Rem
		bbdoc: Create an item by data and add it to the menu.
		returns: The item it created and added to the menu, or False if the item was not added (created item was Null or other unknown reason).
	End Rem
	Method AddItemByData:dui_TTableItem(_text:String, _data:Int = 0, _extra:Object = Null, _dorefresh:Int = True)
		Local item:dui_TTableItem
		
		item = gTable.AddItemByData([_text], _data, _extra, _dorefresh)
		If _dorefresh = True Then Refresh()
		Return item
	End Method
	
	Rem
		bbdoc: Add an item to the menu.
		returns: True if the item was added, or False if it was not added (item is Null).
	End Rem
	Method AddItem:Int(_item:dui_TTableItem, _dorefresh:Int = True)
		Local succ:Int
		
		succ = gTable.AddItem(_item, _dorefresh)
		If _dorefresh = True Then Refresh()
		Return succ
	End Method
	
	Rem
		bbdoc: Remove an item from the menu.
		returns: True if the item was removed, or False if it was not removed (invalid index).
	End Rem
	Method RemoveItemAtIndex:Int(_index:Int)
		Local success:Int, sindex:Int
		
		success = gTable.RemoveItemAtIndex(_index)
		If success = True
			If _index = dui_SELECTED_ITEM Or _index = gTable.GetSelectedItemIndex()
				If gTable.GetItemCount() = 0 Then sindex = -1
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
		gTable.ClearItems()
		SelectItem(- 1)
	End Method
	
	Rem
		bbdoc: Get the number of items in the menu.
		returns: The number of items in the menu.
	End Rem
	Method GetItemCount:Int()
		Return gTable.GetItemCount()
	End Method
	
	Rem
		bbdoc: Select an item in the menu.
		returns: Nothing.
	End Rem
	Method SelectItem(_index:Int)
		gTable.SelectItem(_index)
		New dui_TEvent.Create(dui_EVENT_GADGETSELECT, Self, GetSelectedItemData(), 0, _index, GetSelectedItemExtra())
	End Method
	
	Rem
		bbdoc: Get the selected item.
		returns: The selected item (could be Null).
	End Rem
	Method GetSelectedItem:dui_TTableItem()
		Return gTable.GetSelectedItem()
	End Method
	
	Rem
		bbdoc: Get the selected item in the menu.
		returns: The index of the selected item in the menu (-1 if the menu is empty).
	End Rem
	Method GetSelectedItemIndex:Int()
		Return gTable.GetSelectedItemIndex()
	End Method
	
	Rem
		bbdoc: Get the text of the selected item.
		returns: The text of the selected item.
	End Rem
	Method GetSelectedItemContent:String()
		Return gTable.GetSelectedItemContentAtColumn(0)
	End Method
	
	Rem
		bbdoc: Get the data of the selected item.
		returns: The data of the selected item.
	End Rem
	Method GetSelectedItemData:Int()
		Return gTable.GetSelectedItemData()
	End Method
	
	Rem
		bbdoc: Get the extra object of the selected item.
		returns: The extra object of the selected item.
	End Rem
	Method GetSelectedItemExtra:Object()
		Return gTable.GetSelectedItemExtra()
	End Method
	
	Rem
		bbdoc: Get an item at the index given.
		returns: The item at the index, or Null if the index was invalid
	End Rem
	Method GetItemAtIndex:dui_TTableItem(_index:Int)
		Return gTable.GetItemAtIndex(_index)
	End Method
	
	Rem
		bbdoc: Get the text of an item.
		returns: The text of the item at @_index (could be Null, but that doesn't mean it failed to grab the content).
	End Rem
	Method GetItemContent:String(_index:Int)
		Return gTable.GetItemContentAtIndex(_index, 0)
	End Method
	
	Rem
		bbdoc: Get the data of an item at the index given.
		returns: The data of the item at the index.
	End Rem
	Method GetItemData:Int(_index:Int)
		Return gTable.GetItemDataAtIndex(_index)
	End Method
	
	Rem
		bbdoc: Get the extra object of an item at the index given.
		returns: The extra object of the item at the index.
	End Rem
	Method GetItemExtra:Object(_index:Int)
		Return gTable.GetItemExtraAtIndex(_index)
	End Method
	
	Rem
		bbdoc: Set the text of an item at the index given.
		returns: True if the content was set, or False if it was not set (invalid index).
	End Rem
	Method SetItemContent:String(_index:Int, _value:String)
		Return gTable.SetItemContentAtIndex(_index, 0, _value)
	End Method
	
	Rem
		bbdoc: Set the data of an item at the index given.
		returns: True if the data was set, or False if it was not set (invalid index).
	End Rem
	Method SetItemData:Int(_index:Int, _data:Int)
		Return gTable.SetItemDataAtIndex(_index, _data)
	End Method
	
	Rem
		bbdoc: Set the extra object of an item at the index given.
		returns: True if the extra object was set, or False if it was not set (invalid index).
	End Rem
	Method SetItemExtra:Int(_index:Int, _extra:Object)
		Return gTable.SetItemExtraAtIndex(_index, _extra)
	End Method
	
	Rem
		bbdoc: Activate the menu.
		returns: Nothing.
		about: This will disable all actions (except for menu actions) until something is selected.
	End Rem
	Method Activate(_x:Int, _y:Int)
		gX = _x
		gY = _y
		Show()
		TDUIMain.SetActiveGadget(Self)
		'gTable.gSelected = -1
		New dui_TEvent.Create(dui_EVENT_GADGETOPEN, Self, 1, 0, 0, Null)
	End Method
	
	Rem
		bbdoc: Used internally (or maybe not), should not be used.
		returns: Nothing.
	End Rem
	Method TableSelect()
		If gCombo <> Null Then gCombo.UpdateText()
		Deactivate()
		Hide()
	End Method
	
	Rem
		bbdoc: Deactivate the menu drop-down.
		returns: Nothing.
	End Rem
	Method Deactivate()
		TDUIMain.ClearActiveGadget()
		gState = IDLE_STATE
		If gCombo <> Null
			gCombo.UpdateText()
			New dui_TEvent.Create(dui_EVENT_GADGETCLOSE, gCombo, 0, 0, 0, Self)
		End If
		New dui_TEvent.Create(dui_EVENT_GADGETCLOSE, Self, 0, 0, 0, Null)
	End Method
	
	Rem
		bbdoc: Refresh the skin for the menu.
		returns: Nothing.
	End Rem
	Function RefreshSkin()
		Local index:Int, x:Int, y:Int, map:Int
		Local image:TImage, mainmap:TPixmap, pixmap:TPixmap[9]
		
		image = LoadImage(TDUIMain.SkinUrl + "/graphics/menu.png")
		mainmap = LockImage(image)
		
		For index = 0 To 8
			gImage[index] = CreateImage(5, 5)
			pixmap[index] = LockImage(gImage[index])
		Next
		
		For y = 0 To 14
			For x = 0 To 14
				' Get correct pixmap to write to
				map = ((y / 5) * 3) + (x / 5)
				pixmap[map].WritePixel((x Mod 5), (y Mod 5), mainmap.ReadPixel(x, y))
			Next
		Next
		
		For index = 0 To 8
			UnlockImage(gImage[index])
		Next
		UnlockImage(image)
	End Function
	
End Type




























