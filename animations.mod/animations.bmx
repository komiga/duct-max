
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
bbdoc: 2D animations module
End Rem
Module duct.animations

ModuleInfo "Version: 0.20"
ModuleInfo "Credits: Indiepath for the initial single surface code"
ModuleInfo "Copyright: Tim Howard"
ModuleInfo "License: MIT"

ModuleInfo "History: Version 0.20"
ModuleInfo "History: Fixed changed dependency (imports duct.imageio)"
ModuleInfo "History: Version 0.19"
ModuleInfo "History: General code cleanup"
ModuleInfo "History: Version 0.18"
ModuleInfo "History: Updated to use objectio (image reading and writing) for serialization and deserialization"
ModuleInfo "History: Version 0.17"
ModuleInfo "History: Initial release"

' Used modules
Import brl.stream

Import brl.glmax2d
?Win32
	Import brl.d3d7max2d
?

Import brl.pngloader
Import brl.bmploader
Import brl.jpgloader

Import duct.imageio
Import duct.etc


' Included code
Include "inc/types/animation.bmx"




























