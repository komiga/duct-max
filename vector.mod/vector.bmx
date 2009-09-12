
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
bbdoc: Vector module
End Rem
Module duct.vector

ModuleInfo "Version: 0.25"
ModuleInfo "Copyright: Tim Howard"
ModuleInfo "Author: Yahfree (most of TVec2, public domain), modified and adapted to duct by Plash (Tim Howard)"
ModuleInfo "License: MIT"

ModuleInfo "History: Version 0.25"
ModuleInfo "History: Added DeSerialize and Serialize methods to all vector types"
ModuleInfo "History: Changed formatting"
ModuleInfo "History: Version 0.24"
ModuleInfo "History: Whoops! Forgot to include vec4.bmx, also found and corrected a slight documentation issue"
ModuleInfo "History: Version 0.23"
ModuleInfo "History: Added TVec4 and changed Assert formats"
ModuleInfo "History: Version 0.22"
ModuleInfo "History: Added Assertions for vector <-> vector operations"
ModuleInfo "History: Version 0.21"
ModuleInfo "History: Removed TVec2.DivideVec, DivideVecNew and TVec3.DivideVec, DivideVecNew - Vectors can only be divided by a scalar (change made by )"
ModuleInfo "History: Version 0.2"
ModuleInfo "History: Added/renamed methods for operations via parameters, vectors, and a version of both types to return new vectors [for the Vec2 and Vec3 types]"
ModuleInfo "History: General code cleanup"
ModuleInfo "History: Version 0.1"
ModuleInfo "History: Added TVec3 type (some methods/functions may be incorrect)"
ModuleInfo "History: Added Get and Set methods (get/set both vector values at the same time)"
ModuleInfo "History: Formaterized and modified from Yahfree's code (http://www.blitzbasic.com/codearcs/codearcs.php?code=2320)"

' Used modules
Import brl.math
Import brl.stream

Private

Function TrueMod:Float(val:Float, modul:Short)
	val:Mod modul
	If val < 0 Then val:+modul
	Return val
End Function

Public

' Included code
Include "inc/types/vec2.bmx"
Include "inc/types/vec3.bmx"
Include "inc/types/vec4.bmx"











