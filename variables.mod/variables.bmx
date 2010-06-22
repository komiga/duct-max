
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

ModuleInfo "Version: 0.24"
ModuleInfo "Copyright: Tim Howard"
ModuleInfo "License: MIT"

ModuleInfo "History: Version 0.24"
ModuleInfo "History: Removed silly debuglog"
ModuleInfo "History: Version 0.23"
ModuleInfo "History: dIdentifier now uses TListEx"
ModuleInfo "History: Version 0.22"
ModuleInfo "History: Fixed documentation, license"
ModuleInfo "History: Renamed TVariable to dVariable"
ModuleInfo "History: Renamed TIntVariable to dIntVariable"
ModuleInfo "History: Renamed TStringVariable to dStringVariable"
ModuleInfo "History: Renamed TFloatVariable to dFloatVariable"
ModuleInfo "History: Renamed TEvalVariable to dEvalVariable"
ModuleInfo "History: Renamed TIdentifier to dIdentifier"
ModuleInfo "History: Renamed TBoolVariable to dBoolVariable"
ModuleInfo "History: Version 0.21"
ModuleInfo "History: Corrected TVariable.RawToVariable parsing for eval variables; added allowevalvars option"
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
	bbdoc: Template variable type for the #dIntVariable type.
End Rem
Const TV_INTEGER:Int = 1
Rem
	bbdoc: Template variable type for the #dStringVariable type.
End Rem
Const TV_STRING:Int = 2
Rem
	bbdoc: Template variable type for the #dFloatVariable type.
End Rem
Const TV_FLOAT:Int = 3
Rem
	bbdoc: Template variable type for the #dEvalVariable type.
End Rem
Const TV_EVAL:Int = 4
Rem
	bbdoc: Template variable type for the #dIdentifier type.
End Rem
Const TV_IDEN:Int = 5
Rem
	bbdoc: Template variable type for the #dBoolVariable type.
End Rem
Const TV_BOOL:Int = 6

Rem
	bbdoc: duct generic variable.
	about: This is the base variable type, you should extend from this to use it.
End Rem
Type dVariable Abstract
	
	Field m_name:String
	Field m_parent:dVariable
	
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
	Method SetParent(parent:dVariable)
		m_parent = parent
	End Method
	
	Rem
		bbdoc: Get the variable's parent.
		returns: The variable's parent.
	End Rem
	Method GetParent:dVariable()
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
	Method Copy:dVariable() Abstract
	
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
	Method Deserialize:dVariable(stream:TStream, tv:Int = True, name:Int = False) Abstract
	
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
		bbdoc: Convert raw data (raw data being things like: "/e:(a+b/0.4181)*a-b" - a dEvalVariable, "A String variable", 3452134 - a dIntVariable, 1204.00321 - a variable) into a Variable.
		returns: A new Variable, or Null if something whacky occured.
		about: @etype is optional, it is used to go automagically to one type of a Variable (1 & 4=String (will check for '/e:' - dEvalVariables and dBoolVariables ['true' or 'false']), 2=Integer, 3=Float).<br/>
		@varname is also an optional parameter. It will be used as the name of the variable.<br/>
		If @allowevalvars (defaults to False) is True, eval variables will be checked for.
	End Rem
	Function RawToVariable:dVariable(vraw:String, etype:Int = 0, varname:String = "", allowevalvars:Int = False)
		Local variable:dVariable
		If vraw = Null
			'DebugLog("(dVariable.RawToVariable) @vraw = Null; returning a dStringVariable (with @varname and Null value)")
			Return New dStringVariable.Create(varname, Null)
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
		End If
		
		Select etype
			Case 2 ' Integer
				variable = dVariable(New dIntVariable.Create(varname, Int(vraw)))
			Case 3 ' Double/Float
				variable = dVariable(New dFloatVariable.Create(varname, Float(vraw)))
			Case 1, 4
				Local vrawlower:String = vraw.ToLower()
				If vrawlower.StartsWith("/e:") = True and allowevalvars = True
					variable = dVariable(New dEvalVariable.Create(varname, vraw[2..]))
				Else If vrawlower = "true" Or vrawlower = "false"
					variable = New dBoolVariable.Create(varname, (vrawlower = "true") And True Or False)
				Else
					variable = dVariable(New dStringVariable.Create(varname, vraw))
				End If
		End Select
		'DebugLog("TSNode.LoadScriptFromStream().RawToVariable(); vraw = ~q" + vraw + "~q \" + etype)
		?Debug
		If variable = Null Then DebugLog("(dVariable.RawToVariable) Unknown error, 'variable' is Null.")
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
	Function DeserializeUniversal:dVariable(stream:TStream, name:Int = False)
		Local tv:Int = Int(stream.ReadByte())
		Select tv
			Case TV_INTEGER
				Return New dIntVariable.Deserialize(stream, True, name)
			Case TV_STRING
				Return New dStringVariable.Deserialize(stream, True, name)
			Case TV_FLOAT
				Return New dFloatVariable.Deserialize(stream, True, name)
			Case TV_EVAL
				Return New dEvalVariable.Deserialize(stream, True, name)
			Case TV_IDEN
				Return New dIdentifier.Deserialize(stream, True, name)
			Case TV_BOOL
				Return New dBoolVariable.Deserialize(stream, True, name)
			Default
				DebugLog("(dVariable.DeserializeUniversal) Failed to recognize the TV in the stream: " + tv)
		End Select
		Return Null
	End Function
	
End Type

Rem
	bbdoc: duct string variable.
End Rem
Type dStringVariable Extends dVariable
	
	Global m_alwaysusequotes:Int = True
	
	Field m_value:String
	
	Rem
		bbdoc: Create a new String variable.
		returns: Itself.
	End Rem
	Method Create:dStringVariable(name:String = Null, value:String)
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
		bbdoc: Set the value of the variable to the given string (ambiguous).
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
		bbdoc: Get the variable as a String.
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
	Method Copy:dStringVariable()
		Return New dStringVariable.Create(m_name, m_value)
	End Method
	
	Rem
		bbdoc: Serialize the variable to a stream.
		returns: Nothing.
		about: @tv tells the method whether it should serialize the TV type for the variable, or to not.
	End Rem
	Method Serialize(stream:TStream, tv:Int = True, name:Int = False)
		If tv = True Then stream.WriteByte(TV_STRING)
		If name = True Then WriteLString(stream, m_name)
		WriteLString(stream, m_value)
	End Method
	
	Rem
		bbdoc: Deserialize the variable from a stream.
		returns: Itself.
		about: @tv tells the method whether it should deserialize the TV type for the variable, or to not.
	End Rem
	Method Deserialize:dStringVariable(stream:TStream, tv:Int = True, name:Int = False)
		If tv = True Then stream.ReadByte()
		If name = True Then m_name = ReadLString(stream)
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
	bbdoc: duct Float variable.
End Rem
Type dFloatVariable Extends dVariable
	
	Field m_value:Float
	
	Rem
		bbdoc: Create a new Float variable.
		returns: Itself.
	End Rem
	Method Create:dFloatVariable(name:String = Null, value:Float)
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
		returns: A scriptable form of the variable.
		about: This function is for script output, for in-code use see #ValueAsString.
	End Rem
	Method ConvToString:String()
		Local conv:String = String(m_value), encountered:Int
		For Local i:Int = conv.Find(".") To conv.Length - 1
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
		bbdoc: Get the variable as a String.
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
	Method Copy:dFloatVariable()
		Return New dFloatVariable.Create(m_name, m_value)
	End Method
	
	Rem
		bbdoc: Serialize the variable to a stream.
		returns: Nothing.
		about: @tv tells the method whether it should serialize the TV type for the variable, or to not.
	End Rem
	Method Serialize(stream:TStream, tv:Int = True, name:Int = False)
		If tv = True Then stream.WriteByte(TV_FLOAT)
		If name = True Then WriteLString(stream, m_name)
		stream.WriteFloat(m_value)
	End Method
	
	Rem
		bbdoc: Deserialize the variable from a stream.
		returns: Itself.
		about: @tv tells the method whether it should deserialize the TV type for the variable, or to not.
	End Rem
	Method Deserialize:dFloatVariable(stream:TStream, tv:Int = True, name:Int = False)
		If tv = True Then stream.ReadByte()
		If name = True Then m_name = ReadLString(stream)
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
	bbdoc: duct Int variable.
End Rem
Type dIntVariable Extends dVariable
	
	Field m_value:Int
	
	Rem
		bbdoc: Create a new Int variable.
		returns: Itself.
	End Rem
	Method Create:dIntVariable(name:String = Null, value:Int)
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
		bbdoc: Get the variable as a String.
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
	Method Copy:dIntVariable()
		Return New dIntVariable.Create(m_name, m_value)
	End Method
	
	Rem
		bbdoc: Serialize the variable to a stream.
		returns: Nothing.
		about: @tv tells the method whether it should serialize the TV type for the variable, or to not.
	End Rem
	Method Serialize(stream:TStream, tv:Int = True, name:Int = False)
		If tv = True Then stream.WriteByte(TV_INTEGER)
		If name = True Then WriteLString(stream, m_name)
		stream.WriteInt(m_value)
	End Method
	
	Rem
		bbdoc: Deserialize the variable from a stream.
		returns: Itself.
		about: @tv tells the method whether it should deserialize the TV type for the variable, or to not.
	End Rem
	Method Deserialize:dIntVariable(stream:TStream, tv:Int = True, name:Int = False)
		If tv = True Then stream.ReadByte()
		If name = True Then m_name = ReadLString(stream)
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
	bbdoc: duct eval variable (for bah.muparser, and the likes).
End Rem
Type dEvalVariable Extends dVariable
	
	Field m_value:String
	
	Rem
		bbdoc: Create a new eval variable.
		returns: Itself.
	End Rem
	Method Create:dEvalVariable(name:String = Null, value:String)
		SetName(name)
		Set(value)
		Return Self
	End Method
	
'#region Field accessors
	
	Rem
		bbdoc: Set the equation string for the variable.
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
		bbdoc: Convert the variable to a visual representation of its data.
		returns: The scriptable form of the variable.
		about: This function is for script output, for in-code use see #ValueAsString.
	End Rem
	Method ConvToString:String()
		Return "~q/e:" + m_value + "~q"
	End Method
	
	Rem
		bbdoc: Get the variable as a String.
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
	Method Copy:dEvalVariable()
		Return New dEvalVariable.Create(m_name, m_value)
	End Method
	
	Rem
		bbdoc: Serialize the variable to a stream.
		returns: Nothing.
		about: @tv tells the method whether it should serialize the TV type for the variable, or to not.
	End Rem
	Method Serialize(stream:TStream, tv:Int = True, name:Int = False)
		If tv = True Then stream.WriteByte(TV_EVAL)
		If name = True Then WriteLString(stream, m_name)
		WriteLString(stream, m_value)
	End Method
	
	Rem
		bbdoc: Deserialize the variable from a stream.
		returns: Itself.
		about: @tv tells the method whether it should deserialize the TV type for the variable, or to not.
	End Rem
	Method Deserialize:dEvalVariable(stream:TStream, tv:Int = True, name:Int = False)
		If tv = True Then stream.ReadByte()
		If name = True Then m_name = ReadLString(stream)
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
	bbdoc: duct boolean variable.
End Rem
Type dBoolVariable Extends dVariable
	
	Field m_value:Int
	
	Rem
		bbdoc: Create a new boolean variable.
		returns: Itself.
	End Rem
	Method Create:dBoolVariable(name:String = Null, value:Int)
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
		bbdoc: Get the dBoolVariable as a String.
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
	Method Copy:dBoolVariable()
		Return New dBoolVariable.Create(m_name, m_value)
	End Method
	
	Rem
		bbdoc: Serialize the variable to a stream.
		returns: Nothing.
		about: @tv tells the method whether it should serialize the TV type for the variable, or to not.
	End Rem
	Method Serialize(stream:TStream, tv:Int = True, name:Int = False)
		If tv = True Then stream.WriteByte(TV_BOOL)
		If name = True Then WriteLString(stream, m_name)
		stream.WriteByte(Byte(m_value))
	End Method
	
	Rem
		bbdoc: Deserialize the variable from a stream.
		returns: The deserialized variable.
		about: @tv tells the method whether it should deserialize the TV type for the variable, or to not.
	End Rem
	Method Deserialize:dBoolVariable(stream:TStream, tv:Int = True, name:Int = False)
		If tv = True Then stream.ReadByte()
		If name = True Then m_name = ReadLString(stream)
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
	bbdoc: duct identifier (used in parsers, mostly).
End Rem
Type dIdentifier Extends dVariable
	
	Field m_values:TListEx
	
	Method New()
	End Method
	
	Rem
		bbdoc: Create a new identifier.
		returns: Itself.
	End Rem
	Method Create:dIdentifier()
		m_values = New TListEx
		Return Self
	End Method
	
	Rem
		bbdoc: Create a new identifier with the given data.
		returns: Itself.
		about: If the @values parameter is Null a new list will be created.
	End Rem
	Method CreateByData:dIdentifier(name:String, values:TListEx = Null)
		SetName(name)
		If values = Null
			m_values = New TListEx
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
	Method SetValues(values:TListEx)
		m_values = values
	End Method
	
	Rem
		bbdoc: Get the identifier's values.
		returns: A list containing the values which the identifier holds.
	End Rem
	Method GetValues:TListEx()
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
		For Local variable:dVariable = EachIn m_values
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
	Method GetValueAtIndex:dVariable(index:Int)
		If m_values <> Null And index > - 1 And index < m_values.Count()
			Return dVariable(m_values.ValueAtIndex(index))
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
	Method AddValue:Int(value:dVariable)
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
	Method Copy:dIdentifier()
		Local clone:dIdentifier
		clone = New dIdentifier.CreateByData(m_name)
		For Local variable:dVariable = EachIn m_values
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
		Local variable:dVariable
		If tv = True Then stream.WriteByte(TV_STRING)
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
	Method Deserialize:dIdentifier(stream:TStream, tv:Int = True, name:Int = False)
		Local count:Int, n:Int
		If tv = True Then stream.ReadByte()
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
	bbdoc: #dVariable map (stores any variable).
EndRem
Type dVariableMap Extends dObjectMap
	
	Rem
		bbdoc: Create a new variable map.
		returns: Itself.
	End Rem
	Method Create:dVariableMap()
		Return Self
	End Method
	
'#region Collections
	
	Rem
		bbdoc: Insert a variable into the map.
		returns: True if the variable was added, or False if it was not (the variable's name is Null).
	End Rem
	Method InsertVariable:Int(variable:dVariable)
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
	Method GetVariableByName:dVariable(name:String)
		Return dVariable(_ValueByKey(name))
	End Method
	
'#end region (Collections)
	
End Type

