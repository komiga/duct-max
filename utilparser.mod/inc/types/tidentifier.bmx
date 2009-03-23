
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
' tidentifier.bmx (Contains: TIdentifier, )
' 
' 

Rem
	bbdoc: The TIdentifier type.
	about: This type holds values for a variable, or 'identifier', which could be read (using internals).
	Something like this: 'identifier "string value" 9.5340 124'
End Rem
Type TIdentifier Extends TVariable
	
	Field values:TList
	
		Method New()
			
			'values = New TVariable[1]
			
		End Method
		
		Rem
			bbdoc: Create (or 'initiate') a TIdentifier.
			returns: The created TIdentfier.
		End Rem
		Method Create:TIdentifier()
			
			values = New TList
			
			Return Self
			
		End Method
		
		Rem
			bbdoc: Create (or 'initiate') a TIdentifier and fill its information.
			returns: The created TIdentfier.
			about: If the @_values parameter is Null a new list will be created.
		End Rem
		Method CreateByData:TIdentifier(_name:String, _values:TList = Null)
			
			name = _name
			
			If values = Null Then values = New TList Else values = _values
			
			Return Self
			
		End Method
		
		Rem
			bbdoc: Set the identifier's values.
			returns: Nothing.
		End Rem
		Method SetValues(_values:TList)
			
			values = _values
			
		End Method
		
		Rem
			bbdoc: Get the identifier's values.
			returns: An array of the identifier's values.
		End Rem
		Method GetValues:TList()
			
			Return values
			
		End Method
		
		Rem
			bbdoc: Get a value at an index.
			returns: The value in the identifier's list at the given index, or Null if it could not be retrieved.
			about: The index is zero-based.
		End Rem
		Method GetValueAtIndex:TVariable(index:Int)
			
			If values <> Null And index > - 1 And index < values.Count()
				
				Return TVariable(values.ValueAtIndex(index))
				
			End If
			
			Return Null
			
		End Method
		
		Rem
			bbdoc: Get the number of values.
			returns: The number of values the identifier contains.
		End Rem
		Method GetValueCount:Int()
			
			If values <> Null
				
				Return values.Count()
				
			Else
				
				Return 0
				
			End If
			
		End Method
		
		Rem
			bbdoc: Add a value to the identifier.
			returns: True for success, or False for failure.
			about: Adds a value to the identifier.
		End Rem
		Method AddValue:Int(_value:TVariable)
			
			If values <> Null And _value <> Null
				
				values.AddLast(_value)
				
				Return True
				
			Else
				
				Return False
				
			End If
				
		End Method
		
		Rem
			bbdoc: Convert the identifier to a string.
			returns: A string representation of the identifier.
		End Rem
		Method ConvToString:String()
			Local op:String = name + " "
			
			For Local variable:TVariable = EachIn values
				
				op:+variable.ConvToString() + " "
				
			Next
			
			op = op[..op.Length - 1]
			
		   Return op
		   
		End Method
		
		Rem
			bbdoc: Get the identifier as a string.
			returns: The identifier contents converted to a string.
			about: Here for complete-ness, simply calls #ConvToString.
		End Rem
		Method ValueAsString:String()
			
			Return ConvToString()
			
		End Method
		
End Type


Rem
Private
Const cs_READINGNAME:Int = 1
Const cs_OPENQUOTE:Int = 2, cs_ENDQUOTE:Int = 3
Const cs_NEWVALUE:Int = 4
Const cs_READINGUNKNOWN:Int = 5

Public
End Rem

Rem
	bbdoc: Parses a variable/identifier line.
	returns: A TIdentifier object, or Null if it failed (see information).
	about: This function will throw an error and return Null if the line was malformed.
	The line should NOT contain newline/return characters (it will throw an error if it does).
End Rem
Rem
Function ParseLine:TIdentifier(Line:String)
  Local cchar:Int, cstate:Int = 0, i:Int, riden:Int = 0
  Local v:String, n:String, stack:TVariable[1]
	
	For i = 0 To Line.Length - 1
	  cchar = Line[i]
		
		'Check for newline/carriage return
		If cchar = 10 Or cchar = 13 Then Throw "Malformed line: encountered newline/carriage return (line cannot contain ~~n or ~~r)"
		If cchar = 0 Then DebugLog "ParseLine (unknown): character is null (ascii 0), bad?"
		
		If cchar = 34 'Check for a quote
		
			If cstate = cs_OPENQUOTE 'A quote has just ended, and we were already reading its data
				
				'We were reading data from a string value, we need to end the value and add it to the stack
				AddValue(v, stack, 1) 'Specifically tell it to add as a string
				
				'Reset the value data; for the next value
				v = ""
				
				'Reset the state
				cstate = cs_ENDQUOTE
				
			Else If cstate = cs_READINGNAME 'Quotes are not allowed in the identifier's name
				
				Throw "Malformed line: an identifier name cannot contain quotes [cs_READINGNAME]"
				
			Else If cstate = cs_READINGUNKNOWN
				
				Throw "Malformed line: encountered quote; expected more data or whitespace [cs_READINGUNKNOWN]"
				
			Else If cstate = cs_NEWVALUE 'A quote has just begun
				
				cstate = cs_OPENQUOTE
				
			End If
			
		Else If cchar = 32 Or cchar = 9 'Check for a new value [NOTE: This check will skip over whitespace, unless currently loading a string]
			
			If cstate = cs_READINGNAME
				
				'We have finished reading the identifier name
				riden = 1
				cstate = cs_NEWVALUE
				
			Else If cstate = cs_READINGUNKNOWN
				
				AddValue(v, stack)
				
				'Reset the value data; for the next value
				v = ""
				
				cstate = cs_NEWVALUE
				
			Else If cstate = cs_OPENQUOTE
				
				'We need to do this because of state encapsulation; the Else block below this will never get called
				v:+Chr(cchar)
				
			Else
				
				cstate = cs_NEWVALUE
				
			End If
			
		Else
			
			If cstate = cs_READINGNAME
				
				n:+Chr(cchar)
				
			Else If cstate = cs_OPENQUOTE Or cstate = cs_READINGUNKNOWN
				
				v:+Chr(cchar)
				
			Else If cstate = cs_NEWVALUE
				If riden = 0
					
					cstate = cs_READINGNAME
					n:+Chr(cchar)
					
				Else
					
					cstate = cs_READINGUNKNOWN
					v:+Chr(cchar)
					
				End If
				
			Else If cstate = cs_ENDQUOTE
				
				Throw "Malformed line: encountered '" + Chr(cchar) + "'; expected a whitespace or eol [cs_ENDQUOTE]"
				
			Else If cstate = 0 And riden = 0
				
				cstate = cs_READINGNAME
				n:+Chr(cchar)
				
			End If
			
		End If
		
	Next
	
	DebugLog "ParseLine(); ending: v = ~q" + v + "~q; i = " + i
	
	'We may have exited the loop before the last value could be obtained
	If cstate = cs_OPENQUOTE
		
		Throw "Malformed line: encountered eol; expected quote [cs_OPENQUOTE|END]"
		
	Else If cstate = cs_ENDQUOTE
		
		AddValue(v, stack, 1)
		
	Else If cstate = cs_READINGUNKNOWN
		
		AddValue(v, stack)
		
	End If
	
	'Return the new identifier, removing the last (empty) value in the stack
	Return New TIdentifier.CreateByData(n, stack[0..stack.Length - 2])
	
	
	
	Function AddValue(vraw:String, _stack:TVariable[] Var, etype:Int = 0)
	  Local variable:TVariable
	  
		If etype = 1 'Explicitly a string
			
			variable = TVariable(New TStringVariable.Create("", vraw))
			
		Else 'Determine the value's type (must be either integer, double, or a string with no spaces)
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
					
				Case 4 'String - non-explicit
					variable = TVariable(New TStringVariable.Create("", vraw))
					
			End Select
			
		End If
		
		DebugLog "Parseline.AddValue(); vraw = ~q" + vraw + "~q \" + etype
		
		If variable = Null Then DebugLog "ParseLine.AddValue(); Unknown error, 'variable' is Null"; Return
		
		_stack[_stack.Length - 1] = variable
		_stack = _stack[.._stack.Length + 1]
		
	End Function
	
End Function

End Rem






















