
SuperStrict

Framework brl.blitz
Import brl.standardio

Import brl.glmax2d
Import brl.pngloader

Import brl.map
Import brl.random

Import duct.etc
Import duct.tilemap

Import brl.filesystem
Import brl.stream

Import brl.bank
Import brl.bankstream
Import duct.memcrypt

TApp.Run()

Type TApp
	
	Global gfx_width:Int = 1440, gfx_height:Int = 900
	
	Global resids:Int[]
	Global map:TTileMap, maphandler:TMyMapHandler, resources:TMapResourceSet, environment:TMapEnvironment
		
		Function Run()
			
			Try
				
				Initiate()
				
			Catch e:String
				
				Print("Caught exception!~n~t" + e)
				End
				
			End Try
			
			Local tiley:Float, tilex:Float, tile:TMapResource
			Local tilerange_low:Int = 0, tilerange:Int = resources.Count() - 1
			
			Local mz:Int, omz:Int
			Local y:Int, x:Int, rid:Int, dtile:TDrawnTile
			
			Local drawtime:Int
			
			SetBlend(MASKBLEND)
			While KeyDown(KEY_ESCAPE) = False And AppTerminate() = False
				
				Cls()
					
					maphandler.m_mousep.Set(MouseX(), MouseY())
					
					drawtime = MilliSecs()
					map.Draw()
					DrawText("Draw time: " + String(MilliSecs() - drawtime) + "ms", 110.0, 13.0)
					
					SetColor(255, 255, 255)
					DrawRectangle(map.GetWindowX(), map.GetWindowY(), map.GetWindowX() + (map.GetWindowWidth()), map.GetWindowY() + (map.GetWindowHeight()))
					
					If KeyHit(KEY_F1)
						
						maphandler.m_debug:~1
						
					End If
					
					If maphandler.m_coll_terrain <> Null
						DrawText("tilez: " + maphandler.m_coll_terrain.GetZ(), 10.0, 13.0)
					End If
					
					mz = MouseZ()
					If mz <> omz
						
						dtile = maphandler.m_coll_terrain
						If dtile <> Null
							
							If mz < omz
								dtile.SetZ(dtile.GetZ() - 4)
							Else If mz > omz
								dtile.SetZ(dtile.GetZ() + 4)
							End If
							
						End If
						
						map.UpdateTileAtPos(dtile.m_pos.m_x, dtile.m_pos.m_y, True)
						map.UpdateTileNormalsAtPos(dtile.m_pos.m_x, dtile.m_pos.m_y)
						omz = mz
						
					End If
					
					If KeyHit(KEY_EQUALS)
						If KeyDown(KEY_LCONTROL)
							tilerange_low = IntMax(tilerange_low + 1, resids.Length - 1)
						Else
							tilerange = IntMax(tilerange + 1, resids.Length - 1)
						End If
					Else If KeyHit(KEY_MINUS)
						If KeyDown(KEY_LCONTROL)
							tilerange_low = IntMin(tilerange_low - 1, 0)
						Else
							tilerange = IntMin(tilerange - 1, 0)
						End If
					End If
					
					If KeyDown(KEY_UP)
						map.SetWindowY(map.GetWindowY() - 5)
					End If
					If KeyDown(KEY_DOWN)
						map.SetWindowY(map.GetWindowY() + 5)
					End If
					If KeyDown(KEY_LEFT)
						map.SetWindowX(map.GetWindowX() - 5)
					End If
					If KeyDown(KEY_RIGHT)
						map.SetWindowX(map.GetWindowX() + 5)
					End If
					
					If KeyDown(KEY_W) Then maphandler.MovePlayer(- 1, - 1)
					If KeyDown(KEY_S) Then maphandler.MovePlayer(+ 1, + 1)
					If KeyDown(KEY_A) Then maphandler.MovePlayer(- 1, + 1)
					If KeyDown(KEY_D) Then maphandler.MovePlayer(+ 1, - 1)
					
					If KeyDown(KEY_SPACE) = True
						
						'y = 6
						'x = 4
						
						SeedRnd(MilliSecs())
						'map.GetTileAtPos(x, y).SetZ(127)
						'map.UpdateTileAtPos(x, y, True)
						
						For y = 0 To map.GetHeight() - 1
							
							For x = 0 To map.GetWidth() - 1
								
								dtile = map.GetTileAtPos(x, y)
								rid = resids[Rand(tilerange_low, tilerange)]
								
								dtile.SetZ(Rand(- 5, 5))
								dtile.SetResourceID(rid)
								
							Next
							
						Next
						
						map.UpdateAllTiles()
						map.UpdateAllTileNormals()
						
						map.UpdateAllTileResources()
						
					End If
					
					tiley = 40.0
					tilex = 5.0
					For tile = EachIn resources.ValueEnumerator()
						
						DrawImage(tile.GetTexture().GetImage(), tilex, tiley)
						
						tiley:+64.0 + 4.0
						If tiley > gfx_height + 64.0
							
							tiley = 40.0
							tilex:+64.0 + 4.0
							
						End If
						
					Next
					
					DrawText("[" + tilerange_low + " - " + tilerange + "] || FPS: " + String(TFPSCounter.GetFPS()), 0.0, 0.0)
					
				Flip(0)
				TFPSCounter.Update()
				Delay(10)
				
			Wend
			
		End Function
		
		Function Initiate()
			Local instream:TStream, staticres:TMapResourceSet
			
			SetGraphicsDriver(GLMax2DDriver())
			Graphics(gfx_width, gfx_height, 0)
			
			' Important! This must be called to initiate the OpenGL lighting for tiles
			TTileMap.InitGL()
			
			resources = TMapResourceSet.LoadFromFile("tiles.dts")
			staticres = TMapResourceSet.LoadFromFile("statics.dts")
			environment = New TMapEnvironment.Create(255, 255, 255)
			
			' We don't call the Create method here because we're DeSerializing (we can set things manually, )
			map = New TTileMap
			
			maphandler = New TMyMapHandler.Create(map)
			map.SetHandler(maphandler)
			map.SetTileResourceMap(resources)
			map.SetStaticResourceMap(staticres)
			map.SetEnvironment(environment)
			
			instream = ReadStream("map_test.map")
			If instream = Null
				Throw("Failed to load map!")
			Else
				
				map.DeSerialize(instream)
				instream.Close()
				
			End If
			
			DebugLog("Window set: " + map.SetWindowDimensions(180, 25, 800, 600))
			DebugLog("Window X: " + map.GetWindowX() + " Window Y: " + map.GetWindowY())
			DebugLog("Window W: " + map.GetWindowWidth() + " Window H: " + map.GetWindowHeight())
			DebugLog("Chunks: " + map.GetChunkCount())
			DebugLog("Map Width: " + map.Getwidth() + " Map Height: " + map.GetHeight())
			
			resids = New Int[resources.Count()]
			Local i:Int, ii:Int, res:TMapResource
			For i = 0 To resources.Count() - 1
				
				ii = 0
				For res = EachIn resources.ValueEnumerator()
					
					If ii = i
						resids[i] = res.GetID()
						Exit
					End If
					
					ii:+1
					
				Next
				
			Next
			
			maphandler.m_coll_terrain = map.GetTileAtPos(10, 10)
			
			map.UpdateAllTileResources()
			map.UpdateAllStaticResources()
			
		End Function
		
End Type


Type TMyMapHandler Extends TTileMapHandler
	
	Field m_debug:Int = False
	Field m_mousep:TVec2 = New TVec2.Create(0.0, 0.0)
	
		Method Create:TMyMapHandler(map:TTileMap)
			
			Init(map, New TMapPos, New TVec3, True, True)
			
			Return Self
			
		End Method
		
		Method BeforeCollidingTileDrawn()
			
			SetColor(255, 255, 0)
			
		End Method
		
		Method AfterTileDrawn(tile:TDrawnTile)
			
			If m_debug = True
				
				'SetColor(255, 0, 0)
				'cdata.m_quad.DrawTopOutline()
				'cdata.m_quad.DrawBottomOutline()
				
			End If
			
		End Method
		
		Method BeforeCollidingStaticDrawn()
			
			SetColor(255, 255, 0)
			
		End Method
		
		Method FinishedDrawing()
			
		End Method
		
End Type

Function DrawRectangle(x1:Float, y1:Float, x2:Float, y2:Float)
	
	' Draw top line
	DrawLine(x1, y1, x2, y1)
	
	' Right..
	DrawLine(x2, y1 + 1.0, x2, y2 - 1.0)
	
	' Bottom..
	DrawLine(x1, y2, x2, y2)
	
	' Left
	DrawLine(x1, y1 + 1.0, x1, y2 - 1.0)
	
End Function
















