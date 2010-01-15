
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
	
	font.bmx (Contains: TProtogFont, TProtogFontChar, )
	
	TODO:
		
	
End Rem

Rem
	bbdoc: Protog single-surface textured font.
End Rem
Type TProtogFont
	
	Global m_template_name:TTemplate = New TTemplate.Create(["name"], [[TV_STRING] ])
	Global m_template_texture:TTemplate = New TTemplate.Create(["texture"], [[TV_STRING] ])
	Global m_template_height:TTemplate = New TTemplate.Create(["height"], [[TV_FLOAT] ])
	
	Global m_map:TObjectMap = New TObjectMap
	
	Field m_name:String, m_height:Float
	Field m_texture:TProtogTexture
	Field m_chars:TIntMap, m_emptychar:TProtogFontChar
	
	Method New()
		m_chars = New TIntMap
	End Method
	
	Method Delete()
		m_chars = Null
	End Method
	
	Method InsertSelf()
		m_map._Insert(m_name, Self)
	End Method
	
'#region Drawing
	
	Rem
		bbdoc: Draw a string on the screen using the font.
		returns: Nothing.
	End Rem
	Method DrawStringVec(str:String, pos:TVec2, hcenter:Int = False, vcenter:Int = False)
		DrawStringParams(str, pos.m_x, pos.m_y, hcenter, vcenter)
	End Method
	
	Rem
		bbdoc: Draw a string on the screen using the font.
		returns: Nothing.
	End Rem
	Method DrawStringParams(str:String, x:Float, y:Float, hcenter:Int = False, vcenter:Int = False)
		Local char:TProtogFontChar, index:Int, charcode:Int
		Local offsetx:Float, offsety:Float, width:Float, height:Float
		Local incx:Float, incy:Float
		
		If str <> Null
			width = StringWidth(str)
			height = StringHeight(str)
			
			If hcenter = True
				offsetx = -(width / 2.0)
			End If
			If vcenter = True
				offsety = -(height / 2.0)
			End If
			
			m_texture.m_gltexture.Bind()
			For index = 0 To str.Length - 1
				charcode = str[index]
				char = GetChar(charcode)
				If charcode = 10
					incx = 0.0
					incy:+m_height
				Else If charcode <> 13 ' Just ignore ~r
					If char = Null
						char = m_emptychar
					End If
					char.Draw(x + offsetx + incx, y + offsety + incy)
					incx:+char.m_width
				End If
			Next
			m_texture.m_gltexture.Unbind()
		End If
	End Method
	
	Rem
		bbdoc: Get the combined pixel-width of the given string (if it were drawn using this font).
		returns: Nothing.
	End Rem
	Method StringWidth:Float(str:String)
		Local char:TProtogFontChar, index:Int, charcode:Int
		Local largestwidth:Float, width:Float
		
		If str <> Null
			For index = 0 To str.Length - 1
				charcode = str[index]
				char = GetChar(charcode)
				If charcode = 10
					If width > largestwidth
						largestwidth = width
					End If
					width = 0.0
				Else If charcode <> 13 ' Just ignore ~r
					If char = Null
						char = m_emptychar
					End If
					width:+char.m_width
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
		returns: The height of the given string (0.0 will be returned if the string is Null).
		about: This really only needs to be used if the given string contains a newline character (if it does not you can simply use the font's height).
	End Rem
	Method StringHeight:Float(str:String)
		Local index:Int, height:Float
		
		If str <> Null
			height = m_height
			For index = 0 To str.Length - 1
				If str[index] = 10
					height:+m_height
				End If
			Next
		End If
		Return height
	End Method
	
'#end region (Drawing)
	
'#region Data handlers
	
	Rem
		bbdoc: Deserialize a font from the given stream.
		returns: The deserialized TProtogFont.
		about: If @readtexture is True, the texture's pixmap will be deserialized from the stream.<br/>
		If @upload is True the texture (if loaded) will be uploaded to OpenGL (the GL texture will be created).<br/>
		If @upload is False you must upload the texture at some point in the future.
	End Rem
	Method DeSerialize:TProtogFont(stream:TStream, readtexture:Int = True, upload:Int = True)
		Local count:Int, index:Int
		Local char:TProtogFontChar
		
		m_name = ReadLString(stream)
		m_height = stream.ReadFloat()
		count = stream.ReadInt()
		
		If readtexture = True
			m_texture = New TProtogTexture.DeSerialize(stream, upload)
		End If
		
		For index = 1 To count
			char = New TProtogFontChar.DeSerialize(stream)
			m_chars.Insert(char.m_char, char)
		Next
		
		m_emptychar = GetChar(- 1)
		InsertSelf()
		
		Return Self
		
	End Method
	
	Rem
		bbdoc: Serialize the font to the given stream.
		returns: Nothing.
		about: If @writetexture is True, the texture's pixmap will be serialized to the stream.
	End Rem
	Method Serialize(stream:TStream, writetexture:Int = True)
		Local char:TProtogFontChar
		
		WriteLString(stream, m_name)
		stream.WriteFloat(m_height)
		stream.WriteInt(m_chars.Count())
		
		If writetexture = True
			m_texture.Serialize(stream)
		End If
		
		For char = EachIn m_chars
			char.Serialize(stream)
		Next
		
	End Method
	
	Rem
		bbdoc: Get a TProtogFont from the given TSNode.
		returns: The converted font (itself), or Null if there was an error (likely that the texture could not be loaded).
		about: If @upload is True the pixmap will be uploaded to OpenGL (creates the GL texture).
	End Rem
	Method FromNode:TProtogFont(root:TSNode, upload:Int = True)
		Local iden:TIdentifier
		Local pixmap:TPixmap, char:TProtogFontChar
		Local texc_width:Float, texc_height:Float, posx:Float, posy:Float
		
		' Doing this here because we want to be sure this is loaded before anything else (the end-user/developer could have this at or near the end of the script)
		iden = root.GetIdentifierByTemplate(m_template_texture)
		If iden <> Null
			Local path:String = TStringVariable(iden.GetValueAtIndex(0)).Get()
			pixmap = LoadPixmap(path)
			Assert pixmap, "(duct.protog2d.TProtogFont.FromNode) Unable to load ~q" + path + "~q"
			m_texture = New TProtogTexture.Create(pixmap, 0, upload)
			texc_width = 1.0 / m_texture.m_width
			texc_height = 1.0 / m_texture.m_height
		Else
			Throw("(duct.protog2d.TProtogFont.FromNode) Unable to find/validate texture identifier in node (needed for calculations)")
		End If
		
		' Another pre-requisite
		iden = root.GetIdentifierByTemplate(m_template_height)
		If iden <> Null
			m_height = TFloatVariable(iden.GetValueAtIndex(0)).Get()
		Else
			Throw("(duct.protog2d.TProtogFont.FromNode) Unable to find/validate font height identifier in node (needed for calculations)")
		End If
		
		For iden = EachIn root.GetChildren()
			'If iden <> Null
				If TProtogFontChar.ValidateIdentifier(iden) = True
					char = New TProtogFontChar.FromIdentifier(iden, posx, posy)
					char.SetUV(posx * texc_width, posy * texc_height, (posx + char.m_width) * texc_width, (posy + char.m_height) * texc_height)
					m_chars.Insert(char.m_char, char)
				Else If m_template_name.ValidateIdentifier(iden) = True
					m_name = TStringVariable(iden.GetValueAtIndex(0)).Get()
				End If
			'End If
		Next
		
		m_emptychar = GetChar(- 1)
		InsertSelf()
		
		Return Self
		
	End Method
	
	Rem
	Method ToNode:TSNode(texture_path:String)
		Local node:TSNode, iden:TIdentifier
		
		node = New TSNode.Create(Null)
		
		iden = New TIdentifier.CreateByData("name")
		iden.AddValue(New TStringVariable.Create(Null, m_name))
		node.AddIdentifier(iden)
		iden = New TIdentifier.CreateByData("texture")
		iden.AddValue(New TStringVariable.Create(Null, texture_path))
		node.AddIdentifier(iden)
		iden = New TIdentifier.CreateByData("height")
		iden.AddValue(New TStringVariable.Create(Null, m_height))
		node.AddIdentifier(iden)
		
		Local char:TProtogFontChar
		For char = EachIn m_chars
			node.AddIdentifier(char.ToIdentifier())
		Next
		
	End Method
	End Rem
	
'#end region (Data handlers)
	
'#region Field accessors
	
	Rem
		bbdoc: Get a character from the given character code.
		returns: The character for the given character code, or Null if the font does not have that character.
	End Rem
	Method GetChar:TProtogFontChar(charcode:Int)
		Return TProtogFontChar(m_chars.ForKey(charcode))
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
	Method SetTexture(texture:TProtogTexture)
		m_texture = texture
	End Method
	
	Rem
		bbdoc: Get the font's texture.
		returns: The texture for the font.
	End Rem
	Method GetTexture:TProtogTexture()
		Return m_texture
	End Method
	
'#end region (Field accessors)
	
'#region Collections
	
	Rem
		bbdoc: Get a font from the name given.
		returns: A TProtogFont which has the given name, or NUll if there was no font found that has the given name.
	End Rem
	Function GetFontFromName:TProtogFont(name:String)
		Return TProtogFont(m_map._ValueByKey(name))
	End Function
	
	Rem
		bbdoc: Remove a font by the name given.
		returns: True if the font with the given name was removed, or False if it was not (no font with the given name exists).
	End Rem
	Function RemoveFontByName:Int(name:String)
		Return m_map._Remove(name)
	End Function
	
	Rem
		bbdoc: Remove the given font from the tracking map.
		returns: True if the given font was removed, or False if it was not (the given font does not exist in the tracking map).
	End Rem
	Function RemoveFont:Int(font:TProtogFont)
		Return m_map._Remove(font.m_name)
	End Function
	
	Rem
		bbdoc: Check if the tracking map contains a font with the name given.
		returns: True if the font exists in the tracking map, or False if it does not.
	End Rem
	Function ContainsFontByName:Int(name:String)
		Return m_map._Contains(name)
	End Function
	
	Rem
		bbdoc: Check if the tracking map contains the given font.
		returns: True if the font exists in the tracking map, or False if it does not.
	End Rem
	Function ContainsFont:Int(font:TProtogFont)
		Return m_map._Contains(font.m_name)
	End Function
	
'#end region (Collections)
	
End Type

Rem
	bbdoc: Protog font character.
End Rem
Type TProtogFontChar
	
	' "char"/"c" <char> <width> <height> <posx> <posy> <offsety>
	Global m_template:TTemplate = New TTemplate.Create(["char", "c"], [[TV_INTEGER], [TV_FLOAT], [TV_FLOAT], [TV_FLOAT], [TV_FLOAT], [TV_FLOAT] ])
	
	Field m_char:Int, m_width:Float, m_height:Float, m_offsety:Float
	Field m_uv:Float[4]
	
	Method New()
	End Method
	
	Method Delete()
	End Method
	
	Rem
		bbdoc: Create a new TProtogFontChar.
		returns: The new TProtogFontChar (itself).
	End Rem
	Method Create:TProtogFontChar(char:Int, width:Float)
		m_char = char
		m_width = width
		Return Self
	End Method
	
	Rem
		bbdoc: Draw the character at the given position (the texture for the font must already be bound).
		returns: Nothing.
	End Rem
	Method Draw(posx:Float, posy:Float)
		glBegin(GL_QUADS)
			glTexCoord2f(m_uv[0], m_uv[1]) ; glVertex2f(posx, posy + m_offsety)
			glTexCoord2f(m_uv[2], m_uv[1]) ; glVertex2f(posx + m_width, posy + m_offsety)
			glTexCoord2f(m_uv[2], m_uv[3]) ; glVertex2f(posx + m_width, posy + m_height + m_offsety)
			glTexCoord2f(m_uv[0], m_uv[3]) ; glVertex2f(posx, posy + m_height + m_offsety)
		glEnd()
	End Method
	
'#region Data handlers
	
	Rem
		bbdoc: Deserialize a char from the given stream.
		returns: The deserialized TProtogFont.
	End Rem
	Method DeSerialize:TProtogFontChar(stream:TStream)
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
	Method FromIdentifier:TProtogFontChar(iden:TIdentifier, posx:Float Var, posy:Float Var)
		m_char = TIntVariable(iden.GetValueAtIndex(0)).Get()
		m_width = TFloatVariable(iden.GetValueAtIndex(1)).Get()
		m_height = TFloatVariable(iden.GetValueAtIndex(2)).Get()
		
		posx = TFloatVariable(iden.GetValueAtIndex(3)).Get()
		posy = TFloatVariable(iden.GetValueAtIndex(4)).Get()
		
		m_offsety = TFloatVariable(iden.GetValueAtIndex(5)).Get()
		
		Return Self
		
	End Method
	
	Rem
		bbdoc: Convert the character to an identifier.
		returns: An identifier containing the character's information.
	End Rem
	Method ToIdentifier:TIdentifier(posx:Float, posy:Float)
		Local iden:TIdentifier
		
		iden = New TIdentifier.CreateByData("char")
		iden.AddValue(New TIntVariable.Create(Null, m_char))
		iden.AddValue(New TFloatVariable.Create(Null, m_width))
		iden.AddValue(New TFloatVariable.Create(Null, m_height))
		iden.AddValue(New TFloatVariable.Create(Null, posx))
		iden.AddValue(New TFloatVariable.Create(Null, posy))
		iden.AddValue(New TFloatVariable.Create(Null, m_offsety))
		Return iden
		
	End Method
	
	Rem
		bbdoc: Check if the given identifier matches the TProtogFontChar template.
		returns: True if the identifier matches, or False if it does not.
	End Rem
	Function ValidateIdentifier:Int(iden:TIdentifier)
		Return m_template.ValidateIdentifier(iden)
	End Function
	
'#end region (Data handlers)
	
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










