
Rem
	dui example
End Rem

SuperStrict

Framework brl.blitz
Import brl.standardio
Import brl.filesystem

Import brl.pngloader
Import brl.tgaloader

Import duct.dui
Import duct.protog2d

Global mainapp:MyGraphicsApp = New MyGraphicsApp.Create()
mainapp.Run()
End

Type MyGraphicsApp Extends TDProtogGraphicsApp
	
	Field m_gdriver:TProtog2DDriver
	
	Field m_defaultfont:TProtogFont
	
	Field m_backimage_gadget:dui_Texture
	Field m_main_screen:dui_Screen, m_fps_label:dui_Label
	Field m_main_panel:dui_Panel, m_alpha_slider:dui_Slider, m_textfield:dui_TextField, m_txf_search:dui_CheckBox, m_dateselector:dui_Date, m_txf_clear:dui_Button
	Field m_test_canvas:dui_Canvas, m_data_table:dui_Table
	Field m_inpanel:dui_Panel
	
	Method New()
	End Method
	
	Method Create:MyGraphicsApp()
		Super.Create()
		Return Self
	End Method
	
	Method OnInit()
		m_graphics = New TDProtogGraphics.Create(1024, 768, 0, 60,, 0, False)
		If m_graphics.StartGraphics() = False
			Print("Failed to open graphics mode!")
			End
		End If
		m_gdriver = m_graphics.GetDriverContext()
		
		' The renderbuffer isn't really necessary here (no full-screen shaders are in use)
		m_gdriver.SetRenderBufferOnFlip(False)
		m_gdriver.UnbindRenderBuffer()
		
		TDUIMain.SetDimensions(m_graphics.GetWidth(), m_graphics.GetHeight())
		TDUIMain.InitiateUI()
		m_gdriver.SetBlend(BLEND_ALPHA)
		TProtogDrawState.InitiateDefaultState()
		TProtogDrawState.m_defaultstate.m_texture = Null
		
		InitResources()
		InitUI()
	End Method
	
	Method InitResources()
		Try
			m_defaultfont = New TProtogFont.FromNode(New TSNode.LoadScriptFromObject("themes/fonts/arial.font"), True)
			dui_FontManager.SetDefaultFont(m_defaultfont)
		Catch e:Object
			Print("Caught exception (attempting to load font): " + e.ToString())
			End
		End Try
		
		Try
			Local theme:dui_Theme = dui_ThemeManager.AddThemeFromObject("themes/theme_generic.theme", True, False)
			If theme <> Null
				TDUIMain.SetTheme(theme)
			Else
				Throw("Failed to load theme from 'themes/theme_generic.theme'")
			End If
		Catch e:Object
			Print("Caught exception (attempting to load/set theme): " + e.ToString())
			End
		End Try
		
		TDUIMain.SetCursorType(0)
		HideMouse()
	End Method
	
	Method InitUI()
		m_main_screen = New dui_Screen.Create("main_screen", "_main")
		TDUIMain.SetCurrentScreen(m_main_screen, False)
		
		m_backimage_gadget = New dui_Texture.Create("backimage_gadget", "background.png", 0.0, 0.0, 0.0, 0.0, Null)
		m_main_screen.AddGadget(m_backimage_gadget)
		
		m_main_panel = New dui_Panel.Create("main_panel", 1.0, 1.0, 600.0, 400.0, True, m_main_screen)
		m_main_panel.SetColorParams(0.37, 0.41, 0.62)
		m_main_panel.SetAlpha(0.9)
		
		m_alpha_slider = New dui_Slider.Create("alpha_slider", 5.0, 380.0, 590.0, dui_ALIGN_HORIZONTAL, 0, 100, 1, m_main_panel)
		m_alpha_slider.SetValue(m_main_panel.GetAlpha() * 100, False)
		
		m_textfield = New dui_TextField.Create("textfield", "Type shtuff in me.", 10.0, 10.0, 190.0, 21.0, False, m_main_panel)
		m_txf_clear = New dui_Button.Create("txf_clear", "Clear", Null, 202.5, 10.0, 60.0, 21.0, m_main_panel)
		
		m_txf_search = New dui_CheckBox.Create("txf_search", "Search Image?", 265.0, 13.0, dui_ALIGN_LEFT, m_main_panel)
		m_txf_search.SetTicked(m_textfield.m_issearch)
		
		m_dateselector = New dui_Date.Create("dateselector", 10.0, 40.0, 190.0, 21.0, 2000, 2015, m_main_panel)
		
		m_test_canvas = New dui_Canvas.Create("test_canvas", 15.0, 90.0, 220.0, 140.0, m_main_panel, True, False)
		m_test_canvas.SetRenderCallback(CanvasDraw)
		m_test_canvas.SetColorParams(0.0, 0.0, 0.0)
		m_test_canvas.SetAlpha(0.6)
		
		m_data_table = New dui_Table.Create("data_table", 240.0, 90.0, 160.0, "Name", 145, 21.0, True, m_main_panel)
		m_data_table.AddColumn("Information", 45, False)
		m_data_table.AddItemByData(["John Smith", "KIA"],, , False)
		m_data_table.AddItemByData(["Jane Smith", "KIA"],, , False)
		m_data_table.Refresh()
		
		' A panel, inside another panel!
		'm_inpanel = New dui_Panel.Create("in_panel", 5.0, 5.0, 450.0, 250.0, True, m_main_panel)
		'm_inpanel.SetColorParams(0.5, 0.27, 0.31)
		'm_inpanel.SetAlpha(0.6)
		
		m_fps_label = New dui_Label.Create("fps_label", "", 10.0, 10.0, 60.0, 20.0, 0, 0, Null)
		m_fps_label.SetTextColorParams(1.0, 1.0, 1.0)
		m_main_screen.AddGadget(m_fps_label)
		
		'For Local gadget:dui_Gadget = EachIn New TListReversed.Create(main_screen.m_children)
		'	Print(gadget.m_name)
		'	For Local gadget2:dui_Gadget = EachIn New TListReversed.Create(gadget.m_children)
		'		Print("~t" + gadget2.m_name)
		'	Next
		'Next
	End Method
	
	Method Run()
		m_gdriver.SetBlend(BLEND_ALPHA)
		While KeyDown(KEY_ESCAPE) = False And AppTerminate() = False
			m_graphics.Cls()
			
			Update()
			Render()
			
			m_graphics.Flip()
			Delay(2)
		Wend
		
		Shutdown()
	End Method
	
	Method Render()
		TDUIMain.Refresh()
	End Method
	
	Method Update()
		TFPSCounter.Update()
		m_fps_label.SetText("FPS:" + String(TFPSCounter.GetFPS()) + "; " + m_textfield.m_cursorpos)
		
		If KeyDown(KEY_SPACE) = True
			m_backimage_gadget.Show()
		Else
			m_backimage_gadget.Hide()
		End If
		
		HandleEvents()
	End Method
	
	Method HandleEvents()
		Local event:dui_Event
		
		While dui_Event.PollEvent()
			event = dui_Event.GetCurrentEvent()
			'If event.id <> dui_EVENT_MOUSEOVER
			'	Print(event.ToString())
			'End If
			
			Select event.m_id
				Case dui_EVENT_GADGETACTION
					Select event.m_source
						Case m_alpha_slider
							m_main_panel.SetAlpha(Float(m_alpha_slider.GetValue() * 0.01), 0, True)
						Case m_txf_search
							m_textfield.m_issearch = m_txf_search.GetTicked()
							m_textfield.Refresh()
						Case m_txf_clear
							m_textfield.Clear()
					End Select
			End Select
		Wend
	End Method
	
	Method OnExit()
		' The super OnExit method will destroy the graphical context
		Super.OnExit()
	End Method
	
	Function CanvasDraw(x:Float, y:Float, canvas:dui_Canvas)
		Local dtext:String = "Son of a goose!", i:Int
		
		TProtog2DDriver.SetBlend(BLEND_ALPHA)
		TProtogDrawState.m_defaultstate.SetStates(True, True, False, False, False, False)
		
		x:+5.0; y:+70.0
		For i = 0 To dtext.Length
			dui_FontManager.RenderString(dtext[i - 1..i], canvas.m_font, x, y - Cos(MilliSecs()) * 10.0)
			y:+Sin(MilliSecs()) * 0.75
			x:+dui_FontManager.StringWidth(dtext[i - 1..i], canvas.m_font)
		Next
	End Function
	
End Type
