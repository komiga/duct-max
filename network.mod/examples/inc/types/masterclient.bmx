
' 
' masterclient.bmx (Contains: TMasterClient, )
' 
' 

Rem
	bbdoc: The MasterClient type.
End Rem
Type TMasterClient Extends TPlayer
	
	Field msgmap:TMessageMap
	Field slotmap:TSlotMap
	Field lastpos:TVec2
	
	Field posmessage:TPositionMessage
	
		Method New()
			
			slotmap = New TSlotMap.Create(2)
			msgmap = New TMessageMap.Create()
			
			lastpos = New TVec2.Create(0.0, 0.0)
			
		End Method
		
		Rem
			bbdoc: Create a new MasterClient.
			returns: The created MasterClient.
		End Rem
		Method Create:TMasterClient(_socket:TSocket, _pid:Byte = 0)
			
			Super.Create(_socket, _pid)
			
			msgmap.InsertMessage(New TPlayerOperationMessage.Create(0, 0))
			msgmap.InsertMessage(New TPlayerMoveMessage.Create(0, 0.0, 0.0))
			
			posmessage = New TPositionMessage.Create(0.0, 0.0)
			
			Return Self
			
		End Method
		
		Rem
			bbdoc: Draw all the players.
			returns: Nothing.
		End Rem
		Method DrawPlayers()
			Local player:TPlayer
			
			For player = EachIn slotmap._map.Values()
				
				player.Draw()
				
			Next
			
		End Method
		
		Rem
			bbdoc: Set the position of the MasterClient.
			returns Nothing.
		End Rem
		Method SetPosition(_x:Float, _y:Float)
			
			Super.SetPosition(_x, _y)
			
			If pos.x <> lastpos.x Or pos.y <> lastpos.y
				
				lastpos.x = pos.x
				lastpos.y = pos.y
				
				SendPosition()
				
			End If
			
		End Method
		
		Rem
			bbdoc: Send the position of the Player to the Server.
			returns: Nothing.
		End Rem
		Method SendPosition()
			
			posmessage.Set(pos.x, pos.y)
			posmessage.Serialize(Self)
			
		End Method
		
		Rem
			bbdoc: Handle a Message sent from the Server.
			returns: Nothing.
		End Rem
		Method HandleMessage(msg_id:Byte, message:TMessage)
			
			If message = Null
				
				Print("(TMasterClient.HandleMessage) Unknown message id: " + msg_id)
				
			Else
				
				message.DeSerialize(Self, False)
				
				Select msg_id
					Case MSGID_PLAYEROPERATION
						Local opmsg:TPlayerOperationMessage, player:TPlayer
						
						opmsg = TPlayerOperationMessage(message)
						Select opmsg.action
							Case OPACTION_ASSIGNID
								Print("Assigned ID: " + opmsg.pid)
								pid = opmsg.pid
								slotmap.InsertPlayer(Self)
								
							Case OPACTION_ADDPLAYER
								Print("Added player (id: " + opmsg.pid + ")")
								
								player = New TPlayer.Create(Null, opmsg.pid)
								slotmap.InsertPlayer(player)
								
							Case OPACTION_REMOVEPLAYER
								Print("Removed player (id: " + opmsg.pid + ")")
								slotmap.InsertPlayerByID(opmsg.pid, Null)
								
						End Select
						
					Case MSGID_PLAYERMOVE
						Local movemsg:TPlayerMoveMessage, player:TPlayer
						
						movemsg = TPlayerMoveMessage(message)
						player = slotmap.GetPlayerByID(movemsg.pid)
						
						If player = Null
							
							Print("(TMasterClient.HandleMessage) MasterClient does not have a player by the sent id (" + movemsg.pid + ")")
							
						Else
							
							player.SetPosition(movemsg.x, movemsg.y)
							
						End If
						
				End Select
				
			End If
			
		End Method
		
		Rem
			bbdoc: Check for and handle incoming data from the Server.
			returns: Nothing.
		End Rem
		Method CheckTransmissions()
			Local msg_id:Byte, message:TMessage
			
			If Eof() = False
				
				If ReadAvail() > 0
					
					While ReadAvail() > 0
						msg_id = ReadByte()
						
						message = msgmap.GetMessageByID(msg_id)
						
						HandleMessage(msg_id, message)
						
					Wend
							
				End If
				
			End If
			
		End Method
		
End Type






























