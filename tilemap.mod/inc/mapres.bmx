
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

Const RESFLAG_Terrain:Int = 1
Const RESFLAG_Static:Int = 2
Const RESFLAG_Impassable:Int = 4
Const RESFLAG_BlocksView:Int = 8
Const RESFLAG_Wall:Int = 16
Const RESFLAG_Door:Int = 32

Rem
	bbdoc: #dTileMap generic resource.
	about: This is the base type for all tile map resources (dMapTileResource, dMapStaticResource).
End Rem
Type dMapResource
	
	Field m_name:String, m_id:Int, m_flags:Int
	Field m_texture:dProtogTexture
	
	Rem
		bbdoc: Create a resource.
		returns: Itself.
		about: This will set the base resource fields (extending types will use this).
	End Rem
	Method _Create:dMapResource(id:Int, name:String, texture:dProtogTexture, flags:Int = 0)
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
	Method SetTexture(texture:dProtogTexture)
		m_texture = texture
	End Method
	Rem
		bbdoc: Get the resource's texture.
		returns: The texture for this resource.
	End Rem
	Method GetTexture:dProtogTexture()
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
		bbdoc: Deserialize the resource from the given stream.
		returns: Itself.
	End Rem
	Method Deserialize:dMapResource(stream:TStream)
		m_id = stream.ReadInt()
		m_name = ReadNString(stream)
		m_flags = stream.ReadInt()
		m_texture = New dProtogTexture.Deserialize(stream)
		Return Self
	End Method
	
	Rem
		bbdoc: Serialize the resource into the given stream.
		returns: Nothing.
	End Rem
	Method Serialize(stream:TStream)
		stream.WriteInt(m_id)
		WriteNString(stream, m_name)
		stream.WriteInt(m_flags)
		m_texture.Serialize(stream)
	End Method
	
	Rem
		bbdoc: Load a resource from the given stream.
		returns: The loaded resource.
		about: Creates a new resource and deserializes it from the given stream.
	End Rem
	Function Load:dMapResource(stream:TStream)
		Return New dMapResource.Deserialize(stream)
	End Function
	
'#end region (Data handling)
	
	Method Compare:Int(withObject:Object)
		Local best:Int = 0
		Local wobj:dMapResource = dMapResource(withObject)
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
	bbdoc: #dMapResource set.
End Rem
Type dMapResourceSet Extends dObjectMap
	
	Rem
		bbdoc: Create a new set.
		returns: Itself.
	End Rem
	Method Create:dMapResourceSet()
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
	Method InsertResource:Int(resource:dMapResource)
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
	Method GetResourceByID:dMapResource(id:Int)
		Return dMapResource(_ValueByKey(String(id)))
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
		bbdoc: Deserialize the set from the given stream.
		returns: Itself.
	End Rem
	Method Deserialize:dMapResourceSet(stream:TStream)
		While stream.Eof() = False
			Select stream.ReadByte()
				Case 0
					InsertResource(dMapResource.Load(stream))
				Case 1
					InsertResource(dMapTileResource.Load(stream))
				Case 2
					InsertResource(dMapStaticResource.Load(stream))
			End Select
		Wend
		Return Self
	End Method
	
	Rem
		bbdoc: Serialize the set into the given stream.
		returns: Nothing.
	End Rem
	Method Serialize(stream:TStream)
		Local resource:dMapResource
		For resource = EachIn m_map.Values()
			'If resource = Null Then DebugLog("dMapResourceSet.Serialize(); resource is Null")
			If dMapTileResource(resource)
				stream.WriteByte(1)
				dMapTileResource(resource).Serialize(stream)
			Else If dMapStaticResource(resource)
				stream.WriteByte(2)
				dMapStaticResource(resource).Serialize(stream)
			Else
				stream.WriteByte(0)
				resource.Serialize(stream)
			End If
		Next
	End Method
	
	Rem
		bbdoc: Load a tilset from the given stream.
		returns: The loaded tileset.
		about: Creates a new set and deserializes it from the given stream.
	End Rem
	Function Load:dMapResourceSet(stream:TStream)
		Return New dMapResourceSet.Deserialize(stream)
	End Function
	
	Rem
		bbdoc: Load a set from a file.
		returns: The loaded set, or Null if the file could not be opened.
		about: Creates a new set and deserializes it from the given file.
	End Rem
	Function LoadFromFile:dMapResourceSet(url:Object)
		Local resourceset:dMapResourceSet
		Local stream:TStream = ReadFile(url)
		If stream <> Null
			resourceset = Load(stream)
			stream.Close()
		End If
		Return resourceset
	End Function
	
'#end region (Data handling)
		
End Type

Rem
	bbdoc: #dDrawnTile map resource.
End Rem
Type dMapTileResource Extends dMapResource
	
	Rem
		bbdoc: Create a new resource.
		returns: The created resource (itself).
	End Rem
	Method Create:dMapTileResource(id:Int, name:String, texture:dProtogTexture, flags:Int = RESFLAG_Terrain)
		_Create(id, name, texture, flags)
		Return Self
	End Method
	
	Rem
		bbdoc: Deserialize the resource from the given stream.
		returns: Itself.
	End Rem
	Method Deserialize:dMapTileResource(stream:TStream)
		Super.Deserialize(stream)
		Return Self
	End Method
	
	Rem
		bbdoc: Load a resource from the given stream.
		returns: The loaded resource.
		about: Creates a new resource and deserializes it from the given stream.
	End Rem
	Function Load:dMapTileResource(stream:TStream)
		Return New dMapTileResource.Deserialize(stream)
	End Function
	
End Type

Rem
	bbdoc: #dDrawnStatic map resource.
End Rem
Type dMapStaticResource Extends dMapResource
	
	Field m_height:Int
	
	Rem
		bbdoc: Create a static resource.
		returns: The created static resource (itself).
	End Rem
	Method Create:dMapStaticResource(id:Int, height:Int, name:String, texture:dProtogTexture, flags:Int = RESFLAG_Static)
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
		bbdoc: Deserialize the resource from the given stream.
		returns: Itself.
	End Rem
	Method Deserialize:dMapStaticResource(stream:TStream)
		Super.Deserialize(stream)
		m_height = Int(stream.ReadByte())
		Return Self
	End Method
	
	Rem
		bbdoc: Serialize the resource into the given stream.
		returns: Nothing.
	End Rem
	Method Serialize(stream:TStream)
		Super.Serialize(stream)
		stream.WriteByte(Byte(m_height))
	End Method
	
	Rem
		bbdoc: Load a resource from the given stream.
		returns: The loaded resource.
		about: Creates a new resource and deserializes it from the given stream.
	End Rem
	Function Load:dMapStaticResource(stream:TStream)
		Return New dMapStaticResource.Deserialize(stream)
	End Function
	
'#end region (Data handling)
	
End Type

