
SuperStrict

Framework brl.blitz
Import brl.standardio
Import brl.bank
Import brl.bankstream

Import brl.glmax2d
Import brl.pngloader
Import brl.bmploader

Import duct.TileMap
Import duct.memcrypt
Import duct.template
Import duct.scriptparser

AppTitle = "resourceset builder"
SetGraphicsDriver(GLMax2DDriver())
Graphics(320, 240, 0)

AutoImageFlags(MASKEDIMAGE)

Local rb:TResBuilder = New TResBuilder

ChangeDir("tiles")
rb.BuildScript("tiles.scc")

rb = New TResBuilder
rb.BuildScript("statics.scc")

Type TResBuilder
	
	Global tpl_base:TTemplate = New TTemplate.Create(["base"], [[TV_INTEGER], [TV_STRING], [TV_STRING] ], False, False, Null)
	Global tpl_flag:TTemplate = New TTemplate.Create(Null, [[TV_INTEGER, TV_STRING] ], False, False, Null)
	Global tpl_static_height:TTemplate = New TTemplate.Create(["height"], [[TV_INTEGER] ], False, False, Null)
	
	Global tpl_maskcolor:TTemplate = New TTemplate.Create(["maskcolor"], [[TV_INTEGER], [TV_INTEGER], [TV_INTEGER] ], False, False, Null)
	Global tpl_datadir:TTemplate = New TTemplate.Create(["datadir"], [[TV_STRING] ], False, False, Null)
	Global tpl_outputfile:TTemplate = New TTemplate.Create(["outputfile"], [[TV_STRING] ], False, False, Null)
	Global tpl_idoffset:TTemplate = New TTemplate.Create(["idoffset"], [[TV_INTEGER] ], False, False, Null)
	Global tpl_incrementoffset:TTemplate = New TTemplate.Create(["incrementoffset"], [[TV_INTEGER, TV_STRING] ], False, False, Null)
	
	Field datadir:String, outputfile:String, idoffset:Int = 0, incrementoffset:Int = False
	Field resourceset:TMapResourceSet
	
		Method BuildScript(_scripturl:String)
			Local script:TSNode
			
			resourceset = New TMapResourceSet.Create()
			
			outputfile = _scripturl + "_auto.dts"
			
			Try
				
				script = TSNode.LoadScriptFromFile(_scripturl)
				
				If script <> Null
					Local child:Object, node:TSNode, iden:TIdentifier
					
					For child = EachIn script.GetChildren()
						node = TSNode(child) ; iden = TIdentifier(child)
						
						If node <> Null
							
							Select node.GetName().ToLower()
								Case "tiles"
									DoTiles(node)
									
								Case "statics"
									DoStatics(node)
									
							End Select
							
						Else If iden <> Null
							
							If tpl_maskcolor.ValidateIdentifier(iden) = True
								
								SetMaskColor(TIntVariable(iden.GetValueAtIndex(0)).Get(),  ..
								TIntVariable(iden.GetValueAtIndex(1)).Get(),  ..
								TIntVariable(iden.GetValueAtIndex(2)).Get())
								
							Else If tpl_datadir.ValidateIdentifier(iden) = True
								
								datadir = TStringVariable(iden.GetValueAtIndex(0)).Get()
								
							Else If tpl_outputfile.ValidateIdentifier(iden) = True
								
								outputfile = TStringVariable(iden.GetValueAtIndex(0)).Get()
								
							Else If tpl_idoffset.ValidateIdentifier(iden) = True
								
								idoffset = TIntVariable(iden.GetValueAtIndex(0)).Get()
								
							Else If tpl_incrementoffset.ValidateIdentifier(iden) = True
								
								incrementoffset = TSNode.ConvertVariableToBool(TVariable(iden.GetValueAtIndex(0)))
								
							End If
							
						End If
						
					Next
					
				End If
				
				Local stream:TBankStream = CreateBankStream(Null)
					
					resourceset.Serialize(stream)
					stream._bank.Save(outputfile)
					
				stream.Close()
				
			Catch e:String
				
				Print("BuildScript(); Caught exception: " + e)
				
			End Try
			
		End Method
		
		Method DoTiles(root:TSNode)
			Local child:Object, node:TSNode, iden:TIdentifier
			
			For child = EachIn root.GetChildren()
				
				node = TSNode(child)
				
				If node <> Null
					
					If node.GetName().ToLower() = "tile"
						Local tile:TMapTileResource
						
						tile = New TMapTileResource.Create(0, "generic_tile", New TTileTexture)
						
						For iden = EachIn node.GetChildren()
							
							If tpl_base.ValidateIdentifier(iden) = True
								
								tile.SetID(idoffset + TIntVariable(iden.GetValueAtIndex(0)).Get())
								tile.SetName(TStringVariable(iden.GetValueAtIndex(1)).Get())
								tile.texture.SetImage(LoadImage(datadir + "/" + TStringVariable(iden.GetValueAtIndex(2)).Get(), MASKEDIMAGE))
								
							End If
							
						Next
						
						resourceset.InsertResource(tile)
						If incrementoffset = True Then idoffset:+1
						
					End If
					
				End If
				
			Next
			
		End Method
		
		Method DoStatics(root:TSNode)
			Local child:Object, node:TSNode, iden:TIdentifier
			
			For child = EachIn root.GetChildren()
				
				node = TSNode(child)
				
				If node <> Null
					
					If node.GetName().ToLower() = "static"
						Local static:TMapStaticResource
						
						static = New TMapStaticResource.Create(0, 1, "generic_static", New TTileTexture)
						
						For iden = EachIn node.GetChildren()
							
							If tpl_base.ValidateIdentifier(iden) = True
								
								static.SetID(idoffset + TIntVariable(iden.GetValueAtIndex(0)).Get())
								static.SetName(TStringVariable(iden.GetValueAtIndex(1)).Get())
								static.texture.SetImage(LoadImage(datadir + "/" + TStringVariable(iden.GetValueAtIndex(2)).Get(), MASKEDIMAGE))
								
							Else If tpl_flag.ValidateIdentifier(iden) = True
								Local flag:Int = TSNode.ConvertVariableToBool(iden.GetValueAtIndex(0))
								
								Select iden.GetName().ToLower()
									Case "impassable"
										If flag = True Then static.AddFlag(RESFLAG_Impassable) Else static.RemoveFlag(RESFLAG_Impassable)
										
									Case "door"
										If flag = True Then static.AddFlag(RESFLAG_Door) Else static.RemoveFlag(RESFLAG_Door)
										
									Case "blocksview"
										If flag = True Then static.AddFlag(RESFLAG_BlocksView) Else static.RemoveFlag(RESFLAG_BlocksView)
										
								End Select
								
							Else If tpl_static_height.ValidateIdentifier(iden) = True
								
								static.SetHeight(TIntVariable(iden.GetValueAtIndex(0)).Get())
								
							End If
							
						Next
						
						resourceset.InsertResource(static)
						If incrementoffset = True Then idoffset:+1
						
					End If
					
				End If
				
			Next
			
		End Method
		
End Type
























