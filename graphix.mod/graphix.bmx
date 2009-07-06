
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
bbdoc: Extended graphics module
about: This module needs a large amount of work.
End Rem
Module duct.graphix

ModuleInfo "Version: 0.12"
ModuleInfo "Copyright: Tim Howard"
ModuleInfo "License: MIT"

ModuleInfo "History: Version 0.12"
ModuleInfo "History: Added driver contexts to TDGraphics for more direct access"
ModuleInfo "History: Updated TDGraphicsApp - uses more standardized flow: Update (logic) and Render (drawing)"
ModuleInfo "History: Implemented handling for the duct.glmax2dext driver"
ModuleInfo "History: Version 0.11"
ModuleInfo "History: General code cleanup"
ModuleInfo "History: Version 0.1"
ModuleInfo "History: Initial version"

' Used modules
Import brl.Graphics
Import brl.max2d

Import brl.glmax2d
?Win32
	Import brl.d3d7max2d
?

Import duct.glmax2dext

Import duct.app
Import duct.objectmap
Import duct.animations
Import duct.vector


' Included code
Include "inc/types/dgraphics.bmx"
Include "inc/types/entity.bmx"
Include "inc/types/gapp.bmx"
Include "inc/types/etc.bmx"





























