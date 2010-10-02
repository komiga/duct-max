
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
	Method Render()
		DrawOval(m_pos.m_x - 2.0, m_pos.m_y - 2.0, 4.0, 4.0)
	End Method
	
	Method HandleMessage(msgid:Int, message:dNetMessage)
		' Stub!
	End Method
	
End Type

Rem
	bbdoc: TPlayer id slot map.
End Rem
Type TSlotMap
	
	Field m_map:dIntMap
	
	Field m_size:Int
	Method New()
		m_map = New dIntMap
	End Method
	
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
			If Not Contains(i)
				Return i
			End If
		Next
		Return 0
	End Method
	
	Rem
		bbdoc: Check if the map contains a player with the given id.
		returns: True if the map contains a player with the given id, or False if it does not.
	End Rem
	Method Contains:Int(pid:Int)
		Return m_map.Contains(pid)
	End Method
	
	Rem
		bbdoc: Get a player with the given id.
		returns: The player with the id given, or Null if the map does not contain a player with the given id.
	End Rem
	Method GetPlayerWithID:TPlayer(pid:Int)
		Return TPlayer(m_map.ForKey(pid))
	End Method
	
	Rem
		bbdoc: Insert a player into the map.
		returns: Nothing.
	End Rem
	Method InsertPlayer(player:TPlayer)
		InsertPlayerWithID(player, player.m_pid)
	End Method
	
	Rem
		bbdoc: Insert a player into the map with the given id.
		returns: Nothing.
	End Rem
	Method InsertPlayerWithID(player:TPlayer, pid:Int)
		m_map.Insert(pid, player)
	End Method
	
	Rem
		bbdoc: Remove the player with the given id.
		returns: True if the player was removed, or False if the given id was not in the map.
	End Rem
	Method RemovePlayerWithID:Int(pid:Int)
		Return m_map.Remove(pid)
	End Method
	
	Rem
		bbdoc: Get the map's enumerator.
		returns: The map's enumerator.
	End Rem
	Method ObjectEnumerator:dIntMapStandardEnum()
		Return m_map.ObjectEnumerator()
	End Method
	
End Type

Const MSGID_POSITION:Int = dNetMessage.MSGID_BASE
Const MSGID_PLAYERMOVE:Int = dNetMessage.MSGID_BASE + 1
Const MSGID_PLAYEROPERATION:Int = dNetMessage.MSGID_BASE + 2

Rem
	bbdoc: TPlayer position message.
End Rem
Type TPositionMessage Extends dNetMessage
	
	Field m_x:Float, m_y:Float
	
	Method New()
		_init(MSGID_POSITION)
	End Method
	
	Rem
		bbdoc: Set message's data.
		returns: Nothing.
	End Rem
	Method Set(x:Float, y:Float)
		m_x = x
		m_y = y
	End Method
	
	Rem
		bbdoc: Serialize the message to the given stream.
		returns: Nothing.
	End Rem
	Method Serialize(stream:TStream)
		Super.Serialize(stream)
		stream.WriteFloat(m_x)
		stream.WriteFloat(m_y)
	End Method
	
	Rem
		bbdoc: Deserialize the message from the given stream.
		returns: Nothing.
	End Rem
	Method Deserialize(stream:TStream, _readid:Int = True)
		Super.Deserialize(stream, _readid)
		m_x = stream.ReadFloat()
		m_y = stream.ReadFloat()
	End Method
	
End Type

Rem
	bbdoc: TPlayer move message (player movement).
End Rem
Type TPlayerMoveMessage Extends dNetMessage
	
	Field m_pid:Int
	Field m_x:Float, m_y:Float
	
	Method New()
		_init(MSGID_PLAYERMOVE)
	End Method
	
	Rem
		bbdoc: Set message's data.
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
	bbdoc: TPlayer operation message (assign id, add player, remove player).
End Rem
Type TPlayerOperationMessage Extends dNetMessage
	
	Field m_pid:Int
	Field m_action:Int
	
	Method New()
		_init(MSGID_PLAYEROPERATION)
	End Method
	
	Rem
		bbdoc: Set message's data.
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
		stream.WriteByte(m_pid)
		stream.WriteByte(m_action)
	End Method
	
	Rem
		bbdoc: Deserialize the message from the given stream.
		returns: Nothing.
	End Rem
	Method Deserialize(stream:TStream, readid:Int = True)
		Super.Deserialize(stream, readid)
		m_pid = stream.ReadByte()
		m_action = stream.ReadByte()
	End Method
	
End Type

