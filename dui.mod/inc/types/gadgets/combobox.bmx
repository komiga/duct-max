
Rem
	combobox.bmx (Contains: dui_TComboBox, )
End Rem

Rem
	bbdoc: The dui combobox gadget type.
End Rem
Type dui_TComboBox Extends dui_TGadget
	
	Global gImage:TImage[9]
	Global gArrowImage:TImage
	
	Field gDefText:String
	Field gText:String
	
	Field gMenu:dui_TMenu
	
		Rem
			bbdoc: Create a combobox.
			returns: The created combobox (itself).
		End Rem
		Method Create:dui_TComboBox(_name:String, _text:String, _x:Float, _y:Float, _w:Float, _h:Float, _mw:Float, _mh:Float, _ih:Float, _parent:dui_TGadget)
			
			PopulateGadget(_name, _x, _y, _w, _h, _parent)
			
			SetBoxText(_text)
			gDefText = _text
			
			'If ih = 0 Then ih = 20
			'If mh = 0 Then mh = 200
			'If mw = 0 Then mw = w
			
			gMenu = New dui_TMenu.Create(_name + ":Menu", _x, _y + _h + 2.0, _mw, _mh, _ih)
			gMenu.gCombo = Self
			Refresh()
			
			Return Self
			
		End Method
		
		Rem
			bbdoc: Render the combobox.
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
				
				SetTextDrawingState()
				DrawText(gText, rX + 5, rY + 3)
				
				SetDrawingState()
				DrawImage(gArrowImage, (rX + gW) - 12, (rY + gH) - 10)
				
				Super.Render(_x, _y)
				
			End If
			
		End Method
		
		Rem
			bbdoc: Update the MouseOver state.
			returns: Nothing.
		End Rem
		Method UpdateMouseOver(_x:Int, _y:Int)
			
			TDUIMain.SetCursor(dui_CURSOR_MOUSEOVER)
			Super.UpdateMouseOver(_x, _y)
			
		End Method
		
		Rem
			bbdoc: Update the MouseDown state.
			returns: Nothing.
		End Rem
		Method UpdateMouseDown(_x:Int, _y:Int)
			
			TDUIMain.SetCursor(dui_CURSOR_MOUSEDOWN)
			Super.UpdateMouseDown(_x, _y)
			
		End Method
		
		Rem
			bbdoc: Update the MouseRelease state.
			returns: Nothing.
		End Rem
		Method UpdateMouseRelease(_x:Int, _y:Int)
			Local rX:Int, rY:Int, aY:Int
			
			If dui_MouseIn(gX + _x, gY + _y, gW, gH)
				
				rX = gX + _x
				rY = gY + _y
				
				' Set up the menu's location
				aY = rY + gH + 2
				If aY + gMenu.gH > TDUIMain.GetScreenHeight()
					aY = (rY - 2) - gMenu.gH
				End If
				
				' Open the combobox list
				Open(rX, aY)
			End If
			
			Super.UpdateMouseRelease(_x, _y)
			
		End Method
		
		Rem
			bbdoc: Set the text drawn on the combobox (the selected text).
			returns: Nothing.
		End Rem
		Method SetBoxText(_text:String)
			
			gText = _text
			
		End Method
			
		Rem
			bbdoc: Update the text (action was made) and post an event.
			returns: Nothing.
		End Rem
		Method UpdateText()
			
			If GetSelectedItemIndex() > - 1
				SetBoxText(GetSelectedItemText())
			Else
				SetBoxText(gDefText)
			End If
			
			New dui_TEvent.Create(dui_EVENT_GADGETSELECT, Self, GetSelectedItemData(), 0, GetSelectedItemIndex(), GetSelectedItemExtra())
			
		End Method
		
		Rem
			bbdoc: Add an item to the combobox by data.
			returns: The created item, or Null if it was not created (unknown reason).
		End Rem
		Method AddItemByData:dui_TTableItem(_text:String, _data:Int = 0, _extra:Object = Null, _dorefresh:Int = True)
			
			Return gMenu.AddItemByData(_text, _data, _extra, _dorefresh)
			
		End Method
		
		Rem
			bbdoc: Add an item to the combobox.
			returns: True if the item was added, or False if it was not added (item is Null).
		End Rem
		Method AddItem:Int(_item:dui_TTableItem, _dorefresh:Int = True)
			
			Return gMenu.AddItem(_item, _dorefresh)
			
		End Method
		
		Rem
			bbdoc: Remove an item from the combobox.
			returns: True if the item was removed, or False if it was not removed (invalid index).
		End Rem
		Method RemoveItemAtIndex:Int(_index:Int)
			
			Return gMenu.RemoveItemAtIndex(_index)
			
		End Method
		
		Rem
			bbdoc: Clear all the items in the combobox.
			returns: Nothing.
		End Rem
		Method ClearItems()
			
			gMenu.ClearItems()
			SetBoxText(gDefText)
			
			'New dui_TEvent.Create(dui_EVENT_GADGETSELECT, Self, GetSelectedItemData(), 0, GetSelectedItemIndex(), Null)
			
		End Method
		
		Rem
			bbdoc: Get the number of items in the combobox.
			returns: The number of items in the combobox.
		End Rem
		Method GetItemCount:Int()
			
			Return gMenu.GetItemCount()
			
		End Method
		
		Rem
			bbdoc: Select an item in the combobox.
			returns: Nothing.
		End Rem
		Method SelectItem(_index:Int)
			
			If gMenu.gTable.HasIndex(_index)
				
				gMenu.SelectItem(_index)
				UpdateText()
				
			End If
			
		End Method
		
		Rem
			bbdoc: Get the selected item.
			returns: The selected item (could be Null).
		End Rem
		Method GetSelectedItem:dui_TTableItem()
			
			Return gMenu.GetSelectedItem()
			
		End Method
		
		Rem
			bbdoc: Get the selected item in the combobox.
			returns: The index of the selected item in the menu (-1 if the combobox is empty).
		End Rem
		Method GetSelectedItemIndex:Int()
			
			Return gMenu.GetSelectedItemIndex()
			
		End Method
		
		Rem
			bbdoc: Get the text of the selected item.
			returns: The text of the selected item.
		End Rem
		Method GetSelectedItemText:String()
			
			Return gMenu.GetSelectedItemContent()
			
		End Method
		
		Rem
			bbdoc: Get the data of the selected item.
			returns: The data of the selected item.
		End Rem
		Method GetSelectedItemData:Int()
			
			Return gMenu.GetSelectedItemData()
			
		End Method
		
		Rem
			bbdoc: Get the extra object of the selected item.
			returns: The extra object of the selected item.
		End Rem
		Method GetSelectedItemExtra:Object()
			
			Return gMenu.GetSelectedItemExtra()
			
		End Method
		
		Rem
			bbdoc: Get an item at the index given.
			returns: The item at the index, or Null if the index was invalid
		End Rem
		Method GetItemAtIndex:dui_TTableItem(_index:Int)
			
			Return gMenu.GetItemAtIndex(_index)
			
		End Method
		
		Rem
			bbdoc: Get the text of an item.
			returns: The text of the item at @_index (could be Null, but that doesn't mean it failed to grab the content).
		End Rem
		Method GetItemContent:String(_index:Int)
			
			Return gMenu.GetItemContent(_index)
			
		End Method
		
		Rem
			bbdoc: Get the data of an item at the index given.
			returns: The data of the item at the index.
		End Rem
		Method GetItemData:Int(_index:Int)
			
			Return gMenu.GetItemData(_index)
			
		End Method
		
		Rem
			bbdoc: Get the extra object of an item at the index given.
			returns: The extra object of the item at the index.
		End Rem
		Method GetItemExtra:Object(_index:Int)
			
			Return gMenu.GetItemExtra(_index)
			
		End Method
		
		Rem
			bbdoc: Set the text of an item at the index given.
			returns: True if the content was set, or False if it was not set (invalid index).
		End Rem
		Method SetItemContent:String(_index:Int, _value:String)
			
			Return gMenu.SetItemContent(_index, _value)
			
		End Method
		
		Rem
			bbdoc: Set the data of an item at the index given.
			returns: True if the data was set, or False if it was not set (invalid index).
		End Rem
		Method SetItemData:Int(_index:Int, _data:Int)
			
			Return gMenu.SetItemData(_index, _data)
			
		End Method
		
		Rem
			bbdoc: Set the extra object of an item at the index given.
			returns: True if the extra object was set, or False if it was not set (invalid index).
		End Rem
		Method SetItemExtra:Int(_index:Int, _extra:Object)
			
			Return gMenu.SetItemExtra(_index, _extra)
			
		End Method
		
		Rem
			bbdoc: Open the combobox selection menu.
			returns: Nothing.
			about: Opens the combobox menu, and generates a dui_EVENT_GADGETOPEN event with the combobox's menu as the extra object.
		End Rem
		Method Open(_x:Float, _y:Float)
			
			gMenu.Activate(_x, _y)
			
			New dui_TEvent.Create(dui_EVENT_GADGETOPEN, Self, 1, 0, 0, gMenu)
			
		End Method
		
		Rem
			bbdoc: Close the combobox selection menu.
			returns: Nothing.
			about: Closes the combo box menu, and generates a dui_EVENT_GADGETCLOSE event with the combobox's menu as the source.
		End Rem
		Method Close()
			
			gMenu.Hide()
			gMenu.Deactivate()
			
		End Method
		
		Rem
			bbdoc: Refresh the skin for the combobox.
			returns: Nothing.
		End Rem
		Function RefreshSkin()
			Local x:Int, y:Int, index:Int, map:Int
			Local image:TImage, mainmap:TPixmap, pixmap:TPixmap[9]
			
			image = LoadImage(TDUIMain.SkinUrl + "/graphics/combobox.png")
			mainmap = LockImage(image)
			
			For index = 0 To 8
				gImage[index] = CreateImage(5, 5)
				pixmap[index] = LockImage(gImage[index])
			Next
			
			For y = 0 To 14
				For x = 0 To 14
					
					map = ((y / 5) * 3) + (x / 5)
					
					pixmap[map].WritePixel((x Mod 5), (y Mod 5), mainmap.ReadPixel(x, y))
					
				Next
			Next
			
			For index = 0 To 8
				UnlockImage(gImage[index])
			Next
			UnlockImage(image)
			
			gArrowImage = LoadImage(TDUIMain.SkinUrl + "/graphics/comboboxarrow.png")
			
		End Function
		
End Type

























