
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
bbdoc: Protog OpenGL 2D graphics engine
End Rem
Module duct.protog2d

ModuleInfo "Version: 0.2"
ModuleInfo "Copyright: Tim Howard"
ModuleInfo "License: MIT"

ModuleInfo "History: 0.2"
ModuleInfo "History: Implemented TProtogFrameBuffer and most other types for shaders and materials"
ModuleInfo "History: 0.1"
ModuleInfo "History: Removed dependencies on brl.max2d and changed interface"
ModuleInfo "History: Added pub.glew init calls and renamed several things"
ModuleInfo "History: Code copied from http://www.blitzbasic.com/Community/posts.php?topic=85304"

Import brl.standardio
Import brl.ramstream

Import pub.glew
Import brl.Graphics
Import brl.GLGraphics

Import duct.etc
Import duct.objectmap
Import duct.objectio
Import duct.vector

' Included code
Include "inc/types/protog.bmx"
Include "inc/types/program.bmx"
Include "inc/types/param.bmx"
Include "inc/types/material.bmx"
Include "inc/types/texture.bmx"
Include "inc/types/fbo.bmx"

































