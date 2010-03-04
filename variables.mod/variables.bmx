
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

SuperStrict

Rem
bbdoc: Variables module
End Rem
Module duct.variables

ModuleInfo "Version: 0.20"
ModuleInfo "Copyright: Tim Howard"
ModuleInfo "License: MIT"

ModuleInfo "History: Version 0.20"
ModuleInfo "History: Added TBoolVariable support in TVariable.DeserializeUniversal"
ModuleInfo "History: Added TBoolVariable support in TVariable.RawToVariable"
ModuleInfo "History: Fixed an issue with eval variables in TVariable.RawToVariable"
ModuleInfo "History: Corrected some method names and some documentation."
ModuleInfo "History: Version 0.19"
ModuleInfo "History: Added TBoolVariable; documentation correction"
ModuleInfo "History: Version 0.18"
ModuleInfo "History: TIdentifier.AddValue now sets the variable's parent to itself"
ModuleInfo "History: Added SetParent and GetParent to TVaraible"
ModuleInfo "History: Version 0.17"
ModuleInfo "History: General cleanup"
ModuleInfo "History: Version 0.16"
ModuleInfo "History: Added SetAmbiguous to all TVariable types"
ModuleInfo "History: Added option to always use quoting with TStringVariables (on by default)"
ModuleInfo "History: Fixed TStringVariable.ConvToString returning of Null strings"
ModuleInfo "History: Version 0.15"
ModuleInfo "History: Change the Create method definition for easier use"
ModuleInfo "History: Changed the '/eval::' recognizer to '/e:' (as per SNode format change)"
ModuleInfo "History: Added the Copy method to every variable type"
ModuleInfo "History: Changed some formatting"
ModuleInfo "History: Version 0.14"
ModuleInfo "History: Changed type tabbing"
ModuleInfo "History: Fixed script output for TStringVariable (quotes are now only added if whitespace is present)"
ModuleInfo "History: Fixed script output for TIdentifier (identifier names can now contain whitespace, in which case they must be quoted)"
ModuleInfo "History: Version 0.13"
ModuleInfo "History: Added the DeserializeUniversal function to TVariable"
ModuleInfo "History: Added Serialize and Deserialize methods to all variable types"
ModuleInfo "History: Version 0.12"
ModuleInfo "History: Changed module name from 'variablemap' to 'variables'"
ModuleInfo "History: Moved all of duct.utilparser here"
ModuleInfo "History: Added the GetTVType function to all variable types"
ModuleInfo "History: Moved TV_* constants from duct.template here"
ModuleInfo "History: Version 0.11"
ModuleInfo "History: Added the ReportType function to all variable types"
ModuleInfo "History: Version 0.10"
ModuleInfo "History: Added the RawToVariable function to TVariable"
ModuleInfo "History: General code cleanup"
ModuleInfo "History: Version 0.09"
ModuleInfo "History: Corrected usage of syntax (in Returns, Cases, News and Selects)"
ModuleInfo "History: Version 0.08"
ModuleInfo "History: Added the TEvalVariable type"
ModuleInfo "History: Initial release"

Import brl.stream

Import duct.etc
Import duct.objectmap

Rem
	bbdoc: Template variable type for the #TIntVariable type.
End Rem
Const TV_INTEGER:Int = 1
Rem
	bbdoc: Template variable type for the #TStringVariable type.
End Rem
Const TV_STRING:Int = 2
Rem
	bbdoc: Template variable type for the #TFloatVariable type.
End Rem
Const TV_FLOAT:Int = 3
Rem
	bbdoc: Template variable type for the #TEvalVariable type.
End Rem
Const TV_EVAL:Int = 4
Rem
	bbdoc: Template variable type for the #TIdentifier type.
End Rem
Const TV_IDEN:Int = 5
Rem
	bbdoc: Template variable type for the #TBoolVariable type.
End Rem
Const TV_BOOL:Int = 6

Rem
	bbdoc: Generic variable type.
	about: This is the base variable type, you should extend from this to use it.
End Rem
Type TVariable Abstract
	
	Field m_name:String
	Field m_parent:TVariable
	
'#region Field accessors
	
	Rem
		bbdoc: Set the variable's name.
		returns: Nothing.
	End Rem
	Method SetName(name:String)
		m_name = name
	End Method
	
	Rem
		bbdoc: Get the variable's name.
		returns: The variable's name.
	End Rem
	Method GetName:String()
		Return m_name
	End Method
	
	Rem
		bbdoc: Set the variable's parent.
		returns: Nothing.
	End Rem
	Method SetParent(parent:TVariable)
		m_parent = parent
	End Method
	
	Rem
		bbdoc: Get the variable's parent.
		returns: The variable's parent.
	End Rem
	Method GetParent:TVariable()
		Return m_parent
	End Method
	
	Rem
		bbdoc: Base method for setting the value of the variable to the given string (conversion).
	End Rem
	Method SetAmbiguous(value:String) Abstract
	
	Rem
		bbdoc: Base method for converting variable data to a script-ready string.
	End Rem
	Method ConvToString:String() Abstract
	
	Rem
		bbdoc: Base method for converting variable data to a printable/usable-in-code string.
	End Rem
	Method ValueAsString:String() Abstract
	
'#end region (Field accessors)
	
'#region Data handling
	
	Rem
		bbdoc: Create a copy of the variable.
		returns: A clone of the variable.
	End Rem
	Method Copy:TVariable() Abstract
	
	Rem
		bbdoc: Serialize the variable to a stream.
		returns: Nothing.
		about: @tv tells the method whether it should serialize the TV type for the variable, or to not.
	End Rem
	Method Serialize(stream:TStream, tv:Int = True, name:Int = False) Abstract
	
	Rem
		bbdoc: Deserialize the variable from a stream.
		returns: The deserialized variable.
		about: @tv tells the method whether it should deserialize the TV type for the variable, or to not.
	End Rem
	Method Deserialize:TVariable(stream:TStream, tv:Int = True, name:Int = False) Abstract
	
'#end region (Data handling)
	
	Rem
		bbdoc: Base method: Get the type of this variable.
	End Rem
	Function ReportType:String() Abstract
	
	Rem
		bbdoc: Base method: Get the TV_* type of this variable.
	End Rem
	Function GetTVType:Int() Abstract
	
	Rem
		bbdoc: Convert raw data (raw data being things like: "/e:(a+b/0.4181)*a-b" - a TEvalVariable, "A String variable", 3452134 - a TIntVariable, 1204.00321 - a FloatVariable) into a Variable.
		returns: A new Variable, or Null if something whacky occured.
		about: @etype is optional, it is used to go automagically to one type of a Variable (1 & 4=String (will check for '/eval::' - EvalVariables), 2=Integer, 3=Float).<br/>
		@varname is also an optional parameter. It will be used as the name of the variable.
	End Rem
	Function RawToVariable:TVariable(vraw:String, etype:Int = 0, varname:String = "")
		Local variable:TVariable
		If vraw = Null
			DebugLog("(TVariable.RawToVariable) @vraw = Null; returning StringVariable (with @varname and Null value)")
			Return New TStringVariable.Create(varname, Null)
		End If
		If etype = 0 ' Determine the value's type (must be either integer, double, or a string with no spaces)
			' ASCII '0' to '9' = 48-57; '-' = 45, '+' = 43; and '.' = 46
			For Local i:Int = 0 To vraw.Length - 1
				Local c:Int = vraw[i]
				If c >= 48 And c <= 57 Or c = 43 Or c = 45
					If etype = 0 ' Leave float and string alone
						etype = 2 ' Integer so far..
					End If
				Else If c = 46
					If etype = 2 ' Already declared as an integer?
						etype = 3
					End If
				Else ' If the character is not numerical there is nothing else to deduce and the value is a string
					etype = 4
					Exit
				End If
			Next
			
			Select etype
				Case 2 ' Integer
					variable = TVariable(New TIntVariable.Create(varname, Int(vraw)))
				Case 3 ' Double/Float
					variable = TVariable(New TFloatVariable.Create(varname, Float(vraw)))
			End Select
		End If
		
		If etype = 1 Or etype = 4
			Local vrawlower:String = vraw.ToLower()
			Local evaltest:Int = vrawlower.StartsWith("/e:")
			If evaltest >= 0
				variable = TVariable(New TEvalVariable.Create(varname, vraw[evaltest + 3..]))
			Else If vrawlower = "true" Or vrawlower = "false"
				variable = New TBoolVariable.Create(varname, (vrawlower = "true") And True Or False)
			Else
				variable = TVariable(New TStringVariable.Create(varname, vraw))
			End If
		End If
		' DebugLog("TSNode.LoadScriptFromStream().RawToVariable(); vraw = ~q" + vraw + "~q \" + etype)
		?Debug
		If variable = Null Then DebugLog("( TVariable.RawToVariable() ) Unknown error, 'variable' is Null.")
		?
		Return variable
	End Function
	
	Rem
		bbdoc: Universally deserialize a variable from the given stream.
		returns: A Deserialized variable.
		about: This will deserialize any variable from the stream.<br/>
		This requires the variable to have been serialized with the template type (see #Serialize parameters).<br/>
		@name tells the further Deserialize calls if the name should be Deserialized or not.
	End Rem
	Function DeserializeUniversal:TVariable(stream:TStream, name:Int = False)
		Local tv:Int = Int(stream.ReadByte())
		Select tv
			Case TV_INTEGER
				Return New TIntVariable.Deserialize(stream, True, name)
			Case TV_STRING
				Return New TStringVariable.Deserialize(stream, True, name)
			Case TV_FLOAT
				Return New TFloatVariable.Deserialize(stream, True, name)
			Case TV_EVAL
				Return New TEvalVariable.Deserialize(stream, True, name)
			Case TV_IDEN
				Return New TIdentifier.Deserialize(stream, True, name)
			Case TV_BOOL
				Return New TBoolVariable.Deserialize(stream, True, name)
			Default
				DebugLog("(TVariable.DeserializeUniversal) Failed to recognize the TV in the stream: " + tv)
		End Select
		Return Null
	End Function
	
End Type

Rem
	bbdoc: String variable.
End Rem
Type TStringVariable Extends TVariable
	
	Global m_alwaysusequotes:Int = True
	
	Field m_value:String
	
	Rem
		bbdoc: Create a new StringVariable.
		returns: The new StringVariable (itself).
	End Rem
	Method Create:TStringVariable(name:String = Null, value:String)
		SetName(name)
		Set(value)
		Return Self
	End Method
	
'#region Field accessors
	
	Rem
		bbdoc: Set the variable's value.
		returns: Nothing.
	End Rem
	Method Set(value:String)
		m_value = value
	End Method
	
	Rem
		bbdoc: Get the variable's value.
		returns: The value of the variable.
	End Rem
	Method Get:String()
		Return m_value
	End Method
	
	Rem
		bbdoc: Set the value of the TStringVariable to the given string (ambiguous).
		returns: Nothing.
		about: For this type, this method is no different than calling #Set.
	End Rem
	Method SetAmbiguous(value:String)
		m_value = value
	End Method
	
	Rem
		bbdoc: Convert the variable to a String.
		returns: A String representation of the variable.
		about: This function is for script output, for in-code use see #ValueAsString.
	End Rem
	Method ConvToString:String()
		If m_alwaysusequotes = True Or m_value.Contains("~t") Or m_value.Contains(" ") Or m_value = Null
			Return "~q" + m_value + "~q"
		Else
			Return m_value
		End If
	End Method
	
	Rem
		bbdoc: Get the StringVariable as a String.
		returns: The variable's value converted to a String.
		about: Here for complete-ness, no difference to `instance.Get()`.
	End Rem
	Method ValueAsString:String()
		Return m_value
	End Method
	
'#end region (Field accessors)
	
'#region Data handling
	
	Rem
		bbdoc: Create a copy of the variable
		returns: A clone of the variable.
	End Rem
	Method Copy:TStringVariable()
		Return New TStringVariable.Create(m_name, m_value)
	End Method
	
	Rem
		bbdoc: Serialize the variable to a stream.
		returns: Nothing.
		about: @tv tells the method whether it should serialize the TV type for the variable, or to not.
	End Rem
	Method Serialize(stream:TStream, tv:Int = True, name:Int = False)
		If tv = True
			stream.WriteByte(TV_STRING)
		End If
		If name = True
			WriteLString(stream, m_name)
		End If
		
		WriteLString(stream, m_value)
	End Method
	
	Rem
		bbdoc: Deserialize the variable from a stream.
		returns: The deserialized variable.
		about: @tv tells the method whether it should deserialize the TV type for the variable, or to not.
	End Rem
	Method Deserialize:TStringVariable(stream:TStream, tv:Int = True, name:Int = False)
		If tv = True
			stream.ReadByte()
		End If
		If name = True
			m_name = ReadLString(stream)
		End If
		
		m_value = ReadLString(stream)
		Return Self
	End Method
	
'#end region (Data handling)
	
	Rem
		bbdoc: Get the type of this variable.
		returns: The type of this variable ("string").
	End Rem
	Function ReportType:String()
		Return "string"
	End Function
	
	Rem
		bbdoc: Get the TV type of this variable.
		returns: The TV_* type of this variable (TV_STRING).
	End Rem
	Function GetTVType:Int()
		Return TV_STRING
	End Function
	
End Type

Rem
	bbdoc: Float variable.
End Rem
Type TFloatVariable Extends TVariable
	
	Field m_value:Float
	
	Rem
		bbdoc: Create a new FloatVariable.
		returns: The new FloatVariable (itself).
	End Rem
	Method Create:TFloatVariable(name:String = Null, value:Float)
		SetName(name)
		Set(value)
		Return Self
	End Method
	
'#region Field accessors
	
	Rem
		bbdoc: Set the variable's value.
		returns: Nothing.
	End Rem
	Method Set(value:Float)
		m_value = value
	End Method
	
	Rem
		bbdoc: Get the variable's value.
		returns: The value of the variable.
	End Rem
	Method Get:Float()
		Return m_value
	End Method
	
	Rem
		bbdoc: Set the value of the variable to the given string (ambiguous).
		returns: Nothing.
	End Rem
	Method SetAmbiguous(value:String)
		m_value = Float(value)
	End Method
	
	Rem
		bbdoc: Convert the variable to a String.
		returns: A scriptable form of the StringVariable.
		about: This function is for script output, for in-code use see #ValueAsString.
	End Rem
	Method ConvToString:String()
		Local conv:String = String(m_value), i:Int, encountered:Int
		
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
		bbdoc: Get the FloatVariable as a String.
		returns: The variable's value converted to a String.
	End Rem
	Method ValueAsString:String()
		Return String(m_value)
	End Method
	
'#end region (Field accessors)
	
'#region Data handling
	
	Rem
		bbdoc: Create a copy of the variable
		returns: A clone of the variable.
	End Rem
	Method Copy:TFloatVariable()
		Return New TFloatVariable.Create(m_name, m_value)
	End Method
	
	Rem
		bbdoc: Serialize the variable to a stream.
		returns: Nothing.
		about: @tv tells the method whether it should serialize the TV type for the variable, or to not.
	End Rem
	Method Serialize(stream:TStream, tv:Int = True, name:Int = False)
		If tv = True
			stream.WriteByte(TV_FLOAT)
		End If
		If name = True
			WriteLString(stream, m_name)
		End If
		stream.WriteFloat(m_value)
	End Method
	
	Rem
		bbdoc: Deserialize the variable from a stream.
		returns: The deserialized variable.
		about: @tv tells the method whether it should deserialize the TV type for the variable, or to not.
	End Rem
	Method Deserialize:TFloatVariable(stream:TStream, tv:Int = True, name:Int = False)
		If tv = True
			stream.ReadByte()
		End If
		If name = True
			m_name = ReadLString(stream)
		End If
		m_value = stream.ReadFloat()
		Return Self
	End Method
	
'#end region (Data handling)
	
	Rem
		bbdoc: Get the type of this variable.
		returns: The type of this variable ("float").
	End Rem
	Function ReportType:String()
		Return "float"
	End Function
	
	Rem
		bbdoc: Get the TV type of this variable.
		returns: The TV_* type of this variable (TV_FLOAT).
	End Rem
	Function GetTVType:Int()
		Return TV_FLOAT
	End Function
	
End Type

Rem
	bbdoc: Integer variable.
End Rem
Type TIntVariable Extends TVariable
	
	Field m_value:Int
	
	Rem
		bbdoc: Create a new IntVariable.
		returns: The new IntVariable (itself).
	End Rem
	Method Create:TIntVariable(name:String = Null, value:Int)
		SetName(name)
		Set(value)
		Return Self
	End Method
	
'#region Field accessors
	
	Rem
		bbdoc: Set the variable's value.
		returns: Nothing.
	End Rem
	Method Set(value:Int)
		m_value = value
	End Method
	
	Rem
		bbdoc: Get the variable's value.
		returns: The value of the variable.
	End Rem
	Method Get:Int()
		Return m_value
	End Method
	
	Rem
		bbdoc: Set the value of the variable to the given string (ambiguous).
		returns: Nothing.
	End Rem
	Method SetAmbiguous(value:String)
		m_value = Int(value)
	End Method
	
	Rem
		bbdoc: Convert the variable to a String.
		returns: A string representation of the variable.
		about: This function is for script output, for in-code use see #ValueAsString.
	End Rem
	Method ConvToString:String()
		Return String(m_value)
	End Method
	
	Rem
		bbdoc: Get the IntVariable as a String.
		returns: The variable's value converted to a String.
	End Rem
	Method ValueAsString:String()
		Return String(m_value)
	End Method
	
'#end region (Field accessors)
	
'#region Data handling
	
	Rem
		bbdoc: Create a copy of the variable
		returns: A clone of the variable.
	End Rem
	Method Copy:TIntVariable()
		Return New TIntVariable.Create(m_name, m_value)
	End Method
	
	Rem
		bbdoc: Serialize the variable to a stream.
		returns: Nothing.
		about: @tv tells the method whether it should serialize the TV type for the variable, or to not.
	End Rem
	Method Serialize(stream:TStream, tv:Int = True, name:Int = False)
		If tv = True
			stream.WriteByte(TV_INTEGER)
		End If
		If name = True
			WriteLString(stream, m_name)
		End If
		
		stream.WriteInt(m_value)
	End Method
	
	Rem
		bbdoc: Deserialize the variable from a stream.
		returns: The deserialized variable.
		about: @tv tells the method whether it should deserialize the TV type for the variable, or to not.
	End Rem
	Method Deserialize:TIntVariable(stream:TStream, tv:Int = True, name:Int = False)
		If tv = True
			stream.ReadByte()
		End If
		If name = True
			m_name = ReadLString(stream)
		End If
		
		m_value = stream.ReadInt()
		Return Self
	End Method
	
'#end region (Data handling)
	
	Rem
		bbdoc: Get the type of this variable.
		returns: The type of this variable ("int").
	End Rem
	Function ReportType:String()
		Return "int"
	End Function
	
	Rem
		bbdoc: Get the TV type of this variable.
		returns: The TV_* type of this variable (TV_INTEGER).
	End Rem
	Function GetTVType:Int()
		Return TV_INTEGER
	End Function
	
End Type

Rem
	bbdoc: Eval variable (for bah.muparser, and the likes).
End Rem
Type TEvalVariable Extends TVariable
	
	Field m_value:String
	
	Rem
		bbdoc: Create a new EvalVariable.
		returns: The new EvalVariable (itself).
	End Rem
	Method Create:TEvalVariable(name:String = Null, value:String)
		SetName(name)
		Set(value)
		Return Self
	End Method
	
'#region Field accessors
	
	Rem
		bbdoc: Set the equation string for the EvalVariable.
		returns: Nothing
	End Rem
	Method Set(value:String)
		m_value = value
	End Method
	
	Rem
		bbdoc: Get the equation string.
		returns: The equation string.
	End Rem
	Method Get:String()
		Return m_value
	End Method
	
	Rem
		bbdoc: Set the value of the variable to the given string (ambiguous).
		returns: Nothing.
		about: For this type, this method is no different than calling #Set.
	End Rem
	Method SetAmbiguous(value:String)
		m_value = value
	End Method
	
	Rem
		bbdoc: Convert the EvalVariable to a visual representation of its data.
		returns: The scriptable form of the EvalVariable.
		about: This function is for script output, for in-code use see #ValueAsString.
	End Rem
	Method ConvToString:String()
		Return "~q/e:" + m_value + "~q"
	End Method
	
	Rem
		bbdoc: Get the EvalVariable as a String.
		returns: The variable's value converted to a String.
	End Rem
	Method ValueAsString:String()
		Return m_value
	End Method
	
'#end region (Field accessors)
	
'#region Data handling
	
	Rem
		bbdoc: Create a copy of the variable
		returns: A clone of the variable.
	End Rem
	Method Copy:TEvalVariable()
		Return New TEvalVariable.Create(m_name, m_value)
	End Method
	
	Rem
		bbdoc: Serialize the variable to a stream.
		returns: Nothing.
		about: @tv tells the method whether it should serialize the TV type for the variable, or to not.
	End Rem
	Method Serialize(stream:TStream, tv:Int = True, name:Int = False)
		If tv = True
			stream.WriteByte(TV_EVAL)
		End If
		If name = True
			WriteLString(stream, m_name)
		End If
		
		WriteLString(stream, m_value)
	End Method
	
	Rem
		bbdoc: Deserialize the variable from a stream.
		returns: The deserialized variable.
		about: @tv tells the method whether it should deserialize the TV type for the variable, or to not.
	End Rem
	Method Deserialize:TEvalVariable(stream:TStream, tv:Int = True, name:Int = False)
		If tv = True
			stream.ReadByte()
		End If
		If name = True
			m_name = ReadLString(stream)
		End If
		
		m_value = ReadLString(stream)
		Return Self
	End Method
	
'#end region (Data handling)
	
	Rem
		bbdoc: Get the type of this variable.
		returns: The type of this variable ("eval").
	End Rem
	Function ReportType:String()
		Return "eval"
	End Function
	
	Rem
		bbdoc: Get the TV type of this variable.
		returns: The TV_* type of this variable (TV_EVAL).
	End Rem
	Function GetTVType:Int()
		Return TV_EVAL
	End Function
	
End Type

Rem
	bbdoc: Boolean variable.
End Rem
Type TBoolVariable Extends TVariable
	
	Field m_value:Int
	
	Rem
		bbdoc: Create a new BoolVariable.
		returns: The new BoolVariable (itself).
	End Rem
	Method Create:TBoolVariable(name:String = Null, value:Int)
		SetName(name)
		Set(value)
		Return Self
	End Method
	
'#region Field accessors
	
	Rem
		bbdoc: Set the variable's value.
		returns: Nothing.
	End Rem
	Method Set(value:Int)
		m_value = value
	End Method
	
	Rem
		bbdoc: Get the variable's value.
		returns: The value of the variable.
	End Rem
	Method Get:Int()
		Return m_value
	End Method
	
	Rem
		bbdoc: Set the value of the variable to the given string (ambiguous).
		returns: Nothing.
	End Rem
	Method SetAmbiguous(value:String)
		m_value = Int(value)
	End Method
	
	Rem
		bbdoc: Convert the variable to a String.
		returns: A string representation of the variable.
		about: This function is for script output, for in-code use see #ValueAsString.
	End Rem
	Method ConvToString:String()
		Return String(m_value)
	End Method
	
	Rem
		bbdoc: Get the TBoolVariable as a String.
		returns: The variable's value converted to a String.
	End Rem
	Method ValueAsString:String()
		Return String(m_value)
	End Method
	
'#end region (Field accessors)
	
'#region Data handling
	
	Rem
		bbdoc: Create a copy of the variable
		returns: A clone of the variable.
	End Rem
	Method Copy:TBoolVariable()
		Return New TBoolVariable.Create(m_name, m_value)
	End Method
	
	Rem
		bbdoc: Serialize the variable to a stream.
		returns: Nothing.
		about: @tv tells the method whether it should serialize the TV type for the variable, or to not.
	End Rem
	Method Serialize(stream:TStream, tv:Int = True, name:Int = False)
		If tv = True
			stream.WriteByte(TV_BOOL)
		End If
		If name = True
			WriteLString(stream, m_name)
		End If
		stream.WriteByte(Byte(m_value))
	End Method
	
	Rem
		bbdoc: Deserialize the variable from a stream.
		returns: The deserialized variable.
		about: @tv tells the method whether it should deserialize the TV type for the variable, or to not.
	End Rem
	Method Deserialize:TBoolVariable(stream:TStream, tv:Int = True, name:Int = False)
		If tv = True
			stream.ReadByte()
		End If
		If name = True
			m_name = ReadLString(stream)
		End If
		m_value = Int(stream.ReadByte())
		Return Self
	End Method
	
'#end region (Data handling)
	
	Rem
		bbdoc: Get the type of this variable.
		returns: The type of this variable ("bool").
	End Rem
	Function ReportType:String()
		Return "bool"
	End Function
	
	Rem
		bbdoc: Get the TV type of this variable.
		returns: The TV_* type of this variable (TV_BOOL).
	End Rem
	Function GetTVType:Int()
		Return TV_BOOL
	End Function
	
End Type

Rem
	bbdoc: Identifier (used in parsers, mostly).
End Rem
Type TIdentifier Extends TVariable
	
	Field m_values:TList
	
	Method New()
	End Method
	
	Rem
		bbdoc: Create a new TIdentifier.
		returns: Itself.
	End Rem
	Method Create:TIdentifier()
		m_values = New TList
		Return Self
	End Method
	
	Rem
		bbdoc: Create a new TIdentifier with the given data.
		returns: The new Identfier (itself).
		about: If the @values parameter is Null a new list will be created.
	End Rem
	Method CreateByData:TIdentifier(name:String, values:TList = Null)
		SetName(name)
		If values = Null
			m_values = New TList
		Else
			m_values = values
		End If
		Return Self
	End Method
	
'#region Field accessors
	
	Rem
		bbdoc: Set the identifier's values.
		returns: Nothing.
	End Rem
	Method SetValues(values:TList)
		m_values = values
	End Method
	
	Rem
		bbdoc: Get the identifier's values.
		returns: A list containing the values which the identifier holds.
	End Rem
	Method GetValues:TList()
		Return m_values
	End Method
	
	Rem
		bbdoc: Deprecated for this type.
		returns: Nothing.
		about: This does nothing.
	End Rem
	Method SetAmbiguous(value:String)
	End Method
	
	Rem
		bbdoc: Convert the identifier to a string.
		returns: A string representation of the identifier.
	End Rem
	Method ConvToString:String()
		Local op:String
		If m_name.Contains("~t") = True Or m_name.Contains(" ") = True
			op = "~q" + m_name + "~q "
		Else
			op = m_name + " "
		End If
		For Local variable:TVariable = EachIn m_values
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
	
'#end region (Field accessors)
	
'#region Value handling
	
	Rem
		bbdoc: Get a value at an index.
		returns: The value in the identifier's list at the given index, or Null if it could not be retrieved.
		about: The index is zero-based.
	End Rem
	Method GetValueAtIndex:TVariable(index:Int)
		If m_values <> Null And index > - 1 And index < m_values.Count()
			Return TVariable(m_values.ValueAtIndex(index))
		End If
		Return Null
	End Method
	
	Rem
		bbdoc: Get the number of values.
		returns: The number of values the identifier contains.
	End Rem
	Method GetValueCount:Int()
		If m_values <> Null
			Return m_values.Count()
		End If
		Return 0
	End Method
	
	Rem
		bbdoc: Add a value to the identifier.
		returns: True for success, or False for failure.
		about: NOTE: This will set the given value's parent.
	End Rem
	Method AddValue:Int(value:TVariable)
		If m_values <> Null And value <> Null
			m_values.AddLast(value)
			value.SetParent(Self)
			Return True
		End If
		Return False
	End Method
	
'#end region (Value handling)
	
'#region Data handling
	
	Rem
		bbdoc: Create a copy of the identifier
		returns: A clone of the identifier.
	End Rem
	Method Copy:TIdentifier()
		Local clone:TIdentifier
		clone = New TIdentifier.CreateByData(m_name)
		For Local variable:TVariable = EachIn m_values
			clone.AddValue(variable.Copy())
		Next
		Return clone
	End Method
	
	Rem
		bbdoc: Serialize the variable to a stream.
		returns: Nothing.
		about: @tv tells the method whether it should serialize the TV type for the variable, or to not.<br/>
		In this case @name tells the method whether it should serialize the <i><b>values</b></i>' name (the identifier's name is always read/written to the stream).
	End Rem
	Method Serialize(stream:TStream, tv:Int = True, name:Int = False)
		Local variable:TVariable
		If tv = True
			stream.WriteByte(TV_STRING)
		End If
		WriteLString(stream, m_name)
		If m_values = Null
			stream.WriteInt(0)
		Else
			stream.WriteInt(m_values.Count())
			For variable = EachIn m_values
				variable.Serialize(stream, True, name)
			Next
		End If
	End Method
	
	Rem
		bbdoc: Deserialize the variable from a stream.
		returns: The deserialized variable.
		about: @tv tells the method whether it should deserialize the TV type for the variable, or to not.<br/>
		In this case @name tells the method whether it should deserialize the <i><b>values</b></i>' name (the identifier's name is always read/written to the stream).
	End Rem
	Method Deserialize:TIdentifier(stream:TStream, tv:Int = True, name:Int = False)
		Local count:Int, n:Int
		If tv = True
			stream.ReadByte()
		End If
		m_name = ReadLString(stream)
		count = stream.ReadInt()
		If count > 0
			For n = 0 To count - 1
				DeserializeUniversal(stream, name)
			Next
		End If
		Return Self
	End Method
	
'#end region (Data handling)
	
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
	bbdoc: Variable map (stores any variable).
EndRem
Type TVariableMap Extends TObjectMap
	
	Rem
		bbdoc: Create a new TVariableMap.
		returns: Itself.
	End Rem
	Method Create:TVariableMap()
		Return Self
	End Method
	
'#region Collections
	
	Rem
		bbdoc: Insert a variable into the map.
		returns: True if the variable was added, or False if it was not (the variable's name is Null).
	End Rem
	Method InsertVariable:Int(variable:TVariable)
		If variable.GetName() <> Null
			_Insert(variable.GetName(), variable)
			Return True
		End If
		Return False
	End Method
	
	Rem
		bbdoc: Remove a variable by the name given.
		returns: True if a variable was removed, or False if it was not (the map contains no variable with the name given).
		about: The name <b>is</b> case-sensitive.
	End Rem
	Method RemoveVariableByName:Int(name:String)
		Return _Remove(name)
	End Method
	
	Rem
		bbdoc: Get a variable from the map by its name.
		returns: The variable object, or if the variable was not found, Null.
		about: The name <b>is</b> case-sensitive.
	End Rem
	Method GetVariableByName:TVariable(name:String)
		Return TVariable(_ValueByKey(name))
	End Method
	
'#end region (Collections)
	
End Type

