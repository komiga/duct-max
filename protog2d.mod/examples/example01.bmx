
Rem
	example01.bmx
	Tests the basics of the GLMax2D Extended driver.
End Rem

SuperStrict

Framework brl.blitz
Import brl.standardio
Import brl.system
Import brl.textstream

Import brl.bmploader
Import brl.jpgloader
Import brl.pngloader

Import duct.graphix
Import duct.protog2d

Global mainapp:MyGraphicsApp = New MyGraphicsApp.Create()

mainapp.Run()

Type MyGraphicsApp Extends TDGraphicsApp
	
	Field m_gdriver:TProtog2DDriver
	Field m_font:TProtogFont
	Field m_mouse:TVec2, m_mvisible:Int = True
	Field m_text:String
	
	Method New()
		m_mouse = New TVec2
	End Method
	
	Method Create:MyGraphicsApp()
		Super.Create()
		Return Self
	End Method
	
	Method OnInit()
		
		m_graphics = New TDGraphics.Create(800, 600, 0, 60,, 0, False)
		If m_graphics.StartGraphics() = False
			Print("Failed to open graphics mode!")
			End
		End If
		
		m_gdriver = m_graphics.m_driver_context
		
		m_font = New TProtogFont.FromNode(New TSNode.LoadScriptFromObject("fonts/arial.font"), True)
		m_text = LoadText("text.txt")
		
	End Method
	
	Method Run()
		
		m_gdriver.SetBlend(BLEND_ALPHA)
		While KeyDown(KEY_ESCAPE) = False And AppTerminate() = False
			m_graphics.Cls()
			
			Update()
			Render()
			
			m_graphics.Flip()
			Delay(1)
		Wend
		
		Shutdown()
		
	End Method
	
	Method Render()
		m_gdriver.SetDrawingColor(0.6, 0.6, 0.6)
		m_font.DrawString("FPS: " + TFPSCounter.GetFPS() + ", " + m_graphics.GetVSyncState() + ", " + m_mvisible + "~n" + ..
		"Controls: F1 - vsync on/off, Space - mouse visibility, Right click - vertical centering, Left click - horizontal centering", New TVec2.Create(2.0, 2.0))
		
		m_gdriver.SetDrawingColor(0.2, 0.5, 0.8)
		m_font.DrawString(m_text, m_mouse, MouseDown(MOUSE_LEFT), MouseDown(MOUSE_RIGHT))
	End Method
	
	Method Update()
		m_mouse.Set(MouseX(), MouseY())
		TFPSCounter.Update()
		
		If KeyHit(KEY_F1) = True
			m_graphics.SetVSyncState(m_graphics.GetVSyncState() ~1)
		End If
		
		If KeyHit(KEY_SPACE) = True
			If m_mvisible = True
				HideMouse()
			Else If m_mvisible = False
				ShowMouse()
			End If
			m_mvisible:~1
		End If
	End Method
	
	Method OnExit()
		' The super OnExit method will destroy the graphical context
		Super.OnExit()
		
		m_mouse = Null
		
	End Method
	
End Type












































