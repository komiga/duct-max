
' Copyright (c) 2009 Tim Howard
' 
' Permission is hereby granted, free of charge, to any person obtaining a copy
' of this software and associated documentation files (the "Software"), to deal
' in the Software without restriction, including without limitation the rights
' to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
' copies of the Software, and to permit persons to whom the Software is
' furnished to do so, subject to the following conditions:
' 
' The above copyright notice and this permission notice shall be included in
' all copies or substantial portions of the Software.
' 
' THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
' IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
' FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
' AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
' LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
' OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
' THE SOFTWARE.
' 

' 
' scriptnode.bmx (Contains: TSNode, )
' 
' 

Rem
	bbdoc: The TSNode (script node) type.
End Rem
Type TSNode
	
	Field name:String
	
	Field parent:TSNode
	Field children:TList
	
		Method New()
			
			children = New TList
			
		End Method
		
		Rem
			bbdoc: Create a node.
			returns: The created node.
		End Rem
		Method Create:TSNode(_name:String, _parent:TSNode = Null)
			
			SetName(_name)
			SetParent(_parent)
			
			Return Self
			
		End Method
		
		Rem
			bbdoc: Set the node's parent.
			returns: Nothing.
		End Rem
		Method SetParent(_parent:TSNode)
			
			parent = _parent
			
		End Method
		
		Rem
			bbdoc: Get the node's parent.
			returns: The node's parent; if the return value is Null then the node is most likely a root node.
		End Rem
		Method GetParent:TSNode()
			
			Return Parent
			
		End Method
		
		Rem
			bbdoc: Set the name of the node.
			returns: Nothing.
		End Rem
		Method SetName(_name:String)
			
			name = _name
			
		End Method
		
		Rem
			bbdoc: Get the name of the node.
			returns: The name of the node.
		End Rem
		Method GetName:String()
			
			Return name
			
		End Method
		
		Rem
			bbdoc: Add a node to the node.
			returns: Nothing.
		End Rem
		Method AddNode(node:TSNode)
			
			If node <> Null
				
				children.AddLast(node)
				
			End If
			
		End Method
		
		Rem
			bbdoc: Get the children.
			returns: The children (identifiers and nodes) of this node.
		End Rem
		Method GetChildren:TList()
			
			Return children
			
		End Method
		
		Rem
			bbdoc: Get a node by its name.
			returns: A TSNode or Null if it was not found.
			about: By default case sensitivity is off.
		End Rem
		Method GetNodeByName:TSNode(_name:String, casesens:Int = False)
		  Local _nname:String
			
			If casesens = False Then _name = _name.ToLower()
			
			For Local node:TSNode = EachIn children
				
				_nname = node.GetName()
				If casesens = False Then _nname = _nname.ToLower()
				
				If _name = _nname
					
					Return node
					
				End If
				
			Next
			
		   Return Null
		   
		End Method
		
		Rem
			bbdoc: Add an identifier to the node.
			returns: Nothing.
		End Rem
		Method AddIdentifier(iden:TIdentifier)
			
			If iden <> Null
				
				children.AddLast(iden)
				
			End If
			
		End Method
		
		Rem
			bbdoc: Get an identifier by its name.
			returns: A TIdentifier or Null if it was not found.
			about: By default case sensitivity is off.
		End Rem
		Method GetIdentifierByName:TIdentifier(_name:String, casesens:Int = False)
		  Local _nname:String
			
			If casesens = False Then _name = _name.ToLower()
			
			For Local iden:TIdentifier = EachIn children
				
				_nname = iden.GetName()
				If casesens = False Then _nname = _nname.ToLower()
				
				If _name = _nname
					
					Return iden
					
				End If
				
			Next
			
		   Return Null
		   
		End Method
		
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
				
				If GetParent() <> Null
					
					If GetName() <> ""
						stream.WriteLine(tablevel + GetName() + " {")
					Else
						stream.WriteLine(tablevel + "{")
					End If
					
					tableveld = tablevel + "~t"
					
				Else
					
					tableveld = tablevel
					stream.WriteLine("")
					
				End If
				
				For Local child:Object = EachIn GetChildren()
					
					If TIdentifier(child)
						
						stream.WriteLine(tableveld + TIdentifier(child).ConvToString())
						
					Else If TSNode(child)
						
						stream.WriteLine(tableveld)
						TSNode(child).WriteToStream(stream, tableveld)
						'stream.WriteLine("")
						
					End If
					
				Next
				
				If GetParent() <> Null
					stream.WriteLine(tablevel + "}")
				End If
				
				Return True
				
			End If
			
		   Return False
		   
			Rem
			Function RemoveTabLevel:String(_tablevel:String)
				
				If _tablevel.Length = 1
					Return "")
				Else
					Return _tablevel[.._tablevel.Length - 2])
				End If
				
			End Function
			End Rem
			
		End Method
		
		Rem
			bbdoc: Load a script from a stream.
			returns: The root node of the script.
			about: This function does not close the stream; Exceptions are currently thrown as strings.
		End Rem
		Function LoadScriptFromStream:TSNode(stream:TStream)
		  Local cline:String', cln:Int
		  Local cchar:Int, cstate:Int = cs_UNK, nstate:Int = cn_UNK
		  Local lcount:Int
		  
		  Local node:TSNode = New TSNode, iden:TIdentifier
		  Local d1:String
				
				If stream <> Null
					
					While Not stream.Eof()
						
					  cline = stream.ReadLine() ; lcount:+1
						
						For Local ci:Int = 0 To cline.Length - 1
							
						  cchar = cline[ci]
							
							If cchar = 32 Or cchar = 9 'whitespace
								
								If cstate = cs_READINGUNKNOWN
									
									If iden <> Null And d1 <> Null
										
										If d1 <> "/>>"
											iden.AddValue(RawToVariable(d1))
											d1 = ""
										Else
											'cstate = cs_NEWVALUE
											Exit
										End If
										
										cstate = cs_NEWVALUE
										
									End If
									
								Else If cstate = cs_READINGNAME
									
									iden = New TIdentifier.Create()
									iden.SetName(d1)
									
									d1 = ""
									
									cstate = cs_NEWVALUE
									
								Else If cstate = cs_OPENQUOTE
									
									d1:+Chr(cchar)
									
								'Else If cstate = cs_NODEWAIT
								'	
								'	'Identifier after brace on the same line
								'	
								'	
								Else
									
									cstate = cs_NEWVALUE
									
								End If
								
							Else If cchar = 34 'quote
								
								If cstate = cs_READINGNAME Or cstate = cs_READINGUNKNOWN
									
									Throw("Malformed line: encountered quote whilst reading value; Line: " + lcount)
									
								Else If cstate = cs_OPENQUOTE
									
									If iden <> Null
										
										iden.AddValue(RawToVariable(d1, 1)) 'Explicitly add as a string variable
										
										'Reset dump
										d1 = ""
										
										cstate = cs_ENDQUOTE
										
									Else
										
										Throw("Malformed line: node/attribute name could not be quoted; Line: " + lcount)
										
									End If
									
								Else If cstate = cs_ENDQUOTE
									
									Throw("Malformed line: values should be separated by whitespace; Line: " + lcount)
									
								Else
									
									cstate = cs_OPENQUOTE
									
								End If
								
							Else If cchar = 39 'single-quote character (')
								
								If cstate = cs_OPENQUOTE
									
									d1:+Chr(cchar)
									
								Else
									
									' Is a comment.. exit loop
									Exit
									
								End If
								
							Else If cchar = 123 'open brace
								
								If cstate = cs_OPENQUOTE
									
									d1:+Chr(cchar)
									
								Else
								  
								  Local last:TSNode = node
									
									node = New TSNode.Create("", Last) 'Create as a nameless node
									
									last.AddNode(node)
									
									'Check if it has been named
									If iden <> Null
										
										node.SetName(iden.GetName())
										
										If iden.GetValueCount() > 0
											
											'DebugLog "TSNode.LoadScript(); Identifier contains values when it should not (reading new node)"
											DebugLog("iden.GetValueCount() = " + iden.GetValueCount())
											Throw("The name of a node cannot contain values; Line: " + lcount)
											
										End If
										
										iden = Null
										
									End If
									
									'DebugLog(node.GetName() + " ; " + Last.GetName())
									
									nstate = cn_OPENBRACE
									cstate = cs_UNK
									
								End If
								
							Else If cchar = 125 'close brace
								
								If cstate = cs_OPENQUOTE
									
									d1:+Chr(cchar)
									
								Else  
								  Local last:TSNode = node
									
									node = node.GetParent()
									
									If node <> Null
										
										If nstate = cn_OPENBRACE
											
											If iden = Null
												iden = New TIdentifier.Create()
												iden.SetName(d1)
											Else
												If d1 <> Null And d1 <> "/>>"
													iden.AddValue(RawToVariable(d1))
												End If
											End If
											If d1 <> "/>>" Then d1 = ""
											last.AddIdentifier(iden)
											iden = Null
								
											DebugLog("TSNode.LoadScriptFromStream(); Attribute passed: " + cstate)
											cstate = cs_UNK
											
										End If
										
									Else
										
										Throw("Encountered end node without beginning node; on line: " + lcount)
										
									End If
									
									nstate = cn_CLOSEBRACE
									
								End If
								
							Else
								
								If cstate = cs_NEWVALUE Or cstate = cs_UNK
									
									d1:+Chr(cchar)
									
									If iden <> Null 'Have we already been reading the attribute?
										
										cstate = cs_READINGUNKNOWN
										
									Else 'This must be the node/attribute name..
										
										cstate = cs_READINGNAME
										
									End If
									
								Else If cstate = cs_READINGUNKNOWN Or cs_READINGNAME Or cs_OPENQUOTE
									
									d1:+Chr(cchar)
									
								'Else If cstate = cs_UNK
									
								'	d1:+Chr(cchar)
									
								'	cstate = cs_READINGNAME
									
								End If
								
							End If
							
						Next
						
						If cstate = cs_READINGNAME
							
							'iden = New TIdentifier.Create()
							'iden.SetName(d1)
							'd1 = ""
							
						Else If cstate = cs_READINGUNKNOWN
							
							If iden <> Null And d1 <> "/>>"
								
								iden.AddValue(RawToVariable(d1))
								
								d1 = ""
								
							End If
							
						Else If cstate = cs_OPENQUOTE
							
							'The quote was not ended before the next line!
							Throw("Malformed line: expected end quote before next line; Line: " + lcount)
							
						End If
						
						'The identifier cannot continue onto the next line
						If iden <> Null
							
							If d1 = "/>>"
								
								'DebugLog("TSNode.LoadScriptFromStream(); Identifier '" + iden.GetName() + "' is extending onto the next line")
								d1 = ""
								cstate = cs_NEWVALUE
								
							Else
								
								node.AddIdentifier(iden)
								iden = Null
								
								DebugLog("TSNode.LoadScriptFromStream(); Attribute passed: " + cstate)
								cstate = cs_UNK
								
							End If
							
						Else
							
							cstate = cs_UNK
							
						End If
						
					Wend
					
					'stream.Close()
					
					If node.GetParent() <> Null
						
						Throw("Node '" + node.GetName() + "' has not been closed properly")
						
					Else
						
						Return node
						
					End If
					
				Else
					
					Throw("Error reading script from stream")
					
				End If
				
				
				Function RawToVariable:TVariable(vraw:String, etype:Int = 0)
				  Local variable:TVariable
					
					'If etype = 1 'Explicitly a string
					'	
					'	variable = TVariable(New TStringVariable.Create("", vraw))
					'	
					If etype = 0 'Determine the value's type (must be either integer, double, or a string with no spaces)
					  Local i:Int
						
						'ASCII '0' to '9' = 48-57; '-' = 45, '+' = 43; and '.' = 46
						For i = 0 To vraw.Length - 1
						  Local c:Int
							
							c = vraw[i]
							
							If c >= 48 And c <= 57 Or c = 43 Or c = 45
								
								If etype = 0 'Leave double and string alone
									
									etype = 2 'Integer so far..
									
								End If
								
							Else If c = 46
								
								If etype = 2 'Already declared an integer?
									
									etype = 3
									
								End If
								
							Else 'If the character is not numerical there is nothing else to deduce and the value is a string
								
								etype = 4
								Exit
								
							End If
							
						Next
						
						Select etype
							Case 2 'Integer
								variable = TVariable(New TIntVariable.Create("", Int(vraw)))
								
							Case 3 'Double/Float
								variable = TVariable(New TFloatVariable.Create("", Float(vraw)))
								
							'Case 4 'String - non-explicit
							'  Local evaltest:Int = vraw.ToLower().Find("/eval::")
							'	
							'	If evaltest >= 0
							'		variable = TVariable(New TEvalVariable.Create("", vraw[evaltest + 7..]))
							'	Else
							'		variable = TVariable(New TStringVariable.Create("", vraw))
							'	End If
								
						End Select
						
					End If
					
					If etype = 1 Or etype = 4
					  Local evaltest:Int = vraw.ToLower().Find("/eval::")
						
						If evaltest >= 0
							variable = TVariable(New TEvalVariable.Create("", vraw[evaltest + 7..]))
						Else
							variable = TVariable(New TStringVariable.Create("", vraw))
						End If
						
					End If
					
					DebugLog("TSNode.LoadScriptFromStream().RawToVariable(); vraw = ~q" + vraw + "~q \" + etype)
					
					If variable = Null Then DebugLog("TSNode.LoadScriptFromStream().RawToVariable(); Unknown error, 'variable' is Null")
					
					Return variable
					
				End Function
			
		End Function
		
		Rem
			bbdoc: Load a script from a file.
			returns: The root node of the script or null if it failed to open the file.
			about: This function calls #LoadScriptFromStream, which may throw exceptions (as strings).
		End Rem
		Function LoadScriptFromFile:TSNode(url:String)
		  Local stream:TStream, node:TSNode
			
			If FileType(url) = FILETYPE_FILE
				stream = ReadStream(url)
				
				If stream <> Null
					
					node = LoadScriptFromStream(stream)
					stream.Close()
					
					Return node
					
				End If
				
			End If
			
			Return Null
			
		End Function
		
		Rem
			bbdoc: Try a TVariable for boolean conversion.
			returns: True if the variable was able to convert into '1', False if the variable was able to convert to '0' or -1 if the variable could not be converted.
			about: Tries integers (i.e. only if they are 1/0) and strings ("on"/"off", "true"/"false", "one"/"zero", "1"/"0" - not case sensitive); floats are not tried.
		End Rem
		Function ConvertVariableToBool:Int(variable:TVariable)
			
			If TIntVariable(variable)
			  Local val:Int = TIntVariable(variable).Get()
				
				If val = False Or val = True Then Return val
				
			Else If TStringVariable(variable)
			  Local val:String = TStringVariable(variable).Get().ToLower()
				
				Select val
					Case "true", "on", "1"
						Return True
					
					Case "false", "off", "0"
						Return False
						
				End Select
				
			End If
			
		   Return - 1
		   
		End Function
		
End Type


Private
Const cs_UNK:Int = 0
Const cs_OPENQUOTE:Int = 1, cs_ENDQUOTE:Int = 2
Const cs_NEWVALUE:Int = 3
Const cs_BEGINCOMMENT:Int = 4, cs_FINISHCOMMENT:Int = 5
Const cs_READINGNAME:Int = 6, cs_READINGUNKNOWN:Int = 7
'Const cs_NODEWAIT:Int = 8


Const cn_UNK:Int = 0
Const cn_OPENBRACE:Int = 1, cn_CLOSEBRACE:Int = 2
Const cn_EXPECTINGNODE:Int = 3









