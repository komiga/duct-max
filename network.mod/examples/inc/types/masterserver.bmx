
' 
' masterserver.bmx (Contains: TMasterServer, TServerPlayer)
' 
' 

Rem
	bbdoc: The MasterServer type.
End Rem
Type TMasterServer Extends TServer
	
	Field slotmap:TSlotMap
	
	Field opmessage:TPlayerOperationMessage, movemessage:TPlayerMoveMessage
	
		Method New()
			
			slotmap = New TSlotMap.Create(2)
			
		End Method
		
		Rem
			bbdoc: Create a new MasterServer.
			returns: The new MasterServer (itself).
		End Rem
		Method Create:TMasterServer(_socket:TSocket, _port:Int, _accept_timeout:Int)
			
			_init(New TMessageMap.Create(), _socket, _port, _accept_timeout)
			
			msgmap.InsertMessage(New TPositionMessage.Create(0.0, 0.0))
			
			opmessage = New TPlayerOperationMessage.Create(0, 0)
			msgmap.InsertMessage(opmessage)
			
			movemessage = New TPlayerMoveMessage.Create(0, 0.0, 0.0)
			msgmap.InsertMessage(movemessage)
			
			Return Self
			
		End Method
		
		Rem
			bbdoc: Called when a Client is added.
			returns: Nothing.
		End Rem
		Method OnClientAdd(client:TClient)
			Local player:TServerPlayer
			player = TServerPlayer(client)
			
			Print("Client Added; ip: " + player.GetIPAddressAsString() + " id: " + player.pid)
			
		End Method
		
		Rem
			bbdoc: Called when a Client is disconnected.
			returns: Nothing.
		End Rem
		Method OnClientDisconnect(client:TClient)
			Local player:TServerPlayer
			player = TServerPlayer(client)
			
			Print("Client Disconnected; ip: " + player.GetIPAddressAsString() + " id: " + player.pid)
			
			opmessage.Set(player.pid, OPACTION_REMOVEPLAYER)
			
			BroadcastMessage(opmessage, player)
			
			slotmap.RemovePlayerByID(player.pid)
			
		End Method
		
		Rem
			bbdoc: Called when a Socket is accepted.
			returns: Nothing.
		End Rem
		Method OnSocketAccept:TClient(socket:TSocket)
			Local player:TServerPlayer, pid:Byte
			
			player = New TServerPlayer.Create(socket)
			
			pid = slotmap.GetFreeSlot()
			If pid = 0
				
				Print("Client Refused (no empty slots); ip: " + player.GetIPAddressAsString())
				socket.Close()
				
			Else
				
				player = Null
				AssignID(player, pid)
				
				SendPlayerList(player)
				
			End If
			
			Return player
			
		End Method
		
		Rem
			bbdoc: Update the Players.
			returns: Nothing.
		End Rem
		Method UpdatePlayers()
			Local player:TServerPlayer
			
			For player = EachIn slotmap._map.Values()
				
				If player.lastpos.x <> player.pos.x Or player.lastpos.y <> player.pos.y
					
					player.SetLastPosition(player.pos.x, player.pos.y)
					movemessage.Set(player.pid, player.pos.x, player.pos.y)
					BroadcastMessage(movemessage, player)
					
				End If
				
			Next
			
		End Method
		
		Rem
			bbdoc: Draw all the Players to the screen.
			returns: Nothing.
		End Rem
		Method DrawPlayers()
			Local player:TServerPlayer
			
			For player = EachIn clients
				
				player.Draw()
				
			Next
			
		End Method
		
		Rem
			bbdoc: Send the MasterServer's Player id list to a ServerPlayer.
			returns: Nothing.
		End Rem
		Method SendPlayerList(player:TServerPlayer)
			Local iplayer:TServerPlayer
			
			opmessage.Set(0, OPACTION_ADDPLAYER)
			
			For iplayer = EachIn slotmap._map.Values()
				
				If iplayer <> player
					
					opmessage.pid = iplayer.pid
					opmessage.Serialize(player)
					
					movemessage.Set(iplayer.pid, iplayer.pos.x, iplayer.pos.y)
					movemessage.Serialize(player)
					
				End If
				
			Next
			
		End Method
		
		Rem
			bbdoc: Assign an id to a ServerPlayer.
			returns: Nothing.
		End Rem
		Method AssignID(player:TServerPlayer, _pid:Byte)
			
			player.pid = _pid
			slotmap.InsertPlayer(player)
			opmessage.Set(_pid, OPACTION_ASSIGNID)
			opmessage.Serialize(player)
			
			opmessage.Set(_pid, OPACTION_ADDPLAYER)
			BroadcastMessage(opmessage, player)
			
		End Method
		
		Rem
			bbdoc: Broadcast a Message to all connected Players.
			returns: Nothing.
		End Rem
		Method BroadcastMessage(message:TMessage, exception:TServerPlayer = Null)
			Local player:TServerPlayer
			
			For player = EachIn clients
				
				If player <> exception
					
					If player.Eof() = False
						
						message.Serialize(player)
						
					End If
					
				End If
				
			Next
			
		End Method
		
End Type

Rem
	bbdoc: The ServerPlayer type.
End Rem
Type TServerPlayer Extends TPlayer
	
	Field lastpos:TVec2
		
		Method New()
			
			lastpos = New TVec2.Create(0.0, 0.0)
			
		End Method
		
		Rem
			bbdoc: Create a new ServerPlayer.
			returns: The created ServerPlayer.
		End Rem
		Method Create:TServerPlayer(_socket:TSocket, _pid:Byte = 0)
			
			Super.Create(_socket, _pid)
			
			Return Self
			
		End Method
		
		Rem
			bbdoc: Set the last position for the ServerPlayer.
			returns: Nothing.
		End Rem
		Method SetLastPosition(_x:Float, _y:Float)
			
			lastpos.x = _x
			lastpos.y = _y
			
		End Method
		
		Rem
			bbdoc: Handle a Message sent from the ServerPlayer.
			returns: Nothing.
		End Rem
		Method HandleMessage(msg_id:Byte, message:TMessage)
			
			If message = Null
				
				Print("(TServerPlayer.HandleMessage) Unknown message id: " + msg_id + "; From: " + GetIPAddressAsString())
				
			Else
				
				message.DeSerialize(Self, False)
				
				Select msg_id
					Case MSGID_POSITION
						Local posmsg:TPositionMessage
						
						posmsg = TPositionMessage(message)
						SetPosition(posmsg.x, posmsg.y)
						
				End Select
				
			End If
			
		End Method
		
End Type

























