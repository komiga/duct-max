
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
	
	pathing.bmx (Contains: TPathProvider, TPath, )
	
End Rem

SuperStrict

Rem
bbdoc: Abstract path keeping/provider module
End Rem
Module duct.pathing

ModuleInfo "Version: 0.11"
ModuleInfo "Copyright: Tim Howard"
ModuleInfo "License: MIT"

ModuleInfo "History: Version 0.11"
ModuleInfo "History: Moved all code to the main source"
ModuleInfo "History: Version 0.1"
ModuleInfo "History: Initial release"

' Used modules
Import brl.stream
Import brl.filesystem

Import duct.scriptparser
Import duct.template


Rem
	bbdoc: The PathProvider type.
	about: This type holds Paths, and offers name-based retrieval.
End Rem
Type TPathProvider Extends TObjectMap
	
	Field m_option_newnodepaths:Int
	
		Method New()
		End Method
		
		Rem
			bbdoc: Create a PathProvider.
			returns: The new PathProvider (itself).
		End Rem
		Method Create:TPathProvider(option_newnodepaths:Int = False)
			
			SetNewNodePathsOption(option_newnodepaths)
			
			Return Self
			
		End Method
		
		'#region Field accessors
		
		Rem
			bbdoc: Set the NewNodePaths option.
			returns: Nothing.
			about: If the option is off (False), loading the provider from an SNode will not allow new paths (<b>ALL</b> paths have to be added programmatically).<br />
			If the option is on (True), loading the provide from an SNode will allow new paths.
		End Rem
		Method SetNewNodePathsOption(option_newnodepaths:Int)
			
			m_option_newnodepaths = option_newnodepaths
			
		End Method
		
		Rem
			bbdoc: Get the NewNodePaths option.
			returns: The NewNodePaths option value (False or True).
			about: For information on this option, see #SetNewNodePathsOption.
		End Rem
		Method GetNewNodePathsOption:Int()
			
			Return m_option_newnodepaths
			
		End Method
		
		'#end region
		
		Rem
			bbdoc: Add a Path to the provider.
			returns: Nothing.
		End Rem
		Method AddPath(path:TPath)
			
			_Insert(path.GetName().ToLower(), path)
			
		End Method
		
		Rem
			bbdoc: Remove a Path by the name given.
			returns: True if a Path was removed, or False if no Path was removed (the provider contains no path by the name given).
		End Rem
		Method RemovePathByName:Int(name:String)
			
			Return _Remove(name.ToLower())
			
		End Method
		
		Rem
			bbdoc: Get a Path by the name given.
			returns: A Path with the given name, or Null if there is no Path associated with the given name.
			about: The @name is not case sensitive.
		End Rem
		Method GetPathByName:TPath(name:String)
			
			Return TPath(_ValueByKey(name.ToLower()))
			
		End Method
		
		Rem
			bbdoc: Get a Path's location by the given name.
			returns: The location for the given name, or Null if the Path for the given name was not found.
			about: The @name is not case sensitive.
		End Rem
		Method GetPathLocationByName:String(name:String)
			Local path:TPath
			
			path = GetPathByName(name)
			
			If path <> Null
				
				Return path.GetLocation()
				
			End If
			
			Return Null
			
		End Method
		
		Rem
			bbdoc: Set a Path within the provider to the given @location.
			returns: True if the Path was changed, or False if it was not (meaning the @name was not associated with any Path).
			about: As seen in the 'Returns' column above, this <b>will</b> allow you to set the Path's location to Null.<br />
			The @name is not case sensitive.
		End Rem
		Method SetPathLocationByName:Int(location:String, name:String)
			Local path:TPath
			
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
			Local path:TPath, location:String
			
			For path = EachIn ValueEnumerator()
				
				location = ExtractDir(path.GetLocation())
				If FileType(location) = FILETYPE_NONE
					
					CreateDir(location)
					
				End If
				
			Next
			
		End Method
		
		'#region Data handlers
		
		Rem
			bbdoc: Serialize the PathProvider to a stream.
			returns: Nothing.
		End Rem
		Method Serialize(stream:TStream)
			Local path:TPath
			
			stream.WriteInt(Count())
			
			For path = EachIn ValueEnumerator()
				
				path.Serialize(stream)
				
			Next
			
		End Method
		
		Rem
			bbdoc: Deserialize a PathProvider from the given stream.
			returns: The deserialized PathProvider (itself).
		End Rem
		Method DeSerialize:TPathProvider(stream:TStream)
			Local path:TPath
			Local n:Int, count:Int
			
			count = stream.ReadInt()
			
			For n = 0 To count - 1
				
				path = New TPath.DeSerialize(stream)
				
				' If the path is not already in the provider, we need to add it
				If SetPathLocationByName(path.GetLocation(), path.GetName()) = False
					
					' Instead of simply adding the path in the first place we need to make sure any 
					' Path references kept outside the Provider stay the same (adding the path would replace
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
		Method LoadFromNode(node:TSNode)
			Local iden:TIdentifier, path:TPath
			
			For iden = EachIn node.GetChildren()
				
				If TPath.ValidateIdentifier(iden) = True
					
					path = New TPath.FromIdentifier(iden)
					
					' If the path is not already in the provider, we need to add it
					If SetPathLocationByName(path.GetLocation(), path.GetName()) = False
						
						' Instead of simply adding the path in the first place (which would work fine..) we
						' need to make sure any Path references kept outside the Provider stay the same (adding the
						' path would replace any existing path with the same name, thus destorying the reference to
						' the path that was just there).
						If m_option_newnodepaths = True
							AddPath(path)
						End If
						
					End If
					
				End If
				
			Next
			
		End Method
		
		Rem
			bbdoc: Get a node containing all the Paths within the PathProvider.
			returns: A node containing the provider's Paths.
		End Rem
		Method ToNode:TSNode(nodename:String = "paths")
			Local node:TSNode, path:TPath
			
			node = New TSNode.Create(nodename)
			
			For path = EachIn ValueEnumerator()
				
				node.AddIdentifier(path.ToIdentifier())
				
			Next
			
			Return node
			
		End Method
		
		'#end region
		
End Type

Rem
	bbdoc: The Path type.
	about: This type holds static paths (handled mostly by PathProvider).
End Rem
Type TPath
	
	Rem
		bbdoc: Path template (for SNodes) (example data: <b>setpath</b> <i>or</i> <b>path</b> "logs" "struct\logs\").
	End Rem
	Global template:TTemplate = New TTemplate.Create(["setpath", "path"], [[TV_STRING], [TV_STRING] ])
	
	Field m_name:String, m_location:String
	
		Method New()
		End Method
		
		Rem
			bbdoc: Create a new Path.
			returns: The new Path (itself).
		End Rem
		Method Create:TPath(name:String, location:String)
			
			SetName(name)
			SetLocation(location)
			
			Return Self
			
		End Method
		
		'#region Field accessors
		
		Rem
			bbdoc: Set the name of the Path.
			returns: Nothing.
		End Rem
		Method SetName(name:String)
			
			m_name = name
			
		End Method
		
		Rem
			bbdoc: Get the name of the Path.
			returns: The name of the Path.
		End Rem
		Method GetName:String()
			
			Return m_name
			
		End Method
		
		Rem
			bbdoc: Set the location of the Path.
			returns: Nothing.
		End Rem
		Method SetLocation(location:String)
			
			m_location = location
			
		End Method
		
		Rem
			bbdoc: Get the location of the Path.
			returns: The location of the Path.
		End Rem
		Method GetLocation:String()
			
			Return m_location
			
		End Method
		
		'#end region
		
		'#region Data handlers
		
		Rem
			bbdoc: Serialize the Path to a stream.
			returns: Nothing.
		End Rem
		Method Serialize(stream:TStream)
			
			WriteLString(stream, GetName())
			WriteLString(stream, GetLocation())
			
		End Method
		
		Rem
			bbdoc: Deserialize a Path from the given stream.
			returns: The deserialized Path (itself).
		End Rem
		Method DeSerialize:TPath(stream:TStream)
			
			SetName(ReadLString(stream))
			SetLocation(ReadLString(stream))
			
			Return Self
			
		End Method
		
		Rem
			bbdoc: Get an identifier for this Path.
			returns: An identifier containing the info of this Path.
		End Rem
		Method ToIdentifier:TIdentifier()
			Local iden:TIdentifier
			
			iden = New TIdentifier.CreateByData(template.GetIden()[0])
			
			iden.AddValue(New TStringVariable.Create(Null, GetName()))
			iden.AddValue(New TStringVariable.Create(Null, GetLocation()))
			
			Return iden
			
		End Method
		
		Rem
			bbdoc: Get information for a Path from the given identifier.
			returns: The Path (itself) from the identifier.
		End Rem
		Method FromIdentifier:TPath(identifier:TIdentifier)
			
			SetName(TStringVariable(identifier.GetValueAtIndex(0)).Get())
			SetLocation(TStringVariable(identifier.GetValueAtIndex(1)).Get())
			
			Return Self
			
		End Method
		
		'#end region
		
		Rem
			bbdoc: Validate an identifier against the template for the Path.
			returns: True if the given identifier matches the Path's template, or False if it does not.
		End Rem
		Function ValidateIdentifier:Int(identifier:TIdentifier)
			
			Return template.ValidateIdentifier(identifier)
			
		End Function
		
End Type













































