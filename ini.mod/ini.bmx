
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
bbdoc: Ini parser module
End Rem
Module duct.ini

ModuleInfo "Version: 0.1"
ModuleInfo "Copyright: Tim Howard"
ModuleInfo "License: MIT"

ModuleInfo "History: Version 0.1"
ModuleInfo "History: Initial release"

Import brl.ramstream
Import brl.textstream
Import duct.etc
Import duct.variables
Import cower.charset

Include "src/parser.bmx"

Rem
	bbdoc: duct ini formatter for the variable framework.
End Rem
Type dIniFormatter
	
	Global m_handler:dIniDefaultParserHandler = New dIniDefaultParserHandler
	
'#region Data handling
	
	Rem
		bbdoc: Write the given node to the given file.
		returns: True if the node was written, or False if the path could not be opened.
	End Rem
	Function WriteToFile:Int(root:dNode, path:String, encoding:Int = ENC_UTF8, nameformat:Int = FMT_NAME_DEFAULT, varformat:Int = FMT_ALL_DEFAULT)
		Local stream:TStream = WriteStream(path)
		If stream
			Local ts:TTextStream = TTextStream.Create(stream, encoding)
			WriteToStream(root, ts, "", nameformat, varformat)
			ts.Close()
			stream.Close()
			Return True
		End If
		Return False
	End Function
	
	Rem
		bbdoc: Write the node and its children to a stream.
		returns: Nothing.
		about: NOTE: The given stream is not closed.<br>
		NOTE: Identifiers are unexpected variables for this formatter. They will be ignored.
	End Rem
	Function WriteToStream(root:dNode, stream:TStream, tablevel:String = "", nameformat:Int = FMT_NAME_DEFAULT, varformat:Int = FMT_ALL_DEFAULT)
		If root.m_parent And root.m_name ' Cheap way of saying the node is not a root node
			stream.WriteLine("[" + root.GetNameFormatted(nameformat) + "]")
		End If
		Local value:dValueVariable, node:dNode
		For Local child:dVariable = EachIn root.m_children
			value = dValueVariable(child)
			node = dNode(child)
			If node
				WriteToStream(node, stream, tablevel, nameformat, varformat)
			Else If value
				stream.WriteLine(FormatValue(value))
			Else
				DebugLog("(dIniFormatter.WriteToStream) Unhandled variable: " + child.ToString())
			End If
		Next
	End Function
	
	Rem
		bbdoc: Format the given value variable into a string.
		returns: The formatted value, or Null if the given value does not have a name.
		about: The return format is "<variable_name>=<variable_value>".
	End Rem
	Function FormatValue:String(value:dValueVariable, nameformat:Int = FMT_NAME_DEFAULT, varformat:Int = FMT_ALL_DEFAULT)
		If value.m_name
			Return value.GetNameFormatted(nameformat) + "=" + value.GetValueFormatted(varformat)
		Else
			DebugLog("(dIniFormatter.FormatValue) value name is Null [" + value.ToString() + "]")
		End If
		Return Null
	End Function
	
	Rem
		bbdoc: Load an ini from a stream.
		returns: The root node of the ini, or Null if the given stream was Null.
		about: NOTE: The given stream will not be closed.<br>
		A #dIniException might be thrown if an error occurs in parsing.
	End Rem
	Function LoadFromStream:dNode(stream:TStream, encoding:Int = ENC_UTF8)
		If stream
			Return m_handler.ProcessFromStream(stream, encoding)
		End If
		Return Null
	End Function
	
	Rem
		bbdoc: Load an ini from a file.
		returns: The root node of the ini, or Null if either the given path was Null or the given path could not be opened.
		about: NOTE: The given stream will not be closed.<br>
		A #dIniException might be thrown if an error occurs in parsing.
	End Rem
	Function LoadFromFile:dNode(path:String, encoding:Int = ENC_UTF8)
		Local stream:TStream = ReadStream(path)
		If stream
			Local root:dNode = m_handler.ProcessFromStream(stream, encoding)
			stream.Close()
			Return root
		End If
		Return Null
	End Function
	
	Rem
		bbdoc: Load an ini from a string containing the source.
		returns: The root node of the ini, or Null if the given string was Null.
		about: A #dIniException might be thrown if an error occurs in parsing.
	End Rem
	Function LoadFromString:dNode(data:String, encoding:Int = ENC_UTF8)
		If data
			Return m_handler.ProcessFromString(data, encoding)
		End If
		Return Null
	End Function
	
'#end region Data handling
	
End Type

