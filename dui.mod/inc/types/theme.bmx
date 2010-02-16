
Rem
	themerenderer.bmx (Contains: dui_ThemeManager, dui_ThemeStub, dui_Theme, dui_ThemeSection, dui_ThemeSectionSet, )
End Rem

Rem
	bbdoc: Theme manager for ductui.
End Rem
Type dui_ThemeManager
	
	Global m_themes:TObjectMap = New TObjectMap
	
'#region Collections
	
	Rem
		bbdoc: Add a theme to the manager.
		returns: True if the theme was added to the manager, or False if it was not (either the theme was Null, or it was already added to the manager).
	End Rem
	Function AddTheme:Int(theme:dui_Theme)
		If theme <> Null And ContainsTheme(theme) = False
			m_themes._Insert(theme.GetName(), theme)
			Return True
		End If
		Return False
	End Function
	
	Rem
		bbdoc: Get a theme from the name given.
		returns: The theme with the name given, or Null if the given name could not be found.
		about: The @name parameter is %not the formal name.
	End Rem
	Function GetThemeFromName:dui_Theme(name:String)
		Return dui_Theme(m_themes._ValueByKey(name))
	End Function
	
	Rem
		bbdoc: Load a theme from the given url (file, stream, etc.) and add it to the manager.
		returns: The theme that was added, or Null if the stream could not be opened.
		about: If the given url is a binary theme (rather than a script), pass @binary as True (defaults to False - script).
	End Rem
	Function AddThemeFromObject:dui_Theme(url:Object, loadtexture:Int = True, binary:Int = False, encoding:Int = SNPEncoding_UTF8)
		Local theme:dui_Theme
		Local stream:TStream
		
		stream = TStream(url)
		If stream = Null
			stream = ReadFile(url)
		End If
		If stream <> Null
			theme = AddThemeFromStream(stream, loadtexture, binary, encoding)
			stream.Close()
		End If
		Return theme
	End Function
	
	Rem
		bbdoc: Load a theme from the given stream and add it to the manager.
		returns: The theme that was added, or Null if the theme could not be loaded (stream is Null).
		about: If the given url is a binary theme (rather than a script), pass @binary as True (defaults to False - script).
	End Rem
	Function AddThemeFromStream:dui_Theme(stream:TStream, loadtexture:Int = True, binary:Int = False, encoding:Int = SNPEncoding_UTF8)
		Local theme:dui_Theme
		
		If stream <> Null
			If binary = True
				theme = New dui_Theme.Deserialize(stream)
			Else
				Local node:TSNode
				
				node = TSNode.LoadScriptFromObject(stream, encoding)
				If node <> Null
					theme = New dui_Theme.FromNode(node)
				End If
			End If
			
			If theme <> Null
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
	Function ContainsTheme:Int(theme:dui_Theme)
		If theme.GetName() = Null
			Return False
		End If
		Return m_themes._Contains(theme.GetName())
	End Function
	
	Rem
		bbdoc: Check if there is a theme with the name given in the manager.
		returns: True if there is a theme with the name given, or False if there is not.
		about: The @name parameter is %not the formal name of the theme.
	End Rem
	Function ContainsThemeFromName:Int(name:String)
		Return m_themes._Contains(name)
	End Function
	
'#end region (Collections)
	
End Type

Rem
	bbdoc: ductui theme stub.
End Rem
Type dui_ThemeStub Extends TObjectMap
	
	Global m_template_name:TTemplate = New TTemplate.Create(["name"], [[TV_STRING] ])
	
	Field m_name:String
	Field m_parent:dui_ThemeStub
	
	Method New()
	End Method
	
	Rem
		bbdoc: Initialize the dui_ThemeStub.
		returns: Nothing.
	End Rem
	Method _Init(name:String)
		SetName(name)
	End Method
	
'#region Field accessors
	
	Rem
		bbdoc: Set the dui_ThemeStub's name.
		returns: Nothing.
	End Rem
	Method SetName(name:String)
		m_name = name
	End Method
	Rem
		bbdoc: Get the dui_ThemeStub's name
		returns: The dui_ThemeStub's name.
	End Rem
	Method GetName:String()
		Return m_name
	End Method
	
	Rem
		bbdoc: Set the stub's parent.
		returns: Nothing.
	End Rem
	Method SetParent(parent:dui_ThemeStub)
		m_parent = parent
	End Method
	Rem
		bbdoc: Get the stub's parent.
		returns: The stub's parent.
	End Rem
	Method GetParent:dui_ThemeStub()
		Return m_parent
	End Method
	
'#end region (Field accessors)
	
'#region Collections
	
	Rem
		bbdoc: Get the top-most parent of the stub.
		returns: The top-most parent of the stub, or itself if the stub has no parent.
	End Rem
	Method GetTopParent:dui_ThemeStub()
		If m_parent <> Null
			Local topparent:dui_ThemeStub
			topparent = m_parent.GetTopParent()
			If topparent <> Null
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
		If m_parent <> Null
			Local parentstructure:String = m_parent.GetStructure()
			If parentstructure <> Null
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
	Method _AddStub(stub:dui_ThemeStub)
		If stub <> Null
			If stub.GetName() <> Null
				stub.SetParent(Self)
				_Insert(stub.GetName(), stub)
			Else
				Assert "(dui_ThemeStub._AddStub) Stub name is Null!"
			End If
		End If
	End Method
	
	Rem
		bbdoc: Get a stub from the name given.
		returns: The #dui_ThemeStub from the name given, or Null if there is no stub with the name given.
	End Rem
	Method _GetStubFromName:dui_ThemeStub(name:String)
		Return dui_ThemeStub(_ValueByKey(name))
	End Method
	
	Rem
		bbdoc: Get a stub from the given structure.
		returns: The #dui_ThemeStub from the given structure, or Null if no stub was found at the end of the structure.
	End Rem
	Method _GetStubFromStructure:dui_ThemeStub(structure:String)
		Local sloc:Int, separator:String = "."
		
		sloc = structure.Find(separator)
		If sloc = -1
			Return _GetStubFromName(structure)
		Else
			Local stub:dui_ThemeStub
			
			stub = _GetStubFromName(structure[..sloc])
			If stub <> Null
				Return stub._GetStubFromStructure(structure[sloc + separator.Length..])
			End If
		End If
		
		Return Null
	End Method
	
'#end region (Collections)
	
'#region Data handlers
	
	Rem
		bbdoc: Serialize the dui_ThemeStub to the given stream.
		returns: Nothing.
	End Rem
	Method Serialize(stream:TStream) Abstract
	
	Rem
		bbdoc: Deserialize a dui_ThemeStub from the given stream.
		returns: The deserialized dui_ThemeStub (itself).
	End Rem
	Method Deserialize:dui_ThemeStub(stream:TStream) Abstract
	
	Rem
		bbdoc: Create a copy of the stub.
		returns: A complete copy of the stub.
	End Rem
	Method Copy:dui_ThemeStub() Abstract
	
'#end region (Data handlers)
	
	Rem
		bbdoc: Get a string containing a hierarchical report of all the stub's data and all its children.
		returns: A string containing the name/structure of the stub and its short data.
	End Rem
	Method Report:String(tab:String = Null)
		Local stub:dui_ThemeStub, str:String
		
		If tab = Null
			str = "~q" + m_name + "~q~n"
		Else
			str = "~q." + m_name + "~q~n"
		End If
		For stub = EachIn ValueEnumerator()
			str:+tab + stub.Report(tab + "~t") + "~n"
		Next
		Return str[0..str.Length - 1]
	End Method
	
End Type

Rem
	bbdoc: ductui theme.
End Rem
Type dui_Theme Extends dui_ThemeStub
	
	Global m_template_formalname:TTemplate = New TTemplate.Create(["formalname"], [[TV_STRING] ])
	Global m_template_textureurl:TTemplate = New TTemplate.Create(["texture"], [[TV_STRING] ])
	
	Global m_texflags:Int = TEXTURE_FILTER ' | TEXTURE_MIPMAP ' | TEXTURE_RECTANGULAR
	Global m_renderquad:TVec4 = New TVec4
	
	Field m_formalname:String
	Field m_texture:TProtogTexture, m_textureurl:String
	Field m_xdelta:Float, m_ydelta:Float, m_texture_width:Float, m_texture_height:Float
	
	Rem
		bbdoc: Create a new theme.
		returns: The new theme (itself), or Null if the given texture could not be loaded (see #LoadTexture).
		about: If @loadtex is True the theme texture will be loaded.
	End Rem
	Method Create:dui_Theme(name:String, formalname:String, textureurl:String, loadtex:Int = True)
		_Init(name)
		SetFormalName(formalname)
		SetTextureURL(textureurl)
		If loadtex = True
			If LoadTexture() = False
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
		Local set:dui_ThemeSectionSet
		
		For set = EachIn ValueEnumerator()
			set.Update(Self)
		Next
	End Method
	
	Rem
		bbdoc: Load the theme's texture (from the texture url).
		returns: True if the texture was loaded, or False if it was not (pixmap was Null).
	End Rem
	Method LoadTexture:Int()
		Local pixmap:TPixmap
		
		pixmap = LoadPixmap(m_textureurl)
		If pixmap <> Null
			m_texture = New TProtogTexture.Create(pixmap, m_texflags)
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
	Method CalculateUV(vector:TVec4, x:Float, y:Float, width:Float, height:Float)
		x:*m_xdelta
		y:*m_ydelta
		
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
	Method RenderArea(x:Float, y:Float, x2:Float, y2:Float, uv:TVec4)
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
	
'#end region (Update & miscellaneous)
	
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
	Method SetTexture(texture:TProtogTexture)
		m_texture = texture
	End Method
	Rem
		bbdoc: Get the theme's texture.
		returns: Nothing.
	End Rem
	Method GetTexture:TProtogTexture()
		Return m_texture
	End Method
	
'#end region (Field accessors)
	
'#region Collections
	
	Rem
		bbdoc: Add a set to the theme.
		returns: Nothing.
	End Rem
	Method AddSectionSet(set:dui_ThemeSectionSet)
		_AddStub(set)
	End Method
	
	Rem
		bbdoc: Add the set(s) in the given node to the theme.
		returns: Nothing.
	End Rem
	Method AddSectionSetsFromNode(root:TSNode)
		Local node:TSNode, set:dui_ThemeSectionSet
		
		For node = EachIn root.GetChildren()
			'DebugLog("(dui_Theme.AddSectionSetsFromNode) node:~q" + node.GetName() + "~q")
			set = New dui_ThemeSectionSet.Create(node.GetName())
			AddSectionSet(set)
			set.FromNode(node)
		Next
	End Method
	
	Rem
		bbdoc: Get a set from the given name.
		returns: The set with the name given, or Null if no set by the given name exists.
	End Rem
	Method GetSectionSetFromName:dui_ThemeSectionSet(name:String)
		Return dui_ThemeSectionSet(_GetStubFromName(name))
	End Method
	
	Rem
		bbdoc: Get a set from the given structure.
		returns: The set from the given structure, or Null if no set was found at the end of the structure.
	End Rem
	Method GetSectionSetFromStructure:dui_ThemeSectionSet(structure:String)
		Return dui_ThemeSectionSet(_GetStubFromStructure(structure))
	End Method
	
	Rem
		bbdoc: Check if the given set is in the theme.
		returns: True if the given set is in the theme, or False if it is not.
	End Rem
	Method ContainsSectionSet:Int(section:dui_ThemeSectionSet)
		Return ContainsSectionSetFromName(section.GetName())
	End Method
	
	Rem
		bbdoc: Check if there is a section in the theme with the given name.
		returns: True if there is a section with the given name, or False if there is not.
	End Rem
	Method ContainsSectionSetFromName:Int(name:String)
		Return _Contains(name)
	End Method
	
	Rem
		bbdoc: Get a section from the given structure.
		returns: The #dui_ThemeSection from the given structure, or Null if no section was found at the end of the structure.
	End Rem
	Method GetSectionFromStructure:dui_ThemeSection(structure:String)
		Return dui_ThemeSection(_GetStubFromStructure(structure))
	End Method
	
'#end region (Collections)
	
'#region Data handlers
	
	Rem
		bbdoc: Convert a given node to a theme.
		returns: The loaded theme (itself).
	End Rem
	Method FromNode:dui_Theme(root:TSNode)
		Local child:Object, iden:TIdentifier, node:TSNode
		
		'DebugStop
		For child = EachIn root.GetChildren()
			iden = TIdentifier(child)
			If iden <> Null
				If m_template_name.ValidateIdentifier(iden) = True
					SetName(iden.GetValueAtIndex(0).ValueAsString())
				Else If m_template_formalname.ValidateIdentifier(iden) = True
					SetFormalName(iden.GetValueAtIndex(0).ValueAsString())
				Else If m_template_textureurl.ValidateIdentifier(iden) = True
					SetTextureURL(iden.GetValueAtIndex(0).ValueAsString())
				Else
					DebugLog("(dui_Theme.FromNode) Unable to recognize identifier ~q" + iden.GetName() + "~q")
				End If
			Else
				node = TSNode(child)
				If node <> Null
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
	Method ToNode:TSNode(nodename:String = "")
		Local node:TSNode, iden:TIdentifier
		Local node_sets:TSNode, set:dui_ThemeSectionSet
		
		node = New TSNode.Create(nodename)
		iden = New TIdentifier.CreateByData(m_template_name.GetIden()[0])
		iden.AddValue(New TStringVariable.Create(Null, m_name))
		node.AddIdentifier(iden)
		
		iden = New TIdentifier.CreateByData(m_template_formalname.GetIden()[0])
		iden.AddValue(New TStringVariable.Create(Null, m_formalname))
		node.AddIdentifier(iden)
		
		iden = New TIdentifier.CreateByData(m_template_textureurl.GetIden()[0])
		iden.AddValue(New TStringVariable.Create(Null, m_textureurl))
		node.AddIdentifier(iden)
		
		node_sets = New TSNode.Create("sets")
		For set = EachIn ValueEnumerator()
			node_sets.AddNode(set.ToNode())
		Next
		node.AddNode(node_sets)
		
		Return node
	End Method
	
	Rem
		bbdoc: Serialize the theme to the given stream.
		returns: Nothing.
	End Rem
	Method Serialize(stream:TStream)
		Local set:dui_ThemeSectionSet
		
		WriteLString(stream, m_name)
		WriteLString(stream, m_formalname)
		WriteLString(stream, m_textureurl)
		
		stream.WriteInt(Count())
		If Count() > 0
			For set = EachIn ValueEnumerator()
				set.Serialize(stream)
			Next
		End If
	End Method
	
	Rem
		bbdoc: Deserialize a theme from the given stream.
		returns: The deserialized theme (itself).
	End Rem
	Method Deserialize:dui_Theme(stream:TStream)
		Local count:Int
		
		m_name = ReadLString(stream)
		m_formalname = ReadLString(stream)
		m_textureurl = ReadLString(stream)
		
		count = stream.ReadInt()
		If count > 0
			For Local i:Int = 0 To count - 1
				AddSectionSet(New dui_ThemeSectionSet.Deserialize(stream))
			Next
		End If
		Return Self
	End Method
	
	Rem
		bbdoc: Create a copy of the theme.
		returns: A complete copy of the theme.
	End Rem
	Method Copy:dui_Theme()
		Local clone:dui_Theme, set:dui_ThemeSectionSet
		
		clone = New dui_Theme.Create(m_name, m_formalname, m_textureurl)
		For set = EachIn ValueEnumerator()
			clone.AddSectionSet(set.Copy())
		Next
		Return clone
	End Method
	
'#end region (Data handlers)
	
End Type

Rem
	bbdoc: ductui theme section set.
End Rem
Type dui_ThemeSectionSet Extends dui_ThemeStub
	
	Global m_template_importset:TTemplate = New TTemplate.Create(["importset"], [[TV_STRING] ])
	Global m_template_importsection:TTemplate = New TTemplate.Create(["importsection"], [[TV_STRING] ])
	
	Rem
		bbdoc: Create a new section set.
		returns: The new section set (itself).
	End Rem
	Method Create:dui_ThemeSectionSet(name:String)
		_Init(name)
		Return Self
	End Method
	
	Rem
		bbdoc: Import the given set.
		returns: Nothing.
	End Rem
	Method ImportSet(sectionset:dui_ThemeSectionSet)
		Local stub:Object, set:dui_ThemeSectionSet, section:dui_ThemeSection
		
		For stub = EachIn sectionset.ValueEnumerator()
			set = dui_ThemeSectionSet(stub)
			section = dui_ThemeSection(stub)
			If set <> Null
				AddSectionSet(set.Copy())
			Else If section <> Null
				ImportSection(section)
			End If
		Next
	End Method
	
	Rem
		bbdoc: Import the given section.
		returns: Nothing.
	End Rem
	Method ImportSection(section:dui_ThemeSection)
		Local clone:dui_ThemeSection
		
		clone = section.Copy()
		AddSection(clone)
	End Method
	
'#region Update & miscellaneous
	
	Rem
		bbdoc: Update the section and all its children (sets and sections).
		returns: Nothing.
	End Rem
	Method Update(theme:dui_Theme)
		Local child:Object, set:dui_ThemeSectionSet, section:dui_ThemeSection
		
		For child = EachIn ValueEnumerator()
			set = dui_ThemeSectionSet(child)
			section = dui_ThemeSection(child)
			If set <> Null
				set.Update(theme)
			Else If section <> Null
				section.Update(theme)
			End If
		Next
	End Method
	
'#end region (Update & miscellaneous)
	
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
	Method AddSectionSet(set:dui_ThemeSectionSet)
		_AddStub(set)
	End Method
	Rem
		bbdoc: Check if the given set is in the set.
		returns: True if the given set is in the set, or False if it is not.
	End Rem
	Method ContainsSectionSet:Int(set:dui_ThemeSectionSet)
		Return _Contains(set.GetName())
	End Method
	Rem
		bbdoc: Get a set from the given name.
		returns: The set with the name given, or Null if no set by the given name exists.
	End Rem
	Method GetSectionSetFromName:dui_ThemeSectionSet(name:String)
		Return dui_ThemeSectionSet(_GetStubFromName(name))
	End Method
	Rem
		bbdoc: Get a set from the given structure.
		returns: The set from the given structure, or Null if no set was found at the end of the structure.
	End Rem
	Method GetSectionSetFromStructure:dui_ThemeSectionSet(structure:String)
		Return dui_ThemeSectionSet(_GetStubFromStructure(structure))
	End Method
	
	Rem
		bbdoc: Add a #dui_ThemeSection to the set.
		returns: Nothing.
	End Rem
	Method AddSection(section:dui_ThemeSection)
		_AddStub(section)
	End Method
	Rem
		bbdoc: Check if the given section is in the set.
		returns: True if the given #dui_ThemeSection is in the set, or False if it is not.
	End Rem
	Method ContainsSection:Int(section:dui_ThemeSection)
		Return _Contains(section.GetName())
	End Method
	Rem
		bbdoc: Get a section from the given name.
		returns: The #dui_ThemeSection with the name given, or Null if no section by the given name exists.
	End Rem
	Method GetSectionFromName:dui_ThemeSection(name:String)
		Return dui_ThemeSection(_GetStubFromName(name))
	End Method
	Rem
		bbdoc: Get a section from the given structure.
		returns: The #dui_ThemeSection from the given structure, or Null if no section was found at the end of the structure.
	End Rem
	Method GetSectionFromStructure:dui_ThemeSection(structure:String)
		Return dui_ThemeSection(_GetStubFromStructure(structure))
	End Method
	
'#end region (Collections)
	
'#region Data handlers
	
	Rem
		bbdoc: Convert the given node to a set.
		returns: The loaded set (itself).
	End Rem
	Method FromNode:dui_ThemeSectionSet(root:TSNode)
		Local child:Object, iden:TIdentifier, node:TSNode
		Local set:dui_ThemeSectionSet
		
		'SetName(root.GetName())
		'Print("(dui_ThemeSectionSet.FromNode) name: ~q" + root.GetName() + "~q")
		For child = EachIn root.GetChildren()
			iden = TIdentifier(child)
			If iden <> Null
				'DebugLog("(dui_ThemeSectionSet.FromNode) iden:~q" + iden.GetName() + "~q")
				If m_template_importsection.ValidateIdentifier(iden) = True
					Local structure:String, theme:dui_Theme, section:dui_ThemeSection
					
					structure = iden.GetValueAtIndex(0).ValueAsString()
					theme = dui_Theme(GetTopParent())
					If theme <> Null
						section = theme.GetSectionFromStructure(structure)
					Else
						DebugLog("(dui_ThemeSectionSet.FromNode()) [importsection] Failed to get top parent as a dui_Theme")
					End If
					If section <> Null
						ImportSection(section)
					Else
						DebugLog("(dui_ThemeSectionSet.FromNode()) [importsection] Failed to find section at '" + structure + "'")
					End If
				Else If m_template_importset.ValidateIdentifier(iden) = True
					Local structure:String, theme:dui_Theme
					
					structure = iden.GetValueAtIndex(0).ValueAsString()
					theme = dui_Theme(GetTopParent())
					If theme <> Null
						set = theme.GetSectionSetFromStructure(structure)
					Else
						DebugLog("(dui_ThemeSectionSet.FromNode()) [importset] Failed to get top parent as a dui_Theme")
					End If
					If set <> Null
						ImportSet(set)
					Else
						DebugLog("(dui_ThemeSectionSet.FromNode()) [importset] Failed to find section set at '" + structure + "'")
					End If
				Else If dui_ThemeSection.ValidateIdentifier(iden) = True
					AddSection(New dui_ThemeSection.FromIdentifier(iden))
				Else
					DebugLog("(dui_ThemeSectionSet.FromNode) Unable to recognize identifier ~q" + iden.GetName() + "~q")
				End If
			Else
				node = TSNode(child)
				If node <> Null
					'DebugLog("(dui_ThemeSectionSet.FromNode) node:~q" + node.GetName() + "~q")
					set = New dui_ThemeSectionSet.Create(node.GetName())
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
	Method ToNode:TSNode()
		Local stub:dui_ThemeStub, node:TSNode
		
		For stub = EachIn ValueEnumerator()
			If dui_ThemeSection(stub)
				node.AddIdentifier(dui_ThemeSection(stub).ToIdentifier())
			Else If dui_ThemeSectionSet(stub)
				node.AddNode(dui_ThemeSectionSet(stub).ToNode())
			End If
		Next
		Return node
	End Method
	
	Rem
		bbdoc: Serialize the set to the given stream.
		returns: Nothing.
	End Rem
	Method Serialize(stream:TStream)
		WriteLString(stream, m_name)
		
		stream.WriteInt(Count())
		If Count() > 0
			Local stub:dui_ThemeStub
			For stub = EachIn ValueEnumerator()
				If dui_ThemeSection(stub)
					stream.WriteByte(1)
					dui_ThemeSection(stub).Serialize(stream)
				Else If dui_ThemeSectionSet(stub)
					stream.WriteByte(2)
					dui_ThemeSectionSet(stub).Serialize(stream)
				End If
			Next
		End If
	End Method
	
	Rem
		bbdoc: Deserialize a set from the given stream.
		returns: The deserialized set (itself).
	End Rem
	Method Deserialize:dui_ThemeSectionSet(stream:TStream)
		m_name = ReadLString(stream)
		
		Local count:Int = stream.ReadInt()
		If count > 0
			Local stubtype:Int, i:Int
			
			For i = 0 To count - 1
				stubtype = Int(stream.ReadByte())
				If stubtype = 1
					AddSection(New dui_ThemeSection.Deserialize(stream))
				Else If stubtype = 2
					AddSectionSet(New dui_ThemeSectionSet.Deserialize(stream))
				End If
			Next
		End If
		Return Self
	End Method
	
	Rem
		bbdoc: Create a copy of the set.
		returns: A complete copy of the set.
	End Rem
	Method Copy:dui_ThemeSectionSet()
		Local clone:dui_ThemeSectionSet
		Local stub:Object, set:dui_ThemeSectionSet, section:dui_ThemeSection
		
		clone = New dui_ThemeSectionSet.Create(m_name)
		For stub = EachIn ValueEnumerator()
			set = dui_ThemeSectionSet(stub)
			section = dui_ThemeSection(stub)
			If set <> Null
				clone.AddSectionSet(set.Copy())
			Else If section <> Null
				clone.AddSection(section.Copy())
			End If
		Next
		Return clone
	End Method
	
'#end region (Data handlers)
	
End Type

Rem
	bbdoc: ductui theme section.
End Rem
Type dui_ThemeSection Extends dui_ThemeStub
	
	Global m_template_section:TTemplate = New TTemplate.Create(["section"], [[TV_STRING] ], False, True, [TV_INTEGER, TV_FLOAT])
	
	Field m_x:Float, m_y:Float, m_width:Float, m_height:Float
	Field m_uv:TVec4 = New TVec4
	
	Method New()
		m_map = Null
	End Method
	
	Rem
		bbdoc: Create a new section.
		returns: The new section (itself).
	End Rem
	Method Create:dui_ThemeSection(name:String, x:Float, y:Float, width:Float, height:Float)
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
	Method Update(theme:dui_Theme)
		theme.CalculateUV(m_uv, m_x, m_y, m_width, m_height)
	End Method
	
'#end region (Update & miscellaneous)
	
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
	
'#end region (Field accessors)
	
'#region Data handlers
	
	Rem
		bbdoc: Get a section from the given identifier.
		returns: The loaded section (itself).
	End Rem
	Method FromIdentifier:dui_ThemeSection(identifier:TIdentifier)
		Local variable:TVariable
		
		SetName(identifier.GetValueAtIndex(0).ValueAsString())
		
		variable = identifier.GetValueAtIndex(1)
		If variable <> Null
			m_x = Float(variable.ValueAsString())
			
			variable = identifier.GetValueAtIndex(2)
			If variable <> Null
				m_y = Float(variable.ValueAsString())
				
				variable = identifier.GetValueAtIndex(3)
				If variable <> Null
					m_width = Float(variable.ValueAsString())
					
					variable = identifier.GetValueAtIndex(4)
					If variable <> Null
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
	Method ToIdentifier:TIdentifier()
		Local identifier:TIdentifier
		
		identifier = New TIdentifier.CreateByData(m_template_section.GetIden()[0])
		identifier.AddValue(New TStringVariable.Create(Null, m_name))
		If m_x <> 0.0 Or m_y <> 0.0 Or m_width <> 0.0 Or m_height <> 0.0
			identifier.AddValue(New TFloatVariable.Create(Null, m_x))
			identifier.AddValue(New TFloatVariable.Create(Null, m_y))
			If m_width <> 0.0 Or m_height <> 0.0
				identifier.AddValue(New TFloatVariable.Create(Null, m_width))
				identifier.AddValue(New TFloatVariable.Create(Null, m_height))
			End If
		End If
		Return identifier
	End Method
	
	Rem
		bbdoc: Validate the given identifier against the section template.
		returns: True if the identifier matches the template, or False if it does not.
	End Rem
	Function ValidateIdentifier:Int(identifier:TIdentifier)
		Return m_template_section.ValidateIdentifier(identifier)
	End Function
	
	Rem
		bbdoc: Serialize the section to the given stream.
		returns: Nothing.
	End Rem
	Method Serialize(stream:TStream)
		WriteLString(stream, m_name)
		
		stream.WriteFloat(m_x)
		stream.WriteFloat(m_y)
		stream.WriteFloat(m_width)
		stream.WriteFloat(m_height)
	End Method
	
	Rem
		bbdoc: Deserialize a section from the given stream.
		returns: The deserialized section (itself).
	End Rem
	Method Deserialize:dui_ThemeSection(stream:TStream)
		m_name = ReadLString(stream)
		
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
	Method Copy:dui_ThemeSection()
		Local clone:dui_ThemeSection
		clone = New dui_ThemeSection.Create(m_name, m_x, m_y, m_width, m_height)
		Return clone
	End Method
	
'#end region (Data handlers)
	
	Rem
		bbdoc: Get a string containing a hierarchical report of all the section's data.
		returns: A string containing the name/structure of the section and its short data.
	End Rem
	Method Report:String(tab:String = Null)
		Return "~q." + m_name + "~q"
	End Method
	
End Type

