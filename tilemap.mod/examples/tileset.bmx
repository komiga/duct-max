
SuperStrict

Framework brl.blitz
Import brl.standardio
Import brl.bankstream
Import brl.pngloader

Import duct.protog2d
Import duct.tilemap
Import duct.scriptparser

AppTitle = "resourceset builder"
brl.Graphics.SetGraphicsDriver(dProtog2DDriver.GetInstance())
brl.Graphics.Graphics(320, 240)

Local rb:ResBuilder = New ResBuilder

ChangeDir("tiles")
rb.BuildScript("tiles.scc")

rb = New ResBuilder
rb.BuildScript("statics.scc")

Type ResBuilder
	
	Global tpl_base:dTemplate = New dTemplate.Create(["base"], [[TV_INTEGER], [TV_STRING], [TV_STRING]], False, False, Null)
	Global tpl_flag:dTemplate = New dTemplate.Create(Null, [[TV_BOOL]], False, False, Null)
	Global tpl_static_height:dTemplate = New dTemplate.Create(["height"], [[TV_INTEGER]], False, False, Null)
	
	'Global tpl_maskcolor:dTemplate = New dTemplate.Create(["maskcolor"], [[TV_INTEGER], [TV_INTEGER], [TV_INTEGER]], False, False, Null)
	Global tpl_datadir:dTemplate = New dTemplate.Create(["datadir"], [[TV_STRING]], False, False, Null)
	Global tpl_outputfile:dTemplate = New dTemplate.Create(["outputfile"], [[TV_STRING]], False, False, Null)
	Global tpl_idoffset:dTemplate = New dTemplate.Create(["idoffset"], [[TV_INTEGER]], False, False, Null)
	Global tpl_incrementoffset:dTemplate = New dTemplate.Create(["incrementoffset"], [[TV_BOOL]], False, False, Null)
	
	Field datadir:String, outputfile:String, idoffset:Int = 0, incrementoffset:Int = False
	Field resourceset:dMapResourceSet
	
	Method BuildScript(scripturl:String)
		resourceset = New dMapResourceSet.Create()
		outputfile = scripturl + "_auto.dts"
		Try
			Local script:dNode = dScriptFormatter.LoadFromFile(scripturl)
			If script
				Local node:dNode, iden:dIdentifier
				For Local child:dCollectionVariable = EachIn script
					node = dNode(child)
					iden = dIdentifier(child)
					If node
						Select node.GetName().ToLower()
							Case "tiles"
								DoTiles(node)
							Case "statics"
								DoStatics(node)
						End Select
					Else If iden
						If tpl_datadir.ValidateIdentifier(iden)
							datadir = dStringVariable(iden.GetValueAtIndex(0)).Get()
						Else If tpl_outputfile.ValidateIdentifier(iden)
							outputfile = dStringVariable(iden.GetValueAtIndex(0)).Get()
						Else If tpl_idoffset.ValidateIdentifier(iden)
							idoffset = dIntVariable(iden.GetValueAtIndex(0)).Get()
						Else If tpl_incrementoffset.ValidateIdentifier(iden)
							incrementoffset = dBoolVariable(iden.GetValueAtIndex(0)).Get()
						Else
							DebugLog("(ResBuilder.BuildScript) Unknown identifier: {" + dScriptFormatter.FormatIdentifier(iden) + "}")
						End If
					End If
				Next
			End If
			
			Local stream:TBankStream = CreateBankStream(Null)
			resourceset.Serialize(stream)
			stream._bank.Save(outputfile)
			stream.Close()
		Catch e:Object
			Print("BuildScript(); Caught exception: " + e.ToString())
		End Try
	End Method
	
	Method DoTiles(root:dNode)
		Local node:dNode, iden:dIdentifier
		For Local child:dCollectionVariable = EachIn root
			node = dNode(child)
			If node
				If node.GetName().ToLower() = "tile"
					Local tile:dMapTileResource = New dMapTileResource.Create(0, "generic_tile", Null)
					For iden = EachIn node
						If tpl_base.ValidateIdentifier(iden)
							tile.SetID(idoffset + dIntVariable(iden.GetValueAtIndex(0)).Get())
							DebugLog("tile id: " + tile.GetID())
							tile.SetName(dStringVariable(iden.GetValueAtIndex(1)).Get())
							tile.SetTexture(New dProtogTexture.Create(LoadPixmap(datadir + "/" + dStringVariable(iden.GetValueAtIndex(2)).Get()), 0))
						End If
					Next
					resourceset.InsertResource(tile)
					If incrementoffset = True Then idoffset:+ 1
				End If
			End If
		Next
	End Method
	
	Method DoStatics(root:dNode)
		Local node:dNode, iden:dIdentifier
		For Local child:dCollectionVariable = EachIn root
			node = dNode(child)
			If node
				If node.GetName().ToLower() = "static"
					Local static:dMapStaticResource = New dMapStaticResource.Create(0, 1, "generic_static", Null)
					For iden = EachIn node
						If tpl_base.ValidateIdentifier(iden)
							static.SetID(idoffset + dIntVariable(iden.GetValueAtIndex(0)).Get())
							static.SetName(dStringVariable(iden.GetValueAtIndex(1)).Get())
							static.SetTexture(New dProtogTexture.Create(LoadPixmap(datadir + "/" + dStringVariable(iden.GetValueAtIndex(2)).Get()), 0))
						Else If tpl_flag.ValidateIdentifier(iden)
							Local flag:Int = dBoolVariable(iden.GetValueAtIndex(0)).Get()
							Select iden.GetName().ToLower()
								Case "impassable"
									If flag Then static.AddFlag(RESFLAG_Impassable) Else static.RemoveFlag(RESFLAG_Impassable)
								Case "door"
									If flag Then static.AddFlag(RESFLAG_Door) Else static.RemoveFlag(RESFLAG_Door)
								Case "blocksview"
									If flag Then static.AddFlag(RESFLAG_BlocksView) Else static.RemoveFlag(RESFLAG_BlocksView)
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

