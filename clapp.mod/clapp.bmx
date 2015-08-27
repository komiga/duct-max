
Rem
Copyright (c) 2010 plash <plash@komiga.com>

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
bbdoc: Command line application stub
End Rem
Module duct.clapp

ModuleInfo "Version: 0.1"
ModuleInfo "Copyright: plash <plash@komiga.com>"
ModuleInfo "License: MIT"

ModuleInfo "History: Version 0.1"
ModuleInfo "History: Initial release"

Import duct.app
Import duct.variables
Import duct.argparser
Import duct.arghandling

Rem
	bbdoc: duct command-line application.
End Rem
Type dCLApp Extends dApp Abstract
	
	Field m_arguments:dIdentifier
	Field m_arghandler:dArgumentHandler
	
	Rem
		bbdoc: This method is called when the app is initialized.
		returns: Nothing.
		about: NOTE: Call Super.OnInit in extending types to initialize the argument handler.
	End Rem
	Method OnInit()
		m_arghandler = New dArgumentHandler.Create()
	End Method
	
'#region Field accessors
	
	Rem
		bbdoc: Set the application's arguments (commonly AppArgs).
		returns: Nothing.
		about: The last two parameters are the same as in dArgParser.ParseArray.
	End Rem
	Method ParseArguments(arguments:String[], fullargs:Int = False, optarglimit:Int = 1)
		m_arguments = dArgParser.ParseArray(arguments, fullargs, optarglimit)
	End Method
	
	Rem
		bbdoc: Get the application's argument handler.
		returns: The application's argument handler.
	End Rem
	Method GetArgumentHandler:dArgumentHandler()
		Return m_arghandler
	End Method
	
'#end region Field accessors
	
End Type

