
Rem
	bbdoc: Master client (client-side player).
End Rem
Type TMasterClient Extends TPlayer
	
	Field m_slotmap:TSlotMap
	Field m_lastpos:dVec2
	
	' Notice here that we're only inserting the messages that will be /received/
	' (There is no reason to insert a message which will never be received)
	Field m_opmessage:TPlayerOperationMessage {create insert}
	Field m_movemessage:TPlayerMoveMessage {create insert}
	Field m_posmessage:TPositionMessage {create}
	
	Method New()
		m_slotmap = New TSlotMap.Create(2)
		m_lastpos = New dVec2.Create(0.0, 0.0)
	End Method
	
	Rem
		bbdoc: Create a new master client.
		returns: Itself.
	End Rem
	Method Create:TMasterClient(socket:TSocket, pid:Int = 0)
		Super.Create(socket, pid)
		Return Self
	End Method
	
	Rem
		bbdoc: Draw all players.
		returns: Nothing.
	End Rem
	Method DrawPlayers()
		For Local player:TPlayer = EachIn m_slotmap.ValueEnumerator()
			player.Draw()
		Next
	End Method
	
	Rem
		bbdoc: Set the position of the client.
		returns Nothing.
	End Rem
	Method SetPosition(x:Float, y:Float)
		Super.SetPosition(x, y)
		If m_pos.m_x <> m_lastpos.m_x Or m_pos.m_y <> m_lastpos.m_y
			m_lastpos.SetVec(m_pos)
			SendPosition()
		End If
	End Method
	
	Rem
		bbdoc: Send the position of the player to the server.
		returns: Nothing.
	End Rem
	Method SendPosition()
		m_posmessage.Set(m_pos.m_x, m_pos.m_y)
		m_posmessage.Serialize(Self)
	End Method
	
	Rem
		bbdoc: Handle a message sent from the server.
		returns: Nothing.
	End Rem
	Method HandleMessage(msgid:Int, message:dNetMessage)
		If message = Null
			Print("(TMasterClient.HandleMessage) Unknown message id: " + msgid)
		Else
			message.Deserialize(Self, False)
			If mainapp.m_msgmap.HandleMessage(Self, message) = False
				Print("(TMasterClient.HandleMessage) Unhandled message: " + msgid)
			End If
		End If
	End Method
	
	Rem
		bbdoc: Check for and handle incoming data from the server.
		returns: Nothing.
	End Rem
	Method CheckTransmissions()
		Local msgid:Int, message:dNetMessage
		If Eof() = False
			If ReadAvail() > 0
				While ReadAvail() > 0
					msgid = ReadByte()
					message = mainapp.m_msgmap.GetMessageByID(msgid)
					HandleMessage(msgid, message)
				Wend
			End If
		End If
	End Method
	
	Rem
		bbdoc: Handler for the player operation messages.
		returns: Nothing.
	End Rem
	Method OnPlayerOperationMessage(msg:TPlayerOperationMessage) {handle = "TPlayerOperationMessage"}
		Select msg.m_action
			Case OPACTION_ASSIGNID
				m_pid = msg.m_pid
				m_slotmap.InsertPlayer(Self)
				Print("Assigned ID: " + msg.m_pid)
			Case OPACTION_ADDPLAYER
				m_slotmap.InsertPlayer(New TPlayer.Create(Null, msg.m_pid))
				Print("Added player (id: " + msg.m_pid + ")")
			Case OPACTION_REMOVEPLAYER
				m_slotmap.InsertPlayerByID(msg.m_pid, Null)
				Print("Removed player (id: " + msg.m_pid + ")")
		End Select
	End Method
	
	Rem
		bbdoc: Handler for the player movement messages.
		returns: Nothing.
	End Rem
	Method OnPlayerMoveMessage(msg:TPlayerMoveMessage) {handle = "TPlayerMoveMessage"}
		Local player:TPlayer = m_slotmap.GetPlayerByID(msg.m_pid)
		If player
			player.SetPosition(msg.m_x, msg.m_y)
		Else
			Print("(TMasterClient.OnPlayerMoveMessage) MasterClient does not have a player with the recieved id (" + msg.m_pid + ")")
		End If
	End Method
	
End Type

