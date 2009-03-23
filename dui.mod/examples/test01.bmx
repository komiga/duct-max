
' 
' test01.bmx
' Test the dui module
' 

SuperStrict

Framework brl.blitz
Import brl.standardio

Import duct.dui
Import brl.glmax2d
Import brl.freetypefont

Import brl.pngloader
Import brl.bmploader
Import brl.jpgloader

TApp.Run()

Type TApp
	
	'Global background_image:TImage
	Global main_screen:dui_TScreen, fps_label:dui_TLabel
	Global main_panel:dui_TPanel, alpha_slider:dui_TSlider, textfield:dui_TTextField, txf_search:dui_TCheckBox, dateselector:dui_TDate, txf_clear:dui_TButton
	Global test_canvas:dui_TCanvas, data_table:dui_TTable
		
		Function Run()
			Local event:dui_TEvent
			
			InitiateGraphics()
			SetupUI()
			
			While KeyHit(KEY_ESCAPE) = False And AppTerminate() = False
				
				Cls()
					
					'DrawImage(background_image, 0.0, 0.0)
					TDUIMain.Refresh()
					fps_label.SetText("FPS:" + String(TFPSCounter.GetFPS()))
					
					While dui_TEvent.PollEvent()
						
						event = dui_TEvent.GetCurrentEvent()
						
						'If event.id <> dui_EVENT_MOUSEOVER Then Print(event.ToString())
						
						Select event.id
							Case dui_EVENT_GADGETACTION
								Select event.source
									Case alpha_slider
										main_panel.SetAlpha(Float(alpha_slider.GetValue() * 0.01))
										
									Case txf_search
										textfield.gSearch = txf_search.GetState()
										textfield.Refresh()
										
									Case txf_clear
										textfield.Clear()
										
								End Select
								
						End Select
						
					Wend
					
				Flip() ; TFPSCounter.Update()
				
			Wend
			
		End Function
		
		Function SetupUI()
			Local backimage_gadget:dui_TImage ', in_panel:dui_TPanel
			
			main_screen = New dui_TScreen.Create("main_screen", "_main")
			TDUIMain.SetCurrentScreen(main_screen, False)
			
			backimage_gadget = New dui_TImage.Create("backimage_gadget", "background.png", 0.0, 0.0, 0.0, 0.0, Null)
			main_screen.AddGadget(backimage_gadget)
			
			main_panel = New dui_TPanel.Create("main_panel", 200.0, 150.0, 600.0, 400.0, True, main_screen)
			main_panel.SetColour(95, 105, 160)
			main_panel.SetAlpha(0.9)
			
			alpha_slider = New dui_TSlider.Create("alpha_slider", 5.0, 380.0, 590.0, dui_TSlider.HORIZ_ALIGN, 0, 100, 1, main_panel)
			alpha_slider.SetValue(Int((main_panel.GetAlpha() + 0.1) * 100), False)
			
			textfield = New dui_TTextField.Create("textfield", "Type shtuff in me.", 10.0, 10.0, 190.0, 21.0, True, main_panel)
			txf_clear = New dui_TButton.Create("txf_clear", "Clear", Null, 202.5, 10.0, 60.0, 21.0, main_panel)
			
			txf_search = New dui_TCheckBox.Create("txf_search", "Search Image?", 265.0, 13.0, dui_TCheckBox.LEFT_ALIGN, main_panel)
			txf_search.SetState(textfield.gSearch)
			
			dateselector = New dui_TDate.Create("dateselector", 10.0, 40.0, 190.0, 21.0, 2000, 2015, main_panel)
			
			'in_panel = New dui_TPanel.Create("in_panel", 5.0, 5.0, 450.0, 250.0, True, main_panel)
			'in_panel.SetColour(130, 70, 80)
			'in_panel.SetAlpha(0.6)
			
			test_canvas = New dui_TCanvas.Create("test_canvas", 15.0, 90.0, 220.0, 140.0, TApp.CanvasDraw, main_panel, True, False)
			test_canvas.SetColour(0, 0, 0)
			test_canvas.SetAlpha(0.6)
			
			data_table = New dui_TTable.Create("data_table", 240.0, 90.0, 160.0, "Name", 145, 21.0, True, main_panel)
			'data_table.AddColumn("Name", 100, False)
			data_table.AddColumn("Information", 45, False)
			data_table.AddItemByData(["John Smith", "KIA"], False)
			data_table.AddItemByData(["Jane Smith", "KIA"], False)
			data_table.Refresh()
			
			fps_label = New dui_TLabel.Create("fps_label", "", 10.0, 10.0, 60.0, 20.0, 0, 0, Null)
			fps_label.SetTextColour(255, 255, 255)
			main_screen.AddGadget(fps_label)
			
			'For Local gadget:dui_TGadget = EachIn New TListReversed.Create(main_screen.children)
			'	
			'	Print(gadget.gName)
			'	
			'	For Local gadget2:dui_TGadget = EachIn New TListReversed.Create(gadget.gChildren)
			'		
			'		Print("~t" + gadget2.gName)
			'		
			'	Next
			'	
			'Next
			
		End Function
		
		Function InitiateGraphics()
			
			TDUIMain.SetDimensions(1024, 768)
			
			SetGraphicsDriver(GLMax2DDriver())
			Graphics(TDUIMain.GetScreenWidth(), TDUIMain.GetScreenHeight(), 0)
			SetClsColor(0, 0, 0)
			SetBlend(ALPHABLEND)
			TDrawState.InitiateDefaultState()
			
			TDUIMain.InitiateUI()
			TDUIMain.LoadSkin("skin")
			
			dui_TFont.SetDefaultFont(New dui_TFont.Create("Default", "lucon.ttf", 14, SMOOTHFONT))
			
			TDUIMain.SetCursorType(0)
			HideMouse()
			
		End Function
		
		Function CanvasDraw()
			Local dtext:String = "Son of a goose!", x:Float, y:Float, i:Int
			
			SetBlend(ALPHABLEND)
			'SetColor(255, 255, 255)
			TDrawState.DefaultState.SetStates(True, True, False, True, False, False, False, False)
			
			x = 5.0; y = 70.0
			For i = 0 To dtext.Length
				
				DrawText(dtext[i - 1..i], x, y - Cos(MilliSecs()) * 10.0)
				y:+Sin(MilliSecs()) * 0.75
				x:+dui_TFont.GetFontStringWidth(dtext[i - 1..i], Null)
				
			Next
			
		End Function
		
End Type
























