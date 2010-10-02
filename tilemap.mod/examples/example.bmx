
SuperStrict

Framework brl.blitz
Import brl.standardio
Import brl.pngloader

Import brl.map
Import brl.random
Import brl.filesystem
Import brl.stream

Import brl.bank
Import brl.bankstream

Import duct.etc
Import duct.protog2d
Import duct.tilemap
Import duct.scriptparser

Global t_light_env:dTemplate = New dTemplate.Create(["env"], [[TV_FLOAT], [TV_FLOAT], [TV_FLOAT], [TV_FLOAT]], False)
Global t_light_ambient:dTemplate = New dTemplate.Create(["ambient"], [[TV_FLOAT], [TV_FLOAT], [TV_FLOAT], [TV_FLOAT]], False)
Global t_light_diffuse:dTemplate = New dTemplate.Create(["diffuse"], [[TV_FLOAT], [TV_FLOAT], [TV_FLOAT], [TV_FLOAT]], False)
Global t_light_specular:dTemplate = New dTemplate.Create(["specular"], [[TV_FLOAT], [TV_FLOAT], [TV_FLOAT], [TV_FLOAT]], False)

Global mainapp:MyApp = New MyApp.Create()
mainapp.Run()
End

Type MyApp Extends dProtogGraphicsApp
	
	Field m_gdriver:dProtog2DDriver
	
	Field m_font:dProtogFont
	Field m_color_white:dProtogColor
	Field m_staticres:dMapResourceSet, m_resources:dMapResourceSet
	
	Field m_resids:Int[]
	Field m_map:dTileMap, m_maphandler:TMyMapHandler, m_environment:dMapEnvironment
	
	Field m_omz:Int
	Field m_tilerange:Int, m_tilerange_low:Int
	
	Field m_infotext:dProtogTextEntity
	Field m_updatetimer:dMSTimer, m_lftime:Int
	
	Method Create:MyApp()
		Super.Create()
		Return Self
	End Method
	
	Method OnInit()
		m_graphics = New dProtogGraphics.Create(1024, 768, 0, 60,, 0, False)
		If Not m_graphics.StartGraphics()
			Print("Failed to open graphics mode!")
			End
		End If
		m_gdriver = m_graphics.GetDriverContext()
		m_gdriver.SetRenderBufferOnFlip(False)
		m_gdriver.UnbindRenderBuffer()
		m_gdriver.SetBlend(BLEND_ALPHA)
		'dTileMap.InitGL()
		InitGLLight()
		Try
			InitResources()
			InitMap()
		Catch e:Object
			Print("Caught exception: " + e.ToString())
			End
		End Try
		InitEntities()
		UpdateLight()
		m_lftime = FileTime("light.script")
	End Method
	
	Method InitResources()
		m_color_white = New dProtogColor.Create(1.0, 1.0, 1.0, 1.0)
		m_font = New dProtogFont.FromNode(dScriptFormatter.LoadFromFile("fonts/arial.font"), True)
		m_resources = dMapResourceSet.LoadFromFile("tiles.dts")
		m_staticres = dMapResourceSet.LoadFromFile("statics.dts")
		m_environment = New dMapEnvironment.Create(1.0, 1.0, 1.0)
		m_updatetimer = New dMSTimer.Create(200)
	End Method
	
	Method InitMap()
		m_map = dTileMap.LoadFromFile("map_test.map")
		If Not m_map
			Throw "Failed to load map_test.map"
		End If
		m_maphandler = New TMyMapHandler.Create(m_map)
		m_map.SetHandler(m_maphandler)
		m_map.SetTileResourceMap(m_resources)
		m_map.SetStaticResourceMap(m_staticres)
		m_map.SetEnvironment(m_environment)
		
		m_map.SetWindowDimensions(170, 35, 800, 600)
		DebugLog("chunks: " + m_map.GetChunkCount())
		DebugLog("width: " + m_map.GetWidth() + " height: " + m_map.GetHeight())
		m_resids = New Int[m_resources.Count()]
		Local ii:Int, res:dMapResource
		For Local i:Int = 0 Until m_resources.Count()
			ii = 0
			For res = EachIn m_resources
				If ii = i
					m_resids[i] = res.GetID()
					Exit
				End If
				ii:+ 1
			Next
		Next
		m_map.UpdateAllTileResources()
		m_map.UpdateAllStaticResources()
		m_tilerange = m_resources.Count() - 1
	End Method
	
	Method InitEntities()
		m_infotext = New dProtogTextEntity.Create("fps: {fps} - [ {tilerange_low} - {tilerange} ]",  ..
		m_font, New dVec2.Create(2.0, 2.0), m_color_white)
		m_infotext.SetupReplacer()
		m_infotext.SetReplacementsWithName("tilerange_low", m_tilerange_low)
		m_infotext.SetReplacementsWithName("tilerange", m_tilerange)
	End Method
	
	Method UpdateLight()
		Local node:dNode
		Try
			node = dScriptFormatter.LoadFromFile("light.script")
		Catch e:Object
			DebugLog("Caught exception reading light.script: " + e.ToString())
			Return
		End Try
		If node
			Local USING_GL_LIGHT:Int = dTileMap.USING_GL_LIGHT
			Local color:Float[4], pname:Int, i:Int, f:dFloatVariable
			For Local iden:dIdentifier = EachIn node
				'If t_light_env.ValidateIdentifier(iden)
				'	i = 0
				'	For f = EachIn iden
				'		color[i] = f.Get()
				'		i:+ 1
				'	Next
				'	glLightfv(USING_GL_LIGHT, pname, color)
				If t_light_ambient.ValidateIdentifier(iden)
					pname = GL_AMBIENT
				Else If t_light_specular.ValidateIdentifier(iden)
					pname = GL_SPECULAR
				Else If t_light_diffuse.ValidateIdentifier(iden)
					pname = GL_DIFFUSE
				End If
				If pname
					i = 0
					For f = EachIn iden
						color[i] = f.Get()
						i:+ 1
					Next
					glLightfv(USING_GL_LIGHT, pname, color)
					If pname = GL_AMBIENT
						m_environment.SetAmbientColorParams(color[0], color[1], color[2], color[3])
					End If
					Print("(UpdateLight) type:" + iden.GetName() + ", color:" + color[0] + ", " + color[1] + ", " + color[2] + ", " + color[3])
					pname = 0
				End If
			Next
		Else
			DebugLog("Could not open light.script")
		End If
	End Method
	
	Method Run()
		While Not KeyDown(KEY_ESCAPE) And Not AppTerminate()
			m_graphics.Cls()
			Update()
			Render()
			m_graphics.Flip()
			Delay(12)
		Wend
		Shutdown()
	End Method
	
	Method Render()
		Local tiley:Float, tilex:Float, tile:dMapResource
		Local y:Int, x:Int, rid:Int, dtile:dDrawnTile
		Local drawtime:Int = MilliSecs()
		m_map.Render()
		m_color_white.Bind()
		m_font.RenderStringParams("Draw time: " + String(MilliSecs() - drawtime) + "ms", 110.0, 13.0)
		Local mz:Int = MouseZ()
		If mz <> m_omz
			m_maphandler.ChangeCollidingZ((mz < m_omz) And -2 Or 2)
			m_omz = mz
		End If
		dProtogPrimitives.RenderRectangle(m_map.GetWindowX(), m_map.GetWindowY(), m_map.GetWindowX() + (m_map.GetWindowWidth()), m_map.GetWindowY() + (m_map.GetWindowHeight()), False)
		If m_maphandler.m_coll_terrain
			m_font.RenderStringParams("tilez: " + m_maphandler.m_coll_terrain.GetZ(), 10.0, 25.0)
		End If
		tiley = 45.0
		tilex = 5.0
		For Local res:dMapResource = EachIn m_resources
			res.m_texture.Bind()
			res.m_texture.RenderToPosParams(tilex, tiley)
			res.m_texture.Unbind()
			tiley:+ 64.0 + 4.0
			If tiley > m_graphics.GetHeight() + 64.0
				tiley = 40.0
				tilex:+ 64.0 + 4.0
			End If
		Next
		If KeyDown(KEY_SPACE)
			SeedRnd(MilliSecs())
			'm_map.GetTileAtPos(x, y).SetZ(127)
			'm_map.UpdateTileAtPos(x, y, True)
			For Local y:Int = 0 Until m_map.GetHeight()
				For Local x:Int = 0 Until m_map.GetWidth()
					dtile = m_map.GetTileAtPos(x, y)
					rid = m_resids[Rand(m_tilerange_low, m_tilerange)]
					dtile.SetZ(Rand(- 5, 5))
					dtile.SetResourceID(rid)
				Next
			Next
			m_map.UpdateAllTiles()
			m_map.UpdateAllTileNormals()
			m_map.UpdateAllTileResources()
		End If
		m_infotext.Render()
	End Method
	
	Method Update()
		TFPSCounter.Update()
		m_infotext.SetReplacementsWithName("fps", TFPSCounter.GetFPS())
		m_maphandler.m_mousep.Set(MouseX(), MouseY())
		If KeyHit(KEY_F1)
			m_maphandler.ClearCollidingObjects(True, False)
			m_maphandler.m_use_terrain_collision:~1
			m_maphandler.m_render_terrain:~1
		End If
		If KeyHit(KEY_F2)
			m_maphandler.ClearCollidingObjects(False, True)
			m_maphandler.m_use_static_collision:~1
			m_maphandler.m_render_static:~1
		End If
		If m_updatetimer.Update()
			Local time:Int = FileTime("light.script")
			If time > m_lftime
				UpdateLight()
				m_lftime = time
			End If
		End If
		If KeyHit(KEY_EQUALS)
			If KeyDown(KEY_LCONTROL)
				m_tilerange_low = IntMax(m_tilerange_low + 1, m_resids.Length - 1)
				m_infotext.SetReplacementsWithName("tilerange_low", m_tilerange_low)
			Else
				m_tilerange = IntMax(m_tilerange + 1, m_resids.Length - 1)
				m_infotext.SetReplacementsWithName("tilerange", m_tilerange)
			End If
		Else If KeyHit(KEY_MINUS)
			If KeyDown(KEY_LCONTROL)
				m_tilerange_low = IntMin(m_tilerange_low - 1, 0)
				m_infotext.SetReplacementsWithName("tilerange_low", m_tilerange_low)
			Else
				m_tilerange = IntMin(m_tilerange - 1, 0)
				m_infotext.SetReplacementsWithName("tilerange", m_tilerange)
			End If
		End If
		If KeyDown(KEY_UP)
			m_map.SetWindowY(m_map.GetWindowY() - 5)
		End If
		If KeyDown(KEY_DOWN)
			m_map.SetWindowY(m_map.GetWindowY() + 5)
		End If
		If KeyDown(KEY_LEFT)
			m_map.SetWindowX(m_map.GetWindowX() - 5)
		End If
		If KeyDown(KEY_RIGHT)
			m_map.SetWindowX(m_map.GetWindowX() + 5)
		End If
		If KeyDown(KEY_W) Then m_maphandler.MovePlayer(-1, -1)
		If KeyDown(KEY_S) Then m_maphandler.MovePlayer(+1, +1)
		If KeyDown(KEY_A) Then m_maphandler.MovePlayer(-1, +1)
		If KeyDown(KEY_D) Then m_maphandler.MovePlayer(+1, -1)
	End Method
	
	Method OnExit()
		' The super OnExit method will destroy the graphical context
		Super.OnExit()
	End Method
	
End Type

Type TMyMapHandler Extends dTileMapHandler
	
	Field m_color_yellow:dProtogColor = New dProtogColor.Create(1.0, 1.0, 0.0)
	Field m_mousep:dVec2 = New dVec2.Create(0.0, 0.0)
	Field m_mousestate:Int
	
	Method Create:TMyMapHandler(map:dTileMap)
		Init(map, New dMapPos, New dVec3, True, True, True, True, ECollisionLayers.LAYER_1)
		Return Self
	End Method
	
	Method ClearCollidingObjects(terrain:Int = True, static:Int = True)
		If terrain Then m_coll_terrain = Null
		If static Then m_coll_static = Null
	End Method
	
	Method ChangeCollidingZ(change:Int)
		If m_coll_terrain
			m_coll_terrain.SetZ(m_coll_terrain.m_pos.m_z + change)
			m_map.UpdateTile(m_coll_terrain, True)
			m_map.UpdateTileNormalsAtPos(m_coll_terrain.m_pos.m_x, m_coll_terrain.m_pos.m_y)
		Else If m_coll_static
			m_coll_static.SetZ(m_coll_static.m_pos.m_z + change)
			m_map.SortStaticsAtPos(m_coll_static.m_pos.m_x, m_coll_static.m_pos.m_y)
		End If
	End Method
	
	Method BeforeCollidingTileRendered()
		'DebugLog("before colliding tile")
		m_color_yellow.Bind()
		m_map.m_use_light = False
	End Method
	
	Method AfterTileRendered(tile:dDrawnTile)
		If m_coll_terrain Then m_map.m_use_light = True
	End Method
	
	Method BeforeCollidingStaticRendered()
		'DebugLog("before colliding static")
		m_color_yellow.Bind()
	End Method
	
	Method FinishedRendering()
		If m_mousestate
			ClearCollidingObjects()
			Local coll:Object[] = dProtogCollision.CollideRect(m_mousep.m_x, m_mousep.m_y, 1.0, 1.0, m_collision_layer, 0)
			If coll
				Local t:dDrawnTile = dDrawnTile(coll[0]), s:dDrawnStatic = dDrawnStatic(coll[0])
				If t
					'DebugLog("matched tile at: " + t.m_pos.m_x + ", " + t.m_pos.m_y)
					m_coll_terrain = t
				Else If s
					'DebugLog("matched static at: " + s.m_pos.m_x + ", " + s.m_pos.m_y)
					m_coll_static = s
				End If
			End If
			m_mousestate = False
		Else
			m_mousestate = MouseDown(MOUSE_LEFT)
		End If
		dProtogCollision.ResetCollisions(m_collision_layer)
	End Method
	
	Method MovePlayer(x_change:Int, y_change:Int)
		Super.MovePlayer(x_change, y_change)
		m_playerpos.m_z = 0 ' Remove the screen bounciness from moving the player (because the screen moves rather fast and because there is no player to track)
	End Method
	
End Type

Function InitGLLight()
	Local lightpos:Float[4], color:Float[4]
	Local USING_GL_LIGHT:Int = dTileMap.USING_GL_LIGHT
	glEnable(USING_GL_LIGHT)
	lightpos[0] = -1.0
	lightpos[1] = -1.0
	lightpos[2] = 0.5
	lightpos[3] = 0.0
	glLightfv(USING_GL_LIGHT, GL_POSITION, lightpos)
	color[0] = 1.0
	color[1] = 1.0
	color[2] = 1.0
	color[3] = 1.0
	glLightfv(USING_GL_LIGHT, GL_AMBIENT, color)
	color[0] = 1.0
	color[1] = 1.0
	color[2] = 1.0
	color[3] = 1.0
	'glLightfv(USING_GL_LIGHT, GL_SPECULAR, color)
	color[0] = 1.0
	color[1] = 1.0
	color[2] = 1.0
	color[3] = 1.0
	glLightfv(USING_GL_LIGHT, GL_DIFFUSE, color)
	'color[0] = 1.0
	'color[1] = 1.0
	'color[2] = 1.0
	'color[3] = 1.0
	'glLightModelfv(GL_LIGHT_MODEL_AMBIENT, color)
	'color[0] = 1.0
	'color[1] = 1.0
	'color[2] = 1.0
	'color[3] = 1.0
	'glMaterialfv(GL_FRONT, GL_AMBIENT, color)
	'glLightModeli(GL_LIGHT_MODEL_TWO_SIDE, False)
	'glDisable(USING_GL_LIGHT)
End Function

