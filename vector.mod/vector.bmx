
' Copyright (c) 2009 Tim Howard
' 
' Permission is hereby granted, free of charge, to any person obtaining a copy
' of this software and associated documentation files (the "Software"), to deal
' in the Software without restriction, including without limitation the rights
' to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
' copies of the Software, and to permit persons to whom the Software is
' furnished to do so, subject to the following conditions:
' 
' The above copyright notice and this permission notice shall be included in
' all copies or substantial portions of the Software.
' 
' THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
' IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
' FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
' AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
' LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
' OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
' THE SOFTWARE.
' 

SuperStrict

Rem
bbdoc: The vector module
End Rem
Module duct.vector

ModuleInfo "Version: 0.1"
ModuleInfo "Copyright: Tim Howard"
ModuleInfo "Author: Yahfree (public domain), modified and adapted to duct by Plash (Tim Howard)"
ModuleInfo "License: MIT"

ModuleInfo "History: Version 0.1"
ModuleInfo "History: Added TVec3 type (some methods/functions may be incorrect)"
ModuleInfo "History: Added Get and Set methods (get/set both vector values at the same time)"
ModuleInfo "History: Formaterized and modified from Yahfree's code (http://www.blitzbasic.com/codearcs/codearcs.php?code=2320)"

'Used modules
Import brl.math

Private

Function TrueMod:Float(val:Float, modul:Short)
	
	val:Mod modul
	
	If val < 0 Then val:+modul
	
	Return val
	
End Function

Public

'Included code
Include "inc/types/vec2.bmx"
Include "inc/types/vec3.bmx"
























