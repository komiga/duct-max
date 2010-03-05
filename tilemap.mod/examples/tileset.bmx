
SuperStrict

Framework brl.blitz
Import brl.standardio
Import brl.bank
Import brl.bankstream

Import brl.pngloader
Import brl.bmploader

Import duct.protog2d
Import duct.tilemap
Import duct.memcrypt
Import duct.scriptparser

AppTitle = "resourceset builder"
brl.Graphics.SetGraphicsDriver(dProtog2DDriver.GetInstance())
brl.Graphics.Graphics(320, 240)

Local rb:TResBuilder = New TResBuilder

ChangeDir("tiles")
rb.BuildScript("tiles.scc")

rb = New TResBuilder
rb.BuildScript("statics.scc")

Type TResBuilder
	
	Global tpl_base:dTemplate = New dTemplate.Create(["base"], [[TV_INTEGER], [TV_STRING], [TV_STRING] ], False, False, Null)
	Global tpl_flag:dTemplate = New dTemplate.Create(Null, [[TV_INTEGER, TV_STRING] ], False, False, Null)
	Global tpl_static_height:dTemplate = New dTemplate.Create(["height"], [[TV_INTEGER] ], False, False, Null)
	
	'Global tpl_maskcolor:dTemplate = New dTemplate.Create(["maskcolor"], [[TV_INTEGER], [TV_INTEGER], [TV_INTEGER] ], False, False, Null)
	Global tpl_datadir:dTemplate = New dTemplate.Create(["datadir"], [[TV_STRING] ], False, False, Null)
	Global tpl_outputfile:dTemplate = New dTemplate.Create(["outputfile"], [[TV_STRING] ], False, False, Null)
	Global tpl_idoffset:dTemplate = New dTemplate.Create(["idoffset"], [[TV_INTEGER] ], False, False, Null)
	Global tpl_incrementoffset:dTemplate = New dTemplate.Create(["incrementoffset"], [[TV_INTEGER, TV_STRING] ], False, False, Null)
	
	Field datadir:String, outputfile:String, idoffset:Int = 0, incrementoffset:Int = False
	Field resourceset:dMapResourceSet
	
	Method BuildScript(scripturl:String)
		resourceset = New dMapResourceSet.Create()
		outputfile = scripturl + "_auto.dts"
		Try
			Local script:dSNode = dSNode.LoadScriptFromObject(scripturl)
			If script <> Null
				Local child:Object, node:dSNode, iden:TIdentifier
				
				For child = EachIn script.GetChildren()
					node = dSNode(child) ; iden = TIdentifier(child)
					If node <> Null
						Select node.GetName().ToLower()
							Case "tiles"
								DoTiles(node)
							Case "statics"
								DoStatics(node)
						End Select
					Else If iden <> Null
						If tpl_datadir.ValidateIdentifier(iden) = True
							datadir = dStringVariable(iden.GetValueAtIndex(0)).Get()
						Else If tpl_outputfile.ValidateIdentifier(iden) = True
							outputfile = dStringVariable(iden.GetValueAtIndex(0)).Get()
						Else If tpl_idoffset.ValidateIdentifier(iden) = True
							idoffset = dIntVariable(iden.GetValueAtIndex(0)).Get()
						Else If tpl_incrementoffset.ValidateIdentifier(iden) = True
							incrementoffset = dSNode.ConvertVariableToBool(TVariable(iden.GetValueAtIndex(0)))
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
	
	Method DoTiles(root:dSNode)
		Local child:Object, node:dSNode, iden:TIdentifier
		For child = EachIn root.GetChildren()
			node = dSNode(child)
			If node <> Null
				If node.GetName().ToLower() = "tile"
					Local tile:dMapTileResource = New dMapTileResource.Create(0, "generic_tile", Null)
					For iden = EachIn node.GetChildren()
						If tpl_base.ValidateIdentifier(iden) = True
							tile.SetID(idoffset + dIntVariable(iden.GetValueAtIndex(0)).Get())
							tile.SetName(dStringVariable(iden.GetValueAtIndex(1)).Get())
							tile.SetTexture(New dProtogTexture.Create(LoadPixmap(datadir + "/" + dStringVariable(iden.GetValueAtIndex(2)).Get()), 0))
						End If
					Next
					resourceset.InsertResource(tile)
					If incrementoffset = True Then idoffset:+1
				End If
			End If
		Next
	End Method
	
	Method DoStatics(root:dSNode)
		Local child:Object, node:dSNode, iden:TIdentifier
		For child = EachIn root.GetChildren()
			node = dSNode(child)
			If node <> Null
				If node.GetName().ToLower() = "static"
					Local static:TMapStaticResource
					
					static = New TMapStaticResource.Create(0, 1, "generic_static", Null)
					For iden = EachIn node.GetChildren()
						If tpl_base.ValidateIdentifier(iden) = True
							static.SetID(idoffset + dIntVariable(iden.GetValueAtIndex(0)).Get())
							static.SetName(dStringVariable(iden.GetValueAtIndex(1)).Get())
							static.SetTexture(New dProtogTexture.Create(LoadPixmap(datadir + "/" + dStringVariable(iden.GetValueAtIndex(2)).Get()), 0))
						Else If tpl_flag.ValidateIdentifier(iden) = True
							Local flag:Int = dSNode.ConvertVariableToBool(iden.GetValueAtIndex(0))
							
							Select iden.GetName().ToLower()
								Case "impassable"
									If flag = True Then static.AddFlag(RESFLAG_Impassable) Else static.RemoveFlag(RESFLAG_Impassable)
								Case "door"
									If flag = True Then static.AddFlag(RESFLAG_Door) Else static.RemoveFlag(RESFLAG_Door)
								Case "blocksview"
									If flag = True Then static.AddFlag(RESFLAG_BlocksView) Else static.RemoveFlag(RESFLAG_BlocksView)
							End Select
						Else If tpl_static_height.ValidateIdentifier(iden) = True
							static.SetHeight(dIntVariable(iden.GetValueAtIndex(0)).Get())
						End If
					Next
					resourceset.InsertResource(static)
					If incrementoffset = True Then idoffset:+1
				End If
			End If
		Next
	End Method
	
End Type

