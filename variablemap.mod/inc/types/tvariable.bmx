
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
' tvariable.bmx (Contains: TVariable, TStringVariable, TFloatVariable, TIntVariable, TEvalVariable. )
' 
' 

Rem
	bbdoc: The TVariable type.
	about: This is the base variable type, if you need to make a new one you should extend from this.
End Rem
Type TVariable Abstract
	
	Field name:String
		
		Rem
			bbdoc: Set the variable's name.
			returns: Nothing.
		End Rem
		Method SetName(_name:String)
			
			name = _name
			
		End Method
		
		Rem
			bbdoc: Get the variable's name.
			returns: The variable's name.
		End Rem
		Method GetName:String()
			
			Return name
			
		End Method
		
		Rem
			bbdoc: Base method for converting variable data to a script-ready string.
		End Rem
		Method ConvToString:String() Abstract
		
		Rem
			bbdoc: Base method for converting variable data to a printable/usable-in-code string.
		End Rem
		Method ValueAsString:String() Abstract
		
End Type

Rem
	bbdoc: The TStringVariable type.
End Rem
Type TStringVariable Extends TVariable
	
	Field value:String
		
		Rem
			bbdoc: Create a TStringVariable.
			returns: The created object.
			about: How to call:
			Local var:TStringVariable = New TStringVariable.Create(1.0)
		End Rem
		Method Create:TStringVariable(_name:String, _value:String)
			
			SetName(_name)
			Set(_value)
			Return Self
			
		End Method
		
		Rem
			bbdoc: Set the variable's value.
			returns: Nothing.
		End Rem
		Method set(_value:String)
			
			value = _value
			
		End Method
		
		Rem
			bbdoc: Get the variable's value.
			returns: The value of the variable.
		End Rem
		Method Get:String()
			
			Return value
			
		End Method
		
		Rem
			bbdoc: Convert the variable to a string.
			returns: A string representation of the variable.
			about: This function is for script output, for in-code use see #ValueAsString.
		End Rem
		Method ConvToString:String()
			
			Return "~q" + value + "~q"
			
		End Method
		
		Rem
			bbdoc: Get the stringvariable as a string.
			returns: The variable value converted to a string.
			about: Here for complete-ness, no difference to stringvar.Get()
		End Rem
		Method ValueAsString:String()
			
			Return Get()
			
		End Method
		
End Type

Rem
	bbdoc: The TFloatVariable type.
End Rem
Type TFloatVariable Extends TVariable
	
	Field value:Float
		
		Rem
			bbdoc: Create a TFloatVariable.
			returns: The created object.
			about: How to call:
			Local var:TFloatVariable = New TFloatVariable.Create(1.0)
		End Rem
		Method Create:TFloatVariable(_name:String, _value:Float)
			
			SetName(_name)
			Set(_value)
			Return Self
			
		End Method
		
		Rem
			bbdoc: Set the variable's value.
			returns: Nothing.
		End Rem
		Method set(_value:Float)
			
			value = _value
			
		End Method
		
		Rem
			bbdoc: Get the variable's value.
			returns: The value of the variable.
		End Rem
		Method Get:Float()
			
			Return value
			
		End Method
		
		Rem
			bbdoc: Convert the variable to a string.
			returns: A string representation of the variable.
			about: This function is for script output, for in-code use see #ValueAsString.
		End Rem
		Method ConvToString:String()
		  Local conv:String = String(value), i:Int, encountered:Int
			
			For i = conv.Find(".") To conv.Length - 1
				
				If conv[i] = 48
					
					If encountered = True
					
						conv = conv[..i]
						Exit
						
					End If
					
				Else If conv[i] <> 46
					
					encountered = True
					
				End If
				
			Next
			
		   Return conv
		   
		End Method
		
		Rem
			bbdoc: Get the floatvariable as a string.
			returns: The variable value converted to a string.
		End Rem
		Method ValueAsString:String()
			
			Return String(Get())
			
		End Method
		
End Type

Rem
	bbdoc: The TIntVariable type.
End Rem
Type TIntVariable Extends TVariable
		
	Field value:Int
		
		Rem
			bbdoc: Create a TIntVariable.
			returns: The created object.
			about: How to call:
			Local var:TIntVariable = New TIntVariable.Create(10)
		End Rem
		Method Create:TIntVariable(_name:String, _value:Int)
			
			SetName(_name)
			Set(_value)
			Return Self
			
		End Method
		
		Rem
			bbdoc: Set the variable's value.
			returns: Nothing.
		End Rem
		Method set(_value:Int)
			
			value = _value
			
		End Method
		
		Rem
			bbdoc: Get the variable's value.
			returns: The value of the variable.
		End Rem
		Method Get:Int()
			
			Return value
			
		End Method
		
		Rem
			bbdoc: Convert the variable to a string.
			returns: A string representation of the variable.
			about: This function is for script output, for in-code use see #ValueAsString.
		End Rem
		Method ConvToString:String()
			
			Return String(value)
			
		End Method
		
		Rem
			bbdoc: Get the intvariable as a string.
			returns: The variable value converted to a string.
		End Rem
		Method ValueAsString:String()
			
			Return String(Get())
			
		End Method
		
End Type


Rem
	bbdoc: The TEvalVariable type.
End Rem
Type TEvalVariable Extends TVariable
	
	Field value:String
		
		Rem
			bbdoc: Create a TEvalVariable.
			returns: The created object.
		End Rem
		Method Create:TEvalVariable(_name:String, _value:String)
			
			setName(_name)
			Set(_value)
			Return Self
			
		End Method
		
		Rem
			bbdoc: Set the equation string for the TEvalVariable.
			returns: Nothing
		End Rem
		Method Set(_value:String)
			
			value = _value
			
		End Method
		
		Rem
			bbdoc: Get the equation string.
			returns: The equation string.
		End Rem
		Method Get:String()
			
			Return value
			
		End Method
		
		Rem
			bbdoc: Convert the TEvalVariable to a visual representation of its data.
			returns: ~q/eval::$EQUATION~q.
			about: This function is for script output, for in-code use see #ValueAsString.
		End Rem
		Method ConvToString:String()
			
			Return "~q/eval::" + value + "~q"
			
		End Method
		
		Rem
			bbdoc: Get the floatvariable as a string.
			returns: The variable value converted to a string.
		End Rem
		Method ValueAsString:String()
			
			Return Get()
			
		End Method
		
End Type





















