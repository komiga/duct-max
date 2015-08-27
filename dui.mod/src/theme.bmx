
Rem
Copyright (c) 2010 plash <plash@komiga.com>

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

Rem
	bbdoc: duct ui theme manager.
End Rem
Type duiThemeManager
	
	Global m_themes:dObjectMap = New dObjectMap
	
'#region Collections
	
	Rem
		bbdoc: Add a theme to the manager.
		returns: True if the theme was added to the manager, or False if it was not (either the theme was Null, or it was already added to the manager).
	End Rem
	Function AddTheme:Int(theme:duiTheme)
		If theme And Not ContainsTheme(theme)
			m_themes._Insert(theme.GetName(), theme)
			Return True
		End If
		Return False
	End Function
	
	Rem
		bbdoc: Get a theme with the given name.
		returns: The theme with the given name, or Null if the given name could not be found.
		about: The @name parameter is %not the formal name.
	End Rem
	Function GetThemeWithName:duiTheme(name:String)
		Return duiTheme(m_themes._ObjectWithKey(name))
	End Function
	
	Rem
		bbdoc: Load a theme from the given file path and add it to the manager.
		returns: The theme that was added, or Null if the stream could not be opened.
		about: If the given url is a binary theme (rather than a script), pass @binary as True (defaults to False - script).
	End Rem
	Function AddThemeFromFile:duiTheme(path:String, loadtexture:Int = True, binary:Int = False, encoding:Int = ENC_UTF8)
		Local theme:duiTheme
		Local stream:TStream = ReadStream(path)
		If stream
			theme = AddThemeFromStream(stream, loadtexture, binary, encoding)
			stream.Close()
		End If
		Return theme
	End Function
	
	Rem
		bbdoc: Load a theme from the given stream and add it to the manager.
		returns: The theme that was added, or Null if the theme could not be loaded (stream was Null).
		about: If the given url is a binary theme (rather than a script), pass @binary as True (defaults to False - script).
	End Rem
	Function AddThemeFromStream:duiTheme(stream:TStream, loadtexture:Int = True, binary:Int = False, encoding:Int = ENC_UTF8)
		Local theme:duiTheme
		If stream
			If binary
				theme = New duiTheme.Deserialize(stream)
			Else
				Local node:dNode = dScriptFormatter.LoadFromStream(stream, encoding)
				If node
					theme = New duiTheme.FromNode(node)
				End If
			End If
			If theme
				AddTheme(theme)
				If loadtexture = True
					theme.LoadTexture()
				End If
			End If
		End If
		Return theme
	End Function
	
	Rem
		bbdoc: Check if the given theme is in the manager.
		returns: True if the given theme is in the manager, or False if it is not.
	End Rem
	Function ContainsTheme:Int(theme:duiTheme)
		If Not theme.GetName()
			Return False
		End If
		Return m_themes._Contains(theme.GetName())
	End Function
	
	Rem
		bbdoc: Check if there is a theme with the name given in the manager.
		returns: True if the given name was found, or Null if the given name could not be found.
		about: The @name parameter is %not the formal name of the theme.
	End Rem
	Function ContainsThemeWithName:Int(name:String)
		Return m_themes._Contains(name)
	End Function
	
'#end region Collections
	
End Type

Rem
	bbdoc: ductui theme stub.
End Rem
Type duiThemeStub Extends dObjectMap
	
	Global m_template_name:dTemplate = New dTemplate.Create(["name"], [[TV_STRING]])
	
	Field m_name:String
	Field m_parent:duiThemeStub
	
	Rem
		bbdoc: Initialize the duiThemeStub.
		returns: Nothing.
	End Rem
	Method _Init(name:String)
		SetName(name)
	End Method
	
'#region Field accessors
	
	Rem
		bbdoc: Set the duiThemeStub's name.
		returns: Nothing.
	End Rem
	Method SetName(name:String)
		m_name = name
	End Method
	Rem
		bbdoc: Get the duiThemeStub's name
		returns: The duiThemeStub's name.
	End Rem
	Method GetName:String()
		Return m_name
	End Method
	
	Rem
		bbdoc: Set the stub's parent.
		returns: Nothing.
	End Rem
	Method SetParent(parent:duiThemeStub)
		m_parent = parent
	End Method
	Rem
		bbdoc: Get the stub's parent.
		returns: The stub's parent.
	End Rem
	Method GetParent:duiThemeStub()
		Return m_parent
	End Method
	
'#end region Field accessors
	
'#region Collections
	
	Rem
		bbdoc: Get the top-most parent of the stub.
		returns: The top-most parent of the stub, or itself if the stub has no parent.
	End Rem
	Method GetTopParent:duiThemeStub()
		If m_parent
			Local topparent:duiThemeStub
			topparent = m_parent.GetTopParent()
			If topparent
				Return topparent
			Else
				Return m_parent
			End If
		End If
		Return Self
	End Method
	
	Rem
		bbdoc: Get the stub's structure.
		returns: The stub's structure.
	End Rem
	Method GetStructure:String(withfirst:Int = False)
		If m_parent
			Local parentstructure:String = m_parent.GetStructure()
			If parentstructure
				Return parentstructure + "." + m_name
			Else
				Return m_name
			End If
		Else
			If withfirst = True
				Return m_name
			Else
				Return Null
			End If
		End If
	End Method
	
	Rem
		bbdoc: Add a stub to the stub.
		returns: Nothing.
		about: This will set the given stub's parent to this stub.
	End Rem
	Method _AddStub(stub:duiThemeStub)
		If stub
			If stub.GetName()
				stub.SetParent(Self)
				_Insert(stub.GetName(), stub)
			Else
				Assert "(duiThemeStub._AddStub) Stub name is Null!"
			End If
		End If
	End Method
	
	Rem
		bbdoc: Get a stub with the given name.
		returns: The stub with the given name, or Null if the given name could not be found.
	End Rem
	Method _GetStubWithName:duiThemeStub(name:String)
		Return duiThemeStub(_ObjectWithKey(name))
	End Method
	
	Rem
		bbdoc: Get a stub from the given structure.
		returns: The #duiThemeStub from the given structure, or Null if no stub was found at the end of the structure.
	End Rem
	Method _GetStubFromStructure:duiThemeStub(structure:String)
		Local separator:String = "."
		Local sloc:Int = structure.Find(separator)
		If sloc = -1
			Return _GetStubWithName(structure)
		Else
			Local stub:duiThemeStub = _GetStubWithName(structure[..sloc])
			If stub
				Return stub._GetStubFromStructure(structure[sloc + separator.Length..])
			End If
		End If
		
		Return Null
	End Method
	
'#end region Collections
	
'#region Data handlers
	
	Rem
		bbdoc: Serialize the duiThemeStub to the given stream.
		returns: Nothing.
	End Rem
	Method Serialize(stream:TStream) Abstract
	
	Rem
		bbdoc: Deserialize a duiThemeStub from the given stream.
		returns: The deserialized duiThemeStub (itself).
	End Rem
	Method Deserialize:duiThemeStub(stream:TStream) Abstract
	
	Rem
		bbdoc: Create a copy of the stub.
		returns: A complete copy of the stub.
	End Rem
	Method Copy:duiThemeStub() Abstract
	
'#end region Data handlers
	
	Rem
		bbdoc: Get a string containing a hierarchical report of all the stub's data and all its children.
		returns: A string containing the name/structure of the stub and its short data.
	End Rem
	Method Report:String(tab:String = Null)
		Local str:String
		If tab = Null
			str = "~q" + m_name + "~q~n"
		Else
			str = "~q." + m_name + "~q~n"
		End If
		For Local stub:duiThemeStub = EachIn ValueEnumerator()
			str:+tab + stub.Report(tab + "~t") + "~n"
		Next
		Return str[0..str.Length - 1]
	End Method
	
End Type

Rem
	bbdoc: ductui theme.
End Rem
Type duiTheme Extends duiThemeStub
	
	Global m_template_formalname:dTemplate = New dTemplate.Create(["formalname"], [[TV_STRING] ])
	Global m_template_textureurl:dTemplate = New dTemplate.Create(["texture"], [[TV_STRING] ])
	
	Global m_texflags:Int = TEXTURE_FILTER ' | TEXTURE_MIPMAP ' | TEXTURE_RECTANGULAR
	Global m_renderquad:dVec4 = New dVec4
	
	Field m_formalname:String
	Field m_texture:dProtogTexture, m_textureurl:String
	Field m_xdelta:Float, m_ydelta:Float, m_texture_width:Float, m_texture_height:Float
	
	Rem
		bbdoc: Create a new theme.
		returns: Itself, or Null if the given texture could not be loaded (see #LoadTexture).
		about: If @loadtex is True the theme texture will be loaded.
	End Rem
	Method Create:duiTheme(name:String, formalname:String, textureurl:String, loadtex:Int = True)
		_Init(name)
		SetFormalName(formalname)
		SetTextureURL(textureurl)
		If loadtex
			If Not LoadTexture()
				Return Null
			End If
		End If
		Return Self
	End Method
	
'#region Update & miscellaneous
	
	Rem
		bbdoc: Update all of sets in the theme.
		returns: Nothing.
	End Rem
	Method UpdateSets()
		For Local set:duiThemeSectionSet = EachIn ValueEnumerator()
			set.Update(Self)
		Next
	End Method
	
	Rem
		bbdoc: Load the theme's texture (from the texture url).
		returns: True if the texture was loaded, or False if it was not (pixmap was Null).
	End Rem
	Method LoadTexture:Int()
		Local pixmap:TPixmap = LoadPixmap(m_textureurl)
		If pixmap
			m_texture = New dProtogTexture.Create(pixmap, m_texflags)
			m_texture_width = m_texture.m_width
			m_texture_height = m_texture.m_height
			If m_texflags & TEXTURE_RECTANGULAR
				m_xdelta = 1
				m_ydelta = 1
			Else
				m_xdelta = m_texture_width / Pow2Size(m_texture_width)
				m_ydelta = m_texture_height / Pow2Size(m_texture_height)
			End If
			UpdateSets()
			Return True
		End If
		Return False
	End Method
	
	Rem
		bbdoc: Calculate the texture coordinates for the given area.
		returns: Nothing. The uv vector which is changed is @vector.
	End Rem
	Method CalculateUV(vector:dVec4, x:Float, y:Float, width:Float, height:Float)
		x:* m_xdelta
		y:* m_ydelta
		' Texture coordinate layout:
		' x---y     u0--v0
		' |   |  =  |    |
		' |   |     |    |
		' z---w     u1--v1
		vector.m_x = Float(x) / Float(m_texture_width)
		vector.m_y = Float(y) / Float(m_texture_height)
		vector.m_z = Float(x + width * m_xdelta) / Float(m_texture_width)
		vector.m_w = Float(y + height * m_ydelta) / Float(m_texture_height)
	End Method
	
	Rem
		bbdoc: Render the vector with the texture coordinates given.
		returns: Nothing.
	End Rem
	Method RenderArea(x:Float, y:Float, x2:Float, y2:Float, uv:dVec4)
		SetRenderQuad(x, y, x2, y2)
		m_texture.m_gltexture.SetUV(uv)
		m_texture.Bind()
		m_texture.Render(m_renderquad, False)
		m_texture.UnBind()
	End Method
	
	Rem
		bbdoc: Set the global theme render quad.
		returns: Nothing.
	End Rem
	Method SetRenderQuad(x:Float, y:Float, z:Float, w:Float)
		m_renderquad.Set(x, y, z, w)
	End Method
	
'#end region Update & miscellaneous
	
'#region Field accessors
	
	Rem
		bbdoc: Set the theme's formal name.
		returns: Nothing.
	End Rem
	Method SetFormalName(formalname:String)
		m_formalname = formalname
	End Method
	Rem
		bbdoc: Get the theme's formal name
		returns: The theme's formal name.
	End Rem
	Method GetFormalName:String()
		Return m_formalname
	End Method
	
	Rem
		bbdoc: Set the url pointing to the theme's texture.
		returns: Nothing.
	End Rem
	Method SetTextureURL(url:String)
		m_textureurl = url
	End Method
	Rem
		bbdoc: Get the url pointing to the theme's texture.
		returns: The texture's url (might be wrong if it was not updated as the texture was changed).
	End Rem
	Method GetTextureURL:String()
		Return m_textureurl
	End Method
	
	Rem
		bbdoc: Set the theme's texture.
		returns: Nothing.
	End Rem
	Method SetTexture(texture:dProtogTexture)
		m_texture = texture
	End Method
	Rem
		bbdoc: Get the theme's texture.
		returns: Nothing.
	End Rem
	Method GetTexture:dProtogTexture()
		Return m_texture
	End Method
	
'#end region Field accessors
	
'#region Collections
	
	Rem
		bbdoc: Add a set to the theme.
		returns: Nothing.
	End Rem
	Method AddSectionSet(set:duiThemeSectionSet)
		_AddStub(set)
	End Method
	
	Rem
		bbdoc: Add the set(s) in the given node to the theme.
		returns: Nothing.
	End Rem
	Method AddSectionSetsFromNode(root:dNode)
		Local set:duiThemeSectionSet
		For Local node:dNode = EachIn root.GetChildren()
			'DebugLog("(duiTheme.AddSectionSetsFromNode) node:~q" + node.GetName() + "~q")
			set = New duiThemeSectionSet.Create(node.GetName())
			AddSectionSet(set)
			set.FromNode(node)
		Next
	End Method
	
	Rem
		bbdoc: Get a set with the given name.
		returns: The set with the given name, or Null if the given name could not be found.
	End Rem
	Method GetSectionSetWithName:duiThemeSectionSet(name:String)
		Return duiThemeSectionSet(_GetStubWithName(name))
	End Method
	
	Rem
		bbdoc: Get a set from the given structure.
		returns: The set from the given structure, or Null if no set was found at the end of the structure.
	End Rem
	Method GetSectionSetFromStructure:duiThemeSectionSet(structure:String)
		Return duiThemeSectionSet(_GetStubFromStructure(structure))
	End Method
	
	Rem
		bbdoc: Check if the given set is in the theme.
		returns: True if the given set is in the theme, or False if it is not.
	End Rem
	Method ContainsSectionSet:Int(section:duiThemeSectionSet)
		Return ContainsSectionSetWithName(section.GetName())
	End Method
	
	Rem
		bbdoc: Check if there is a section in the theme with the given name.
		returns: True if there is a section with the given name, or False if there is not.
	End Rem
	Method ContainsSectionSetWithName:Int(name:String)
		Return _Contains(name)
	End Method
	
	Rem
		bbdoc: Get a section from the given structure.
		returns: The #duiThemeSection from the given structure, or Null if no section was found at the end of the structure.
	End Rem
	Method GetSectionFromStructure:duiThemeSection(structure:String)
		Return duiThemeSection(_GetStubFromStructure(structure))
	End Method
	
'#end region Collections
	
'#region Data handlers
	
	Rem
		bbdoc: Convert a given node to a theme.
		returns: The loaded theme (itself).
	End Rem
	Method FromNode:duiTheme(root:dNode)
		Local iden:dIdentifier, node:dNode
		'DebugStop
		For Local child:dVariable = EachIn root.GetChildren()
			iden = dIdentifier(child)
			If iden
				If m_template_name.ValidateIdentifier(iden)
					SetName(iden.GetValueAtIndex(0).ValueAsString())
				Else If m_template_formalname.ValidateIdentifier(iden)
					SetFormalName(iden.GetValueAtIndex(0).ValueAsString())
				Else If m_template_textureurl.ValidateIdentifier(iden)
					SetTextureURL(iden.GetValueAtIndex(0).ValueAsString())
				Else
					DebugLog("(duiTheme.FromNode) Unable to recognize identifier ~q" + iden.GetName() + "~q")
				End If
			Else
				node = dNode(child)
				If node
					Select node.GetName().ToLower()
						Case "sets"
							AddSectionSetsFromNode(node)
						Default
							DebugLog("Unknown node: '" + node.GetName() + "'")
					End Select
				End If
			End If
		Next
		'DebugLog("Report:~n" + Report())
		Return Self
	End Method
	
	Rem
		bbdoc: Get a node containing the theme's data.
		returns: A node containing all the theme's data.
	End Rem
	Method ToNode:dNode(nodename:String = "")
		Local node:dNode, iden:dIdentifier
		Local node_sets:dNode
		node = New dNode.Create(nodename)
		iden = New dIdentifier.Create(m_template_name.GetIden()[0])
		iden.AddVariable(New dStringVariable.Create(Null, m_name))
		node.AddVariable(iden)
		
		iden = New dIdentifier.Create(m_template_formalname.GetIden()[0])
		iden.AddVariable(New dStringVariable.Create(Null, m_formalname))
		node.AddVariable(iden)
		
		iden = New dIdentifier.Create(m_template_textureurl.GetIden()[0])
		iden.AddVariable(New dStringVariable.Create(Null, m_textureurl))
		node.AddVariable(iden)
		
		node_sets = New dNode.Create("sets")
		For Local set:duiThemeSectionSet = EachIn ValueEnumerator()
			node_sets.AddVariable(set.ToNode())
		Next
		node.AddVariable(node_sets)
		Return node
	End Method
	
	Rem
		bbdoc: Serialize the theme to the given stream.
		returns: Nothing.
	End Rem
	Method Serialize(stream:TStream)
		dStreamIO.WriteLString(stream, m_name)
		dStreamIO.WriteLString(stream, m_formalname)
		dStreamIO.WriteLString(stream, m_textureurl)
		stream.WriteInt(Count())
		If Count() > 0
			For Local set:duiThemeSectionSet = EachIn ValueEnumerator()
				set.Serialize(stream)
			Next
		End If
	End Method
	
	Rem
		bbdoc: Deserialize a theme from the given stream.
		returns: The deserialized theme (itself).
	End Rem
	Method Deserialize:duiTheme(stream:TStream)
		m_name = dStreamIO.ReadLString(stream)
		m_formalname = dStreamIO.ReadLString(stream)
		m_textureurl = dStreamIO.ReadLString(stream)
		Local count:Int = stream.ReadInt()
		If count > 0
			For Local i:Int = 0 Until count
				AddSectionSet(New duiThemeSectionSet.Deserialize(stream))
			Next
		End If
		Return Self
	End Method
	
	Rem
		bbdoc: Create a copy of the theme.
		returns: A complete copy of the theme.
	End Rem
	Method Copy:duiTheme()
		Local clone:duiTheme = New duiTheme.Create(m_name, m_formalname, m_textureurl)
		For Local set:duiThemeSectionSet = EachIn ValueEnumerator()
			clone.AddSectionSet(set.Copy())
		Next
		Return clone
	End Method
	
'#end region Data handlers
	
End Type

Rem
	bbdoc: ductui theme section set.
End Rem
Type duiThemeSectionSet Extends duiThemeStub
	
	Global m_template_importset:dTemplate = New dTemplate.Create(["importset"], [[TV_STRING] ])
	Global m_template_importsection:dTemplate = New dTemplate.Create(["importsection"], [[TV_STRING] ])
	
	Rem
		bbdoc: Create a new section set.
		returns: Itself.
	End Rem
	Method Create:duiThemeSectionSet(name:String)
		_Init(name)
		Return Self
	End Method
	
	Rem
		bbdoc: Import the given set.
		returns: Nothing.
	End Rem
	Method ImportSet(sectionset:duiThemeSectionSet)
		Local set:duiThemeSectionSet, section:duiThemeSection
		For Local stub:Object = EachIn sectionset.ValueEnumerator()
			set = duiThemeSectionSet(stub)
			section = duiThemeSection(stub)
			If set
				AddSectionSet(set.Copy())
			Else If section
				ImportSection(section)
			End If
		Next
	End Method
	
	Rem
		bbdoc: Import the given section.
		returns: Nothing.
	End Rem
	Method ImportSection(section:duiThemeSection)
		Local clone:duiThemeSection = section.Copy()
		AddSection(clone)
	End Method
	
'#region Update & miscellaneous
	
	Rem
		bbdoc: Update the section and all its children (sets and sections).
		returns: Nothing.
	End Rem
	Method Update(theme:duiTheme)
		Local set:duiThemeSectionSet, section:duiThemeSection
		For Local child:Object = EachIn ValueEnumerator()
			set = duiThemeSectionSet(child)
			section = duiThemeSection(child)
			If set
				set.Update(theme)
			Else If section
				section.Update(theme)
			End If
		Next
	End Method
	
'#end region Update & miscellaneous
	
'#region Collections
	
	Rem
		bbdoc: Check if there is an object in the set with the given name.
		returns: True if there is an object with the given name, or False if there is not.
	End Rem
	Method Contains:Int(name:String)
		Return _Contains(name)
	End Method
	
	Rem
		bbdoc: Add a set to the set.
		returns: Nothing.
	End Rem
	Method AddSectionSet(set:duiThemeSectionSet)
		_AddStub(set)
	End Method
	Rem
		bbdoc: Check if the given set is in the set.
		returns: True if the given set is in the set, or False if it is not.
	End Rem
	Method ContainsSectionSet:Int(set:duiThemeSectionSet)
		Return _Contains(set.GetName())
	End Method
	Rem
		bbdoc: Get a set with the given name.
		returns: The set with the given name, or Null if the given name could not be found.
	End Rem
	Method GetSectionSetWithName:duiThemeSectionSet(name:String)
		Return duiThemeSectionSet(_GetStubWithName(name))
	End Method
	Rem
		bbdoc: Get a set from the given structure.
		returns: The set from the given structure, or Null if no set was found at the end of the structure.
	End Rem
	Method GetSectionSetFromStructure:duiThemeSectionSet(structure:String)
		Return duiThemeSectionSet(_GetStubFromStructure(structure))
	End Method
	
	Rem
		bbdoc: Add a #duiThemeSection to the set.
		returns: Nothing.
	End Rem
	Method AddSection(section:duiThemeSection)
		_AddStub(section)
	End Method
	Rem
		bbdoc: Check if the given section is in the set.
		returns: True if the given #duiThemeSection is in the set, or False if it is not.
	End Rem
	Method ContainsSection:Int(section:duiThemeSection)
		Return _Contains(section.GetName())
	End Method
	Rem
		bbdoc: Get a section with the given name.
		returns: The section with the given name, or Null if the given name could not be found.
	End Rem
	Method GetSectionWithName:duiThemeSection(name:String)
		Return duiThemeSection(_GetStubWithName(name))
	End Method
	Rem
		bbdoc: Get a section from the given structure.
		returns: The #duiThemeSection from the given structure, or Null if no section was found at the end of the structure.
	End Rem
	Method GetSectionFromStructure:duiThemeSection(structure:String)
		Return duiThemeSection(_GetStubFromStructure(structure))
	End Method
	
'#end region Collections
	
'#region Data handlers
	
	Rem
		bbdoc: Convert the given node to a set.
		returns: The loaded set (itself).
	End Rem
	Method FromNode:duiThemeSectionSet(root:dNode)
		Local iden:dIdentifier, node:dNode
		Local set:duiThemeSectionSet
		'SetName(root.GetName())
		'Print("(duiThemeSectionSet.FromNode) name: ~q" + root.GetName() + "~q")
		For Local child:Object = EachIn root.GetChildren()
			iden = dIdentifier(child)
			If iden
				'DebugLog("(duiThemeSectionSet.FromNode) iden:~q" + iden.GetName() + "~q")
				If m_template_importsection.ValidateIdentifier(iden)
					Local structure:String = iden.GetValueAtIndex(0).ValueAsString()
					Local theme:duiTheme = duiTheme(GetTopParent())
					Local section:duiThemeSection
					If theme
						section = theme.GetSectionFromStructure(structure)
					Else
						DebugLog("(duiThemeSectionSet.FromNode()) [importsection] Failed to get top parent as a duiTheme")
					End If
					If section
						ImportSection(section)
					Else
						DebugLog("(duiThemeSectionSet.FromNode()) [importsection] Failed to find section at '" + structure + "'")
					End If
				Else If m_template_importset.ValidateIdentifier(iden)
					Local structure:String = iden.GetValueAtIndex(0).ValueAsString()
					Local theme:duiTheme = duiTheme(GetTopParent())
					If theme
						set = theme.GetSectionSetFromStructure(structure)
					Else
						DebugLog("(duiThemeSectionSet.FromNode()) [importset] Failed to get top parent as a duiTheme")
					End If
					If set
						ImportSet(set)
					Else
						DebugLog("(duiThemeSectionSet.FromNode()) [importset] Failed to find section set at '" + structure + "'")
					End If
				Else If duiThemeSection.ValidateIdentifier(iden)
					AddSection(New duiThemeSection.FromIdentifier(iden))
				Else
					DebugLog("(duiThemeSectionSet.FromNode) Unable to recognize identifier ~q" + iden.GetName() + "~q")
				End If
			Else
				node = dNode(child)
				If node
					'DebugLog("(duiThemeSectionSet.FromNode) node:~q" + node.GetName() + "~q")
					set = New duiThemeSectionSet.Create(node.GetName())
					AddSectionSet(set)
					set.FromNode(node)
				End If
			End If
		Next
		Return Self
	End Method
	
	Rem
		bbdoc: Get a node containing the set's data.
		returns: A node containing all the set's data.
	End Rem
	Method ToNode:dNode()
		Local node:dNode
		For Local stub:duiThemeStub = EachIn ValueEnumerator()
			If duiThemeSection(stub)
				node.AddVariable(duiThemeSection(stub).ToIdentifier())
			Else If duiThemeSectionSet(stub)
				node.AddVariable(duiThemeSectionSet(stub).ToNode())
			End If
		Next
		Return node
	End Method
	
	Rem
		bbdoc: Serialize the set to the given stream.
		returns: Nothing.
	End Rem
	Method Serialize(stream:TStream)
		dStreamIO.WriteLString(stream, m_name)
		stream.WriteInt(Count())
		If Count() > 0
			For Local stub:duiThemeStub = EachIn ValueEnumerator()
				If duiThemeSection(stub)
					stream.WriteByte(1)
					duiThemeSection(stub).Serialize(stream)
				Else If duiThemeSectionSet(stub)
					stream.WriteByte(2)
					duiThemeSectionSet(stub).Serialize(stream)
				End If
			Next
		End If
	End Method
	
	Rem
		bbdoc: Deserialize a set from the given stream.
		returns: The deserialized set (itself).
	End Rem
	Method Deserialize:duiThemeSectionSet(stream:TStream)
		m_name = dStreamIO.ReadLString(stream)
		Local count:Int = stream.ReadInt()
		If count > 0
			Local stubtype:Int
			For Local i:Int = 0 To count
				stubtype = Int(stream.ReadByte())
				If stubtype = 1
					AddSection(New duiThemeSection.Deserialize(stream))
				Else If stubtype = 2
					AddSectionSet(New duiThemeSectionSet.Deserialize(stream))
				End If
			Next
		End If
		Return Self
	End Method
	
	Rem
		bbdoc: Create a copy of the set.
		returns: A complete copy of the set.
	End Rem
	Method Copy:duiThemeSectionSet()
		Local set:duiThemeSectionSet, section:duiThemeSection
		Local clone:duiThemeSectionSet = New duiThemeSectionSet.Create(m_name)
		For Local stub:Object = EachIn ValueEnumerator()
			set = duiThemeSectionSet(stub)
			section = duiThemeSection(stub)
			If set
				clone.AddSectionSet(set.Copy())
			Else If section
				clone.AddSection(section.Copy())
			End If
		Next
		Return clone
	End Method
	
'#end region Data handlers
	
End Type

Rem
	bbdoc: ductui theme section.
End Rem
Type duiThemeSection Extends duiThemeStub
	
	Global m_template_section:dTemplate = New dTemplate.Create(["section"], [[TV_STRING] ], False, True, [TV_INTEGER, TV_FLOAT])
	
	Field m_x:Float, m_y:Float, m_width:Float, m_height:Float
	Field m_uv:dVec4 = New dVec4
	
	Method New()
		m_map = Null
	End Method
	
	Rem
		bbdoc: Create a new section.
		returns: Itself.
	End Rem
	Method Create:duiThemeSection(name:String, x:Float, y:Float, width:Float, height:Float)
		_Init(name)
		SetPosition(x, y)
		SetSize(width, height)
		Return Self
	End Method
	
'#region Update & miscellaneous
	
	Rem
		bbdoc: Update the section.
		returns: Nothing.
	End Rem
	Method Update(theme:duiTheme)
		theme.CalculateUV(m_uv, m_x, m_y, m_width, m_height)
	End Method
	
'#end region Update & miscellaneous
	
'#region Field accessors
	
	Rem
		bbdoc: Set the section's position.
		returns: Nothing.
	End Rem
	Method SetPosition(x:Float, y:Float)
		m_x = x
		m_y = y
	End Method
	
	Rem
		bbdoc: Set the section's size.
		returns: Nothing.
	End Rem
	Method SetSize(width:Float, height:Float)
		m_width = width
		m_height = height
	End Method
	
'#end region Field accessors
	
'#region Data handlers
	
	Rem
		bbdoc: Get a section from the given identifier.
		returns: The loaded section (itself).
	End Rem
	Method FromIdentifier:duiThemeSection(identifier:dIdentifier)
		SetName(identifier.GetValueAtIndex(0).ValueAsString())
		Local variable:dValueVariable = identifier.GetValueAtIndex(1)
		If variable
			m_x = Float(variable.ValueAsString())
			variable = identifier.GetValueAtIndex(2)
			If variable
				m_y = Float(variable.ValueAsString())
				variable = identifier.GetValueAtIndex(3)
				If variable
					m_width = Float(variable.ValueAsString())
					variable = identifier.GetValueAtIndex(4)
					If variable
						m_height = Float(variable.ValueAsString())
					End If
				End If
			End If
		End If
		Return Self
	End Method
	
	Rem
		bbdoc: Get an identifier containting the section's data.
		returns: An identifier containing the section's data.
	End Rem
	Method ToIdentifier:dIdentifier()
		Local identifier:dIdentifier = New dIdentifier.Create(m_template_section.GetIden()[0])
		identifier.AddVariable(New dStringVariable.Create(, m_name))
		If m_x <> 0.0 Or m_y <> 0.0 Or m_width <> 0.0 Or m_height <> 0.0
			identifier.AddVariable(New dFloatVariable.Create(, m_x))
			identifier.AddVariable(New dFloatVariable.Create(, m_y))
			If m_width <> 0.0 Or m_height <> 0.0
				identifier.AddVariable(New dFloatVariable.Create(, m_width))
				identifier.AddVariable(New dFloatVariable.Create(, m_height))
			End If
		End If
		Return identifier
	End Method
	
	Rem
		bbdoc: Validate the given identifier against the section template.
		returns: True if the identifier matches the template, or False if it does not.
	End Rem
	Function ValidateIdentifier:Int(identifier:dIdentifier)
		Return m_template_section.ValidateIdentifier(identifier)
	End Function
	
	Rem
		bbdoc: Serialize the section to the given stream.
		returns: Nothing.
	End Rem
	Method Serialize(stream:TStream)
		dStreamIO.WriteLString(stream, m_name)
		stream.WriteFloat(m_x)
		stream.WriteFloat(m_y)
		stream.WriteFloat(m_width)
		stream.WriteFloat(m_height)
	End Method
	
	Rem
		bbdoc: Deserialize a section from the given stream.
		returns: The deserialized section (itself).
	End Rem
	Method Deserialize:duiThemeSection(stream:TStream)
		m_name = dStreamIO.ReadLString(stream)
		m_x = stream.ReadFloat()
		m_y = stream.ReadFloat()
		m_width = stream.ReadFloat()
		m_height = stream.ReadFloat()
		Return Self
	End Method
	
	Rem
		bbdoc: Create a copy of the section.
		returns: A complete copy of the section.
	End Rem
	Method Copy:duiThemeSection()
		Local clone:duiThemeSection = New duiThemeSection.Create(m_name, m_x, m_y, m_width, m_height)
		Return clone
	End Method
	
'#end region Data handlers
	
	Rem
		bbdoc: Get a string containing a hierarchical report of all the section's data.
		returns: A string containing the name/structure of the section and its short data.
	End Rem
	Method Report:String(tab:String = Null)
		Return "~q." + m_name + "~q"
	End Method
	
End Type

