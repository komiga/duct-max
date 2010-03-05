
Rem
	bbdoc: Master client (client-side player).
End Rem
Type TMasterClient Extends TPlayer
	
	Field m_msgmap:dNetMessageMap
	Field m_slotmap:TSlotMap
	Field m_lastpos:dVec2
	
	Field m_posmessage:TPositionMessage
	
	Method New()
		m_slotmap = New TSlotMap.Create(2)
		m_msgmap = New dNetMessageMap.Create()
		m_lastpos = New dVec2.Create(0.0, 0.0)
	End Method
	
	Rem
		bbdoc: Create a new master client.
		returns: Itself.
	End Rem
	Method Create:TMasterClient(socket:TSocket, pid:Int = 0)
		Super.Create(socket, pid)
		m_msgmap.InsertMessage(New TPlayerOperationMessage.Create())
		m_msgmap.InsertMessage(New TPlayerMoveMessage.Create())
		m_posmessage = New TPositionMessage.Create()
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
			Select msgid
				Case MSGID_PLAYEROPERATION
					Local opmsg:TPlayerOperationMessage = TPlayerOperationMessage(message)
					Select opmsg.m_action
						Case OPACTION_ASSIGNID
							Print("Assigned ID: " + opmsg.m_pid)
							m_pid = opmsg.m_pid
							m_slotmap.InsertPlayer(Self)
						Case OPACTION_ADDPLAYER
							Print("Added player (id: " + opmsg.m_pid + ")")
							m_slotmap.InsertPlayer(New TPlayer.Create(Null, opmsg.m_pid))
						Case OPACTION_REMOVEPLAYER
							Print("Removed player (id: " + opmsg.m_pid + ")")
							m_slotmap.InsertPlayerByID(opmsg.m_pid, Null)
					End Select
				Case MSGID_PLAYERMOVE
					Local movemsg:TPlayerMoveMessage = TPlayerMoveMessage(message)
					Local player:TPlayer = m_slotmap.GetPlayerByID(movemsg.m_pid)
					If player = Null
						Print("(TMasterClient.HandleMessage) MasterClient does not have a player with the recieved id (" + movemsg.m_pid + ")")
					Else
						player.SetPosition(movemsg.m_x, movemsg.m_y)
					End If
			End Select
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
					message = m_msgmap.GetMessageByID(msgid)
					HandleMessage(msgid, message)
				Wend
			End If
		End If
	End Method
	
End Type

