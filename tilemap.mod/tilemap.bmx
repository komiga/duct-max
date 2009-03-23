
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
bbdoc: Tile map module
End Rem
Module duct.tilemap

ModuleInfo "Version: 0.064"
ModuleInfo "Copyright: Tim Howard"
ModuleInfo "License: MIT"

ModuleInfo "History: Version 0.064"
ModuleInfo "History: "
ModuleInfo "History: Fixed DirectX terrain rendering (height changes with the system was only changed for OpenGL rendering)"
ModuleInfo "History: Switched collision method to use max2d collision layers"
ModuleInfo "History: Hacked a fix for leaking glmax2d states (because Mark likes to be very closed doors with the graphics drivers :( )"
ModuleInfo "History: Added basic static object actions, updated serialization and deserialization (requires format change for existing maps)"
ModuleInfo "History: Changed slightly confusing SetHeight and GetHeight methods in TDrawnObject to SetZ and GetZ"
ModuleInfo "History: Changed the terrain and statics arrays to use multi-dimensions instead of array of array (easier to manage)"
ModuleInfo "History: Version 0.063"
ModuleInfo "History: Added: Simple tile shading and map environment type (TMapEnvironment, ambient color and light position)"
ModuleInfo "History: Changed: TTileMatrix to TTileQuad, all previous uses of TPoint changed to use TVec2"
ModuleInfo "History: Fixed: TTileMap.Draw was not setting the drawntile before calling map handler functions"
ModuleInfo "History: Version 0.062"
ModuleInfo "History: Fixed IsPointInsideTile function"
ModuleInfo "History: Changed types to be more understandable"
ModuleInfo "History: Another code & documentation cleanup"
ModuleInfo "History: Changed debug and tile-to-screen-position collision handling (through the TTileMapHandler type)"
ModuleInfo "History: Added support for DirectX (removed special handling for textures, now uses TImages)"
ModuleInfo "History: Version 0.061"
ModuleInfo "History: Cleaned up documentation and code"
ModuleInfo "History: Fixed tile rendering flaw"

'Used modules
Import duct.objectmap
Import duct.objectio
Import duct.vector
Import duct.etc

Import brl.pixmap
Import brl.max2d
Import brl.glmax2d
?win32
Import brl.d3d7max2d
?

Import brl.stream
Import brl.filesystem


'Included code
Include "inc/types/tile.bmx"
Include "inc/types/mapres.bmx"
Include "inc/types/mapenv.bmx"

























