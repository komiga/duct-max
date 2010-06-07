
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
bbdoc: JSON handler for cower.jonk
End Rem
Module duct.json

ModuleInfo "Version: 0.5"
ModuleInfo "Copyright: Tim Howard"
ModuleInfo "License: MIT"

ModuleInfo "History: Version 0.5"
ModuleInfo "History: Added GetVariableWithName method to dJObject"
ModuleInfo "History: Version 0.4"
ModuleInfo "History: Updated for API change"
ModuleInfo "History: Version 0.3"
ModuleInfo "History: Corrected rootliness in dJEventHandler"
ModuleInfo "History: Version 0.2"
ModuleInfo "History: dJNullVariable.ValueAsString now returns Null (instead of ~qnull~q); documentation correction"
ModuleInfo "History: Version 0.1"
ModuleInfo "History: Initial version."

Import duct.variables
Import cower.jonk

Rem
	bbdoc: duct JSON object.
End Rem
Type dJObject Extends dIdentifier
	
	Rem
		bbdoc: Create a new dJObject.
		returns: The new dJObject (itself).
	End Rem
	Method Create:dJObject()
		Super.Create()
		Return Self
	End Method
	
	Rem
		bbdoc: Get the object's parent.
		returns: The object's parent.
	End Rem
	Method GetParent:dJObject()
		Return dJObject(m_parent)
	End Method
	
	Rem
		bbdoc: Get the variable with the given name.
		returns: The variable with the given name, or Null if there is no variable with the given name.
	End Rem
	Method GetVariableWithName:dVariable(name:String)
		For Local v:dVariable = EachIn m_values
			If v.m_name = name
				Return v
			End If
		Next
		Return Null
	End Method
	
End Type

Rem
	bbdoc: duct JSON array.
End Rem
Type dJArray Extends dJObject
	
	Rem
		bbdoc: Create a new dJArray.
		returns: The new dJArray (itself).
	End Rem
	Method Create:dJArray()
		Super.Create()
		Return Self
	End Method
	
End Type

Rem
	bbdoc: Template variable type for the #dJNullVariable type.
End Rem
Const TV_NULL:Int = 100

Rem
	bbdoc: duct JSON null variable.
End Rem
Type dJNullVariable Extends dVariable
	
	Rem
		bbdoc: Create a New dJNullVariable.
		returns: The New dJNullVariable (itself).
	End Rem
	Method Create:dJNullVariable(name:String = Null)
		SetName(name)
		Return Self
	End Method
	
'#region Field accessors
	
	Rem
		bbdoc: Set the value of the variable To the given String (ambiguous).
		returns: Nothing.
		about: This does nothing for dJNullVariable.
	End Rem
	Method SetAmbiguous(value:String)
	End Method
	
	Rem
		bbdoc: Convert the variable to a String.
		returns: A string representation of the variable.
		about: This function is for script output, for in-code use see #ValueAsString.
	End Rem
	Method ConvToString:String()
		Return "null"
	End Method
	
	Rem
		bbdoc: Get the variable as a String.
		returns: The variable's value converted to a String.
	End Rem
	Method ValueAsString:String()
		Return Null
	End Method
	
'#end region (Field accessors)
	
'#region Data handling
	
	Rem
		bbdoc: Create a copy of the variable
		returns: A clone of the variable.
	End Rem
	Method Copy:dJNullVariable()
		Return New dJNullVariable.Create(m_name)
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
	End Method
	
	Rem
		bbdoc: Deserialize the variable from a stream.
		returns: The deserialized variable.
		about: @tv tells the method whether it should deserialize the TV type for the variable, or to not.
	End Rem
	Method DeSerialize:dJNullVariable(stream:TStream, tv:Int = True, name:Int = False)
		If tv = True
			stream.ReadByte()
		End If
		If name = True
			m_name = ReadLString(stream)
		End If
		Return Self
	End Method
	
'#end region (Data handling)
	
	Rem
		bbdoc: Get the type of this variable.
		returns: The type of this variable ("null").
	End Rem
	Function ReportType:String()
		Return "null"
	End Function
	
	Rem
		bbdoc: Get the TV type of this variable.
		returns: The TV_* type of this variable (TV_NULL).
	End Rem
	Function GetTVType:Int()
		Return TV_NULL
	End Function
	
End Type

Rem
	bbdoc: duct event handler for JONK.
End Rem
Type dJEventHandler Extends JEventHandler
	
	Field m_objname:String
	Field m_root:dJObject
	Field m_object:dJObject
	
	Field tmpvar:dVariable
	
	Method BeginParsing()
		'm_root = New dJObject.Create()
		'm_object = m_root
	End Method
	
	Method EndParsing()
		'Assert m_object = m_root, "(dJEventHandler.EndParsing) m_object != m_root!"
		m_objname = Null
		m_object = Null
	End Method
	
	Method ObjectBegin()
		tmpvar = New dJObject.Create()
		DoBegin()
	End Method
	
	Method ObjectKey(name:String)
		m_objname = name
	End Method
	
	Method ObjectEnd()
		m_object = dJObject(m_object.GetParent())
	End Method
	
	Method ArrayBegin()
		tmpvar = New dJArray.Create()
		DoBegin()
	End Method
	
	Method ArrayEnd()
		m_object = dJObject(m_object.GetParent())
	End Method
	
	Method NumberValue(number:String, isdecimal:Int)
		If isdecimal = True
			tmpvar = New dFloatVariable.Create(Null, Float(number))
		Else
			tmpvar = New dIntVariable.Create(Null, Int(number))
		End If
		SetAndClearName(tmpvar)
		m_object.AddValue(tmpvar)
	End Method
	
	Method StringValue(value:String)
		tmpvar = New dStringVariable.Create(Null, value)
		SetAndClearName(tmpvar)
		m_object.AddValue(tmpvar)
	End Method
	
	Method BooleanValue(value:Int)
		tmpvar = New dBoolVariable.Create(Null, value)
		SetAndClearName(tmpvar)
		m_object.AddValue(tmpvar)
	End Method
	
	Method NullValue()
		tmpvar = New dJNullVariable.Create(Null)
		SetAndClearName(tmpvar)
		m_object.AddValue(tmpvar)
	End Method
	
	Method Error:Int(err:JParserException)
		Return False
	End Method
	
	Method SetAndClearName(variable:dVariable)
		variable.SetName(m_objname)
		m_objname = Null
	End Method
	
	Method DoBegin()
		SetAndClearName(tmpvar)
		If m_object <> Null m_object.AddValue(tmpvar)
		m_object = dJObject(tmpvar)
		If Not m_root Then m_root = m_object
	End Method
	
End Type

Rem
	bbdoc: duct JSON reader.
End Rem
Type dJReader
	
	Field m_evthandler:dJEventHandler
	Field m_parser:JParser
	Field m_root:dJObject
	
	Method New()
		m_evthandler = New dJEventHandler
	End Method
	
	Rem
		bbdoc: Initiate the reader with the given url/stream.
		returns: Itself, or Null if the stream could not be opened.
	End Rem
	Method InitWithStream:dJReader(url:Object, encoding:Int = JSONEncodingUTF8, bufferLength:Int = JParser.JPARSERBUFFER_INITIAL_SIZE)
		Try
			m_parser = New JParser.InitWithStream(url, m_evthandler, encoding, bufferLength)
			Return Self
		Catch e:JException
			Return Null
		End Try
	End Method
	
	Rem
		bbdoc: Initiate the reader with the given string.
		returns: Itself.
	End Rem
	Method InitWithString:dJReader(str:String)
		m_parser = New JParser.InitWithString(str, m_evthandler)
		Return Self
	End Method
	
	Rem
		bbdoc: Parse the reader's data.
		returns: The root object for the json data.
		about: A #JParserException will be thrown if there is an error during parsing.
	End Rem
	Method Parse:dJObject()
		m_parser.Parse()
		Return m_evthandler.m_root
	End Method
	
End Type

