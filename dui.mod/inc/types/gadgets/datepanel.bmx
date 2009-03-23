
' 
' datepanel.bmx (Contains: dui_TDatePanel, )
' 
' 

Rem
	bbdoc: The dui date panel gadget type.
End Rem
Type dui_TDatePanel Extends dui_TGadget
	
	Global gImage:TImage[9]
	
	Field gDate:dui_TDate
	Field gMonth:dui_TComboBox
	Field gYear:dui_TComboBox
	Field gCalendar:dui_TTable
	
	Field gMonthItem:Int
	Field gYearItem:Int
	
	Field gStart:Int
	Field gEnd:Int
		
		Rem
			bbdoc: Create a date panel.
			returns: The created date panel (itself).
		End Rem
		Method Create:dui_TDatePanel(_name:String, _w:Float, _h:Float, _sy:Int, _ey:Int, _date:dui_TDate)
			Local _index:Int
			
			PopulateGadget(_name, 0.0, 0.0, _w, _h, Null, False)
			SetRange(_sy, _ey, False)
			
			' Add to the extra list BEFORE its child combo boxes
			TDUIMain.AddExtra(Self)
			
			gDate = _date
			
			gMonth = New dui_TComboBox.Create(_name + ":Month", "", 5.0, 5.0, 95.0, 20.0, 95.0, 270.0, 18.0, Self)
			For _index = 1 To 12
				gMonth.AddItemByData(dui_MonthAsString(_index, True), _index,, False)
			Next
			
			gYear = New dui_TComboBox.Create(_name + ":Year", "", 105.0, 5.0, 70.0, 20.0, 80.0, 200.0, 18.0, Self)
			gCalendar = New dui_TTable.Create(_name + ":Results", 5.0, 30.0, 145.0, "S", 22.0, 18.0, True, Self)
			gCalendar.AddColumn("M", 22, False)
			gCalendar.AddColumn("T", 22, False)
			gCalendar.AddColumn("W", 22, False)
			gCalendar.AddColumn("T", 22, False)
			gCalendar.AddColumn("F", 22, False)
			gCalendar.AddColumn("S", 22, False)
			
			' Table heading
			gCalendar.SetColour(0, 0, 0, 2)
			gCalendar.SetAlpha(0.5, 2)
			gCalendar.SetTextColour(255, 255, 255, 2)
			
			Hide()
			Refresh()
					
			Return Self
			
		End Method
			
		Rem
			bbdoc: Render the date panel.
			returns: Nothing.
		End Rem
		Method Render(_x:Float, _y:Float)
			Local rX:Float, rY:Float
			
			If IsVisible() = True
				
				SetDrawingState()
				
				' Set up rendering locations
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
			bbdoc: Update the date panel.
			returns: Nothing.
		End Rem
		Method Update(_x:Int, _y:Int)
			
			' Test if the calendar needs updating
			If gMonthItem <> gMonth.GetSelectedItemIndex() Or gYearItem <> gYear.GetSelectedItemIndex() Then RefreshCalendar()
			
			Super.Update(_x, _y)
			
			' Check to see if the mouse is down, regardless of location
			If TDUIMain.IsGadgetActive(Self) And MouseDown(1) And IsVisible() = True
				
				UpdateMouseDown(_x, _y)
				
			End If
			
		End Method
		
		Rem
			bbdoc: Update the MouseDown state.
			returns: Nothing.
		End Rem
		Method UpdateMouseDown(_x:Int, _y:Int)
			Local rX:Int, rY:Int
			
			rX = gX + _x
			rY = gY + _y
			
			Super.UpdateMouseDown(_x, _y)
			
			If IsVisible() = True
				
				' Hide the gadget and generate a close event
				New dui_TEvent.Create(dui_EVENT_GADGETCLOSE, Self, 0, 0, 0, Self)
				Hide()
				
			End If
			
		End Method
		
		Rem
			bbdoc: Activate the date panel menu.
			returns: Nothing.
		End Rem
		Method Activate(_x:Int, _y:Int)
			
			gX = _x
			gY = _y
			Show()
			TDUIMain.SetActiveGadget(Self)
			gCalendar.gSelected = -1
			
			New dui_TEvent.Create(dui_EVENT_GADGETOPEN, Self, 1, 0, 0, Null)
			
		End Method
		
		Rem
			bbdoc: Deactivate the date panel menu.
			returns: Nothing.
		End Rem
		Method Deactivate()
			
			TDUIMain.ClearActiveGadget()
			gState = IDLE_STATE
			
			New dui_TEvent.Create(dui_EVENT_GADGETCLOSE, gDate, 0, 0, 0, Null)
			
		End Method
		
		Rem
			bbdoc: Set the year range of the date panel (?)
			returns: Nothing.
		End Rem
		Method SetRange(_start:Int, _end:Int, _dorefresh:Int = True)
			
			gStart = _start
			gEnd = _end
			
			If _end < _start Then gEnd = _start
			
			If _dorefresh = True Then Refresh()
			
		End Method
		
		Rem
			bbdoc: Select a day in the month.
			returns: Nothing.
		End Rem
		Method SelectDay(_day:Int)
			
			If _day > 0 And _day < 32
				
				gDate.SetCalendarDate(_day, gMonthItem + 1, gYearItem + gStart)
				
			End If
			
		End Method
			
		Rem
			bbdoc: Refresh the date panel.
			retruns: Nothing.
		End Rem
		Method Refresh()
			Local index:Int
			
			' Refresh the year list
			gYear.ClearItems()
			For index = gStart To gEnd
				
				gYear.AddItemByData(String(index),, , False)
				
			Next
			
			' Set the month to January, and year to first available
			gMonth.SelectItem(0)
			gYear.SelectItem(0)
			
			' Refresh calendar
			RefreshCalendar(True)
			
			gMonth.gMenu.Refresh()
			gYear.gMenu.Refresh()
			
		End Method
		
		Rem
			bbdoc: Refresh the calender.
			returns: Nothing.
		End Rem
		Method RefreshCalendar(_dorefresh:Int = True)
			Local calender_:Int[][], week_:Int, day_:Int
			
			gMonthItem = gMonth.GetSelectedItemIndex()
			gYearItem = gYear.GetSelectedItemIndex()
			
			gCalendar.ClearItems()
			
			calender_ = dui_Calendar(gMonthItem + 1, gYearItem + gStart)
			For week_ = 0 To 5
				' Add the item
				gCalendar.AddItemByData([""],,, False)
				
				' Set the content
				For day_ = 0 To 6
					
					If calender_[day_][week_] <> 0 Then gCalendar.SetItemContentAtIndex(week_, day_, calender_[day_][week_])
					
				Next
				
			Next
			
			If _dorefresh = True
				gCalendar.Refresh()
			End If
			
		End Method
		
		Rem
			bbdoc: Refresh the skin for the date panel.
			returns: Nothing.
		End Rem
		Function RefreshSkin()
			Local x:Int, y:Int, index:Int, map:Int
			Local image:TImage, mainmap:TPixmap, pixmap:TPixmap[9]
			
			image = LoadImage(TDUIMain.SkinUrl + "/graphics/menu.png")
			mainmap = LockImage(image)
			
			For index = 0 To 8
				gImage[index] = CreateImage(5, 5)
				pixmap[index] = LockImage(gImage[index])
			Next
			
			For Local y:Int = 0 To 14
				For Local x:Int = 0 To 14
				
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


























