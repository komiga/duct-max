
Rem
Copyright (c) 2010 plash <plash@komiga.com>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
End Rem

Rem
	bbdoc: duct ui table gadget.
	about: Passing indexes as dui_SELECTED_ITEM is a shortcut to use the selected item index.
End Rem
Type duiTable Extends duiGadget
	
	Field m_heading:String[]				' Headings for the columns
	Field m_columnwidths:Int[]					' Width of the columns
	Field m_itemheight:Int						' Item height
	Field m_items:TListEx = New TListEx	' The list of items
	Field m_header:Int					' Use heading
	
	Field m_highlight:Int = True			' Highlight the selected item
	
	Field m_selected:Int = -1					' Selected item number
	'Field m_selecteditem:duiTableItem			' Selected item row
	
	Field m_scroll:duiScrollBar				' Scroll bar
	Field m_oldy:Int								' Y origin for scrolling
	
	Field m_hirow:Int = -1						' Mouse over item row
	Field m_hicolumn:Int = -1					' Mouse over item column
	
	Field m_background:Int[] = [True, True]				' Background states
	
	Rem
		bbdoc: Create a table.
		returns: Itself.
	End Rem
	Method Create:duiTable(name:String, x:Float, y:Float, h:Float, heading:String, headingcolwidth:Int, itemheight:Float, header:Int, parent:duiGadget)
		_Init(name, x, y, 0, h, parent, False)
		m_itemheight = itemheight
		If m_itemheight = 0.0
			m_itemheight = 20.0
		End If
		SetHeader(header)
		m_scroll = New duiScrollBar.Create(name + ":Scroll", x + 2.0, y + m_itemheight + 3.0, h - (m_itemheight + 3.0), 0, 0, h - (m_itemheight + 3), parent)
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
		If IsVisible()
			Local index:Int, itemcount:Int, item:duiTableItem
			Local rx:Float = m_x + x
			Local ry:Float = m_y + y
			Local tx:Float
			
			BindRenderingState(2)
			If m_header = True
				If m_background[1]
					For index = 0 Until m_heading.Length
						dProtogPrimitives.RenderRectangleToSize(rx + tx, ry, m_columnwidths[index], m_itemheight)
						tx:+ 3.0 + m_columnwidths[index]
					Next
				End If
				BindTextRenderingState(2)
				tx = 3.0
				For index = 0 Until m_heading.Length
					duiFontManager.RenderString(m_heading[index], m_font, rx + tx, ry + 3.0)
					tx:+ 3.0 + m_columnwidths[index]
				Next
			Else
				ry:- (m_itemheight + 2.0)
			End If
			
			dProtogDrawState.Push(False, False, False, True, False, False)
			dui_SetViewport(rx, ry + m_itemheight + 2, m_width, m_height - ((m_itemheight + 2) * m_header))
			For item = EachIn m_items
				itemcount:+ 1
				If m_background[0] Or itemcount - 1 = m_selected
					If itemcount - 1 = m_selected And m_highlight
						BindRenderingState(1)
					Else
						BindRenderingState(0)
					End If
					tx = 0.0
					For index = 0 Until m_heading.Length
						If dui_IsInViewport(rx + tx, ry + (itemcount * (m_itemheight + 2)) + m_oldy, m_columnwidths[index], m_itemheight)
							dProtogPrimitives.RenderRectangleToSize(rx + tx, ry + (itemcount * (m_itemheight + 2)) + m_oldy, m_columnwidths[index], m_itemheight, True)
						End If
						tx:+ 3.0 + m_columnwidths[index]
					Next
				End If
				If itemcount - 1 = m_selected And m_highlight
					BindTextRenderingState(1)
				Else
					BindTextRenderingState(0)
				End If
				tx = 3.0
				For index = 0 Until m_heading.Length
					If dui_IsInViewport((rx + tx) - 3.0, ry + (itemcount * (m_itemheight + 2.0)) + m_oldy, m_columnwidths[index], m_itemheight)
						duiFontManager.RenderString(item.GetContentAtIndex(index), m_font, rx + tx, ry + 3.0 + (itemcount * (m_itemheight + 2.0)) + m_oldy)
					End If
					tx:+ 3.0 + m_columnwidths[index]
				Next
			Next
			dProtogDrawState.Pop(False, False, False, True, False, False)
			Super.Render(x, y)
		End If
	End Method
	
	Rem
		bbdoc: Update the table (extended just updates the scrollbar).
		returns: Nothing.
	End Rem
	Method Update(x:Int, y:Int)
		m_oldy = -m_scroll.GetValue()
		Super.Update(x, y)
	End Method
	
	Rem
		bbdoc: Update the MouseOver state.
		returns: Nothing.
	End Rem
	Method UpdateMouseOver(x:Int, y:Int)
		duiMain.SetCursor(dui_CURSOR_MOUSEOVER)
		Local relx:Int = m_x + x
		Local iy:Int = m_y + y + m_itemheight + 2 + m_oldy
		If Not m_header Then iy = iy - (m_itemheight + 2)
		Super.UpdateMouseOver(x, y)
		If dui_MouseIn(relx, iy - m_oldy, m_width, m_height - ((m_itemheight + 2) * m_header))
			m_hirow = (MouseY() - iy) / (m_itemheight + 2)
			Local pos:Int = -1
			For Local index:Int = 0 Until m_columnwidths.Length
				pos:+ m_columnwidths[index] + 3
				If MouseX() - relx < pos
					m_hicolumn = index
					Exit
				End If
			Next
		Else
			m_hirow = -1
			m_hicolumn = -1
		End If
		Local mz:Int = MouseZ()
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
		duiMain.SetCursor(dui_CURSOR_MOUSEDOWN)
		Super.UpdateMouseDown(x, y)
	End Method
		
	Rem
		bbdoc: Update the MouseRelease state.
		returns: Nothing.
	End Rem
	Method UpdateMouseRelease(x:Int, y:Int)
		Local menu:duiMenu, datepanel:duiDatePanel, search:duiSearchPanel
		Local relx:Int = m_x + x
		Local iy:Int = m_y + y + m_itemheight + 2
		If Not m_header Then iy = iy - (m_itemheight + 2)
		Super.UpdateMouseRelease(x, y)
		If dui_MouseIn(relx, iy, m_width, m_height - ((m_itemheight + 2) * m_header)) And m_hirow < GetItemCount() And m_hirow > - 1
			If duiDatePanel(m_parent) = Null Then SelectItem(m_hirow)
			'DebugLog("Table item row selected: " + m_hirow + " Now: " + GetSelectedItemIndex())
			menu = duiMenu(m_parent)
			If menu
				menu.Deactivate()
				menu.Hide()
				Return
			End If
			datepanel = duiDatePanel(m_parent)
			If datepanel
				If GetItemContentAtIndex(m_hirow, m_hicolumn)
					SelectItem(m_hirow)
					datepanel.Deactivate()
					datepanel.SelectDay(Int(GetItemContentAtIndex(m_hirow, m_hicolumn)))
					datepanel.Hide()
				End If
				Return
			End If
			search = duiSearchPanel(m_parent)
			If search
				search.Deactivate()
				Search.SelectItem(GetSelectedItemContentAtColumn(0), GetSelectedItemData())
				search.Hide()
				Return
			End If
			New duiEvent.Create(dui_EVENT_GADGETSELECT, Self, GetSelectedItemData(), m_hicolumn, m_hirow, GetSelectedItem())
		End If
	End Method
	
	Rem
		bbdoc: Refresh the table.
		returns: Nothing.
	End Rem
	Method Refresh()
		m_width = -3.0
		For Local index:Int = 0 Until m_columnwidths.Length
			m_width:+ 3.0 + m_columnwidths[index]
		Next
		m_scroll.SetPosition(m_x + m_width + 2, m_y + ((m_itemheight + 3) * m_header))
		m_scroll.SetLength(m_height - ((m_itemheight + 3) * m_header))
		m_scroll.SetRange(m_height - ((m_itemheight + 3) * m_header))
		m_scroll.SetMax(((GetItemCount()) * (m_itemheight + 2)) - 2)
		If m_scroll.GetRange() >= m_scroll.GetMax()
			m_scroll.Hide()
		Else
			m_scroll.Show()
		End If
	End Method
	
'#end region Render & update methods
	
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
		about: @index can be:<br>
		0 - The header state<br>
		1 - The table list\items state
	End Rem
	Method SetBackground(index:Int, background:Int)
		If index = 0 Or index = 1
			m_background[index] = background
		End If
	End Method
	
'#end region Field accessors
	
'#region Collections
	
	Rem
		bbdoc: Add a column to the table.
		returns: Nothing.
	End Rem
	Method AddColumn(heading:String, width:Int = 0, dorefresh:Int = True)
		Local nlen:Int = m_heading.Length + 1
		m_heading = m_heading[0..nlen]
		m_heading[nlen - 1] = heading
		m_columnwidths = m_columnwidths[0..nlen]
		m_columnwidths[nlen - 1] = width
		If m_columnwidths[nlen - 1] < (duiFontManager.StringWidth(heading, GetFont()) + 6)
			SetColumnWidth(nlen - 1, duiFontManager.StringWidth(heading, GetFont()) + 6)
		End If
		If dorefresh
			Refresh()
		End If
	End Method
	
	Rem
		bbdoc: Set the width of a column.
		returns: Nothing.
	End Rem
	Method SetColumnWidth(column:Int, width:Int)
		If HasColumn(column)
			m_columnwidths[column] = width
		End If
	End Method
	
	Rem
		bbdoc: Add an item to the table.
		returns: True if the item was added to the table, or False if it was not added (Null item).
		about: The content of the item will be expanded or trimmed down to fit the size of the table.
	End Rem
	Method AddItem:Int(item:duiTableItem, dorefresh:Int = True)
		If item
			' Trim the content/expand the content to fit the table
			item.m_content = item.m_content[0..m_heading.Length]
			m_items.AddLast(item)
			If dorefresh Then Refresh()
			Return True
		End If
		Return False
	End Method
	
	Rem
		bbdoc: Create an item by data and add it to the table.
		returns: The item it created and added to the table, or False if the item was not added (created item was Null or other unknown reason).
	End Rem
	Method AddItemByData:duiTableItem(text:String[], data:Int = 0, extra:Object = Null, dorefresh:Int = True)
		Local item:duiTableItem = New duiTableItem.Create(text, data, extra)
		If AddItem(item, dorefresh)
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
		If HasIndex(index)
			m_selected = index
			'gSelectedItem = duiTableItem(m_items.ValueAtIndex(index))
			If doevent
				New duiEvent.Create(dui_EVENT_GADGETSELECT, Self, GetSelectedItemData(), 0, 0, GetSelectedItem())
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
	Method GetSelectedItem:duiTableItem()
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
	Method GetItemAtIndex:duiTableItem(index:Int)
		If HasIndex(index)
			index = CorrectIndex(index)
			Local item:duiTableItem = duiTableItem(m_items.ValueAtIndex(index))
			If item
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
		Local item:duiTableItem = GetItemAtIndex(index)
		If RemoveItem(item)
			Refresh()
			Return True
		End If
		Return False
	End Method
	
	Rem
		bbdoc: Remove an item from the table.
		returns: True if the item was removed, or False if it was not removed (the item was not in the table or it was Null).
	End Rem
	Method RemoveItem:Int(item:duiTableItem)
		If item
			m_items.Remove(item)
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
		SelectItem(-1)
		Refresh()
	End Method
	
	Rem
		bbdoc: Clear the selected item.
		returns: Nothing.
	End Rem
	Method ClearSelection(doevent:Int = False)
		m_selected = -1
		If doevent Then New duiEvent.Create(dui_EVENT_GADGETSELECT, Self, GetSelectedItemData(), 0, 0, GetSelectedItem())
	End Method
	
	Rem
		bbdoc: Get the index of an item which has the data specified.
		returns: An index value (zero-based), or -1 if either @_start (the start at index) is invalid or if @_data did not match any in the table.<br>
	End Rem
	Method FindData:Int(data:Int, start:Int = 0)
		If HasIndex(start)
			start = CorrectIndex(start)
			Local item:duiTableItem
			For Local index:Int = start Until GetItemCount()
				item = duiTableItem(m_items.ValueAtIndex(index))
				If item
					If item.GetData() = data Then Return index
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
	Method GetItemExtraAtIndex:Object(index:Int)
		Local item:duiTableItem = GetItemAtIndex(index)
		If item
			Return item.GetExtra()
		End If
		Return Null
	End Method
	
	Rem
		bbdoc: Get the data of an item at the given index.
		returns: The item's data, or 0 if the index was invalid.
	End Rem
	Method GetItemDataAtIndex:Int(index:Int)
		Local item:duiTableItem = GetItemAtIndex(index)
		If item
			Return item.GetData()
		End If
		Return 0
	End Method
	
	Rem
		bbdoc: Get the extra object of an item at the given index.
		returns: The item's extra object, or Null if the index, or the column, was invalid.
	End Rem
	Method GetItemContentAtIndex:String(index:Int, column:Int)
		If HasColumn(column)
			Local item:duiTableItem = GetItemAtIndex(index)
			If item
				Return item.GetContentAtIndex(column)
			End If
		End If
		Return Null
	End Method
	
	Rem
		bbdoc: Set the content of an item in the table by the given index.
		returns: True if the content was set, or False if it was not (invalid index or invalid column).
	End Rem
	Method SetItemContentAtIndex:Int(index:Int, column:Int, value:String)
		If HasColumn(column)
			Local item:duiTableItem = GetItemAtIndex(index)
			If item
				item.SetContentAtIndex(column, value)
				Return True
			End If
		End If
		Return False
	End Method
	
	Rem
		bbdoc: Set the whole content array for a given item.
		returns: True if the content array was set, or False if it was not (invalid index or Null value).
	End Rem
	Method SetItemAllContentAtIndex:Int(index:Int, value:String[])
		If value
			Local item:duiTableItem = GetItemAtIndex(index)
			If item
				item.SetContent(value)
				Return True
			End If
		End If
		Return False
	End Method
	
	Rem
		bbdoc: Set the extra object of an item at the given index.
		returns: True if the extra object was set, or False if the value was not set (index was invalid - extra object @can be Null).
	End Rem
	Method SetItemExtraAtIndex:Int(index:Int, extra:Object)
		Local item:duiTableItem = GetItemAtIndex(index)
		If item
			item.SetExtra(extra)
			Return True
		End If
		Return False
	End Method
	
	Rem
		bbdoc: Set the item data at the given index.
		returns: True if the data was set, False if it was not (index was invalid).
	End Rem
	Method SetItemDataAtIndex:Int(index:Int, data:Int)
		Local item:duiTableItem = GetItemAtIndex(index)
		If item
			item.SetData(data)
		End If
		Return False
	End Method
	
	Rem
		bbdoc: Check if the given column is valid.
		returns: True if the column is within range of the table column count, False if it was invalid.
	End Rem
	Method HasColumn:Int(column:Int)
		If column > -1 And column < m_heading.Length
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
		If index > -1 And index < GetItemCount()
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
	
'#end region Collections
	
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
	
'#end region Function
	
End Type


Rem
	bbdoc: duct ui table item.
	about: See #duiTable.
End Rem
Type duiTableItem
	
	Field m_content:String[]
	Field m_extra:Object
	Field m_data:Int
	
	Rem
		bbdoc: Create an item.
		returns: Itself.
	End Rem
	Method Create:duiTableItem(content:String[], data:Int, extra:Object = Null)
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
	Method GetContent:String[]()
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
	
'#end region Field accessors
	
'#region Collections
	
	Rem
		bbdoc: Set the content at a given index.
		returns: True if the content was set, or False if it was not (invalid index).
	End Rem
	Method SetContentAtIndex:Int(index:Int, value:String)
		If HasIndex(index)
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
		If HasIndex(index)
			Return m_content[index]
		End If
		Return Null
	End Method
	
	Rem
		bbdoc: Check if the item has the given index.
		returns: True if the item has the index, False if it does not.
	End Rem
	Method HasIndex:Int(index:Int)
		If index > -1 And index < m_content.Length
			Return True
		End If
		Return False
	End Method
	
'#end region Collections
	
End Type

