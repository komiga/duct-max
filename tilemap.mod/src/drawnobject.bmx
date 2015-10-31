
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

Rem
	bbdoc: duct base drawn object for #dTileMap.
	about: NOTE: You will need to modify the serialization functions if you extend this type and add any fields.
End Rem
Type dDrawnObject Abstract
	
	Field m_resourceid:Int
	Field m_pos:dMapPos
	
	Method New()
		m_pos = New dMapPos
	End Method
	
	Rem
		bbdoc: Initiate the drawn object.
		returns: Nothing.
	End Rem
	Method _init(resourceid:Int, z:Int)
		m_resourceid = resourceid
		SetZ(z)
	End Method
	
'#region Field accessors
	
	Rem
		bbdoc: Set the resource id to be used when rendering.
		returns: Nothing.
	End Rem
	Method SetResourceID(resourceid:Int)
		m_resourceid = resourceid
	End Method
	Rem
		bbdoc: Get the resource id (used when rendering).
		returns: The drawn object's resource id.
	End Rem
	Method GetResourceID:Int()
		Return m_resourceid
	End Method
	
	Rem
		bbdoc: Set the z position of the drawn object.
		returns: Nothing.
		about: The @z parameter will be clamped to [-127, 127].
	End Rem
	Method SetZ(z:Int)
		m_pos.SetZ(z)
	End Method
	Rem
		bbdoc: Get the z position of the drawn object.
		returns: The z position of the drawn object.
	End Rem
	Method GetZ:Int()
		Return m_pos.m_z
	End Method
	
	Rem
		bbdoc: Set the MapPos for this drawn object (x and y values are not used in this base type).
		returns: Nothing.
		about: This will set the drawn object's position by the given position (instead of changing the reference to @pos).
	End Rem
	Method SetPos(pos:dMapPos)
		m_pos.SetByPos(pos)
	End Method
	Rem
		bbdoc: Get the MapPos for this drawn object (x and y values are not used in this base type).
		returns: The MapPos for this drawn object.
	End Rem
	Method GetPos:dMapPos()
		Return m_pos
	End Method
	
'#end region Field accessors
	
'#region Data handling
	
	Rem
		bbdoc: Deserialize the drawn object from the given stream.
		returns: Itself.
	End Rem
	Method Deserialize:dDrawnObject(stream:TStream)
		m_resourceid = stream.ReadInt()
		' Signed byte to integer conversion (credits to Nilium: http://www.blitzbasic.com/codearcs/codearcs.php?code=1700)
		m_pos.m_z = Int((stream.ReadByte() Shl 24) Sar 24)
		Return Self
	End Method
	
	Rem
		bbdoc: Serialize the drawn object to the given stream.
		returns: Nothing.
	End Rem
	Method Serialize(stream:TStream)
		stream.WriteInt(m_resourceid)
		' Integer to signed byte conversion (credits to Nilium: http://www.blitzbasic.com/codearcs/codearcs.php?code=1700)
		stream.WriteByte(Byte(((m_pos.m_z & $80000000) Shr 24) | (m_pos.m_z & $7FFFFFFF)))
	End Method
	
'#end region Data handling
	
End Type

Rem
	bbdoc: duct drawn tile (see #dTileMap).
End Rem
Type dDrawnTile Extends dDrawnObject
	
	Field m_resource:dMapTileResource, m_texture:dProtogTexture
	
	Field m_leftz:Int, m_rightz:Int, m_bottomz:Int ' m_z2 (x+1,y); m_z3 (x,y+1); m_z4 (x+1,y+1)
	Field m_normals:dVec3[4]
	
	Method New()
		m_normals[0] = New dVec3
		m_normals[1] = New dVec3
		m_normals[2] = New dVec3
		m_normals[3] = New dVec3
	End Method
	
	Rem
		bbdoc: Create a drawn tile.
		returns: Itself.
	End Rem
	Method Create:dDrawnTile(tileid:Int, z:Int)
		_init(tileid, z)
		Return Self
	End Method
	
'#region Rendering and updating
	
	Rem
		bbdoc: Render the tile at the given position.
		returns: Nothing.
	End Rem
	Method Render(reldrawx:Int, reldrawy:Int, writemask:Int, use_lighting:Int = True)
		'If ZLevelChanged
		'	ZLevelChanged = False
		'	Update()
		'End If
		If m_texture
			Local posx:Int = reldrawx + (m_pos.m_x - m_pos.m_y) * 22
			Local posy:Int = reldrawy + (m_pos.m_x + m_pos.m_y) * 22
			' Top
			Local x0:Int = 0
			Local y0:Int = 0 - m_pos.m_z Shl 2
			' Left
			Local x1:Int = -22
			Local y1:Int = 22 - m_leftz Shl 2
			' Bottom
			Local x2:Int = 0
			Local y2:Int = 44 - m_bottomz Shl 2
			' Right
			Local x3:Int = 22
			Local y3:Int = 22 - m_rightz Shl 2
			
			m_texture.Bind()
			If use_lighting Then glEnable(GL_LIGHTING)
			glBegin(GL_QUADS)
				glNormal3fv(Varptr(m_normals[0].m_x))
				glTexCoord2f(0.0, 0.0)
				glVertex2i(posx + x0, posy + y0)
				
				glNormal3fv(Varptr(m_normals[3].m_x))
				glTexCoord2f(0.0, 1.0)
				glVertex2i(posx + x1, posy + y1)
				
				glNormal3fv(Varptr(m_normals[2].m_x))
				glTexCoord2f(1.0, 1.0)
				glVertex2i(posx + x2, posy + y2)
				
				glNormal3fv(Varptr(m_normals[1].m_x))
				glTexCoord2f(1.0, 0.0)
				glVertex2i(posx + x3, posy + y3)
			glEnd()
			If use_lighting Then glDisable(GL_LIGHTING)
			If writemask
				dProtogCollision.CollideTextureQuad(Null, posx + x0, posy + y0, posx + x1, posy + y1, posx + x2, posy + y2, posx + x3, posy + y3, 0, writemask, Self)
			End If
		End If
	End Method
	
	Rem
		bbdoc: Update the internal position and altitudes of the tile.
		returns: Nothing.
	End Rem
	Method Update(x:Int, y:Int, leftz:Int, rightz:Int, bottomz:Int)
		m_pos.m_x = x
		m_pos.m_y = y
		m_leftz = leftz
		m_rightz = rightz
		m_bottomz = bottomz
	End Method
	
	Rem
		bbdoc: Update the internal position of the tile.
		returns: Nothing.
	End Rem
	Method UpdatePosition(x:Int, y:Int)
		m_pos.m_x = x
		m_pos.m_y = y
	End Method
	
	Rem
		bbdoc: Update the internal altitudes of the tile.
		returns: Nothing.
	End Rem
	Method UpdateAltitudes(leftz:Int, rightz:Int, bottomz:Int)
		m_leftz = leftz
		m_rightz = rightz
		m_bottomz = bottomz
	End Method
	
	Rem
		bbdoc: Update the internal resource of the tile.
		returns: Nothing.
	End Rem
	Method UpdateResource(resource:dMapTileResource)
		m_resource = resource
		If m_resource
			m_texture = m_resource.m_texture
		End If
	End Method
	
	Rem
		bbdoc: Update the tile's normals.
		returns: Nothing.
	End Rem
	Method UpdateNormals(bx:Int, by:Int, basenormals:dVec3[,,] Var)
		Local normal:dVec3
		normal = m_normals[0]
		normal.SetVec(basenormals[bx - 1, by - 1, 2])
		normal.AddVec(basenormals[bx - 1, by, 1])
		normal.AddVec(basenormals[bx, by - 1, 3])
		normal.AddVec(basenormals[bx, by, 0])
		normal.Normalize()
		
		normal = m_normals[1]
		normal.SetVec(basenormals[bx, by - 1, 2])
		normal.AddVec(basenormals[bx, by, 1])
		normal.AddVec(basenormals[bx + 1, by - 1, 3])
		normal.AddVec(basenormals[bx + 1, by, 0])
		normal.Normalize()
		
		normal = m_normals[2]
		normal.SetVec(basenormals[bx, by, 2])
		normal.AddVec(basenormals[bx, by + 1, 1])
		normal.AddVec(basenormals[bx + 1, by, 3])
		normal.AddVec(basenormals[bx + 1, by + 1, 0])
		normal.Normalize()
		
		normal = m_normals[3]
		normal.SetVec(basenormals[bx - 1, by, 2])
		normal.AddVec(basenormals[bx - 1, by + 1, 1])
		normal.AddVec(basenormals[bx, by, 3])
		normal.AddVec(basenormals[bx, by + 1, 0])
		normal.Normalize()
	End Method
	
	Rem
		bbdoc: Check if the tile is visible in the given area.
		returns: True if the tile is visible, or False if it is not.
	End Rem
	Method IsVisible:Int(window_width:Int, window_height:Int, playerpos:dMapPos)
		Local posx:Int = (window_width Shr 1) + (m_pos.m_x - playerpos.m_x - m_pos.m_y + playerpos.m_y) * 22
		Local posy:Int = (window_height Shr 1) + (m_pos.m_x - playerpos.m_x + m_pos.m_y - playerpos.m_y) * 22 + playerpos.m_z Shl 2
		' Top
		Local x0:Int = 0
		Local y0:Int = 0 - m_pos.m_z Shl 2
		' Left
		Local x1:Int = -22
		Local y1:Int = 22 - m_leftz Shl 2
		' Bottom
		Local x2:Int = 0
		Local y2:Int = 44 - m_bottomz Shl 2
		' Right
		Local x3:Int = 22
		Local y3:Int = 22 - m_rightz Shl 2
		If ((posx + x0 >= - 44) And (posy + y0 >= - 44) And (posx + x0 < window_width + 44) And (posy + y0 < window_height + 44)) Or ..
			((posx + x1 >= - 44) And (posy + y1 >= - 44) And (posx + x1 < window_width + 44) And (posy + y1 < window_height + 44)) Or ..
			((posx + x2 >= - 44) And (posy + y2 >= - 44) And (posx + x2 < window_width + 44) And (posy + y2 < window_height + 44)) Or ..
			((posx + x3 >= - 44) And (posy + y3 >= - 44) And (posx + x3 < window_width + 44) And (posy + y3 < window_height + 44))
			Return True
		End If
		Return False
	End Method
	
'#end region Drawing and updating
	
'#region Data handling
	
	Rem
		bbdoc: Deserialize the tile from the given stream.
		returns: Itself.
	End Rem
	Method Deserialize:dDrawnTile(stream:TStream)
		Super.Deserialize(stream)
		Return Self
	End Method
	
'#end region Data handling
	
End Type

Rem
	bbdoc: duct drawn static (see #dTileMap).
End Rem
Type dDrawnStatic Extends dDrawnObject
	
	Field m_resource:dMapStaticResource, m_texture:dProtogTexture
	
	Rem
		bbdoc: Create a drawn static.
		returns: Itself.
	End Rem
	Method Create:dDrawnStatic(staticid:Int, z:Int)
		_init(staticid, z)
		Return Self
	End Method
	
'#region Rendering and updating
	
	Rem
		bbdoc: Render the static.
		returns: Nothing.
	End Rem
	Method Render(reldrawx:Int, reldrawy:Int, writemask:Int)
		If m_texture
			m_texture.Bind()
			reldrawx:+ (m_pos.m_x - m_pos.m_y) * 22 - (m_texture.GetWidth() Shr 1)
			reldrawy:+ (m_pos.m_x + m_pos.m_y) * 22 - m_pos.m_z Shl 2 - m_texture.GetHeight() + 44
			m_texture.RenderToPosParams(reldrawx, reldrawy)
			'm_texture.RenderToPosParams(reldrawx + (m_pos.m_x - m_pos.m_y) * 22 - (m_texture.GetWidth() Shr 1), reldrawy + (m_pos.m_x + m_pos.m_y) * 22 - m_pos.m_z Shl 2 - m_texture.GetHeight() + 44)
			If writemask
				dProtogCollision.CollideTexture(m_texture, reldrawx, reldrawy, 0, writemask, Self)
			End If
		End If
	End Method
	
	Rem
		bbdoc: Update the internal position of the static.
		returns: Nothing.
	End Rem
	Method UpdatePosition(x:Int, y:Int)
		m_pos.m_x = x
		m_pos.m_y = y
	End Method
	
	Rem
		bbdoc: Update the internal resource of the static.
		returns: Nothing.
	End Rem
	Method UpdateResource(resource:dMapStaticResource)
		m_resource = resource
		If m_resource
			m_texture = m_resource.m_texture
		End If
	End Method
	
	Rem
		bbdoc: Check if the static is within the given area.
		returns: True if the static is visible, or False if it is not.
	End Rem
	Method IsVisible:Int(window_width:Int, window_height:Int, playerpos:dMapPos)
		If m_texture
			Local posx:Int = (window_width Shr 1) + (m_pos.m_x - playerpos.m_x - m_pos.m_y + playerpos.m_y) * 22 - (m_texture.GetWidth() Shr 1)
			Local posy:Int = (window_height Shr 1) + (m_pos.m_x - playerpos.m_x + m_pos.m_y - playerpos.m_y) * 22 - m_pos.m_z Shl 2 - m_texture.GetHeight() + 44 + playerpos.m_z Shl 2
			If (posx - 44 < window_width) Or (posy - 44 < window_height) Or (posx + m_texture.GetWidth() + 44 >= 0) Or (posy + m_texture.GetHeight() + 44 >= 0)
				Return True
			End If
		End If
		Return False
	End Method
	
'#end region Drawing and updating
	
'#region Data handling
	
	Rem
		bbdoc: Deserialize the static from the given stream.
		returns: Itself.
	End Rem
	Method Deserialize:dDrawnStatic(stream:TStream)
		Super.Deserialize(stream)
		Return Self
	End Method
	
'#end region Data handling
	
	Method Compare:Int(withobject:Object)
		Local best:Int = 0
		Local static:dDrawnStatic = dDrawnStatic(withobject)
		If static
			If static.m_pos.m_z = m_pos.m_z
				best = 0
			Else If static.m_pos.m_z > m_pos.m_z
				best = -1
			Else If static.m_pos.m_z < m_pos.m_z
				best = 1
			End If
		End If
		Return best
	End Method
	
End Type

Rem
	bbdoc: duct drawn tile chunk (see #dTileMap).
End Rem
Type dDrawnTileChunk
	
	Const c_chunksize:Int = 64, c_elemsq:Int = 8
	'Global g_basearray:dDrawnTile[c_chunksize]
	
	Field m_objects:dDrawnTile[]
	
	'Function InitiateType()
	'	Local n:Int
	'	
	'	For n = 0 To c_chunksize - 1
	'		g_basearray[n] = New dDrawnTile.Create(- 1, 0)
	'	Next
	'End Function
	
	Rem
		bbdoc: Create a new tile chunk.
		returns: Itself.
		about: If @objects is Null (which it is by default), an empty array (of 64 elements) will be used.<br/>
		WARNING: This type's methods do not check for Null tiles in the objects array().
	End Rem
	Method Create:dDrawnTileChunk(objects:dDrawnTile[] = Null, base_resid:Int = -1, base_alt:Short = 0)
		If Not objects
			m_objects = New dDrawnTile[c_chunksize]
			For Local n:Int = 0 To c_chunksize - 1
				m_objects[n] = New dDrawnTile.Create(base_resid, base_alt)
			Next
		Else
			SetObjects(objects)
		End If
		Return Self
	End Method
	
'#region Field accessors
	
	Rem
		bbdoc: Set the array of tiles for this chunk.
		returns: Nothing.
		about: If @objects has more, or less, than 64 tiles, and error will be thrown.<br/>
		Nothing will happen if @objects is Null.
	End Rem
	Method SetObjects(objects:dDrawnTile[])
		If objects
			If objects.Length = c_chunksize
				m_objects = objects
			Else
				Throw "(dDrawnTileChunk.SetObjects()) @objects has more or less than " + c_chunksize + " elements!"
			End If
		End If
	End Method
	
	Rem
		bbdoc: Get the array of tiles for this chunk.
		returns: The chunk's array of tiles.
	End Rem
	Method GetObjects:dDrawnTile[]()
		Return m_objects
	End Method
	
'#end region
	
'#region Tile & chunk update functions
	
	Rem
		bbdoc: Update the tile chunk's normals.
		returns: Nothing.
	End Rem
	Method UpdateNormals(basenormals:dVec3[,,] Var)
		For Local y:Int = 0 Until 8
			For Local x:Int = 0 Until 8
				m_objects[y * 8 + x].UpdateNormals(x + 1, y + 1, basenormals)
			Next
		Next
	End Method
	
'#end region Tile & chunk update functions
	
'#region Collections handling
	
	Rem
		bbdoc: Get a tile by its relative position (x and y are 0 to 7).
		returns: Nothing.
		about: Warning: This will NOT check if the positions are out of bounds.
	End Rem
	Method GetTileByPos:dDrawnTile(x:Int, y:Int)
		Return m_objects[y * 8 + x]
	End Method
	
	Rem
		bbdoc: Get the altitude (z position) of a tile by its relative position (x and y are 0 to 7).
		returns: Nothing.
		about: Warning: This will NOT check if the positions are out of bounds.
	End Rem
	Method GetTileAltitudeByPos:Int(x:Int, y:Int)
		Return m_objects[y * 8 + x].m_pos.m_z
	End Method
	
'#end region Collections handling
	
'#region Data handling
	
	Rem
		bbdoc: Deserialize the chunk from the given stream.
		returns: Itself.
		about: See #Serialize for information on the @opt_donils parameter.
	End Rem
	Method Deserialize:dDrawnTileChunk(stream:TStream, opt_donils:Int = True)
		For Local n:Int = 0 Until c_chunksize
			If opt_donils
				m_objects[n] = New dDrawnTile.Deserialize(stream)
			Else
				If stream.ReadByte() = True
					m_objects[n] = New dDrawnTile.Deserialize(stream)
				End If
			End If
		Next
		Return Self
	End Method
	
	Rem
		bbdoc: Serialize the chunk to the given stream.
		returns: Nothing.
		about: @opt_donils (True or False) tells the method to either save or not save tiles with the resource id of -1 (this changes the data structure slightly).
	End Rem
	Method Serialize(stream:TStream, opt_donils:Int = True)
		For Local dtile:dDrawnTile = EachIn m_objects
			If opt_donils = True
				dtile.Serialize(stream)
			Else If opt_donils = False
				If dtile.m_resourceid = -1
					stream.WriteByte(False)
				Else
					stream.WriteByte(True)
					dtile.Serialize(stream)
				End If
			End If
		Next
	End Method
	
'#end region Data handling
	
'#region Position conversion/checking functions
	
	Rem
		bbdoc: Get a relative position in the chunk for the given cell.
		returns: True if the cell is in bounds and if the positions were set, or False otherwise.
		about: This will set the @x and @y parameters (both are 0-7).
	End Rem
	Function GetPositionFromCell:Int(cell:Int, x:Int Var, y:Int Var)
		If CellInBounds(cell)
			x = (cell Mod 8)
			'y = (cell / 8)
			y = (cell Shr 3)
			Return True
		End If
		Return False
	End Function
	
	Rem
		bbdoc: Get the cell for the given (relative) position.
		returns: The cell for the given position, or -1 if the given position is out of bounds.
	End Rem
	Function GetCellFromPosition:Int(x:Int, y:Int)
		If PosInBounds(x, y)
			Return (y Mod 8) Shl 3 + (x Mod 8)
		End If
		Return -1
	End Function
	
	Rem
		bbdoc: Check if a given cell is within the bounds of a chunk size.
		returns: True if the cell is within the bounds of a chunk size, or False if it is not.
	End Rem
	Function CellInBounds:Int(cell:Int)
		If cell > -1 And cell < c_chunksize
			Return True
		End If
		Return False
	End Function
	
	Rem
		bbdoc: Check if the given (relative) position is within the bounds of the chunk size.
		returns: True if the position is within the chunk (both parameters must be 0-7), or False if the position is out of bounds.
	End Rem
	Function PosInBounds:Int(x:Int, y:Int)
		If x > -1 And x < c_elemsq And y > -1 And y < c_elemsq
			Return True
		End If
		Return False
	End Function
	
'#end region Position conversion/checking functions
	
End Type

