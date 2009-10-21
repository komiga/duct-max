
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

' 
' tile.bmx (Contains: TDrawnObject, TDrawnTile, TDrawnTileMap, )
' 
' TODO: Implement an xf table (xf is used to properly render tiles), so that higher resolution tiles can be used to fit within the tile size.
' 

Rem
	bbdoc: The drawn object type.
End Rem
Type TDrawnObject Abstract
	
	Field resourceid:Int
	Field z:Int
		
		Rem
			bbdoc: Create a drawnobject.
			returns: The created drawnobject (itself).
			about: Set the base fields for the drawnobject.
		End Rem
		Method _Create:TDrawnObject(_resourceid:Int, _z:Int)
			
			resourceid = _resourceid
			z = _z
			
			Return Self
			
		End Method
		
		Rem
			bbdoc: Set the resource id to be used when rendering.
			returns: Nothing.
		End Rem
		Method SetResourceID(_resourceid:Int)
			
			resourceid = _resourceid
			
		End Method
		
		Rem
			bbdoc: Get the resource id (used when rendering).
			returns: The drawnobject's resource id.
		End Rem
		Method GetResourceID:Int()
			
			Return resourceid
			
		End Method
		
		Rem
			bbdoc: Set the z position of the drawnobject.
			returns: Nothing.
		End Rem
		Method SetZ(_z:Int)
			
			z = _z
			
		End Method
		
		Rem
			bbdoc: Get the z position of the drawnobject.
			returns: The z position of the drawnobject.
		End Rem
		Method GetZ:Int()
			
			Return z
			
		End Method
		
		Rem
			bbdoc: Deserialize the drawnobject from a stream.
			returns: The drawnobject (itself).
		End Rem
		Method DeSerialize:TDrawnObject(stream:TStream)
			
			resourceid = stream.ReadInt()
			z = Int(stream.ReadShort())
			
			Return Self
			
		End Method
		
		Rem
			bbdoc: Serialize the drawnobject to a stream.
			returns: Nothing.
		End Rem
		Method Serialize(stream:TStream)
			
			stream.WriteInt(resourceid)
			stream.WriteShort(Short(z))
			
		End Method
		
End Type

Rem
	bbdoc: The drawntile type (used within a repeated datatype - such as the TDrawnTileMap - used to define the position of a drawn tile).
End Rem
Type TDrawnTile Extends TDrawnObject
	
	Rem
		bbdoc: This is a 'nil' (empty/blank) tile that is used in the initialization of TDrawnTileMaps.
		about: By default, it has the tileid of -1 and the height of 0.
	End Rem
	'Global nilDrawnTile:TDrawnTile = New TDrawnTile.Create(- 1, 0)
	
		Rem
			bbdoc: Create a new drawntile.
			returns: The created drawntile (itself).
		End Rem
		Method Create:TDrawnTile(_tileid:Int, _z:Int)
			
			_Create(_tileid, _z)
			
			Return Self
			
		End Method
		
		Rem
			bbdoc: Deserialize the drawntile from a stream.
			returns: The drawntile (itself).
		End Rem
		Method DeSerialize:TDrawnTile(stream:TStream)
			
			Super.DeSerialize(stream)
			
			Return Self
			
		End Method
		
		
		Rem
			bbdoc: Load a drawntile from a stream.
			returns: The loaded drawntile.
			about: This function will create a new drawntile and deserialize it from the given stream.
		End Rem
		Function Load:TDrawnTile(stream:TStream)
			Local _drawntile:TDrawnTile
			
			_drawntile = New TDrawnTile
			_drawntile.DeSerialize(stream)
			
			Return _drawntile
			
		End Function
		
End Type

Rem
	bbdoc: The drawnstatic type.
	about: This type is a chain, you can add other drawn statics on to it and remove them as you see fit.
End Rem
Type TDrawnStatic Extends TDrawnObject
		
		Rem
			bbdoc: Create a new drawntile.
			returns: The created drawntile (itself).
		End Rem
		Method Create:TDrawnStatic(_tileid:Int, _z:Int)
			
			_Create(_tileid, _z)
			
			Return Self
			
		End Method
		
		Rem
			bbdoc: Deserialize the drawntile from a stream.
			returns: The drawntile (itself).
		End Rem
		Method DeSerialize:TDrawnStatic(stream:TStream)
			
			Super.DeSerialize(stream)
			
			Return Self
			
		End Method
		
		Method Compare:Int(withObject:Object)
			Local best:Int = 0, wobj:TDrawnStatic
			
			wobj = TDrawnStatic(withObject)
			If wobj <> Null
				
				If wobj.z = z
					best = 0
				Else If wobj.z > z
					best = -1
				Else If wobj.z < z
					best = 1
				End If
				
			End If
			
			Return best
			
		End Method
		
		
		Rem
			bbdoc: Load a drawntile from a stream.
			returns: The loaded drawntile.
			about: This function will create a new drawntile and deserialize it from the given stream.
		End Rem
		Function Load:TDrawnStatic(stream:TStream)
			Local _drawntile:TDrawnStatic
			
			_drawntile = New TDrawnStatic
			_drawntile.DeSerialize(stream)
			
			Return _drawntile
			
		End Function
		
End Type


Rem
	bbdoc: The tile map type (this is the graphical map, uses arrays to handle drawntiles).
	about: It is extemely important that you not change any given position in the map to Null (some checks left out for max rendering speed).<br>
	Resource ID -1 should be considered the 'blank'/'empty' resource id.
End Rem
Type TTileMap
	
	' Internal, subject to change
	Global TILEDIMENSIONS:Float = 44.547725696
	Global TILEWIDTH:Float = 44.0, TILEHEIGHT:Float = 44.0
	Global TILEWIDTH_2:Float = 22.273862848, TILEHEIGHT_2:Float = 22.273862848 ' 22.0
	
	Field name:String
	Field width:Int, height:Int
	
	Field handler:TTileMapHandler
	Field tileres:TMapResourceSet, staticres:TMapResourceSet
	
	Field environment:TMapEnvironment
	
	Field data_terrain:TDrawnTile[,], data_statics:TDrawnStatic[][,]
	
	' Draw window fields
	Field dw_x:Int, dw_y:Int, dw_width:Int, dw_height:Int
	
		Method New()
		End Method
		
		Rem
			bbdoc: Initiate the default map array
			returns: Nothing.
			about: This will recreate the tile & static arrays (fills each terrain cell with a new tile - resid of @_resid and z of @_altitude).
		End Rem
		Method _Init(_resid:Int = -1, _altitude:Int = 0)
			Local x:Int, y:Int
			
			data_terrain = New TDrawnTile[height, width]
			data_statics = New TDrawnStatic[][height, width]
			
			For y = 0 To height - 1
				
				For x = 0 To width - 1
					
					'data_statics[y, x] = New TDrawnStatic[1]
					
					' Set all the tiles to empty
					data_terrain[y, x] = New TDrawnTile.Create(_resid, _altitude)
					
				Next
				
			Next
			
		End Method
		
		Rem
			bbdoc: Create a tile map.
			returns: The created map (itself).
			about: NOTE: This method initiates the tile array (@_resid and @_altitude are the parameters passed to the initialize method).
		End Rem
		Method Create:TTileMap(_name:String, _width:Int, _height:Int, _environment:TMapEnvironment, _handler:TTileMapHandler, _resid:Int = -1, _altitude:Int = 0)
			
			SetName(_name)
			
			SetWidth(_width)
			SetHeight(_height)
			
			SetEnvironment(_environment)
			SetHandler(_handler)
			
			_Init(_resid, _altitude)
			
			Return Self
			
		End Method
		
		Rem
			bbdoc: Get the map's environment.
			returns: The map's environment.
		End Rem
		Method GetEnvironment:TMapEnvironment()
			
			Return environment
			
		End Method
		
		Rem
			bbdoc: Set the map's environment.
			returns: Nothing.
		End Rem
		Method SetEnvironment(_environment:TMapEnvironment)
			
			environment = _environment
			
		End Method
		
		Rem
			bbdoc: Set the map's handler.
			returns: Nothing.
		End Rem
		Method SetHandler(_handler:TTileMapHandler)
			
			handler = _handler
			
		End Method
		
		Rem
			bbdoc: Get the map's handler.
			returns: The handler for the map.
		End Rem
		Method GetHandler:TTileMapHandler()
			
			Return handler
			
		End Method
		
		Rem
			bbdoc: Set the tile rendering resource map.
			returns: Nothing.
			about: This will set the resource map used to render tiles.
		End Rem
		Method SetTileResourceMap(_set:TMapResourceSet)
			
			tileres = _set
			
		End Method
		
		Rem
			bbdoc: Get the tile resource map.
			returns: Get the resource map used to render tiles.
		End Rem
		Method GetTileResourceMap:TMapResourceSet()
			
			Return tileres
			
		End Method
		
		Rem
			bbdoc: Set the static rendering resource map.
			returns: Nothing.
			about: This will set the resource map used to render statics.
		End Rem
		Method SetStaticResourceMap(_set:TMapResourceSet)
			
			staticres = _set
			
		End Method
		
		Rem
			bbdoc: Get the static resource map.
			returns: Get the resource map used to render statics.
		End Rem
		Method GetStaticResourceMap:TMapResourceSet()
			
			Return staticres
			
		End Method
		
		Rem
			bbdoc: Set the name of the map.
			returns: Nothing.
		End Rem
		Method SetName(_name:String)
			
			name = _name
			
		End Method
		
		Rem
			bbdoc: Get the name of the map.
			returns: The name of the map.
		End Rem
		Method GetName:String()
			
			Return name
			
		End Method
		
		Rem
			bbdoc: Set the width of the map.
			returns: Nothing.
		End Rem
		Method SetWidth(_width:Int)
			
			width = _width
			
		End Method
		
		Rem
			bbdoc: Get the width of the map.
			returns: The width of the map.
		End Rem
		Method GetWidth:Int()
			
			Return width
			
		End Method
		
		Rem
			bbdoc: Set the height of the map.
			returns: Nothing.
		End Rem
		Method SetHeight(_height:Int)
			
			height = _height
			
		End Method
		
		Rem
			bbdoc: Get the height of the map.
			returns: The height of the map.
		End Rem
		Method GetHeight:Int()
			
			Return height
			
		End Method
		
		Rem
			bbdoc: Add an array of statics to a position in the map.
			returns: True if the array was added to the given position, or False if it was not (position was out of bounds or the given array was Null).
		End Rem
		Method AddStaticArrayToPos:Int(_statics:TDrawnStatic[], _x:Int, _y:Int, _dosort:Int = True)
			Local statics:TDrawnStatic[]
			
			If PosInBounds(_x, _y) = True And _statics <> Null
				
				statics = data_statics[_y, _x]
				
				If statics = Null
					
					statics = _statics
					
				Else
					
					statics = statics + _statics
					
				End If
				
				If _dosort = True Then statics.Sort()
				data_statics[_y, _x] = statics
				
				Return True
				
			End If
			
			Return False
			
		End Method
		
		Rem
			bbdoc: Add a static to a position in the map.
			returns: True if the static was added to the given position, or False if it was not (position was out of bounds or given static was Null).
		End Rem
		Method AddStaticToPos:Int(_static:TDrawnStatic, _x:Int, _y:Int, _dosort:Int = True)
			Local statics:TDrawnStatic[]
			
			If PosInBounds(_x, _y) = True And _static <> Null
				
				statics = data_statics[_y, _x]
				
				If statics = Null
					
					statics = New TDrawnStatic[1]
					
				Else
					
					statics = statics[..statics.Length + 1]
					
				End If
				
				statics[statics.Length - 1] = _static
				If _dosort = True Then statics.Sort()
				
				data_statics[_y, _x] = statics
				
				Return True
				
			End If
			
			Return False
			
		End Method
		
		Rem
			bbdoc: Get the an array of the statics at the given position.
			returns: The array of statics at the given position, or Null if either the position was out of bounds or if there are no statics at the given position.
		End Rem
		Method GetStaticsAtPos:TDrawnStatic[] (_x:Int, _y:Int)
			Local statics:TDrawnStatic[]
			
			If PosInBounds(_x, _y) = True
				
				statics = data_statics[_y, _x]
				
			End If
			
			Return statics
			
		End Method
		
		Rem
			bbdoc: Remove a static from the map by its position and index.
			returns: True if the static at the given position and index was removed, or False if it was not removed.
		End Rem
		Method RemoveStaticAtPosByIndex:Int(_x:Int, _y:Int, _index:Int, _dosort:Int = True)
			Local statics:TDrawnStatic[]
			
			If PosInBounds(_x, _y) = True
				
				statics = data_statics[_y, _x]
				
				If statics <> Null
					
					If _index <= statics.Length - 1 And _index > - 1
						
						If statics.Length = 1
							statics = Null
						Else If _index = 0
							statics = statics[1..]
						Else If _index = statics.Length - 1
							statics = statics[..statics.Length - 1]
						Else
							statics = statics[.._index] + statics[_index + 1..]
						End If
						
						If statics <> Null And _dosort = True Then statics.Sort()
						data_statics[_y, _x] = statics
						
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
		Method RemoveStaticAtPos:Int(_x:Int, _y:Int, _static:TDrawnStatic, _dosort:Int = True)
			Local statics:TDrawnStatic[], i:Int
			
			If PosInBounds(_x, _y) = True
				
				statics = data_statics[_y, _x]
				
				If statics <> Null
					
					For i = 0 To statics.Length - 1
						
						If statics[i] = _static
							
							Return RemoveStaticAtPosByIndex(_x, _y, i, _dosort)
							
						End If
						
					Next
					
				End If
				
			End If
			
			Return False
			
		End Method
		
		Rem
			bbdoc: Set the tile at the given position in the map.
			returns: True if the tile at the given position was set, or False if the tile was Null or the position was out of bounds.
			about: @_x (column) and @_y (row) are zero based.
		End Rem
		Method SetTileAtPos:Int(_dtile:TDrawnTile, _x:Int, _y:Int)
			
			If PosInBounds(_x, _y) = True And _dtile <> Null
				
				data_terrain[_y, _x] = _dtile
				
				Return True
				
			End If
			
			Return False
			
		End Method
		
		Rem
			bbdoc: Get a tile from the map by its position.
			returns: The drawn tile at the position given, or Null if the position is out of bounds.
			about: @_x (column) and @_y (row) are zero based.
		End Rem
		Method GetTileAtPos:TDrawnTile(_x:Int, _y:Int)
			
			If PosInBounds(_x, _y) = True
				
				Return data_terrain[_y, _x]
				
			End If
			
			Return Null
			
		End Method
		
		Rem
			bbdoc: Check if a given tile position is within bounds.
			returns: True if the position is within bounds, or False if it is not.
			about: @_x (column) and @_y (row) are zero based.
		End Rem
		Method PosInBounds:Int(_x:Int, _y:Int)
			
			If _x < width And _x > - 1
				
				If _y < height And _y > - 1
					
					Return True
					
				End If
				
			End If
			
			Return False
			
		End Method
		
		Rem
			bbdoc: Check if a given tile position is within the current drawing window.
			returns: True if the position is within the map's window, or False if it is not.
			about: @_x (column) and @_y (row) are zero based.
		End Rem
		Method PosInWindow:Int(_x:Int, _y:Int)
			
			If _x < dw_x + dw_width And _x >= dw_x
				
				If _y < dw_y + dw_height And _y >= dw_y
					
					Return True
					
				End If
				
			End If
			
			Return False
			
		End Method
		
		Rem
			bbdoc: Get the tile in the center of the current drawing window.
			returns: The tile in the center of the drawing window, or Null if the position is out of bounds (meaning the window is set incorrectly, or there are no tiles in the map).
		End Rem
		Method GetCenteredTile:TDrawnTile()
			Local cr:Int, cc:Int
			
			GetCenteredTilePositon(cc, cr)
			
			Return GetTileAtPos(cc, cr)
			
		End Method
		
		Rem
			bbdoc: Get the position of the tile in the center of the drawing window.
			returns: Nothing. @_x and @_y will contrain the tile's position.
		End Rem
		Method GetCenteredTilePositon(_x:Int Var, _y:Int Var)
			Local cr:Int, cc:Int
			
			cr = IntMin(IntMax(IntMax(dw_y + dw_height - 1, height), height - 1), 0)
			cc = IntMin(IntMax(IntMax(dw_x + dw_width - 1, width), width - 1), 0)
			
			_x = cc - (dw_width / 2)
			_y = cr - (dw_height / 2)
			
		End Method
		
		Rem
			bbdoc: Get the highest number of columns and row that will fit into the rectangle.
			returns: Nothing, see @nrows and @ncolumns - these values will be set.
		End Rem
		Method GetOptimalSize(_x:Float, _y:Float, _width:Float, _height:Float, nrows:Int Var, ncolumns:Int Var, _addlast:Int = True)
			Local nr:Int, nc:Int
			
			While _x + (nr * TILEHEIGHT) < _width - _x
				
				nr:+1
				
			Wend
			
			While _y + (nc * TILEHEIGHT) < _height - _y
				
				nc:+1
				
			Wend
			
			If _addlast = True
				
				nr:+1
				nc:+1
				
			End If
			
			If nr > nc Then nr = nc
			If nc > nr Then nc = nr
			
			nrows = nr
			ncolumns = nc
			
		End Method
		
		Rem
			bbdoc: Set the render window.
			returns: True if the window was set, and False if it failed (usually means you passed False for boundify, and the window went out-of-bounds; or that the resultant window contained no tiles [w=0 / h=0])<br>
			about: This will set the beginning position and ending positions to be drawn (ie, a window/section of tiles).<br>
			If @_boundify is True, the window will be sized to fit within the boundary, False and it may return False if the window goes out-of-bounds.<br>
			@_x and @_y are zero based cell/tile positions, whereas @_width and @_height are number of columns and number of rows, respectively (both one-based).
		End Rem
		Method SetDrawWindow:Int(_x:Int, _y:Int, _width:Int, _height:Int, _boundify:Int = True)
			Local ret:Int
			
			If _boundify = True
				
				_x = IntMax(IntMin(_x, 0), width - 1)
				_y = IntMax(IntMin(_y, 0), height - 1)
				
				_width = IntMax(_x + _width, width)
				_height = IntMax(_y + _height, height)
				
				'If _x + 1 + _width > GetWidth() Then _width = GetWidth() - (_x + 1)
				'If _y + 1 + _height > GetHeight() Then _height = GetHeight() - (_y + 1)
				
				If _height >= 0 Or _width >= 0
					ret = True
				End If
				
			Else
				
				If _x + 1 + _width <= width And _y + 1 + _height <= height
					ret = True
				End If
				
			End If
			
			If ret = True
				dw_x = _x
				dw_y = _y
				dw_width = _width
				dw_height = _height
			End If
			
			Return ret
			
		End Method
		
		Rem
			bbdoc: Set the draw position.
			returns: True if the position was set.
			about: You can set the draw window (x, y, width and height) then use this to retain size, but change position.
		End Rem
		Method SetDrawWindowPosition:Int(_x:Int, _y:Int)
			Local ret:Int
			
			_x = IntMin(_x, 0)
			_y = IntMin(_y, 0)
			
			If _x + dw_width - 1 < width Then dw_x = _x; ret = True
			If _y + dw_height - 1 < height Then dw_y = _y; ret = True
			
			Return ret
			
		End Method
		
		'Const __vtpos:Float = 0.348029107 '0.348029107 x 64.0 = 31.5 (44.0 when rotated)
		Global xf:Float = 22.273862848 'TILEWIDTH_2 ' 64.0 * __vtpos
		' 64.0 x 0.348029107 is actually very very close to TILEWIDTH_2 (which is 22.0), trying this as an expirement..
		'Function PosTransform(ix:Float, iy:Float, jx:Float, jy:Float)
		'	
		'	ix = __vtpos
		'	iy = -__vtpos
		'	
		'	jx = __vtpos
		'	jy = __vtpos
		'	
		'End Function
		
		Rem
			bbdoc: Get the tile matrix (rendering positions) for a position.
			returns: A tile matrix for the given position.
			about: This does not check for Null's or if the position is in-bounds.
		End Rem
		Method GetTileQuadAtPosition:TTileQuad(_xpos:Int, _ypos:Int, x:Float = 0.0, y:Float = 0.0, _cdata:TTileCollisionData = Null)
			Local dtile:TDrawnTile, ntile:TDrawnTile, quad:TTileQuad
			Local z:Float, ny:Float, tx:Float, ty:Float
			
			dtile = data_terrain[_ypos, _xpos]
			
			If _cdata = Null
				quad = New TTileQuad.Create(New TVec3, New TVec3, New TVec3, New TVec3)
			Else
				quad = _cdata.quad
				_cdata.dtile = dtile
				_cdata.xpos = _xpos
				_cdata.ypos = _ypos
			End If
			
			z = -Float(dtile.z)
			
			tx = x' + _xoff
			ty = y' + _yoff
			
			quad.topleft.Set(tx, ty, z)
			
			'ny = 0
			If PosInBounds(_xpos + 1, _ypos) = True
				
				ntile = data_terrain[_ypos, _xpos + 1]
				ny = -Float(ntile.z)
				
			Else
				
				'ny = Z
				ny = 0
				
			End If
			quad.topright.Set(xf + tx, xf + ty, ny)
			
			'ny = 0
			If PosInBounds(_xpos + 1, _ypos + 1) = True
				
				ntile = data_terrain[_ypos + 1, _xpos + 1]
				ny = -Float(ntile.z)
				
			Else
				
				'ny = Z
				ny = 0
				
			End If
			quad.bottomleft.Set(xf + (- xf) + tx, xf + xf + ty, ny)
			
			'ny = 0
			If PosInBounds(_xpos, _ypos + 1) = True
				
				ntile = data_terrain[_ypos + 1, _xpos]
				ny = -Float(ntile.z)
				
			Else
				
				'ny = Z
				ny = 0
				
			End If
			quad.bottomright.Set((- xf) + tx, xf + ty, ny)
			
			Return quad
			
		End Method
		
		Rem
			bbdoc: Draw the map (offset by a screen position).
			returns: Nothing.
		End Rem
		Method Draw(xoff:Float, yoff:Float)
			Local cdata:TTileCollisionData, sdata:TStaticCollisionData
			
			cdata = New TTileCollisionData.Create(Null, New TTileQuad.Create(New TVec3, New TVec3, New TVec3, New TVec3))
			sdata = New TStaticCollisionData.Create(Null, 0, 0)
			
			Local drow:Int, dcolumn:Int, cr:Int, cc:Int
			Local crow:Int, ccolumn:Int
			Local mxoff:Float, myoff:Float
			
			Local static:TDrawnStatic, statics:TDrawnStatic[], staticresource:TMapStaticResource, resimage:TImage
			
			' Offset orientation
			xoff:+(dw_width * TILEWIDTH_2)
			
			cr = IntMax(dw_y + (dw_height) - 1, height - 1)
			cc = IntMax(dw_x + (dw_width) - 1, width - 1)
			
			For crow = dw_y To cr
				
				For ccolumn = dw_x To cc
					Local tileresource:TMapResource
					
					mxoff = ((dcolumn - drow) * TILEWIDTH_2) + xoff
					myoff = ((dcolumn + drow) * TILEWIDTH_2) + yoff
					
					GetTileQuadAtPosition(ccolumn, crow, mxoff, myoff, cdata)
					
					tileresource = tileres.GetResourceByID(cdata.dtile.resourceid)
					
					If tileresource <> Null
						
						Local light:Float, dp:Float
						Local normal:TVec3, normal1:TVec3, normal2:TVec3
						
						normal1 = cdata.quad.topright.Copy()
						normal2 = cdata.quad.bottomright.Copy()
						normal1.SubtractVec(cdata.quad.topleft)
						normal2.SubtractVec(cdata.quad.topleft)
						
						normal = TVec3.CrossProduct(normal1, normal2)
						normal.Normalize()
						dp = normal.DotProduct(environment.light)
						
						If dp < 0 Then dp = 0
						light = dp * 0.4 + 0.6
						SetColor(light * environment.amb_color[0], light * environment.amb_color[1], light * environment.amb_color[2])
						
						If handler.coll_terrain = cdata.dtile Then handler.BeforeCollidingTileDrawn(cdata, light)
						
						tileresource.texture.DrawToTileMatrix(cdata.quad)
						If handler.use_terrain_collision = True
							
							CollideImageQuad(Null, 0,  ..
							cdata.quad.topleft.x, cdata.quad.topleft.y + cdata.quad.topleft.z,  ..
							cdata.quad.topright.x, cdata.quad.topright.y + cdata.quad.topright.z,  ..
							cdata.quad.bottomleft.x, cdata.quad.bottomleft.y + cdata.quad.bottomleft.z,  ..
							cdata.quad.bottomright.x, cdata.quad.bottomright.y + cdata.quad.bottomright.z,  ..
							0, handler.terrain_clayer, cdata.dtile)
							
						End If
						
					End If
					handler.AfterTileDrawn(cdata)
					
					statics = data_statics[crow, ccolumn]
					If statics <> Null
						
						SetColor(environment.amb_color[0], environment.amb_color[1], environment.amb_color[2])
						For static = EachIn statics
							
							staticresource = TMapStaticResource(staticres.GetResourceByID(static.resourceid))
							
							If staticresource <> Null
								
								resimage = staticresource.texture.image
								sdata.static = static
								sdata.xpos = ccolumn
								sdata.ypos = crow
								
								If static = handler.coll_static Then handler.BeforeCollidingStaticDrawn(sdata)
								
								'myoff:-cdata.dtile.z
								DrawImage(resimage, mxoff - (resimage.width / 2), myoff - resimage.height + 44.0 + (4.0 * -static.z) + 2.0, 0)
								If handler.use_static_collision = True
									
									CollideImage(resimage, mxoff - (resimage.width / 2), myoff - resimage.height + 44.0 + (4.0 * -static.z) + 2.0, 0, 0, handler.static_clayer, static)
									
								End If
								
								If static = handler.coll_static Then SetColor(environment.amb_color[0], environment.amb_color[1], environment.amb_color[2])
								
							End If
							
						Next
						
					End If
					
					dcolumn:+1
					
				Next
				
				dcolumn = 0
				drow:+1
				
			Next
			
			handler.FinishedDrawing()
			
		End Method
		
		Rem
			bbdoc: Deserialize a tile map from a stream.
			returns: The deserialized tile map (itself).
			about: Instead of creating a new tile map and then deserializing, you should do New TTileMap.DeSerialize(stream) (or just TTileMap.Load(stream) ) - to avoid initiating the data array twice.
		End Rem
		Method DeSerialize:TTileMap(stream:TStream)
			Local x:Int, y:Int, i:Int, count:Int, statics:TDrawnStatic[]
			
			SetName(ReadNString(stream))
			
			SetWidth(stream.ReadInt())
			SetHeight(stream.ReadInt())
			
			_Init()
			
			For y = 0 To height - 1
				
				For x = 0 To width - 1
					
					'y = Int(stream.ReadShort())
					'x = Int(stream.ReadShort())
					
					If stream.ReadByte() = True
						data_terrain[y, x] = TDrawnTile.Load(stream)
					End If
					
					count = Int(stream.ReadByte())
					If count > 0
						
						statics = New TDrawnStatic[count]
						
						For i = 0 To count - 1
							
							statics[i] = TDrawnStatic.Load(stream)
							
						Next
						
						data_statics[y, x] = statics
						
					End If
					
				Next
				
			Next
			
			Return Self
			
		End Method
		
		Rem
			bbdoc: Serialize a tile map into a stream.
			returns: Nothing.
			about: If a tile has the resource id -1 it will not be saved.
		End Rem
		Method Serialize(stream:TStream)
			Local x:Int, y:Int, i:Int, dtile:TDrawnTile, statics:TDrawnStatic[]
			
			WriteNString(stream, name)
			
			stream.WriteInt(width)
			stream.WriteInt(height)
			
			' Save all tiles
			For y = 0 To height - 1
				
				For x = 0 To width - 1
					
					dtile = data_terrain[y, x]
					statics = data_statics[y, x]
					
					'stream.WriteShort(Short(y))
					'stream.WriteShort(Short(x))
					
					If dtile.resourceid = -1
						
						stream.WriteByte(False)
						
					Else
						
						stream.WriteByte(True)
						dtile.Serialize(stream)
						
					End If
					
					If statics = Null
						
						stream.WriteByte(0)
						
					Else
						
						stream.WriteByte(Byte(statics.Length))
						
						For i = 0 To statics.Length - 1
							
							statics[i].Serialize(stream)
							
						Next
						
					End If
					
				Next
				
			Next
			
		End Method
		
		
		Rem
			bbdoc: Load a tile map from a stream.
			returns: The loaded tile map.
			about: This function will create a new tile map (_Init is not called twice) and deserialize it from the stream.
		End Rem
		Function Load:TTileMap(stream:TStream)
			Local _tilemap:TTileMap
			
			_tilemap = New TTileMap
			_tilemap.DeSerialize(stream)
			
			Return _tilemap
			
		End Function
		
End Type

Rem
	bbdoc: The tile matrix type (drawing positions).
End Rem
Type TTileQuad
	
	Field topleft:TVec3, topright:TVec3, bottomright:TVec3, bottomleft:TVec3
		
		Rem
			bbdoc: Create a tile quad.
			returns: The created tile quad (itself).
		End Rem
		Method Create:TTileQuad(_topleft:TVec3, _topright:TVec3, _bottomright:TVec3, _bottomleft:TVec3)
			
			topleft = _topleft; topright = _topright
			bottomright = _bottomright; bottomleft = _bottomleft
			
			Return Self
			
		End Method
		
		Rem
			bbdoc: Check if a point is within the quad.
			returns: True if the given point is within the tile quad, or False if it is not.
		End Rem
		Method IsVectorInside:Int(vec:TVec2)
			Local c_topleft:TVec2, c_topright:TVec2, c_bottomright:TVec2, c_bottomleft:TVec2
			
			c_topleft = New TVec2.Create(topleft.x, topleft.y + topleft.z)
			c_topright = New TVec2.Create(topright.x, topright.y + topright.z)
			c_bottomright = New TVec2.Create(bottomright.x, bottomright.y + bottomright.z)
			c_bottomleft = New TVec2.Create(bottomleft.x, bottomleft.y + bottomleft.z)
			
			If ((vec.y - c_topleft.y) * (c_topright.x - c_topleft.x)) - ((vec.x - c_topleft.x) * (c_topright.y - c_topleft.y)) <= 0 Then Return False
			If ((vec.y - c_topright.y) * (c_bottomleft.x - c_topright.x)) - ((vec.x - c_topright.x) * (c_bottomleft.y - c_topright.y)) <= 0 Then Return False
			If ((vec.y - c_bottomleft.y) * (c_bottomright.x - c_bottomleft.x)) - ((vec.x - c_bottomleft.x) * (c_bottomright.y - c_bottomleft.y)) <= 0 Then Return False
			If ((vec.y - c_bottomright.y) * (c_topleft.x - c_bottomright.x)) - ((vec.x - c_bottomright.x) * (c_topleft.y - c_bottomright.y)) <= 0 Then Return False
			
			Return True
			
			Rem
			'Credits to BlitzSupport! (http://www.blitzbasic.com/codearcs/codearcs.php?code=626)
			Function GenericPointInQuad:Int(cx:Float, cy:Float, x0:Float, y0:Float, x1:Float, y1:Float, x2:Float, y2:Float, x3:Float, y3:Float)
				If ((cy - y0) * (x1 - x0)) - ((cx - x0) * (y1 - y0)) <= 0 Then Return 0
				If ((cy - y1) * (x2 - x1)) - ((cx - x1) * (y2 - y1)) <= 0 Then Return 0
				If ((cy - y2) * (x3 - x2)) - ((cx - x2) * (y3 - y2)) <= 0 Then Return 0
				If ((cy - y3) * (x0 - x3)) - ((cx - x3) * (y0 - y3)) <= 0 Then Return 0
				
				Return True
				
			End Function
			End Rem
			
		End Method
		
		Rem
			bbdoc: Draw the top outline of the quad.
			returns: Nothing.
		End Rem
		Method DrawTopOutline()
			
			DrawLine(bottomright.x, bottomright.y + bottomright.z, topleft.x, topleft.y + topleft.z)
			DrawLine(topleft.x, topleft.y + topleft.z, topright.x, topright.y + topright.z)
			
		End Method
		
		Rem
			bbdoc: Draw the bottom outline of the quad.
			returns: Nothing.
		End Rem
		Method DrawBottomOutline()
			
			DrawLine(topright.x, topright.y + topright.z, bottomleft.x, bottomleft.y + bottomleft.z)
			DrawLine(bottomleft.x, bottomleft.y + bottomleft.z, bottomright.x, bottomright.y + bottomright.z)
			
		End Method
			
		Rem
			bbdoc: Get the screen (exact rendering position) for the quad.
			returns: Nothing. The respective parameters will be set.
			about: If a given parameter is Null it will be created (if it is not Null then it will be set).
		End Rem
		Method GetScreenVectors(_topleft:TVec2 Var, _topright:TVec2 Var, _bottomright:TVec2 Var, _bottomleft:TVec2 Var)
			
			If _topleft = Null
				_topleft = New TVec2.Create(topleft.x, topleft.y + topleft.z)
			Else
				_topleft.Set(topleft.x, topleft.y + topleft.z)
			End If
			If _topright = Null
				_topright = New TVec2.Create(topright.x, topright.y + topright.z)
			Else
				_topright.Set(topright.x, topright.y + topright.z)
			End If
			If _bottomright = Null
				_bottomright = New TVec2.Create(bottomright.x, bottomright.y + bottomright.z)
			Else
				_bottomright.Set(bottomright.x, bottomright.y + bottomright.z)
			End If
			If _bottomleft = Null
				_bottomleft = New TVec2.Create(bottomleft.x, bottomleft.y + bottomleft.z)
			Else
				_bottomleft.Set(bottomleft.x, bottomleft.y + bottomleft.z)
			End If
			
		End Method
		
		Rem
			bbdoc: Create a copy of the quad.
			returns: A copy of this quad.
		End Rem
		Method Copy:TTileQuad()
			Local clone:TTileQuad
			
			clone = New TTileQuad.Create(topleft.Copy(), topright.Copy(), bottomright.Copy(), bottomleft.Copy())
			
			Return clone
			
		End Method
		
End Type

Rem
	bbdoc: The tile collision data type.
End Rem
Type TTileCollisionData
	
	Field xpos:Int, ypos:Int
	Field dtile:TDrawnTile
	Field quad:TTileQuad
		
		Rem
			bbdoc: Create a tilecollisiondata object.
			returns: Nothing.
			about: 
		End Rem
		Method Create:TTileCollisionData(_dtile:TDrawnTile, _quad:TTileQuad)
			
			dtile = _dtile
			quad = _quad
			
			Return Self
			
		End Method
		
		Rem
			bbdoc: Get the colliding tile.
			returns: Nothing.
		End Rem
		Method GetTile:TDrawnTile()
			
			Return dtile
			
		End Method
		
		Rem
			bbdoc: Create a copy of the collision data.
			returns: A copy of the collision data.
		End Rem
		Method Copy:TTileCollisionData()
			Local clone:TTileCollisionData
			
			clone = New TTileCollisionData.Create(dtile, quad.Copy())
			clone.xpos = xpos
			clone.ypos = ypos
			
			Return clone
			
		End Method
		
End Type

Rem
	bbdoc: The static collision data type.
End Rem
Type TStaticCollisionData
	
	Field xpos:Int, ypos:Int
	Field static:TDrawnStatic
	
		Method Create:TStaticCollisionData(_static:TDrawnStatic, _xpos:Int, _ypos:Int)
			
			static = _static
			
			xpos = _xpos
			ypos = _ypos
			
			Return Self
			
		End Method
		
		Method Copy:TStaticCollisionData()
			Local clone:TStaticCollisionData
			
			clone = New TStaticCollisionData.Create(static, xpos, ypos)
			
			Return clone
			
		End Method
		
End Type

Rem
Function IsPointInsidePoly:Int(collide_point:TPoint, points:TPoint[], xpos:Float, ypos:Float)
	
	Local i:Int, j:Int
	Local bInPoly:Int = False
	Local xt1:Float, xt2:Float, yt1:Float, yt2:Float
	
	j = points.Length - 1
	For i = 0 To j
		
		xt1 = Points[j].x + xpos
		xt2 = Points[i].x + xpos
		yt1 = Points[j].y + ypos
		yt2 = Points[i].y + ypos
		
		
		If collide_point.X < ((xt1 - xt2) * (collide_point.Y - yt2) / (yt1 - yt2) + xt2) And ((yt2 <= collide_point.Y And collide_point.Y < yt1) Or (yt1 <= collide_point.Y And collide_point.Y < yt2)) Then bInPoly = 1 - bInPoly
		
		j = i
		
	Next
	
   Return bInPoly
   
End Function

End Rem


Rem
	bbdoc: The tilemap handler type.
	about: The terrain collision layer defaults to the 17th, and the static collision layer to the 18th.
End Rem
Type TTileMapHandler Abstract
	
	Field use_terrain_collision:Int = True, use_static_collision:Int = True
	
	Field terrain_clayer:Int = COLLISION_LAYER_17, static_clayer:Int = COLLISION_LAYER_18
	Field coll_static:TDrawnStatic, coll_terrain:TDrawnTile
	
		Rem
			bbdoc: This method is called before the colliding tile is drawn.
			returns: Nothing.
			about: cdata is the collision data for the tile about to be drawn.
		End Rem
		Method BeforeCollidingTileDrawn(cdata:TTileCollisionData, light:Float)
		End Method
		
		Rem
			bbdoc: This method is called after a tile is drawn.
			returns: Nothing.
			about: cdata is the collision data for the tile that was drawn.
		End Rem
		Method AfterTileDrawn(cdata:TTileCollisionData)
		End Method
		
		Rem
			bbdoc: This method is called before coll_static is drawn.
			returns: Nothing.
		End Rem
		Method BeforeCollidingStaticDrawn(sdata:TStaticCollisionData)
		End Method
		
		Rem
			bbdoc: This method is called when all map rendering is complete.
			returns: Nothing.
		End Rem
		Method FinishedDrawing()
		End Method
		
End Type






















