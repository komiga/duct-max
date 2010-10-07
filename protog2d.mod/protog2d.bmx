
Rem
Copyright (c) 2010 Tim Howard

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

ModuleInfo "Version: 1.0"
ModuleInfo "Copyright: Tim Howard"
ModuleInfo "License: MIT"

ModuleInfo "History: Version 1.0"
ModuleInfo "History: General cleanup"
ModuleInfo "History: Renamed *ByName methods to *WithName"
ModuleInfo "History: Version 0.9"
ModuleInfo "History: General cleanup"
ModuleInfo "History: Updated for duct.objectmap changes"
ModuleInfo "History: Added GetDefaultState, SetDefaultStates and StoreDefaultStates functions to dProtogDrawState"
ModuleInfo "History: Renamed the dProtogDrawState.InitiateDefaultState function to InitDefaultState"
ModuleInfo "History: Renamed dProtogDrawState.*ColorsState to *ColorStates"
ModuleInfo "History: Renamed dProtog2DCollision to dProtogCollision"
ModuleInfo "History: Renamed 'Draw' to 'Render' in methods and functions"
ModuleInfo "History: Added Set and Get methods to dProtogColor"
ModuleInfo "History: Adapted to duct.etc changes"
ModuleInfo "History: Corrected variable code for duct.variables update"
ModuleInfo "History: Moved inc/ to src/"
ModuleInfo "History: Version 0.8"
ModuleInfo "History: Restructured includes"
ModuleInfo "History: Fixed documentation, licenses, examples"
ModuleInfo "History: Renamed _TShaderSource to _dShaderSource"
ModuleInfo "History: Renamed TShaderAssist to dShaderAssist"
ModuleInfo "History: Renamed TDProtog* types to dProtog*"
ModuleInfo "History: Renamed TProtog* types to dProtog*"
ModuleInfo "History: Updated for API change"
ModuleInfo "History: Version 0.7"
ModuleInfo "History: General cleanup"
ModuleInfo "History: Version 0.6"
ModuleInfo "History: Added TProtogTexture.RenderToPosParams"
ModuleInfo "History: Fixed font string width calculation (was returning 0.0 for strings that did /not/ contain a newline character)"
ModuleInfo "History: Added TProtogDrawState"
ModuleInfo "History: Added some state getters/setters"
ModuleInfo "History: Added some viewport-related functions to TProtog2DDriver"
ModuleInfo "History: Added TProtogPrimitives and line width access"
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
Import brl.graphics
Import brl.glgraphics

Import duct.etc
Import duct.intmap
Import duct.objectmap
Import duct.objectio
Import duct.vector
Import duct.graphix
Import duct.variables

Include "src/protog.bmx"
Include "src/program.bmx"
Include "src/param.bmx"
Include "src/material.bmx"
Include "src/texture.bmx"
Include "src/fbo.bmx"
Include "src/font.bmx"
Include "src/entity.bmx"
Include "src/collision.bmx"
Include "src/color.bmx"
Include "src/primitives.bmx"
Include "src/drawstate.bmx"

Include "src/app.bmx"

