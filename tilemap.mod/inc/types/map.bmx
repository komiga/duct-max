
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
	
	tile.bmx (Contains: TTileMap, TTileMapHandler, )
	
	TODO:
		[TTileMapHandler.SetPlayerPosition] Set flags for a needed map drawing cache recalculation
		
End Rem

Rem
	bbdoc: The TileMap type.
	about: It is extemely important that you not change any given tile in the map to Null (Null [and other] checks are left out for max rendering speed).<br />
	Resource ID -1 is interpreted as a blank tile (black).
End Rem
Type TTileMap
	
	Global USING_GL_LIGHT:Int = GL_LIGHT0
	
	' Basic stats
	Field m_name:String
	Field m_width:Int, m_height:Int, m_chunks:Int
	
	' Assistants (resource sets, handler and environment)
	Field m_handler:TTileMapHandler
	Field m_tileres:TMapResourceSet, m_staticres:TMapResourceSet
	Field m_environment:TMapEnvironment
	
	' Map data
	Field m_data_terrain:TDrawnTileChunk[], m_data_statics:TDrawnStatic[][,]
	Field m_stream_tilepos:Int ' Beginning location, in bytes, for the tile section of a map file
	
	' Positioning
	Field m_pov:TMapPos
	Field m_window_x:Int, m_window_y:Int, m_window_width:Int, m_window_height:Int
	
	' Draw cache
	'Field m_drawcache:TTileMapDrawCache
	
	Method New()
		'm_drawcache = New TTileMapDrawCache.Create()
	End Method
	
	Rem
		bbdoc: Initiate the default map array
		returns: Nothing.
		about: This will recreate the terrain chunk & static arrays (fills each terrain cell with a new tile - resid of @resid and z of @altitude).
	End Rem
	Method _Init(base_resid:Int = -1, base_altitude:Int = 0)
		Local n:Int, n2:Int
		
		m_data_terrain = New TDrawnTileChunk[m_chunks]
		m_data_statics = New TDrawnStatic[][m_height, m_width]
		For n = 0 To m_chunks - 1
			m_data_terrain[n] = New TDrawnTileChunk.Create(Null, base_resid, base_altitude)
		Next
	End Method
	
	Rem
		bbdoc: Create a new TileMap.
		returns: The new TileMap (itself).
		about: NOTE: This method initiates the tile array (@resid and @altitude are the parameters passed to the #_Init method).<br />
		IMPORTANT: @width and @height must be evenly divisble by 8. See #SetWidth and #SetHeight for more information.
	End Rem
	Method Create:TTileMap(name:String, width:Int, height:Int, environment:TMapEnvironment, handler:TTileMapHandler, base_resid:Int = -1, base_altitude:Int = 0)
		SetName(name)
		
		SetWidth(width)
		SetHeight(height)
		UpdateChunkCount()
		
		SetEnvironment(environment)
		SetHandler(handler)
		
		_Init(base_resid, base_altitude)
		
		Return Self
	End Method
	
'#region Field accessors
	
	Rem
		bbdoc: Set the map's environment.
		returns: Nothing.
	End Rem
	Method SetEnvironment(environment:TMapEnvironment)
		m_environment = environment
	End Method
	Rem
		bbdoc: Get the map's environment.
		returns: The environment for the map.
	End Rem
	Method GetEnvironment:TMapEnvironment()
		Return m_environment
	End Method
	
	Rem
		bbdoc: Set the map's handler.
		returns: Nothing.
	End Rem
	Method SetHandler(handler:TTileMapHandler)
		m_handler = handler
	End Method
	Rem
		bbdoc: Get the map's handler.
		returns: The handler for the map.
	End Rem
	Method GetHandler:TTileMapHandler()
		Return m_handler
	End Method
	
	Rem
		bbdoc: Set the tile rendering resource map.
		returns: Nothing.
		about: This will set the resource map used to render tiles.
	End Rem
	Method SetTileResourceMap(set:TMapResourceSet)
		m_tileres = set
	End Method
	Rem
		bbdoc: Get the tile resource map.
		returns: Get the resource map used to render tiles.
	End Rem
	Method GetTileResourceMap:TMapResourceSet()
		Return m_tileres
	End Method
	
	Rem
		bbdoc: Set the static rendering resource map.
		returns: Nothing.
		about: This will set the resource map used to render statics.
	End Rem
	Method SetStaticResourceMap(set:TMapResourceSet)
		m_staticres = set
	End Method
	Rem
		bbdoc: Get the static resource map.
		returns: Get the resource map used to render statics.
	End Rem
	Method GetStaticResourceMap:TMapResourceSet()
		Return m_staticres
	End Method
	
	Rem
		bbdoc: Set the name of the map.
		returns: Nothing.
	End Rem
	Method SetName(name:String)
		m_name = name
	End Method
	Rem
		bbdoc: Get the name of the map.
		returns: The name of the map.
	End Rem
	Method GetName:String()
		Return m_name
	End Method
	
	Rem
		bbdoc: Set the map's width.
		returns: Nothing.
		about: IMPORTANT: For chunking to work correctly, all sizes (width and height) must be evenly divisible by 8 (Assertion will throw an error if the given value is not divisible by 8).
	End Rem
	Method SetWidth(width:Int)
		Assert IsDivisible(width, 8), "(TTileMap.SetWidth()) Width (" + width + ") must be evenly divisible by 8!"
		m_width = width
	End Method
	Rem
		bbdoc: Get the map's width.
		returns: The width of the map.
	End Rem
	Method GetWidth:Int()
		Return m_width
	End Method
	
	Rem
		bbdoc: Set the map's height.
		returns: Nothing.
		about: IMPORTANT: For chunking to work correctly, all sizes (width and height) must be evenly divisible by 8 (Assertion will throw an error if the given value is not divisible by 8).
	End Rem
	Method SetHeight(height:Int)
		Assert IsDivisible(height, 8), "(TTileMap.SetHeight()) Height (" + height + ") must be evenly divisible by 8!"
		m_height = height
	End Method
	Rem
		bbdoc: Get the map's height.
		returns: The height of the map.
	End Rem
	Method GetHeight:Int()
		Return m_height
	End Method
	
	Rem
		bbdoc: Get the number of chunks in the map.
		returns: The number of the chunks in the map.
	End Rem
	Method GetChunkCount:Int()
		Return m_chunks
	End Method
	
	Rem
		bbdoc: Update the number of the chunks in the map (based on the width and height of the map).
		returns: Nothing.
		about: This should be called if you change the height or the width (and don't forget to call Init again).
	End Rem
	Method UpdateChunkCount()
		m_chunks = (m_width Shr 3) * (m_height Shr 3)
		'DebugLog("( TTileMap.UpdateChunkCount() ) m_chunks = " + m_chunks)
	End Method
	
	Rem
		bbdoc: Set the window's dimensions.
		returns: Nothing.
	End Rem
	Method SetWindowDimensions(x:Int, y:Int, width:Int, height:Int)
		SetWindowPosition(x, y)
		SetWindowSize(width, height)
	End Method
	Rem
		bbdoc: Get the window's dimensions.
		returns: Nothing. The parameters will be set to their respective values.
	End Rem
	Method GetWindowDimensions(x:Int Var, y:Int Var, width:Int Var, height:Int Var)
		GetWindowPosition(x, y)
		GetWindowSize(width, height)
	End Method
	
	Rem
		bbdoc: Set the drawing window's size.
		returns: Nothing.
	End Rem
	Method SetWindowSize(width:Int, height:Int)
		m_window_width = width
		m_window_height = height
	End Method
	Rem
		bbdoc: Set the drawing window's size.
		returns: Nothing. The parameters will be set to their respective values.
	End Rem
	Method GetWindowSize(width:Int Var, height:Int Var)
		width = m_window_width
		height = m_window_height
	End Method
	
	Rem
		bbdoc: Set the drawing window's position.
		returns: Nothing.
	End Rem
	Method SetWindowPosition(x:Int, y:Int)
		m_window_x = x
		m_window_y = y
	End Method
	Rem
		bbdoc: Get the drawing window's position.
		returns: Nothing. The parameters will be set to their respective values.
	End Rem
	Method GetWindowPosition(x:Int Var, y:Int Var)
		x = m_window_x
		y = m_window_y
	End Method
	
	Rem
		bbdoc: Set the x position of the drawing window.
		returns: Nothing.
	End Rem
	Method SetWindowX(x:Int)
		m_window_x = x
	End Method
	Rem
		bbdoc: Get the x position of the drawing window.
		returns: The x position of the drawing window.
	End Rem
	Method GetWindowX:Int()
		Return m_window_x
	End Method
	
	Rem
		bbdoc: Set the y position of the drawing window.
		returns: Nothing.
	End Rem
	Method SetWindowY(y:Int)
		m_window_y = y
	End Method
	Rem
		bbdoc: Get the y position of the drawing window.
		returns: The y position of the drawing window.
	End Rem
	Method GetWindowY:Int()
		Return m_window_y
	End Method
	
	Rem
		bbdoc: Set the width of the drawing window.
		returns: Nothing.
	End Rem
	Method SetWindowWidth(width:Int)
		m_window_width = width
	End Method
	Rem
		bbdoc: Get the width of the drawing window.
		returns: The width of the drawing window.
	End Rem
	Method GetWindowWidth:Int()
		Return m_window_width
	End Method
	
	Rem
		bbdoc: Set the height of the drawing window.
		returns: Nothing.
	End Rem
	Method SetWindowHeight(height:Int)
		m_window_height = height
	End Method
	Rem
		bbdoc: Get the height of the drawing window.
		returns: The height of the drawing window.
	End Rem
	Method GetWindowHeight:Int()
		Return m_window_height
	End Method
	
'#end region (Field accessors)
	
'#region Tile and Static collections handling
	
	Rem
		bbdoc: Add an array of statics to a position in the map.
		returns: True if the array was added to the given position, or False if it was not (position was out of bounds, or the given array was Null).
	End Rem
	Method AddStaticArrayToPos:Int(statics:TDrawnStatic[], x:Int, y:Int, dosort:Int = True)
		Local posstatics:TDrawnStatic[]
		
		If PosInBounds(x, y) = True And statics <> Null
			posstatics = m_data_statics[y, x]
			If posstatics = Null
				posstatics = statics
			Else
				posstatics = posstatics + statics
			End If
			
			If dosort = True Then posstatics.Sort()
			m_data_statics[y, x] = posstatics
			Return True
		End If
		Return False
	End Method
	
	Rem
		bbdoc: Add a static to a position in the map.
		returns: True if the static was added to the given position, or False if it was not (position was out of bounds or given static was Null).
	End Rem
	Method AddStaticToPos:Int(static:TDrawnStatic, x:Int, y:Int, dosort:Int = True)
		Local posstatics:TDrawnStatic[]
		
		If PosInBounds(x, y) = True And static <> Null
			posstatics = m_data_statics[y, x]
			If posstatics = Null
				posstatics = New TDrawnStatic[1]
			Else
				posstatics = posstatics[..posstatics.Length + 1]
			End If
			
			posstatics[posstatics.Length - 1] = static
			If dosort = True Then posstatics.Sort()
			
			m_data_statics[y, x] = posstatics
			Return True
		End If
		Return False
	End Method
	
	Rem
		bbdoc: Get an array of the statics at the given position.
		returns: The array of statics at the given position, or Null if either the position was out of bounds or if there are no statics at the given position.
	End Rem
	Method GetStaticsAtPos:TDrawnStatic[] (x:Int, y:Int)
		Local statics:TDrawnStatic[]
		
		If PosInBounds(x, y) = True
			statics = m_data_statics[y, x]
		End If
		Return statics
	End Method
	
	Rem
		bbdoc: Remove a static from the map by its position and index.
		returns: True if the static at the given position and index was removed, or False if it was not removed.
	End Rem
	Method RemoveStaticAtPosByIndex:Int(x:Int, y:Int, index:Int, dosort:Int = True)
		Local statics:TDrawnStatic[]
		
		If PosInBounds(x, y) = True
			statics = m_data_statics[y, x]
			If statics <> Null
				If index <= statics.Length - 1 And index > - 1
					If statics.Length = 1
						statics = Null
					Else If index = 0
						statics = statics[1..]
					Else If index = statics.Length - 1
						statics = statics[..statics.Length - 1]
					Else
						statics = statics[..index] + statics[index + 1..]
					End If
					
					If statics <> Null And dosort = True Then statics.Sort()
					m_data_statics[y, x] = statics
					Return True
				End If
			End If
			
		End If
		Return False
	End Method
	
	Rem
		bbdoc: Remove a static from the map by its position.
		returns: True if the static at the given position was removed, or False if it was not removed.
	End Rem
	Method RemoveStaticAtPos:Int(x:Int, y:Int, static:TDrawnStatic, dosort:Int = True)
		Local statics:TDrawnStatic[], i:Int
		
		If PosInBounds(x, y) = True
			statics = m_data_statics[y, x]
			If statics <> Null
				For i = 0 To statics.Length - 1
					If statics[i] = static
						Return RemoveStaticAtPosByIndex(x, y, i, dosort)
					End If
				Next
			End If
		End If
		Return False
	End Method
	
	Rem
		bbdoc: Set the tile at the given position in the map.
		returns: True if the tile at the given position was set, or False if the tile id was Null or the position was out of bounds.
		about: @x (column) and @y (row) are zero based.
	End Rem
	Method SetTileAtPos:Int(dtile:TDrawnTile, x:Int, y:Int)
		Local index:Int, cell:Int
		
		If PosInBounds(x, y) = True
			index = (y Shr 3) * (m_height Shr 3) + (x Shr 3)
			cell = (y Mod 8) Shl 3 + (x Mod 8)
			'DebugLog("( TTileMap.SetTileAtPos() ) x = " + x + " y = " + y + " index = " + index + " cell = " + cell)
			m_data_terrain[index].m_objects[cell] = dtile
			Return True
		End If
		Return False
	End Method
	
	Rem
		bbdoc: Get a tile from the map by its position.
		returns: The drawn tile at the position given, or Null if the position is out of bounds.
		about: @x (column) and @y (row) are zero based.
	End Rem
	Method GetTileAtPos:TDrawnTile(x:Int, y:Int)
		Local index:Int, cell:Int
		
		If PosInBounds(x, y) = True
			index = (y Shr 3) * (m_height Shr 3) + (x Shr 3)
			cell = (y Mod 8) Shl 3 + (x Mod 8)
			
			'DebugLog("( TTileMap.GetTileAtPos() ) x = " + x + " y = " + y + " index = " + index + " cell = " + cell)
			Return m_data_terrain[index].m_objects[cell]
		End If
		Return Null
	End Method
	
	Rem
		bbdoc: Get the altitude (z position) for the tile at the given position.
		returns: The altitude for the tile (0 will be the default return if the position is out of bounds).
	End Rem
	Method GetTileAltitudeAtPos:Int(x:Int, y:Int)
		Local tile:TDrawnTile
		
		tile = GetTileAtPos(x, y)
		If tile <> Null
			Return tile.m_pos.m_z
		End If
		Return 0
	End Method
	
'#end region (Tile and Static collections handling)
	
'#region Position/Index based methods
	
	Rem
		bbdoc: 
		returns: True if the index and cell is in bounds and if the position parameters were set, or False if not.
		about: The parameters @x and @y are set to the position.
	End Rem
	Method GetPositionFromIndexAndCell:Int(index:Int, cell:Int, x:Int Var, y:Int Var)
		Local basex:Int, basey:Int
		
		If IndexInBounds(index) = True And TDrawnTileChunk.CellInBounds(cell) = True
			BeginningPositionForChunkIndex(index, basex, basey)
			TDrawnTileChunk.GetPositionFromCell(cell, x, y)
			x:+basex
			y:+basey
			Return True
		End If
		Return False
	End Method
	
	Rem
		bbdoc: Get the beginning position for a chunk index.
		returns: True if the index is in bounds and if the position parameters were set, or False if not.
		about: The parameters @x and @y are set to the position.
	End Rem
	Method BeginningPositionForChunkIndex:Int(index:Int, x:Int Var, y:Int Var)
		If IndexInBounds(index) = True
			' 'X' and 'Y' are the relative positions within a chunk (not cell or real object position)
			' px and py seem to be flipped (at least for my definition they are)
			'py = (BlockID Mod height) * 8 + Y
			'px = (BlockID div height) * 8 + X
			
			x = (index Mod (m_height Shr 3)) Shl 3 '+ 0
			y = (index / (m_height Shr 3)) Shl 3 '+ 0
			Return True
		End If
		Return False
	End Method
	
	Rem
		bbdoc: 
		returns: The chunk <b>cell index</b> for the given position (you must get the chunk's index to [obviously] know which chunk the position lied; see #ChunkIndexForPosition), or -1 if the position is out of bounds.
	End Rem
	Method ChunkCellForPosition:Int(x:Int, y:Int)
		If PosInBounds(x, y) = True
			'Return (y Mod 8) * 8 + (x Mod 8)
			Return (y Mod 8) Shl 3 + (x Mod 8)
		End If
		Return - 1
	End Method
	
	Rem
		bbdoc: Get the chunk index for the given tile position.
		returns: The index for the given tile position, or -1 if the position is out of bounds.
	End Rem
	Method ChunkIndexForPosition:Int(x:Int, y:Int)
		If PosInBounds(x, y) = True
			'Return (x Shr 3) * m_height + (y Shr 3)
			Return (y Shr 3) * (m_height Shr 3) + (x Shr 3)
		End If
		Return - 1
	End Method
	
	Rem
		bbdoc: Check if the given chunk index is within the map's bounds.
		returns: True if the index is within the map's bounds, or False if it is not.
	End Rem
	Method IndexInBounds:Int(index:Int)
		If index > - 1 And index < m_chunks
			Return True
		End If
		Return False
	End Method
	
	Rem
		bbdoc: Check if the given tile position is within the map's bounds.
		returns: True if the position is within the map's bounds, or False if it is not.
		about: @x (column) and @y (row) are zero based.
	End Rem
	Method PosInBounds:Int(x:Int, y:Int)
		'DebugLog("( TTileMap.PosInBounds() ) x = " + x + " y = " + y + " m_width = " + m_width + " m_height = " + m_height)
		If x > - 1 And x < m_width
			If y > - 1 And y < m_height
				Return True
			End If
		End If
		Return False
	End Method
	
	Rem
		_bbdoc: Check if a given tile position is within the map's window.
		_returns: True if the position is within the map's window, or False if it is not.
		_about: @x (column) and @y (row) are zero based.
	
	Method PosInWindow:Int(x:Int, y:Int)
		If x < m_window_x + m_window_width And x >= m_window_x
			If y < m_window_y + m_window_height And y >= m_window_y
				Return True
			End If
		End If
		Return False
	End Method
	End Rem
	
	Rem
		bbdoc: Clamp the given x and y values to the map's size (0 to width and 0 to height).
		returns: Nothing. The parameters will be set.
	End Rem
	Method ClampPos(x:Int Var, y:Int Var)
		ClampXPos(x)
		ClampYPos(y)
	End Method
	
	Rem
		bbdoc: Clamp the given x position.
		returns: Nothing. The parameter will be set.
	End Rem
	Method ClampXPos(x:Int Var)
		If x < 0
			x = 0
		Else If x >= m_width
			x = m_width - 1
		End If
	End Method
	
	Rem
		bbdoc: Clamp the given x position.
		returns: Nothing. The parameter will be set.
	End Rem
	Method ClampYPos(y:Int Var)
		If y < 0
			y = 0
		Else If y >= m_height
			y = m_height - 1
		End If
	End Method
	
'#end region (Position/Index based methods)
	
'#region Tile updating methods
	
	Rem
		bbdoc: Update the normals for all the tiles in the map (should be used after calling #Init, #DeSerialize or #Load).
		returns: Nothing.
	End Rem
	Method UpdateAllTiles()
		Local index:Int
		
		For index = 0 To m_chunks - 1
			UpdateChunkTilesAtIndex(index)
		Next
	End Method
	
	Rem
		bbdoc: Update all the internal tile positions and altitudes for the given chunk index.
		returns: Nothing.
		about: This method does not check if the given index is out of bounds.
	End Rem
	Method UpdateChunkTilesAtIndex(index:Int)
		Local chunk:TDrawnTileChunk, tile:TDrawnTile
		Local x:Int, y:Int, px:Int, py:Int, px2:Int, py2:Int
		
		chunk = m_data_terrain[index]
		px = (index Mod (m_height Shr 3)) Shl 3
		py = (index / (m_height Shr 3)) Shl 3
		For x = 0 To 7
			For y = 0 To 7
				px2 = px + x
				py2 = py + y
				
				tile = chunk.m_objects[y Shl 3 + x]
				tile.m_pos.m_x = px2
				tile.m_pos.m_y = py2
				
				If x < 7
					tile.m_rightz = chunk.m_objects[y Shl 3 + (x + 1)].m_pos.m_z
				Else
					tile.m_rightz = GetTileAltitudeAtPos(px2 + 1, py2)
				End If
				If y < 7
					tile.m_leftz = chunk.m_objects[(y + 1) Shl 3 + x].m_pos.m_z
				Else
					tile.m_leftz = GetTileAltitudeAtPos(px2, py2 + 1)
				End If
				If y < 7 And x < 7
					tile.m_bottomz = chunk.m_objects[(y + 1) Shl 3 + (x + 1)].m_pos.m_z
				Else
					tile.m_bottomz = GetTileAltitudeAtPos(px2 + 1, py2 + 1)
				End If
			Next
		Next
		
	End Method
	
	Rem
		bbdoc: Update the tile's internal position and altitudes at the position given.
		returns: Nothing.
		about: This does not check if the given position is in bounds.<br />
		If @opt_doconnections is True, the tiles connected to the top point of the given tile will also be updated.
	End Rem
	Method UpdateTileAtPos(x:Int, y:Int, opt_doconnections:Int = True)
		Local tile:TDrawnTile
		
		tile = GetTileAtPos(x, y)
		tile.Update(x, y, GetTileAltitudeAtPos(x, y + 1), GetTileAltitudeAtPos(x + 1, y), GetTileAltitudeAtPos(x + 1, y + 1))
		
		If opt_doconnections = True
			If PosInBounds(x - 1, y) = True
				UpdateTileAtPos(x - 1, y, False)
			End If
			If PosInBounds(x, y - 1) = True
				UpdateTileAtPos(x, y - 1, False)
			End If
			If PosInBounds(x - 1, y - 1) = True
				UpdateTileAtPos(x - 1, y - 1, False)
			End If
		End If
	End Method
	
	Rem
		bbdoc: Update all the internal tile resources in the map.
		returns: Nothing.
	End Rem
	Method UpdateAllTileResources()
		Local index:Int
		
		For index = 0 To m_chunks - 1
			UpdateChunkTileResourcesAtIndex(index)
		Next
	End Method
	
	Rem
		bbdoc: Update all the internal tile resources for the given chunk index.
		returns: Nothing.
		about: This method does not check if the given index is out of bounds.
	End Rem
	Method UpdateChunkTileResourcesAtIndex(index:Int)
		Local chunk:TDrawnTileChunk, tile:TDrawnTile
		Local x:Int, y:Int
		
		chunk = m_data_terrain[index]
		For x = 0 To 7
			For y = 0 To 7
				tile = chunk.m_objects[y Shl 3 + x]
				tile.UpdateResource(TMapTileResource(m_tileres.GetResourceByID(tile.m_resourceid)))
			Next
		Next
	End Method
	
	Rem
		bbdoc: Update the normals for all the tiles in the map (should be used after calling #Init, #DeSerialize or #Load).
		returns: Nothing.
		about: This expects all the tiles to have previously been updated (internal position and altitude); see #UpdateAllTiles.
	End Rem
	Method UpdateAllTileNormals()
		Local index:Int
		
		For index = 0 To m_chunks - 1
			UpdateChunkNormalsAtIndex(index)
		Next
	End Method
	
	Rem
		bbdoc: Update all the normals for each tile in the given chunk.
		returns: Nothing.
		about: This method does not check if the given index is out of bounds.
	End Rem
	Method UpdateChunkNormalsAtIndex(index:Int)
		Local chunk:TDrawnTileChunk, tile:TDrawnTile
		Local basenormals:TVec3[10, 10, 4], bvec:TVec3, wvec:TVec3
		Local x:Int, y:Int
		Local px:Int, py:Int, px2:Int, py2:Int
		
		chunk = m_data_terrain[index]
		px = (index Mod (m_height Shr 3)) Shl 3
		py = (index / (m_height Shr 3)) Shl 3
		
		wvec = New TVec3
		
		For y = -1 To 8
			For x = -1 To 8
				
				px2 = px + x
				py2 = py + y
				
				If y > - 1 And y < 8 And x > - 1 And x < 8
					tile = chunk.m_objects[y Shl 3 + x]
				Else
					tile = GetTileAtPos(px2, py2)
				End If
				
				If (tile = Null) Or (tile.m_pos.m_z = tile.m_leftz And tile.m_pos.m_z = tile.m_rightz And tile.m_pos.m_z = tile.m_bottomz)
					basenormals[x + 1, y + 1, 0] = New TVec3.Create(0.0, 0.0, 1.0)
					basenormals[x + 1, y + 1, 1] = New TVec3.Create(0.0, 0.0, 1.0)
					basenormals[x + 1, y + 1, 2] = New TVec3.Create(0.0, 0.0, 1.0)
					basenormals[x + 1, y + 1, 3] = New TVec3.Create(0.0, 0.0, 1.0)
				Else
					bvec = New TVec3.Create(-22, 22, (tile.m_pos.m_z - tile.m_rightz Shl 2))
					wvec.Set(-22, -22, (tile.m_leftz - tile.m_pos.m_z Shl 2))
					wvec.CrossProductVec(wvec)
					bvec.Normalize()
					basenormals[x + 1, y + 1, 0] = bvec
					
					bvec = New TVec3.Create(22, 22, (tile.m_rightz - tile.m_bottomz Shl 2))
					wvec.Set(-22, 22, (tile.m_pos.m_z - tile.m_rightz Shl 2))
					bvec.CrossProductVec(wvec)
					bvec.Normalize()
					basenormals[x + 1, y + 1, 1] = bvec
					
					bvec = New TVec3.Create(22, -22, (tile.m_bottomz - tile.m_leftz Shl 2))
					wvec.Set(22, 22, (tile.m_rightz - tile.m_bottomz Shl 2))
					bvec.CrossProductVec(wvec)
					bvec.Normalize()
					basenormals[x + 1, y + 1, 2] = bvec
					
					bvec = New TVec3.Create(-22, -22, (tile.m_leftz - tile.m_pos.m_z Shl 2))
					wvec.Set(22, -22, (tile.m_bottomz - tile.m_leftz Shl 2))
					bvec.CrossProductVec(wvec)
					bvec.Normalize()
					basenormals[x + 1, y + 1, 3] = bvec
				End If
				
			Next
		Next
		
		chunk.UpdateNormals(basenormals)
	End Method
	
	Rem
		bbdoc: Update the normals for the tile at the given position.
		returns: Nothing.
		about: This method does not check if the given position is out of bounds.
	End Rem
	Method UpdateTileNormalsAtPos(px:Int, py:Int)
		Local tile:TDrawnTile
		Local basenormals:TVec3[3, 3, 4], bvec:TVec3, wvec:TVec3
		Local x:Int, y:Int, px2:Int, py2:Int
		
		wvec = New TVec3
		
		For y = -1 To 1
			For x = -1 To 1
				px2 = px + x
				py2 = py + y
				tile = GetTileAtPos(px2, py2)
				
				If (tile = Null) Or (tile.m_pos.m_z = tile.m_leftz And tile.m_pos.m_z = tile.m_rightz And tile.m_pos.m_z = tile.m_bottomz)
					basenormals[x + 1, y + 1, 0] = New TVec3.Create(0.0, 0.0, 1.0)
					basenormals[x + 1, y + 1, 1] = New TVec3.Create(0.0, 0.0, 1.0)
					basenormals[x + 1, y + 1, 2] = New TVec3.Create(0.0, 0.0, 1.0)
					basenormals[x + 1, y + 1, 3] = New TVec3.Create(0.0, 0.0, 1.0)
				Else
					bvec = New TVec3.Create(-22, 22, (tile.m_pos.m_z - tile.m_rightz Shl 2))
					wvec.Set(-22, -22, (tile.m_leftz - tile.m_pos.m_z Shl 2))
					wvec.CrossProductVec(wvec)
					bvec.Normalize()
					basenormals[x + 1, y + 1, 0] = bvec
					
					bvec = New TVec3.Create(22, 22, (tile.m_rightz - tile.m_bottomz Shl 2))
					wvec.Set(-22, 22, (tile.m_pos.m_z - tile.m_rightz Shl 2))
					bvec.CrossProductVec(wvec)
					bvec.Normalize()
					basenormals[x + 1, y + 1, 1] = bvec
					
					bvec = New TVec3.Create(22, -22, (tile.m_bottomz - tile.m_leftz Shl 2))
					wvec.Set(22, 22, (tile.m_rightz - tile.m_bottomz Shl 2))
					bvec.CrossProductVec(wvec)
					bvec.Normalize()
					basenormals[x + 1, y + 1, 2] = bvec
					
					bvec = New TVec3.Create(-22, -22, (tile.m_leftz - tile.m_pos.m_z Shl 2))
					wvec.Set(22, -22, (tile.m_bottomz - tile.m_leftz Shl 2))
					bvec.CrossProductVec(wvec)
					bvec.Normalize()
					basenormals[x + 1, y + 1, 3] = bvec
				End If
				
			Next
		Next
		
		x = 1
		y = 1
		tile = GetTileAtPos(px, py)
		tile.UpdateNormals(x, y, basenormals)
		
	End Method
	
'#end region (Tile updating methods)
	
'#region Static updating methods
	
	Rem
		bbdoc: Update the internal positions for all the statics in the map.
		returns: Nothing.
	End Rem
	Method UpdateAllStaticPositions()
		Local x:Int, y:Int
		
		For x = 0 To m_width - 1
			For y = 0 To m_height - 1
				UpdateStaticPositionsAtPos(x, y)
			Next
		Next
	End Method
	
	Rem
		bbdoc: Update all the internal positions for the statics at the given position.
		returns: Nothing.
	End Rem
	Method UpdateStaticPositionsAtPos(x:Int, y:Int)
		Local statics:TDrawnStatic[], static:TDrawnStatic
		
		statics = m_data_statics[y, x]
		If statics <> Null
			For static = EachIn statics
				static.UpdatePosition(x, y)
			Next
		End If
	End Method
	
	Rem
		bbdoc: Update the internal resources for all the statics in the map.
		returns: Nothing.
	End Rem
	Method UpdateAllStaticResources()
		Local x:Int, y:Int
		
		For x = 0 To m_width - 1
			For y = 0 To m_height - 1
				UpdateStaticResourcesAtPos(x, y)
			Next
		Next
	End Method
	
	Rem
		bbdoc: Update all the internal resources for the statics at the given position.
		returns: Nothing.
	End Rem
	Method UpdateStaticResourcesAtPos(x:Int, y:Int)
		Local statics:TDrawnStatic[], static:TDrawnStatic
		
		statics = m_data_statics[y, x]
		If statics <> Null
			For static = EachIn statics
				static.UpdateResource(TMapStaticResource(m_staticres.GetResourceByID(static.m_resourceid)))
			Next
		End If
	End Method
	
'#end region (Static updating methods)
	
'#region Drawing cache
	
	Rem
	Method RecalculateDrawCache() '(clearall:Int)
		Local x:Int, y:Int
		Local index:Int
		Local px:Int, py:Int
		Local diff:Byte
		
		'If clearall = True
		'	ClearWorldCache()
		'	WorldCache.SetAllInvis()
		'End If
		
		m_drawcache.Clear()
		
		px = m_handler.m_player.m_pos.m_x Shr 3
		py = m_handler.m_player.m_pos.m_y Shr 3
		
		' früher war das ne 4, aber ne 2 scheint auch zu reichen ?!?
		' Back then it was a four, but a two seems to suffice? (sentence does not make sense, seeing as 'diff' is still 4)
		
		diff = 4
		
		For x = px - diff To px + diff
			For y = py - diff To py + diff
				index = x * m_height + y
				If (x >= px - 3) And (x <= px + 3) And (y >= py - 3) And (y <= py + 3)
					m_drawcache.AddChunk(index)
				Else
					m_drawcache.HideBlock(index)
					'm_drawcache.CheckObjectDistances(index, m_handler.m_player.m_pos)
				End If
			Next
		Next
		m_drawcache.m_sorted = False
	End Method
	End Rem
	
'#end region (Drawing cache)
	
	Rem
		bbdoc: Draw the map (offset by a screen position).
		returns: Nothing.
	End Rem
	Method Draw()
		Local cr:Int, cc:Int, crow:Int, ccolumn:Int
		
		Local tile:TDrawnTile
		Local static:TDrawnStatic, statics:TDrawnStatic[]
		Local terrainlayer:Int, staticlayer:Int
		
		terrainlayer = (m_handler.m_use_terrain_collision = True) And m_handler.m_collision_layer Or 0
		staticlayer = (m_handler.m_use_static_collision = True) And m_handler.m_collision_layer Or 0
		
		' Offset orientation
		'Local xoff:Int = m_window_x' Shl 1  + (m_window_width * TILEWIDTH_2)
		
		Local pposition:TMapPos, pmovement:TVec3
		pposition = m_handler.m_playerpos
		pmovement = m_handler.m_playermovement
		
		cr = IntMax(pposition.m_y + 19, m_height - 1)
		cc = IntMax(pposition.m_x + 19, m_width - 1)
		
		' Might want to change these to Floats (and the parameters in the Draw method for DrawnObjects to Floats as well)
		Local reldrawx:Int = m_window_x + (m_window_width Shr 1) + (-pposition.m_x + pposition.m_y) * 22 - pmovement.m_x
		Local reldrawy:Int = m_window_y + (-pposition.m_x - pposition.m_y) * 22 + pposition.m_z Shl 3 - pmovement.m_y + Int(pmovement.m_z) Shl 2
		
		For crow = pposition.m_y To cr
			For ccolumn = pposition.m_x To cc
				If m_handler.m_draw_terrain = True
					tile = GetTileAtPos(ccolumn, crow)
					m_environment.BindAmbientColor()
					If m_handler.m_coll_terrain = tile Then m_handler.BeforeCollidingTileDrawn()
					tile.Render(reldrawx, reldrawy, terrainlayer)
					If m_handler.m_draw_terrain = True Then m_handler.AfterTileDrawn(tile)
				End If
				
				If m_handler.m_draw_statics = True
					statics = m_data_statics[crow, ccolumn]
					If statics <> Null
						m_environment.BindAmbientColor()
						For static = EachIn statics
							If static = m_handler.m_coll_static Then m_handler.BeforeCollidingStaticDrawn()
							'drawx = mxoff - (resimage.width / 2)
							'drawy = myoff - resimage.height + 44.0 + (4.0 * -static.m_z) + 2.0
							
							static.Render(reldrawx, reldrawy, staticlayer)
							If static = m_handler.m_coll_static Then m_environment.BindAmbientColor()
						Next
					End If
				End If
				
			Next
		Next
		
		m_handler.FinishedDrawing()
	End Method
	
'#region Data handling
	
	Rem
		bbdoc: Deserialize a TileMap from a stream.
		returns: The deserialized TileMap (itself).
		about: Instead of creating a new TileMap and then deserializing, you should do `New TTileMap.DeSerialize(stream)` (or just `TTileMap.Load(stream)` ) - to avoid initiating the data arrays twice.
	End Rem
	Method DeSerialize:TTileMap(stream:TStream)
		Local x:Int, y:Int, n:Int, count:Int, statics:TDrawnStatic[]
		
		SetName(ReadNString(stream))
		
		SetWidth(stream.ReadInt())
		SetHeight(stream.ReadInt())
		UpdateChunkCount()
		
		_Init()
		
		m_stream_tilepos = stream.Pos()
		For n = 0 To m_chunks - 1
			m_data_terrain[n].DeSerialize(stream, False)
		Next
		
		For y = 0 To m_height - 1
			For x = 0 To m_width - 1
				count = Int(stream.ReadByte())
				If count > 0
					statics = New TDrawnStatic[count]
					For n = 0 To count - 1
						statics[n] = New TDrawnStatic.DeSerialize(stream)
					Next
					m_data_statics[y, x] = statics
				End If
			Next
		Next
		
		UpdateAllTiles()
		UpdateAllTileNormals()
		UpdateAllStaticPositions()
		
		' Not updating internal resources because certain code flow would put the map without resource sets
		
		Return Self
	End Method
	
	Rem
		bbdoc: Serialize the TileMap into a stream.
		returns: Nothing.
		about: If a tile has the resource id -1 it will not be saved.
	End Rem
	Method Serialize(stream:TStream)
		Local x:Int, y:Int, n:Int, statics:TDrawnStatic[]
		
		WriteNString(stream, m_name)
		
		stream.WriteInt(m_width)
		stream.WriteInt(m_height)
		
		' Save chunks
		For n = 0 To m_chunks - 1
			m_data_terrain[n].Serialize(stream, False)
		Next
		
		' Save all statics
		For y = 0 To m_height - 1
			For x = 0 To m_width - 1
				statics = m_data_statics[y, x]
				If statics = Null
					stream.WriteByte(0)
				Else
					stream.WriteByte(Byte(statics.Length))
					For n = 0 To statics.Length - 1
						statics[n].Serialize(stream)
					Next
				End If
			Next
		Next

	End Method
	
	Rem
		bbdoc: Load a TileMap from a stream.
		returns: The loaded TileMap.
		about: This function will create a new TileMap (_Init is not called twice) and deserialize it from the stream.
	End Rem
	Function Load:TTileMap(stream:TStream)
		Return New TTileMap.DeSerialize(stream)
	End Function
	
'#end region (Data handling)
	
	Function InitGL()
		Local lightpos:Float[4], ambient:Float[4]
		
		'glEnable(GL_ALPHA_TEST)
		'glAlphaFunc(GL_GREATER, 0.1)
		
		glEnable(USING_GL_LIGHT)
		
		lightpos[0] = - 1.0
		lightpos[1] = - 1.0
		lightpos[2] = 0.5
		lightpos[3] = 0.0
		glLightfv(USING_GL_LIGHT, GL_POSITION, lightpos)
		
		ambient[0] = 2.0
		ambient[1] = 2.0
		ambient[2] = 2.0
		ambient[3] = 1.0
		glLightfv(USING_GL_LIGHT, GL_AMBIENT, ambient)
		
		ambient[0] = 1.0
		ambient[1] = 1.0
		ambient[2] = 1.0
		ambient[3] = 1.0
		glLightModelfv(GL_LIGHT_MODEL_AMBIENT, ambient)
		
		glLightModeli(GL_LIGHT_MODEL_TWO_SIDE, False)
	End Function
	
End Type

Rem
	bbdoc: The TileMapHandler type.
	about: This type holds and handles the player position procedures/fields and any other features/options in a TileMap.<br />
	The terrain collision layer defaults to the 17th, and the static collision layer to the 18th.
End Rem
Type TTileMapHandler Abstract
	
	Field m_map:TTileMap
	
	' Player fields
	Field m_playerpos:TMapPos
	Field m_playermovement:TVec3
	
	' Other TileMap-related fields
	Field m_draw_terrain:Int = True, m_draw_statics:Int = True
	Field m_use_terrain_collision:Int = True, m_use_static_collision:Int = True
	Field m_collision_layer:Int = 0
	
	Field m_coll_static:TDrawnStatic, m_coll_terrain:TDrawnTile
	
	Rem
		bbdoc: Initiate the TTileMapHandler.
		returns: Nothing.
	End Rem
	Method Init(map:TTileMap, playerpos:TMapPos, playermovement:TVec3, draw_terrain:Int = True, draw_statics:Int = True)
		m_map = map
		
		m_playerpos = playerpos
		m_playermovement = playermovement
		
		m_draw_terrain = draw_terrain
		m_draw_statics = draw_statics
	End Method
	
'#region Field accessors
	
	Rem
		bbdoc: Set the collision layer used for tiles and statics.
		returns: Nothing.
	End Rem
	Method SetCollisionLayer(layer:Int)
		m_collision_layer = layer
	End Method
	Rem
		bbdoc: Get the collision layer used for tiles and statics.
		returns: The collision layer for the handler.
	End Rem
	Method GetCollisionLayer:Int()
		Return m_collision_layer
	End Method
	
	Rem
		bbdoc: Turn on (True) or off (False) terrain collision.
		returns: Nothing.
	End Rem
	Method SetTerrainCollision(state:Int)
		m_use_terrain_collision = state
	End Method
	Rem
		bbdoc: Get the terrain collision use state.
		returns: True if terrain collision is on, or False if it is off.
	End Rem
	Method GetTerrainCollision:Int()
		Return m_use_terrain_collision
	End Method
	
	Rem
		bbdoc: Turn on (True) or off (False) static collision.
		returns: Nothing.
	End Rem
	Method SetStaticCollision(state:Int)
		m_use_static_collision = state
	End Method
	Rem
		bbdoc: Get the static collision use state.
		returns: True if static collision is on, or False if it is off.
	End Rem
	Method GetStaticCollision:Int()
		Return m_use_static_collision
	End Method
	
'#end region Field accessors
	
	Rem
		bbdoc: This method is called before the colliding tile is drawn.
		returns: Nothing.
	End Rem
	Method BeforeCollidingTileDrawn()
	End Method
	
	Rem
		bbdoc: This method is called after a tile is drawn.
		returns: Nothing.
		about: @tile is the tile that was drawn.
	End Rem
	Method AfterTileDrawn(tile:TDrawnTile)
	End Method
	
	Rem
		bbdoc: This method is called before coll_static is drawn.
		returns: Nothing.
	End Rem
	Method BeforeCollidingStaticDrawn()
	End Method
	
	Rem
		bbdoc: This method is called when all map rendering is complete.
		returns: Nothing.
	End Rem
	Method FinishedDrawing()
	End Method
	
	Rem
		bbdoc: Move the player by an offset.
		returns: Nothing.
	End Rem
	Method MovePlayer(x_change:Int, y_change:Int)
		SetPlayerPosition(m_playerpos.m_x + x_change, m_playerpos.m_y + y_change)
	End Method
	
	Rem
		bbdoc: Set the player's position.
		returns: Nothing.
	End Rem
	Method SetPlayerPosition(x:Int, y:Int)
		m_map.ClampPos(x, y)
		If x <> m_playerpos.m_x Or y <> m_playerpos.m_y
			m_playerpos.m_x = x
			m_playerpos.m_y = y
			
			m_playerpos.m_z = m_map.GetTileAltitudeAtPos(m_playerpos.m_x, m_playerpos.m_y)
			
			' TODO: Set flags for a needed map drawing list recalculation
		End If
	End Method
	
End Type
















