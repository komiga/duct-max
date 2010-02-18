
' 
' base.bmx (Contains: TPlayer, TSlotMap, TPositionMessage, TPlayerMoveMessage, TPlayerOperationMessage, )
' 
' 

Rem
	bbdoc: The Player type.
End Rem
Type TPlayer Extends TClient
	
	Field m_pid:Int, m_pos:TVec2
	
	Method New()
		m_pos = New TVec2.Create(0.0, 0.0)
	End Method
	
	Rem
		bbdoc: Create a new Player.
		returns: The new Player (itself).
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
	
	Method HandleMessage(msgid:Int, message:TNetMessage)
		' Stub!
	End Method
	
End Type

Rem
	bbdoc: The SlotMap type.
End Rem
Type TSlotMap Extends TObjectMap
	
	Field m_size:Int
	
	Rem
		bbdoc: Create a new SlotMap.
		returns: The created SlotMap (itself).
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

Const MSGID_POSITION:Byte = TNetMessage.MSGID_BASE
Const MSGID_PLAYERMOVE:Byte = TNetMessage.MSGID_BASE + 1
Const MSGID_PLAYEROPERATION:Byte = TNetMessage.MSGID_BASE + 2

Rem
	bbdoc: The PositionMessage type.
End Rem
Type TPositionMessage Extends TNetMessage
	
	Field m_x:Float, m_y:Float
	
	Rem
		bbdoc: Create a new PositionMessage with the value given.
		returns: The new PositionMessage (itself).
	End Rem
	Method Create:TPositionMessage(x:Float, y:Float)
		_init(MSGID_POSITION)
		Set(x, y)
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
	Method DeSerialize(stream:TStream, readid:Int = True)
		Super.DeSerialize(stream, readid)
		m_x = stream.ReadFloat()
		m_y = stream.ReadFloat()
	End Method
	
End Type

Rem
	bbdoc: The PlayerMoveMessage type.
End Rem
Type TPlayerMoveMessage Extends TNetMessage
	
	Field m_pid:Int
	Field m_x:Float, m_y:Float
	
	Rem
		bbdoc: Create a new PlayerMoveMessage with the value given.
		returns: The new PlayerMoveMessage (itself).
	End Rem
	Method Create:TPlayerMoveMessage(pid:Int, x:Float, y:Float)
		_init(MSGID_PLAYERMOVE)
		Set(pid, x, y)
		Return Self
	End Method
	
	Rem
		bbdoc: Set the values for the PlayerMoveMessage.
		returns: Nothing.
	End Rem
	Method Set(pid:Int, x:Float, y:Float)
		m_pid = pid
		m_x = x
		m_y = y
	End Method
	
	Rem
		bbdoc: Serialize the PlayerMoveMessage to a Stream.
		returns: Nothing.
	End Rem
	Method Serialize(stream:TStream)
		Super.Serialize(stream)
		stream.WriteByte(m_pid)
		stream.WriteFloat(m_x)
		stream.WriteFloat(m_y)
	End Method
	
	Rem
		bbdoc: Deserialize the PlayerMoveMessage from a Stream.
		returns: Nothing.
	End Rem
	Method DeSerialize(stream:TStream, readid:Int = True)
		Super.DeSerialize(stream, readid)
		m_pid = stream.ReadByte()
		m_x = stream.ReadFloat()
		m_y = stream.ReadFloat()
	End Method
	
End Type


Const OPACTION_ADDPLAYER:Byte = 1
Const OPACTION_REMOVEPLAYER:Byte = 2
Const OPACTION_ASSIGNID:Byte = 3

Rem
	bbdoc: The PlayerOperationMessage type.
End Rem
Type TPlayerOperationMessage Extends TNetMessage
	
	Field m_pid:Int
	Field m_action:Int ', m_data:Int
	
	Rem
		bbdoc: Create a new PlayerOperationMessage with the value given.
		returns: The new PlayerOperationMessage (itself).
	End Rem
	Method Create:TPlayerOperationMessage(pid:Int, action:Int) ', data:Byte)
		_init(MSGID_PLAYEROPERATION)
		Set(pid, action) ', data)
		Return Self
	End Method
	
	Rem
		bbdoc: Set the value for the PlayerOperationMessage.
		returns: Nothing.
	End Rem
	Method Set(pid:Int, action:Int) ', data:Byte)
		m_pid = pid
		m_action = action
		'm_data = data
	End Method
	
	Rem
		bbdoc: Serialize the PlayerOperationMessage to a Stream.
		returns: Nothing.
	End Rem
	Method Serialize(stream:TStream)
		Super.Serialize(stream)
		stream.WriteByte(Byte(m_pid))
		stream.WriteByte(Byte(m_action))
		'stream.WriteByte(Byte(m_data))
	End Method
	
	Rem
		bbdoc: Deserialize the PlayerOperationMessage from a Stream.
		returns: Nothing.
	End Rem
	Method DeSerialize(stream:TStream, readid:Int = True)
		Super.DeSerialize(stream, readid)
		m_pid = Int(stream.ReadByte())
		m_action = Int(stream.ReadByte())
		'm_data = Int(stream.ReadByte())
	End Method
	
End Type

