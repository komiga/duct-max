
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

ModuleInfo "Version: 0.5"
ModuleInfo "Copyright: Tim Howard"
ModuleInfo "License: MIT"

ModuleInfo "History: Version 0.5"
ModuleInfo "History: Lots of changes.."
ModuleInfo "History: Added TProtogSpriteEntity"
ModuleInfo "History: Fixed (probably) the rendering setup for shaders (not sure why, but using a vertex shader screws the rest up - probably a fault in the matrix or something)"
ModuleInfo "History: Fixed shader binding (order was backwards)"
ModuleInfo "History: Protog2D DGraphics and DGraphics app implemented here (moved from graphix)"
ModuleInfo "History: Trying out a different implementation of the Protog2D base"
ModuleInfo "History: Version 0.4"
ModuleInfo "History: Added the Bind method to TProtogAnimTexture and TProtogTexture"
ModuleInfo "History: Added TProtogIntParam and TProtogVec2ArrayParam"
ModuleInfo "History: Changed all TGL* param types to TProtog*, changed TGLSLParam to TProtogShaderParam and TGLProgram to TProtogShader"
ModuleInfo "History: Added TTextReplacer support for TProtogTextEntity"
ModuleInfo "History: Fixed ModuleInfo formatting for different versions"
ModuleInfo "History: Added a tracking map for TProtogFont"
ModuleInfo "History: Added TProtogEntity, TProtogTextEntity and TProtogColor"
ModuleInfo "History: Added/fixed some documentation"
ModuleInfo "History: Some more formatting changes"
ModuleInfo "History: Version 0.3"
ModuleInfo "History: Some formatting changes"
ModuleInfo "History: Made TProtog2DDriver and TProtog2DGraphics independent of TGLGraphicsDriver and TGLGraphics (still uses the C code for them, though)"
ModuleInfo "History: Implemented TProtogFont (single-surface font handler)"
ModuleInfo "History: Version 0.2"
ModuleInfo "History: Implemented TProtogFrameBuffer and most other types for shaders and materials"
ModuleInfo "History: Version 0.1"
ModuleInfo "History: Removed dependencies on brl.max2d and changed interface"
ModuleInfo "History: Added pub.glew init calls and renamed several things"
ModuleInfo "History: Code copied from http://www.blitzbasic.com/Community/posts.php?topic=85304"

Import brl.standardio
Import brl.ramstream

Import pub.glew
Import brl.pixmap
Import brl.Graphics
Import brl.GLGraphics

Import duct.etc
Import duct.intmap
Import duct.objectmap
Import duct.objectio
Import duct.vector
Import duct.graphix
Import duct.scriptparser

' Included code
Include "inc/types/protog.bmx"
Include "inc/types/program.bmx"
Include "inc/types/param.bmx"
Include "inc/types/material.bmx"
Include "inc/types/texture.bmx"
Include "inc/types/fbo.bmx"
Include "inc/types/font.bmx"
Include "inc/types/entity.bmx"
Include "inc/types/color.bmx"

Include "inc/types/app.bmx"








