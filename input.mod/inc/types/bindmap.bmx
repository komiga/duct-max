
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
' bindmap.bmx (Contains: TBindMap, )
' TODO: 
' 

Rem
	bbdoc: The TBindMap type.
EndRem
Type TBindMap Extends TObjectMap
	
		Rem
			bbdoc: Create a bindmap.
			returns: The created bindmap.
			about: NOTE: This method currently does nothing, calling New(TBindMap) is sufficient.
		End Rem
		Method Create:TBindMap()
			
			Return Self
			
		End Method
		
		Rem
			bbdoc: Inserts an Input Identifier into the map.
			returns: @inputiden, for flow purposes (see example code)
			about: The identifier will be inserted using its action as the key.
		End Rem
		Method InsertInputIdentifier:TInputIdentifier(inputiden:TInputIdentifier)
			
			_Insert(inputiden.GetAction().ToLower(), inputiden)
			Return inputiden
			
		End Method
		
		Rem
			bbdoc: Get a InputIdentifier from the map by its action.
			returns: The identifier object, or Null if the identifier was not found.
		End Rem
		Method GetInputIdentifierByAction:TInputIdentifier(action:String)
			
			Return TInputIdentifier(_ValueByKey(action.ToLower()))
			
		End Method
		
		Rem
			bbdoc: Check if a key code is already in the map (check duplicate).
			returns: An input identifier if it was found, and Null if it is not in the map.
			about: If the given input code is INPUT_UNBOUND (zero) then it will be ignored and Null will be returned.
		End Rem
		Method IsInputCodeInMap:TInputIdentifier(_input_code:Int, _input_type:Int)
		  Local iiden:TInputIdentifier
			
			If _input_code <> INPUT_UNBOUND And _input_type <> INPUT_UNBOUND
				For iiden = EachIn _map.Values()
					
					If iiden.GetInputCode() = _input_code And iiden.GetInputType() = _input_type
						
						Return iiden
						
					End If
					
				Next
			End If
			
			Return Null
			
		End Method
		
		Rem
			bbdoc: Update input identifiers in the map from a node.
			returns: Nothing.
			about: This method is not recursive, it will only look within the given node (not searching child nodes, parent node, etc).
			This will not add more input identifiers, it just updates the identifiers currently in the map.
			If an input code conflicts with any given identifier in the node the old identifier will be unbound.
			You should not run into a thrown exception, this method encapsulates and ignores any unidentified input codes or non bind identifiers.
		End Rem
		Method UpdateFromNode(node:TSNode)
		  Local iden:TIdentifier, iiden:TInputIdentifier, miden:TInputIdentifier, ciden:TInputIdentifier
			
			If node <> Null
				
				For iden = EachIn node.GetChildren()
					
					Try
						
						iiden = TInputIdentifier.GetFromIdentifier(iden)
						If iiden <> Null
							
							ciden = GetInputIdentifierByAction(iiden.GetAction())
							If ciden <> Null
								miden = IsInputCodeInMap(iiden.GetInputCode(), iiden.GetInputType())
								
								If ciden <> miden
									If miden <> Null
										miden.UnBind()
									End If
									
									ciden.Bind(iiden.GetInputCode(), iiden.GetInputType())
									
								End If
								
							End If
							
						End If
						
					Catch ex:TBindRecognizeException
						DebugLog("TBindMap.UpdateFromNode(); Exception caught: " + ex.ToString())
					End Try
					
				Next
				
			Else
				
				DebugLog("TBindMap.UpdateFromNode(); Node is Null")
				
			End If
			
		End Method
		
		Rem
			bbdoc: Get a string containing the input identifiers (and their data) from the map.
			returns: A string listing the information.
		End Rem
		Method ReportAsString:String()
		  Local output:String, iiden:TInputIdentifier
			
			For iiden = EachIn _map.Values()
				
				output:+ iiden.GetInputCodeAsString() + " " + iiden.GetInputType() + " " + iiden.GetAction() + "~n"
				
			Next
			
			Return output
			
		End Method
		
End Type






















