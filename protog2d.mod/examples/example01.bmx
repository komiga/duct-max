
Rem
	example01.bmx
	Tests the basics of the GLMax2D Extended driver.
End Rem

SuperStrict

Framework brl.blitz
Import brl.standardio

Import duct.graphix
Import duct.protog2d

Global mainapp:MyGraphicsApp = New MyGraphicsApp.Create()

mainapp.Run()

Type MyGraphicsApp Extends TDGraphicsApp
	
	Field m_driver_context:TProtog2DDriver
	Field m_mouse:TVec2
	
		Method New()
			m_mouse = New TVec2
		End Method
		
		Method Create:MyGraphicsApp()
			Super.Create()
			Return Self
		End Method
		
		Method OnInit()
			m_graphics = New TDGraphics.Create(800, 600, 0, 60, 0, 0, True)
			m_driver_context = m_graphics.m_driver_context
			
			'm_graphics.SetVSyncState(0)
		End Method
		
		Method Run()
			
			m_driver_context.SetDrawingColor(1.0, 0.0, 0.0)
			While KeyDown(KEY_ESCAPE) = False And AppTerminate() = False
				m_graphics.Cls()
				
				Update()
				Render()
				
				m_graphics.Flip()
			Wend
			
			Shutdown()
			
		End Method
		
		Method Render()
			GLDrawText("FPS: " + TFPSCounter.GetFPS(), 0.0, 0.0)
			GLDrawText("Testing Graphics!!", m_mouse.m_x, m_mouse.m_y)
			'DrawRect(0.0, 0.0, 324.0, 168.0)
		End Method
		
		Method Update()
			m_mouse.Set(Float(MouseX()), Float(MouseY()))
			TFPSCounter.Update()
		End Method
		
		Method OnExit()
			' The super OnExit method will destroy the graphical context
			Super.OnExit()
			
			m_mouse = Null
			
		End Method
		
End Type












































