
Rem
	table.bmx (Contains: dui_TTable, dui_TTableItem, )
End Rem

Rem
	bbdoc: The dui table gadget type.
	about: Passing indexes as dui_SELECTED_ITEM is a shortcut to use the selected item index.
End Rem
Type dui_TTable Extends dui_TGadget
	
	Field gHeading:String[]				' Headings for the columns
	Field gWidth:Int[]					' Width of the columns
	Field gIH:Int						' Item height
	Field gItems:TList = New TList		' The list of items
	Field gHeader:Int					' Use heading
	
	Field gHighlight:Int = True			' Highlight the selected item
	
	Field gOZ:Int						' Old mouse scroll position
	
	Field gColour:Int[][] = [[DefaultColour[0][0], DefaultColour[0][1], DefaultColour[0][2] ],  ..
	[DefaultColour[1][0], DefaultColour[1][1], DefaultColour[1][2] ],  ..
	[DefaultColour[2][0], DefaultColour[2][1], DefaultColour[2][2] ] ]
	
	Field gTextColour:Int[][] = [[DefaultTextColour[0][0], DefaultTextColour[0][1], DefaultTextColour[0][2] ],  ..
	[DefaultTextColour[1][0], DefaultTextColour[1][1], DefaultTextColour[1][2] ],  ..
	[DefaultTextColour[2][0], DefaultTextColour[2][1], DefaultTextColour[2][2] ] ]
	
	Field gAlpha:Float[] = [DefaultAlpha[0], DefaultAlpha[1], DefaultAlpha[2] ]
	Field gTextAlpha:Float[] = [DefaultTextAlpha[0], DefaultTextAlpha[1], DefaultTextAlpha[2] ]
	
	Field gSelected:Int = -1					' Selected item number
	'Field gSelectedItem:dui_TTableItem			' Selected item row
	
	Field gScroll:dui_TScrollBar				' Scroll bar
	Field gOY:Int								' Y origin for scrolling
	
	Field gHiRow:Int = -1						' Mouse over item row
	Field gHiColumn:Int = -1					' Mouse over item column
	
	Field gBackground:Int[] = [True, True]				' Background states
		
		Rem
			bbdoc: Create a table.
			returns: The created table (itself).
		End Rem
		Method Create:dui_TTable(_name:String, _x:Float, _y:Float, _h:Float, _heading:String, _headingcolwidth:Int, _ih:Float, _header:Int, _parent:dui_TGadget)
			
			PopulateGadget(_name, _x, _y, 0, _h, _parent, False)
			
			gIH = _ih
			If gIH = 0.0 Then gIH = 20.0
			DebugLog("Table Item Height: " + gIH)
			
			SetHeader(_header)
			
			gScroll = New dui_TScrollBar.Create(_name + ":Scroll", _x + 2.0, _y + gIH + 3.0, _h - (gIH + 3.0), 0, 0, _h - (gIH + 3), _parent)
			
			'update increments
			gScroll.SetInc(gIH + 2)
			gScroll.SetBigInc((gIH + 2) * 10)
			
			AddColumn(_heading, _headingcolwidth, False)
			
			Refresh()
			
			Return Self
			
		End Method
		
		Rem
			bbdoc: Render the table.
			returns: Nothing.
		End Rem
		Method Render(_x:Float, _y:Float)
			Local rx:Float, ry:Float, tx:Float, index:Int, itemcount:Int, item:dui_TTableItem
			
			If IsVisible() = True
				
				dui_TFont.SetDrawingFont(gFont)
				SetDrawingState(2)
				
				' Set up rendering locations
				rx = gX + _x
				ry = gY + _y
				
				' Draw the table headings
				If gHeader = True
					If gBackground[1] = True
						
						For index = 0 To gHeading.Length - 1
							
							DrawRect(rx + tx, ry, gWidth[index], gIH)
							tx:+3 + gWidth[index]
							
						Next
						
					End If
					
					' Set the text colour and reset the x location
					SetTextDrawingState(False, 2)
					tx = 3
					
					' Add the text
					For index = 0 To gHeading.Length - 1
						
						DrawText(gHeading[index], rx + tx, ry + 3)
						tx:+3 + gWidth[index]
						
					Next
					
				Else
					
					ry:-(gIH + 2)
					
				End If
				
				TDrawState.Push(False, False, False, False, False, True, False, False)
				dui_SetViewport(rx, ry + gIH + 2, gW, gH - ((gIH + 2) * gHeader))
				
				For item = EachIn gItems
					
					' Update item count
					itemcount:+ 1
					
					' Backgrounds
					If gBackground[0] = True Or itemcount - 1 = gSelected
						
						If itemcount - 1 = gSelected And gHighlight = True
							SetDrawingState(1)
						Else
							SetDrawingState(0)
						End If
						
						tx = 0
						
						For index = 0 To gHeading.Length - 1
							
							If dui_IsInViewport(rx + tx, ry + (itemcount * (gIH + 2)) + gOY, gWidth[index], gIH)
								DrawRect(tx + tx, ry + (itemcount * (gIH + 2)) + gOY, gWidth[index], gIH)
							End If
							
							tx = tx + 3 + gWidth[index]
							
						Next
						
					End If
					
					If itemcount - 1 = gSelected And gHighlight = True
						SetTextDrawingState(False, 1)
					Else
						SetTextDrawingState(False, 0)
					End If
					
					tx = 3
					For index = 0 To gHeading.Length - 1
						
						If dui_IsInViewport((rx + tx) - 3, ry + (itemcount * (gIH + 2)) + gOY, gWidth[index], gIH)
							DrawText(item.GetContentAtIndex(index), rx + tx, ry + 3 + (itemcount * (gIH + 2)) + gOY)
						End If
						
						tx:+3 + gWidth[index]
						
					Next
					
				Next
				
				TDrawState.Pop(False, False, False, False, False, True, False, False)
				
				Super.Render(_x, _y)
				
			End If
			
		End Method
		
		Rem
			bbdoc: Update the table (extended just updates the scrollbar).
			returns: Nothing.
		End Rem
		Method Update(_x:Int, _y:Int)
			
			' Check for values of scrollbar
			gOY = -gScroll.GetValue()
			
			Super.Update(_x, _y)
			
		End Method
		
		Rem
			bbdoc: Update the MouseOver state.
			returns: Nothing.
		End Rem
		Method UpdateMouseOver(_x:Int, _y:Int)
			Local rX:Int, iY:Int, pos:Int, mz:Int, index:Int
			
			TDUIMain.SetCursor(dui_CURSOR_MOUSEOVER)
			
			rX = gX + _x
			iY = gY + _y + gIH + 2 + gOY
			
			If gHeader = False Then iY = iY - (gIH + 2)
			
			Super.UpdateMouseOver(_x, _y)
			
			' If inside the highlight area
			If dui_MouseIn(rX, iY - gOY, gW, gH - ((gIH + 2) * gHeader))
				
				' Calculate the highlighted item from the MouseY position
				gHiRow = (MouseY()  - iY) / (gIH + 2)
				
				' Calculate the column from the MouseX position
				pos = -1
				For index = 0 To gWidth.Length - 1
					pos:+gWidth[index] + 3
					
					If MouseX() - rX < pos
						gHiColumn = index
						Exit
					End If
					
				Next
				
			Else
				
				gHiRow = -1
				gHiColumn = -1
				
			End If
			
			' Moushweeling!
			mz = MouseZ()
			If mz <> gOZ
				If mz > gOZ
					gScroll.SetValue(gScroll.gValue - gScroll.gInc)
				Else
					gScroll.SetValue(gScroll.gValue + gScroll.gInc)
				End If
				
				gOZ = mz
				
			End If
			
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
			Local rX:Int, iY:Int
			Local menu:dui_TMenu, datepanel:dui_TDatePanel, search:dui_TSearchPanel
			
			rX = gX + _x
			iY = gY + _y + gIH + 2
			
			If gHeader = False Then iY = iY - (gIH + 2)
			
			Super.UpdateMouseRelease(_x, _y)
			
			' If inside the highlight area, select an item
			If dui_MouseIn(rX, iY, gW, gH - ((gIH + 2) * gHeader)) And gHiRow < GetItemCount() And gHiRow > - 1
				
				If dui_TDatePanel(gParent) = Null Then SelectItem(gHiRow)
				'DebugLog("Table item row selected: " + gHiRow + " Now: " + GetSelectedItemIndex())
				
				'test parent for menu or date panel (special actions, not the cleanest way but gets it done)
				menu = dui_TMenu(gParent)
				If menu <> Null
					menu.Deactivate()
					menu.Hide()
					Return
				End If
				
				datepanel = dui_TDatePanel(gParent)
				If datepanel <> Null
					If GetItemContentAtIndex(gHiRow, gHiColumn) <> Null
						SelectItem(gHiRow)
						datepanel.Deactivate()
						datepanel.SelectDay(Int(GetItemContentAtIndex(gHiRow, gHiColumn)))
						datepanel.Hide()
					End If
					
					Return
				End If
				
				search = dui_TSearchPanel(gParent)
				If search <> Null
					search.Deactivate()
					Search.SelectItem(GetSelectedItemContentAtColumn(0), GetSelectedItemData())
					search.Hide()
					Return
				End If
				
				New dui_TEvent.Create(dui_EVENT_GADGETSELECT, Self, GetSelectedItem().GetData(), gHiColumn, gHiRow, Null)
				
			End If
			
		End Method
		
		Rem
			bbdoc: Refresh the table.
			returns: Nothing.
		End Rem
		Method Refresh()
			Local index:Int
			
			' Set width, compensating for the gaps between columns
			gW = -3
			For index = 0 To gWidth.Length - 1
				gW:+3 + gWidth[index]
			Next
			
			' Set the position, length and range of the scrollbar
			gScroll.SetPosition(gX + gW + 2, gY + ((gIH + 3) * gHeader))
			gScroll.SetLength(gH - ((gIH + 3) * gHeader))
			gScroll.SetRange(gH - ((gIH + 3) * gHeader))
			
			' Set the max value of the scrollbar
			gScroll.SetMax(((GetItemCount()) * (gIH + 2)) - 2)
			
			If gScroll.GetRange() >= gScroll.GetMax()
				gScroll.Hide()
			Else
				gScroll.Show()
			End If
			
		End Method
		
		Rem
			bbdoc: Set the stabdard drawing state.
			returns: Nothing.
		End Rem
		Method SetDrawingState(_index:Int = 0)
			
			If _index > - 1 And _index < 3
				brl.max2d.SetColor(gColour[_index][0], gColour[_index][1], gColour[_index][2])
				brl.max2d.SetAlpha(gAlpha[_index])
			End If
			
		End Method
		
		Rem
			bbdoc: Set the text drawing state.
			returns: Nothing.
		End Rem
		Method SetTextDrawingState(_setfont:Int = True, _index:Int = 0)
			
			If _index > - 1 And _index < 3
				brl.max2d.SetColor(gTextColour[_index][0], gTextColour[_index][1], gTextColour[_index][2])
				brl.max2d.SetAlpha(gTextAlpha[_index])
				If _setfont = True Then dui_TFont.SetDrawingFont(gFont)
			End If
			
		End Method
		
		Rem
			bbdoc: Set item highlighting on or off.
			returns: Nothing.
			about: If enabled, the selected item will be rendered with the highlight color.
		End Rem
		Method SetItemHighlight(_highlight:Int)
			
			gHighlight = _highlight
			
		End Method
		
		Rem
			bbdoc: Set the table header on or off.
			returns: Nothing.
			about: The table header is the very top of the table (the column description, or column names).
		End Rem
		Method SetHeader(header:Int)
			
			gHeader = header
			
		End Method
		
		Rem
			bbdoc: Set one of the table's colours.
			returns: Nothing.
			about: @_back can be:<br>
			0 - Item background<br>
			1 - Selected item background<br>
			2 - Heading background
		End Rem
		Method SetColour(_r:Int, _g:Int, _b:Int, _index:Int = 0)
			
			If _index > - 1 And _index < 3
				gColour[_index] = [_r, _g, _b]
			End If
			
		End Method
		
		Rem
			bbdoc: Set one of the table's text colours.
			returns: Nothing.
			about: @_index can be:<br>
			0 - Item background<br>
			1 - Selected item background<br>
			2 - Heading background
		End Rem
		Method SetTextColour(_r:Int, _g:Int, _b:Int, _index:Int = 0)
			
			If _index > - 1 And _index < 3
				gTextColour[_index] = [_r, _g, _b]
			End If
			
		End Method
		
		Rem
			bbdoc: Set the alpha value of the table.
			returns: Nothing.
			about: @_index can be:<br>
			0 - Item background<br>
			1 - Selected item background<br>
			2 - Heading background
		End Rem
		Method SetAlpha(_a:Float, _index:Int)
			
			If _index > - 1 And _index < 3
				gAlpha[_index] = _a
			End If
			
		End Method
		
		Rem
			bbdoc: Set the alpha value of the table's text.
			returns: Nothing.
			about: @_index can be:<br>
			0 - Item background<br>
			1 - Selected item background<br>
			2 - Heading background
		End Rem
		Method SetTextAlpha(_a:Float, _index:Int)
			
			If _index > - 1 And _index < 3
				gTextAlpha[_index] = _a
			End If
			
		End Method
		
		Rem
			bbdoc: Set the background drawing state.
			returns: Nothing.
			about: @_index can be:<br>
			0 - The header state
			1 - The table list\items state
		End Rem
		Method SetBackground(_index:Int, _background:Int)
			
			If _index = 0 Or _index = 1
				gBackground[_index] = _background
			End If
			
		End Method
		
		Rem
			bbdoc: Add a column to the table.
			returns: Nothing.
		End Rem
		Method AddColumn(_heading:String, _width:Int = 0, _dorefresh:Int = True)
			
			' Get new array length
			Local nlen:Int = gHeading.Length + 1
			
			' Update headings
			gHeading = gHeading[0..nlen]
			gHeading[nlen - 1] = _heading
			
			'update widths
			gWidth = gWidth[0..nlen]
			gWidth[nlen - 1] = _width
			If gWidth[nlen - 1] < (dui_TFont.GetFontStringWidth(_heading, GetFont()) + 6) Then SetColumnWidth(nlen - 1, dui_TFont.GetFontStringWidth(_heading, GetFont()) + 6)
			
			If _dorefresh = True Then Refresh()
			
		End Method
		
		Rem
			bbdoc: Set the width of a column.
			returns: Nothing.
		End Rem
		Method SetColumnWidth(_column:Int, _width:Int)
			
			If HasColumn(_column) = True
				
				gWidth[_column] = _width
				
			End If
			
		End Method
		
		Rem
			bbdoc: Add an item to the table.
			returns: True if the item was added to the table, or False if it was not added (Null item).
			about: The content of the item will be expanded or trimmed down to fit the size of the table.
		End Rem
		Method AddItem:Int(item:dui_TTableItem, _dorefresh:Int = True)
			
			If item <> Null
				
				' Trim the content/expand the content to fit the table
				item.content = item.Content[0..gHeading.Length]
				
				gItems.AddLast(item)
				
				If _dorefresh = True Then Refresh()
				Return True
				
			End If
			
			Return False
			
		End Method
		
		Rem
			bbdoc: Create an item by data and add it to the table.
			returns: The item it created and added to the table, or False if the item was not added (created item was Null or other unknown reason).
		End Rem
		Method AddItemByData:dui_TTableItem(_text:String[], _data:Int = 0, _extra:Object = Null, _dorefresh:Int = True)
			Local item:dui_TTableItem
			item = New dui_TTableItem.Create(_text, _data, _extra)
			
			If AddItem(item, _dorefresh) = True
				
				Return item
				
			End If
			
			Return Null
			
		End Method
		
		Rem
			bbdoc: Select an item at the given index.
			returns: Nothing.
		End Rem
		Method SelectItem(_index:Int)
			
			If GetItemCount() = 0 Then _index = -1
			
			_index = CorrectIndex(_index)
			
			If HasIndex(_index) = True
				
				gSelected = _index
				'gSelectedItem = dui_TTableItem(gItems.ValueAtIndex(_index))
				
			Else If _index = -1
				
				ClearSelection()
				
			Else
				
				'ClearSelection()
				
			End If
			
		End Method
		
		Rem
			bbdoc: Get the selected item index.
			returns: The selected item index (-1 if nothing is selected).
		End Rem
		Method GetSelectedItemIndex:Int()
		
			Return gSelected
			
		End Method
		
		Rem
			bbdoc: Get the selected item.
			returns: The selected item.
		End Rem
		Method GetSelectedItem:dui_TTableItem()
			
			Return GetItemAtIndex(dui_SELECTED_ITEM)
			
		End Method
		
		Rem
			bbdoc: Get the selected item's content at the given column.
			returns: The content of the selected item (could be Null, but that doesn't mean it failed to grab the content).
		End Rem
		Method GetSelectedItemContentAtColumn:String(_column:Int)
			
			Return GetItemContentAtIndex(dui_SELECTED_ITEM, _column)
			
		End Method
		
		Rem
			bbdoc: Get selected item data.
			returns: The data of the selected item.
		End Rem
		Method GetSelectedItemData:Int()
			
			Return GetItemDataAtIndex(dui_SELECTED_ITEM)
			
		End Method
		
		Rem
			bbdoc: Get selected item extra object.
			returns: The extra object of the selected item.
		End Rem
		Method GetSelectedItemExtra:Object()
			
			Return GetItemExtraAtIndex(dui_SELECTED_ITEM)
			
		End Method
		
		Rem
			bbdoc: Get an item from the table by an index.
			returns: An item, or Null if the index was invalid.
		End Rem
		Method GetItemAtIndex:dui_TTableItem(_index:Int)
			Local item:dui_TTableItem
			
			If HasIndex(_index) = True
				
				_index = CorrectIndex(_index)
				item = dui_TTableItem(gItems.ValueAtIndex(_index))
				If item <> Null
					
					Return item
					
				End If
				
			End If
			
			Return Null
			
		End Method
		
		Rem
			bbdoc: Remove an item from the table by it's index.
			returns: True if the item was removed (in the table), or False if it was not removed.
		End Rem
		Method RemoveItemAtIndex:Int(_index:Int)
			Local item:dui_TTableItem
			
			item = GetItemAtIndex(_index)
			If RemoveItem(item) = True
				
				Refresh()
				Return True
				
			End If
			
			Return False
			
		End Method
		
		Rem
			bbdoc: Remove an item from the table.
			returns: True if the item was removed, or False if it was not removed (the item was not in the table or it was Null).
		End Rem
		Method RemoveItem:Int(_item:dui_TTableItem)
			
			If _item <> Null
				
				gItems.Remove(_item)
				Return True
				
			End If
			
			Return False
			
		End Method
		
		Rem
			bbdoc: Get the number of items in the table.
			returns: The number of items in the table.
		End Rem
		Method GetItemCount:Int()
			
			Return gItems.Count()
			
		End Method
		
		Rem
			bbdoc: Clear all the items in the table.
			returns: Nothing.
		End Rem
		Method ClearItems()
			
			gItems.Clear()
			SelectItem(- 1)
			Refresh()
			
		End Method
		
		Rem
			bbdoc: Clear the selected item.
			returns: Nothing.
		End Rem
		Method ClearSelection()
			
			gSelected = -1
			'gSelectedItem = Null
			
		End Method
		
		Rem
			bbdoc: Get the index of an item which has the data specified.
			returns: An index value (zero-based), or -1 if either @_start (the start at index) is invalid or if @_data did not match any in the table.<br>
		End Rem
		Method FindData:Int(_data:Int, _start:Int = 0)
			Local item:dui_TTableItem, index:Int
			
			If HasIndex(_start) = True
				
				_start = CorrectIndex(_start)
				
				For index = _start To GetItemCount() - 1
					
					item = dui_TTableItem(gItems.ValueAtIndex(index))
					If item <> Null
						
						If item.GetData() = _data Then Return index
						
					End If
					
				Next
				
			End If
			
			Return -1
			
		End Method
		
		Rem
			bbdoc: Get the extra object of an item at the given index.
			returns: The item's extra object, or Null if the index was invalid.
			about: Issue: The item's extra object could be Null, thus you could not distinguish an invalid index from the actual extra object of the item.
		End Rem
		Method GetItemExtraAtIndex:Object(_index:Int)
			Local item:dui_TTableItem
			
			item = GetItemAtIndex(_index)
			If item <> Null
				
				Return item.GetExtra()
				
			End If
			
			Return Null
			
		End Method
		
		Rem
			bbdoc: Get the data of an item at the given index.
			returns: The item's data, or 0 if the index was invalid.
		End Rem
		Method GetItemDataAtIndex:Int(_index:Int)
			Local item:dui_TTableItem
			
			item = GetItemAtIndex(_index)
			If item <> Null
				
				Return item.GetData()
				
			End If
			
			Return 0
			
		End Method
		
		Rem
			bbdoc: Get the extra object of an item at the given index.
			returns: The item's extra object, or Null if the index, or the column, was invalid.
		End Rem
		Method GetItemContentAtIndex:String(_index:Int, _column:Int)
			Local item:dui_TTableItem
			
			If HasColumn(_column) = True
				
				item = GetItemAtIndex(_index)
				If item <> Null
					
					Return item.GetContentAtIndex(_column)
					
				End If
				
			End If
			
			Return Null
			
		End Method
		
		Rem
			bbdoc: Set the content of an item in the table by the given index.
			returns: True if the content was set, or False if it was not (invalid index or invalid column).
		End Rem
		Method SetItemContentAtIndex:Int(_index:Int, _column:Int, _value:String)
			Local item:dui_TTableItem
			
			If HasColumn(_column) = True
				
				item = GetItemAtIndex(_index)
				If item <> Null
					
					item.SetContentAtIndex(_column, _value)
					Return True
					
				End If
				
			End If
			
			Return False
			
		End Method
		
		Rem
			bbdoc: Set the whole content array for a given item.
			returns: True if the content array was set, or False if it was not (invalid index or Null value).
		End Rem
		Method SetItemAllContentAtIndex:Int(_index:Int, _value:String[])
			Local item:dui_TTableItem
			
			If _value <> Null
				
				item = GetItemAtIndex(_index)
				If item <> Null
					
					item.SetContent(_value)
					Return True
					
				End If
				
			End If
			
			Return False
			
		End Method
		
		Rem
			bbdoc: Set the extra object of an item at the given index.
			returns: True if the extra object was set, or False if the value was not set (index was invalid - extra object @can be Null).
		End Rem
		Method SetItemExtraAtIndex:Int(_index:Int, _extra:Object)
			Local item:dui_TTableItem
			
			item = GetItemAtIndex(_index)
			If item <> Null
				
				item.SetExtra(_extra)
				Return True
				
			End If
			
			Return False
			
		End Method
		
		Rem
			bbdoc: Set the item data at the given index.
			returns: True if the data was set, False if it was not (index was invalid).
		End Rem
		Method SetItemDataAtIndex:Int(_index:Int, _data:Int)
			Local item:dui_TTableItem
			
			item = GetItemAtIndex(_index)
			If item <> Null
				
				item.SetData(_data)
				
			End If
			
			Return False
			
		End Method
		
		Rem
			bbdoc: Check if the given column is valid.
			returns: True if the column is within range of the table column count, False if it was invalid.
		End Rem
		Method HasColumn:Int(_column:Int)
			
			If _column > - 1 And _column < gHeading.Length
				
				Return True
				
			End If
			
			Return False
			
		End Method
		
		Rem
			bbdoc: Check if the given index is valid.
			returns: True if the index is within range of the table item count, False if it was invalid.
			about: This calls #CorrectIndex on @_index.
		End Rem
		Method HasIndex:Int(_index:Int)
			
			_index = CorrectIndex(_index)
			
			If _index > - 1 And _index < GetItemCount()
				
				Return True
				
			End If
			
			Return False
			
		End Method
		
		Rem
			bbdoc: Correct the index using certain table rules.
			returns: #SelectedItem if @_index is dui_SELECTED_ITEM, otherwise it returns @_index.
		End Rem
		Method CorrectIndex:Int(_index:Int)
			
			If _index = dui_SELECTED_ITEM Then _index = GetSelectedItemIndex()
			
			Return _index
			
		End Method
		
End Type


Rem
	bbdoc: The dui table item type.
End Rem
Type dui_TTableItem
	
	Field content:String[]			' The content of the item
	Field extra:Object				' An extra object
	Field data:Int					' Extra integer data
		
		Rem
			bbdoc: Create an item.
			returns: The created item (itself).
		End Rem
		Method Create:dui_TTableItem(_content:String[], _data:Int, _extra:Object = Null)
			
			SetContent(_content)
			SetExtra(_extra)
			SetData(_data)
			
			Return Self
			
		End Method
		
		Rem
			bbdoc: Set the content array for the item.
			returns: Nothing.
		End Rem
		Method SetContent(_value:String[])
			
			content = _value
			
		End Method
		
		Rem
			bbdoc: Set the content at a given index.
			returns: True if the content was set, or False if it was not (invalid index).
		End Rem
		Method SetContentAtIndex:Int(_index:Int, _value:String)
			
			If HasIndex(_index) = True
				
				content[_index] = _value
				Return True
				
			End If
			
			Return False
			
		End Method
		
		Rem
			bbdoc: Get the content array of the item.
			returns: The content array of the item.
		End Rem
		Method GetContent:String[] ()
			
			Return content
			
		End Method
		
		Rem
			bbdoc: Get the content of the item at an index.
			returns: The content for the given index, or Null if the index was invalid.
			about: Issue: By just using this method there is no certain way to distinguish between an invalid index and a Null value (the value for that index was Null).
		End Rem
		Method GetContentAtIndex:String(_index:Int)
			
			If HasIndex(_index) = True
				
				Return content[_index]
				
			End If
			
			Return Null
			
		End Method
		
		Rem
			bbdoc: Set the extra object for the item.
			returns: Nothing.
		End Rem
		Method SetExtra(_value:Object)
			
			extra = _value
			
		End Method
		
		Rem
			bbdoc: Get the extra object of the item.
			returns: The extra object for the item (might be Null).
		End Rem
		Method GetExtra:Object()
			
			Return extra
			
		End Method
		
		Rem
			bbdoc: Set the data of the item.
			returns: Nothing.
		End Rem
		Method SetData(_value:Int)
			
			data = _value
			
		End Method
		
		Rem
			bbdoc: Get the data of the item.
			returns: The data of the item.
		End Rem
		Method GetData:Int()
		
			Return data
			
		End Method
		
		Rem
			bbdoc: Check if the item has the given index.
			returns: True if the item has the index, False if it does not.
		End Rem
		Method HasIndex:Int(_index:Int)
			
			If _index > - 1 And _index < content.Length
				
				Return True
				
			End If
			
			Return False
			
		End Method
		
End Type





























