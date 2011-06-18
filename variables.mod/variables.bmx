
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

ModuleInfo "Version: 0.28"
ModuleInfo "Copyright: Tim Howard"
ModuleInfo "License: MIT"

ModuleInfo "History: Version 0.28"
ModuleInfo "History: Fixed some documentation"
ModuleInfo "History: Explicit conditional for dIntVariable->boolean conversion in dVariable.ConvertVariableToBool"
ModuleInfo "History: Added newline check to whitespaced-string formatting"
ModuleInfo "History: Version 0.27"
ModuleInfo "History: Added GetValueMatchingTemplate method to dCollectionVariable"
ModuleInfo "History: Version 0.26"
ModuleInfo "History: General cleanup"
ModuleInfo "History: Updated for duct.objectmap changes"
ModuleInfo "History: Added variable renaming to dTemplate"
ModuleInfo "History: Added variable compacting and identifier expanding to dTemplate"
ModuleInfo "History: Added InsertVariableAfterLink and InsertVariableBeforeLink to dCollectionVariable"
ModuleInfo "History: Adapted for duct.etc change"
ModuleInfo "History: Added formatting flags and formatting to dValueVariable.GetValueFormatted and dVariable.GetNameFormatted"
ModuleInfo "History: Moved value variables to src/values.bmx and collection variables to src/collections.bmx"
ModuleInfo "History: Fixed Deserialize calls in DeserializeUniversal (TV was already being read)"
ModuleInfo "History: Added dCollectionVariable; dIdentifier and dNode now extend from dCollectionVariable"
ModuleInfo "History: Added dValueVariable; dStringVariable, dIntVariable, dFloatVariable and dBoolVariable now extend from dValueVariable"
ModuleInfo "History: Added dBoolVariable.ConvertVariableToBool"
ModuleInfo "History: Moved base of scriptparser.dSNode to variables.dNode"
ModuleInfo "History: Removed dEvalVariable"
ModuleInfo "History: Version 0.25"
ModuleInfo "History: The dBoolVariable.ConvToString method now returns 'true' or 'false' according to value"
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

Include "src/values.bmx"
Include "src/collections.bmx"
Include "src/template.bmx"

Rem
	bbdoc: Value quote-always format flag.
	about: This flag is for any variable type. The output will always have quotes around it.
End Rem
Const FMT_VALUE_QUOTE_ALWAYS:Int = $1

Rem
	bbdoc: String quote-whitespace format flag.
	about: This format will quote a string containing whitespace or newlines. e.g. "foo bar~t" -> "~qfoo bar~t~q".
End Rem
Const FMT_STRING_QUOTE_WHITESPACE:Int = $10
Rem
	bbdoc: String quote-empty format flag.
	about: This format will quote an empty string. e.g. "" -> "~q~q".
End Rem
Const FMT_STRING_QUOTE_EMPTY:Int = $20
Rem
	bbdoc: String quote-bool format flag.
	about: This format will quote a string if it equals "true" or "false" as a type safeguard. e.g. "true" -> "~qtrue~q".
End Rem
Const FMT_STRING_SAFE_BOOL:Int = $40
Rem
	bbdoc: String quote-number format flag.
	about: This format will quote a string if it is a number as a type safeguard. e.g. "1234.5678" -> "~q1234.5678~q".
End Rem
Const FMT_STRING_SAFE_NUMBER:Int = $80
Rem
	bbdoc: String safe format flag.
	about: Comprised of #FMT_STRING_SAFE_BOOL and #FMT_STRING_SAFE_NUMBER
End Rem
Const FMT_STRING_SAFE:Int = FMT_STRING_SAFE_BOOL | FMT_STRING_SAFE_NUMBER
Rem
	bbdoc: Default string format flag.
	about: Comprised of #FMT_STRING_SAFE, #FMT_STRING_QUOTE_WHITESPACE and #FMT_STRING_QUOTE_EMPTY.
End Rem
Const FMT_STRING_DEFAULT:Int = FMT_STRING_SAFE | FMT_STRING_QUOTE_WHITESPACE | FMT_STRING_QUOTE_EMPTY

Rem
	bbdoc: Float truncate format flag.
	about: This format will remove repeated numbers at the end of a float. e.g. "0.123400000" -> "0.1234".
End Rem
Const FMT_FLOAT_TRUNCATE:Int = $100
Rem
	bbdoc: Default float format flag.
	about: Comprised of #FMT_FLOAT_TRUNCATE.
End Rem
Const FMT_FLOAT_DEFAULT:Int = FMT_FLOAT_TRUNCATE

Rem
	bbdoc: Boolean string format flag.
	about: Convert the boolean value to a string ("true", "false"). e.g. False -> "false", True -> "true".
End Rem
Const FMT_BOOL_STRING:Int = $1000
Rem
	bbdoc: Default boolean format flag.
	about: Comprised of #FMT_BOOL_STRING.
End Rem
Const FMT_BOOL_DEFAULT:Int = FMT_BOOL_STRING

Rem
	bbdoc: Default name format flag.
	about: Comprised of #FMT_STRING_SAFE, #FMT_STRING_QUOTE_WHITESPACE and #FMT_STRING_QUOTE_EMPTY.
End Rem
Const FMT_NAME_DEFAULT:Int = FMT_STRING_SAFE | FMT_STRING_QUOTE_WHITESPACE | FMT_STRING_QUOTE_EMPTY

Rem
	bbdoc: Default int format flag.
	about: Unset flag (no formatting).
End Rem
Const FMT_INTEGER_DEFAULT:Int = 0

Rem
	bbdoc: Default format flag for any variable.
	about: Comprised of all default format flags: #FMT_STRING_DEFAULT, #FMT_FLOAT_DEFAULT, #FMT_BOOL_DEFAULT and #FMT_INTEGER_DEFAULT.
End Rem
Const FMT_ALL_DEFAULT:Int = FMT_STRING_DEFAULT | FMT_FLOAT_DEFAULT | FMT_BOOL_DEFAULT | FMT_INTEGER_DEFAULT

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
	bbdoc: Template variable type for the #dBoolVariable type.
End Rem
Const TV_BOOL:Int = 4

Rem
	bbdoc: Template variable type for the #dIdentifier type.
End Rem
Const TV_IDEN:Int = 10
Rem
	bbdoc: Template variable type for the #dNode type.
End Rem
Const TV_NODE:Int = 11

Rem
	bbdoc: duct generic variable.
	about: This is the base variable type, you should extend from this to use it.
End Rem
Type dVariable Abstract
	
	Field m_name:String
	Field m_parent:dCollectionVariable
	
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
		bbdoc: Get the variable's name, formatted to encapsulate whitespace.
		returns: The variable's formatted name.
	End Rem
	Method GetNameFormatted:String(format:Int = FMT_NAME_DEFAULT)
		If format & FMT_VALUE_QUOTE_ALWAYS
			Return "~q" + m_name + "~q"
		Else If Not m_name And format & FMT_STRING_QUOTE_EMPTY
			Return "~q~q"
		Else If format & FMT_STRING_QUOTE_WHITESPACE And (m_name.Contains("~t") Or m_name.Contains(" ") Or m_name.Contains("~n"))
			Return "~q" + m_name + "~q"
		End If
		Return m_name
	End Method
	
	Rem
		bbdoc: Set the variable's parent.
		returns: Nothing.
	End Rem
	Method SetParent(parent:dCollectionVariable)
		m_parent = parent
	End Method
	
	Rem
		bbdoc: Get the variable's parent.
		returns: The variable's parent.
	End Rem
	Method GetParent:dCollectionVariable()
		Return m_parent
	End Method
	
'#end region Field accessors
	
'#region Data handling
	
	Rem
		bbdoc: Create a copy of the variable.
		returns: A clone of the variable.
		about: NOTE: A clone has no parent.
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
		returns: Itself.
		about: @tv tells the method whether it should deserialize the TV type for the variable, or to not.
	End Rem
	Method Deserialize:dVariable(stream:TStream, tv:Int = True, name:Int = False) Abstract
	
'#end region Data handling
	
	Rem
		bbdoc: Base method: Get the type of this variable.
	End Rem
	Function ReportType:String() Abstract
	
	Rem
		bbdoc: Base method: Get the TV_* type of this variable.
	End Rem
	Function GetTVType:Int() Abstract
	
	Rem
		bbdoc: Convert raw data (raw data being things like: "A String variable", 3452134 - a dIntVariable, 1204.321 - a dFloatVariable) into a Variable.
		returns: A new Variable, or Null if something whacky occured.
		about: @etype is optional, it is used to automagically goto one type of a variable (1 and 4=String (will check for dBoolVariables ['true', '1', 'false', '0']), 2=Integer, 3=Float).<br>
		@varname is also an optional parameter. It will be used as the name of the variable.<br>
	End Rem
	Function RawToVariable:dValueVariable(vraw:String, etype:Int = 0, varname:String = "")
		Local variable:dValueVariable
		If Not vraw
			Return New dStringVariable.Create(varname, Null)
		End If
		If etype = 0 ' Determine the value's type (must be either integer, double, or a string with no spaces)
			' ASCII '0' to '9' = 48-57; '-' = 45, '+' = 43; and '.' = 46
			For Local i:Int = 0 Until vraw.Length
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
				variable = New dIntVariable.Create(varname, Int(vraw))
			Case 3 ' Double/Float
				variable = New dFloatVariable.Create(varname, Float(vraw))
			Case 1, 4
				Local vrawlower:String = vraw.ToLower()
				If vrawlower = "true" Or vrawlower = "false" Or vrawlower = "1" Or vrawlower = "0"
					variable = New dBoolVariable.Create(varname, (vrawlower = "true" Or vrawlower = "1") And True Or False)
				Else
					variable = New dStringVariable.Create(varname, vraw)
				End If
		End Select
		?Debug
		If Not variable Then DebugLog("(dVariable.RawToVariable) Unknown error, 'variable' is Null; vraw=~q" + vraw + "~q, varname=~q" + varname + "~q etype=" + etype)
		?
		Return variable
	End Function
	
	Rem
		bbdoc: Universally deserialize a variable from the given stream.
		returns: A Deserialized variable.
		about: This will deserialize any variable from the stream.<br>
		This requires the variable to have been serialized with the template type (see #Serialize parameters).<br>
		@name tells the further Deserialize calls if the name should be Deserialized or not.
	End Rem
	Function DeserializeUniversal:dVariable(stream:TStream, name:Int = False)
		Local tv:Int = stream.ReadByte()
		Select tv
			Case TV_INTEGER
				Return New dIntVariable.Deserialize(stream, False, name)
			Case TV_STRING
				Return New dStringVariable.Deserialize(stream, False, name)
			Case TV_FLOAT
				Return New dFloatVariable.Deserialize(stream, False, name)
			Case TV_BOOL
				Return New dBoolVariable.Deserialize(stream, False, name)
			Case TV_IDEN
				Return New dIdentifier.Deserialize(stream, False, name)
			Case TV_NODE
				Return New dNode.Deserialize(stream, False, name)
			Default
				DebugLog("(dVariable.DeserializeUniversal) Failed to recognize the TV in the stream: " + tv)
		End Select
		Return Null
	End Function
	
	Rem
		bbdoc: Convert a dValueVariable to a boolean value (dStringVariable, dBoolVariable or dIntVariable).
		returns: True if the variable was able to convert to true, False if the variable was able to convert to false, or -1 if the variable could not be converted.
		about: Tries integers (only if they are 1 or 0), strings ("true"/"false", "1"/"0" - not case sensitive) and boolean variables (from value); floats are not tried.
	End Rem
	Function ConvertVariableToBool:Int(variable:dValueVariable)
		If dIntVariable(variable)
			Local val:Int = dIntVariable(variable).Get()
			If val = 0 Or val = 1
				Return val
			End If
		Else If dStringVariable(variable)
			Local val:String = dStringVariable(variable).Get().ToLower()
			Select val
				Case "true", "1"
					Return True
				Case "false", "0"
					Return False
			End Select
		Else If dBoolVariable(variable)
			Return dBoolVariable(variable).Get()
		End If
		Return -1
	End Function
	
	Rem
		bbdoc: Convert the given string to a boolean value.
		returns: True if the string was able to convert to true, False if the string was able to convert to false, or -1 if the string could not be converted to false or true.
		about: NOTE: Matches are "true", "1", "false" and "0".
	End Rem
	Function ConvertStringToBool:Int(str:String, casesens:Int = False)
		If str
			If Not casesens Then str = str.ToLower()
			Select str
				Case "true", "1"
					Return True
				Case "false", "0"
					Return False
			End Select
		End If
		Return -1
	End Function
	
End Type

Rem
	bbdoc: duct value variable base.
	about: This type should be extended if you want to make a variable that stores a value.
End Rem
Type dValueVariable Extends dVariable Abstract
	
	Rem
		bbdoc: Base method for setting the value of the variable to the given string (conversion).
	End Rem
	Method SetAmbiguous(value:String) Abstract
	
	Rem
		bbdoc: Base method formatted-value method.
	End Rem
	Method GetValueFormatted:String(format:Int) Abstract
	
	Rem
		bbdoc: Base method for converting variable data to an unformatted string.
	End Rem
	Method ValueAsString:String() Abstract
	
End Type

Rem
	bbdoc: duct collection variable (variable with children).
End Rem
Type dCollectionVariable Extends dVariable Abstract
	
	Field m_children:TListEx
	
'#region Field accessors
	
	Rem
		bbdoc: Set the variable's children list.
		returns: Nothing.
		about: NOTE: If the given list has variables, the collection will become their parent.
	End Rem
	Method SetChildren(children:TListEx)
		m_children = children
		If m_children
			If m_children.Count() > 0
				For Local v:dVariable = EachIn m_children
					v.SetParent(Self)
				Next
			End If
		End If
	End Method
	
	Rem
		bbdoc: Get the variable's children list.
		returns: The variable's children list.
	End Rem
	Method GetChildren:TListEx()
		Return m_children
	End Method
	
'#end region Field accessors
	
'#region Collections
	
	Rem
		bbdoc: Get a variable at the given index.
		returns: The variable at the given index, or Null if it could not be retrieved.
	End Rem
	Method GetVariableAtIndex:dVariable(index:Int)
		If index > -1 And index < m_children.Count()
			Return dVariable(m_children.ValueAtIndex(index))
		End If
		Return Null
	End Method
	
	Rem
		bbdoc: Get a value variable at the given index.
		returns: The value variable at the given index, or Null if it could not be retrieved (either index out of bounds, or index contained a non-value variable).
	End Rem
	Method GetValueAtIndex:dValueVariable(index:Int)
		If index > -1 And index < m_children.Count()
			Return dValueVariable(m_children.ValueAtIndex(index))
		End If
		Return Null
	End Method
	
	Rem
		bbdoc: Get the number of children the collection contains.
		returns: The number of children.
	End Rem
	Method GetChildCount:Int()
		Return m_children.Count()
	End Method
	
	Rem
		bbdoc: Add a variable to the collection.
		returns: True if the variable was added, or False if the given variable was Null.
	End Rem
	Method AddVariable:Int(variable:dVariable, setparent:Int = True)
		If variable
			m_children.AddLast(variable)
			If setparent Then variable.SetParent(Self)
			Return True
		End If
		Return False
	End Method
	
	Rem
		bbdoc: Insert the given variable after the given link.
		returns: The link that was inserted, or Null if either the given arguments were Null, or the given link could not be inserted.
	End Rem
	Method InsertVariableAfterLink:TLink(variable:dVariable, link:TLink, setparent:Int = True)
		If variable And link
			Local link:TLink = m_children.InsertAfterLink(variable, link)
			If link
				If setparent Then variable.SetParent(Self)
				Return link
			End If
		End If
		Return Null
	End Method
	
	Rem
		bbdoc: Insert the given variable before the given link.
		returns: The link that was inserted, or Null if either the given arguments were Null, or the given link could not be inserted.
	End Rem
	Method InsertVariableBeforeLink:TLink(variable:dVariable, link:TLink, setparent:Int = True)
		If variable And link
			Local link:TLink = m_children.InsertBeforeLink(variable, link)
			If link
				If setparent Then variable.SetParent(Self)
				Return link
			End If
		End If
		Return Null
	End Method
	
	Rem
		bbdoc: Remove the given variable from the collection.
		returns: True if the variable was removed, or False if the given variable was not found.
		about: NOTE: This will clear the variable's parent if the parent is the collection (regardless if it was removed or not).
	End Rem
	Method RemoveVariable:Int(variable:dVariable)
		If variable
			Local removed:Int = m_children.Remove(variable)
			If variable.m_parent = Self Then variable.SetParent(Null)
			Return removed
		End If
		Return False
	End Method
	
	Rem
		bbdoc: Remove a variable with the given name from the collection.
		returns: True if a variable was removed, or False if the collection has no variables with the given name.
		about: NOTE: This will clear the variable's parent if the parent is the collection (regardless if it was removed or not).
	End Rem
	Method RemoveVariableWithName:Int(name:String, casesens:Int = True)
		If name
			Local variable:dVariable = GetVariableWithName(name, casesens)
			If variable
				Local removed:Int = m_children.Remove(variable)
				If variable.m_parent = Self Then variable.SetParent(Null)
				Return removed
			End If
		End If
		Return False
	End Method
	
	Rem
		bbdoc: Remove a node with the given name from the collection.
		returns: True if a node was removed, or False if the collection has no nodes with the given name.
		about: NOTE: This will clear the node's parent if the parent is the collection (regardless if it was removed or not).
	End Rem
	Method RemoveNodeWithName:Int(name:String, casesens:Int = True)
		If name
			Local variable:dVariable = GetNodeWithName(name, casesens)
			If variable
				Local removed:Int = m_children.Remove(variable)
				If variable.m_parent = Self Then variable.SetParent(Null)
				Return removed
			End If
		End If
		Return False
	End Method
	
	Rem
		bbdoc: Remove an identifier with the given name from the collection.
		returns: True if an identifier was removed, or False if the collection has no identifiers with the given name.
		about: NOTE: This will clear the identifier's parent if the parent is the collection (regardless if it was removed or not).
	End Rem
	Method RemoveIdentifierWithName:Int(name:String, casesens:Int = True)
		If name
			Local variable:dVariable = GetIdentifierWithName(name, casesens)
			If variable
				Local removed:Int = m_children.Remove(variable)
				If variable.m_parent = Self Then variable.SetParent(Null)
				Return removed
			End If
		End If
		Return False
	End Method
	
	Rem
		bbdoc: Remove a value with the given name from the collection.
		returns: True if a value was removed, or False if the collection has no values with the given name.
		about: NOTE: This will clear the value's parent if the parent is the collection (regardless if it was removed or not).
	End Rem
	Method RemoveValueWithName:Int(name:String, casesens:Int = True)
		If name
			Local variable:dVariable = GetValueWithName(name, casesens)
			If variable
				Local removed:Int = m_children.Remove(variable)
				If variable.m_parent = Self Then variable.SetParent(Null)
				Return removed
			End If
		End If
		Return False
	End Method
	
	Rem
		bbdoc: Get any variable by its name.
		returns: A variable with the name given, or Null if it was not found.
		about: By default case sensitivity is on.
	End Rem
	Method GetVariableWithName:dVariable(name:String, casesens:Int = True)
		Local itername:String
		If Not casesens Then name = name.ToLower()
		For Local variable:dValueVariable = EachIn m_children
			itername = variable.GetName()
			If Not casesens Then itername = itername.ToLower()
			If name = itername
				Return variable
			End If
		Next
		Return Null
	End Method
	
	Rem
		bbdoc: Get a node with the given name.
		returns: A node with the name given, or Null if the collection has no nodes with the given name.
		about: By default case sensitivity is on.
	End Rem
	Method GetNodeWithName:dNode(name:String, casesens:Int = True)
		Local itername:String
		If Not casesens Then name = name.ToLower()
		For Local node:dNode = EachIn m_children
			itername = node.GetName()
			If Not casesens Then itername = itername.ToLower()
			If name = itername
				Return node
			End If
		Next
		Return Null
	End Method
	
	Rem
		bbdoc: Get an identifier with the given name.
		returns: An identifier with the name given, or Null if the collection has no identifiers with the given name.
		about: By default case sensitivity is on.
	End Rem
	Method GetIdentifierWithName:dIdentifier(name:String, casesens:Int = True)
		Local itername:String
		If Not casesens Then name = name.ToLower()
		For Local iden:dIdentifier = EachIn m_children
			itername = iden.GetName()
			If Not casesens Then itername = itername.ToLower()
			If name = itername
				Return iden
			End If
		Next
		Return Null
	End Method
	
	Rem
		bbdoc: Get an identifier matching the given template.
		returns: The first matching identifier, or Null if no matches were found.
	End Rem
	Method GetIdentifierMatchingTemplate:dIdentifier(template:dTemplate)
		For Local iden:dIdentifier = EachIn m_children
			If template.ValidateIdentifier(iden)
				Return iden
			End If
		Next
		Return Null
	End Method
	
	Rem
		bbdoc: Get a value with the given name.
		returns: A value with the name given, or Null if the collection has no values with the given name.
		about: By default case sensitivity is on.
	End Rem
	Method GetValueWithName:dValueVariable(name:String, casesens:Int = True)
		Local itername:String
		If Not casesens Then name = name.ToLower()
		For Local variable:dValueVariable = EachIn m_children
			itername = variable.GetName()
			If Not casesens Then itername = itername.ToLower()
			If name = itername
				Return variable
			End If
		Next
		Return Null
	End Method
	
	Rem
		bbdoc: Get a value variable matching the given template.
		returns: The first matching value variable, or Null if no matches were found.
	End Rem
	Method GetValueMatchingTemplate:dValueVariable(template:dTemplate)
		For Local value:dValueVariable = EachIn m_children
			If template.ValidateValue(value)
				Return value
			End If
		Next
		Return Null
	End Method
	
'#end region Collections
	
'#region Data handling
	
	Rem
		bbdoc: Create a copy of the variable.
		returns: A clone of the variable.
		about: NOTE: A clone has no parent.
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
	
'#end region Data handling
	
	Rem
		bbdoc: Base method: Get the type of this variable.
	End Rem
	Function ReportType:String() Abstract
	
	Rem
		bbdoc: Base method: Get the TV_* type of this variable.
	End Rem
	Function GetTVType:Int() Abstract
	
	Rem
		bbdoc: Get the collection's enumerator.
		returns: The collection's enumerator.
	End Rem
	Method ObjectEnumerator:TListEnum()
		Return m_children.ObjectEnumerator()
	End Method
	
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
	Method RemoveVariableWithName:Int(name:String)
		Return _Remove(name)
	End Method
	
	Rem
		bbdoc: Get a variable from the map by its name.
		returns: The variable object, or if the variable was not found, Null.
		about: The name <b>is</b> case-sensitive.
	End Rem
	Method GetVariableWithName:dVariable(name:String)
		Return dVariable(_ObjectWithKey(name))
	End Method
	
'#end region Collections
	
End Type

