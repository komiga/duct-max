
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
	
	message.bmx (Contains: TMessage, TMessageMap, )
	
End Rem

Rem
	bbdoc: The Message type.
End Rem
Type TMessage
	
	Const MSGID_BASE:Byte = 1
	'Const MSGID_FREESTART:Byte = 10
	
	Field id:Byte
	
		Method _init(_id:Byte)
			
			SetID(_id)
			
		End Method
		
		Rem
			bbdoc: Set the id for the Message.
			returns: Nothing.
		End Rem
		Method SetID(_id:Byte)
			
			id = _id
			
		End Method
		
		Rem
			bbdoc: Get the message id for the Message.
			returns: The message id for this Message.
		End Rem
		Method GetID:Byte()
			
			Return id
			
		End Method
		
		Rem
			bbdoc: Write the id for the Message to a Stream.
			returns: Nothing.
		End Rem
		Method WriteID(stream:TStream)
			
			stream.WriteByte(id)
			
		End Method
		
		Rem
			bbdoc: Read the id for the Message from a Stream.
			returns: Expected to be the id for this Message (as long as the data is intact and everything is ordered the same).
		End Rem
		Method ReadID:Byte(stream:TStream)
			
			Return stream.ReadByte()
			
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
		Method DeSerialize(stream:TStream, _readid:Int = True)
			
			If _readid = True
				
				ReadID(stream)
				
			End If
			
		End Method
		
End Type


Rem
	bbdoc: The MessageMap type.
End Rem
Type TMessageMap Extends TObjectMap
		
		Rem
			bbdoc: Create a new MessageMap.
			returns: The new MessageMap (itself).
		End Rem
		Method Create:TMessageMap()
			
			Return Self
			
		End Method
		
		Rem
			bbdoc: Insert a Message into the map.
			returns: True if the Message was inserted, or False if it was unable to be inserted.
		End Rem
		Method InsertMessage(_msg:TMessage)
			
			_Insert(String(_msg.id), _msg)
			
		End Method
		
		Rem
			bbdoc: Get a Message from the map by the ID given.
			returns: The Message with the ID given, or Null if the map does not contain a Message for the given ID.
		End Rem
		Method GetMessageByID:TMessage(_msg_id:Byte)
			
			Return TMessage(_ValueByKey(String(_msg_id)))
			
		End Method
		
End Type










































