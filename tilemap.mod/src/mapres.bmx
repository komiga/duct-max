
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

Const RESFLAG_Terrain:Int = $1
Const RESFLAG_Static:Int = $2
Const RESFLAG_Impassable:Int = $4
Const RESFLAG_BlocksView:Int = $8
Const RESFLAG_Wall:Int = $10
Const RESFLAG_Door:Int = $20

Rem
	bbdoc: #dTileMap generic resource.
End Rem
Type dMapResource Abstract
	
	Field m_name:String, m_id:Int, m_flags:Int
	Field m_texture:dProtogTexture
	
	Rem
		bbdoc: Initialize the resource.
		returns: Nothing.
		about: This will set the base resource fields (extending types will use this).
	End Rem
	Method _init(id:Int, name:String, texture:dProtogTexture, flags:Int = 0)
		m_id = id
		m_name = name
		m_flags = flags
		m_texture = texture
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
	
'#end region Field accessors
	
'#region Flags
	
	Rem
		bbdoc: Add a flag to the resource.
		returns: Nothing.
	End Rem
	Method AddFlag(flag:Int)
		If Not TestFlag(flag)
			m_flags:| flag
		End If
	End Method
	
	Rem
		bbdoc: Remove a flag from the resource.
		returns: True if the flag was removed, or False if the flag could not be removed (it was not previously set).
	End Rem
	Method RemoveFlag:Int(flag:Int)
		If TestFlag(flag)
			m_flags:~ flag
			Return True
		End If
		Return False
	End Method
	
	Rem
		bbdoc: Test if a flag is set.
		returns: True if the flag is set, or False if it is not.
	End Rem
	Method TestFlag:Int(flag:Int)
		Return m_flags & flag > 0
	End Method
	
'#end region Flags
	
'#region Data handling
	
	Rem
		bbdoc: Deserialize the resource from the given stream.
		returns: Itself.
	End Rem
	Method Deserialize:dMapResource(stream:TStream)
		m_id = stream.ReadInt()
		m_name = dStreamIO.ReadLString(stream)
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
		dStreamIO.WriteLString(stream, m_name)
		stream.WriteInt(m_flags)
		m_texture.Serialize(stream)
	End Method
	
'#end region Data handling
	
	Method Compare:Int(withobject:Object)
		Local best:Int = 0
		Local res:dMapResource = dMapResource(withobject)
		If res
			If res.m_id = m_id
				best = 0
			Else If res.m_id > m_id
				best = -1
			Else If res.m_id < m_id
				best = 1
			End If
		End If
		Return best
	End Method
	
End Type

Rem
	bbdoc: #dMapResource set.
End Rem
Type dMapResourceSet
	
	Field m_map:dIntMap
	
	Method New()
		m_map = New dIntMap
	End Method
	
	Rem
		bbdoc: Create a new set.
		returns: Itself.
	End Rem
	Method Create:dMapResourceSet()
		Return Self
	End Method
	
	Rem
		bbdoc: Check if a resource with the given id is in the set.
		returns: True if the set has a resource with the given id, or False if the set contains no resource with the given id.
	End Rem
	Method Contains:Int(id:Int)
		Return m_map.Contains(id)
	End Method
	
	Rem
		bbdoc: Get the number of resources in the set.
		returns: The number of resources in the set.
	End Rem
	Method Count:Int()
		Return m_map.Count()
	End Method
	
	Rem
		bbdoc: Insert a resource into the set.
		returns: True if the resource was inserted, or False if the given resource was Null.
	End Rem
	Method InsertResource:Int(resource:dMapResource)
		If resource
			m_map.Insert(resource.m_id, resource)
			Return True
		End If
		Return False
	End Method
	
	Rem
		bbdoc: Get a resource with the given id.
		returns: The resource with the given id, or Null if there is no resource with the given id in the set.
	End Rem
	Method GetResourceWithID:dMapResource(id:Int)
		Return dMapResource(m_map.ForKey(id))
	End Method
	
	Rem
		bbdoc: Remove a resource with the given id.
		returns: True if the resource was removed, or False if the set does not have a resource with the given id.
	End Rem
	Method RemoveResourceWithID:Int(id:Int)
		Return m_map.Remove(id)
	End Method
	
'#region Data handling
	
	Rem
		bbdoc: Deserialize the set from the given stream.
		returns: Itself.
	End Rem
	Method Deserialize:dMapResourceSet(stream:TStream)
		While Not stream.Eof()
			Select stream.ReadByte()
				'Case 0
				'	InsertResource(New dMapResource.Deserialize(stream))
				Case 1
					InsertResource(New dMapTileResource.Deserialize(stream))
				Case 2
					InsertResource(New dMapStaticResource.Deserialize(stream))
				Default
					Assert False, "(dMapResourceSet.Deserialize) Unknown resource type"
			End Select
		End While
		Return Self
	End Method
	
	Rem
		bbdoc: Serialize the set into the given stream.
		returns: Nothing.
	End Rem
	Method Serialize(stream:TStream)
		For Local resource:dMapResource = EachIn m_map
			'If Not resource Then DebugLog("dMapResourceSet.Serialize(); resource is Null")
			If dMapTileResource(resource)
				stream.WriteByte(1)
				dMapTileResource(resource).Serialize(stream)
			Else If dMapStaticResource(resource)
				stream.WriteByte(2)
				dMapStaticResource(resource).Serialize(stream)
			Else
				DebugLog("(dMapResourceSet.Serialize) Unknown resource type")
				'stream.WriteByte(0)
				'resource.Serialize(stream)
			End If
		Next
	End Method
	
	Rem
		bbdoc: Load a set from a file.
		returns: A set, or Null if the file could not be opened.
	End Rem
	Function LoadFromFile:dMapResourceSet(path:String)
		Local set:dMapResourceSet
		Local stream:TStream = ReadStream(path)
		If stream
			set = New dMapResourceSet.Deserialize(stream)
			stream.Close()
		End If
		Return set
	End Function
	
'#end region Data handling
	
	Rem
		bbdoc: Update the given tile's resource.
		returns: True if the tile's resource was updated, or False if the tile's resource id was not found.
	End Rem
	Method UpdateTileResource:Int(tile:dDrawnTile)
		Local resource:dMapTileResource = dMapTileResource(GetResourceWithID(tile.m_resourceid))
		If resource
			tile.UpdateResource(resource)
			Return True
		End If
		Return False
	End Method
	
	Rem
		bbdoc: Update the given static's resource.
		returns: True if the static's resource was updated, or False if the static's resource id was not found.
	End Rem
	Method UpdateStaticResource:Int(static:dDrawnStatic)
		Local resource:dMapStaticResource = dMapStaticResource(GetResourceWithID(static.m_resourceid))
		If resource
			static.UpdateResource(resource)
			Return True
		End If
		Return False
	End Method
	
	Rem
		bbdoc: Get the enumerator for the set.
		returns: The set's enumerator.
	End Rem
	Method ObjectEnumerator:dIntMapStandardEnum()
		Return m_map.ObjectEnumerator()
	End Method
	
	Rem
		bbdoc: Get the reversed enumerator for the set.
		returns: The set's reversed enumerator.
	End Rem
	Method ReverseEnumerator:dIntMapReverseEnum()
		Return m_map.ReverseEnumerator()
	End Method
	
End Type

Rem
	bbdoc: #dDrawnTile map resource.
End Rem
Type dMapTileResource Extends dMapResource
	
	Rem
		bbdoc: Create a new resource.
		returns: Itself.
	End Rem
	Method Create:dMapTileResource(id:Int, name:String, texture:dProtogTexture, flags:Int = RESFLAG_Terrain)
		_init(id, name, texture, flags)
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
	
End Type

Rem
	bbdoc: #dDrawnStatic map resource.
End Rem
Type dMapStaticResource Extends dMapResource
	
	Field m_height:Int
	
	Rem
		bbdoc: Create a static resource.
		returns: Itself.
	End Rem
	Method Create:dMapStaticResource(id:Int, height:Int, name:String, texture:dProtogTexture, flags:Int = RESFLAG_Static)
		_init(id, name, texture, flags)
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
	
'#end region Field accessors
	
'#region Data handling
	
	Rem
		bbdoc: Deserialize the resource from the given stream.
		returns: Itself.
	End Rem
	Method Deserialize:dMapStaticResource(stream:TStream)
		Super.Deserialize(stream)
		m_height = stream.ReadByte()
		Return Self
	End Method
	
	Rem
		bbdoc: Serialize the resource into the given stream.
		returns: Nothing.
	End Rem
	Method Serialize(stream:TStream)
		Super.Serialize(stream)
		stream.WriteByte(m_height)
	End Method
	
'#end region Data handling
	
End Type

