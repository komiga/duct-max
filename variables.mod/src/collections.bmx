
Rem
Copyright (c) 2010 plash <plash@komiga.com>

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
	bbdoc: duct identifier (used in parsers, mostly).
End Rem
Type dIdentifier Extends dCollectionVariable
	
	Rem
		bbdoc: Create an identifier.
		returns: Itself.
	End Rem
	Method Create:dIdentifier(name:String = Null, parent:dCollectionVariable = Null, children:TListEx = Null)
		SetName(name)
		SetParent(parent)
		If Not children Then children = New TListEx
		SetChildren(children)
		Return Self
	End Method
	
'#region Data handling
	
	Rem
		bbdoc: Create a copy of the identifier.
		returns: A clone of the identifier.
		about: NOTE: A clone has no parent.
	End Rem
	Method Copy:dIdentifier()
		Local clone:dIdentifier = New dIdentifier.Create(m_name, Null)
		For Local variable:dVariable = EachIn m_children
			clone.AddVariable(variable.Copy())
		Next
		Return clone
	End Method
	
	Rem
		bbdoc: Serialize the variable to a stream.
		returns: Nothing.
		about: @tv tells the method whether it should serialize the TV type for the variable, or to not.<br>
		In this case @name tells the method whether it should serialize the <i><b>children</b></i>'s names (the identifier's name is always read/written to the stream).
	End Rem
	Method Serialize(stream:TStream, tv:Int = True, name:Int = False)
		If tv = True Then stream.WriteByte(TV_IDEN)
		dStreamIO.WriteLString(stream, m_name)
		If m_children = Null
			stream.WriteInt(0)
		Else
			stream.WriteInt(m_children.Count())
			For Local variable:dVariable = EachIn m_children
				variable.Serialize(stream, True, name)
			Next
		End If
	End Method
	
	Rem
		bbdoc: Deserialize the variable from a stream.
		returns: The deserialized variable.
		about: @tv tells the method whether it should deserialize the TV type for the variable, or to not.<br>
		In this case @name tells the method whether it should serialize the <i><b>children</b></i>'s names (the identifier's name is always read/written to the stream).
	End Rem
	Method Deserialize:dIdentifier(stream:TStream, tv:Int = True, name:Int = False)
		If tv = True Then stream.ReadByte()
		m_name = dStreamIO.ReadLString(stream)
		Local count:Int = stream.ReadInt()
		If count > 0
			For Local n:Int = 0 Until count
				AddVariable(DeserializeUniversal(stream, name))
			Next
		End If
		Return Self
	End Method
	
'#end region Data handling
	
	Rem
		bbdoc: Get the type of this variable.
		returns: The type of this variable ("identifier").
	End Rem
	Function ReportType:String()
		Return "identifier"
	End Function
	
	Rem
		bbdoc: Get the TV type of this variable.
		returns: The TV_* type of this variable (TV_IDEN).
	End Rem
	Function GetTVType:Int()
		Return TV_IDEN
	End Function
	
End Type

Rem
	bbdoc: duct generic node.
	about: A node can hold other nodes or dVariables.
End Rem
Type dNode Extends dCollectionVariable
	
	Method New()
		SetChildren(New TListEx)
	End Method
	
	Rem
		bbdoc: Create a dNode.
		returns: Itself.
	End Rem
	Method Create:dNode(name:String = Null, parent:dCollectionVariable = Null)
		SetName(name)
		SetParent(parent)
		Return Self
	End Method
	
'#region Data handling
	
	Rem
		bbdoc: Create a copy of the node.
		returns: A clone of the node.
		about: NOTE: A clone has no parent.
	End Rem
	Method Copy:dNode()
		Local clone:dNode = New dNode.Create(m_name, m_parent)
		For Local variable:dVariable = EachIn m_children
			clone.AddVariable(variable.Copy())
		Next
		Return clone
	End Method
	
	Rem
		bbdoc: Serialize the variable to a stream.
		returns: Nothing.
		about: @tv tells the method whether it should serialize the TV type for the variable, or to not.<br>
		In this case @name tells the method whether it should deserialize the <i><b>children</b></i>'s names (the node's name is always read/written to the stream).
	End Rem
	Method Serialize(stream:TStream, tv:Int = True, name:Int = False)
		If tv = True Then stream.WriteByte(TV_NODE)
		dStreamIO.WriteLString(stream, m_name)
		stream.WriteInt(m_children.Count())
		For Local variable:dVariable = EachIn m_children
			variable.Serialize(stream, True, name)
		Next
	End Method
	
	Rem
		bbdoc: Deserialize the variable from a stream.
		returns: The deserialized variable.
		about: @tv tells the method whether it should deserialize the TV type for the variable, or to not.<br>
		In this case @name tells the method whether it should deserialize the <i><b>children</b></i>'s names (the node's name is always read/written to the stream).
	End Rem
	Method Deserialize:dNode(stream:TStream, tv:Int = True, name:Int = False)
		If tv = True Then stream.ReadByte()
		m_name = dStreamIO.ReadLString(stream)
		Local count:Int = stream.ReadInt()
		If count > 0
			For Local n:Int = 0 Until count
				AddVariable(DeserializeUniversal(stream, name), True)
			Next
		End If
		Return Self
	End Method
	
'#end region Data handling
	
	Rem
		bbdoc: Get the type of this variable.
		returns: The type of this variable ("node").
	End Rem
	Function ReportType:String()
		Return "node"
	End Function
	
	Rem
		bbdoc: Get the TV type of this variable.
		returns: The TV_* type of this variable (TV_NODE).
	End Rem
	Function GetTVType:Int()
		Return TV_NODE
	End Function
	
End Type

