
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
Import duct.memcrypt

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
	
	Method New()
	End Method
	
	Method Create:MyApp()
		Super.Create()
		Return Self
	End Method
	
	Method OnInit()
		m_graphics = New dProtogGraphics.Create(1024, 768, 0, 60,, 0, False)
		If m_graphics.StartGraphics() = False
			Print("Failed to open graphics mode!")
			End
		End If
		m_gdriver = m_graphics.GetDriverContext()
		m_gdriver.SetRenderBufferOnFlip(False)
		m_gdriver.UnbindRenderBuffer()
		
		dTileMap.InitGL()
		Try
			InitResources()
			InitMap()
		Catch e:String
			Print("Caught exception!~n~t" + e)
			End
		End Try
		
		InitEntities()
	End Method
	
	Method InitResources()
		m_color_white = New dProtogColor.Create(1.0, 1.0, 1.0, 1.0)
		m_font = New dProtogFont.FromNode(New TSNode.LoadScriptFromObject("fonts/arial.font"), True)
		
		m_resources = dMapResourceSet.LoadFromFile("tiles.dts")
		m_staticres = dMapResourceSet.LoadFromFile("statics.dts")
		m_environment = New dMapEnvironment.Create(1.0, 1.0, 1.0)
	End Method
	
	Method InitMap()
		Local instream:TStream, staticres:dMapResourceSet
		
		' We don't call the Create method here because we're Deserializing (we can set things manually)
		m_map = New dTileMap
		
		m_maphandler = New TMyMapHandler.Create(m_map)
		m_map.SetHandler(m_maphandler)
		m_map.SetTileResourceMap(m_resources)
		m_map.SetStaticResourceMap(m_staticres)
		m_map.SetEnvironment(m_environment)
		
		instream = ReadStream("map_test.map")
		If instream = Null
			Throw("Failed to load map!")
		Else
			m_map.Deserialize(instream)
			instream.Close()
		End If
		
		DebugLog("Window set: " + m_map.SetWindowDimensions(180, 25, 800, 600))
		DebugLog("Window X: " + m_map.GetWindowX() + " Window Y: " + m_map.GetWindowY())
		DebugLog("Window W: " + m_map.GetWindowWidth() + " Window H: " + m_map.GetWindowHeight())
		DebugLog("Chunks: " + m_map.GetChunkCount())
		DebugLog("Map Width: " + m_map.Getwidth() + " Map Height: " + m_map.GetHeight())
		
		m_resids = New Int[m_resources.Count()]
		Local i:Int, ii:Int, res:TMapResource
		For i = 0 To m_resources.Count() - 1
			ii = 0
			For res = EachIn m_resources.ValueEnumerator()
				If ii = i
					m_resids[i] = res.GetID()
					Exit
				End If
				ii:+1
			Next
		Next
		
		m_maphandler.m_coll_terrain = m_map.GetTileAtPos(4, 10)
		
		m_map.UpdateAllTileResources()
		m_map.UpdateAllStaticResources()
		
		m_tilerange = m_resources.Count() - 1
	End Method
	
	Method InitEntities()
		m_infotext = New dProtogTextEntity.Create("fps: {fps} - [ {tilerange_low} - {tilerange} ]",  ..
		m_font, New dVec2.Create(2.0, 2.0), m_color_white)
		
		m_infotext.SetupReplacer()
		m_infotext.SetReplacementByName("tilerange_low", m_tilerange_low)
		m_infotext.SetReplacementByName("tilerange", m_tilerange)
	End Method
	
	Method Run()
		m_gdriver.SetBlend(BLEND_ALPHA)
		While KeyDown(KEY_ESCAPE) = False And AppTerminate() = False
			m_graphics.Cls()
			
			Update()
			Render()
			
			m_graphics.Flip()
			Delay(12)
		Wend
		
		Shutdown()
	End Method
	
	Method Render()
		Local tiley:Float, tilex:Float, tile:TMapResource
		Local drawtime:Int, mz:Int
		Local y:Int, x:Int, rid:Int, dtile:dDrawnTile
		drawtime = MilliSecs()
		m_map.Draw()
		m_font.DrawStringParams("Draw time: " + String(MilliSecs() - drawtime) + "ms", 110.0, 13.0)
		
		mz = MouseZ()
		If mz <> m_omz
			dtile = m_maphandler.m_coll_terrain
			If dtile <> Null
				If mz < m_omz
					dtile.SetZ(dtile.GetZ() - 4)
				Else If mz > m_omz
					dtile.SetZ(dtile.GetZ() + 4)
				End If
				
				m_map.UpdateTileAtPos(dtile.m_pos.m_x, dtile.m_pos.m_y, True)
				m_map.UpdateTileNormalsAtPos(dtile.m_pos.m_x, dtile.m_pos.m_y)
			End If
			m_omz = mz
		End If
		
		m_color_white.Bind()
		dProtogPrimitives.DrawRectangle(m_map.GetWindowX(), m_map.GetWindowY(), m_map.GetWindowX() + (m_map.GetWindowWidth()), m_map.GetWindowY() + (m_map.GetWindowHeight()), False)
		
		If m_maphandler.m_coll_terrain <> Null
			m_font.DrawStringParams("tilez: " + m_maphandler.m_coll_terrain.GetZ(), 10.0, 25.0)
		End If
		
		tiley = 45.0
		tilex = 5.0
		For tile = EachIn m_resources.ValueEnumerator()
			tile.GetTexture().Bind()
			tile.GetTexture().RenderToPosParams(tilex, tiley)
			tiley:+64.0 + 4.0
			If tiley > m_graphics.GetHeight() + 64.0
				tiley = 40.0
				tilex:+64.0 + 4.0
			End If
		Next
		
		If KeyDown(KEY_SPACE) = True
			'y = 6
			'x = 4
			
			SeedRnd(MilliSecs())
			'm_map.GetTileAtPos(x, y).SetZ(127)
			'm_map.UpdateTileAtPos(x, y, True)
			
			For y = 0 To m_map.GetHeight() - 1
				For x = 0 To m_map.GetWidth() - 1
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
		m_infotext.SetReplacementByName("fps", TFPSCounter.GetFPS())
		
		m_maphandler.m_mousep.Set(MouseX(), MouseY())
		If KeyHit(KEY_F1)
			m_maphandler.m_debug:~1
		End If
		
		If KeyHit(KEY_EQUALS)
			If KeyDown(KEY_LCONTROL)
				m_tilerange_low = IntMax(m_tilerange_low + 1, m_resids.Length - 1)
				m_infotext.SetReplacementByName("tilerange_low", m_tilerange_low)
			Else
				m_tilerange = IntMax(m_tilerange + 1, m_resids.Length - 1)
				m_infotext.SetReplacementByName("tilerange", m_tilerange)
			End If
		Else If KeyHit(KEY_MINUS)
			If KeyDown(KEY_LCONTROL)
				m_tilerange_low = IntMin(m_tilerange_low - 1, 0)
				m_infotext.SetReplacementByName("tilerange_low", m_tilerange_low)
			Else
				m_tilerange = IntMin(m_tilerange - 1, 0)
				m_infotext.SetReplacementByName("tilerange", m_tilerange)
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
		If KeyDown(KEY_S) Then m_maphandler.MovePlayer(+ 1, + 1)
		If KeyDown(KEY_A) Then m_maphandler.MovePlayer(-1, + 1)
		If KeyDown(KEY_D) Then m_maphandler.MovePlayer(+ 1, -1)
	End Method
	
	Method OnExit()
		' The super OnExit method will destroy the graphical context
		Super.OnExit()
	End Method
	
End Type

Type TMyMapHandler Extends dTileMapHandler
	
	Field m_debug:Int = False
	Field m_mousep:dVec2 = New dVec2.Create(0.0, 0.0)
	
	Field m_color_yellow:dProtogColor = New dProtogColor.Create(1.0, 1.0, 0.0)
	
	Method Create:TMyMapHandler(map:dTileMap)
		Init(map, New dMapPos, New dVec3, True, True)
		Return Self
	End Method
	
	Method BeforeCollidingTileDrawn()
		m_color_yellow.Bind()
	End Method
	
	Method AfterTileDrawn(tile:dDrawnTile)
		If m_debug = True
			'SetColor(255, 0, 0)
			'cdata.m_quad.DrawTopOutline()
			'cdata.m_quad.DrawBottomOutline()
		End If
	End Method
	
	Method BeforeCollidingStaticDrawn()
		m_color_yellow.Bind()
	End Method
	
	Method FinishedDrawing()
	End Method
	
End Type

