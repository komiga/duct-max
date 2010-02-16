
Rem
	Copyright (c) 2009 Tim Howard
	
	Permission is hereby granted, free of charge, to any person obtaining a copy
	of this software and associated documentation files (the "Software"), to deal
	in the Software without restriction, including without limitation the rights
	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the Software is
	furnished to do so, subject to the following conditions:
	
	The above copyright notice and this permission notice shall be included in
	all copies or substantial portions of the Software.
	
	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
	THE SOFTWARE.
	-----------------------------------------------------------------------------
	
	basicmessages.bmx (Contains: TByteMessage, TShortMessage, TIntegerMessage, TLongMessage,
								TFloatMessage, TDoubleMessage, TStringMessage, )
	
	Description:
				Examples of basic datatype messages.
	
End Rem

Rem
	bbdoc: The ByteMessage type.
End Rem
Type TByteMessage Extends TNetMessage
	
	Field m_value:Byte
	
	Rem
		bbdoc: Create a new ByteMessage with the m_value given.
		returns: The new ByteMessage (itself).
	End Rem
	Method Create:TByteMessage(m_value:Byte)
		_init(TNetMessage.MSGID_BASE)
		SetValue(m_value)
		Return Self
	End Method
	
	Rem
		bbdoc: Set the m_value for the ByteMessage.
		returns: Nothing.
	End Rem
	Method SetValue(m_value:Byte)
		m_value = m_value
	End Method
	
	Rem
		bbdoc: Get the m_value of the ByteMessage.
		returns: The m_value of this ByteMessage.
	End Rem
	Method GetValue:Byte()
		Return m_value
	End Method
	
	Rem
		bbdoc: Serialize the ByteMessage to a Stream.
		returns: Nothing.
	End Rem
	Method Serialize(stream:TStream)
		Super.Serialize(stream)
		stream.WriteByte(m_value)
	End Method
	
	Rem
		bbdoc: Deserialize the ByteMessage from a Stream.
		returns: Nothing.
	End Rem
	Method DeSerialize(stream:TStream, readid:Int = True)
		Super.DeSerialize(stream, readid)
		m_value = stream.ReadByte()
	End Method
	
End Type

Rem
	bbdoc: The ShortMessage type.
End Rem
Type TShortMessage Extends TNetMessage
	
	Field m_value:Short
	
	Rem
		bbdoc: Create a new ShortMessage with the m_value given.
		returns: The new ShortMessage (itself).
	End Rem
	Method Create:TShortMessage(value:Short)
		_init(TNetMessage.MSGID_BASE + 1)
		SetValue(value)
		Return Self
	End Method
	
	Rem
		bbdoc: Set the m_value for the ShortMessage.
		returns: Nothing.
	End Rem
	Method SetValue(value:Short)
		m_value = value
	End Method
	
	Rem
		bbdoc: Get the m_value of the ShortMessage.
		returns: The m_value of this ShortMessage.
	End Rem
	Method GetValue:Short()
		Return m_value
	End Method
	
	Rem
		bbdoc: Serialize the ShortMessage to a Stream.
		returns: Nothing.
	End Rem
	Method Serialize(stream:TStream)
		Super.Serialize(stream)
		stream.WriteShort(m_value)
	End Method
	
	Rem
		bbdoc: Deserialize the ShortMessage from a Stream.
		returns: Nothing.
	End Rem
	Method DeSerialize(stream:TStream, readid:Int = True)
		Super.DeSerialize(stream, readid)
		m_value = stream.ReadShort()
	End Method
	
End Type

Rem
	bbdoc: The IntegerMessage type.
End Rem
Type TIntegerMessage Extends TNetMessage
	
	Field m_value:Int
	
	Rem
		bbdoc: Create a new IntegerMessage with the m_value given.
		returns: The new IntegerMessage (itself).
	End Rem
	Method Create:TIntegerMessage(value:Int)
		_init(TNetMessage.MSGID_BASE + 2)
		SetValue(value)
		Return Self
	End Method
	
	Rem
		bbdoc: Set the m_value for the IntegerMessage.
		returns: Nothing.
	End Rem
	Method SetValue(value:Int)
		m_value = value
	End Method
	
	Rem
		bbdoc: Get the m_value of the IntegerMessage.
		returns: The m_value of this IntegerMessage.
	End Rem
	Method GetValue:Int()
		Return m_value
	End Method
	
	Rem
		bbdoc: Serialize the IntegerMessage to a Stream.
		returns: Nothing.
	End Rem
	Method Serialize(stream:TStream)
		Super.Serialize(stream)
		stream.WriteInt(m_value)
	End Method
	
	Rem
		bbdoc: Deserialize the IntegerMessage from a Stream.
		returns: Nothing.
	End Rem
	Method DeSerialize(stream:TStream, readid:Int = True)
		Super.DeSerialize(stream, readid)
		m_value = stream.ReadInt()
	End Method
	
End Type

Rem
	bbdoc: The LongMessage type.
End Rem
Type TLongMessage Extends TNetMessage
	
	Field m_value:Long
	
	Rem
		bbdoc: Create a new LongMessage with the m_value given.
		returns: The new LongMessage (itself).
	End Rem
	Method Create:TLongMessage(value:Long)
		_init(TNetMessage.MSGID_BASE + 3)
		SetValue(value)
		Return Self
	End Method
	
	Rem
		bbdoc: Set the m_value for the LongMessage.
		returns: Nothing.
	End Rem
	Method SetValue(value:Long)
		m_value = value
	End Method
	
	Rem
		bbdoc: Get the m_value of the LongMessage.
		returns: The m_value of this LongMessage.
	End Rem
	Method GetValue:Long()
		Return m_value
	End Method
	
	Rem
		bbdoc: Serialize the LongMessage to a Stream.
		returns: Nothing.
	End Rem
	Method Serialize(stream:TStream)
		Super.Serialize(stream)
		stream.WriteLong(m_value)
	End Method
	
	Rem
		bbdoc: Deserialize the LongMessage from a Stream.
		returns: Nothing.
	End Rem
	Method DeSerialize(stream:TStream, readid:Int = True)
		Super.DeSerialize(stream, readid)
		m_value = stream.ReadLong()
	End Method
	
End Type

Rem
	bbdoc: The FloatMessage type.
End Rem
Type TFloatMessage Extends TNetMessage
	
	Field m_value:Float
	
	Rem
		bbdoc: Create a new FloatMessage with the m_value given.
		returns: The new FloatMessage (itself).
	End Rem
	Method Create:TFloatMessage(value:Float)
		_init(TNetMessage.MSGID_BASE + 4)
		SetValue(value)
		Return Self
	End Method
	
	Rem
		bbdoc: Set the m_value for the FloatMessage.
		returns: Nothing.
	End Rem
	Method SetValue(value:Float)
		m_value = value
	End Method
	
	Rem
		bbdoc: Get the m_value of the FloatMessage.
		returns: The m_value of this FloatMessage.
	End Rem
	Method GetValue:Float()
		Return m_value
	End Method
	
	Rem
		bbdoc: Serialize the FloatMessage to a Stream.
		returns: Nothing.
	End Rem
	Method Serialize(stream:TStream)
		Super.Serialize(stream)
		stream.WriteFloat(m_value)
	End Method
	
	Rem
		bbdoc: Deserialize the FloatMessage from a Stream.
		returns: Nothing.
	End Rem
	Method DeSerialize(stream:TStream, readid:Int = True)
		Super.DeSerialize(stream, readid)
		m_value = stream.ReadFloat()
	End Method
	
End Type

Rem
	bbdoc: The DoubleMessage type.
End Rem
Type TDoubleMessage Extends TNetMessage
	
	Field m_value:Double
	
	Rem
		bbdoc: Create a new DoubleMessage with the m_value given.
		returns: The new DoubleMessage (itself).
	End Rem
	Method Create:TDoubleMessage(value:Double)
		_init(TNetMessage.MSGID_BASE + 5)
		SetValue(value)
		Return Self
	End Method
	
	Rem
		bbdoc: Set the m_value for the DoubleMessage.
		returns: Nothing.
	End Rem
	Method SetValue(value:Double)
		m_value = value
	End Method
	
	Rem
		bbdoc: Get the m_value of the DoubleMessage.
		returns: The m_value of this DoubleMessage.
	End Rem
	Method GetValue:Double()
		Return m_value
	End Method
	
	Rem
		bbdoc: Serialize the DoubleMessage to a Stream.
		returns: Nothing.
	End Rem
	Method Serialize(stream:TStream)
		Super.Serialize(stream)
		stream.WriteDouble(m_value)
	End Method
	
	Rem
		bbdoc: Deserialize the DoubleMessage from a Stream.
		returns: Nothing.
	End Rem
	Method DeSerialize(stream:TStream, readid:Int = True)
		Super.DeSerialize(stream, readid)
		m_value = stream.ReadDouble()
	End Method
	
End Type 

Rem
	bbdoc: The StringMessage type.
End Rem
Type TStringMessage Extends TNetMessage
	
	Field m_value:String
	
	Rem
		bbdoc: Create a new StringMessage with the m_value given.
		returns: The new StringMessage (itself).
	End Rem
	Method Create:TStringMessage(value:String)
		_init(TNetMessage.MSGID_BASE + 6)
		SetValue(value)
		Return Self
	End Method
	
	Rem
		bbdoc: Set the m_value for the StringMessage.
		returns: Nothing.
	End Rem
	Method SetValue(value:String)
		m_value = value
	End Method
	
	Rem
		bbdoc: Get the m_value of the StringMessage.
		returns: The m_value of this StringMessage.
	End Rem
	Method GetValue:String()
		Return m_value
	End Method
	
	Rem
		bbdoc: Serialize the StringMessage to a Stream.
		returns: Nothing.
	End Rem
	Method Serialize(stream:TStream)
		Super.Serialize(stream)
		WriteLString(stream, m_value)
	End Method
	
	Rem
		bbdoc: Deserialize the StringMessage from a Stream.
		returns: Nothing.
	End Rem
	Method DeSerialize(stream:TStream, readid:Int = True)
		Super.DeSerialize(stream, readid)
		m_value = ReadLString(stream)
	End Method
	
End Type

