
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

Rem
	bbdoc: duct string variable.
End Rem
Type dStringVariable Extends dValueVariable
	
	Field m_value:String
	
	Rem
		bbdoc: Create a new String variable.
		returns: Itself.
	End Rem
	Method Create:dStringVariable(name:String = Null, value:String, parent:dCollectionVariable = Null)
		SetName(name)
		Set(value)
		SetParent(parent)
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
		bbdoc: Get the variable's value with the given format.
		returns: The formatted value.
		about: NOTE: @ValueAsString will give you the unformatted string conversion of the variable's value.
	End Rem
	Method GetValueFormatted:String(format:Int = FMT_STRING_DEFAULT)
		If format & FMT_VALUE_QUOTE_ALWAYS
			Return "~q" + m_value + "~q"
		Else If Not m_value And format & FMT_STRING_QUOTE_EMPTY
			Return "~q~q"
		Else If format & FMT_STRING_QUOTE_WHITESPACE And (m_value.Contains("~t") Or m_value.Contains(" ") Or m_value.Contains("~n"))
			Return "~q" + m_value + "~q"
		Else If format & FMT_STRING_SAFE_BOOL And Not(dVariable.ConvertVariableToBool(Self) = -1)
			Return "~q" + m_value + "~q"
		Else If format & FMT_STRING_SAFE_NUMBER
			Local number:Int = False, dec:Int = False
			Local c:Int
			For Local i:Int = 0 Until m_value.Length
				c = m_value[i]
				If c = 46
					If dec
						number = False
						Exit
					Else
						dec = True
					End If
				Else If c > 47 And c < 58
					number = True
				Else
					number = False
					Exit
				End If
			Next
			If number
				Return "~q" + m_value + "~q"
			End If
		End If
		Return m_value
	End Method
	
	Rem
		bbdoc: Get the variable's value as a string.
		returns: The variable's value converted to a string.
	End Rem
	Method ValueAsString:String()
		Return m_value
	End Method
	
'#end region Field accessors
	
'#region Data handling
	
	Rem
		bbdoc: Create a copy of the variable
		returns: A clone of the variable.
		about: NOTE: A clone has no parent.
	End Rem
	Method Copy:dStringVariable()
		Return New dStringVariable.Create(m_name, m_value, Null)
	End Method
	
	Rem
		bbdoc: Serialize the variable to a stream.
		returns: Nothing.
		about: @tv tells the method whether it should serialize the TV type for the variable, or to not.
	End Rem
	Method Serialize(stream:TStream, tv:Int = True, name:Int = False)
		If tv = True Then stream.WriteByte(TV_STRING)
		If name = True Then dStreamIO.WriteLString(stream, m_name)
		dStreamIO.WriteLString(stream, m_value)
	End Method
	
	Rem
		bbdoc: Deserialize the variable from a stream.
		returns: Itself.
		about: @tv tells the method whether it should deserialize the TV type for the variable, or to not.
	End Rem
	Method Deserialize:dStringVariable(stream:TStream, tv:Int = True, name:Int = False)
		If tv = True Then stream.ReadByte()
		If name = True Then m_name = dStreamIO.ReadLString(stream)
		m_value = dStreamIO.ReadLString(stream)
		Return Self
	End Method
	
'#end region Data handling
	
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
Type dFloatVariable Extends dValueVariable
	
	Field m_value:Float
	
	Rem
		bbdoc: Create a new Float variable.
		returns: Itself.
	End Rem
	Method Create:dFloatVariable(name:String = Null, value:Float, parent:dCollectionVariable = Null)
		SetName(name)
		Set(value)
		SetParent(parent)
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
		bbdoc: Get the variable's value with the given format.
		returns: The formatted value.
		about: NOTE: @ValueAsString will give you the unformatted string conversion of the variable's value.
	End Rem
	Method GetValueFormatted:String(format:Int = FMT_FLOAT_DEFAULT)
		Local conv:String = String(m_value)
		'DebugLog("(dFloatVariable.GetValueFormatted) conv=~q" + conv + "~q format=" + format)
		If format & FMT_FLOAT_TRUNCATE
			conv = conv[..Min(conv.Find(".") + 6, conv.Length)]
			Local repc:Int = conv[conv.Length - 1]
			'DebugLog("(dFloatVariable.GetValueFormatted) truncate. conv=~q" + conv + "~q i=" + (conv.Length - 1) + " repc=" + repc + " .p=" + conv.Find("."))
			For Local i:Int = conv.Length - 1 Until Max(conv.Find(".") - 1, 0) Step -1
				If conv[i] = 46
					'DebugLog("conv[" + i + "] = 46")
					conv = conv[..Min(i + 2, conv.Length)]
					Exit
				Else If conv[i] <> repc' And conv[i] <> 48
					'DebugLog("conv[" + i + "] <> " + repc)
					conv = conv[..Min(i + 1, conv.Length)]
					Exit
				End If
			Next
		End If
		If format & FMT_VALUE_QUOTE_ALWAYS
			Return "~q" + conv + "~q"
		End If
		Return conv
	End Method
	
	Rem
		bbdoc: Get the variable's value as a string.
		returns: The variable's value converted to a string.
	End Rem
	Method ValueAsString:String()
		Return String(m_value)
	End Method
	
'#end region Field accessors
	
'#region Data handling
	
	Rem
		bbdoc: Create a copy of the variable
		returns: A clone of the variable.
		about: NOTE: A clone has no parent.
	End Rem
	Method Copy:dFloatVariable()
		Return New dFloatVariable.Create(m_name, m_value, Null)
	End Method
	
	Rem
		bbdoc: Serialize the variable to a stream.
		returns: Nothing.
		about: @tv tells the method whether it should serialize the TV type for the variable, or to not.
	End Rem
	Method Serialize(stream:TStream, tv:Int = True, name:Int = False)
		If tv = True Then stream.WriteByte(TV_FLOAT)
		If name = True Then dStreamIO.WriteLString(stream, m_name)
		stream.WriteFloat(m_value)
	End Method
	
	Rem
		bbdoc: Deserialize the variable from a stream.
		returns: Itself.
		about: @tv tells the method whether it should deserialize the TV type for the variable, or to not.
	End Rem
	Method Deserialize:dFloatVariable(stream:TStream, tv:Int = True, name:Int = False)
		If tv = True Then stream.ReadByte()
		If name = True Then m_name = dStreamIO.ReadLString(stream)
		m_value = stream.ReadFloat()
		Return Self
	End Method
	
'#end region Data handling
	
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
Type dIntVariable Extends dValueVariable
	
	Field m_value:Int
	
	Rem
		bbdoc: Create a new Int variable.
		returns: Itself.
	End Rem
	Method Create:dIntVariable(name:String = Null, value:Int, parent:dCollectionVariable = Null)
		SetName(name)
		Set(value)
		SetParent(parent)
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
		bbdoc: Get the variable's value with the given format.
		returns: The formatted value.
		about: NOTE: @ValueAsString will give you the unformatted string conversion of the variable's value.
	End Rem
	Method GetValueFormatted:String(format:Int = FMT_INTEGER_DEFAULT)
		If format & FMT_VALUE_QUOTE_ALWAYS
			Return "~q" + m_value + "~q"
		End If
		Return String(m_value)
	End Method
	
	Rem
		bbdoc: Get the variable's value as a string.
		returns: The variable's value converted to a string.
	End Rem
	Method ValueAsString:String()
		Return String(m_value)
	End Method
	
'#end region Field accessors
	
'#region Data handling
	
	Rem
		bbdoc: Create a copy of the variable
		returns: A clone of the variable.
		about: NOTE: A clone has no parent.
	End Rem
	Method Copy:dIntVariable()
		Return New dIntVariable.Create(m_name, m_value, Null)
	End Method
	
	Rem
		bbdoc: Serialize the variable to a stream.
		returns: Nothing.
		about: @tv tells the method whether it should serialize the TV type for the variable, or to not.
	End Rem
	Method Serialize(stream:TStream, tv:Int = True, name:Int = False)
		If tv = True Then stream.WriteByte(TV_INTEGER)
		If name = True Then dStreamIO.WriteLString(stream, m_name)
		stream.WriteInt(m_value)
	End Method
	
	Rem
		bbdoc: Deserialize the variable from a stream.
		returns: Itself.
		about: @tv tells the method whether it should deserialize the TV type for the variable, or to not.
	End Rem
	Method Deserialize:dIntVariable(stream:TStream, tv:Int = True, name:Int = False)
		If tv = True Then stream.ReadByte()
		If name = True Then m_name = dStreamIO.ReadLString(stream)
		m_value = stream.ReadInt()
		Return Self
	End Method
	
'#end region Data handling
	
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
	bbdoc: duct boolean variable.
End Rem
Type dBoolVariable Extends dValueVariable
	
	Field m_value:Int
	
	Rem
		bbdoc: Create a new boolean variable.
		returns: Itself.
	End Rem
	Method Create:dBoolVariable(name:String = Null, value:Int, parent:dCollectionVariable = Null)
		SetName(name)
		Set(value)
		SetParent(parent)
		Return Self
	End Method
	
'#region Field accessors
	
	Rem
		bbdoc: Set the variable's value.
		returns: Nothing.
	End Rem
	Method Set(value:Int)
		m_value = Min(Max(value, False), True)
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
		bbdoc: Get the variable's value with the given format.
		returns: The formatted value.
		about: NOTE: @ValueAsString will give you the unformatted string conversion of the variable's value.
	End Rem
	Method GetValueFormatted:String(format:Int = FMT_BOOL_DEFAULT)
		Local conv:String
		If format & FMT_BOOL_STRING
			If m_value Then conv = "true" Else conv = "false"
		Else
			If m_value Then conv = "1" Else conv = "0"
		End If
		If format & FMT_VALUE_QUOTE_ALWAYS
			Return "~q" + conv + "~q"
		Else
			Return conv
		End If
	End Method
	
	Rem
		bbdoc: Get the dBoolVariable as a String.
		returns: The variable's value converted to a String.
	End Rem
	Method ValueAsString:String()
		Return String(m_value)
	End Method
	
'#end region Field accessors
	
'#region Data handling
	
	Rem
		bbdoc: Create a copy of the variable
		returns: A clone of the variable.
		about: NOTE: A clone has no parent.
	End Rem
	Method Copy:dBoolVariable()
		Return New dBoolVariable.Create(m_name, m_value, Null)
	End Method
	
	Rem
		bbdoc: Serialize the variable to a stream.
		returns: Nothing.
		about: @tv tells the method whether it should serialize the TV type for the variable, or to not.
	End Rem
	Method Serialize(stream:TStream, tv:Int = True, name:Int = False)
		If tv = True Then stream.WriteByte(TV_BOOL)
		If name = True Then dStreamIO.WriteLString(stream, m_name)
		stream.WriteByte(Byte(m_value))
	End Method
	
	Rem
		bbdoc: Deserialize the variable from a stream.
		returns: The deserialized variable.
		about: @tv tells the method whether it should deserialize the TV type for the variable, or to not.
	End Rem
	Method Deserialize:dBoolVariable(stream:TStream, tv:Int = True, name:Int = False)
		If tv = True Then stream.ReadByte()
		If name = True Then m_name = dStreamIO.ReadLString(stream)
		m_value = Int(stream.ReadByte())
		Return Self
	End Method
	
'#end region Data handling
	
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

