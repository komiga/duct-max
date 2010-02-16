
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
	
	mapres.bmx (Contains: TMapResource, TMapResourceSet, TMapTileResource, TMapStaticResource, )
	
End Rem

Const RESFLAG_Terrain:Int = 1
Const RESFLAG_Static:Int = 2
Const RESFLAG_Impassable:Int = 4
Const RESFLAG_BlocksView:Int = 8
Const RESFLAG_Wall:Int = 16
Const RESFLAG_Door:Int = 32

Rem
	bbdoc: The base for all TileMap resources (TMapTileResource, TMapStaticResource).
End Rem
Type TMapResource
	
	Field m_name:String, m_id:Int, m_flags:Int
	Field m_texture:TProtogTexture
	
	Rem
		bbdoc: Create a MapResource.
		returns: The new MapResource (itself).
		about: This will set the base resource fields (extending types will use this).
	End Rem
	Method _Create:TMapResource(id:Int, name:String, texture:TProtogTexture, flags:Int = 0)
		m_id = id
		m_name = name
		m_flags = flags
		m_texture = texture
		Return Self
	End Method
	
'#region Field accessors
	
	Rem
		bbdoc: Set the resource's id.
		returns: Nothing.
	End Rem
	Method SetID(id:Int)
		m_id = id
	End Method
	Rem
		bbdoc: Get the resource's id.
		returns: The id for this resource.
	End Rem
	Method GetID:Int()
		Return m_id
	End Method
	
	Rem
		bbdoc: Set the resource's name.
		returns: Nothing.
	End Rem
	Method SetName(name:String)
		m_name = name
	End Method
	Rem
		bbdoc: Get the resource's name.
		returns: The name for this resource.
	End Rem
	Method GetName:String()
		Return m_name
	End Method
	
	Rem
		bbdoc: Set the resource's texture.
		returns: Nothing.
	End Rem
	Method SetTexture(texture:TProtogTexture)
		m_texture = texture
	End Method
	Rem
		bbdoc: Get the resource's texture.
		returns: The texture for this resource.
	End Rem
	Method GetTexture:TProtogTexture()
		Return m_texture
	End Method
	
	Rem
		bbdoc: Set the resource's flags.
		returns: Nothing.
	End Rem
	Method SetFlags(flags:Int)
		m_flags = flags
	End Method
	Rem
		bbdoc: Get the resource's flags.
		returns: The flags for this resource.
	End Rem
	Method GetFlags:Int()
		Return m_flags
	End Method
	
'#end region (Field accessors)
	
'#region Flags
	
	Rem
		bbdoc: Add a flag to the resource.
		returns: Nothing.
	End Rem
	Method AddFlag(flag:Int)
		If TestFlag(flag) = False
			m_flags:|flag
		End If
	End Method
	
	Rem
		bbdoc: Remove a flag from the resource.
		returns: True if the flag was removed, or False if the flag could not be removed (it was not previously set).
	End Rem
	Method RemoveFlag:Int(flag:Int)
		If TestFlag(flag) = True
			m_flags:&flag
			Return True
		Else
			Return False
		End If
	End Method
	
	Rem
		bbdoc: Test if a flag is set.
		returns: True if the flag is set, or False if it is not.
	End Rem
	Method TestFlag:Int(flag:Int)
		Return m_flags & flag > 0
	End Method
	
'#end region (Flags)
	
'#region Data handling
	
	Rem
		bbdoc: Deserialize the resource from a stream.
		returns: The deserialized resource (itself).
	End Rem
	Method DeSerialize:TMapResource(stream:TStream)
		m_id = stream.ReadInt()
		m_name = ReadNString(stream)
		m_flags = stream.ReadInt()
		m_texture = New TProtogTexture.DeSerialize(stream)
		Return Self
	End Method
	
	Rem
		bbdoc: Serialize the resource into a stream.
		returns: Nothing.
	End Rem
	Method Serialize(stream:TStream)
		stream.WriteInt(m_id)
		WriteNString(stream, m_name)
		stream.WriteInt(m_flags)
		m_texture.Serialize(stream)
	End Method
	
	Rem
		bbdoc: Load a resource from a stream.
		returns: The loaded resource.
		about: Creates a new resource and deserializes it from the given stream.
	End Rem
	Function Load:TMapResource(stream:TStream)
		Return New TMapResource.DeSerialize(stream)
	End Function
	
'#end region (Data handling)
	
	Method Compare:Int(withObject:Object)
		Local best:Int = 0, wobj:TMapResource
		
		wobj = TMapResource(withObject)
		If wobj <> Null
			If wobj.m_id = m_id
				best = 0
			Else If wobj.m_id > m_id
				best = -1
			Else If wobj.m_id < m_id
				best = 1
			End If
		End If
		Return best
	End Method
	
End Type

Rem
	bbdoc: The map resource set type (contains TMapResources).
End Rem
Type TMapResourceSet Extends TObjectMap
	
	Rem
		bbdoc: Create a new MapResourceSet.
		returns: The new MapResourceSet (itself).
	End Rem
	Method Create:TMapResourceSet()
		Return Self
	End Method
	
	Rem
		bbdoc: Check if a resource is in the set by the given id.
		returns: True if the resource id is in the set, or False if it is not.
	End Rem
	Method Contains:Int(id:Int)
		Return _Contains(String(id))
	End Method
	
	Rem
		bbdoc: Insert a resource into the set.
		returns: True for success or False for failure (resource was Null).
	End Rem
	Method InsertResource:Int(resource:TMapResource)
		If resource <> Null
			_Insert(String(resource.GetID()), resource)
			Return True
		End If
		Return False
	End Method
	
	Rem
		bbdoc: Get a resource from the set by its id.
		returns: A resource object, or Null if a resource by the id given was not found in the set.
	End Rem
	Method GetResourceByID:TMapResource(id:Int)
		Return TMapResource(_ValueByKey(String(id)))
	End Method
	
	Rem
		bbdoc: Remove a resource from the set by its id.
		returns: True if it was removed, or False if it was not.
	End Rem
	Method RemoveResourceByID:Int(id:Int)
		Return _Remove(String(id))
	End Method
	
'#region Data handling
	
	Rem
		bbdoc: Deserialize the MapResourceSet from a stream.
		returns: The deserialized MapResourceSet (itself).
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
		bbdoc: Serialize the MapResourceSet into a stream.
		returns: Nothing.
	End Rem
	Method Serialize(stream:TStream)
		Local resource:TMapResource
		For resource = EachIn m_map.Values()
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
		about: Creates a new MapResourceSet and deserializes it from the given stream.
	End Rem
	Function Load:TMapResourceSet(stream:TStream)
		Return New TMapResourceSet.DeSerialize(stream)
	End Function
	
	Rem
		bbdoc: Load a MapResourceSet from a file.
		returns: The loaded MapResourceSet, or Null if the file could not be opened.
		about: Created a new MapResourceSet and deserializes it from the given file.
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
	
'#end region (Data handling)
		
End Type

Rem
	bbdoc: The MapTileResource type (terrains).
End Rem
Type TMapTileResource Extends TMapResource
	
	Rem
		bbdoc: Create a new MapTileResource.
		returns: The created MapTileResource (itself).
	End Rem
	Method Create:TMapTileResource(id:Int, name:String, texture:TProtogTexture, flags:Int = RESFLAG_Terrain)
		_Create(id, name, texture, flags)
		Return Self
	End Method
	
	Rem
		bbdoc: Deserialize the MapTileResource from a stream.
		returns: The deserialized MapTileResource (itself).
	End Rem
	Method DeSerialize:TMapTileResource(stream:TStream)
		Super.DeSerialize(stream)
		Return Self
	End Method
	
	Rem
		bbdoc: Load a MapTileResource from a stream.
		returns: The loaded MapTileResource.
		about: Creates a new MapTileResource and deserializes it from the given stream.
	End Rem
	Function Load:TMapTileResource(stream:TStream)
		Return New TMapTileResource.DeSerialize(stream)
	End Function
	
End Type

Rem
	bbdoc: The MapStaticResource type (walls, game objects, non-morphic tiles, etc).
End Rem
Type TMapStaticResource Extends TMapResource
	
	Field m_height:Int
	
	Rem
		bbdoc: Create a static resource.
		returns: The created static resource (itself).
	End Rem
	Method Create:TMapStaticResource(id:Int, height:Int, name:String, texture:TProtogTexture, flags:Int = RESFLAG_Static)
		_Create(id, name, texture, flags)
		m_height = height
		Return Self
	End Method
	
'#region Field accessors
	
	Rem
		bbdoc: Set the height for the static.
		returns: Nothing.
	End Rem
	Method SetHeight(height:Int)
		m_height = height
	End Method
	Rem
		bbdoc: Get the static's height.
		returns: The height of the static.
	End Rem
	Method GetHeight:Int()
		Return m_height
	End Method
	
'#end region (Field accessors)
	
'#region Data handling
	
	Rem
		bbdoc: Deserialize the MapStaticResource from a stream.
		returns: The deserialized MapStaticResource (itself).
	End Rem
	Method DeSerialize:TMapStaticResource(stream:TStream)
		Super.DeSerialize(stream)
		m_height = Int(stream.ReadByte())
		Return Self
	End Method
	
	Rem
		bbdoc: Serialize the MapStaticResource into a stream.
		returns: Nothing.
	End Rem
	Method Serialize(stream:TStream)
		Super.Serialize(stream)
		stream.WriteByte(Byte(m_height))
	End Method
	
	Rem
		bbdoc: Load a MapStaticResource from a stream.
		returns: The loaded MapStaticResource.
		about: Creates a new MapStaticResource and deserializes it from the given stream.
	End Rem
	Function Load:TMapStaticResource(stream:TStream)
		Return New TMapStaticResource.DeSerialize(stream)
	End Function
	
'#end region (Data handling)
	
End Type

