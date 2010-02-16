
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
	-----------------------------------------------------------------------------
	
	drawnobject.bmx (Contains: TDrawnObject, TDrawnTile, TDrawnStatic, TDrawnTileChunk, )
	
End Rem

Rem
	bbdoc: The base type for all tile/statics in a TTileMap.
	about: NOTE: You will need to modify the serialization functions if you extend this type and add any fields.
End Rem
Type TDrawnObject Abstract
	
	Field m_resourceid:Int
	Field m_pos:TMapPos
	
	Method New()
		m_pos = New TMapPos
	End Method
	
	Rem
		bbdoc: Initiate the DrawnObject.
		returns: Nothing.
		about: Set the base fields for the DrawnObject.
	End Rem
	Method Init(resourceid:Int, z:Int)
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
		returns: The DrawnObject's resource id.
	End Rem
	Method GetResourceID:Int()
		Return m_resourceid
	End Method
	
	Rem
		bbdoc: Set the z position of the DrawnObject.
		returns: Nothing.
		about: The @z parameter will be clamped to [-127, 127].
	End Rem
	Method SetZ(z:Int)
		m_pos.SetZ(z)
	End Method
	Rem
		bbdoc: Get the z position of the DrawnObject.
		returns: The z position of the DrawnObject.
	End Rem
	Method GetZ:Int()
		Return m_pos.m_z
	End Method
	
	Rem
		bbdoc: Set the MapPos for this DrawnObject (x and y values are not used in this base type).
		returns: Nothing.
		about: This will set the DrawnObject's position by the given position (instead of changing the reference to @pos).
	End Rem
	Method SetPos(pos:TMapPos)
		m_pos.SetByPos(pos)
	End Method
	Rem
		bbdoc: Get the MapPos for this DrawnObject (x and y values are not used in this base type).
		returns: The MapPos for this DrawnObject.
	End Rem
	Method GetPos:TMapPos()
		Return m_pos
	End Method
	
'#end region (Field accessors)
	
'#region Data handling
	
	Rem
		bbdoc: Deserialize the DrawnObject from a stream.
		returns: The deserialized DrawnObject (itself).
	End Rem
	Method DeSerialize:TDrawnObject(stream:TStream)
		m_resourceid = stream.ReadInt()
		' Signed byte to integer conversion (credits to Nilium: http://www.blitzbasic.com/codearcs/codearcs.php?code=1700)
		m_pos.m_z = Int((stream.ReadByte() Shl 24) Sar 24)
		'stream.ReadBytes(Self, SizeOf(Self))
		Return Self
	End Method
	
	Rem
		bbdoc: Serialize the DrawnObject to a stream.
		returns: Nothing.
	End Rem
	Method Serialize(stream:TStream)
		stream.WriteInt(m_resourceid)
		' Integer to signed byte conversion (credits to Nilium: http://www.blitzbasic.com/codearcs/codearcs.php?code=1700)
		stream.WriteByte(Byte(((m_pos.m_z & $80000000) Shr 24) | (m_pos.m_z & $7FFFFFFF)))
		'stream.WriteBytes(Self, SizeOf(Self))
	End Method
	
'#end region (Data handling)
	
End Type

Rem
	bbdoc: Drawn tile for TTileMaps.
End Rem
Type TDrawnTile Extends TDrawnObject
	
	Field m_resource:TMapTileResource, m_texture:TProtogTexture
	
	Field m_leftz:Int, m_rightz:Int, m_bottomz:Int 'm_z2 (x+1,y); m_z3 (x,y+1); m_z4 (x+1,y+1)
	Field m_normals:TVec3[4]
	
	Method New()
		m_normals[0] = New TVec3
		m_normals[1] = New TVec3
		m_normals[2] = New TVec3
		m_normals[3] = New TVec3
	End Method
	
	Rem
		bbdoc: Create a TDrawnTile.
		returns: The new TDrawnTile (itself).
	End Rem
	Method Create:TDrawnTile(tileid:Int, z:Int)
		Init(tileid, z)
		Return Self
	End Method
	
'#region Rendering and updating
	
	Rem
		bbdoc: Render the tile at the given position.
		returns: Nothing.
	End Rem
	Method Render(reldrawx:Int, reldrawy:Int, collisionlayer:Int)
		Local posx:Int, posy:Int
		Local x0:Int, y0:Int, x1:Int, y1:Int, x2:Int, y2:Int, x3:Int, y3:Int
		
		'If ZLevelChanged
		'	ZLevelChanged = False
		'	Update()
		'End If
		
		If m_texture <> Null
			posx = reldrawx + (m_pos.m_x - m_pos.m_y) * 22
			posy = reldrawy + (m_pos.m_x + m_pos.m_y) * 22
			
			' Top
			x0 = 0
			y0 = 0 - m_pos.m_z Shl 2
			
			' Left
			x1 = -22
			y1 = 22 - m_leftz Shl 2
			
			' Bottom
			x2 = 0
			y2 = 44 - m_bottomz Shl 2
			
			' Right
			x3 = 22
			y3 = 22 - m_rightz Shl 2
			
			m_texture.Bind()
			
			'glColor4f(1.0, 1.0, 1.0, 1.0)
			glEnable(GL_LIGHTING)
			
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
			
			glDisable(GL_LIGHTING)
			
			' TODO: Turn into callback
			'Mouse.CheckObject(posy, posy, x0, y0, x1, y1, x2, y2, x3, y3, Self)
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
	Method UpdateResource(resource:TMapTileResource)
		m_resource = resource
		If m_resource <> Null
			m_texture = m_resource.m_texture
		End If
	End Method
	
	Rem
		bbdoc: Update the tile's normals.
		returns: Nothing.
	End Rem
	Method UpdateNormals(bx:Int, by:Int, basenormals:TVec3[,,] Var)
		Local normal:TVec3
		
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
	
	Method IsVisible:Int(window_width:Int, window_height:Int, playerpos:TMapPos)
		Local posx:Int, posy:Int
		Local x0:Int, y0:Int, x1:Int, y1:Int, x2:Int, y2:Int, x3:Int, y3:Int
		
		'If TextureChanged = True
		'	TextureChanged = False
		'	GetTexture()
		'End If
		
		If m_texture <> Null
			posx = (window_width Shr 1) + (m_pos.m_x - playerpos.m_x - m_pos.m_y + playerpos.m_y) * 22
			posy = (window_height Shr 1) + (m_pos.m_x - playerpos.m_x + m_pos.m_y - playerpos.m_y) * 22 + playerpos.m_z Shl 2
			
			' Top
			x0 = 0
			y0 = 0 - m_pos.m_z Shl 2
			
			' Left
			x1 = -22
			y1 = 22 - m_leftz Shl 2
			
			' Bottom
			x2 = 0
			y2 = 44 - m_bottomz Shl 2
			
			' Right
			x3 = 22
			y3 = 22 - m_rightz Shl 2
			
			If ((posx + x0 >= - 44) And (posy + y0 >= - 44) And (posx + x0 < window_width + 44) And (posy + y0 < window_height + 44)) Or ..
				((posx + x1 >= - 44) And (posy + y1 >= - 44) And (posx + x1 < window_width + 44) And (posy + y1 < window_height + 44)) Or ..
				((posx + x2 >= - 44) And (posy + y2 >= - 44) And (posx + x2 < window_width + 44) And (posy + y2 < window_height + 44)) Or ..
				((posx + x3 >= - 44) And (posy + y3 >= - 44) And (posx + x3 < window_width + 44) And (posy + y3 < window_height + 44))
				Return True
			End If
		End If
		Return False
	End Method
	
'#end region (Drawing and updating)
	
'#region Data handling
	
	Rem
		bbdoc: Deserialize the DrawnTile from a stream.
		returns: The deserialized DrawnTile (itself).
	End Rem
	Method DeSerialize:TDrawnTile(stream:TStream)
		Super.DeSerialize(stream)
		Return Self
	End Method
	
	Rem
		bbdoc: Load a DrawnTile from a stream.
		returns: The loaded DrawnTile.
		about: This function will create a new DrawnTile and deserialize it from the given stream.
	End Rem
	Function Load:TDrawnTile(stream:TStream)
		Return New TDrawnTile.DeSerialize(stream)
	End Function
	
'#end region
	
End Type


Rem
	bbdoc: Drawn static for TTileMaps.
End Rem
Type TDrawnStatic Extends TDrawnObject
	
	Field m_resource:TMapStaticResource, m_texture:TProtogTexture
	
	Rem
		bbdoc: Create a TDrawnStatic.
		returns: The created TDrawnStatic (itself).
	End Rem
	Method Create:TDrawnStatic(staticid:Int, z:Int)
		Init(staticid, z)
		Return Self
	End Method
	
'#region Rendering and updating
	
	Rem
		bbdoc: Render the static.
		returns: Nothing.
	End Rem
	Method Render(reldrawx:Int, reldrawy:Int, collisionlayer:Int)
		If m_texture <> Null
			m_texture.Bind()
			m_texture.RenderToPosParams(reldrawx + (m_pos.m_x - m_pos.m_y) * 22 - (m_texture.GetWidth() Shr 1), reldrawy + (m_pos.m_x + m_pos.m_y) * 22 - m_pos.m_z Shl 2 - m_texture.GetHeight() + 44)
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
	Method UpdateResource(resource:TMapStaticResource)
		m_resource = resource
		If m_resource <> Null
			m_texture = m_resource.m_texture
		End If
	End Method
	
	Rem
		bbdoc: Check if the DrawnStatic is within the given area.
		returns: True if the DrawnStatic is visible, or False if it is not.
	End Rem
	Method IsVisible:Int(window_width:Int, window_height:Int, playerpos:TMapPos)
		Local posx:Int, posy:Int
		
		If m_texture <> Null
			posx = (window_width Shr 1) + (m_pos.m_x - playerpos.m_x - m_pos.m_y + playerpos.m_y) * 22 - (m_texture.GetWidth() Shr 1)
			posy = (window_height Shr 1) + (m_pos.m_x - playerpos.m_x + m_pos.m_y - playerpos.m_y) * 22 - m_pos.m_z Shl 2 - m_texture.GetHeight() + 44 + playerpos.m_z Shl 2
			
			If (posx - 44 < window_width) Or (posy - 44 < window_height) Or (posx + m_texture.GetWidth() + 44 >= 0) Or (posy + m_texture.GetHeight() + 44 >= 0)
				Return True
			End If
		End If
		Return False
	End Method
	
'#end region (Drawing and updating)
	
'#region Data handling
	
	Rem
		bbdoc: Deserialize the TDrawnStatic from a stream.
		returns: The deserialized TDrawnStatic (itself).
	End Rem
	Method DeSerialize:TDrawnStatic(stream:TStream)
		Super.DeSerialize(stream)
		Return Self
	End Method
	
	Rem
		bbdoc: Load a TDrawnStatic from a stream.
		returns: The loaded TDrawnStatic.
		about: This function will create a new TDrawnStatic and deserialize it from the given stream.
	End Rem
	Function Load:TDrawnStatic(stream:TStream)
		Return New TDrawnStatic.DeSerialize(stream)
	End Function
	
'#end region (Data handling)
	
	Method Compare:Int(withObject:Object)
		Local best:Int = 0, wobj:TDrawnStatic
		
		wobj = TDrawnStatic(withObject)
		If wobj <> Null
			If wobj.m_pos.m_z = m_pos.m_z
				best = 0
			Else If wobj.m_pos.m_z > m_pos.m_z
				best = -1
			Else If wobj.m_pos.m_z < m_pos.m_z
				best = 1
			End If
		End If
		Return best
	End Method
	
End Type

Rem
	bbdoc: The DrawnTileChunk type.
	about: This type is the base for all drawable TileMap DrawnTiles.
End Rem
Type TDrawnTileChunk
	
	Const c_chunksize:Int = 64, c_elemsq:Int = 8
	'Global g_basearray:TDrawnTile[c_chunksize]
	
	Field m_objects:TDrawnTile[]
	
	'Function InitiateType()
	'	Local n:Int
	'	
	'	For n = 0 To c_chunksize - 1
	'		g_basearray[n] = New TDrawnTile.Create(- 1, 0)
	'	Next
	'End Function
	
	Rem
		bbdoc: Create a new DrawnTileChunk.
		returns: The new DrawnTileChunk (itself).
		about: If @objects is Null (which it is by default), an empty array (of 64 elements) will be used.<br />
		WARNING: This type's methods do not check for Null DrawnTiles in the objects array().
	End Rem
	Method Create:TDrawnTileChunk(objects:TDrawnTile[] = Null, base_resid:Int = -1, base_alt:Short = 0)
		Local n:Int
		
		If objects = Null
			m_objects = New TDrawnTile[c_chunksize]
			For n = 0 To c_chunksize - 1
				m_objects[n] = New TDrawnTile.Create(base_resid, base_alt)
			Next
		Else
			SetObjects(objects)
		End If
		Return Self
	End Method
	
'#region Field accessors
	
	Rem
		bbdoc: Set the array of DrawnTiles for this chunk.
		returns: Nothing.
		about: If @objects has more, or less, than 64 DrawnTiles, and error will be thrown.<br />
		Nothing will happen if @objects is Null.
	End Rem
	Method SetObjects(objects:TDrawnTile[])
		If objects <> Null
			If objects.Length = c_chunksize
				m_objects = objects
			Else
				Throw "(TDrawnTileChunk.SetObjects()) @objects has more or less than " + c_chunksize + " elements!"
			End If
		End If
	End Method
	
	Rem
		bbdoc: Get the array of DrawnTiles for this chunk.
		returns: The chunk's array of DrawnTiles.
	End Rem
	Method GetObjects:TDrawnTile[] ()
		Return m_objects
	End Method
	
'#end region
	
'#region Tile & chunk update functions
	
	Rem
		bbdoc: Update the tile chunk's normals.
		returns: Nothing.
	End Rem
	Method UpdateNormals(basenormals:TVec3[,,] Var)
		Local x:Int, y:Int
		
		For y = 0 To 7
			For x = 0 To 7
				m_objects[y * 8 + x].UpdateNormals(x + 1, y + 1, basenormals)
			Next
		Next
	End Method
	
'#end region (Tile & chunk update functions)
	
'#region Collections handling
	
	Rem
		bbdoc: Get a tile by its relative position (x and y are 0 to 7).
		returns: Nothing.
		about: Warning: This will NOT check if the positions are out of bounds.
	End Rem
	Method GetTileByPos:TDrawnTile(x:Int, y:Int)
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
	
'#end region (Collections handling)
	
'#region Data handling
	
	Rem
		bbdoc: Deserialize the DrawnTileChunk from a stream.
		returns: The deserialized DrawnTileChunk (itself).
		about: See #Serialize for information on the @opt_donils parameter.
	End Rem
	Method DeSerialize:TDrawnTileChunk(stream:TStream, opt_donils:Int = True)
		Local n:Int
		
		For n = 0 To c_chunksize - 1
			If opt_donils = True
				m_objects[n] = New TDrawnTile.DeSerialize(stream)
			Else If opt_donils = False
				If stream.ReadByte() = True
					m_objects[n] = New TDrawnTile.DeSerialize(stream)
				End If
			End If
		Next
		Return Self
	End Method
	
	Rem
		bbdoc: Serialize the DrawnTileChunk to a stream.
		returns: Nothing.
		about: @opt_donils (True or False) tells the method to either save or not save tiles with the resource id of -1 (this changes the data structure slightly).
	End Rem
	Method Serialize(stream:TStream, opt_donils:Int = True)
		Local n:Int, dtile:TDrawnTile
		
		For n = 0 To c_chunksize - 1
			dtile = m_objects[n]
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
	
'#end region (Data handling)
	
'#region Position conversion/checking functions
	
	Rem
		bbdoc: Get a relative position in the chunk for the given cell.
		returns: True if the cell is in bounds and if the positions were set, or False otherwise.
		about: This will set the @x and @y parameters (both are 0-7).
	End Rem
	Function GetPositionFromCell:Int(cell:Int, x:Int Var, y:Int Var)
		If CellInBounds(cell) = True
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
		If PosInBounds(x, y) = True
			Return (y Mod 8) Shl 3 + (x Mod 8)
		End If
		Return - 1
	End Function
	
	Rem
		bbdoc: Check if a given cell is within the bounds of a chunk size.
		returns: True if the cell is within the bounds of a chunk size, or False if it is not.
	End Rem
	Function CellInBounds:Int(cell:Int)
		If cell > - 1 And cell < c_chunksize
			Return True
		End If
		Return False
	End Function
	
	Rem
		bbdoc: Check if the given (relative) position is within the bounds of the chunk size.
		returns: True if the position is within the chunk (both parameters must be 0-7), or False if the position is out of bounds.
	End Rem
	Function PosInBounds:Int(x:Int, y:Int)
		If x > - 1 And x < c_elemsq And y > - 1 And y < c_elemsq
			Return True
		End If
		Return False
	End Function
	
'#end region (Position conversion/checking functions)
	
End Type

