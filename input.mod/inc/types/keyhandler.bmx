
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
	
	keyhandler.bmx (Contains: TBindRecognizeException, TInputIdentifier, )
	
End Rem

Rem
	bbdoc: The BindRecognizeException type.
	about: Contains and is used to throw errors when TInputIdentifier.GetFromNodeByAction(...) <br />
	fails to recognize the bind identifer (invalid value state, unusable input identifier type, or 
	unrecognized input code).
End Rem
Type TBindRecognizeException
	
	Field m_info:String
		
		Method Create:TBindRecognizeException(info:String)
			
			m_info = info
			
			Return Self
			
		End Method
		
		Method ToString:String()
			Local output:String
			
			output = "Failed to recognize bind identifier, unrecognized input code"
			If m_info <> Null Then output:+" (" + m_info + ")"
			
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
	bbdoc: The InputIdentifier type.
	about: This type essentially holds a key/mouse 'bind'.
End Rem
Type TInputIdentifier
	
	Field m_action:String
	Field m_input_type:Int, m_input_code:Int ', m_input_scode:String
		
		Rem
			bbdoc: The template for InputIdentifiers.
			about: Definition: bind "INPUTCODE" "INPUTACTION".
		End Rem
		Global template:TTemplate = New TTemplate.Create(["bind"], [[TV_STRING, TV_INTEGER], [TV_STRING] ], False, False, Null)
		
		Method New()
			
			m_input_code = INPUT_UNBOUND
			m_input_type = INPUT_UNBOUND
			
			'm_input_scode = Null
			
		End Method
		
		Rem
			bbdoc: Create a new InputIdentifier.
			returns: The new InputIdentifier (itself).
			about: @input_type can be either INPUT_UNBOUND, INPUT_KEYBOARD or INPUT_MOUSE.<br />
			@input_code can also be INPUT_UNBOUND (which it is, by default).
		End Rem
		Method Create:TInputIdentifier(input_code:Int, input_type:Int, action:String) ', input_scode:String
			
			Bind(input_code, input_type)
			SetAction(action)
			
			Return Self
			
		End Method
		
		Rem
			bbdoc: Unbind the InputIdentifier.
			returns: Nothing.
			about: This method will set both the input code and the input type to INPUT_UNBOUND.
		End Rem
		Method UnBind()
			
			Bind(INPUT_UNBOUND, INPUT_UNBOUND)
			
		End Method
		
		Rem
			bbdoc: Bind the InputIdentifier.
			returns: Nothing.
		End Rem
		Method Bind(input_code:Int, input_type:Int)
			
			SetInputCode(input_code)
			SetInputType(input_type)
			'SetInputCodeString(input_scode)
			
		End Method
		
		Rem
			bbdoc: Get the (down) state of the InputIdentifier.
			returns: True if the action for this identifier is being performed, or False if it has not.
		End Rem
		Method GetStateDown:Int()
			Local istate:Int
			
			If m_input_code <> INPUT_UNBOUND
				If m_input_type = INPUT_KEYBOARD
					
					istate = KeyDown(m_input_code)
					
				Else If m_input_type = INPUT_MOUSE
					
					istate = MouseDown(m_input_code)
					
				End If
			End If
			
			Return istate
			
		End Method
		
		Rem
			bbdoc: Get the (hit) state of the InputIdentifier.
			returns: True if the action for this identifier has been performed, or False if it has not.
		End Rem
		Method GetStateHit:Int()
			Local istate:Int
			
			If m_input_code <> INPUT_UNBOUND
				If m_input_type = INPUT_KEYBOARD
					
					istate = KeyHit(m_input_code)
					
				Else If m_input_type = INPUT_MOUSE
					
					istate = MouseHit(m_input_code)
					
				End If
			End If
			
			Return istate
			
		End Method
		
		'#region Field accessors
		
		Rem
			bbdoc: Set the input code for the InputIdentifier.
			returns: Nothing.
		End Rem
		Method SetInputCode(input_code:Int)
			
			m_input_code = input_code
			
		End Method
		
		Rem
			bbdoc: Get the input code for the InputIdentifier.
			returns: The input code for the identifier.
		End Rem
		Method GetInputCode:Int()
			
			Return m_input_code
			
		End Method
		
		Rem
			bbdoc: Get the input code string (textual identifier) for the InputIdentifier.
			returns: The input code string (textual identifier) for the identifier, or Null ("") if it's unbound.
		End Rem
		Method GetInputCodeAsString:String()
			
			If m_input_code <> INPUT_UNBOUND
				If m_input_type = INPUT_KEYBOARD
					Return TInputConv.KeyCodeToString(m_input_code)
				Else If m_input_type = INPUT_MOUSE
					Return TInputConv.MouseCodeToString(m_input_code)
				End If
			End If
			
			Return Null
			
		End Method
		
		Rem
			bbdoc: Set the input type for the InputIdentifier (either INPUT_KEYBOARD or INPUT_MOUSE).
			returns: Nothing.
		End Rem
		Method SetInputType(input_type:Int)
			
			m_input_type = input_type
			
		End Method
		
		Rem
			bbdoc: Get the input type for the InputIdentifier (either INPUT_KEYBOARD or INPUT_MOUSE).
			returns: The input type for the identifer.
		End Rem
		Method GetInputType:Int()
			
			Return m_input_type
			
		End Method
		
		Rem
			bbdoc: Set the action for the InputIdentifier.
			returns: Nothing.
		End Rem
		Method SetAction(action:String)
			
			m_action = action
			
		End Method
		
		Rem
			bbdoc: Get the action for the InputIdentifier.
			returns: The action of the identifer.
		End Rem
		Method GetAction:String()
			
			Return m_action
			
		End Method
		
		'#end region
		
		Rem
			bbdoc: Stuff the InputIdentifier into an scriptable Identifier.
			returns: A TIdentifier object.
		End Rem
		Method ToIdentifier:TIdentifier()
			Local iden:TIdentifier = New TIdentifier.CreateByData("bind")
			
			iden.AddValue(New TStringVariable.Create("", GetInputCodeAsString()))
			iden.AddValue(New TStringVariable.Create("", m_action))
			
			Return iden
			
		End Method
		
		Rem
			bbdoc: Get an InputIdentifier from an SNode (a Script Node), based on the given action.
			returns: An InputIdentifier, or Null if the given action was not found (may also throw a TBindRecognizeException if the code is unrecognized).
			about: This is based on the 'bind' Template (from a script), e.g. `bind "up" forward` (where `bind` is the identifer, `up` the input code and `forward` the action).<br />
			@action is not case sensitive.<br />
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
							If iiden.GetAction().ToLower() = action
								
								Return iiden
								
							End If
						End If
						
					Catch ex:TBindRecognizeException
						
						DebugLog("TInputIdentifier.GetFromNodeByAction(); Exception caught: " + ex.ToString())
						
					End Try
					
				Next
				
			End If
			
			' Failed to find the InputIdentifier for the given action
			Return Null
			
		End Function
		
		Rem
			bbdoc: Get an InputIdentifier from an Identifier.
			returns: A InputIdentifier, or Null if the identifier was not a bind identifier (may also throw a TBindRecognizeException if the code is unrecognized).
			about: This is based on the 'bind' Template (from a script), e.g. `bind "up" forward` (where `bind` is the identifer, `up` the input code and `forward` the action).
		End Rem
		Function GetFromIdentifier:TInputIdentifier(iden:TIdentifier)
			Local var1:TStringVariable, var2:TVariable, input_type:Int, input_code:Int, ic_raw:String
			
			If iden <> Null
				
				If template.ValidateIdentifier(iden) = True
					
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






















