
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
bbdoc: Tile map module
End Rem
Module duct.tilemap

ModuleInfo "Version: 0.6"
ModuleInfo "Copyright: Coranna Howard <me@komiga.com>"
ModuleInfo "License: MIT"

ModuleInfo "History: Version 0.6"
ModuleInfo "History: General cleanup"
ModuleInfo "History: Corrected variable code for duct.variables update"
ModuleInfo "History: dTileMap methods AddStaticToPos, AddStaticArrayToPos and SetTileAtPos now update the given object's position"
ModuleInfo "History: Added UpdateTile to dTileMap"
ModuleInfo "History: Added UpdateTileResource and UpdateStaticResource methods to dMapResourceSet and dTileMap"
ModuleInfo "History: Renamed dTileMapHandler.*Drawn to *Rendered and dTileMapHandler.FinishDrawing to FinishRendering"
ModuleInfo "History: Renamed dTileMap.Draw to dTileMap.Render"
ModuleInfo "History: Renamed dMapResourceSet.*ByID methods to *WithID"
ModuleInfo "History: Added dTileMap.LoadFromFile"
ModuleInfo "History: Corrected flag removal in dMapResource.RemoveFlag"
ModuleInfo "History: Renamed inc/ to src/"
ModuleInfo "History: Version 0.5"
ModuleInfo "History: Fixed documentation, licenses, examples"
ModuleInfo "History: Renamed type prefix from 'T' to 'd'"
ModuleInfo "History: Update for API change"
ModuleInfo "History: Version 0.4"
ModuleInfo "History: General cleanup"
ModuleInfo "History: Version 0.3"
ModuleInfo "History: Ported to Protog2D"
ModuleInfo "History: Removed references to TTileMapCache (for now)"
ModuleInfo "History: Changed formatting"
ModuleInfo "History: Version 0.2"
ModuleInfo "History: Added many methods to get tile position <-> chunk index and cell"
ModuleInfo "History: Added UpdateNormals to the DrawnTile type"
ModuleInfo "History: Added Update methods to the DrawnTile and DrawnStatic types (along with internal positions, altitudes and textures - rendering is now internalized)"
ModuleInfo "History: Added Draw methods to DrawnTile and DrawnStatic"
ModuleInfo "History: Reverted TTileMap.TILEWIDTH_2, TILEHEIGHT_2, TILEDIMENSIONS to the evened out divisions (tiny increments evidenced rendering mishaps - I actually forget why I didn't have them set to what they are now..)"
ModuleInfo "History: Converted some drawing techniques to use the ones defined here (Ultima Online's definition): http://uo.stratics.com/heptazane/fileformats.shtml"
ModuleInfo "History: Fixed some documentation and added some more `#region ... #end region` areas"
ModuleInfo "History: General code cleanup"
ModuleInfo "History: Version 0.064"
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

Import brl.pixmap
Import brl.stream
Import duct.etc
Import duct.intmap
Import duct.vector
Import duct.protog2d

Include "src/drawnobject.bmx"
Include "src/map.bmx"
Include "src/mapres.bmx"
Include "src/mapenv.bmx"
Include "src/mappos.bmx"

