
Rem
	bbdoc: Master server.
End Rem
Type TMasterServer Extends dServer
	
	Field m_slotmap:TSlotMap
	
	Field m_opmessage:TPlayerOperationMessage {create}
	Field m_movemessage:TPlayerMoveMessage {create}
	
	Method New()
		m_slotmap = New TSlotMap.Create(2)
	End Method
	
	Rem
		bbdoc: Create a new master server.
		returns: Itself.
	End Rem
	Method Create:TMasterServer(socket:TSocket, port:Int, accept_timeout:Int)
		_init(mainapp.m_msgmap, socket, port, accept_timeout)
		Return Self
	End Method
	
	Rem
		bbdoc: Called when a client is added.
		returns: Nothing.
	End Rem
	Method OnClientAdd(client:dClient)
		Local player:TServerPlayer
		player = TServerPlayer(client)
		Print("Client Added; ip: " + player.GetIPAddressAsString() + " id: " + player.m_pid)
	End Method
	
	Rem
		bbdoc: Called when a client is disconnected.
		returns: Nothing.
	End Rem
	Method OnClientDisconnect(client:dClient)
		Local player:TServerPlayer
		player = TServerPlayer(client)
		Print("Client Disconnected; ip: " + player.GetIPAddressAsString() + " id: " + player.m_pid)
		m_opmessage.Set(player.m_pid, OPACTION_REMOVEPLAYER)
		BroadcastMessage(m_opmessage, player)
		m_slotmap.RemovePlayerWithID(player.m_pid)
	End Method
	
	Rem
		bbdoc: Called when a socket is accepted.
		returns: Nothing.
	End Rem
	Method OnSocketAccept:dClient(socket:TSocket)
		Local player:TServerPlayer = New TServerPlayer.Create(socket)
		Local pid:Int = m_slotmap.GetFreeSlot()
		If pid = 0
			Print("Client Refused (no empty slots); ip: " + player.GetIPAddressAsString())
			socket.Close()
			player = Null
		Else
			AssignID(player, pid)
			SendPlayerList(player)
		End If
		Return player
	End Method
	
	Rem
		bbdoc: Update the players.
		returns: Nothing.
	End Rem
	Method UpdatePlayers()
		For Local player:TServerPlayer = EachIn m_slotmap
			If player.m_lastpos.m_x <> player.m_pos.m_x Or player.m_lastpos.m_y <> player.m_pos.m_y
				player.SetLastPosition(player.m_pos.m_x, player.m_pos.m_y)
				m_movemessage.Set(player.m_pid, player.m_pos.m_x, player.m_pos.m_y)
				BroadcastMessage(m_movemessage, player)
			End If
		Next
	End Method
	
	Rem
		bbdoc: Render all the players to the screen.
		returns: Nothing.
	End Rem
	Method RenderPlayers()
		For Local player:TServerPlayer = EachIn m_clients
			player.Render()
		Next
	End Method
	
	Rem
		bbdoc: Send the server's player id map to a player.
		returns: Nothing.
	End Rem
	Method SendPlayerList(player:TServerPlayer)
		m_opmessage.Set(0, OPACTION_ADDPLAYER)
		For Local iplayer:TServerPlayer = EachIn m_slotmap
			If iplayer <> player
				m_opmessage.m_pid = iplayer.m_pid
				m_opmessage.Serialize(player)
				m_movemessage.Set(iplayer.m_pid, iplayer.m_pos.m_x, iplayer.m_pos.m_y)
				m_movemessage.Serialize(player)
			End If
		Next
	End Method
	
	Rem
		bbdoc: Assign an id to a player.
		returns: Nothing.
	End Rem
	Method AssignID(player:TServerPlayer, pid:Int)
		player.m_pid = pid
		m_slotmap.InsertPlayer(player)
		m_opmessage.Set(pid, OPACTION_ASSIGNID)
		m_opmessage.Serialize(player)
		m_opmessage.Set(pid, OPACTION_ADDPLAYER)
		BroadcastMessage(m_opmessage, player)
	End Method
	
	Rem
		bbdoc: Broadcast a message to all connected player.
		returns: Nothing.
		about: If exception is found in the client list, the message will not be sent to that client.
	End Rem
	Method BroadcastMessage(message:dNetMessage, exception:TServerPlayer = Null)
		For Local player:TServerPlayer = EachIn m_clients
			If player <> exception
				If player.Eof() = False
					message.Serialize(player)
				End If
			End If
		Next
	End Method
	
End Type

Rem
	bbdoc: Server player (server-side client).
End Rem
Type TServerPlayer Extends TPlayer
	
	Field m_lastpos:dVec2
	
	Method New()
		m_lastpos = New dVec2.Create(0.0, 0.0)
	End Method
	
	Rem
		bbdoc: Create a server player.
		returns: Itself.
	End Rem
	Method Create:TServerPlayer(socket:TSocket, pid:Int = 0)
		Super.Create(socket, pid)
		Return Self
	End Method
	
	Rem
		bbdoc: Set the last position for the player.
		returns: Nothing.
	End Rem
	Method SetLastPosition(x:Float, y:Float)
		m_lastpos.m_x = x
		m_lastpos.m_y = y
	End Method
	
	Rem
		bbdoc: Handle a message sent from the player.
		returns: Nothing.
	End Rem
	Method HandleMessage(msgid:Int, message:dNetMessage)
		If message = Null
			Print("(TServerPlayer.HandleMessage) Unknown message id: " + msgid + "; From: " + GetIPAddressAsString())
		Else
			message.Deserialize(Self, False)
			If Not mainapp.m_msgmap.HandleMessage(Self, message)
				Print("(TServerPlayer.HandleMessage) Unhandled message: " + msgid)
			End If
		End If
	End Method
	
	Rem
		bbdoc: Handler for position messages.
		returns: Nothing.
	End Rem
	Method OnPositionMessage(msg:TPositionMessage) {handle = "TPositionMessage"}
		SetPosition(msg.m_x, msg.m_y)
	End Method
	
End Type

