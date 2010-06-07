
Rem
	bbdoc: Master server.
End Rem
Type TMasterServer Extends dServer
	
	Field m_slotmap:TSlotMap
	Field m_opmessage:TPlayerOperationMessage
	Field m_movemessage:TPlayerMoveMessage
	
	Method New()
		m_slotmap = New TSlotMap.Create(2)
	End Method
	
	Rem
		bbdoc: Create a new MasterServer.
		returns: The new MasterServer (itself).
	End Rem
	Method Create:TMasterServer(socket:TSocket, port:Int, accept_timeout:Int)
		_init(mainapp.m_msgmap, socket, port, accept_timeout)
		m_opmessage = New TPlayerOperationMessage
		m_movemessage = New TPlayerMoveMessage
		Return Self
	End Method
	
	Rem
		bbdoc: Called when a Client is added.
		returns: Nothing.
	End Rem
	Method OnClientAdd(client:dClient)
		Local player:TServerPlayer
		player = TServerPlayer(client)
		Print("Client Added; ip: " + player.GetIPAddressAsString() + " id: " + player.m_pid)
	End Method
	
	Rem
		bbdoc: Called when a Client is disconnected.
		returns: Nothing.
	End Rem
	Method OnClientDisconnect(client:dClient)
		Local player:TServerPlayer
		player = TServerPlayer(client)
		Print("Client Disconnected; ip: " + player.GetIPAddressAsString() + " id: " + player.m_pid)
		m_opmessage.Set(player.m_pid, OPACTION_REMOVEPLAYER)
		BroadcastMessage(m_opmessage, player)
		m_slotmap.RemovePlayerByID(player.m_pid)
	End Method
	
	Rem
		bbdoc: Called when a Socket is accepted.
		returns: Nothing.
	End Rem
	Method OnSocketAccept:dClient(socket:TSocket)
		Local player:TServerPlayer = New TServerPlayer.Create(socket)
		local pid:Int = m_slotmap.GetFreeSlot()
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
		bbdoc: Update the Players.
		returns: Nothing.
	End Rem
	Method UpdatePlayers()
		For Local player:TServerPlayer = EachIn m_slotmap.ValueEnumerator()
			If player.m_lastpos.m_x <> player.m_pos.m_x Or player.m_lastpos.m_y <> player.m_pos.m_y
				player.SetLastPosition(player.m_pos.m_x, player.m_pos.m_y)
				m_movemessage.Set(player.m_pid, player.m_pos.m_x, player.m_pos.m_y)
				BroadcastMessage(m_movemessage, player)
			End If
		Next
	End Method
	
	Rem
		bbdoc: Draw all the Players to the screen.
		returns: Nothing.
	End Rem
	Method DrawPlayers()
		For Local player:TServerPlayer = EachIn m_clients
			player.Draw()
		Next
	End Method
	
	Rem
		bbdoc: Send the MasterServer's Player id list to a ServerPlayer.
		returns: Nothing.
	End Rem
	Method SendPlayerList(player:TServerPlayer)
		m_opmessage.Set(0, OPACTION_ADDPLAYER)
		For Local iplayer:TServerPlayer = EachIn m_slotmap.ValueEnumerator()
			If iplayer <> player
				m_opmessage.m_pid = iplayer.m_pid
				m_opmessage.Serialize(player)
				m_movemessage.Set(iplayer.m_pid, iplayer.m_pos.m_x, iplayer.m_pos.m_y)
				m_movemessage.Serialize(player)
			End If
		Next
	End Method
	
	Rem
		bbdoc: Assign an id to a ServerPlayer.
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
		bbdoc: Broadcast a NetMessage to all connected Players.
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
		bbdoc: Create a new ServerPlayer.
		returns: The created ServerPlayer.
	End Rem
	Method Create:TServerPlayer(socket:TSocket, pid:Int = 0)
		Super.Create(socket, pid)
		Return Self
	End Method
	
	Rem
		bbdoc: Set the last position for the ServerPlayer.
		returns: Nothing.
	End Rem
	Method SetLastPosition(x:Float, y:Float)
		m_lastpos.m_x = x
		m_lastpos.m_y = y
	End Method
	
	Rem
		bbdoc: Handle a Message sent from the ServerPlayer.
		returns: Nothing.
	End Rem
	Method HandleMessage(msgid:Int, message:dNetMessage)
		If message = Null
			Print("(TServerPlayer.HandleMessage) Unknown message id: " + msgid + "; From: " + GetIPAddressAsString())
		Else
			message.Deserialize(Self, False)
			Select msgid
				Case MSGID_POSITION
					Local posmsg:TPositionMessage = TPositionMessage(message)
					SetPosition(posmsg.m_x, posmsg.m_y)
			End Select
		End If
	End Method
	
End Type

