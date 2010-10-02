
Rem
	example01.bmx
	Tests the basics of the Protog2D driver.
End Rem

SuperStrict

Framework brl.blitz
Import brl.standardio
Import brl.system
Import brl.textstream

Import brl.pngloader

Import duct.protog2d
Import duct.scriptparser

Global mainapp:MyGraphicsApp = New MyGraphicsApp.Create()
mainapp.Run()
End

Type MyGraphicsApp Extends dProtogGraphicsApp
	
	Field m_gdriver:dProtog2DDriver
	Field m_mvisible:Int = True
	Field m_font:dProtogFont
	Field m_color_white:dProtogColor, m_color_grey:dProtogColor
	Field m_testtext:dProtogTextEntity, m_infotext:dProtogTextEntity
	
	Method Create:MyGraphicsApp()
		Super.Create()
		Return Self
	End Method
	
	Method OnInit()
		m_graphics = New dProtogGraphics.Create(800, 600, 0, 60,, 0, False)
		If Not m_graphics.StartGraphics()
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
		m_color_white = New dProtogColor.Create()
		m_color_grey = New dProtogColor.Create(0.6, 0.6, 0.6)
		m_font = New dProtogFont.FromNode(dScriptFormatter.LoadFromFile("fonts/arial.font"), True)
	End Method
	
	Method InitEntities()
		m_testtext = New dProtogTextEntity.Create(LoadText("text.txt"), m_font, New dVec2, New dProtogColor.Create(0.2, 0.5, 0.8))
		m_infotext = New dProtogTextEntity.Create("fps: {fps} - vsync: {vsync} - mvisible: {mvisible}~n" + ..
			"~tControls: F1 - vsync on/off~n" + ..
			"~tSpace - mouse visibility~n" + ..
			"~tRight click - vertical centering~n" + ..
			"~tLeft click - horizontal centering", m_font, New dVec2.Create(2.0, 2.0), m_color_grey)
		m_infotext.SetupReplacer()
		m_infotext.SetReplacementsWithName("vsync", m_graphics.GetVSyncState())
		m_infotext.SetReplacementsWithName("mvisible", m_mvisible)
	End Method
	
	Method Run()
		m_gdriver.SetBlend(BLEND_ALPHA)
		While Not KeyDown(KEY_ESCAPE) And Not AppTerminate()
			Update()
			Render()
			'Delay(2)
		Wend
		Shutdown()
	End Method
	
	Method Render()
		m_graphics.Cls()
		m_infotext.Render()
		m_testtext.Render()
		m_graphics.Flip()
	End Method
	
	Method Update()
		m_testtext.SetPositionParams(Float(MouseX()), Float(MouseY()))
		TFPSCounter.Update()
		m_infotext.SetReplacementsWithName("fps", TFPSCounter.GetFPS())
		If KeyHit(KEY_F1)
			m_graphics.SetVSyncState(m_graphics.GetVSyncState() ~1)
			m_infotext.SetReplacementsWithName("vsync", m_graphics.GetVSyncState())
		End If
		If KeyHit(KEY_SPACE)
			If m_mvisible
				HideMouse()
			Else
				ShowMouse()
			End If
			m_mvisible:~ 1
			m_infotext.SetReplacementsWithName("mvisible", m_mvisible)
		End If
		m_testtext.SetHCentering(MouseDown(MOUSE_LEFT))
		m_testtext.SetVCentering(MouseDown(MOUSE_RIGHT))
	End Method
	
	Method OnExit()
		' The super OnExit method will destroy the graphical context
		Super.OnExit()
	End Method
	
End Type

