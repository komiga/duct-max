
' 
' basicmessages.bmx (Contains: TByteMessage, TShortMessage, TIntegerMessage, TLongMessage, ..
'		TFloatMessage, TDoubleMessage, TStringMessage, )
' Examples of basic datatype messages.
'

Rem
	bbdoc: The ByteMessage type.
End Rem
Type TByteMessage Extends TMessage
	
	Field value:Byte
	
		Rem
			bbdoc: Create a new ByteMessage with the value given.
			returns: The new ByteMessage (itself).
		End Rem
		Method Create:TByteMessage(_value:Byte)
			
			_init(TMessage.MSGID_BASE)
			
			SetValue(_value)
			
			Return Self
			
		End Method
		
		Rem
			bbdoc: Set the value for the ByteMessage.
			returns: Nothing.
		End Rem
		Method SetValue(_value:Byte)
			
			value = _value
			
		End Method
		
		Rem
			bbdoc: Get the value of the ByteMessage.
			returns: The value of this ByteMessage.
		End Rem
		Method GetValue:Byte()
			
			Return value
			
		End Method
		
		Rem
			bbdoc: Serialize the ByteMessage to a Stream.
			returns: Nothing.
		End Rem
		Method Serialize(stream:TStream)
			
			Super.Serialize(stream)
			stream.WriteByte(value)
			
		End Method
		
		Rem
			bbdoc: Deserialize the ByteMessage from a Stream.
			returns: Nothing.
		End Rem
		Method DeSerialize(stream:TStream, _readid:Int = True)
			
			Super.DeSerialize(stream, _readid)
			value = stream.ReadByte()
			
		End Method
		
End Type

Rem
	bbdoc: The ShortMessage type.
End Rem
Type TShortMessage Extends TMessage
	
	Field value:Short
	
		Rem
			bbdoc: Create a new ShortMessage with the value given.
			returns: The new ShortMessage (itself).
		End Rem
		Method Create:TShortMessage(_value:Short)
			
			_init(TMessage.MSGID_BASE + 1)
			
			SetValue(_value)
			
			Return Self
			
		End Method
		
		Rem
			bbdoc: Set the value for the ShortMessage.
			returns: Nothing.
		End Rem
		Method SetValue(_value:Short)
			
			value = _value
			
		End Method
		
		Rem
			bbdoc: Get the value of the ShortMessage.
			returns: The value of this ShortMessage.
		End Rem
		Method GetValue:Short()
			
			Return value
			
		End Method
		
		Rem
			bbdoc: Serialize the ShortMessage to a Stream.
			returns: Nothing.
		End Rem
		Method Serialize(stream:TStream)
			
			Super.Serialize(stream)
			stream.WriteShort(value)
			
		End Method
		
		Rem
			bbdoc: Deserialize the ShortMessage from a Stream.
			returns: Nothing.
		End Rem
		Method DeSerialize(stream:TStream, _readid:Int = True)
			
			Super.DeSerialize(stream, _readid)
			value = stream.ReadShort()
			
		End Method
		
End Type

Rem
	bbdoc: The IntegerMessage type.
End Rem
Type TIntegerMessage Extends TMessage
	
	Field value:Int
	
		Rem
			bbdoc: Create a new IntegerMessage with the value given.
			returns: The new IntegerMessage (itself).
		End Rem
		Method Create:TIntegerMessage(_value:Int)
			
			_init(TMessage.MSGID_BASE + 2)
			
			SetValue(_value)
			
			Return Self
			
		End Method
		
		Rem
			bbdoc: Set the value for the IntegerMessage.
			returns: Nothing.
		End Rem
		Method SetValue(_value:Int)
			
			value = _value
			
		End Method
		
		Rem
			bbdoc: Get the value of the IntegerMessage.
			returns: The value of this IntegerMessage.
		End Rem
		Method GetValue:Int()
			
			Return value
			
		End Method
		
		Rem
			bbdoc: Serialize the IntegerMessage to a Stream.
			returns: Nothing.
		End Rem
		Method Serialize(stream:TStream)
			
			Super.Serialize(stream)
			stream.WriteInt(value)
			
		End Method
		
		Rem
			bbdoc: Deserialize the IntegerMessage from a Stream.
			returns: Nothing.
		End Rem
		Method DeSerialize(stream:TStream, _readid:Int = True)
			
			Super.DeSerialize(stream, _readid)
			value = stream.ReadInt()
			
		End Method
		
End Type

Rem
	bbdoc: The LongMessage type.
End Rem
Type TLongMessage Extends TMessage
	
	Field value:Long
	
		Rem
			bbdoc: Create a new LongMessage with the value given.
			returns: The new LongMessage (itself).
		End Rem
		Method Create:TLongMessage(_value:Long)
			
			_init(TMessage.MSGID_BASE + 3)
			
			SetValue(_value)
			
			Return Self
			
		End Method
		
		Rem
			bbdoc: Set the value for the LongMessage.
			returns: Nothing.
		End Rem
		Method SetValue(_value:Long)
			
			value = _value
			
		End Method
		
		Rem
			bbdoc: Get the value of the LongMessage.
			returns: The value of this LongMessage.
		End Rem
		Method GetValue:Long()
			
			Return value
			
		End Method
		
		Rem
			bbdoc: Serialize the LongMessage to a Stream.
			returns: Nothing.
		End Rem
		Method Serialize(stream:TStream)
			
			Super.Serialize(stream)
			stream.WriteLong(value)
			
		End Method
		
		Rem
			bbdoc: Deserialize the LongMessage from a Stream.
			returns: Nothing.
		End Rem
		Method DeSerialize(stream:TStream, _readid:Int = True)
			
			Super.DeSerialize(stream, _readid)
			value = stream.ReadLong()
			
		End Method
		
End Type

Rem
	bbdoc: The FloatMessage type.
End Rem
Type TFloatMessage Extends TMessage
	
	Field value:Float
	
		Rem
			bbdoc: Create a new FloatMessage with the value given.
			returns: The new FloatMessage (itself).
		End Rem
		Method Create:TFloatMessage(_value:Float)
			
			_init(TMessage.MSGID_BASE + 4)
			
			SetValue(_value)
			
			Return Self
			
		End Method
		
		Rem
			bbdoc: Set the value for the FloatMessage.
			returns: Nothing.
		End Rem
		Method SetValue(_value:Float)
			
			value = _value
			
		End Method
		
		Rem
			bbdoc: Get the value of the FloatMessage.
			returns: The value of this FloatMessage.
		End Rem
		Method GetValue:Float()
			
			Return value
			
		End Method
		
		Rem
			bbdoc: Serialize the FloatMessage to a Stream.
			returns: Nothing.
		End Rem
		Method Serialize(stream:TStream)
			
			Super.Serialize(stream)
			stream.WriteFloat(value)
			
		End Method
		
		Rem
			bbdoc: Deserialize the FloatMessage from a Stream.
			returns: Nothing.
		End Rem
		Method DeSerialize(stream:TStream, _readid:Int = True)
			
			Super.DeSerialize(stream, _readid)
			value = stream.ReadFloat()
			
		End Method
		
End Type

Rem
	bbdoc: The DoubleMessage type.
End Rem
Type TDoubleMessage Extends TMessage
	
	Field value:Double
	
		Rem
			bbdoc: Create a new DoubleMessage with the value given.
			returns: The new DoubleMessage (itself).
		End Rem
		Method Create:TDoubleMessage(_value:Double)
			
			_init(TMessage.MSGID_BASE + 5)
			
			SetValue(_value)
			
			Return Self
			
		End Method
		
		Rem
			bbdoc: Set the value for the DoubleMessage.
			returns: Nothing.
		End Rem
		Method SetValue(_value:Double)
			
			value = _value
			
		End Method
		
		Rem
			bbdoc: Get the value of the DoubleMessage.
			returns: The value of this DoubleMessage.
		End Rem
		Method GetValue:Double()
			
			Return value
			
		End Method
		
		Rem
			bbdoc: Serialize the DoubleMessage to a Stream.
			returns: Nothing.
		End Rem
		Method Serialize(stream:TStream)
			
			Super.Serialize(stream)
			stream.WriteDouble(value)
			
		End Method
		
		Rem
			bbdoc: Deserialize the DoubleMessage from a Stream.
			returns: Nothing.
		End Rem
		Method DeSerialize(stream:TStream, _readid:Int = True)
			
			Super.DeSerialize(stream, _readid)
			value = stream.ReadDouble()
			
		End Method
		
End Type 

Rem
	bbdoc: The StringMessage type.
End Rem
Type TStringMessage Extends TMessage
	
	Field value:String
	
		Rem
			bbdoc: Create a new StringMessage with the value given.
			returns: The new StringMessage (itself).
		End Rem
		Method Create:TStringMessage(_value:String)
			
			_init(TMessage.MSGID_BASE + 6)
			
			SetValue(_value)
			
			Return Self
			
		End Method
		
		Rem
			bbdoc: Set the value for the StringMessage.
			returns: Nothing.
		End Rem
		Method SetValue(_value:String)
			
			value = _value
			
		End Method
		
		Rem
			bbdoc: Get the value of the StringMessage.
			returns: The value of this StringMessage.
		End Rem
		Method GetValue:String()
			
			Return value
			
		End Method
		
		Rem
			bbdoc: Serialize the StringMessage to a Stream.
			returns: Nothing.
		End Rem
		Method Serialize(stream:TStream)
			
			Super.Serialize(stream)
			WriteLString(stream, value)
			
		End Method
		
		Rem
			bbdoc: Deserialize the StringMessage from a Stream.
			returns: Nothing.
		End Rem
		Method DeSerialize(stream:TStream, _readid:Int = True)
			
			Super.DeSerialize(stream, _readid)
			value = ReadLString(stream)
			
		End Method
		
End Type














