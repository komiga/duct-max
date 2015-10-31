
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
bbdoc: Application argument parser
End Rem
Module duct.argparser

ModuleInfo "Version: 0.5"
ModuleInfo "Copyright: Coranna Howard <me@komiga.com>"
ModuleInfo "License: MIT"

ModuleInfo "History: Version 0.5"
ModuleInfo "History: Corrected variable code for duct.variables update"
ModuleInfo "History: Version 0.4"
ModuleInfo "History: Changed parsing for single-dash options"
ModuleInfo "History: Version 0.3"
ModuleInfo "History: Fixed argument parsing for commands"
ModuleInfo "History: Version 0.2"
ModuleInfo "History: Updated for API change"
ModuleInfo "History: Version 0.1"
ModuleInfo "History: Initial version."

Import duct.variables

Rem
	bbdoc: duct argument parser.
End Rem
Type dArgParser
	
	Rem
		bbdoc: Parse the given arguments string array.
		returns: The root identifier containing the parsed arguments.
		about: The expected value does <b>not</b> (by default) contain the first argument of AppArgs (the application location).<br>
		You can override this by passing @fullargs as True. If you leave it as False, the root identifier's name will be set to the first argument (which should be the application location - if you're passing AppArgs).<br>
		@optarglimit limits how many arguments can be given to an option (options start with "--" or "-"). If set to -1, there is no limit.<br>
		Single-dash options (e.g. "-a") are not parsed for arguments, whereas double-dash options (e.g. "--foobar wakka") will be.
	End Rem
	Function ParseArray:dIdentifier(args:String[], fullargs:Int = False, optarglimit:Int = 1)
		Local root:dIdentifier = New dIdentifier.Create()
		If fullargs = True
			root.SetName(args[0])
			args = args[1..]
		End If
		Local arg:String, i:Int, length:Int = args.Length - 1
		Local sub:dIdentifier, subset:Int = False
		optarglimit = (optarglimit = -1) And length Or optarglimit
		For i = 0 To length
			arg = args[i]
			sub = New dIdentifier.Create(arg, Null)
			If arg <> Null And arg[0] = 45 ' "-"
				If arg[1] = 45 ' "-"
					Local lim:Int = Min(length, i + optarglimit)
					i:+1
					While i <= length
						arg = args[i]
						If arg = Null Or arg[0] <> 45 ' "-"
							sub.AddVariable(dVariable.RawToVariable(arg))
							i:+1
							If i > lim
								i:-1
								Exit
							End If
						Else
							i:-1
							Exit
						End If
					End While
					root.AddVariable(sub)
				Else
					root.AddVariable(sub)
				End If
			Else
				If subset = False
					root.AddVariable(sub)
					root = sub
					subset = True
				Else
					root.AddVariable(dVariable.RawToVariable(arg))
				End If
			End If
		Next
		While Not root.GetParent() = Null
			root = dIdentifier(root.GetParent())
		End While
		Return root
	End Function
	
End Type

