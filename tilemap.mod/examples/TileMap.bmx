
SuperStrict

Framework brl.blitz
Import brl.standardio

Import brl.glmax2d
?win32
Import brl.d3d7max2d
?
Import brl.pngloader
Import brl.map
Import brl.random

Import duct.etc
Import duct.TileMap

Import brl.filesystem
Import brl.stream

Import brl.bank
Import brl.bankstream
Import duct.memcrypt

TApp.Run()

Type TApp
	
	Global gfx_width:Int = 1024, gfx_height:Int = 768
	
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
			Local xoff:Float = 180.0, yoff:Float = 25.0, tilerange_low:Int = 0, tilerange:Int = resources.Count() - 1
			
			Local mz:Int, omz:Int
			Local y:Int, x:Int, rid:Int, dtile:TDrawnTile
			
			SetBlend(MASKBLEND)
			While KeyDown(KEY_ESCAPE) = False And AppTerminate() = False
				
				Cls()
					
					maphandler.mousep.Set(MouseX(), MouseY())
					
					map.Draw(xoff, yoff)
					
					SetColor(255, 255, 255)
					DrawRectangle(xoff, yoff, xoff + (map.dw_width * 44.0), yoff + (map.dw_height * 44.0))
					
					If KeyHit(KEY_F1)
						
						maphandler.debug:~1
						
					End If
					
					mz = MouseZ()
					If mz <> omz
						
						dtile = maphandler.coll_terrain
						If dtile <> Null
							
							If mz < omz
								dtile.SetZ(dtile.GetZ() - 2)
							Else If mz > omz
								dtile.SetZ(dtile.GetZ() + 2)
							End If
							
						End If
						
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
					
					If KeyDown(KEY_UP) Then yoff:-5
					If KeyDown(KEY_DOWN) Then yoff:+5
					If KeyDown(KEY_LEFT) Then xoff:-5
					If KeyDown(KEY_RIGHT) Then xoff:+5
					
					If KeyDown(KEY_D) Then map.SetDrawWindowPosition(map.dw_x + 1, map.dw_y - 1)
					If KeyDown(KEY_A) Then map.SetDrawWindowPosition(map.dw_x - 1, map.dw_y + 1)
					If KeyDown(KEY_W) Then map.SetDrawWindowPosition(map.dw_x - 1, map.dw_y - 1)
					If KeyDown(KEY_S) Then map.SetDrawWindowPosition(map.dw_x + 1, map.dw_y + 1)
					
					If KeyDown(KEY_SPACE)
						
						SeedRnd(MilliSecs())
						For y = 0 To map.height - 1
							
							For x = 0 To map.width - 1
								
								dtile = map.data_terrain[y, x]
								rid = resids[Rand(tilerange_low, tilerange)]
								
								map.data_terrain[y, x].SetZ(Rand(- 15, 15))
								map.data_terrain[y, x].SetResourceID(rid)
								
							Next
							
						Next
						
					End If
					
					tiley = 40.0
					tilex = 5.0
					For tile = EachIn resources._map.Values()
						
						DrawImage(tile.GetTexture().GetImage(), tilex, tiley)
						
						tiley:+64.0 + 4.0
						If tiley > gfx_height + 64.0
							
							tiley = 40.0
							tilex:+64.0 + 4.0
							
						End If
						
					Next
					
					DrawText("[" + tilerange_low + " - " + tilerange + "] || FPS: " + String(TFPSCounter.GetFPS()), 0.0, 0.0)
					
				Flip()
				TFPSCounter.Update()
				Delay(10)
				
			Wend
			
		End Function
		
		Function Initiate()
			Local instream:TStream, staticres:TMapResourceSet
			
			'SetGraphicsDriver(D3D7Max2DDriver())
			SetGraphicsDriver(GLMax2DDriver())
			Graphics(gfx_width, gfx_height, 0)
			
			resources = TMapResourceSet.LoadFromFile("tiles.dts")
			staticres = TMapResourceSet.LoadFromFile("statics.dts")
			
			instream = ReadStream("map_test.map")
			If instream = Null Then Throw("Failed to load map!")
			map = TTileMap.Load(instream)
			instream.Close()
			
			map.SetTileResourceMap(resources)
			map.SetStaticResourceMap(staticres)
			
			environment = New TMapEnvironment.Create(255, 255, 255)
			map.SetEnvironment(environment)
			
			DebugLog("Window set: " + map.SetDrawWindow(0, 0, 16, 16, True))
			DebugLog("dw_x: " + map.dw_x + " dw_y: " + map.dw_y)
			DebugLog("dw_w: " + map.dw_width + " dw_h: " + map.dw_height)
			DebugLog("w: " + map.data_terrain.Length + " h: " + map.data_terrain.Length)
			DebugLog("gw: " + (map.Getwidth() - 1) + " gh: " + (map.GetHeight() - 1))
			
			resids = New Int[resources.Count()]
			Local i:Int, ii:Int, res:TMapResource
			For i = 0 To resources.Count() - 1
				
				ii = 0
				For res = EachIn resources._map.Values()
					
					If ii = i
						resids[i] = res.GetID()
						Exit
					End If
					
					ii:+1
				Next
				
			Next
			
			maphandler = New TMyMapHandler
			map.handler = maphandler
			
			For i = 0 To map.GetHeight() - 1
				
				For ii = 0 To map.GetWidth() - 1
					
					If map.data_terrain[i, ii] = Null Then Print("Position (" + i + ", " + ii + ") is Null")
					
				Next
				
			Next
			
		End Function
		
End Type


Type TMyMapHandler Extends TTileMapHandler
	
	Field debug:Int = False
	Field mousep:TVec2 = New TVec2.Create(0.0, 0.0)
	
		Method BeforeCollidingTileDrawn(cdata:TTileCollisionData, light:Float)
			
			SetColor(255 * light, 255 * light, light)
			
			Rem
			If cdata.quad.IsVectorInside(mousep) = True
				
				colliding = cdata.Copy()
				
			Else If colliding <> Null
				
				If cdata.tilex = colliding.tilex And cdata.tiley = colliding.tiley
					
					' Simply to update the tile quad so debug rendering updates if tile heights are modified
					colliding = cdata.Copy()
					
				End If
				
			End If
			End Rem
			
		End Method
		
		Method AfterTileDrawn(cdata:TTileCollisionData)
				
			If debug = True
				
				SetColor(255, 0, 0)
				cdata.quad.DrawTopOutline()
				cdata.quad.DrawBottomOutline()
				
			End If
			
		End Method
		
		Method BeforeCollidingStaticDrawn()
			
			SetColor(255, 255, 0)
			
		End Method
		
		Method FinishedDrawing()
			Local coll:Object[]
			
			coll = CollideRect(mousep.x, mousep.y, 1, 1, static_clayer, 0)
			
			If coll = Null
				
				coll_static = Null
				
			Else
				
				coll_terrain = Null
				coll_static = TDrawnStatic(coll[0])
				
			End If
			ResetCollisions(static_clayer)
			
			If coll_static = Null
				coll = CollideRect(mousep.x, mousep.y, 1, 1, terrain_clayer, 0)
				
				If coll = Null
					
					coll_terrain = Null
					
				Else
					
					coll_terrain = TDrawnTile(coll[0])
					
				End If
				ResetCollisions(terrain_clayer)
			End If
			
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
















