
' Simple input module test.
' Tests BindMap updating by node (and, internally by identifier) and general InputIdentifier usage.

SuperStrict

Framework brl.blitz
Import brl.standardio
Import brl.linkedlist

Import brl.glmax2d

Import duct.Input
Import duct.scriptparser


TGame.Run()

Type TGame
	
	Global gfx_width:Int, gfx_height:Int
	
	' The TBindMap is intended for update usage (you keep variables to the identifiers and insert them into the map,
	' and when you want to update any given identifier, automagically, you just send off the info to the bind map and it will
	' do the rest).
	Global BindMap:TBindMap
	Global bind_up:TInputIdentifier, bind_down:TInputIdentifier, bind_left:TInputIdentifier, bind_right:TInputIdentifier
	Global bind_update:TInputIdentifier
	
		Function Initiate()
			
			gfx_width = 800; gfx_height = 600
			
			BindMap = New(TBindMap).Create()
			bind_up = BindMap.InsertInputIdentifier(New(TInputIdentifier).Create(KEY_UP, INPUT_KEYBOARD, "up"))
			bind_down = BindMap.InsertInputIdentifier(New(TInputIdentifier).Create(KEY_DOWN, INPUT_KEYBOARD, "down"))
			bind_left = BindMap.InsertInputIdentifier(New(TInputIdentifier).Create(KEY_LEFT, INPUT_KEYBOARD, "left"))
			bind_right = BindMap.InsertInputIdentifier(New(TInputIdentifier).Create(KEY_RIGHT, INPUT_KEYBOARD, "right"))
			bind_update = BindMap.InsertInputIdentifier(New(TInputIdentifier).Create(KEY_SPACE, INPUT_KEYBOARD, "update"))
			
			SetGraphicsDriver(GLMax2DDriver())
			Graphics(gfx_width, gfx_height, 0)
			
			New(TPlayer).Create(gfx_width / 2, gfx_height / 2, 4.0)
			
		End Function
		
		Function Draw()
			
			For Local entity:TEntity = EachIn TEntity._list
				
				entity.Draw()
				
			Next
			
		End Function
		
		Function Update()
			
			For Local entity:TEntity = EachIn TEntity._list
				
				entity.Update()
				
			Next
			
			UpdateBinds()
			
		End Function
		
		Function UpdateBinds()
		  Local node:TSNode
			
			If bind_update.GetStateHit() = True
				
				Try
					
					node = TSNode.LoadScriptFromFile("binds.script")
					
					If node <> Null
						
						BindMap.UpdateFromNode(node)
						Print(BindMap.ReportAsString())
						
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
			
			While(Not KeyHit(KEY_ESCAPE) And Not AppTerminate())
				
				Cls()
					
					Update()
					Draw()
					
				Flip()
				
			Wend
			
		End Function
		
End Type

Type TEntity Abstract
	
	Global _list:TList = New(TList)
	Field _link:TLink
	
	Field x:Float, y:Float
		
		Method New()
			_link = _list.AddLast(Self)
		End Method
		
		Method Destroy()
			_link.Remove()
			_link = Null
		End Method
		
		Method Draw() Abstract
		Method Update() Abstract
		
End Type

Type TPlayer Extends TEntity
	
	Field speed:Float
	
		Method Create(_x:Float, _y:Float, _speed:Float = 1.0)
			
			x = _x
			y = _y
			speed = _speed
			
		End Method
		
		Method Draw()
			
			DrawRect(x - 10, y - 10, 20, 20)
			
		End Method
		
		Method Update()
			
			If TGame.bind_up.GetStateDown() = True Then y:- speed
			If TGame.bind_down.GetStateDown() = True Then y:+ speed
			If TGame.bind_left.GetStateDown() = True Then x:- speed
			If TGame.bind_right.GetStateDown() = True Then x:+ speed
			
		End Method
		
End Type














