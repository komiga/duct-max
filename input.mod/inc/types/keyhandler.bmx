
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
' keyhandler.bmx (Contains: TBindRecognizeException, TInputIdentifier, )
' TODO: 
' 

Rem
	bbdoc: The TBindRecognizeException type.
	about: Contains and is used to throw errors when TInputIdentifier.GetFromNodeByAction(...)
	fails to recognize the bind identifer (invalid value state, unusable input identifier type, or 
	unrecognized input code).
End Rem
Type TBindRecognizeException
	
	Rem
		bbdoc: Contains the TIdentifier that caused the error.
		about: The identifier this points to should not be modified.
	End Rem
	Field info:String
		
		Method Create:TBindRecognizeException(_info:String)
			
			info = _info
			
			Return Self
			
		End Method
		
		Method ToString:String()
		  Local output:String
			
			output = "Failed to recognize bind identifier, unrecognized input code"
			If info <> Null Then output:+ " ('" + info + "')"
			
			Return output
			
		End Method
		
End Type


Rem
	bbdoc: TInputIdentifier input code/type: Unbound
End Rem
Const INPUT_UNBOUND:Int = 0

Rem
	bbdoc: TInputIdentifier input type: Keyboard
End Rem
Const INPUT_KEYBOARD:Int = 1

Rem
	bbdoc: TInputIdentifier input type: Mouse
End Rem
Const INPUT_MOUSE:Int = 2


Rem
	bbdoc: The TInputIdentifier type.
End Rem
Type TInputIdentifier
	
	Field input_type:Int
	Field input_code:Int ', input_scode:String
	Field action:String
		
		Rem
			bbdoc: The template for bind identifiers.
			about: Definition: bind "INPUTCODE" "INPUTACTION".
		End Rem
		Global BindTemplate:TTemplate = New TTemplate.Create(["bind"], [[TV_STRING, TV_INTEGER], [TV_STRING] ], False, False, Null)
		
		Method New()
			
			input_type = INPUT_UNBOUND
			input_code = INPUT_UNBOUND
			'input_scode = Null
			
		End Method
		
		Rem
			bbdoc: Create an Input Identifier.
			returns: An Input Identifier (itself).
			about: @_input_type can be either INPUT_UNBOUND, INPUT_KEYBOARD or INPUT_MOUSE.~n@_input_code can also be INPUT_UNBOUND (which it is, upon creation).
		End Rem
		Method Create:TInputIdentifier(_input_code:Int, _input_type:Int, _action:String) ', _input_scode:String
			
			Bind(_input_code, _input_type)
			SetAction(_action)
			
		   Return Self
		   
		End Method
		
		Rem
			bbdoc: Unbind the identifier.
			returns: Nothing.
			about: This method will set both the input code and the input type to INPUT_UNBOUND.
		End Rem
		Method UnBind()
			
			Bind(INPUT_UNBOUND, INPUT_UNBOUND)
			
		End Method
		
		Rem
			bbdoc: Bind the identifier.
			returns: Nothing.
		End Rem
		Method Bind(_input_code:Int, _input_type:Int)
			
			SetInputCode(_input_code)
			SetInputType(_input_type)
			'SetInputCodeString(_input_scode)
			
		End Method
		
		Rem
			bbdoc: Get the (down) state of the Input Identifier.
			returns: True key/mouse action is being admitted, Or False If it is Not.
		End Rem
		Method GetStateDown:Int()
		  Local istate:Int
			
			If input_code <> INPUT_UNBOUND
				If input_type = INPUT_KEYBOARD
					
					istate = KeyDown(input_code)
					
				Else If input_type = INPUT_MOUSE
					
					istate = MouseDown(input_code)
					
				End If
			End If
			
			Return istate
			
		End Method
		
		Rem
			bbdoc: Get the (hit) state of the Input Identifier.
			returns: True key/mouse action is being admitted, or False if it is not.
		End Rem
		Method GetStateHit:Int()
		  Local istate:Int
			
			If input_code <> INPUT_UNBOUND
				If input_type = INPUT_KEYBOARD
					
					istate = KeyHit(input_code)
					
				Else If input_type = INPUT_MOUSE
					
					istate = MouseHit(input_code)
					
				End If
			End If
			
			Return istate
			
		End Method
		
		Rem
			bbdoc: Set the input code for the Input Identifier.
			returns: Nothing.
		End Rem
		Method SetInputCode(_input_code:Int)
			
			input_code = _input_code
			
		End Method
		
		Rem
			bbdoc: Get the input code for the Input Identifier.
			returns: The input code for the Input Identifier.
		End Rem
		Method GetInputCode:Int()
			
			Return input_code
			
		End Method
		
		'Rem
		'	bbdoc: Set the input code string (textual identifier) for the Input Identifier.
		'	returns: Nothing.
		'End Rem
		'Method SetInputCodeString(_input_scode:String)
		'	
		'	input_scode = _input_scode
		'	
		'End Method
		'
		Rem
			bbdoc: Get the Input code string (textual identifier) for the Input Identifier.
			returns: The Input code string (textual identifier) for the Input Identifier, or Null ("") if the identifier is unbound.
		End Rem
		Method GetInputCodeAsString:String()
		  Local scode:String
			
			If GetInputCode() <> INPUT_UNBOUND
				If GetInputType() = INPUT_KEYBOARD
					scode = TInputConv.KeyCodeToString(GetInputCode())
				Else If GetInputType() = INPUT_MOUSE
					scode = TInputConv.MouseCodeToString(GetInputCode())
				End If
			End If
			
			Return scode
			
		End Method
		
		Rem
			bbdoc: Set the input type for the Input Identifier (either INPUT_KEYBOARD or INPUT_MOUSE).
			returns: Nothing.
		End Rem
		Method SetInputType(_input_type:Int)
			
			input_type = _input_type
			
		End Method
		
		Rem
			bbdoc: Get the input type for the Input Identifier (either INPUT_KEYBOARD or INPUT_MOUSE).
			returns: The input type for the Input Identifer.
		End Rem
		Method GetInputType:Int()
			
			Return input_type
			
		End Method
		
		Rem
			bbdoc: Set the action for the Input Identifier.
			returns: Nothing.
		End Rem
		Method SetAction(_action:String)
			
			action = _action
			
		End Method
		
		Rem
			bbdoc: Get the action for the Input Identifier.
			returns: The action of the Input Identifer.
		End Rem
		Method GetAction:String()
			
			Return action
			
		End Method
		
		Rem
			bbdoc: Create a 'bind' identifier for the TInputIdentifier.
			returns: A TIdentifier object.
		End Rem
		Method ToIdentifier:TIdentifier()
		  Local iden:TIdentifier = New TIdentifier.CreateByData("bind")
			
			iden.AddValue(New TStringVariable.Create("", GetInputCodeAsString()))
			iden.AddValue(New TStringVariable.Create("", GetAction()))
			
		   Return iden
		   
		End Method
		
		Rem
			bbdoc: Get an Input Identifier from a TSNode (a Script Node), based on an action.
			returns: An Input Identifier, or Null if the given input action was not found (may also throw a TBindRecognizeException if the code is unrecognized).
			about: This is based on the 'bind' identifier (from a script), e.g. 'bind "up" forward' (bind is the identifer, 'up' the input code and 'forward' the action).
			@action is not case sensitive.
			NOTE: This is not recursive, it will only look within the given node (not searching child nodes, parent node, etc).
		End Rem
		Function GetFromNodeByAction:TInputIdentifier(node:TSNode, action:String)
		  Local iiden:TInputIdentifier, iden:TIdentifier
			
			action = action.ToLower()
			
			If node <> Null
				
				For iden = EachIn node.GetChildren()
					
					Try
						iiden = GetFromIdentifier(iden)
						
						If iiden <> Null
							If iiden.GetAction().ToLower() = action Then Return iiden
						End If
						
					Catch ex:TBindRecognizeException
						DebugLog("TInputIdentifier.GetFromNodeByAction(); Exception caught: " + ex.ToString())
					End Try
					
				Next
				
			End If
			
			'Failed to find the Input Identifier for the given action
			Return Null
			
		End Function
		
		Rem
			bbdoc: Get a TInputIdentifier from a TIdentifier.
			returns: A TInputIdentifier, or Null if the identifier was not a bind identifier (may also throw a TBindRecognizeException if the code is unrecognized).
			about: This is based on the 'bind' identifier (from a script), e.g. 'bind "up" forward' (bind is the identifer, 'up' the input code and 'forward' the action).
		End Rem
		Function GetFromIdentifier:TInputIdentifier(iden:TIdentifier)
		  Local var1:TStringVariable, var2:TVariable, input_type:Int, input_code:Int, ic_raw:String
			
			If iden <> Null
				If BindTemplate.ValidateIdentifier(iden) = True
					
					var1 = TStringVariable(iden.GetValues().ValueAtIndex(1))
					var2 = TVariable(iden.GetValues().ValueAtIndex(0))
					
					If TStringVariable(var2)
						ic_raw = TStringVariable(var2).Get()
					Else If TIntVariable(var2)
						ic_raw = String(TIntVariable(var2).Get())
					End If
					
					input_type = INPUT_KEYBOARD
					input_code = TInputConv.StringToKeyCode(ic_raw)
					
					' Not a key code?
					If input_code = INPUT_UNBOUND
						input_type = INPUT_MOUSE
						input_code = TInputConv.StringToMouseCode(ic_raw)
					End If
					
					' Good code?
					If input_code <> INPUT_UNBOUND
						
						Return New TInputIdentifier.Create(input_code, input_type, var1.Get())
						
					Else
						
						Throw(New TBindRecognizeException.Create(iden.ConvToString()))
						
					End If
					
				Else
					
					DebugLog("TInputIdentifier.GetFromIdentifier(); Identifier: '" + iden.ConvToString() + "' did not match the bind template")
					
				End If
			End If
			
			Return Null
			
		End Function
		
End Type















