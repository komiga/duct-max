
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
	bbdoc: duct C-style script node.
End Rem
Type dSNode
	
	Global m_handler:dSNodeDefaultParserHandler = New dSNodeDefaultParserHandler
	
	Field m_name:String
	Field m_parent:dSNode
	Field m_children:TListEx
	
	Method New()
		m_children = New TListEx
	End Method
	
	Rem
		bbdoc: Create a new SNode.
		returns: The new SNode (itself).
	End Rem
	Method Create:dSNode(name:String, parent:dSNode = Null)
		SetName(name)
		SetParent(parent)
		Return Self
	End Method
	
'#region Field accessors
	
	Rem
		bbdoc: Set the node's parent.
		returns: Nothing.
	End Rem
	Method SetParent(parent:dSNode)
		m_parent = parent
	End Method
	Rem
		bbdoc: Get the node's parent.
		returns: The node's parent; if the return value is Null then the node is most likely a root node.
	End Rem
	Method GetParent:dSNode()
		Return m_parent
	End Method
	
	Rem
		bbdoc: Set the name of the node.
		returns: Nothing.
	End Rem
	Method SetName(name:String)
		m_name = name
	End Method
	Rem
		bbdoc: Get the name of the node.
		returns: The name of the node.
	End Rem
	Method GetName:String()
		Return m_name
	End Method
	
'#end region (Field accessors)
	
'#region Collections
	
	Rem
		bbdoc: Add a SNode to this node.
		returns: Nothing.
		about: The SNode you add shall become a child (it will be re-parented) of this node.
	End Rem
	Method AddNode(node:dSNode)
		If node <> Null
			m_children.AddLast(node)
			node.SetParent(Self)
		End If
	End Method
	
	Rem
		bbdoc: Add an Identifier to the node.
		returns: Nothing.
	End Rem
	Method AddIdentifier(iden:dIdentifier)
		If iden <> Null
			m_children.AddLast(iden)
		End If
	End Method
	
	Rem
		bbdoc: Get the children (SNodes and Identifiers) of this node.
		returns: A list containing the children of the node.
	End Rem
	Method GetChildren:TList()
		Return m_children
	End Method
	
	Rem
		bbdoc: Get a node by its name.
		returns: A dSNode with the name given, or Null if it was not found.
		about: By default case sensitivity is off.
	End Rem
	Method GetNodeByName:dSNode(name:String, casesens:Int = False)
		Local node:dSNode, itername:String
		
		If casesens = False
			name = name.ToLower()
		End If
		For node = EachIn m_children
			itername = node.GetName()
			If casesens = False
				itername = itername.ToLower()
			End If
			If name = itername
				Return node
			End If
		Next
		Return Null
	End Method
	
	Rem
		bbdoc: Get an identifier by its name.
		returns: A dIdentifier with the name given, or Null if it was not found.
		about: By default case sensitivity is off.
	End Rem
	Method GetIdentifierByName:dIdentifier(name:String, casesens:Int = False)
		Local iden:dIdentifier, itername:String
		
		If casesens = False
			name = name.ToLower()
		End If
		For iden = EachIn m_children
			itername = iden.GetName()
			If casesens = False
				itername = itername.ToLower()
			End If
			If name = itername
				Return iden
			End If
		Next
		Return Null
	End Method
	
	Rem
		bbdoc: Get an identifier by the given template.
		returns: A matching dIdentifier, or Null if no matches were found.
	End Rem
	Method GetIdentifierByTemplate:dIdentifier(template:dTemplate)
		Local iden:dIdentifier
		
		For iden = EachIn m_children
			If template.ValidateIdentifier(iden) = True
				Return iden
			End If
		Next
		Return Null
	End Method
	
'#end region (Collections)
	
'#region Data handling
	
	Rem
		bbdoc: Write the node and it's children (child nodes and identifiers) to a file.
		returns: True if completed successfully, or False if an error occured.
		about: This will overwrite an existing file without warning.
	End Rem
	Method WriteToFile:Int(url:String)
		Local outstream:TStream, rv:Int
		
		outstream = WriteStream(url)
		If outstream <> Null
			rv = WriteToStream(outstream)
			outstream.Close()
		End If
		Return rv
	End Method
	
	Rem
		bbdoc: Write the node and it's children (child nodes and identifiers) to a stream.
		returns: True if completed successfully, or False if an error occured.
	End Rem
	Method WriteToStream:Int(stream:TStream, tablevel:String = "")
		If stream <> Null
			Local tableveld:String
			
			If m_parent <> Null
				If m_name <> ""
					If m_name.Contains("~t") = True Or m_name.Contains(" ")
						stream.WriteLine(tablevel + "~q" + m_name + "~q {")
					Else
						stream.WriteLine(tablevel + m_name + " {")
					End If
				Else
					stream.WriteLine(tablevel + "{")
				End If
				tableveld = tablevel + "~t"
			Else
				tableveld = tablevel
				stream.WriteLine("")
			End If
			
			Local child:Object, iden:dIdentifier, node:dSNode
			For child = EachIn m_children
				iden = dIdentifier(child)
				node = dSNode(child)
				If iden <> Null
					stream.WriteLine(tableveld + iden.ConvToString())
				Else If node <> Null
					stream.WriteLine(tableveld)
					node.WriteToStream(stream, tableveld)
					'stream.WriteLine("")
				End If
			Next
			If m_parent <> Null
				stream.WriteLine(tablevel + "}")
			End If
			Return True
		End If
		Return False
		
		Rem
		Function RemoveTabLevel:String(_tablevel:String)
			If _tablevel.Length = 1
				Return ""
			Else
				Return _tablevel[.._tablevel.Length - 2]
			End If
		End Function
		End Rem
	End Method
	
	Rem
		bbdoc: Load a script from a stream/file.
		returns: The root node of the script.
		about: If the given @obj is a stream, it will not be closed.<br/>
		A #dSNodeException might be thrown if an error occurs in parsing.
	End Rem
	Function LoadScriptFromObject:dSNode(obj:Object, encoding:Int = SNPEncoding_UTF8)
		Local root:dSNode = m_handler.ProcessFromObject(obj, encoding)
		Return root
	End Function
	
	Rem
		bbdoc: Load a script from a string containing the source.
		returns: The root node of the script.
		about: A #dSNodeException might be thrown if an error occurs in parsing.
	End Rem
	Function LoadScriptFromString:dSNode(data:String, encoding:Int = SNPEncoding_UTF8)
		Local root:dSNode = m_handler.ProcessFromString(data, encoding)
		Return root
	End Function
	
'#end region (Data handling)
	
	Rem
		bbdoc: Try a dVariable for boolean conversion.
		returns: True if the variable was able to convert into '1', False if the variable was able to convert to '0' or -1 if the variable could not be converted.
		about: Tries integers (i.e. only if they are 1/0) and strings ("on"/"off", "true"/"false", "one"/"zero", "1"/"0" - not case sensitive); floats are not tried.
	End Rem
	Function ConvertVariableToBool:Int(variable:dVariable)
		If dIntVariable(variable)
			Local val:Int = dIntVariable(variable).Get()
			If val = False Or val = True
				Return val
			End If
		Else If dStringVariable(variable)
			Local val:String = dStringVariable(variable).Get().ToLower()
			
			Select val
				Case "true", "on", "1"
					Return True
				Case "false", "off", "0"
					Return False
			End Select
		End If
		Return -1
	End Function
	
End Type
