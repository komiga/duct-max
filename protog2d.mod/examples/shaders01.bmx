
Rem
	shaders.bmx
	Tests Protog2D shaders.
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
	Field m_font:TProtogFont
	Field m_color_white:TProtogColor, m_color_grey:TProtogColor
	Field m_bmaxlogo:TProtogTexture
	
	Field m_infotext:TProtogTextEntity, m_bmaxsprite:TProtogSpriteEntity
	
	Field m_hueshader:TProtogShader, m_blurshader:TProtogShader, m_saturationshader:TProtogShader
	Field m_shadersenabled:Int = True
	
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
		m_gdriver.UseRenderPasses(False)
		
		InitResources()
		InitShaders()
		InitEntities()
	End Method
	
	Method InitResources()
		m_color_white = New TProtogColor.Create(1.0, 1.0, 1.0)
		TProtogEntity.SetDefaultColor(m_color_white)
		m_color_grey = New TProtogColor.Create(0.6, 0.6, 0.6)
		
		m_font = New TProtogFont.FromNode(New TSNode.LoadScriptFromObject("fonts/arial.font"), True)
		TProtogTextEntity.SetDefaultFont(m_font)
		
		m_bmaxlogo = New TProtogTexture.Create(LoadPixmap("textures/max.png"), TEXTURE_RECTANGULAR, True)
	End Method
	
	Method InitShaders()
		Local mat:TProtogMaterial
		
		mat = New TProtogMaterial.Create("shaders/blur")
		m_blurshader = LoadShader("shaders/blur.glsl", mat)
		
		mat = New TProtogMaterial.Create("shaders/saturation")
		m_saturationshader = LoadShader("shaders/saturation.glsl", mat)
		
		mat = New TProtogMaterial.Create("shaders/hue")
		mat.SetVec3("hue", New TVec3.Create(0.0, 0.4, 0.0))
		m_hueshader = LoadShader("shaders/hue.glsl", mat)
		
		m_gdriver.AddRenderPassShader(m_hueshader)
		m_gdriver.AddRenderPassShader(m_blurshader)
	End Method
	
	Method InitEntities()
		m_infotext = New TProtogTextEntity.Create("fps: {fps} - vsync: {vsync} - shaders: {shaders}~n" + ..
			"~tControls: F1 - vsync on/off~n" + ..
			"~tSpace - Shaders on/off~n" + ..
			"~tF1-F3 - Toggle individual shaders",  ..
		, New TVec2.Create(2.0, 2.0), m_color_grey)
		
		m_infotext.SetupReplacer()
		m_infotext.SetReplacementByName("vsync", m_graphics.GetVSyncState())
		m_infotext.SetReplacementByName("shaders", m_shadersenabled)
		
		m_bmaxsprite = New TProtogSpriteEntity.Create(m_bmaxlogo)
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
		
		If m_shadersenabled = True
			m_gdriver.BindRenderBuffer()
			m_graphics.Cls()
		End If
		
		m_bmaxsprite.Render()
		
		If m_shadersenabled = True
			m_gdriver.UseRenderPasses(True)
			m_gdriver.DrawRenderBuffer()
			m_gdriver.UseRenderPasses(False)
			
			m_gdriver.UnbindRenderBuffer()
			m_gdriver.DrawRenderBuffer(False)
		End If
		
		m_infotext.Render()
	End Method
	
	Method Update()
		' Entities
		m_bmaxsprite.SetPositionParams(MouseX() - (m_bmaxlogo.GetWidth() / 2), MouseY () - (m_bmaxlogo.GetHeight() / 2))
		TFPSCounter.Update()
		m_infotext.SetReplacementByName("fps", TFPSCounter.GetFPS())
		
		If KeyHit(KEY_F1) = True
			m_graphics.SetVSyncState(m_graphics.GetVSyncState() ~1)
			m_infotext.SetReplacementByName("vsync", m_graphics.GetVSyncState())
		End If
		
		If KeyHit(KEY_SPACE) = True
			ToggleShaders()
			m_infotext.SetReplacementByName("shaders", m_shadersenabled)
		End If
		
		' Shaders
		If KeyHit(KEY_F2) = True
			If m_gdriver.ContainsRenderPassShader(m_blurshader) = True
				m_gdriver.RemoveRenderPassShader(m_blurshader)
			Else
				m_gdriver.AddRenderPassShader(m_blurshader)
			End If
		End If
		If KeyHit(KEY_F3) = True
			If m_gdriver.ContainsRenderPassShader(m_hueshader) = True
				m_gdriver.RemoveRenderPassShader(m_hueshader)
			Else
				m_gdriver.AddRenderPassShader(m_hueshader)
			End If
		End If
		If KeyHit(KEY_F4) = True
			If m_gdriver.ContainsRenderPassShader(m_saturationshader) = True
				m_gdriver.RemoveRenderPassShader(m_saturationshader)
			Else
				m_gdriver.AddRenderPassShader(m_saturationshader)
			End If
		End If
		
	End Method
	
	Method ToggleShaders()
		m_shadersenabled:~1
	End Method
	
	Method LoadShader:TProtogShader(file:String, mat:TProtogMaterial)
		Local shader:TProtogShader
		Try
			shader = New TProtogShader.CreateFromDualFile(file, mat, False, True)
		Catch e:Object
			DebugLog("Exception caught: ~n" + e.ToString())
			End
		End Try
		
		Return shader
	End Method
	
	Method OnExit()
		' The super OnExit method will destroy the graphical context
		Super.OnExit()
	End Method
	
End Type


















