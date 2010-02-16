
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
	
	message.bmx (Contains: TNetMessage, TNetMessageMap, )
	
End Rem

Rem
	bbdoc: The NetMessage type.
End Rem
Type TNetMessage
	
	Const MSGID_BASE:Byte = 1
	'Const MSGID_FREESTART:Byte = 10
	
	Field m_id:Int
	
	Method _init(id:Int)
		SetID(id)
	End Method
	
'#region Field accessors
	
	Rem
		bbdoc: Set the id for the Message.
		returns: Nothing.
	End Rem
	Method SetID(id:Int)
		m_id = id
	End Method
	
	Rem
		bbdoc: Get the message id for the Message.
		returns: The message id for this Message.
	End Rem
	Method GetID:Int()
		Return m_id
	End Method
	
'#end region (Field accessors)
	
'#region Data handling
	
	Rem
		bbdoc: Write the id for the Message to a Stream.
		returns: Nothing.
	End Rem
	Method WriteID(stream:TStream)
		stream.WriteByte(Byte(m_id))
	End Method
	
	Rem
		bbdoc: Read the id for the Message from a Stream.
		returns: Expected to be the id for this Message (as long as the data is intact and everything is ordered the same).
	End Rem
	Method ReadID:Int(stream:TStream)
		Return Int(stream.ReadByte())
	End Method
	
	Rem
		bbdoc: Serialize the Message to a Stream.
		returns: Nothing.
		about: This method should be implemented in extending types.
	End Rem
	Method Serialize(stream:TStream)
		WriteID(stream)
	End Method
	
	Rem
		bbdoc: Deserialize the Message from a Stream.
		returns: Nothing.
		about: This method should be implemented in extending types.
	End Rem
	Method DeSerialize(stream:TStream, readid:Int = True)
		If readid = True
			m_id = ReadID(stream)
		End If
	End Method
	
'#end region (Data handling)
	
End Type

Rem
	bbdoc: The NetMessageMap type.
End Rem
Type TNetMessageMap Extends TObjectMap
	
	Rem
		bbdoc: Create a new NetMessageMap.
		returns: The new NetMessageMap (itself).
	End Rem
	Method Create:TNetMessageMap()
		Return Self
	End Method
	
	Rem
		bbdoc: Insert a Message into the map.
		returns: True if the Message was inserted, or False if it was unable to be inserted.
	End Rem
	Method InsertMessage(msg:TNetMessage)
		_Insert(String(msg.id), msg)
	End Method
	
	Rem
		bbdoc: Get a Message from the map by the ID given.
		returns: The Message with the ID given, or Null if the map does not contain a Message for the given ID.
	End Rem
	Method GetMessageByID:TNetMessage(msgid:Int)
		Return TNetMessage(_ValueByKey(String(msgid)))
	End Method
	
End Type

