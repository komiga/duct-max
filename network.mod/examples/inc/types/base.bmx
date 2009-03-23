
' 
' base.bmx (Contains: TPlayer, TSlotMap, TPositionMessage, TPlayerMoveMessage, TPlayerOperationMessage, )
' 
' 

Rem
	bbdoc: The Player type.
End Rem
Type TPlayer Extends TClient
	
	Field pid:Byte
	Field pos:TVec2
	
		Method New()
			
			pos = New TVec2.Create(0.0, 0.0)
			
		End Method
		
		Rem
			bbdoc: Create a new Player.
			returns: The new Player (itself).
		End Rem
		Method Create:TPlayer(_socket:TSocket, _pid:Byte = 0)
			
			Super._init(_socket)
			
			pid = _pid
			
			Return Self
			
		End Method
		
		Rem
			bbdoc: Set the Player's position.
			returns: Nothing.
		End Rem
		Method SetPosition(_x:Float, _y:Float)
			
			pos.x = _x
			pos.y = _y
			
		End Method
		
		Rem
			bbdoc: Draw the player to the screen.
			returns: Nothing.
		End Rem
		Method Draw()
			
			DrawOval(pos.x - 2.0, pos.y - 2.0, 4.0, 4.0)
			
		End Method
		
		Method HandleMessage(msg_id:Byte, message:TMessage)
			
			' Stub!
			
		End Method
		
End Type

Rem
	bbdoc: The SlotMap type.
End Rem
Type TSlotMap Extends TObjectMap
	
	Field size:Byte
	
		Rem
			bbdoc: Create a new SlotMap.
			returns: The created SlotMap (itself).
		End Rem
		Method Create:TSlotMap(_size:Byte)
			
			size = _size
			
			Return Self
			
		End Method
		
		Rem
			bbdoc: Get a free slot in the map (if there is one).
			returns: The free slot id, or zero if there is no open slot.
		End Rem
		Method GetFreeSlot:Byte()
			Local player:TPlayer, i:Byte
			
			For i = 1 To size
				
				player = GetPlayerByID(i)
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
		Method GetPlayerByID:TPlayer(_id:Byte)
			
			Return TPlayer(_ValueByKey(String(_id)))
			
		End Method
		
		Rem
			bbdoc: Insert a Player into the SlotMap.
			returns: Nothing.
		End Rem
		Method InsertPlayer(player:TPlayer)
			
			InsertPlayerByID(player.pid, player)
			
		End Method
		
		Rem
			bbdoc: Insert a Player into the SlotMap by a specific id.
			returns: Nothing.
		End Rem
		Method InsertPlayerByID(pid:Byte, player:TPlayer)
			
			_Insert(String(pid), player)
			
		End Method
		
		Rem
			bbdoc: Remove a Player by its pid.
			returns: True if the Player was removed, or False if it was not.
		End Rem
		Method RemovePlayerByID:Int(_pid:Byte)
			
			Return _Remove(String(_pid))
			
		End Method
		
End Type


Const MSGID_POSITION:Byte = TMessage.MSGID_BASE
Const MSGID_PLAYERMOVE:Byte = TMessage.MSGID_BASE + 1
Const MSGID_PLAYEROPERATION:Byte = TMessage.MSGID_BASE + 2

Rem
	bbdoc: The PositionMessage type.
End Rem
Type TPositionMessage Extends TMessage
	
	Field x:Float, y:Float
	
		Rem
			bbdoc: Create a new PositionMessage with the value given.
			returns: The new PositionMessage (itself).
		End Rem
		Method Create:TPositionMessage(_x:Float, _y:Float)
			
			_init(MSGID_POSITION)
			
			Set(_x, _y)
			
			Return Self
			
		End Method
		
		Rem
			bbdoc: Set the value for the PositionMessage.
			returns: Nothing.
		End Rem
		Method Set(_x:Float, _y:Float)
			
			x = _x
			y = _y
			
		End Method
		
		Rem
			bbdoc: Serialize the PositionMessage to a Stream.
			returns: Nothing.
		End Rem
		Method Serialize(stream:TStream)
			
			Super.Serialize(stream)
			stream.WriteFloat(x)
			stream.WriteFloat(y)
			
		End Method
		
		Rem
			bbdoc: Deserialize the PositionMessage from a Stream.
			returns: Nothing.
		End Rem
		Method DeSerialize(stream:TStream, _readid:Int = True)
			
			Super.DeSerialize(stream, _readid)
			x = stream.ReadFloat()
			y = stream.ReadFloat()
			
		End Method
		
End Type

Rem
	bbdoc: The PlayerMoveMessage type.
End Rem
Type TPlayerMoveMessage Extends TMessage
	
	Field pid:Byte
	Field x:Float, y:Float
	
		Rem
			bbdoc: Create a new PlayerMoveMessage with the value given.
			returns: The new PlayerMoveMessage (itself).
		End Rem
		Method Create:TPlayerMoveMessage(_pid:Byte, _x:Float, _y:Float)
			
			_init(MSGID_PLAYERMOVE)
			
			Set(_pid, _x, _y)
			
			Return Self
			
		End Method
		
		Rem
			bbdoc: Set the value for the PlayerMoveMessage.
			returns: Nothing.
		End Rem
		Method Set(_pid:Byte, _x:Float, _y:Float)
			
			pid = _pid
			x = _x
			y = _y
			
		End Method
		
		Rem
			bbdoc: Serialize the PlayerMoveMessage to a Stream.
			returns: Nothing.
		End Rem
		Method Serialize(stream:TStream)
			
			Super.Serialize(stream)
			stream.WriteByte(pid)
			stream.WriteFloat(x)
			stream.WriteFloat(y)
			
		End Method
		
		Rem
			bbdoc: Deserialize the PlayerMoveMessage from a Stream.
			returns: Nothing.
		End Rem
		Method DeSerialize(stream:TStream, _readid:Int = True)
			
			Super.DeSerialize(stream, _readid)
			pid = stream.ReadByte()
			x = stream.ReadFloat()
			y = stream.ReadFloat()
			
		End Method
		
End Type


Const OPACTION_ADDPLAYER:Byte = 1
Const OPACTION_REMOVEPLAYER:Byte = 2
Const OPACTION_ASSIGNID:Byte = 3

Rem
	bbdoc: The PlayerOperationMessage type.
End Rem
Type TPlayerOperationMessage Extends TMessage
	
	Field pid:Byte
	Field action:Byte ', data:Byte
	
		Rem
			bbdoc: Create a new PlayerOperationMessage with the value given.
			returns: The new PlayerOperationMessage (itself).
		End Rem
		Method Create:TPlayerOperationMessage(_pid:Byte, _action:Byte) ', _data:Byte)
			
			_init(MSGID_PLAYEROPERATION)
			
			Set(_pid, _action) ', _data)
			
			Return Self
			
		End Method
		
		Rem
			bbdoc: Set the value for the PlayerOperationMessage.
			returns: Nothing.
		End Rem
		Method Set(_pid:Byte, _action:Byte) ', _data:Byte)
			
			pid = _pid
			action = _action
			'data = _data
			
		End Method
		
		Rem
			bbdoc: Serialize the PlayerOperationMessage to a Stream.
			returns: Nothing.
		End Rem
		Method Serialize(stream:TStream)
			
			Super.Serialize(stream)
			stream.WriteByte(pid)
			stream.WriteByte(action)
			'stream.WriteByte(data)
			
		End Method
		
		Rem
			bbdoc: Deserialize the PlayerOperationMessage from a Stream.
			returns: Nothing.
		End Rem
		Method DeSerialize(stream:TStream, _readid:Int = True)
			
			Super.DeSerialize(stream, _readid)
			pid = stream.ReadByte()
			action = stream.ReadByte()
			'data = stream.ReadByte()
			
		End Method
		
End Type
















