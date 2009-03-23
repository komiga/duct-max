
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
' tvariablemap.bmx (Contains: TVariableMap, )
' 
' 

Rem
	bbdoc: The TVariableMap type.
EndRem
Type TVariableMap Extends TObjectMap
	
		Rem
			bbdoc: Creates a variablemap.
			returns: The created variablemap.
			about: How to call: 
			Local varmap:TVariableMap = New TVariableMap.Create()
			
			NOTE: This function currently does nothing, so calling it would be the same as doing New TVariableMap.
		End Rem
		Method Create:TVariableMap()
			
			Return Self
			
		End Method
		
		Rem
			bbdoc: Inserts a variable.
			returns: Nothing.
			about: The variable will be inserted using its name as the key.
		End Rem
		Method InsertVariable(variable:TVariable)
			
			_Insert(variable.GetName(), variable)
			
		End Method
		
		Rem
			bbdoc: Gets a variable from the map by its name.
			returns: The variable object, or if the variable was not found, Null.
		End Rem
		Method GetVariableByName:TVariable(name:String)
			
			Return TVariable(_ValueByKey(name))
			
		End Method
		
End Type







