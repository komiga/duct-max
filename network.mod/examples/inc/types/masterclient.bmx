
Rem
	masterclient.bmx (Contains: TMasterClient, )
End Rem

Rem
	bbdoc: The MasterClient type.
End Rem
Type TMasterClient Extends TPlayer
	
	Field m_msgmap:TNetMessageMap
	Field m_slotmap:TSlotMap
	Field m_lastpos:TVec2
	
	Field m_posmessage:TPositionMessage
	
	Method New()
		m_slotmap = New TSlotMap.Create(2)
		m_msgmap = New TNetMessageMap.Create()
		m_lastpos = New TVec2.Create(0.0, 0.0)
	End Method
	
	Rem
		bbdoc: Create a new MasterClient.
		returns: The created MasterClient.
	End Rem
	Method Create:TMasterClient(socket:TSocket, pid:Int = 0)
		Super.Create(socket, pid)
		m_msgmap.InsertMessage(New TPlayerOperationMessage.Create(0, 0))
		m_msgmap.InsertMessage(New TPlayerMoveMessage.Create(0, 0.0, 0.0))
		m_posmessage = New TPositionMessage.Create(0.0, 0.0)
		Return Self
	End Method
	
	Rem
		bbdoc: Draw all the players.
		returns: Nothing.
	End Rem
	Method DrawPlayers()
		For Local player:TPlayer = EachIn m_slotmap.ValueEnumerator()
			player.Draw()
		Next
	End Method
	
	Rem
		bbdoc: Set the position of the MasterClient.
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
		bbdoc: Send the position of the Player to the Server.
		returns: Nothing.
	End Rem
	Method SendPosition()
		m_posmessage.Set(m_pos.m_x, m_pos.m_y)
		m_posmessage.Serialize(Self)
	End Method
	
	Rem
		bbdoc: Handle a Message sent from the Server.
		returns: Nothing.
	End Rem
	Method HandleMessage(msgid:Int, message:TNetMessage)
		If message = Null
			Print("(TMasterClient.HandleMessage) Unknown message id: " + msgid)
		Else
			message.DeSerialize(Self, False)
			Select msgid
				Case MSGID_PLAYEROPERATION
					Local opmsg:TPlayerOperationMessage, player:TPlayer
					
					opmsg = TPlayerOperationMessage(message)
					Select opmsg.m_action
						Case OPACTION_ASSIGNID
							Print("Assigned ID: " + opmsg.m_pid)
							m_pid = opmsg.m_pid
							m_slotmap.InsertPlayer(Self)
						Case OPACTION_ADDPLAYER
							Print("Added player (id: " + opmsg.m_pid + ")")
							player = New TPlayer.Create(Null, opmsg.m_pid)
							m_slotmap.InsertPlayer(player)
						Case OPACTION_REMOVEPLAYER
							Print("Removed player (id: " + opmsg.m_pid + ")")
							m_slotmap.InsertPlayerByID(opmsg.m_pid, Null)
					End Select
				Case MSGID_PLAYERMOVE
					Local movemsg:TPlayerMoveMessage, player:TPlayer
					
					movemsg = TPlayerMoveMessage(message)
					player = m_slotmap.GetPlayerByID(movemsg.m_pid)
					If player = Null
						Print("(TMasterClient.HandleMessage) MasterClient does not have a player with the recieved id (" + movemsg.m_pid + ")")
					Else
						player.SetPosition(movemsg.m_x, movemsg.m_y)
					End If
			End Select
		End If
	End Method
	
	Rem
		bbdoc: Check for and handle incoming data from the Server.
		returns: Nothing.
	End Rem
	Method CheckTransmissions()
		Local msgid:Int, message:TNetMessage
		
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

