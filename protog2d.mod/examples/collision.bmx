
Rem
	example01.bmx
	Tests xroads.p2d collision.
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
Import ductdev.p2d

Global mainapp:MyGraphicsApp = New MyGraphicsApp.Create()
mainapp.Run()
End

Type MyGraphicsApp Extends TDProtogGraphicsApp
	
	Field m_gdriver:TProtog2DDriver
	
	Field m_font:TProtogFont
	Field m_bmaxlogo:TProtogTexture
	Field m_color_white:TProtogColor, m_color_grey:TProtogColor, m_color_highlight:TProtogColor
	
	Field m_infotext:TProtogTextEntity, m_bmaxsprite:TProtogSpriteEntity
	
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
		m_color_white = New TProtogColor.Create(1.0, 1.0, 1.0)
		TProtogEntity.SetDefaultColor(m_color_white)
		m_color_grey = New TProtogColor.Create(0.6, 0.6, 0.6)
		m_color_highlight = New TProtogColor.Create(1.0, 0.0, 0.0)
		
		m_font = New TProtogFont.FromNode(New TSNode.LoadScriptFromObject("fonts/arial.font"), True)
		TProtogTextEntity.SetDefaultFont(m_font)
		
		m_bmaxlogo = New TProtogTexture.Create(LoadPixmap("textures/max.png"), TEXTURE_RECTANGULAR, True)
	End Method
	
	Method InitEntities()
		m_infotext = New TProtogTextEntity.Create("fps: {fps} - vsync: {vsync}~n" + ..
			"~tControls: F1 - vsync on/off",  ..
		, New TVec2.Create(2.0, 2.0), m_color_grey)
		
		m_infotext.SetupReplacer()
		m_infotext.SetReplacementByName("vsync", m_graphics.GetVSyncState())
		
		m_bmaxsprite = New TProtogSpriteEntity.Create(m_bmaxlogo, New TVec2.Create(44.0, 44.0))
	End Method
	
	Method Run()
		m_gdriver.SetBlend(BLEND_ALPHA)
		While KeyDown(KEY_ESCAPE) = False And AppTerminate() = False
			m_graphics.Cls()
			TProtog2DCollision.ResetCollisions(ECollisionLayers.LAYER_1)
			
			Update()
			Render()
			
			m_graphics.Flip()
			Delay(2)
		Wend
		
		Shutdown()
	End Method
	
	Method Render()
		m_bmaxsprite.Render()
		m_infotext.Render()
	End Method
	
	Method Update()
		
		' Entities
		'm_bmaxsprite.SetPositionParams(MouseX() - (m_bmaxlogo.GetWidth() / 2), MouseY () - (m_bmaxlogo.GetHeight() / 2))
		If KeyHit(KEY_F2) = True
			DebugStop
		End If
		
		Local pos:TVec2 = m_bmaxsprite.m_pos, size:TVec2 = m_bmaxsprite.m_size
		TProtog2DCollision.CollideTexture(m_bmaxsprite.m_texture, pos.m_x, pos.m_y, 0, ECollisionLayers.LAYER_1, m_bmaxsprite)
		
		Local objs:Object[]
		objs = TProtog2DCollision.CollideRect(MouseX(), MouseY(), 1.0, 1.0, ECollisionLayers.LAYER_1, 0, Null)
		If objs <> Null
			If objs[0] = m_bmaxsprite
				DebugLog("Collided with sprite!!")
				m_bmaxsprite.SetColor(m_color_highlight)
			End If
		Else
			m_bmaxsprite.SetColor(m_color_white)
			DebugLog("Not colliding")
		End If
		
		TFPSCounter.Update()
		m_infotext.SetReplacementByName("fps", TFPSCounter.GetFPS())
		
		If KeyHit(KEY_F1) = True
			m_graphics.SetVSyncState(m_graphics.GetVSyncState() ~1)
			m_infotext.SetReplacementByName("vsync", m_graphics.GetVSyncState())
		End If
	End Method
	
	Method OnExit()
		' The super OnExit method will destroy the graphical context
		Super.OnExit()
	End Method
	
End Type


















