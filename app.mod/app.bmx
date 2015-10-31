
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
bbdoc: Application stub module
End Rem
Module duct.app

ModuleInfo "Version: 0.4"
ModuleInfo "Copyright: Coranna Howard <me@komiga.com>"
ModuleInfo "License: MIT"

ModuleInfo "History: Version 0.4"
ModuleInfo "History: Fixed documentation"
ModuleInfo "History: Renamed TDApp to dApp"
ModuleInfo "History: Merged includes"
ModuleInfo "History: Version 0.3"
ModuleInfo "History: Added OnExit method to TDApp"
ModuleInfo "History: Version 0.2"
ModuleInfo "History: General cleanup"
ModuleInfo "History: Version 0.1"
ModuleInfo "History: Initial version."

Import brl.blitz

Rem
	bbdoc: duct abstract base for wxMax-style applications.
End Rem
Type dApp Abstract
	
	Method New()
	End Method
	
	Rem
		bbdoc: Create a new app.
		returns: The new app (itself).
	End Rem
	Method Create:dApp()
		OnInit()
		Return Self
	End Method
	
	Rem
		bbdoc: This method is called when the app is initialized.
		returns: Nothing.
	End Rem
	Method OnInit() Abstract
	
	Rem
		bbdoc: This method is called when the app is shutdown.
		returns: Nothing.
	End Rem
	Method OnExit() Abstract
	
	Rem
		bbdoc: Run the app.
		returns: Nothing.
	End Rem
	Method Run() Abstract
	
End Type

