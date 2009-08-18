
Rem
	Copyright (c) 2009 Tim Howard
	
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

ModuleInfo "Version: 0.48"
ModuleInfo "Copyright: Tim Howard"
ModuleInfo "License: MIT"

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


' Used modules
Import brl.ramstream
Import brl.textstream
Import brl.linkedlist
Import brl.filesystem

Import duct.variables

Import cower.charset

' Included source code
Include "inc/types/snode.bmx"
Include "inc/types/parser.bmx"






















