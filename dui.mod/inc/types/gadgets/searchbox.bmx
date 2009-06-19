
Rem
	searchbox.bmx (Contains: dui_TSearchBox, )
End Rem

Rem
	bbdoc: The dui search box gadget type.
End Rem
Type dui_TSearchBox Extends dui_TGadget

	Global gImage:TImage[9]
	Global gSearchImage:TImage
	
	Field gText:String
	Field gData:Int
	Field gNull:Int
	
	Field fSearch(_searchbox:dui_TSearchBox, _text:String)
	
	Field gSearchPanel:dui_TSearchPanel
		
		Rem
			bbdoc: Create a search box gadget.
			returns: The created search box.
		End Rem
		Method Create:dui_TSearchBox(_name:String, _x:Float, _y:Float, _w:Float, _h:Float, _pw:Float, _ph:Float, _ih:Int, _nv:Int, _parent:dui_TGadget)
			
			PopulateGadget(_name, _x, _y, _w, _h, _parent)
			
			gSearchPanel = New dui_TSearchPanel.Create(_name + ":Panel", _pw, _ph, _ih, Self)
			gNull = _nv
			SetSelectedText(Null)
			
			Return Self
			
		End Method
		
		Rem
			bbdoc: Render the search box.
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
				
				SetTextDrawingState(True)
				DrawText(gText, rx + 5, ry + 3)
				
				DrawImage(gSearchImage, (rx + gW) - 16, ry + ((gH - 2) / 2) - 4)
				
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
			Local rx:Int, ry:Int, ay:Int
			
			rx = gX + _x
			ry = gY + _y
			
			ay = ry + gH + 2
			If ay + gSearchPanel.gH > TDUIMain.gHeight Then ay = (rY - 2) - gSearchPanel.gH
			
			'activate the panel
			Open(rx, ay)
			
			Super.UpdateMouseRelease(_x, _y)
			
		End Method
		
		Rem
			bbdoc: Set the text for the search box.
			returns: Nothing.
		End Rem
		Method SetText(_text:String)
			
			gText = _text
			
		End Method
		
		Rem
			bbdoc: Get the text for the search box.
			returns: The search box's text.
		End Rem
		Method GetText:String()
			
			Return gText
			
		End Method
		
		Rem
			bbdoc: Set the data for the search box.
			returns: Nothing.
		End Rem
		Method SetData(_data:Int)
			
			gData = _data
			
		End Method
		
		Rem
			bbdoc: Get the data for the search box.
			returns: The search box's data.
		End Rem	
		Method GetData:Int()
			
			Return gData
			
		End Method
		
		Rem
			bbdoc: Clear the search box.
			returns: Nothing.
		End Rem
		Method ClearItems()
			
			gSearchPanel.gResults.ClearItems()
			
		End Method
		
		Rem
			bbdoc: Add an item to the search box.
			returns: Nothing.
		End Rem
		Method AddItem(_text:String, _data:Int)
			
			gSearchPanel.gResults.AddItemByData([_text], _data, Null)
			
		End Method
		
		Rem
			bbdoc: Set the selected text.
			returns: Nothing.
		End Rem
		Method SetSelectedText(_text:String, _data:Int = 0)
			If _text = Null
				_text = "[None]"
				_data = gNull
			End If
			
			SetText(_text)
			SetData(_data)
			
		End Method
		
		Rem
			bbdoc: Set the search function callback.
			returns: Nothing.
		End Rem
		Method SetSearchCallback(func(_searchbox:dui_TSearchBox, _text:String))
			
			fSearch = func
			
		End Method
		
		Rem
			bbdoc: Search for the given text.
			returns: Nothing.
			about: This calls the search function callback.
		End Rem
		Method Search(_text:String)
			
			If fSearch <> Null
				
				fSearch(Self, _text)
				
			End If
			
		End Method
		
		Rem
			bbdoc: Open the search panel.
			returns: Nothing.
			about: Opens the search panel, and generates a dui_EVENT_GADGETOPEN event.
		End Rem
		Method Open(_x:Float, _y:Float)
			
			gSearchPanel.Activate(_x, _y)
			
			New dui_TEvent.Create(dui_EVENT_GADGETOPEN, Self, 1, 0, 0, gSearchPanel)
			
		End Method
		
		Rem
			bbdoc: Close the search panel.
			returns: Nothing.
			about: Closes the search panel, and generates a dui_EVENT_GADGETCLOSE event.
		End Rem
		Method Close()
			
			gSearchPanel.Hide()
			gSearchPanel.Deactivate()
			
		End Method
		
		Rem
			bbdoc: Refresh the searchbox skin.
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
			
			gSearchImage = LoadImage(TDUIMain.SkinUrl + "/graphics/search.png")
			
		End Function
		
End Type





























