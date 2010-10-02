
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
	Field m_font:dProtogFont
	Field m_color_white:dProtogColor, m_color_grey:dProtogColor
	Field m_bmaxlogo:dProtogTexture
	
	Field m_infotext:dProtogTextEntity, m_bmaxsprite:dProtogSpriteEntity
	
	Field m_hueshader:dProtogShader, m_blurshader:dProtogShader, m_saturationshader:dProtogShader
	Field m_shadersenabled:Int = True
	
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
		m_gdriver.UseRenderPasses(False)
		InitResources()
		InitShaders()
		InitEntities()
	End Method
	
	Method InitResources()
		m_color_white = New dProtogColor.Create(1.0, 1.0, 1.0)
		dProtogEntity.SetDefaultColor(m_color_white)
		m_color_grey = New dProtogColor.Create(0.6, 0.6, 0.6)
		m_font = New dProtogFont.FromNode(dScriptFormatter.LoadFromFile("fonts/arial.font"), True)
		dProtogTextEntity.SetDefaultFont(m_font)
		m_bmaxlogo = New dProtogTexture.Create(LoadPixmap("textures/max.png"), TEXTURE_RECTANGULAR, True)
	End Method
	
	Method InitShaders()
		Local mat:dProtogMaterial = New dProtogMaterial.Create("shaders/blur")
		m_blurshader = LoadShader("shaders/blur.glsl", mat)
		mat = New dProtogMaterial.Create("shaders/saturation")
		m_saturationshader = LoadShader("shaders/saturation.glsl", mat)
		mat = New dProtogMaterial.Create("shaders/hue")
		mat.SetVec3("hue", New dVec3.Create(0.0, 0.4, 0.0))
		m_hueshader = LoadShader("shaders/hue.glsl", mat)
		m_gdriver.AddRenderPassShader(m_hueshader)
		m_gdriver.AddRenderPassShader(m_blurshader)
	End Method
	
	Method InitEntities()
		m_infotext = New dProtogTextEntity.Create("fps: {fps} - vsync: {vsync} - shaders: {shaders}~n" + ..
			"~tControls: F1 - vsync on/off~n" + ..
			"~tSpace - Shaders on/off~n" + ..
			"~tF2-F4 - Toggle individual shaders",, New dVec2.Create(2.0, 2.0), m_color_grey)
		m_infotext.SetupReplacer()
		m_infotext.SetReplacementsWithName("vsync", m_graphics.GetVSyncState())
		m_infotext.SetReplacementsWithName("shaders", m_shadersenabled)
		m_bmaxsprite = New dProtogSpriteEntity.Create(m_bmaxlogo)
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
		If m_shadersenabled
			m_gdriver.BindRenderBuffer()
		End If
		m_graphics.Cls()
		m_bmaxsprite.Render()
		If m_shadersenabled
			m_gdriver.UseRenderPasses(True)
			m_gdriver.RenderRenderBuffer()
			m_gdriver.UseRenderPasses(False)
			m_gdriver.UnbindRenderBuffer()
			m_gdriver.RenderRenderBuffer(False)
		End If
		m_infotext.Render()
		m_graphics.Flip()
	End Method
	
	Method Update()
		m_bmaxsprite.SetPositionParams(MouseX() - (m_bmaxlogo.GetWidth() / 2), MouseY () - (m_bmaxlogo.GetHeight() / 2))
		TFPSCounter.Update()
		m_infotext.SetReplacementsWithName("fps", TFPSCounter.GetFPS())
		If KeyHit(KEY_F1)
			m_graphics.SetVSyncState(m_graphics.GetVSyncState() ~ 1)
			m_infotext.SetReplacementsWithName("vsync", m_graphics.GetVSyncState())
		End If
		If KeyHit(KEY_SPACE)
			ToggleShaders()
			m_infotext.SetReplacementsWithName("shaders", m_shadersenabled)
		End If
		If KeyHit(KEY_F2)
			If m_gdriver.ContainsRenderPassShader(m_blurshader)
				m_gdriver.RemoveRenderPassShader(m_blurshader)
			Else
				m_gdriver.AddRenderPassShader(m_blurshader)
			End If
		End If
		If KeyHit(KEY_F3)
			If m_gdriver.ContainsRenderPassShader(m_hueshader)
				m_gdriver.RemoveRenderPassShader(m_hueshader)
			Else
				m_gdriver.AddRenderPassShader(m_hueshader)
			End If
		End If
		If KeyHit(KEY_F4)
			If m_gdriver.ContainsRenderPassShader(m_saturationshader)
				m_gdriver.RemoveRenderPassShader(m_saturationshader)
			Else
				m_gdriver.AddRenderPassShader(m_saturationshader)
			End If
		End If
	End Method
	
	Method ToggleShaders()
		m_shadersenabled:~1
	End Method
	
	Method LoadShader:dProtogShader(file:String, mat:dProtogMaterial)
		Local shader:dProtogShader
		Try
			shader = New dProtogShader.CreateFromSourceFiles("shaders/vert.glsl", file, mat)
		Catch e:Object
			DebugLog("Exception caught: " + e.ToString())
			End
		End Try
		Return shader
	End Method
	
	Method OnExit()
		' The super OnExit method will destroy the graphical context
		Super.OnExit()
	End Method
	
End Type

