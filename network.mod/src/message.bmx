
Rem
Copyright (c) 2010 Tim Howard

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
End Rem

Rem
	bbdoc: duct generic net message.
	about: This is an abstract type, you must extend it.
End Rem
Type dNetMessage Abstract
	
	Const MSGID_BASE:Byte = 1
	
	Field m_id:Int
	
	Rem
		bbdoc: Initiate the message with the given id.
		returns: Nothing.
	End Rem
	Method _init(id:Int)
		SetID(id)
	End Method
	
'#region Field accessors
	
	Rem
		bbdoc: Set the message's id (should never change after first set).
		returns: Nothing.
	End Rem
	Method SetID(id:Int)
		m_id = id
	End Method
	
	Rem
		bbdoc: Get the message's id.
		returns: The message's id.
	End Rem
	Method GetID:Int()
		Return m_id
	End Method
	
'#end region Field accessors
	
'#region Data handling
	
	Rem
		bbdoc: Write the id for the message to a stream.
		returns: Nothing.
	End Rem
	Method WriteID(stream:TStream)
		stream.WriteByte(Byte(m_id))
	End Method
	
	Rem
		bbdoc: Read the id for the message from a stream.
		returns: Expected to be the id for this message (as long as the data is intact and everything is ordered the same).
	End Rem
	Method ReadID:Int(stream:TStream)
		Return Int(stream.ReadByte())
	End Method
	
	Rem
		bbdoc: Serialize the message to the given stream.
		returns: Nothing.
		about: This method should be implemented in extending types.
	End Rem
	Method Serialize(stream:TStream)
		WriteID(stream)
	End Method
	
	Rem
		bbdoc: Deserialize the message from the given stream.
		returns: Nothing.
		about: This method should be implemented in extending types.
	End Rem
	Method Deserialize(stream:TStream, _readid:Int = True)
		If _readid
			m_id = ReadID(stream)
		End If
	End Method
	
'#end region Data handling
	
End Type

Rem
	bbdoc: duct #dNetMessage map.
End Rem
Type dNetMessageMap
	
	Field m_map:dIntMap
	
	Method New()
		m_map = New dIntMap
	End Method
	
	Rem
		bbdoc: Create a new message map.
		returns: Itself.
	End Rem
	Method Create:dNetMessageMap()
		Return Self
	End Method
	
	Rem
		bbdoc: Insert a message into the map.
		returns: True if the message was inserted, or False if it was unable to be inserted.
	End Rem
	Method InsertMessage:Int(msg:dNetMessage)
		If msg
			m_map.Insert(msg.m_id, msg)
			Return True
		Else
			Return False
		End If
	End Method
	
	Rem
		bbdoc: Get a message from the map with the given ID.
		returns: The message with the ID given, or Null if the map does not contain a message with the given ID.
	End Rem
	Method GetMessageWithID:dNetMessage(msgid:Int)
		Return dNetMessage(m_map.ForKey(msgid))
	End Method
	
End Type

