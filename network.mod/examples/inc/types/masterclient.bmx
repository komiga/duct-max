
Rem
	masterclient.bmx (Contains: TMasterClient, )
End Rem

Rem
	bbdoc: The MasterClient type.
End Rem
Type TMasterClient Extends TPlayer
	
	Field m_msgmap:TMessageMap
	Field m_slotmap:TSlotMap
	Field m_lastpos:TVec2
	
	Field m_posmessage:TPositionMessage
	
	Method New()
		m_slotmap = New TSlotMap.Create(2)
		m_msgmap = New TMessageMap.Create()
		m_lastpos = New TVec2.Create(0.0, 0.0)
	End Method
	
	Rem
		bbdoc: Create a new MasterClient.
		returns: The created MasterClient.
	End Rem
	Method Create:TMasterClient(socket:TSocket, pid:Byte = 0)
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
		For Local player:TPlayer = EachIn slotmap.m_map.Values()
			player.Draw()
		Next
	End Method
	
	Rem
		bbdoc: Set the position of the MasterClient.
		returns Nothing.
	End Rem
	Method SetPosition(_x:Float, y:Float)
		Super.SetPosition(x, y)
		If pos.m_x <> lastpos.m_x Or pos.m_y <> lastpos.m_y
			lastpos.SetVec(pos)
			SendPosition()
		End If
	End Method
	
	Rem
		bbdoc: Send the position of the Player to the Server.
		returns: Nothing.
	End Rem
	Method SendPosition()
		posmessage.Set(pos.m_x, pos.m_y)
		posmessage.Serialize(Self)
	End Method
	
	Rem
		bbdoc: Handle a Message sent from the Server.
		returns: Nothing.
	End Rem
	Method HandleMessage(msgid:Int, message:TMessage)
		If message = Null
			Print("(TMasterClient.HandleMessage) Unknown message id: " + msgid)
		Else
			message.DeSerialize(Self, False)
			Select msgid
				Case MSGID_PLAYEROPERATION
					Local opmsg:TPlayerOperationMessage, player:TPlayer
				
					opmsg = TPlayerOperationMessage(message)
					Select opmsg.action
						Case OPACTION_ASSIGNID
							Print("Assigned ID: " + opmsg.m_pid)
							pid = opmsg.m_pid
							slotmap.InsertPlayer(Self)
						Case OPACTION_ADDPLAYER
							Print("Added player (id: " + opmsg.m_pid + ")")
							player = New TPlayer.Create(Null, opmsg.m_pid)
							slotmap.InsertPlayer(player)
						Case OPACTION_REMOVEPLAYER
							Print("Removed player (id: " + opmsg.m_pid + ")")
							slotmap.InsertPlayerByID(opmsg.m_pid, Null)
					End Select
				Case MSGID_PLAYERMOVE
					Local movemsg:TPlayerMoveMessage, player:TPlayer
				
					movemsg = TPlayerMoveMessage(message)
					player = slotmap.GetPlayerByID(movemsg.m_pid)
					If player = Null
						Print("(TMasterClient.HandleMessage) MasterClient does not have a player by the sent id (" + movemsg.m_pid + ")")
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
		Local msgid:Byte, message:TMessage
		
		If Eof() = False
			If ReadAvail() > 0
				While ReadAvail() > 0
					msgid = ReadByte()
					message = msgmap.GetMessageByID(msgid)
					HandleMessage(msgid, message)
				Wend
			End If
		End If
	End Method
	
End Type

