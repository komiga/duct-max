
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

Rem
	bbdoc: Protog single-surface textured font.
End Rem
Type dProtogFont
	
	Global m_template_name:dTemplate = New dTemplate.Create(["name"], [[TV_STRING]])
	Global m_template_texture:dTemplate = New dTemplate.Create(["texture"], [[TV_STRING]])
	Global m_template_height:dTemplate = New dTemplate.Create(["height"], [[TV_FLOAT]])
	
	Global m_map:dObjectMap = New dObjectMap
	
	Field m_name:String, m_height:Float
	Field m_texture:dProtogTexture
	Field m_chars:dIntMap, m_emptychar:dProtogFontChar
	
	Method New()
		m_chars = New dIntMap
	End Method
	
	Method Delete()
		m_chars = Null
	End Method
	
	Method InsertSelf()
		m_map._Insert(m_name, Self)
	End Method
	
'#region Rendering
	
	Rem
		bbdoc: Render a string on the screen using the font.
		returns: Nothing.
	End Rem
	Method RenderStringVec(str:String, pos:dVec2, hcenter:Int = False, vcenter:Int = False)
		RenderStringParams(str, pos.m_x, pos.m_y, hcenter, vcenter)
	End Method
	
	Rem
		bbdoc: Render a string on the screen using the font.
		returns: Nothing.
	End Rem
	Method RenderStringParams(str:String, x:Float, y:Float, hcenter:Int = False, vcenter:Int = False)
		Local char:dProtogFontChar, index:Int, charcode:Int
		Local offsetx:Float, offsety:Float
		Local incx:Float, incy:Float
		If str
			If hcenter
				offsetx = -(StringWidth(str) / 2.0)
			End If
			If vcenter
				offsety = -(StringHeight(str) / 2.0)
			End If
			m_texture.m_gltexture.Bind()
			For index = 0 Until str.Length
				charcode = str[index]
				char = dProtogFontChar(m_chars.ForKey(charcode))
				If charcode = 10
					incx = 0.0
					incy:+ m_height
				Else If charcode <> 13 ' Just ignore ~r
					If Not char
						char = m_emptychar
					End If
					char.Render(x + offsetx + incx, y + offsety + incy)
					incx:+ char.m_width
				End If
			Next
			m_texture.m_gltexture.Unbind()
		End If
	End Method
	
	Rem
		bbdoc: Get the combined pixel-width of the given string (if it were drawn using this font).
		returns: The width of the given string in pixels (0.0 if the given string is Null).
	End Rem
	Method StringWidth:Float(str:String)
		Local largestwidth:Float
		If str
			Local char:dProtogFontChar, charcode:Int, width:Float
			For Local index:Int = 0 Until str.Length
				charcode = str[index]
				char = dProtogFontChar(m_chars.ForKey(charcode))
				If charcode = 10
					If width > largestwidth
						largestwidth = width
					End If
					width = 0.0
				Else If charcode <> 13 ' Just ignore ~r
					If Not char
						char = m_emptychar
					End If
					width:+ char.m_width
				End If
			Next
			If width > largestwidth
				largestwidth = width
			End If
		End If
		Return largestwidth
	End Method
	
	Rem
		bbdoc: Get the combined pixel-height of the given string (if it were drawn using this font).
		returns: The height of the given string in pixels (0.0 if the given string is Null).
		about: This really only needs to be used if the given string contains a newline character (if it does not you can simply use the font's height).
	End Rem
	Method StringHeight:Float(str:String)
		Local height:Float
		If str
			height = m_height
			For Local index:Int = 0 Until str.Length
				If str[index] = 10
					height:+ m_height
				End If
			Next
		End If
		Return height
	End Method
	
'#end region Rendering
	
'#region Data handling
	
	Rem
		bbdoc: Deserialize a font from the given stream.
		returns: The deserialized dProtogFont.
		about: If @readtexture is True, the texture's pixmap will be deserialized from the stream.<br>
		If @upload is True the texture (if loaded) will be uploaded to OpenGL (the GL texture will be created).<br>
		If @upload is False you must upload the texture at some point in the future.
	End Rem
	Method Deserialize:dProtogFont(stream:TStream, readtexture:Int = True, upload:Int = True)
		m_name = dStreamIO.ReadLString(stream)
		m_height = stream.ReadFloat()
		Local count:Int = stream.ReadInt()
		If readtexture
			m_texture = New dProtogTexture.Deserialize(stream, upload)
		End If
		Local char:dProtogFontChar
		For Local index:Int = 0 Until count
			char = New dProtogFontChar.Deserialize(stream)
			m_chars.Insert(char.m_char, char)
		Next
		m_emptychar = GetChar(-1)
		InsertSelf()
		Return Self
	End Method
	
	Rem
		bbdoc: Serialize the font to the given stream.
		returns: Nothing.
		about: If @writetexture is True, the texture's pixmap will be serialized to the stream.
	End Rem
	Method Serialize(stream:TStream, writetexture:Int = True)
		dStreamIO.WriteLString(stream, m_name)
		stream.WriteFloat(m_height)
		stream.WriteInt(m_chars.Count())
		If writetexture
			m_texture.Serialize(stream)
		End If
		For Local char:dProtogFontChar = EachIn m_chars
			char.Serialize(stream)
		Next
	End Method
	
	Rem
		bbdoc: Get a dProtogFont from the given dNode.
		returns: The converted font (itself), or Null if there was an error (likely that the texture could not be loaded).
		about: If @upload is True the pixmap will be uploaded to OpenGL (creates the GL texture).
	End Rem
	Method FromNode:dProtogFont(root:dNode, upload:Int = True)
		Local pixmap:TPixmap, char:dProtogFontChar
		Local texc_width:Float, texc_height:Float, posx:Float, posy:Float
		' Doing this here because we want to be sure this is loaded before anything else (the end-user/developer could have this at or near the end of the script)
		Local iden:dIdentifier = root.GetIdentifierMatchingTemplate(m_template_texture)
		If iden
			Local path:String = dStringVariable(iden.GetVariableAtIndex(0)).Get()
			pixmap = LoadPixmap(path)
			If Not pixmap Then Throw "(duct.protog2d.dProtogFont.FromNode) Unable to load ~q" + path + "~q"
			m_texture = New dProtogTexture.Create(pixmap, 0, upload)
			texc_width = 1.0 / m_texture.m_width
			texc_height = 1.0 / m_texture.m_height
		Else
			Throw "(duct.protog2d.dProtogFont.FromNode) Unable to find/validate texture identifier in node (needed for calculations)"
		End If
		' Another pre-requisite
		iden = root.GetIdentifierMatchingTemplate(m_template_height)
		If iden
			m_height = dFloatVariable(iden.GetVariableAtIndex(0)).Get()
		Else
			Throw "(duct.protog2d.dProtogFont.FromNode) Unable to find/validate font height identifier in node (needed for calculations)"
		End If
		For iden = EachIn root.GetChildren()
			'If iden
				If dProtogFontChar.ValidateIdentifier(iden)
					char = New dProtogFontChar.FromIdentifier(iden, posx, posy)
					char.SetUV(posx * texc_width, posy * texc_height, (posx + char.m_width) * texc_width, (posy + char.m_height) * texc_height)
					m_chars.Insert(char.m_char, char)
				Else If m_template_name.ValidateIdentifier(iden)
					m_name = dStringVariable(iden.GetVariableAtIndex(0)).Get()
				End If
			'End If
		Next
		m_emptychar = GetChar(-1)
		InsertSelf()
		Return Self
	End Method
	
	Rem
	Method ToNode:dNode(texture_path:String)
		Local node:dNode, iden:dIdentifier
		node = New dNode.Create(Null)
		iden = New dIdentifier.CreateByData("name")
		iden.AddValue(New dStringVariable.Create(Null, m_name))
		node.AddIdentifier(iden)
		iden = New dIdentifier.CreateByData("texture")
		iden.AddValue(New dStringVariable.Create(Null, texture_path))
		node.AddIdentifier(iden)
		iden = New dIdentifier.CreateByData("height")
		iden.AddValue(New dStringVariable.Create(Null, m_height))
		node.AddIdentifier(iden)
		Local char:dProtogFontChar
		For char = EachIn m_chars
			node.AddIdentifier(char.ToIdentifier())
		Next
	End Method
	End Rem
	
'#end region Data handling
	
'#region Field accessors
	
	Rem
		bbdoc: Get the character with the given character code.
		returns: The character with the given character code, or Null if the given code was not found.
	End Rem
	Method GetChar:dProtogFontChar(charcode:Int)
		Return dProtogFontChar(m_chars.ForKey(charcode))
	End Method
	
	Rem
		bbdoc: Set the font's name.
		returns: Nothing.
	End Rem
	Method SetName(name:String)
		m_name = name
	End Method
	
	Rem
		bbdoc: Get the font's name.
		returns: The name of the font.
	End Rem
	Method GetName:String()
		Return m_name
	End Method
	
	Rem
		bbdoc: Get the font's height.
		returns: The height of each character in the font.
	End Rem
	Method GetHeight:Float()
		Return m_height
	End Method
	
	Rem
		bbdoc: Set the font's texture.
		returns: Nothing.
	End Rem
	Method SetTexture(texture:dProtogTexture)
		m_texture = texture
	End Method
	
	Rem
		bbdoc: Get the font's texture.
		returns: The font's texture.
	End Rem
	Method GetTexture:dProtogTexture()
		Return m_texture
	End Method
	
'#end region Field accessors
	
'#region Collections
	
	Rem
		bbdoc: Get the font with the given name.
		returns: The font with the given name, or Null if the name given was not found.
	End Rem
	Function GetFontWithName:dProtogFont(name:String)
		Return dProtogFont(m_map._ObjectWithKey(name))
	End Function
	
	Rem
		bbdoc: Remove the font with the name given.
		returns: True if the font with the given name was removed, or False if the name given was not found.
	End Rem
	Function RemoveFontWithName:Int(name:String)
		Return m_map._Remove(name)
	End Function
	
	Rem
		bbdoc: Remove the given font.
		returns: True if the given font was removed, or False if it was not (the given font does not exist in the tracking map).
	End Rem
	Function RemoveFont:Int(font:dProtogFont)
		Return m_map._Remove(font.m_name)
	End Function
	
	Rem
		bbdoc: Check if a font with the given name has been loaded.
		returns: True if there is a font with the given name, or False if the name given was not found.
	End Rem
	Function ContainsFontWithName:Int(name:String)
		Return m_map._Contains(name)
	End Function
	
	Rem
		bbdoc: Check if the given font has been loaded.
		returns: True if the given font was found, or False if the given font was not found.
	End Rem
	Function ContainsFont:Int(font:dProtogFont)
		Return m_map._Contains(font.m_name)
	End Function
	
'#end region Collections
	
End Type

Rem
	bbdoc: Protog font character.
End Rem
Type dProtogFontChar
	
	' "char"/"c" <char> <width> <height> <posx> <posy> <offsety>
	Global m_template:dTemplate = New dTemplate.Create(["char", "c"], [[TV_INTEGER], [TV_FLOAT], [TV_FLOAT], [TV_FLOAT], [TV_FLOAT], [TV_FLOAT]])
	
	Field m_char:Int, m_width:Float, m_height:Float, m_offsety:Float
	Field m_uv:Float[4]
	
	Rem
		bbdoc: Create a char.
		returns: Itself.
	End Rem
	Method Create:dProtogFontChar(char:Int, width:Float)
		m_char = char
		m_width = width
		Return Self
	End Method
	
	Rem
		bbdoc: Render the character at the given position (the texture for the font must already be bound).
		returns: Nothing.
	End Rem
	Method Render(posx:Float, posy:Float)
		glBegin(GL_QUADS)
			glTexCoord2f(m_uv[0], m_uv[1]); glVertex2f(posx, posy + m_offsety)
			glTexCoord2f(m_uv[2], m_uv[1]); glVertex2f(posx + m_width, posy + m_offsety)
			glTexCoord2f(m_uv[2], m_uv[3]); glVertex2f(posx + m_width, posy + m_height + m_offsety)
			glTexCoord2f(m_uv[0], m_uv[3]); glVertex2f(posx, posy + m_height + m_offsety)
		glEnd()
	End Method
	
'#region Data handling
	
	Rem
		bbdoc: Deserialize a char from the given stream.
		returns: The deserialized dProtogFont.
	End Rem
	Method Deserialize:dProtogFontChar(stream:TStream)
		m_char = stream.ReadInt()
		m_width = stream.ReadFloat()
		m_height = stream.ReadFloat()
		m_offsety = stream.ReadFloat()
		m_uv[0] = stream.ReadFloat()
		m_uv[1] = stream.ReadFloat()
		m_uv[2] = stream.ReadFloat()
		m_uv[3] = stream.ReadFloat()
		Return Self
	End Method
	
	Rem
		bbdoc: Serialize the char to the given stream.
		returns: Nothing.
	End Rem
	Method Serialize(stream:TStream)
		stream.WriteInt(m_char)
		stream.WriteFloat(m_width)
		stream.WriteFloat(m_height)
		stream.WriteFloat(m_offsety)
		stream.WriteFloat(m_uv[0])
		stream.WriteFloat(m_uv[1])
		stream.WriteFloat(m_uv[2])
		stream.WriteFloat(m_uv[3])
	End Method
	
	Rem
		bbdoc: Get a char from the given identifier.
		returns: The converted char (itself).
		about: This does not check if the given identifier matches the template (do this elsewhere in the pipeline).
	End Rem
	Method FromIdentifier:dProtogFontChar(iden:dIdentifier, posx:Float Var, posy:Float Var)
		m_char = dIntVariable(iden.GetVariableAtIndex(0)).Get()
		m_width = dFloatVariable(iden.GetVariableAtIndex(1)).Get()
		m_height = dFloatVariable(iden.GetVariableAtIndex(2)).Get()
		posx = dFloatVariable(iden.GetVariableAtIndex(3)).Get()
		posy = dFloatVariable(iden.GetVariableAtIndex(4)).Get()
		m_offsety = dFloatVariable(iden.GetVariableAtIndex(5)).Get()
		Return Self
	End Method
	
	Rem
		bbdoc: Convert the character to an identifier.
		returns: An identifier containing the character's information.
	End Rem
	Method ToIdentifier:dIdentifier(posx:Float, posy:Float)
		Local iden:dIdentifier = New dIdentifier.Create("char")
		iden.AddVariable(New dIntVariable.Create(, m_char))
		iden.AddVariable(New dFloatVariable.Create(, m_width))
		iden.AddVariable(New dFloatVariable.Create(, m_height))
		iden.AddVariable(New dFloatVariable.Create(, posx))
		iden.AddVariable(New dFloatVariable.Create(, posy))
		iden.AddVariable(New dFloatVariable.Create(, m_offsety))
		Return iden
	End Method
	
	Rem
		bbdoc: Check if the given identifier matches the dProtogFontChar template.
		returns: True if the identifier matches, or False if it does not.
	End Rem
	Function ValidateIdentifier:Int(iden:dIdentifier)
		Return m_template.ValidateIdentifier(iden)
	End Function
	
'#end region Data handling
	
	Rem
		bbdoc: Set the UV array by the given parameters.
		returns: Nothing.
	End Rem
	Method SetUV(u0:Float, v0:Float, u1:Float, v1:Float)
		m_uv[0] = u0
		m_uv[1] = v0
		m_uv[2] = u1
		m_uv[3] = v1
	End Method
	
End Type

