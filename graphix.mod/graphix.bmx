
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
bbdoc: duct graphics app module
End Rem
Module duct.graphix

ModuleInfo "Version: 0.18"
ModuleInfo "Copyright: plash <plash@komiga.com>"
ModuleInfo "License: MIT"

ModuleInfo "History: Version 0.18"
ModuleInfo "History: Removed unnecessary New method in dGraphicsApp"
ModuleInfo "History: Version 0.17"
ModuleInfo "History: Fixed documentation, license"
ModuleInfo "History: Renamed TDGraphicsApp to dGraphicsApp"
ModuleInfo "History: Version 0.16"
ModuleInfo "History: General cleanup"
ModuleInfo "History: Version 0.15"
ModuleInfo "History: Changed dGraphicsApp to be extension-safe, removed dependency on Protog2D (TDProtogGraphicsApp is in Protog2D now)"
ModuleInfo "History: Changed some more formatting"
ModuleInfo "History: Removed TDEntity and TDColor (types now handled by Protog2D)"
ModuleInfo "History: Version 0.14"
ModuleInfo "History: Changed some formatting"
ModuleInfo "History: Version 0.13"
ModuleInfo "History: Removed dependencies on any Max2D-related stuff (this module is entirely Protog2D now)"
ModuleInfo "History: Version 0.12"
ModuleInfo "History: Added some asserts for vsync, graphics window creation and incorrect drivers"
ModuleInfo "History: Added driver contexts to TDGraphics for more direct access"
ModuleInfo "History: Updated dGraphicsApp - uses more standardized flow: Update (logic) and Render (drawing)"
ModuleInfo "History: Implemented handling for the duct.glmax2dext driver"
ModuleInfo "History: Version 0.11"
ModuleInfo "History: General code cleanup"
ModuleInfo "History: Version 0.1"
ModuleInfo "History: Initial version"

Import duct.app

Rem
	bbdoc: Wrapper type for graphical applications (extend this).
End Rem
Type dGraphicsApp Extends dApp
	
	Rem
		bbdoc: Create a new app.
		returns: Itself.
	End Rem
	Method Create:dGraphicsApp()
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
	
	Rem
		bbdoc: Do any rendering.
		returns: Nothing.
	End Rem
	Method Render() Abstract
	
	Rem
		bbdoc: Do logic updates (fps, mouse & keyboard input, etc).
		returns: Nothing.
	End Rem
	Method Update() Abstract
	
	Rem
		bbdoc: Shutdown the app.
		returns: Nothing.
		about: This will call OnExit.
	End Rem
	Method Shutdown()
		OnExit()
	End Method
	
End Type

