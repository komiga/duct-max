
Rem
	table.bmx (Contains: dui_Table, dui_TableItem, )
End Rem

Rem
	bbdoc: The dui table gadget type.
	about: Passing indexes as dui_SELECTED_ITEM is a shortcut to use the selected item index.
End Rem
Type dui_Table Extends dui_Gadget
	
	Field m_heading:String[]				' Headings for the columns
	Field m_columnwidths:Int[]					' Width of the columns
	Field m_itemheight:Int						' Item height
	Field m_items:TListEx = New TListEx	' The list of items
	Field m_header:Int					' Use heading
	
	Field m_highlight:Int = True			' Highlight the selected item
	
	Field m_selected:Int = -1					' Selected item number
	'Field m_selecteditem:dui_TableItem			' Selected item row
	
	Field m_scroll:dui_ScrollBar				' Scroll bar
	Field m_oldy:Int								' Y origin for scrolling
	
	Field m_hirow:Int = -1						' Mouse over item row
	Field m_hicolumn:Int = -1					' Mouse over item column
	
	Field m_background:Int[] = [True, True]				' Background states
	
	Rem
		bbdoc: Create a table.
		returns: The created table (itself).
	End Rem
	Method Create:dui_Table(name:String, x:Float, y:Float, h:Float, heading:String, headingcolwidth:Int, itemheight:Float, header:Int, parent:dui_Gadget)
		_Init(name, x, y, 0, h, parent, False)
		
		m_itemheight = itemheight
		If m_itemheight = 0.0
			m_itemheight = 20.0
		End If
		
		SetHeader(header)
		
		m_scroll = New dui_ScrollBar.Create(name + ":Scroll", x + 2.0, y + m_itemheight + 3.0, h - (m_itemheight + 3.0), 0, 0, h - (m_itemheight + 3), parent)
		'update increments
		m_scroll.SetInc(m_itemheight + 2)
		m_scroll.SetBigInc((m_itemheight + 2) * 10)
		
		AddColumn(heading, headingcolwidth, False)
		Refresh()
		Return Self
	End Method
	
'#region Render & update methods
	
	Rem
		bbdoc: Render the table.
		returns: Nothing.
	End Rem
	Method Render(x:Float, y:Float)
		Local rx:Float, ry:Float, tx:Float
		Local index:Int, itemcount:Int, item:dui_TableItem
		
		If IsVisible() = True
			' Set up rendering locations
			rx = m_x + x
			ry = m_y + y
			
			BindDrawingState(2)
			' Draw the table headings
			If m_header = True
				If m_background[1] = True
					For index = 0 To m_heading.Length - 1
						TProtogPrimitives.DrawRectangleToSize(rx + tx, ry, m_columnwidths[index], m_itemheight)
						tx:+3 + m_columnwidths[index]
					Next
				End If
				
				' Set the text color and reset the x location
				BindTextDrawingState(2)
				tx = 3
				' Add the text
				For index = 0 To m_heading.Length - 1
					dui_FontManager.RenderString(m_heading[index], m_font, rx + tx, ry + 3)
					tx:+3 + m_columnwidths[index]
				Next
			Else
				ry:-(m_itemheight + 2)
			End If
			
			TProtogDrawState.Push(False, False, False, True, False, False)
			dui_SetViewport(rx, ry + m_itemheight + 2, m_width, m_height - ((m_itemheight + 2) * m_header))
			
			For item = EachIn m_items
				' Update item count
				itemcount:+ 1
				' Backgrounds
				If m_background[0] = True Or itemcount - 1 = m_selected
					If itemcount - 1 = m_selected And m_highlight = True
						BindDrawingState(1)
					Else
						BindDrawingState(0)
					End If
					
					tx = 0
					For index = 0 To m_heading.Length - 1
						If dui_IsInViewport(rx + tx, ry + (itemcount * (m_itemheight + 2)) + m_oldy, m_columnwidths[index], m_itemheight)
							TProtogPrimitives.DrawRectangleToSize(rx + tx, ry + (itemcount * (m_itemheight + 2)) + m_oldy, m_columnwidths[index], m_itemheight, True)
						End If
						tx = tx + 3 + m_columnwidths[index]
					Next
				End If
				
				If itemcount - 1 = m_selected And m_highlight = True
					BindTextDrawingState(1)
				Else
					BindTextDrawingState(0)
				End If
				
				tx = 3
				For index = 0 To m_heading.Length - 1
					If dui_IsInViewport((rx + tx) - 3, ry + (itemcount * (m_itemheight + 2)) + m_oldy, m_columnwidths[index], m_itemheight)
						dui_FontManager.RenderString(item.GetContentAtIndex(index), m_font, rx + tx, ry + 3 + (itemcount * (m_itemheight + 2)) + m_oldy)
					End If
					tx:+3 + m_columnwidths[index]
				Next
			Next
			
			TProtogDrawState.Pop(False, False, False, True, False, False)
			Super.Render(x, y)
		End If
	End Method
	
	Rem
		bbdoc: Update the table (extended just updates the scrollbar).
		returns: Nothing.
	End Rem
	Method Update(x:Int, y:Int)
		' Check for values of scrollbar
		m_oldy = -m_scroll.GetValue()
		Super.Update(x, y)
	End Method
	
	Rem
		bbdoc: Update the MouseOver state.
		returns: Nothing.
	End Rem
	Method UpdateMouseOver(x:Int, y:Int)
		Local relx:Int, iY:Int, pos:Int, mz:Int, index:Int
		
		TDUIMain.SetCursor(dui_CURSOR_MOUSEOVER)
		relx = m_x + x
		iY = m_y + y + m_itemheight + 2 + m_oldy
		
		If m_header = False Then iY = iY - (m_itemheight + 2)
		Super.UpdateMouseOver(x, y)
		
		' If inside the highlight area
		If dui_MouseIn(relx, iY - m_oldy, m_width, m_height - ((m_itemheight + 2) * m_header))
			' Calculate the highlighted item from the MouseY position
			m_hirow = (MouseY()  - iY) / (m_itemheight + 2)
			' Calculate the column from the MouseX position
			pos = -1
			For index = 0 To m_columnwidths.Length - 1
				pos:+m_columnwidths[index] + 3
				If MouseX() - relx < pos
					m_hicolumn = index
					Exit
				End If
			Next
		Else
			m_hirow = -1
			m_hicolumn = -1
		End If
		
		' Moushweeling!
		mz = MouseZ()
		If mz <> m_oz
			If mz > m_oz
				m_scroll.MoveUp(0,, True)
			Else
				m_scroll.MoveDown(0,, True)
			End If
			m_oz = mz
		End If
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
		Local relx:Int, iY:Int
		Local menu:dui_Menu, datepanel:dui_DatePanel, search:dui_SearchPanel
		
		relx = m_x + x
		iY = m_y + y + m_itemheight + 2
		If m_header = False Then iY = iY - (m_itemheight + 2)
		Super.UpdateMouseRelease(x, y)
		
		' If inside the highlight area, select an item
		If dui_MouseIn(relx, iY, m_width, m_height - ((m_itemheight + 2) * m_header)) = True And m_hirow < GetItemCount() And m_hirow > - 1
			
			'TDUIMain.SetActiveGadget(Self)
			'gState = STATE_MOUSERELEASE
			
			If dui_DatePanel(m_parent) = Null Then SelectItem(m_hirow)
			'DebugLog("Table item row selected: " + m_hirow + " Now: " + GetSelectedItemIndex())
			
			'test parent for menu or date panel (special actions, not the cleanest way but gets it done)
			menu = dui_Menu(m_parent)
			If menu <> Null
				menu.Deactivate()
				menu.Hide()
				Return
			End If
			
			datepanel = dui_DatePanel(m_parent)
			If datepanel <> Null
				If GetItemContentAtIndex(m_hirow, m_hicolumn) <> Null
					SelectItem(m_hirow)
					datepanel.Deactivate()
					datepanel.SelectDay(Int(GetItemContentAtIndex(m_hirow, m_hicolumn)))
					datepanel.Hide()
				End If
				
				Return
			End If
			
			search = dui_SearchPanel(m_parent)
			If search <> Null
				search.Deactivate()
				Search.SelectItem(GetSelectedItemContentAtColumn(0), GetSelectedItemData())
				search.Hide()
				Return
			End If
			New dui_Event.Create(dui_EVENT_GADGETSELECT, Self, GetSelectedItemData(), m_hicolumn, m_hirow, GetSelectedItem())
		End If
	End Method
	
	Rem
		bbdoc: Refresh the table.
		returns: Nothing.
	End Rem
	Method Refresh()
		Local index:Int
		
		' Set width, compensating for the gaps between columns
		m_width = -3
		For index = 0 To m_columnwidths.Length - 1
			m_width:+3 + m_columnwidths[index]
		Next
		
		' Set the position, length and range of the scrollbar
		m_scroll.SetPosition(m_x + m_width + 2, m_y + ((m_itemheight + 3) * m_header))
		m_scroll.SetLength(m_height - ((m_itemheight + 3) * m_header))
		m_scroll.SetRange(m_height - ((m_itemheight + 3) * m_header))
		
		' Set the max value of the scrollbar
		m_scroll.SetMax(((GetItemCount()) * (m_itemheight + 2)) - 2)
		
		If m_scroll.GetRange() >= m_scroll.GetMax()
			m_scroll.Hide()
		Else
			m_scroll.Show()
		End If
	End Method
	
'#end region (Render & update methods)
	
'#region Field accessors
	
	Rem
		bbdoc: Set item highlighting on or off.
		returns: Nothing.
		about: If enabled, the selected item will be rendered with the highlight color.
	End Rem
	Method SetItemHighlight(highlight:Int)
		m_highlight = highlight
	End Method
	
	Rem
		bbdoc: Set the table header on or off.
		returns: Nothing.
		about: The table header is the very top of the table (the column description, or column names).
	End Rem
	Method SetHeader(header:Int)
		m_header = header
	End Method
	
	Rem
		bbdoc: Set the background drawing state.
		returns: Nothing.
		about: @index can be:<br/>
		0 - The header state<br/>
		1 - The table list\items state
	End Rem
	Method SetBackground(index:Int, background:Int)
		If index = 0 Or index = 1
			m_background[index] = background
		End If
	End Method
	
'#end region (Field accessors)
	
'#region Collections
	
	Rem
		bbdoc: Add a column to the table.
		returns: Nothing.
	End Rem
	Method AddColumn(_heading:String, _width:Int = 0, dorefresh:Int = True)
		' Get new array length
		Local nlen:Int = m_heading.Length + 1
		' Update headings
		m_heading = m_heading[0..nlen]
		m_heading[nlen - 1] = _heading
		
		'update widths
		m_columnwidths = m_columnwidths[0..nlen]
		m_columnwidths[nlen - 1] = _width
		If m_columnwidths[nlen - 1] < (dui_FontManager.StringWidth(_heading, GetFont()) + 6)
			SetColumnWidth(nlen - 1, dui_FontManager.StringWidth(_heading, GetFont()) + 6)
		End If
		
		If dorefresh = True
			Refresh()
		End If
	End Method
	
	Rem
		bbdoc: Set the width of a column.
		returns: Nothing.
	End Rem
	Method SetColumnWidth(_column:Int, _width:Int)
		If HasColumn(_column) = True
			m_columnwidths[_column] = _width
		End If
	End Method
	
	Rem
		bbdoc: Add an item to the table.
		returns: True if the item was added to the table, or False if it was not added (Null item).
		about: The content of the item will be expanded or trimmed down to fit the size of the table.
	End Rem
	Method AddItem:Int(item:dui_TableItem, dorefresh:Int = True)
		If item <> Null
			' Trim the content/expand the content to fit the table
			item.m_content = item.m_content[0..m_heading.Length]
			m_items.AddLast(item)
			If dorefresh = True Then Refresh()
			Return True
		End If
		Return False
	End Method
	
	Rem
		bbdoc: Create an item by data and add it to the table.
		returns: The item it created and added to the table, or False if the item was not added (created item was Null or other unknown reason).
	End Rem
	Method AddItemByData:dui_TableItem(text:String[], data:Int = 0, extra:Object = Null, dorefresh:Int = True)
		Local item:dui_TableItem
		
		item = New dui_TableItem.Create(text, data, extra)
		If AddItem(item, dorefresh) = True
			Return item
		End If
		Return Null
	End Method
	
	Rem
		bbdoc: Select an item at the given index.
		returns: Nothing.
	End Rem
	Method SelectItem(index:Int, doevent:Int = False)
		If GetItemCount() = 0 Then index = -1
		
		index = CorrectIndex(index)
		If HasIndex(index) = True
			m_selected = index
			'gSelectedItem = dui_TableItem(m_items.ValueAtIndex(index))
			If doevent = True
				New dui_Event.Create(dui_EVENT_GADGETSELECT, Self, GetSelectedItemData(), 0, 0, GetSelectedItem())
			End If
		Else If index = -1
			ClearSelection(doevent)
		Else
			'ClearSelection()
		End If
	End Method
	
	Rem
		bbdoc: Get the selected item index.
		returns: The selected item index (-1 if nothing is selected).
	End Rem
	Method GetSelectedItemIndex:Int()
		Return m_selected
	End Method
	
	Rem
		bbdoc: Get the selected item.
		returns: The selected item.
	End Rem
	Method GetSelectedItem:dui_TableItem()
		Return GetItemAtIndex(GetSelectedItemIndex())
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
	Method GetItemAtIndex:dui_TableItem(index:Int)
		Local item:dui_TableItem
		If HasIndex(index) = True
			index = CorrectIndex(index)
			item = dui_TableItem(m_items.ValueAtIndex(index))
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
	Method RemoveItemAtIndex:Int(index:Int)
		Local item:dui_TableItem
		
		item = GetItemAtIndex(index)
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
	Method RemoveItem:Int(_item:dui_TableItem)
		If _item <> Null
			m_items.Remove(_item)
			Return True
		End If
		Return False
	End Method
	
	Rem
		bbdoc: Get the number of items in the table.
		returns: The number of items in the table.
	End Rem
	Method GetItemCount:Int()
		Return m_items.Count()
	End Method
	
	Rem
		bbdoc: Clear all the items in the table.
		returns: Nothing.
	End Rem
	Method ClearItems()
		m_items.Clear()
		SelectItem(- 1)
		Refresh()
	End Method
	
	Rem
		bbdoc: Clear the selected item.
		returns: Nothing.
	End Rem
	Method ClearSelection(doevent:Int = False)
		m_selected = -1
		'gSelectedItem = Null
		New dui_Event.Create(dui_EVENT_GADGETSELECT, Self, GetSelectedItemData(), 0, 0, GetSelectedItem())
	End Method
	
	Rem
		bbdoc: Get the index of an item which has the data specified.
		returns: An index value (zero-based), or -1 if either @_start (the start at index) is invalid or if @_data did not match any in the table.<br>
	End Rem
	Method FindData:Int(_data:Int, _start:Int = 0)
		Local item:dui_TableItem, index:Int
		
		If HasIndex(_start) = True
			_start = CorrectIndex(_start)
			For index = _start To GetItemCount() - 1
				item = dui_TableItem(m_items.ValueAtIndex(index))
				If item <> Null
					If item.GetData() = _data Then Return index
				End If
			Next
		End If
		Return - 1
	End Method
	
	Rem
		bbdoc: Get the extra object of an item at the given index.
		returns: The item's extra object, or Null if the index was invalid.
		about: Issue: The item's extra object could be Null, thus you could not distinguish an invalid index from the actual extra object of the item.
	End Rem
	Method GetItemExtraAtIndex:Object(index:Int)
		Local item:dui_TableItem
		item = GetItemAtIndex(index)
		If item <> Null
			Return item.GetExtra()
		End If
		Return Null
	End Method
	
	Rem
		bbdoc: Get the data of an item at the given index.
		returns: The item's data, or 0 if the index was invalid.
	End Rem
	Method GetItemDataAtIndex:Int(index:Int)
		Local item:dui_TableItem
		item = GetItemAtIndex(index)
		If item <> Null
			Return item.GetData()
		End If
		Return 0
	End Method
	
	Rem
		bbdoc: Get the extra object of an item at the given index.
		returns: The item's extra object, or Null if the index, or the column, was invalid.
	End Rem
	Method GetItemContentAtIndex:String(index:Int, _column:Int)
		Local item:dui_TableItem
		If HasColumn(_column) = True
			item = GetItemAtIndex(index)
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
	Method SetItemContentAtIndex:Int(index:Int, _column:Int, _value:String)
		Local item:dui_TableItem
		If HasColumn(_column) = True
			item = GetItemAtIndex(index)
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
	Method SetItemAllContentAtIndex:Int(index:Int, _value:String[])
		Local item:dui_TableItem
		If _value <> Null
			item = GetItemAtIndex(index)
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
	Method SetItemExtraAtIndex:Int(index:Int, _extra:Object)
		Local item:dui_TableItem
		item = GetItemAtIndex(index)
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
	Method SetItemDataAtIndex:Int(index:Int, _data:Int)
		Local item:dui_TableItem
		item = GetItemAtIndex(index)
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
		If _column > - 1 And _column < m_heading.Length
			Return True
		End If
		Return False
	End Method
	
	Rem
		bbdoc: Check if the given index is valid.
		returns: True if the index is within range of the table item count, False if it was invalid.
		about: This calls #CorrectIndex on @index.
	End Rem
	Method HasIndex:Int(index:Int)
		index = CorrectIndex(index)
		If index > - 1 And index < GetItemCount()
			Return True
		End If
		Return False
	End Method
	
	Rem
		bbdoc: Correct the index using certain table rules.
		returns: #SelectedItem if @index is dui_SELECTED_ITEM, otherwise it returns @index.
	End Rem
	Method CorrectIndex:Int(index:Int)
		If index = dui_SELECTED_ITEM
			index = GetSelectedItemIndex()
		End If
		Return index
	End Method
	
'#end region (Collections)
	
'#region Function
	
	Rem
		bbdoc: Send a key to the textfield for input.
		returns: Nothing.
		about: @_type can be either<br>
		0 - An action key (KEY_ constants, things like cursor left, right; backspace and delete, enter and escape)<br>
		1 - An ascii character key (e.g. a value from GetChar - this does not convert from KEY_ constants to actual input)
	End Rem
	Method SendKey(key:Int, _type:Int = 0)
		If _type = 0
			Select key
				Case KEY_UP
					m_scroll.MoveUp(0,, True)
					If GetSelectedItemIndex() > 0
						SelectItem(GetSelectedItemIndex() - 1, True)
					End If
				Case KEY_DOWN
					m_scroll.MoveDown(0,, True)
					If GetSelectedItemIndex() < GetItemCount()
						SelectItem(GetSelectedItemIndex() + 1, True)
					End If
				Case KEY_HOME
					m_scroll.MoveToTop(True)
					SelectItem(0, True)
				Case KEY_END
					m_scroll.MoveToEnd(True)
					SelectItem(GetItemCount() - 1, True)
			End Select
		End If
	End Method
	
'#end region (Function)
	
End Type


Rem
	bbdoc: The dui table item type.
End Rem
Type dui_TableItem
	
	Field m_content:String[]			' The content of the item
	Field m_extra:Object				' An extra object
	Field m_data:Int					' Extra integer data
	
	Rem
		bbdoc: Create an item.
		returns: The created item (itself).
	End Rem
	Method Create:dui_TableItem(content:String[], data:Int, extra:Object = Null)
		SetContent(content)
		SetExtra(extra)
		SetData(data)
		
		Return Self
	End Method
	
'#region Field accessors
	
	Rem
		bbdoc: Set the content array for the item.
		returns: Nothing.
	End Rem
	Method SetContent(value:String[])
		m_content = value
	End Method
	Rem
		bbdoc: Get the content array of the item.
		returns: The content array of the item.
	End Rem
	Method GetContent:String[] ()
		Return m_content
	End Method
	
	Rem
		bbdoc: Set the extra object for the item.
		returns: Nothing.
	End Rem
	Method SetExtra(value:Object)
		m_extra = value
	End Method
	Rem
		bbdoc: Get the extra object of the item.
		returns: The extra object for the item (might be Null).
	End Rem
	Method GetExtra:Object()
		Return m_extra
	End Method
	
	Rem
		bbdoc: Set the data of the item.
		returns: Nothing.
	End Rem
	Method SetData(value:Int)
		m_data = value
	End Method
	Rem
		bbdoc: Get the data of the item.
		returns: The data of the item.
	End Rem
	Method GetData:Int()
		Return m_data
	End Method
	
'#end region (Field accessors)
	
'#region Collections
	
	Rem
		bbdoc: Set the content at a given index.
		returns: True if the content was set, or False if it was not (invalid index).
	End Rem
	Method SetContentAtIndex:Int(index:Int, value:String)
		If HasIndex(index) = True
			m_content[index] = value
			Return True
		End If
		Return False
	End Method
	
	Rem
		bbdoc: Get the content of the item at an index.
		returns: The content for the given index, or Null if the index was invalid.
		about: Issue: By just using this method there is no certain way to distinguish between an invalid index and a Null value (the value for that index was Null).
	End Rem
	Method GetContentAtIndex:String(index:Int)
		If HasIndex(index) = True
			Return m_content[index]
		End If
		Return Null
	End Method
	
	Rem
		bbdoc: Check if the item has the given index.
		returns: True if the item has the index, False if it does not.
	End Rem
	Method HasIndex:Int(index:Int)
		If index > - 1 And index < m_content.Length
			Return True
		End If
		Return False
	End Method
	
'#end region (Collections)
	
End Type

