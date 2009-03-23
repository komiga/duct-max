
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
' mapres.bmx (Contains: TMapResource, TMapResourceSet, TMapTileResource, TMapStaticResource, )
' 
' 

Const RESFLAG_Terrain:Int = 1
Const RESFLAG_Static:Int = 2
Const RESFLAG_Impassable:Int = 4
Const RESFLAG_BlocksView:Int = 8
Const RESFLAG_Wall:Int = 16
Const RESFLAG_Door:Int = 32

Rem
	bbdoc: The map resource type.
End Rem
Type TMapResource
	
	Field name:String, id:Int, flags:Int
	
	Field texture:TTileTexture
	
		Rem
			bbdoc: Create a map resource.
			returns: The created resource (itself).
			about: This will set the base resource fields.
		End Rem
		Method _Create:TMapResource(_id:Int, _name:String, _texture:TTileTexture, _flags:Int = 0)
			
			SetID(_id)
			SetName(_name)
			
			SetFlags(_flags)
			
			SetTexture(_texture)
			
			Return Self
			
		End Method
		
		Rem
			bbdoc: Set the resource's id.
			returns: Nothing.
		End Rem
		Method SetID(_id:Int)
			
			id = _id
			
		End Method
		
		Rem
			bbdoc: Get the resource's id.
			returns: The resource's id.
		End Rem
		Method GetID:Int()
			
			Return id
			
		End Method
		
		Rem
			bbdoc: Set the resource's name.
			returns: Nothing.
		End Rem
		Method SetName(_name:String)
			
			name = _name
			
		End Method
		
		Rem
			bbdoc: Get the resource's name.
			returns: The resource's name.
		End Rem
		Method GetName:String()
			
			Return name
			
		End Method
		
		Rem
			bbdoc: Set the resource's texture.
			returns: Nothing.
		End Rem
		Method SetTexture(_texture:TTileTexture)
			
			texture = _texture
			
		End Method
		
		Rem
			bbdoc: Get the resource's texture.
			returns: The resource's texture.
		End Rem
		Method GetTexture:TTileTexture()
			
			Return texture
			
		End Method
		
		Rem
			bbdoc: Set the resource's flags.
			returns: Nothing.
		End Rem
		Method SetFlags(_flags:Int)
			
			flags = _flags
			
		End Method
		
		Rem
			bbdoc: Get the resource's flags.
			returns: The resource's flags.
		End Rem
		Method GetFlags:Int()
			
			Return flags
			
		End Method
		
		Rem
			bbdoc: Add a flag to the resource.
			returns: Nothing.
		End Rem
		Method AddFlag(_flag:Int)
			
			If TestFlag(_flag) = False
				
				flags:|_flag
				
			End If
			
		End Method
		
		Rem
			bbdoc: Remove a flag from the resource.
			returns: True if the flag was removed or False if the flag could not be removed (it was not set).
		End Rem
		Method RemoveFlag:Int(_flag:Int)
			
			If TestFlag(_flag) = True
				
				flags:&_flag
				
				Return True
				
			Else
				
				Return False
				
			End If
			
		End Method
		
		Rem
			bbdoc: Test if a flag is set.
			returns: True if the flag is set, or False if it is not.
		End Rem
		Method TestFlag:Int(_flag:Int)
			
			Return flags & _flag > 0
			
		End Method
		
		Rem
			bbdoc: Deserialize the resource from a stream.
			returns: The deserialized resource (itself).
		End Rem
		Method DeSerialize:TMapResource(stream:TStream)
			
			id = stream.ReadInt()
			name = ReadNString(stream)
			
			flags = stream.ReadInt()
			
			texture = TTileTexture.Load(stream)
			
			Return Self
			
		End Method
		
		Rem
			bbdoc: Serialize the resource into a stream.
			returns: Nothing.
		End Rem
		Method Serialize(stream:TStream)
			
			stream.WriteInt(id)
			WriteNString(stream, name)
			
			stream.WriteInt(flags)
			
			texture.Serialize(stream)
			
		End Method
		
		Method Compare:Int(withObject:Object)
			Local best:Int = 0, wobj:TMapResource
			
			wobj = TMapResource(withObject)
			If wobj <> Null
				
				If wobj.id = id
					best = 0
				Else If wobj.id > id
					best = -1
				Else If wobj.id < id
					best = 1
				End If
				
			End If
			
			Return best
			
		End Method
		
		Rem
			bbdoc: Load a resource from a stream.
			returns: The loaded resource.
			about: Creates a new resource and deserializes it from the given stream.
		End Rem
		Function Load:TMapResource(stream:TStream)
			Local _resource:TMapResource
			
			_resource = New TMapResource
			_resource.DeSerialize(stream)
			
			Return _resource
			
		End Function
		
End Type

Rem
	bbdoc: The map resource set type (contains TMapResources).
End Rem
Type TMapResourceSet Extends TObjectMap
		
		Rem
			bbdoc: Create a tileset.
			returns: The created resource set (itself).
		End Rem
		Method Create:TMapResourceSet()
			
			Return Self
			
		End Method
		
		Rem
			bbdoc: Insert a resource into the set.
			returns: True for success or False for failure (resource was Null).
		End Rem
		Method InsertResource:Int(_resource:TMapResource)
			
			If _resource <> Null
				
				_Insert(String(_resource.GetID()), _resource)
				Return True
				
			End If
			
			Return False
			
		End Method
		
		Rem
			bbdoc: Check if a resource id is in the set.
			returns: True if the id is in the set, or False if it is not.
		End Rem
		Method Contains:Int(id:Int)
			
			Return _Contains(String(id))
			
		End Method
		
		Rem
			bbdoc: Get a resource from the map by its id.
			returns: A resource object, or Null if a resource by the id given was not found in the map.
		End Rem
		Method GetResourceByID:TMapResource(id:Int)
			
			Return TMapResource(_ValueByKey(String(id)))
			
		End Method
		
		Rem
			bbdoc: Remove a resource from the map by its id.
			returns: True if it was removed, or False if it was not.
		End Rem
		Method RemoveResourceByID:Int(id:Int)
			
			Return _Remove(String(id))
			
		End Method
		
		Rem
			bbdoc: Deserialize the resource set from a stream.
			returns: The deserialized resource set (itself).
		End Rem
		Method DeSerialize:TMapResourceSet(stream:TStream)
			
			While stream.Eof() = False
				
				Select stream.ReadByte()
					Case 0
						InsertResource(TMapResource.Load(stream))
						
					Case 1
						InsertResource(TMapTileResource.Load(stream))
						
					Case 2
						InsertResource(TMapStaticResource.Load(stream))
						
				End Select
				
			Wend
			
			Return Self
			
		End Method
		
		Rem
			bbdoc: Serialize the resource set into a stream.
			returns: Nothing.
		End Rem
		Method Serialize(stream:TStream)
			Local resource:TMapResource
			
			For resource = EachIn _map.Values()
				
				'If resource = Null Then DebugLog("TMapResourceSet.Serialize(); resource is Null")
				If TMapTileResource(resource)
					stream.WriteByte(1)
					TMapTileResource(resource).Serialize(stream)
				Else If TMapStaticResource(resource)
					stream.WriteByte(2)
					TMapStaticResource(resource).Serialize(stream)
				Else
					stream.WriteByte(0)
					resource.Serialize(stream)
				End If
				
			Next
			
		End Method
		
		
		Rem
			bbdoc: Load a tilset from a stream.
			returns: The loaded tileset.
			about: Creates a new resource set and deserializes it from the given stream.
		End Rem
		Function Load:TMapResourceSet(stream:TStream)
			Local _resourceset:TMapResourceSet
			
			_resourceset = New TMapResourceSet
			_resourceset.DeSerialize(stream)
			
			Return _resourceset
			
		End Function
		
		Rem
			bbdoc: Load a resource set from a file.
			returns: The loaded resource set, or Null if the file could not be opened.
			about: Created a new resource set and deserializes it from the given file.
		End Rem
		Function LoadFromFile:TMapResourceSet(url:Object)
			Local stream:TStream, resourceset:TMapResourceSet
			
			stream = ReadFile(url)
			
			If stream <> Null
				
				resourceset = Load(stream)
				stream.Close()
				
			End If
			
			Return resourceset
			
		End Function
		
End Type

Rem
	bbdoc: The map tile resource type (terrain).
End Rem
Type TMapTileResource Extends TMapResource
		
		Rem
			bbdoc: Create a tile resource.
			returns: The created tile resource (itself).
		End Rem
		Method Create:TMapTileResource(_id:Int, _name:String, _texture:TTileTexture, _flags:Int = RESFLAG_Terrain)
			
			_Create(_id, _name, _texture, _flags)
			
			Return Self
			
		End Method
		
		Rem
			bbdoc: Deserialize the tile resource from a stream.
			returns: The deserialized tile resource (itself).
		End Rem
		Method DeSerialize:TMapTileResource(stream:TStream)
			
			Super.DeSerialize(stream)
			
			Return Self
			
		End Method
		
		
		Rem
			bbdoc: Load a tile resource from a stream.
			returns: The loaded tile resource.
			about: Creates a new tile resource and deserializes it from the given stream.
		End Rem
		Function Load:TMapTileResource(stream:TStream)
			Local _tile:TMapTileResource
			
			_tile = New TMapTileResource
			_tile.DeSerialize(stream)
			
			Return _tile
			
		End Function
		
End Type

Rem
	bbdoc: The map static resource type (walls, game objects, non-morphic tiles, etc).
End Rem
Type TMapStaticResource Extends TMapResource
	
	Field height:Int
		
		Rem
			bbdoc: Create a static resource.
			returns: The created static resource (itself).
		End Rem
		Method Create:TMapStaticResource(_id:Int, _height:Int, _name:String, _texture:TTileTexture, _flags:Int = RESFLAG_Static)
			
			_Create(_id, _name, _texture, _flags)
			
			height = _height
			
			Return Self
			
		End Method
		
		Rem
			bbdoc: Set the height for the static.
			returns: Nothing.
		End Rem
		Method SetHeight(_height:Int)
			
			height = _height
			
		End Method
		
		Rem
			bbdoc: Get the static's height.
			returns: The height of the static.
		End Rem
		Method GetHeight:Int()
			
			Return height
			
		End Method
		
		Rem
			bbdoc: Deserialize the static resource from a stream.
			returns: The deserialized static resource (itself).
		End Rem
		Method DeSerialize:TMapStaticResource(stream:TStream)
			
			Super.DeSerialize(stream)
			
			height = Int(stream.ReadByte())
			
			Return Self
			
		End Method
		
		Rem
			bbdoc: Serialize the static resource into a stream.
			returns: Nothing.
		End Rem
		Method Serialize(stream:TStream)
			
			Super.Serialize(stream)
			
			stream.WriteByte(Byte(height))
			
		End Method
		
		
		Rem
			bbdoc: Load a static resource from a stream.
			returns: The loaded static resource.
			about: Creates a new static resource and deserializes it from the given stream.
		End Rem
		Function Load:TMapStaticResource(stream:TStream)
			Local _static:TMapStaticResource
			
			_static = New TMapStaticResource
			_static.DeSerialize(stream)
			
			Return _static
			
		End Function
		
End Type

Rem
	bbdoc: The tile texture type.
End Rem
Type TTileTexture
	
	Field image:TImage
		
		Rem
			bbdoc: Create a tile texture.
			returns: The created texture (itself), may throw an exception (as a string) if it fails to load the image.
			about: @_url can be either a string (the image will be loaded automatically), a TPixmap, or a TImage (for a string and a pixmap, LoadImage will be used).
		End Rem
		Method Create:TTileTexture(_url:Object, _flags:Int = -1)
			Local _image:TImage
			
			_image = TImage(_url)
			If _image = Null Then _image = LoadImage(_url, _flags)
			SetImage(_image)
			
			Return Self
			
		End Method
		
		Rem
			bbdoc: Get texture's width.
			returns: The width of the texture.
		End Rem
		Method GetWidth:Float()
			
			Return Float(image.width)
			
		End Method
		
		Rem
			bbdoc: Get texture's height.
			returns: The height of the texture.
		End Rem
		Method GetHeight:Float()
			
			Return Float(image.height)
			
		End Method
		
		Rem
			bbdoc: Set the texture's image (essentially 'the texture').
			returns: Nothing.
		End Rem
		Method SetImage(_image:TImage)
			
			image = _image
			
		End Method
		
		Rem
			bbdoc: Get the texture's image (essentially 'the texture').
			returns: The texture's image.
		End Rem
		Method GetImage:TImage()
			
			Return image
			
		End Method
		
		Rem
			bbdoc: Draw the texture to a tile matrix.
			returns: Nothing.
		End Rem
		Method DrawToTileMatrix(_quad:TTileQuad)
			Local iframe:TImageFrame, glframe:TGLImageFrame
			
			iframe = image.Frame(0)
			
			?win32
			Local dxframe:TD3D7ImageFrame, gpx:TD3D7Max2DDriver
			
			dxframe = TD3D7ImageFrame(iframe)
			If dxframe <> Null' And gpx <> Null
				
				gpx = TD3D7Max2DDriver(TMax2DGraphics.Current()._driver)
				Local uv:Float Ptr, c:Int Ptr
				uv = dxframe.xyzuv
				c = Int Ptr(uv)
				
				uv[0] = _quad.topleft.x
				uv[1] = _quad.topleft.y + _quad.topleft.z
				c[3] = gpx.drawcolor
				
				uv[6] = _quad.topright.x
				uv[7] = _quad.topright.y + _quad.topright.z
				c[9] = gpx.drawcolor
				
				uv[12] = _quad.bottomleft.x
				uv[13] = _quad.bottomleft.y + _quad.bottomleft.z
				c[15] = gpx.drawcolor
				
				uv[18] = _quad.bottomright.x
				uv[19] = _quad.bottomright.y + _quad.bottomright.z
				c[21] = gpx.drawcolor
				
				gpx.SetActiveFrame(dxframe)
				gpx.device.DrawPrimitive(D3DPT_TRIANGLEFAN, D3DFVF_XYZ | D3DFVF_DIFFUSE | D3DFVF_TEX1, uv, 4, 0)
				
			Else
			?
				
				glframe = TGLImageFrame(iframe)
				
				If glframe <> Null
					Local isTex2DEnabled:Int, lasttex:Int
					glGetBooleanv(GL_TEXTURE_2D, Varptr isTex2DEnabled)
					glGetIntegerv(GL_TEXTURE_BINDING_2D, Varptr lasttex)
					
					glBindTexture(GL_TEXTURE_2D, glframe.name)
					glEnable(GL_TEXTURE_2D)
					'brl.glmax2d.BindTex(glframe.name)
					glBegin(GL_QUADS)
					glTexCoord2f(0.0, 0.0)
					glVertex2f(_quad.topleft.x, _quad.topleft.y + _quad.topleft.z)
					
					glTexCoord2f(1.0, 0.0)
					glVertex2f(_quad.topright.x, _quad.topright.y + _quad.topright.z)
					
					glTexCoord2f(1.0, 1.0)
					glVertex2f(_quad.bottomleft.x, _quad.bottomleft.y + _quad.bottomleft.z)
					
					glTexCoord2f(0.0, 1.0)
					glVertex2f(_quad.bottomright.x, _quad.bottomright.y + _quad.bottomright.z)
					
					glEnd()
					'glDisable(GL_TEXTURE_2D)
					
					If isTex2DEnabled = False Then glDisable(GL_TEXTURE_2D)
					glBindTexture(GL_TEXTURE_2D, lasttex)
					
				End If
				
			?win32
			End If
			?
			
		End Method
		
		Rem
			bbdoc: Deserialize a texture from a stream.
			returns: The deserialized texture (itself).
		End Rem
		Method DeSerialize:TTileTexture(stream:TStream)
			
			SetImage(TImageIO.Read(stream))
			
			Return Self
			
		End Method
		
		Rem
			bbdoc: Serialize the texture into a stream.
			returns: Nothing.
		End Rem
		Method Serialize(stream:TStream)
			
			TImageIO.Write(image, stream)
			
		End Method
		
		
		Rem
			bbdoc: Load a tile texture.
			returns: The loaded (deserialized) tile texture.
			about: Creates a new texture and deserializes it from the stream.
		End Rem
		Function Load:TTileTexture(stream:TStream)
			Local _texture:TTileTexture
			
			_texture = New TTileTexture
			_texture.DeSerialize(stream)
			
			Return _texture
			
		End Function
		
End Type
































