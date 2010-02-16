
Rem
	example01.bmx
	Tests the basics of the Protog2D driver.
End Rem

SuperStrict

Framework brl.blitz
Import brl.standardio
Import brl.system
Import brl.textstream

Import brl.bmploader
Import brl.jpgloader
Import brl.pngloader

Import duct.protog2d

Global mainapp:MyGraphicsApp = New MyGraphicsApp.Create()
mainapp.Run()
End

Type MyGraphicsApp Extends TDProtogGraphicsApp
	
	Field m_gdriver:TProtog2DDriver
	Field m_mvisible:Int = True
	Field m_font:TProtogFont
	Field m_color_white:TProtogColor, m_color_grey:TProtogColor
	Field m_testtext:TProtogTextEntity, m_infotext:TProtogTextEntity
	
	Method New()
	End Method
	
	Method Create:MyGraphicsApp()
		Super.Create()
		Return Self
	End Method
	
	Method OnInit()
		m_graphics = New TDProtogGraphics.Create(800, 600, 0, 60,, 0, False)
		If m_graphics.StartGraphics() = False
			Print("Failed to open graphics mode!")
			End
		End If
		m_gdriver = m_graphics.GetDriverContext()
		m_gdriver.SetRenderBufferOnFlip(False)
		m_gdriver.UnbindRenderBuffer()
		
		InitResources()
		InitEntities()
	End Method
	
	Method InitResources()
		m_color_white = New TProtogColor.Create()
		m_color_grey = New TProtogColor.Create(0.6, 0.6, 0.6)
		m_font = New TProtogFont.FromNode(New TSNode.LoadScriptFromObject("fonts/arial.font"), True)
	End Method
	
	Method InitEntities()
		m_testtext = New TProtogTextEntity.Create(LoadText("text.txt"), m_font, New TVec2, New TProtogColor.Create(0.2, 0.5, 0.8))
		
		m_infotext = New TProtogTextEntity.Create("fps: {fps} - vsync: {vsync} - mvisible: {mvisible}~n" + ..
			"~tControls: F1 - vsync on/off~n" + ..
			"~tSpace - mouse visibility~n" + ..
			"~tRight click - vertical centering~n" + ..
			"~tLeft click - horizontal centering",  ..
			m_font, New TVec2.Create(2.0, 2.0), m_color_grey)
		
		m_infotext.SetupReplacer()
		m_infotext.SetReplacementByName("vsync", m_graphics.GetVSyncState())
		m_infotext.SetReplacementByName("mvisible", m_mvisible)
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
		m_infotext.Render()
		m_testtext.Render()
	End Method
	
	Method Update()
		m_testtext.SetPositionParams(Float(MouseX()), Float(MouseY()))
		
		TFPSCounter.Update()
		m_infotext.SetReplacementByName("fps", TFPSCounter.GetFPS())
		
		If KeyHit(KEY_F1) = True
			m_graphics.SetVSyncState(m_graphics.GetVSyncState() ~1)
			m_infotext.SetReplacementByName("vsync", m_graphics.GetVSyncState())
		End If
		
		If KeyHit(KEY_SPACE) = True
			If m_mvisible = True
				HideMouse()
			Else If m_mvisible = False
				ShowMouse()
			End If
			m_mvisible:~1
			m_infotext.SetReplacementByName("mvisible", m_mvisible)
		End If
		
		If KeyHit(KEY_A) = True
			m_gdriver.m_renderbuffer.m_glbuffers[0] = GL_COLOR_ATTACHMENT0_EXT + 1
			m_gdriver.m_renderbuffer.m_glbuffers[1] = GL_COLOR_ATTACHMENT0_EXT + 0
			m_gdriver.m_renderbuffer.Bind()
		End If
		If KeyHit(KEY_B) = True
			m_gdriver.m_renderbuffer.m_glbuffers[0] = GL_COLOR_ATTACHMENT0_EXT + 1
			m_gdriver.m_renderbuffer.m_glbuffers[1] = GL_COLOR_ATTACHMENT0_EXT + 0
			m_gdriver.m_renderbuffer.Bind()
		End If
		
		m_testtext.SetHCentering(MouseDown(MOUSE_LEFT))
		m_testtext.SetVCentering(MouseDown(MOUSE_RIGHT))
	End Method
	
	Method OnExit()
		' The super OnExit method will destroy the graphical context
		Super.OnExit()
	End Method
	
End Type

