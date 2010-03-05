
SuperStrict

Framework brl.blitz
Import brl.standardio
Import brl.linkedlist
Import brl.glmax2d

Import duct.input
Import duct.scriptparser

TGame.Run()

Type TGame
	
	Global gfx_width:Int, gfx_height:Int
	
	' The dBindMap is intended for update usage (you keep variables to the identifiers and insert them into the map,
	' and when you want to update any given identifier, automagically, you just send off the info to the bind map and it will
	' do the rest).
	Global bindmap:dBindMap
	Global bind_up:dInputIdentifier, bind_down:dInputIdentifier, bind_left:dInputIdentifier, bind_right:dInputIdentifier
	Global bind_update:dInputIdentifier
	
	Function Initiate()
		bindmap = New dBindMap.Create()
		bind_up = bindmap.InsertInputIdentifier(New dInputIdentifier.Create(KEY_UP, INPUT_KEYBOARD, "up"))
		bind_down = bindmap.InsertInputIdentifier(New dInputIdentifier.Create(KEY_DOWN, INPUT_KEYBOARD, "down"))
		bind_left = bindmap.InsertInputIdentifier(New dInputIdentifier.Create(KEY_LEFT, INPUT_KEYBOARD, "left"))
		bind_right = bindmap.InsertInputIdentifier(New dInputIdentifier.Create(KEY_RIGHT, INPUT_KEYBOARD, "right"))
		bind_update = bindmap.InsertInputIdentifier(New dInputIdentifier.Create(KEY_SPACE, INPUT_KEYBOARD, "update"))
		
		gfx_width = 800; gfx_height = 600
		SetGraphicsDriver(GLMax2DDriver())
		Graphics(gfx_width, gfx_height, 0)
		New TPlayer.Create(gfx_width / 2, gfx_height / 2, 4.0)
	End Function
	
	Function Draw()
		For Local entity:TEntity = EachIn TEntity.m_list
			entity.Draw()
		Next
	End Function
	
	Function Update()
		For Local entity:TEntity = EachIn TEntity.m_list
			entity.Update()
		Next
		UpdateBinds()
	End Function
	
	Function UpdateBinds()
		If bind_update.GetStateHit() = True
			Try
				Local node:dSNode = dSNode.LoadScriptFromFile("binds.script")
				If node <> Null
					bindmap.UpdateFromNode(node)
					Print(bindmap.ReportAsString())
				Else
					Print("Failed to load script 'binds.script'")
				End If
			Catch e:String
				Print("Caught exception: " + e)
			End Try
		End If
	End Function
	
	Function Run()
		Initiate()
		While KeyHit(KEY_ESCAPE) = False And AppTerminate() = False
			Cls()
			Update()
			Draw()
			Flip()
			Delay(10)
		End While
	End Function
	
End Type

Type TEntity Abstract
	
	Global m_list:TListEx = New TListEx
	Field m_link:TLink
	
	Field m_x:Float, m_y:Float
	
	Method New()
		m_link = m_list.AddLast(Self)
	End Method
	
	Method Destroy()
		m_link.Remove()
		m_link = Null
	End Method
	
	Method Draw() Abstract
	Method Update() Abstract
	
End Type

Type TPlayer Extends TEntity
	
	Field m_speed:Float
	
	Method Create(x:Float, y:Float, speed:Float = 1.0)
		m_x = x
		m_y = y
		m_speed = speed
	End Method
	
	Method Draw()
		DrawRect(m_x - 10, m_y - 10, 20, 20)
	End Method
	
	Method Update()
		If TGame.bind_up.GetStateDown() = True Then m_y:- m_speed
		If TGame.bind_down.GetStateDown() = True Then m_y:+ m_speed
		If TGame.bind_left.GetStateDown() = True Then m_x:- m_speed
		If TGame.bind_right.GetStateDown() = True Then m_x:+ m_speed
	End Method
	
End Type

