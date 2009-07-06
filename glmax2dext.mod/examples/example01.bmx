
Rem
	
	example01.bmx
	
	Tests the basics of the GLMax2D Extended driver.
	
End Rem


SuperStrict

Framework brl.blitz
Import brl.standardio

Import duct.graphix
Import duct.glmax2dext

Global mainapp:MyGraphicsApp = New MyGraphicsApp.Create()

mainapp.Run()

Type MyGraphicsApp Extends TDGraphicsApp
	
	Field m_oglext_context:TGLMax2DExtDriver
	Field m_mouse:TVec2
	
		Method New()
			
			m_mouse = New TVec2
			
		End Method
		
		Method Create:MyGraphicsApp()
			
			Super.Create()
			
			Return Self
			
		End Method
		
		Method OnInit()
			
			m_graphics = New TDGraphics.Create(DGFX_DRIVER_OGLEXT, 512, 512,,, GRAPHICS_BACKBUFFER, True)
			m_oglext_context = m_graphics.m_driver_context_oglext
			
		End Method
		
		Method Run()
			
			' Just to make sure..
			m_oglext_context.BindRenderBuffer()
			'm_oglext_context.UnbindRenderBuffer()
			
			While KeyDown(KEY_ESCAPE) = False And AppTerminate() = False
				
				m_graphics.Cls()
				
				Update()
				Render()
				
				'm_oglext_context.DrawRenderBuffer()
				m_graphics.Flip(0)
				
			Wend
			
		End Method
		
		Method Render()
			
			SetColor(255, 0, 0)
			DrawText("FPS: " + TFPSCounter.GetFPS(), 0.0, 0.0)
			
			DrawText("Testing Graphics!!", m_mouse.m_x, m_mouse.m_y)
			'DrawRect(0.0, 0.0, 324.0, 168.0)
			
		End Method
		
		Method Update()
			
			m_mouse.Set(Float(MouseX()), Float(MouseY()))
			
			TFPSCounter.Update()
			
		End Method
		
End Type












































