
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

TODO:
	[dTileMapHandler.SetPlayerPosition] Set flags for a needed map drawing cache recalculation
End Rem

Rem
	bbdoc: duct tile map.
	about: It is extemely important that you not change any given tile in the map to Null (Null [and other] checks are left out for max rendering speed).<br>
	Resource ID -1 is interpreted as a blank tile (black).
End Rem
Type dTileMap
	
	Global USING_GL_LIGHT:Int = GL_LIGHT1
	
	' Basic stats
	Field m_name:String
	Field m_width:Int, m_height:Int, m_chunks:Int
	
	' Assistants (resource sets, handler and environment)
	Field m_handler:dTileMapHandler
	Field m_tileres:dMapResourceSet, m_staticres:dMapResourceSet
	Field m_environment:dMapEnvironment
	
	' Map data
	Field m_data_terrain:dDrawnTileChunk[], m_data_statics:dDrawnStatic[][,]
	Field m_stream_tilepos:Int ' Beginning location, in bytes, for the tile section of a map file
	
	' Positioning
	'Field m_pov:dMapPos
	Field m_window_x:Int, m_window_y:Int, m_window_width:Int, m_window_height:Int
	Field m_use_light:Int = True
	
	' Render cache
	'Field m_drawcache:dTileMapDrawCache
	
	Method New()
		'm_drawcache = New dTileMapDrawCache.Create()
	End Method
	
	Rem
		bbdoc: Initialize the default map array
		returns: Nothing.
		about: This will recreate the terrain chunk & static arrays (fills each terrain cell with a new tile - resid of @resid and z of @altitude).
	End Rem
	Method _init(base_resid:Int = -1, base_altitude:Int = 0)
		m_data_terrain = New dDrawnTileChunk[m_chunks]
		m_data_statics = New dDrawnStatic[][m_height, m_width]
		For Local n:Int = 0 Until m_chunks
			m_data_terrain[n] = New dDrawnTileChunk.Create(Null, base_resid, base_altitude)
		Next
	End Method
	
	Rem
		bbdoc: Create a new tile map.
		returns: Itself.
		about: NOTE: This method initiates the tile array (@resid and @altitude are the parameters passed to the #_init method).<br>
		IMPORTANT: @width and @height must be evenly divisble by 8. See #SetWidth and #SetHeight for more information.
	End Rem
	Method Create:dTileMap(name:String, width:Int, height:Int, environment:dMapEnvironment, handler:dTileMapHandler, base_resid:Int = -1, base_altitude:Int = 0)
		SetName(name)
		SetWidth(width)
		SetHeight(height)
		UpdateChunkCount()
		SetEnvironment(environment)
		SetHandler(handler)
		_init(base_resid, base_altitude)
		Return Self
	End Method
	
'#region Field accessors
	
	Rem
		bbdoc: Set the map's environment.
		returns: Nothing.
	End Rem
	Method SetEnvironment(environment:dMapEnvironment)
		m_environment = environment
	End Method
	Rem
		bbdoc: Get the map's environment.
		returns: The environment for the map.
	End Rem
	Method GetEnvironment:dMapEnvironment()
		Return m_environment
	End Method
	
	Rem
		bbdoc: Set the map's handler.
		returns: Nothing.
	End Rem
	Method SetHandler(handler:dTileMapHandler)
		m_handler = handler
	End Method
	Rem
		bbdoc: Get the map's handler.
		returns: The handler for the map.
	End Rem
	Method GetHandler:dTileMapHandler()
		Return m_handler
	End Method
	
	Rem
		bbdoc: Set the tile rendering resource map.
		returns: Nothing.
		about: This will set the resource map used to render tiles.
	End Rem
	Method SetTileResourceMap(set:dMapResourceSet)
		m_tileres = set
	End Method
	Rem
		bbdoc: Get the tile resource map.
		returns: Get the resource map used to render tiles.
	End Rem
	Method GetTileResourceMap:dMapResourceSet()
		Return m_tileres
	End Method
	
	Rem
		bbdoc: Set the static rendering resource map.
		returns: Nothing.
		about: This will set the resource map used to render statics.
	End Rem
	Method SetStaticResourceMap(set:dMapResourceSet)
		m_staticres = set
	End Method
	Rem
		bbdoc: Get the static resource map.
		returns: Get the resource map used to render statics.
	End Rem
	Method GetStaticResourceMap:dMapResourceSet()
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
		Assert IsDivisible(width, 8), "(dTileMap.SetWidth()) Width (" + width + ") must be evenly divisible by 8!"
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
		Assert IsDivisible(height, 8), "(dTileMap.SetHeight()) Height (" + height + ") must be evenly divisible by 8!"
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
		'DebugLog("( dTileMap.UpdateChunkCount() ) m_chunks = " + m_chunks)
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
		bbdoc: Set the rendering window's size.
		returns: Nothing.
	End Rem
	Method SetWindowSize(width:Int, height:Int)
		m_window_width = width
		m_window_height = height
	End Method
	Rem
		bbdoc: Set the rendering window's size.
		returns: Nothing. The parameters will be set to their respective values.
	End Rem
	Method GetWindowSize(width:Int Var, height:Int Var)
		width = m_window_width
		height = m_window_height
	End Method
	
	Rem
		bbdoc: Set the rendering window's position.
		returns: Nothing.
	End Rem
	Method SetWindowPosition(x:Int, y:Int)
		m_window_x = x
		m_window_y = y
	End Method
	Rem
		bbdoc: Get the rendering window's position.
		returns: Nothing. The parameters will be set to their respective values.
	End Rem
	Method GetWindowPosition(x:Int Var, y:Int Var)
		x = m_window_x
		y = m_window_y
	End Method
	
	Rem
		bbdoc: Set the x position of the rendering window.
		returns: Nothing.
	End Rem
	Method SetWindowX(x:Int)
		m_window_x = x
	End Method
	Rem
		bbdoc: Get the x position of the rendering window.
		returns: The x position of the rendering window.
	End Rem
	Method GetWindowX:Int()
		Return m_window_x
	End Method
	
	Rem
		bbdoc: Set the y position of the rendering window.
		returns: Nothing.
	End Rem
	Method SetWindowY(y:Int)
		m_window_y = y
	End Method
	Rem
		bbdoc: Get the y position of the rendering window.
		returns: The y position of the rendering window.
	End Rem
	Method GetWindowY:Int()
		Return m_window_y
	End Method
	
	Rem
		bbdoc: Set the width of the rendering window.
		returns: Nothing.
	End Rem
	Method SetWindowWidth(width:Int)
		m_window_width = width
	End Method
	Rem
		bbdoc: Get the width of the rendering window.
		returns: The width of the rendering window.
	End Rem
	Method GetWindowWidth:Int()
		Return m_window_width
	End Method
	
	Rem
		bbdoc: Set the height of the rendering window.
		returns: Nothing.
	End Rem
	Method SetWindowHeight(height:Int)
		m_window_height = height
	End Method
	Rem
		bbdoc: Get the height of the rendering window.
		returns: The height of the rendering window.
	End Rem
	Method GetWindowHeight:Int()
		Return m_window_height
	End Method
	
'#end region Field accessors
	
'#region Tile and static collections
	
	Rem
		bbdoc: Add an array of statics to a position in the map.
		returns: True if the array was added to the given position, or False if it was not (position was out of bounds, or the given array was Null).
	End Rem
	Method AddStaticArrayToPos:Int(statics:dDrawnStatic[], x:Int, y:Int, dosort:Int = True)
		If PosInBounds(x, y) And statics
			Local posstatics:dDrawnStatic[] = m_data_statics[y, x]
			If posstatics
				posstatics = posstatics + statics
			Else
				posstatics = statics
			End If
			For Local i:Int = 0 Until statics.Length
				statics[i].UpdatePosition(x, y)
			Next
			If dosort Then posstatics.Sort()
			m_data_statics[y, x] = posstatics
			Return True
		End If
		Return False
	End Method
	
	Rem
		bbdoc: Add a static to a position in the map.
		returns: True if the static was added to the given position, or False if it was not (position was out of bounds or given static was Null).
	End Rem
	Method AddStaticToPos:Int(static:dDrawnStatic, x:Int, y:Int, dosort:Int = True)
		If PosInBounds(x, y) And static
			Local posstatics:dDrawnStatic[] = m_data_statics[y, x]
			If posstatics
				posstatics = posstatics[..posstatics.Length + 1]
			Else
				posstatics = New dDrawnStatic[1]
			End If
			posstatics[posstatics.Length - 1] = static
			static.UpdatePosition(x, y)
			If dosort And posstatics.Length > 1 Then posstatics.Sort()
			m_data_statics[y, x] = posstatics
			Return True
		End If
		Return False
	End Method
	
	Rem
		bbdoc: Get an array of the statics at the given position.
		returns: The array of statics at the given position, or Null if either the position was out of bounds or if there are no statics at the given position.
	End Rem
	Method GetStaticsAtPos:dDrawnStatic[](x:Int, y:Int)
		Local statics:dDrawnStatic[]
		If PosInBounds(x, y)
			statics = m_data_statics[y, x]
		End If
		Return statics
	End Method
	
	Rem
		bbdoc: Remove a static from the map by its position and index.
		returns: True if the static at the given position and index was removed, or False if it was not removed.
	End Rem
	Method RemoveStaticAtPosByIndex:Int(x:Int, y:Int, index:Int, dosort:Int = True)
		Local statics:dDrawnStatic[]
		If PosInBounds(x, y)
			statics = m_data_statics[y, x]
			If statics
				If index > -1 And index <= statics.Length - 1
					If statics.Length = 1
						statics = Null
					Else If index = 0
						statics = statics[1..]
					Else If index = statics.Length - 1
						statics = statics[..statics.Length - 1]
					Else
						statics = statics[..index] + statics[index + 1..]
					End If
					If statics And dosort Then statics.Sort()
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
	Method RemoveStaticAtPos:Int(x:Int, y:Int, static:dDrawnStatic, dosort:Int = True)
		If PosInBounds(x, y)
			Local statics:dDrawnStatic[] = m_data_statics[y, x]
			If statics
				For Local i:Int = 0 Until statics.Length
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
		returns: True if the tile at the given position was set, or False if the position was out of bounds.
		about: @x (column) and @y (row) are zero based.
	End Rem
	Method SetTileAtPos:Int(dtile:dDrawnTile, x:Int, y:Int)
		If PosInBounds(x, y)
			Local index:Int = (y Shr 3) * (m_height Shr 3) + (x Shr 3)
			Local cell:Int = (y Mod 8) Shl 3 + (x Mod 8)
			'DebugLog("( dTileMap.SetTileAtPos() ) x = " + x + " y = " + y + " index = " + index + " cell = " + cell)
			m_data_terrain[index].m_objects[cell] = dtile
			dtile.UpdatePosition(x, y)
			Return True
		End If
		Return False
	End Method
	
	Rem
		bbdoc: Get a tile from the map by its position.
		returns: The drawn tile at the position given, or Null if the position is out of bounds.
		about: @x (column) and @y (row) are zero based.
	End Rem
	Method GetTileAtPos:dDrawnTile(x:Int, y:Int)
		If PosInBounds(x, y)
			Local index:Int = (y Shr 3) * (m_height Shr 3) + (x Shr 3)
			Local cell:Int = (y Mod 8) Shl 3 + (x Mod 8)
			'DebugLog("( dTileMap.GetTileAtPos() ) x = " + x + " y = " + y + " index = " + index + " cell = " + cell)
			Return m_data_terrain[index].m_objects[cell]
		End If
		Return Null
	End Method
	
	Rem
		bbdoc: Get the altitude (z position) for the tile at the given position.
		returns: The altitude for the tile (0 will be the default return if the position is out of bounds).
	End Rem
	Method GetTileAltitudeAtPos:Int(x:Int, y:Int)
		Local tile:dDrawnTile = GetTileAtPos(x, y)
		If tile
			Return tile.m_pos.m_z
		End If
		Return 0
	End Method
	
'#end region Tile and static collections
	
'#region Position/index based methods
	
	Rem
		bbdoc: 
		returns: True if the index and cell is in bounds and if the position parameters were set, or False if not.
		about: The parameters @x and @y are set to the position.
	End Rem
	Method GetPositionFromIndexAndCell:Int(index:Int, cell:Int, x:Int Var, y:Int Var)
		If IndexInBounds(index) And dDrawnTileChunk.CellInBounds(cell)
			Local basex:Int, basey:Int
			BeginningPositionForChunkIndex(index, basex, basey)
			dDrawnTileChunk.GetPositionFromCell(cell, x, y)
			x:+ basex
			y:+ basey
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
		If IndexInBounds(index)
			' 'X' and 'Y' are the relative positions within a chunk (not cell or real object position)
			' px and py seem to be flipped (at least for my definition they are)
			'py = (BlockID Mod height) * 8 + Y
			'px = (BlockID / height) * 8 + X
			x = (index Mod (m_height Shr 3)) Shl 3
			y = (index / (m_height Shr 3)) Shl 3
			Return True
		End If
		Return False
	End Method
	
	Rem
		bbdoc: 
		returns: The chunk <b>cell index</b> for the given position (you must get the chunk's index to [obviously] know which chunk the position lied; see #ChunkIndexForPosition), or -1 if the position is out of bounds.
	End Rem
	Method ChunkCellForPosition:Int(x:Int, y:Int)
		If PosInBounds(x, y)
			'Return (y Mod 8) * 8 + (x Mod 8)
			Return (y Mod 8) Shl 3 + (x Mod 8)
		End If
		Return -1
	End Method
	
	Rem
		bbdoc: Get the chunk index for the given tile position.
		returns: The index for the given tile position, or -1 if the position is out of bounds.
	End Rem
	Method ChunkIndexForPosition:Int(x:Int, y:Int)
		If PosInBounds(x, y)
			'Return (x Shr 3) * m_height + (y Shr 3)
			Return (y Shr 3) * (m_height Shr 3) + (x Shr 3)
		End If
		Return -1
	End Method
	
	Rem
		bbdoc: Check if the given chunk index is within the map's bounds.
		returns: True if the index is within the map's bounds, or False if it is not.
	End Rem
	Method IndexInBounds:Int(index:Int)
		If index > -1 And index < m_chunks
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
		'DebugLog("(dTileMap.PosInBounds) x = " + x + " y = " + y + " m_width = " + m_width + " m_height = " + m_height)
		If x > -1 And x < m_width
			If y > -1 And y < m_height
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
	
'#end region Position/index based methods
	
'#region Tile updating methods
	
	Rem
		bbdoc: Update the normals for all the tiles in the map (should be used after calling #Init, #Deserialize or #Load).
		returns: Nothing.
	End Rem
	Method UpdateAllTiles()
		For Local index:Int = 0 Until m_chunks
			UpdateChunkTilesAtIndex(index)
		Next
	End Method
	
	Rem
		bbdoc: Update all the internal tile positions and altitudes for the given chunk index.
		returns: Nothing.
		about: This method does not check if the given index is out of bounds.
	End Rem
	Method UpdateChunkTilesAtIndex(index:Int)
		Local chunk:dDrawnTileChunk = m_data_terrain[index]
		Local px:Int = (index Mod (m_height Shr 3)) Shl 3
		Local py:Int = (index / (m_height Shr 3)) Shl 3
		Local tile:dDrawnTile, px2:Int, py2:Int
		For Local x:Int = 0 Until 8
			For Local y:Int = 0 Until 8
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
		bbdoc: Update the given tile's internal position and altitudes.
		returns: Nothing.
		about: If @opt_doconnections is True, the tiles connected to the top point of the given tile will also be updated.
	End Rem
	Method UpdateTile(tile:dDrawnTile, opt_doconnections:Int = True)
		Local x:Int = tile.m_pos.m_x
		Local y:Int = tile.m_pos.m_y
		tile.Update(x, y, GetTileAltitudeAtPos(x, y + 1), GetTileAltitudeAtPos(x + 1, y), GetTileAltitudeAtPos(x + 1, y + 1))
		If opt_doconnections
			If PosInBounds(x - 1, y)
				UpdateTileAtPos(x - 1, y, False)
			End If
			If PosInBounds(x, y - 1)
				UpdateTileAtPos(x, y - 1, False)
			End If
			If PosInBounds(x - 1, y - 1)
				UpdateTileAtPos(x - 1, y - 1, False)
			End If
		End If
	End Method
	
	Rem
		bbdoc: Update the tile's internal position and altitudes at the given position.
		returns: Nothing.
		about: NOTE: This does not check if the given position is in bounds.<br>
		If @opt_doconnections is True, the tiles connected to the top point of the given tile will also be updated.
	End Rem
	Method UpdateTileAtPos(x:Int, y:Int, opt_doconnections:Int = True)
		Local tile:dDrawnTile = GetTileAtPos(x, y)
		UpdateTile(tile, opt_doconnections)
	End Method
	
	Rem
		bbdoc: Update all the internal tile resources in the map.
		returns: Nothing.
	End Rem
	Method UpdateAllTileResources()
		For Local index:Int = 0 Until m_chunks
			UpdateChunkTileResourcesAtIndex(index)
		Next
	End Method
	
	Rem
		bbdoc: Update the given tile's resource with the map's tile set.
		returns: True if the tile's resource was updated, or False if the tile's resource id was not found.
	End Rem
	Method UpdateTileResource:Int(tile:dDrawnTile)
		Return m_tileres.UpdateTileResource(tile)
	End Method
	
	Rem
		bbdoc: Update all the internal tile resources for the given chunk index.
		returns: Nothing.
		about: This method does not check if the given index is out of bounds.
	End Rem
	Method UpdateChunkTileResourcesAtIndex(index:Int)
		Local chunk:dDrawnTileChunk = m_data_terrain[index]
		Local tile:dDrawnTile
		For Local x:Int = 0 Until 8
			For Local y:Int = 0 Until 8
				tile = chunk.m_objects[y Shl 3 + x]
				tile.UpdateResource(dMapTileResource(m_tileres.GetResourceWithID(tile.m_resourceid)))
			Next
		Next
	End Method
	
	Rem
		bbdoc: Update the normals for all the tiles in the map (should be used after calling #Init, #Deserialize or #Load).
		returns: Nothing.
		about: This expects all the tiles to have previously been updated (internal position and altitude); see #UpdateAllTiles.
	End Rem
	Method UpdateAllTileNormals()
		For Local index:Int = 0 Until m_chunks
			UpdateChunkNormalsAtIndex(index)
		Next
	End Method
	
	Rem
		bbdoc: Update all the normals for each tile in the given chunk.
		returns: Nothing.
		about: This method does not check if the given index is out of bounds.
	End Rem
	Method UpdateChunkNormalsAtIndex(index:Int)
		Local basenormals:dVec3[10, 10, 4]
		Local chunk:dDrawnTileChunk = m_data_terrain[index]
		Local px:Int = (index Mod (m_height Shr 3)) Shl 3
		Local py:Int = (index / (m_height Shr 3)) Shl 3
		Local wvec:dVec3 = New dVec3
		For Local y:Int = -1 To 8
			For Local x:Int = -1 To 8
				Local px2:Int = px + x
				Local py2:Int = py + y
				Local tile:dDrawnTile
				If y > -1 And y < 8 And x > -1 And x < 8
					tile = chunk.m_objects[y Shl 3 + x]
				Else
					tile = GetTileAtPos(px2, py2)
				End If
				If Not tile Or (tile.m_pos.m_z = tile.m_leftz And tile.m_pos.m_z = tile.m_rightz And tile.m_pos.m_z = tile.m_bottomz)
					basenormals[x + 1, y + 1, 0] = New dVec3.Create(0.0, 0.0, 1.0)
					basenormals[x + 1, y + 1, 1] = New dVec3.Create(0.0, 0.0, 1.0)
					basenormals[x + 1, y + 1, 2] = New dVec3.Create(0.0, 0.0, 1.0)
					basenormals[x + 1, y + 1, 3] = New dVec3.Create(0.0, 0.0, 1.0)
				Else
					Local bvec:dVec3 = New dVec3.Create(-22, 22, (tile.m_pos.m_z - tile.m_rightz Shl 2))
					wvec.Set(-22, -22, (tile.m_leftz - tile.m_pos.m_z Shl 2))
					wvec.CrossProductVec(wvec)
					bvec.Normalize()
					basenormals[x + 1, y + 1, 0] = bvec
					
					bvec = New dVec3.Create(22, 22, (tile.m_rightz - tile.m_bottomz Shl 2))
					wvec.Set(-22, 22, (tile.m_pos.m_z - tile.m_rightz Shl 2))
					bvec.CrossProductVec(wvec)
					bvec.Normalize()
					basenormals[x + 1, y + 1, 1] = bvec
					
					bvec = New dVec3.Create(22, -22, (tile.m_bottomz - tile.m_leftz Shl 2))
					wvec.Set(22, 22, (tile.m_rightz - tile.m_bottomz Shl 2))
					bvec.CrossProductVec(wvec)
					bvec.Normalize()
					basenormals[x + 1, y + 1, 2] = bvec
					
					bvec = New dVec3.Create(-22, -22, (tile.m_leftz - tile.m_pos.m_z Shl 2))
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
		Local basenormals:dVec3[3, 3, 4], tile:dDrawnTile
		Local wvec:dVec3 = New dVec3
		For Local y:Int = -1 To 1
			For Local x:Int = -1 To 1
				Local px2:Int = px + x
				Local py2:Int = py + y
				tile = GetTileAtPos(px2, py2)
				If Not tile Or (tile.m_pos.m_z = tile.m_leftz And tile.m_pos.m_z = tile.m_rightz And tile.m_pos.m_z = tile.m_bottomz)
					basenormals[x + 1, y + 1, 0] = New dVec3.Create(0.0, 0.0, 1.0)
					basenormals[x + 1, y + 1, 1] = New dVec3.Create(0.0, 0.0, 1.0)
					basenormals[x + 1, y + 1, 2] = New dVec3.Create(0.0, 0.0, 1.0)
					basenormals[x + 1, y + 1, 3] = New dVec3.Create(0.0, 0.0, 1.0)
				Else
					Local bvec:dVec3 = New dVec3.Create(-22, 22, (tile.m_pos.m_z - tile.m_rightz Shl 2))
					wvec.Set(-22, -22, (tile.m_leftz - tile.m_pos.m_z Shl 2))
					wvec.CrossProductVec(wvec)
					bvec.Normalize()
					basenormals[x + 1, y + 1, 0] = bvec
					
					bvec = New dVec3.Create(22, 22, (tile.m_rightz - tile.m_bottomz Shl 2))
					wvec.Set(-22, 22, (tile.m_pos.m_z - tile.m_rightz Shl 2))
					bvec.CrossProductVec(wvec)
					bvec.Normalize()
					basenormals[x + 1, y + 1, 1] = bvec
					
					bvec = New dVec3.Create(22, -22, (tile.m_bottomz - tile.m_leftz Shl 2))
					wvec.Set(22, 22, (tile.m_rightz - tile.m_bottomz Shl 2))
					bvec.CrossProductVec(wvec)
					bvec.Normalize()
					basenormals[x + 1, y + 1, 2] = bvec
					
					bvec = New dVec3.Create(-22, -22, (tile.m_leftz - tile.m_pos.m_z Shl 2))
					wvec.Set(22, -22, (tile.m_bottomz - tile.m_leftz Shl 2))
					bvec.CrossProductVec(wvec)
					bvec.Normalize()
					basenormals[x + 1, y + 1, 3] = bvec
				End If
			Next
		Next
		'x = 1
		'y = 1
		tile = GetTileAtPos(px, py)
		tile.UpdateNormals(1, 1, basenormals)
	End Method
	
'#end region Tile updating methods
	
'#region Static updating methods
	
	Rem
		bbdoc: Update the internal positions for all the statics in the map.
		returns: Nothing.
	End Rem
	Method UpdateAllStaticPositions()
		For Local x:Int = 0 Until m_width
			For Local y:Int = 0 Until m_height
				UpdateStaticPositionsAtPos(x, y)
			Next
		Next
	End Method
	
	Rem
		bbdoc: Update all the internal positions for the statics at the given position.
		returns: Nothing.
	End Rem
	Method UpdateStaticPositionsAtPos(x:Int, y:Int)
		Local statics:dDrawnStatic[] = m_data_statics[y, x]
		If statics
			For Local static:dDrawnStatic = EachIn statics
				static.UpdatePosition(x, y)
			Next
		End If
	End Method
	
	Rem
		bbdoc: Update the internal resources for all the statics in the map.
		returns: Nothing.
	End Rem
	Method UpdateAllStaticResources()
		For Local x:Int = 0 Until m_width
			For Local y:Int = 0 Until m_height
				UpdateStaticResourcesAtPos(x, y)
			Next
		Next
	End Method
	
	Rem
		bbdoc: Update all the internal resources for the statics at the given position.
		returns: Nothing.
	End Rem
	Method UpdateStaticResourcesAtPos(x:Int, y:Int)
		Local statics:dDrawnStatic[] = m_data_statics[y, x]
		If statics
			For Local static:dDrawnStatic = EachIn statics
				static.UpdateResource(dMapStaticResource(m_staticres.GetResourceWithID(static.m_resourceid)))
			Next
		End If
	End Method
	
	Rem
		bbdoc: Update the given tile's resource with the map's tile set.
		returns: True if the tile's resource was updated, or False if the tile's resource id was not found.
	End Rem
	Method UpdateStaticResource:Int(static:dDrawnStatic)
		Return m_staticres.UpdateStaticResource(static)
	End Method
	
	Rem
		bbdoc: Sort the statics at the given position.
		returns: True if the statics at the given position were sorted, or False if there is no statics array at the given position.
	End Rem
	Method SortStaticsAtPos:Int(x:Int, y:Int)
		Local statics:dDrawnStatic[] = m_data_statics[y, x]
		If statics
			statics.Sort()
			Return True
		End If
		Return False
	End Method
	
'#end region Static updating methods
	
'#region Render cache
	
	Rem 'TODO
	Method RecalculateDrawCache() '(clearall:Int)
		Local x:Int, y:Int
		Local index:Int
		Local px:Int, py:Int
		Local diff:Byte
		'If clearall
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
	
'#end region Render cache
	
	Rem
		bbdoc: Render the map (offset by a screen position).
		returns: Nothing.
	End Rem
	Method Render()
		Local tile:dDrawnTile, static:dDrawnStatic, statics:dDrawnStatic[]
		Local terrainlayer:Int = m_handler.m_use_terrain_collision And m_handler.m_collision_layer Or 0
		Local staticlayer:Int = m_handler.m_use_static_collision And m_handler.m_collision_layer Or 0
		' Offset orientation
		'Local xoff:Int = m_window_x' Shl 1  + (m_window_width * TILEWIDTH_2)
		Local pposition:dMapPos = m_handler.m_playerpos
		Local pmovement:dVec3 = m_handler.m_playermovement
		Local cr:Int = IntMax(pposition.m_y + 20, m_height - 1)
		Local cc:Int = IntMax(pposition.m_x + 20, m_width - 1)
		' Might want to change these to Floats (and the parameters in the Render method for DrawnObjects to Floats as well)
		Local reldrawx:Int = m_window_x + (m_window_width Shr 1) + (-pposition.m_x + pposition.m_y) * 22 - pmovement.m_x
		Local reldrawy:Int = m_window_y + (-pposition.m_x - pposition.m_y) * 22 + pposition.m_z Shl 3 - pmovement.m_y + Int(pmovement.m_z) Shl 2
		'DebugLog("(dTileMap.Render) reldrawx:" + reldrawx + ", reldrawy:" + reldrawy)
		For Local crow:Int = pposition.m_y Until cr
			For Local ccolumn:Int = pposition.m_x Until cc
				If m_handler.m_render_terrain
					tile = GetTileAtPos(ccolumn, crow)
					m_environment.BindAmbientColor()
					If m_handler.m_coll_terrain = tile Then m_handler.BeforeCollidingTileRendered()
					tile.Render(reldrawx, reldrawy, terrainlayer, m_use_light)
					m_handler.AfterTileRendered(tile)
				End If
				If m_handler.m_render_static
					statics = m_data_statics[crow, ccolumn]
					If statics
						m_environment.BindAmbientColor()
						For static = EachIn statics
							If static = m_handler.m_coll_static Then m_handler.BeforeCollidingStaticRendered()
							'drawx = mxoff - (resimage.width / 2)
							'drawy = myoff - resimage.height + 44.0 + (4.0 * -static.m_z) + 2.0
							static.Render(reldrawx, reldrawy, staticlayer)
							If static = m_handler.m_coll_static Then m_environment.BindAmbientColor()
						Next
					End If
				End If
			Next
		Next
		m_handler.FinishedRendering()
	End Method
	
'#region Data handling
	
	Rem
		bbdoc: Deserialize a tile map from a stream.
		returns: Itself.
		about: Instead of creating a new tile map and then deserializing, you should do `New dTileMap.Deserialize(stream)` - to avoid initiating the data arrays twice.
	End Rem
	Method Deserialize:dTileMap(stream:TStream)
		SetName(dStreamIO.ReadLString(stream))
		SetWidth(stream.ReadInt())
		SetHeight(stream.ReadInt())
		UpdateChunkCount()
		_init()
		m_stream_tilepos = stream.Pos()
		For Local n:Int = 0 Until m_chunks
			m_data_terrain[n].Deserialize(stream, False)
		Next
		For Local y:Int = 0 Until m_height
			For Local x:Int = 0 Until m_width
				Local count:Int = Int(stream.ReadByte())
				If count > 0
					Local statics:dDrawnStatic[] = New dDrawnStatic[count]
					For Local n:Int = 0 Until count
						statics[n] = New dDrawnStatic.Deserialize(stream)
					Next
					m_data_statics[y, x] = statics
				End If
			Next
		Next
		UpdateAllTiles()
		UpdateAllTileNormals()
		UpdateAllStaticPositions()
		' Skipping internal resources update because certain code flow would put the map without resource sets
		Return Self
	End Method
	
	Rem
		bbdoc: Serialize the tile map into a stream.
		returns: Nothing.
		about: If a tile has the resource id -1 it will not be written.
	End Rem
	Method Serialize(stream:TStream)
		dStreamIO.WriteLString(stream, m_name)
		stream.WriteInt(m_width)
		stream.WriteInt(m_height)
		For Local n:Int = 0 Until m_chunks
			m_data_terrain[n].Serialize(stream, False)
		Next
		For Local y:Int = 0 Until m_height
			For Local x:Int = 0 Until m_width
				Local statics:dDrawnStatic[] = m_data_statics[y, x]
				If Not statics
					stream.WriteByte(0)
				Else
					stream.WriteByte(Byte(statics.Length))
					For Local n:Int = 0 Until statics.Length
						statics[n].Serialize(stream)
					Next
				End If
			Next
		Next
	End Method
	
	Rem
		bbdoc: Load a tile map from the given file.
		returns: A tile map, or Null if the given path could not be opened.
	End Rem
	Function LoadFromFile:dTileMap(path:String)
		Local stream:TStream = ReadStream(path)
		If stream
			Local map:dTileMap = New dTileMap.Deserialize(stream)
			stream.Close()
			Return map
		End If
		Return Null
	End Function
	
'#end region Data handling
	
	Function InitGL()
		Local lightpos:Float[4], color:Float[4]
		'glEnable(GL_ALPHA_TEST)
		'glAlphaFunc(GL_GREATER, 0.1)
		glEnable(USING_GL_LIGHT)
		lightpos[0] = -1.0
		lightpos[1] = -1.0
		lightpos[2] = 0.5
		lightpos[3] = 0.0
		glLightfv(USING_GL_LIGHT, GL_POSITION, lightpos)
		color[0] = 1.0
		color[1] = 1.0
		color[2] = 1.0
		color[3] = 1.0
		glLightfv(USING_GL_LIGHT, GL_AMBIENT, color)
		color[0] = 1.0
		color[1] = 1.0
		color[2] = 1.0
		color[3] = 1.0
		glLightfv(USING_GL_LIGHT, GL_SPECULAR, color)
		color[0] = 0.8
		color[1] = 0.8
		color[2] = 0.8
		color[3] = 1.0
		glLightfv(USING_GL_LIGHT, GL_DIFFUSE, color)
		'color[0] = 1.0
		'color[1] = 1.0
		'color[2] = 1.0
		'color[3] = 1.0
		'glLightModelfv(GL_LIGHT_MODEL_AMBIENT, color)
		'glLightModeli(GL_LIGHT_MODEL_TWO_SIDE, False)
	End Function
	
End Type

Rem
	bbdoc: #dTileMap handler (handles player position and all procedures for maps).
	about: This type stores and handles the player position procedures/fields and any other features/options in a tile map.
End Rem
Type dTileMapHandler Abstract
	
	Field m_map:dTileMap
	
	' Player fields
	Field m_playerpos:dMapPos
	Field m_playermovement:dVec3
	
	' Other tile map-related fields
	Field m_render_terrain:Int = True, m_render_static:Int = True
	Field m_use_terrain_collision:Int = True, m_use_static_collision:Int = True
	Field m_collision_layer:Int
	
	Field m_coll_static:dDrawnStatic, m_coll_terrain:dDrawnTile
	
	Rem
		bbdoc: Initiate the handler.
		returns: Nothing.
	End Rem
	Method Init(map:dTileMap, playerpos:dMapPos, playermovement:dVec3, render_terrain:Int = True, render_static:Int = True, use_terrain_collision:Int = True, use_static_collision:Int = True, collision_layer:Int = 0)
		m_map = map
		m_playerpos = playerpos
		m_playermovement = playermovement
		m_render_terrain = render_terrain
		m_render_static = render_static
		m_use_terrain_collision = use_terrain_collision
		m_use_static_collision = use_static_collision
		m_collision_layer = collision_layer
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
	
	Rem
		bbdoc: Turn on (True) or off (False) terrain rendering.
		returns: Nothing.
	End Rem
	Method SetTerrainRendering(render_terrain:Int)
		m_render_terrain = render_terrain
	End Method
	
	Rem
		bbdoc: Get the terrain rendering state.
		returns: True if terrain rendering is on, or False if terrain rendering is off.
	End Rem
	Method GetTerrainRendering:Int()
		Return m_render_terrain
	End Method
	
	Rem
		bbdoc: Turn on (True) or off (False) static rendering.
		returns: Nothing.
	End Rem
	Method SetStaticRendering(render_static:Int)
		m_render_static = render_static
	End Method
	
	Rem
		bbdoc: Get the static rendering state.
		returns: True if static rendering is on, or False if static rendering is off.
	End Rem
	Method GetStaticRendering:Int()
		Return m_render_static
	End Method
	
'#end region Field accessors
	
	Rem
		bbdoc: This method is called before the colliding tile is drawn.
		returns: Nothing.
	End Rem
	Method BeforeCollidingTileRendered()
	End Method
	
	Rem
		bbdoc: This method is called after a tile is rendered.
		returns: Nothing.
		about: @tile is the tile that was rendered.
	End Rem
	Method AfterTileRendered(tile:dDrawnTile)
	End Method
	
	Rem
		bbdoc: This method is called before the colliding static is rendered.
		returns: Nothing.
	End Rem
	Method BeforeCollidingStaticRendered()
	End Method
	
	Rem
		bbdoc: This method is called when all map rendering is complete.
		returns: Nothing.
	End Rem
	Method FinishedRendering()
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

