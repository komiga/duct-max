
Rem
	bbdoc: Generic player.
	about: This is extended by both TMasterClient and TMasterServer to implement the client-side and server-side handling.
End Rem
Type TPlayer Extends dClient
	
	Field m_pid:Int, m_pos:dVec2
	
	Method New()
		m_pos = New dVec2.Create(0.0, 0.0)
	End Method
	
	Rem
		bbdoc: Create a new player with the given socket and player id.
		returns: Itself.
	End Rem
	Method Create:TPlayer(socket:TSocket, pid:Int = 0)
		Super._init(socket)
		m_pid = pid
		Return Self
	End Method
	
	Rem
		bbdoc: Set the Player's position.
		returns: Nothing.
	End Rem
	Method SetPosition(x:Float, y:Float)
		m_pos.Set(x, y)
	End Method
	
	Rem
		bbdoc: Draw the player to the screen.
		returns: Nothing.
	End Rem
	Method Draw()
		DrawOval(m_pos.m_x - 2.0, m_pos.m_y - 2.0, 4.0, 4.0)
	End Method
	
	Method HandleMessage(msgid:Int, message:dNetMessage)
		' Stub!
	End Method
	
End Type

Rem
	bbdoc: Player id slot map.
End Rem
Type TSlotMap Extends dObjectMap
	
	Field m_size:Int
	
	Rem
		bbdoc: Create a new slot map with the given size.
		returns: Itself.
	End Rem
	Method Create:TSlotMap(size:Int)
		m_size = size
		Return Self
	End Method
	
	Rem
		bbdoc: Get a free slot in the map (if there is one).
		returns: The free slot id, or zero if there is no open slot.
	End Rem
	Method GetFreeSlot:Int()
		For Local i:Int = 1 To m_size
			Local player:TPlayer = GetPlayerByID(i)
			If player = Null
				Return i
			End If
		Next
		Return 0
	End Method
	
	Rem
		bbdoc: Get a Player by its id.
		returns: A Player by the id given, or Null if this SlotMap does not contain a Player by the id given.
	End Rem
	Method GetPlayerByID:TPlayer(pid:Int)
		Return TPlayer(_ValueByKey(String(pid)))
	End Method
	
	Rem
		bbdoc: Insert a Player into the SlotMap.
		returns: Nothing.
	End Rem
	Method InsertPlayer(player:TPlayer)
		InsertPlayerByID(player.m_pid, player)
	End Method
	
	Rem
		bbdoc: Insert a Player into the SlotMap by a specific id.
		returns: Nothing.
	End Rem
	Method InsertPlayerByID(pid:Int, player:TPlayer)
		_Insert(String(pid), player)
	End Method
	
	Rem
		bbdoc: Remove a Player by its m_pid.
		returns: True if the Player was removed, or False if it was not.
	End Rem
	Method RemovePlayerByID:Int(pid:Int)
		Return _Remove(String(pid))
	End Method
	
End Type

Const MSGID_POSITION:Int = dNetMessage.MSGID_BASE
Const MSGID_PLAYERMOVE:Int = dNetMessage.MSGID_BASE + 1
Const MSGID_PLAYEROPERATION:Int = dNetMessage.MSGID_BASE + 2

Rem
	bbdoc: Player position message.
End Rem
Type TPositionMessage Extends dNetMessage
	
	Field m_x:Float, m_y:Float
	
	Rem
		bbdoc: Create a new PositionMessage with the value given.
		returns: The new PositionMessage (itself).
	End Rem
	Method Create:TPositionMessage()
		_init(MSGID_POSITION)
		Return Self
	End Method
	
	Rem
		bbdoc: Set the value for the PositionMessage.
		returns: Nothing.
	End Rem
	Method Set(x:Float, y:Float)
		m_x = x
		m_y = y
	End Method
	
	Rem
		bbdoc: Serialize the PositionMessage to a Stream.
		returns: Nothing.
	End Rem
	Method Serialize(stream:TStream)
		Super.Serialize(stream)
		stream.WriteFloat(m_x)
		stream.WriteFloat(m_y)
	End Method
	
	Rem
		bbdoc: Deserialize the PositionMessage from a Stream.
		returns: Nothing.
	End Rem
	Method Deserialize(stream:TStream, readid:Int = True)
		Super.Deserialize(stream, readid)
		m_x = stream.ReadFloat()
		m_y = stream.ReadFloat()
	End Method
	
End Type

Rem
	bbdoc: Player move message (player movement).
End Rem
Type TPlayerMoveMessage Extends dNetMessage
	
	Field m_pid:Int
	Field m_x:Float, m_y:Float
	
	Rem
		bbdoc: Create a new player move message.
		returns: Itself.
	End Rem
	Method Create:TPlayerMoveMessage()
		_init(MSGID_PLAYERMOVE)
		Return Self
	End Method
	
	Rem
		bbdoc: Set the values for the message.
		returns: Nothing.
	End Rem
	Method Set(pid:Int, x:Float, y:Float)
		m_pid = pid
		m_x = x
		m_y = y
	End Method
	
	Rem
		bbdoc: Serialize the message to the given stream.
		returns: Nothing.
	End Rem
	Method Serialize(stream:TStream)
		Super.Serialize(stream)
		stream.WriteByte(m_pid)
		stream.WriteFloat(m_x)
		stream.WriteFloat(m_y)
	End Method
	
	Rem
		bbdoc: Deserialize the message from the given stream.
		returns: Nothing.
	End Rem
	Method Deserialize(stream:TStream, readid:Int = True)
		Super.Deserialize(stream, readid)
		m_pid = stream.ReadByte()
		m_x = stream.ReadFloat()
		m_y = stream.ReadFloat()
	End Method
	
End Type

Const OPACTION_ADDPLAYER:Int = 1
Const OPACTION_REMOVEPLAYER:Int = 2
Const OPACTION_ASSIGNID:Int = 3

Rem
	bbdoc: Player operation message (assign id, add player, remove player).
End Rem
Type TPlayerOperationMessage Extends dNetMessage
	
	Field m_pid:Int
	Field m_action:Int
	
	Rem
		bbdoc: Create a new player operation message.
		returns: Itself.
	End Rem
	Method Create:TPlayerOperationMessage()
		_init(MSGID_PLAYEROPERATION)
		Return Self
	End Method
	
	Rem
		bbdoc: Set the value for the PlayerOperationMessage.
		returns: Nothing.
	End Rem
	Method Set(pid:Int, action:Int)
		m_pid = pid
		m_action = action
	End Method
	
	Rem
		bbdoc: Serialize the message to the given stream.
		returns: Nothing.
	End Rem
	Method Serialize(stream:TStream)
		Super.Serialize(stream)
		stream.WriteByte(Byte(m_pid))
		stream.WriteByte(Byte(m_action))
	End Method
	
	Rem
		bbdoc: Deserialize the message from the given stream.
		returns: Nothing.
	End Rem
	Method Deserialize(stream:TStream, readid:Int = True)
		Super.Deserialize(stream, readid)
		m_pid = Int(stream.ReadByte())
		m_action = Int(stream.ReadByte())
	End Method
	
End Type

