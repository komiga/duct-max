
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
bbdoc: Scriptparser module
End Rem
Module duct.scriptparser

ModuleInfo "Version: 1.0"
ModuleInfo "Copyright: Tim Howard"
ModuleInfo "License: MIT"

ModuleInfo "History: Version 1.0"
ModuleInfo "History: Corrected some documentation"
ModuleInfo "History: Added Finish method to dScriptParserHandler as a safeguard"
ModuleInfo "History: Fixed dScriptParser non-newline-ending parsing (EOFToken was never sent)"
ModuleInfo "History: Fixed dScriptParser.InitWithString (crash due to incorrect data handling)"
ModuleInfo "History: Renamed dSNodeParserException"
ModuleInfo "History: Renamed dSNodeDefaultParserHandler to dScriptDefaultParserHandler"
ModuleInfo "History: Renamed dSNodeParserHandler to dScriptParserHandler"
ModuleInfo "History: Renamed dSNodeParser to dScriptParser"
ModuleInfo "History: Renamed dSNodeToken to dScriptToken"
ModuleInfo "History: Added dScriptFormatter.FormatValue and dScriptFormatter.FormatIdentifier"
ModuleInfo "History: Renamed dScriptFormatter.LoadScriptFromString to dScriptFormatter.LoadFromString"
ModuleInfo "History: Removed dScriptFormatter.LoadScriptFromObject; added dScriptFormatter.LoadFromFile and dScriptFormatter.LoadFromStream"
ModuleInfo "History: Replaced dSNode with dScriptFormatter (static format handler type)"
ModuleInfo "History: Got rid of EvalVariable stuff, moved inc/ to src/"
ModuleInfo "History: Version 0.9"
ModuleInfo "History: Added bool-from-string support in dSNodeDefaultParserHandler"
ModuleInfo "History: Version 0.8"
ModuleInfo "History: Added multi-line quoted-string support"
ModuleInfo "History: Version 0.7"
ModuleInfo "History: Fixed eval variable parsing"
ModuleInfo "History: Fixed documentation, licenses, examples"
ModuleInfo "History: Renamed TSNode* types to dSNode*"
ModuleInfo "History: Added TV_BOOL support to dTemplate"
ModuleInfo "History: Updated for API change"
ModuleInfo "History: Version 0.6"
ModuleInfo "History: General cleanup"
ModuleInfo "History: Version 0.50"
ModuleInfo "History: General cleanup"
ModuleInfo "History: Fixed encoding references in TSNode.LoadScriptFromObject() and TSNode.LoadScriptFromString()"
ModuleInfo "History: Version 0.49"
ModuleInfo "History: Added parser encoding constants"
ModuleInfo "History: Changed TSNodeToken to use a buffer"
ModuleInfo "History: Fixed digit reading (never added the decimal point)"
ModuleInfo "History: Fixed the templates example"
ModuleInfo "History: Added GetIdentifierByTemplate to TSNode"
ModuleInfo "History: Moved duct.template here (needed to use the TTemplate type in the TSNode type)"
ModuleInfo "History: Changed some formatting"
ModuleInfo "History: Version 0.48"
ModuleInfo "History: Eval variable identification changed to '/e:'"
ModuleInfo "History: Removed support for the line-continuance feature ('/>>' in a script)"
ModuleInfo "History: Revamped parser (now tokenized)"
ModuleInfo "History: Changed type tabbing"
ModuleInfo "History: Version 0.44"
ModuleInfo "History: General code cleanup"
ModuleInfo "History: Moved TSNode.LoadScriptFromStream().RawToVariable() to TVariable.RawToVariable()"
ModuleInfo "History: Version 0.43"
ModuleInfo "History: Merged identifier and node lists (for the benifit of positioning)"
ModuleInfo "History: Fixed: TSNode.WriteToStream() did not return True when it succeeded to write the node"
ModuleInfo "History: Added: New-lines between identifier-nodes and node-node in TSNode.WriteToStream()"
ModuleInfo "History: Fixed: TSNode.LoadScriptFromFile() did not close the stream before returning"
ModuleInfo "History: Added: Support for single-line nodes"
ModuleInfo "History: Cleaned up some sections of the code"
ModuleInfo "History: Version 0.42"
ModuleInfo "History: Added abrupt EOL parsing (usage: />>)"
ModuleInfo "History: Version 0.24"
ModuleInfo "History: Added Eval variable parsing"
ModuleInfo "History: Version 0.12"
ModuleInfo "History: Initial release"

Import brl.ramstream
Import brl.textstream
Import duct.etc
Import duct.variables
Import cower.charset

Include "src/parser.bmx"

Rem
	bbdoc: duct Quake-style script formatter for the variable framework.
End Rem
Type dScriptFormatter
	
	Global m_handler:dScriptDefaultParserHandler = New dScriptDefaultParserHandler
	
'#region Data handling
	
	Rem
		bbdoc: Write the given node to the given file.
		returns: True if the node was written, or False if the path could not be opened.
	End Rem
	Function WriteToFile:Int(root:dNode, path:String, encoding:Int = ENC_UTF8, nameformat:Int = FMT_NAME_DEFAULT, varformat:Int = FMT_ALL_DEFAULT)
		Local stream:TStream = WriteStream(path)
		If stream
			Local ts:TTextStream = New TTextStream.Create(stream, encoding)
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
		about: NOTE: The given stream is not closed.
	End Rem
	Function WriteToStream(root:dNode, stream:TStream, tablevel:String = "", nameformat:Int = FMT_NAME_DEFAULT, varformat:Int = FMT_ALL_DEFAULT)
		Local tableveld:String
		If root.m_parent
			If root.m_name
				stream.WriteLine(tablevel + root.GetNameFormatted() + " {")
			Else
				stream.WriteLine(tablevel + "{")
			End If
			tableveld = tablevel + "~t"
		Else
			'stream.WriteLine("")
			tableveld = tablevel
		End If
		Local iden:dIdentifier, node:dNode, value:dValueVariable, writtenvariable:Int
		For Local child:dVariable = EachIn root.m_children
			value = dValueVariable(child)
			iden = dIdentifier(child)
			node = dNode(child)
			If Not node And Not child.m_name
				DebugLog("(dScriptFormatter.WriteToStream) Ignored dValueVariable or dIdentifier because of null name [" + value.ToString() + "]")
			Else
				If value
					stream.WriteLine(tableveld + FormatValue(value))
					writtenvariable = True
				Else If iden
					stream.WriteLine(tableveld + FormatIdentifier(iden))
					writtenvariable = True
				Else If node
					If Not root.m_parent And writtenvariable Then stream.WriteLine(tableveld)
					WriteToStream(node, stream, tableveld, nameformat, varformat)
					If Not root.m_parent Then stream.WriteLine(tableveld)
					writtenvariable = False
				End If
			End If
		Next
		If root.m_parent
			stream.WriteLine(tablevel + "}")
		End If
	End Function
	
	Rem
		bbdoc: Format the given identifier into a string.
		returns: The formatted identifier, or Null if the given identifier does not have a name.
		about: The return format is "<identifier_name> <variable_value> <variable_value> <variable_value> ...".
	End Rem
	Function FormatIdentifier:String(iden:dIdentifier, nameformat:Int = FMT_NAME_DEFAULT, varformat:Int = FMT_ALL_DEFAULT)
		If iden.m_name
			Local op:String = iden.GetNameFormatted(nameformat)
			If iden.GetChildCount()
				For Local variable:dValueVariable = EachIn iden.m_children
					op:+ " " + variable.GetValueFormatted(varformat)
				Next
			End If
			Return op
		Else
			DebugLog("(dScriptFormatter.FormatIdentifier) identifier name is Null [" + iden.ToString() + "]")
		End If
		Return Null
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
			DebugLog("(dScriptFormatter.FormatValue) value name is Null [" + value.ToString() + "]")
		End If
		Return Null
	End Function
	
	Rem
		bbdoc: Load a script from a file.
		returns: The root node of the script, or Null if the path could not be opened.
		about: A #dScriptException might be thrown if an error occurs in parsing.
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
		bbdoc: Load a script from the given stream.
		returns: The root node of the script, or Null if the stream given was Null.
		about: A #dScriptException might be thrown if an error occurs in parsing.<br>
		NOTE: The given stream will not be closed.
	End Rem
	Function LoadFromStream:dNode(stream:TStream, encoding:Int = ENC_UTF8)
		If stream
			Return m_handler.ProcessFromStream(stream, encoding)
		End If
		Return Null
	End Function
	
	Rem
		bbdoc: Load a script from a string containing the source.
		returns: The root node of the script, or Null if the given string was Null.
		about: A #dScriptException might be thrown if an error occurs in parsing.
	End Rem
	Function LoadFromString:dNode(data:String, encoding:Int = ENC_UTF8)
		If data
			Return m_handler.ProcessFromString(data, encoding)
		End If
		Return Null
	End Function
	
'#end region Data handling
	
End Type

