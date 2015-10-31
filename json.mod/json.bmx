
Rem
Copyright (c) 2010 Coranna Howard <me@komiga.com>

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

ModuleInfo "Version: 0.7"
ModuleInfo "Copyright: Coranna Howard <me@komiga.com>"
ModuleInfo "License: MIT"

ModuleInfo "History: Version 0.7"
ModuleInfo "History: Added LoadFromString, LoadFromStream and LoadFromFile functions to dJReader"
ModuleInfo "History: Version 0.6"
ModuleInfo "History: General cleanup"
ModuleInfo "History: Renamed TV_NULL to TV_JSON_NULL"
ModuleInfo "History: Corrected variable code for duct.variables update"
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
		bbdoc: Create a dJObject.
		returns: Itself.
	End Rem
	Method Create:dJObject(name:String = Null, parent:dCollectionVariable = Null, children:TListEx = Null)
		Super.Create(name, parent, children)
		Return Self
	End Method
	
	Rem
		bbdoc: Get the object's parent.
		returns: The object's parent.
	End Rem
	Method GetParent:dJObject()
		Return dJObject(m_parent)
	End Method
	
End Type

Rem
	bbdoc: duct JSON array.
End Rem
Type dJArray Extends dJObject
	
	Rem
		bbdoc: Create a dJArray.
		returns: Itself.
	End Rem
	Method Create:dJArray(name:String = Null, parent:dCollectionVariable = Null, children:TListEx = Null)
		Super.Create(name, parent, children)
		Return Self
	End Method
	
End Type

Rem
	bbdoc: Template variable type for the #dJNullVariable type.
End Rem
Const TV_JSON_NULL:Int = 32

Rem
	bbdoc: duct JSON null variable.
End Rem
Type dJNullVariable Extends dValueVariable
	
	Rem
		bbdoc: Create a dJNullVariable.
		returns: Itself.
	End Rem
	Method Create:dJNullVariable(name:String = Null)
		SetName(name)
		Return Self
	End Method
	
'#region Field accessors
	
	Rem
		bbdoc: Set the value of the variable to the given string (ambiguous).
		returns: Nothing.
		about: NOTE: This does nothing for dJNullVariable.
	End Rem
	Method SetAmbiguous(value:String)
	End Method
	
	Rem
		bbdoc: Get the variable's value with the given format.
		returns: The formatted value.
	End Rem
	Method GetValueFormatted:String(format:Int = 0)
		If format & FMT_VALUE_QUOTE_ALWAYS
			Return "~qnull~q"
		Else
			Return "null"
		End If
	End Method
	
	Rem
		bbdoc: Get the variable as a string.
		returns: Null.
	End Rem
	Method ValueAsString:String()
		Return Null
	End Method
	
'#end region Field accessors
	
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
			dStreamIO.WriteLString(stream, m_name)
		End If
	End Method
	
	Rem
		bbdoc: Deserialize the variable from a stream.
		returns: Itself.
		about: @tv tells the method whether it should deserialize the TV type for the variable, or to not.
	End Rem
	Method Deserialize:dJNullVariable(stream:TStream, tv:Int = True, name:Int = False)
		If tv = True Then stream.ReadByte()
		If name = True Then m_name = dStreamIO.ReadLString(stream)
		Return Self
	End Method
	
'#end region Data handling
	
	Rem
		bbdoc: Get the type of this variable.
		returns: The type of this variable ("null").
	End Rem
	Function ReportType:String()
		Return "null"
	End Function
	
	Rem
		bbdoc: Get the TV type of this variable.
		returns: The TV_* type of this variable (TV_JSON_NULL).
	End Rem
	Function GetTVType:Int()
		Return TV_JSON_NULL
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
		If isdecimal
			tmpvar = New dFloatVariable.Create(Null, Float(number))
		Else
			tmpvar = New dIntVariable.Create(Null, Int(number))
		End If
		SetAndClearName(tmpvar)
		m_object.AddVariable(tmpvar)
	End Method
	
	Method StringValue(value:String)
		tmpvar = New dStringVariable.Create(Null, value)
		SetAndClearName(tmpvar)
		m_object.AddVariable(tmpvar)
	End Method
	
	Method BooleanValue(value:Int)
		tmpvar = New dBoolVariable.Create(Null, value)
		SetAndClearName(tmpvar)
		m_object.AddVariable(tmpvar)
	End Method
	
	Method NullValue()
		tmpvar = New dJNullVariable.Create(Null)
		SetAndClearName(tmpvar)
		m_object.AddVariable(tmpvar)
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
		If m_object Then m_object.AddVariable(tmpvar)
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
	Method InitWithStream:dJReader(stream:TStream, encoding:Int = ENC_UTF8, bufferlength:Int = JParser.JPARSERBUFFER_INITIAL_SIZE)
		Try
			m_parser = New JParser.InitWithStream(stream, m_evthandler, encoding, bufferlength)
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
		returns: The root object.
		about: A #JParserException will be thrown if there is an error during parsing.
	End Rem
	Method Parse:dJObject()
		m_parser.Parse()
		Return m_evthandler.m_root
	End Method
	
	Rem
		bbdoc: Load a file containing JSON data.
		returns: The root object, or Null if an error occurred.
		A #JParserException will be thrown if there is an error during parsing.
	End Rem
	Function LoadFromFile:dJObject(path:String, encoding:Int = ENC_UTF8, bufferlength:Int = JParser.JPARSERBUFFER_INITIAL_SIZE)
		Local stream:TStream = ReadStream(path)
		If stream
			Local root:dJObject = LoadFromStream(stream, encoding, bufferlength)
			stream.Close()
			Return root
		End If
		Return Null
	End Function
	
	Rem
		bbdoc: Load a JSON object from the given stream.
		returns: The root object, or Null if either an error occurred or the given stream was Null.
		about: NOTE: The given stream will not be closed.
	End Rem
	Function LoadFromStream:dJObject(stream:TStream, encoding:Int = ENC_UTF8, bufferlength:Int = JParser.JPARSERBUFFER_INITIAL_SIZE)
		If stream
			If Not dCloseGuardStreamWrapper(stream)
				stream = New dCloseGuardStreamWrapper.Create(stream) ' Protect the stream from being closed (merge this into cower.jonk)
			End If
			Local parser:dJReader = New dJReader.InitWithStream(stream, encoding, bufferlength)
			If parser
				Return parser.Parse()
			End If
		End If
		Return Null
	End Function
	
	Rem
		bbdoc: Load a JSON object from the given string.
		returns: The root object, or Null if either the given string was Null or an error occurred.
	End Rem
	Function LoadFromString:dJObject(str:String)
		If str
			Local parser:dJReader = New dJReader.InitWithString(str)
			If parser
				Return parser.Parse()
			End If
		End If
		Return Null
	End Function
	
End Type

