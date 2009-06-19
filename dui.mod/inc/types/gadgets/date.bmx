
Rem
	date.bmx (Contains: dui_TDate, )
End Rem

Rem
	bbdoc: The dui date gadget type.
End Rem
Type dui_TDate Extends dui_TGadget

	Global gImage:TImage[9]
	Global gDateImage:TImage
	
	Field gText:String		'caption
	Field gDate:Int		'date value, in julian days
	
	Rem
		bbdoc: The date panel
		about: A date has a date panel gadget containing the calendar
	End Rem
	Field gDatePanel:dui_TDatePanel
		
		Rem
			bbdoc: Create a date gadget.
			returns: The created date gadget (itself).
		End Rem
		Method Create:dui_TDate(_name:String, _x:Float, _y:Float, _w:Float, _h:Float, _sy:Int, _ey:Int, _parent:dui_TGadget)
			
			PopulateGadget(_name, _x, _y, _w, _h, _parent, True)
			
			gDatePanel = New dui_TDatePanel.Create(_name + ":Panel", 180.0, 180.0, _sy, _ey, Self)
			
			Return Self
			
		End Method
		
		Rem
			bbdoc: Render the date gadget.
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
				DrawImage(gDateImage, (rX + gW) - 12, (rY + gH) - 10)
				
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
				If aY + gDatePanel.gH > TDUIMain.gHeight Then aY = (rY - 2) - gDatePanel.gH
				
				'activate the panel
				Open(rX, aY)
				
			End If
			
			Super.UpdateMouseRelease(_x, _y)
			
		End Method
		
		Rem
			bbdoc: Set the calendar date
		End Rem
		Method SetCalendarDate(day:Int, month:Int, year:Int)
			
			SetDate(dui_JulianDayAsInt(day, month, year))
			
		End Method
		
		Rem
			bbdoc: Set the date using julian days
		End Rem
		Method SetDate(date:Int)
			
			gDate = date
			gText = dui_JulianDateAsString(date, dui_FULL_DATE)
			
		End Method
		
		Rem
			Get the date
		End Rem	
		Method GetDate:Int()
			
			Return gDate
			
		End Method
		
		Rem
			bbdoc: Open the date panel
			about: Opens the date panel, and generates a dui_EVENT_GADGETOPEN event.
		End Rem
		Method Open(_x:Int, _y:Int)
			
			gDatePanel.Activate(_x, _y)
			
			New dui_TEvent.Create(dui_EVENT_GADGETOPEN, Self, 1, 0, 0, gDatePanel)
			
		End Method
		
		Rem
			bbdoc: Close the combo box menu
			about: Closes the combo box, and generates a dui_EVENT_GADGETCLOSE event with the combobox's menu as the source.
		End Rem
		Method Close()
			
			gDatePanel.Hide()
			gDatePanel.Deactivate()
			
		End Method
		
		Rem
			bbdoc: Refresh the skin for the date gadget.
			returns: Nothing.
		End Rem
		Function RefreshSkin()
			Local index:Int, x:Int, y:Int, map:Int
			Local image:TImage, mainmap:TPixmap, pixmap:TPixmap[9]
			
			image = LoadImage(TDUIMain.SkinUrl + "/graphics/combobox.png")
			mainmap = LockImage(image)
			
			For index = 0 To 8
				gImage[index] = CreateImage(5, 5)
				pixmap[index] = LockImage(gImage[index])
			Next
			
			For y = 0 To 14
				For x = 0 To 14
				
					' Get correct pixmap to write to
					map = ((y / 5) * 3) + (x / 5)
					
					WritePixel(pixmap[map], (x Mod 5), (y Mod 5), ReadPixel(mainmap, x, y))
					
				Next
			Next
			
			For index = 0 To 8
				UnlockImage(gImage[index])
			Next
			UnlockImage(image)
			
			gDateImage = LoadImage(TDUIMain.SkinUrl + "/graphics/comboboxarrow.png")
			
		End Function
		
		
End Type















