
Rem
	searchpanel.bmx (Contains: dui_TSearchPanel, )
End Rem

Rem
	bbdoc: The dui search panel gadget type.
End Rem
Type dui_TSearchPanel Extends dui_TGadget
	
	Global gImage:TImage[9]
	
	Field gSearchBox:dui_TSearchBox		'search box gadget
	Field gSearch:dui_TTextField		'search text field gadget
	Field gResults:dui_TTable			'search results
	Field gNull:dui_TButton			'null button, to set chosen data to -1
		
		Rem
			bbdoc: Create a search panel gadget.
			returns: The created search panel.
		End Rem
		Method Create:dui_TSearchPanel(_name:String, _w:Float, _h:Float, _ih:Float, _search:dui_TSearchBox)
			
			If _w = 0.0 Then _w = _search.gW
			If _h = 0.0 Then _h = 200.0
			
			PopulateGadget(_name, 0, 0, _w, _h, Null)
			
			' Add to the extra list BEFORE its child combo boxes
			TDUIMain.AddExtra(Self)
			
			gNull = New dui_TButton.Create(_name + ":Null", "None", Null, 5, 5, 40, 20, Self)
			gSearch = New dui_TTextField.Create(_name + ":Search", "", 50, 5, _w - 55, 20, True, Self)
			gResults = New dui_TTable.Create(_name + ":Results", 5, 30, _h - 35, "", _w - 28, _ih, False, Self)
			
			gSearchBox = _search
			
			Hide()
			
			Return Self
			
		End Method
		
		Rem
			bbdoc: Render the search panel.
			returns: Nothing.
		End Rem
		Method Render(_x:Float, _y:Float)
			Local rx:Float, ry:Float
			
			If IsVisible() = True
				
				SetDrawingState()
				
				rx = gX + _x
				ry = gY + _y
				
				' Draw four corners
				DrawImage(gImage[0], rx, ry)
				DrawImage(gImage[2], (rx + gW) - 5, ry)
				DrawImage(gImage[6], rx, (ry + gH) - 5)
				DrawImage(gImage[8], (rx + gW) - 5, (ry + gH) - 5)
				
				' Draw four sides
				DrawImageRect(gImage[1], rx + 5, ry, gW - 10, 5)
				DrawImageRect(gImage[7], rx + 5, (ry + gH) - 5, gW - 10, 5)
				DrawImageRect(gImage[3], rx, ry + 5, 5, gH - 10)
				DrawImageRect(gImage[5], (rx + gW) - 5, ry + 5, 5, gH - 10)
				
				' Draw centre
				DrawImageRect(gImage[4], rx + 5, ry + 5, gW - 10, gH - 10)
				
				Super.Render(_x, _y)
				
			End If
			
		End Method
		
		Rem
			bbdoc: Update the search panel.
			returns: Nothing.
		End Rem
		Method Update(_x:Int, _y:Int)
			
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
			'Local rx:Int, ry:Int
			
			'rx = gX + _x
			'ry = gY + _y
			
			Super.UpdateMouseDown(_x, _y)
			
			If IsVisible() = True
				
				New dui_TEvent.Create(dui_EVENT_GADGETCLOSE, Self, 0, 0, 0, Self)
				Hide()
				
			End If
			
		End Method
		
		Rem
			bbdoc: Activate the search panel.
			returns: Nothing.
		End Rem
		Method Activate(_x:Float, _y:Float)
			
			SetPosition(_x, _y)
			
			Show()
			TDUIMain.SetActiveGadget(Self)
			
			New dui_TEvent.Create(dui_EVENT_GADGETOPEN, Self, 1, 0, 0, Null)
			
		End Method
		
		Rem
			bbdoc: Deactivate the search panel.
			returns: Nothing.
		End Rem
		Method Deactivate()
			
			TDUIMain.ClearActiveGadget()
			gState = IDLE_STATE
			
			New dui_TEvent.Create(dui_EVENT_GADGETCLOSE, gSearchBox, 0, 0, 0, Null)
			
		End Method
			
		Rem
			bbdoc: Select an item in the search panel by the text given.
			returns: Nothing.
		End Rem
		Method SelectItem(_text:String, _data:Int = 0)
			
			gSearchBox.SetSelectedText(_text, _data)
			
		End Method
		
		Rem
			bbdoc: Refresh the search panel skin.
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
			
		End Function
		
		
End Type





























