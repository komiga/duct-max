
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

SuperStrict

Rem
bbdoc: Abstract path keeping/provider module
End Rem
Module duct.pathing

ModuleInfo "Version: 0.15"
ModuleInfo "Copyright: Tim Howard"
ModuleInfo "License: MIT"

ModuleInfo "History: Version 0.15"
ModuleInfo "History: Fixed documentation, license"
ModuleInfo "History: Renamed TPathProvider to dPathProvider"
ModuleInfo "History: Renamed TPath to dPath"
ModuleInfo "History: Updated for API change"
ModuleInfo "History: Version 0.14"
ModuleInfo "History: General cleanup"
ModuleInfo "History: Version 0.13"
ModuleInfo "History: Added note about the new paths via nodes option in dPathProvider.Create"
ModuleInfo "History: Changed: dPathProvider.LoadFromNode returns itself"
ModuleInfo "History: Version 0.12"
ModuleInfo "History: Changed formatting"
ModuleInfo "History: Version 0.11"
ModuleInfo "History: Moved all code to the main source"
ModuleInfo "History: Version 0.1"
ModuleInfo "History: Initial release"

Import brl.stream
Import brl.filesystem
Import duct.scriptparser

Rem
	bbdoc: duct path provider.
End Rem
Type dPathProvider Extends dObjectMap
	
	Field m_option_newnodepaths:Int
	
	Method New()
	End Method
	
	Rem
		bbdoc: Create a path provider.
		returns: Itself.
		about: See #SetNewNodePathsOption for more information on the @option_newnodepaths parameter.
	End Rem
	Method Create:dPathProvider(option_newnodepaths:Int = False)
		SetNewNodePathsOption(option_newnodepaths)
		Return Self
	End Method
	
'#region Field accessors
	
	Rem
		bbdoc: Set the 'new node paths' option.
		returns: Nothing.
		about: If the option is off (False), loading the provider from an SNode will not allow new paths (<b>ALL</b> paths have to be added programmatically).<br/>
		If the option is on (True), loading the provide from an SNode will allow new paths.
	End Rem
	Method SetNewNodePathsOption(option_newnodepaths:Int)
		m_option_newnodepaths = option_newnodepaths
	End Method
	
	Rem
		bbdoc: Get the 'new node paths' option.
		returns: The 'new node paths' option value (False or True).
		about: For information on this option, see #SetNewNodePathsOption.
	End Rem
	Method GetNewNodePathsOption:Int()
		Return m_option_newnodepaths
	End Method
	
'#end region
	
	Rem
		bbdoc: Add a path to the provider.
		returns: Nothing.
	End Rem
	Method AddPath(path:dPath)
		_Insert(path.GetName().ToLower(), path)
	End Method
	
	Rem
		bbdoc: Remove a path by the name given.
		returns: True if a path was removed, or False if no path was removed (the provider contains no path by the name given).
	End Rem
	Method RemovePathByName:Int(name:String)
		Return _Remove(name.ToLower())
	End Method
	
	Rem
		bbdoc: Get a path by the name given.
		returns: A path with the given name, or Null if there is no path associated with the given name.
		about: The @name is not case sensitive.
	End Rem
	Method GetPathByName:dPath(name:String)
		Return dPath(_ValueByKey(name.ToLower()))
	End Method
	
	Rem
		bbdoc: Get a path's location by the given name.
		returns: The location for the given name, or Null if the path for the given name was not found.
		about: The @name is not case sensitive.
	End Rem
	Method GetPathLocationByName:String(name:String)
		Local path:dPath
		path = GetPathByName(name)
		If path <> Null
			Return path.GetLocation()
		End If
		Return Null
	End Method
	
	Rem
		bbdoc: Set a path within the provider to the given @location.
		returns: True if the path was changed, or False if it was not (meaning the @name was not associated with any path).
		about: As seen in the 'Returns' column above, this <b>will</b> allow you to set the path's location to Null.<br/>
		The @name is not case sensitive.
	End Rem
	Method SetPathLocationByName:Int(location:String, name:String)
		Local path:dPath
		path = GetPathByName(name)
		If path <> Null
			path.SetLocation(location)
			Return True
		End If
		Return False
	End Method
	
	Rem
		bbdoc: Create all directories for Paths within the provider.
		returns: Nothing.
	End Rem
	Method CreatePaths()
		Local location:String
		For Local path:dPath = EachIn ValueEnumerator()
			location = ExtractDir(path.GetLocation())
			If FileType(location) = FILETYPE_NONE
				CreateDir(location)
			End If
		Next
	End Method
	
'#region Data handling
	
	Rem
		bbdoc: Serialize the path provider to a stream.
		returns: Nothing.
	End Rem
	Method Serialize(stream:TStream)
		Local path:dPath
		stream.WriteInt(Count())
		For path = EachIn ValueEnumerator()
			path.Serialize(stream)
		Next
	End Method
	
	Rem
		bbdoc: Deserialize a path provider from the given stream.
		returns: The deserialized path provider (itself).
	End Rem
	Method DeSerialize:dPathProvider(stream:TStream)
		Local path:dPath
		Local n:Int, count:Int
		
		count = stream.ReadInt()
		For n = 0 To count - 1
			path = New dPath.DeSerialize(stream)
			' If the path is not already in the provider, we need to add it
			If SetPathLocationByName(path.GetLocation(), path.GetName()) = False
				' Instead of simply adding the path in the first place we need to make sure any 
				' path references kept outside the Provider stay the same (adding the path would replace
				' any existing path with the same name, thus destorying the reference to the path that
				' was just there).
				AddPath(path)
			End If
		Next
		Return Self
	End Method
	
	Rem
		bbdoc: Load the Provider's Paths from a node.
		returns: Nothing.
	End Rem
	Method LoadFromNode:dPathProvider(node:dSNode)
		Local iden:dIdentifier, path:dPath
		
		For iden = EachIn node.GetChildren()
			If dPath.ValidateIdentifier(iden) = True
				path = New dPath.FromIdentifier(iden)
				' If the path is not already in the provider, we need to add it
				If SetPathLocationByName(path.GetLocation(), path.GetName()) = False
					' Instead of simply adding the path in the first place (which would work fine..) we
					' need to make sure any path references kept outside the Provider stay the same (adding the
					' path would replace any existing path with the same name, thus destorying the reference to
					' the path that was just there).
					If m_option_newnodepaths = True
						AddPath(path)
					End If
				End If
			End If
		Next
		Return Self
	End Method
	
	Rem
		bbdoc: Get a node containing all the Paths within the path provider.
		returns: A node containing the provider's Paths.
	End Rem
	Method ToNode:dSNode(nodename:String = "paths")
		Local node:dSNode, path:dPath
		node = New dSNode.Create(nodename)
		For path = EachIn ValueEnumerator()
			node.AddIdentifier(path.ToIdentifier())
		Next
		Return node
	End Method
	
'#end region (Data handling)
	
End Type

Rem
	bbdoc: duct static path.
	about: See #dPathProvider.
End Rem
Type dPath
	
	Rem
		bbdoc: Path template (for dSNodes) (example data: <b>setpath</b> <i>or</i> <b>path</b> "logs" "struct\logs\").
	End Rem
	Global m_template:dTemplate = New dTemplate.Create(["setpath", "path"], [[TV_STRING], [TV_STRING] ])
	
	Field m_name:String, m_location:String
	
	Method New()
	End Method
	
	Rem
		bbdoc: Create a new path.
		returns: The new path (itself).
	End Rem
	Method Create:dPath(name:String, location:String)
		SetName(name)
		SetLocation(location)
		Return Self
	End Method
	
'#region Field accessors
	
	Rem
		bbdoc: Set the path's name.
		returns: Nothing.
	End Rem
	Method SetName(name:String)
		m_name = name
	End Method
	
	Rem
		bbdoc: Get the path's name.
		returns: The name of the path.
	End Rem
	Method GetName:String()
		Return m_name
	End Method
	
	Rem
		bbdoc: Set the path's location.
		returns: Nothing.
	End Rem
	Method SetLocation(location:String)
		m_location = location
	End Method
	
	Rem
		bbdoc: Get the location of the path.
		returns: The location of the path.
	End Rem
	Method GetLocation:String()
		Return m_location
	End Method
	
'#end region (Field accessors)
	
'#region Data handling
	
	Rem
		bbdoc: Serialize the path to a stream.
		returns: Nothing.
	End Rem
	Method Serialize(stream:TStream)
		WriteLString(stream, GetName())
		WriteLString(stream, GetLocation())
	End Method
	
	Rem
		bbdoc: Deserialize a path from the given stream.
		returns: The deserialized path (itself).
	End Rem
	Method DeSerialize:dPath(stream:TStream)
		SetName(ReadLString(stream))
		SetLocation(ReadLString(stream))
		Return Self
	End Method
	
	Rem
		bbdoc: Get an identifier for this path.
		returns: An identifier containing the info of this path.
	End Rem
	Method ToIdentifier:dIdentifier()
		Local iden:dIdentifier
		iden = New dIdentifier.CreateByData(m_template.GetIden()[0])
		iden.AddValue(New dStringVariable.Create(Null, GetName()))
		iden.AddValue(New dStringVariable.Create(Null, GetLocation()))
		Return iden
	End Method
	
	Rem
		bbdoc: Get information for a path from the given identifier.
		returns: The path (itself) from the identifier.
	End Rem
	Method FromIdentifier:dPath(identifier:dIdentifier)
		SetName(dStringVariable(identifier.GetValueAtIndex(0)).Get())
		SetLocation(dStringVariable(identifier.GetValueAtIndex(1)).Get())
		Return Self
	End Method
	
'#end region (Data handling)
	
	Rem
		bbdoc: Validate an identifier against the template for the path.
		returns: True if the given identifier matches the path's template, or False if it does not.
	End Rem
	Function ValidateIdentifier:Int(identifier:dIdentifier)
		Return m_template.ValidateIdentifier(identifier)
	End Function
	
End Type

