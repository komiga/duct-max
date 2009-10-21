
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
	
	entity.bmx (Contains: TProtogEntity, TProtogTextEntity, TProtogSpriteEntity, )
	
	TODO:
		
End Rem

Rem
	bbdoc: Base Protog2D entity.
End Rem
Type TProtogEntity Abstract
	
	Global m_default_pos:TVec2 = New TVec2.Create(0.0, 0.0)
	Global m_default_color:TProtogColor = New TProtogColor.Create()
	
	Field m_pos:TVec2
	Field m_color:TProtogColor
	
	Method New()
	End Method
	
'#region Default values
	
	Rem
		bbdoc: Set the default position for new entities.
		returns: Nothing.
	End Rem
	Function SetDefaultPos(vector:TVec2)
		m_default_pos = vector
	End Function
	
	Rem
		bbdoc: Get the default position for new entities.
		returns: The default entity position vector.
	End Rem
	Function GetDefaultPos:TVec2()
		Return m_default_pos
	End Function
	
	Rem
		bbdoc: Set the default color for new entities.
		returns: Nothing.
	End Rem
	Function SetDefaultColor(color:TProtogColor)
		m_default_color = color
	End Function
	
	Rem
		bbdoc: Get the default color for new entities.
		returns: The default entity color.
	End Rem
	Function GetDefaultColor:TProtogColor()
		Return m_default_color
	End Function
	
'#end region (Default values)
	
'#region Field accessors
	
	Rem
		bbdoc: Set the position vector of the entity.
		returns: Nothing.
	End Rem
	Method SetPosition(vec:TVec2)
		m_pos = vec
	End Method
	
	Rem
		bbdoc: Set the entity's position by the parameters given.
		returns: Nothing.
	End Rem
	Method SetPositionParams(x:Float, y:Float)
		m_pos.Set(x, y)
	End Method
	
	Rem
		bbdoc: Get the entity's position.
		returns: The entity's position vector.
		about: NOTE: The returned value is <b>not</b> a clone of the position vector.
	End Rem
	Method GetPosition:TVec2()
		Return m_pos
	End Method
	
	Rem
		bbdoc: Set the entity's color.
		returns: Nothing.
	End Rem
	Method SetColor(color:TProtogColor)
		m_color = color
	End Method
	
	Rem
		bbdoc: Get the entity's color.
		returns: The entity's color.
		about: NOTE: The returned color is <b>not</b> a clone of the entity's color.
	End Rem
	Method GetColor:TProtogColor()
		Return m_color
	End Method
	
'#end region (Field accessors)
	
'#region Entity function
	
	Rem
		bbdoc: Render the entity.
		returns: Nothing.
	End Rem
	Method Render(bind:Int = True) Abstract
	
	Rem
		bbdoc: Update the entity.
		returns: Nothing.
	End Rem
	Method Update() Abstract
	
'#end region (Entity function)
	
'#region Data handlers
	
	Rem
		bbdoc: Serialize the entity to the given stream.
		returns: Nothing.
	End Rem
	Method Serialize(stream:TStream) Abstract
	
	Rem
		bbdoc: Deserialize the entity from the given stream.
		returns: The deserialized entity.
	End Rem
	Method DeSerialize:TProtogEntity(stream:TStream) Abstract
	
	Rem
		bbdoc: Create a copy of the entity
		returns: A clone of the entity.
	End Rem
	Method Copy:TProtogEntity() Abstract
	
'#end region (Data handlers)
	
End Type

Rem
	bbdoc: Generic Protog2D text entity.
End Rem
Type TProtogTextEntity Extends TProtogEntity
	
	Global m_default_font:TProtogFont
	
	Field m_vcenter:Int, m_hcenter:Int
	Field m_font:TProtogFont
	Field m_text:String, m_replacer:TTextReplacer
	
	Method New()
	End Method
	
	Rem
		bbdoc: Create a new TProtogTextEntity.
		returns: The new TProtogTextEntity (itself).
		about: The default value for @font, @pos and @color will be used if one is Null.
	End Rem
	Method Create:TProtogTextEntity(text:String, font:TProtogFont = Null, pos:TVec2 = Null, color:TProtogColor = Null)
		m_text = text
		
		If font = Null Then m_font = GetDefaultFont() Else m_font = font
		If pos = Null Then m_pos = GetDefaultPos().Copy() Else m_pos = pos
		If color = Null Then m_color = GetDefaultColor().Copy() Else m_color = color
		
		Return Self
	End Method
	
'#region Default values
	
	Rem
		bbdoc: Set the default font for new text entities.
		returns: Nothing.
	End Rem
	Function SetDefaultFont(font:TProtogFont)
		m_default_font = font
	End Function
	
	Rem
		bbdoc: Get the default font for new text entities.
		returns: The default font.
	End Rem
	Function GetDefaultFont:TProtogFont()
		Return m_default_font
	End Function
	
'#end region (Default values)
	
'#region Field accessors
	
	Rem
		bbdoc: Set the entity's text.
		returns: Nothing.
	End Rem
	Method SetText(text:String)
		m_text = text
	End Method
	
	Rem
		bbdoc: Get the entity's text.
		returns: The entity's text.
	End Rem
	Method GetText:String()
		Return m_text
	End Method
	
	Rem
		bbdoc: Set the entity's font.
		returns: Nothing.
	End Rem
	Method SetFont(font:TProtogFont)
		m_font = font
	End Method
	
	Rem
		bbdoc: Get the entity's font.
		returns: The entity's font..
	End Rem
	Method GetFont:TProtogFont()
		Return m_font
	End Method
	
	Rem
		bbdoc: Tell the entity to, or to not, use vertical centering.
		returns: Nothing.
		about: True will turn vertical centering on, False will turn it off.
	End Rem
	Method SetVCentering(vcenter:Int)
		m_vcenter = vcenter
	End Method
	
	Rem
		bbdoc: Get the vertical centering state.
		returns: True if the entity is rendering text vertically centered, or False if it is not.
	End Rem
	Method GetVCentering:Int()
		Return m_vcenter
	End Method
	
	Rem
		bbdoc: Tell the entity to, or to not, use horizontal centering.
		returns: Nothing.
		about: True will turn horizontal centering on, False will turn it off.
	End Rem
	Method SetHCentering(hcenter:Int)
		m_hcenter = hcenter
	End Method
	
	Rem
		bbdoc: Get the horizontal centering state.
		returns: True if the entity is rendering text horizontally centered, or False if it is not.
	End Rem
	Method GetHCentering:Int()
		Return m_hcenter
	End Method
	
'#end region (Field accessors)
	
'#region Replacer
	
	Rem
		bbdoc: Setup/update the replacer.
		returns: Nothing.
		about: This must be called for #SetReplacementByName and #GetReplacementFromName.<br/>
	End Rem
	Method SetupReplacer(autoreplace:Int = True, beginiden:String = "{", endiden:String = "}")
		If m_replacer = Null
			m_replacer = New TTextReplacer
		End If
		
		m_replacer.SetString(m_text)
		If autoreplace = True
			m_replacer.AutoReplacements(beginiden, endiden)
		End If
		
	End Method
	
	Rem
		bbdoc: Set a replacement string by the name of the TTextReplacement (e.g. "FOO" for the '{FOO}' part of the text).
		returns: True if the TTextReplacement value was set, or False if it was not (either could not find the given name or the replacer has not been setup - see #SetupReplacer).
	End Rem
	Method SetReplacementByName:Int(name:String, value:String, casesens:Int = False)
		If m_replacer <> Null
			Return m_replacer.SetReplacementByName(name, value, casesens)
		End If
		Return False
	End Method
	
	Rem
		bbdoc: Get a TTextReplacement by the name given.
		returns: The TTextReplacement with the name given, or Null if either the given name was not found or the replacer has not been setup - see #SetupReplacer.
	End Rem
	Method GetReplacementFromName:TTextReplacement(name:String, casesens:Int = False)
		If m_replacer <> Null
			Return m_replacer.GetReplacementFromName(name, casesens)
		End If
		Return Null
	End Method
	
'#end region (Replacer)
	
'#region Entity function
	
	Rem
		bbdoc: Render the entity.
		returns: Nothing.
		about: @bind does nothing.
	End Rem
	Method Render(bind:Int = True)
		m_color.Bind()
		If m_replacer <> Null
			m_font.DrawStringVec(m_replacer.DoReplacements(), m_pos, m_hcenter, m_vcenter)
		Else
			m_font.DrawStringVec(m_text, m_pos, m_hcenter, m_vcenter)
		End If
	End Method
	
	Rem
		bbdoc: Update the entity.
		returns: Nothing.
	End Rem
	Method Update()
	End Method
	
'#end region (Entity function)
	
'#region Data handlers
	
	Rem
		bbdoc: Serialize the entity to the given stream.
		returns: Nothing.
	End Rem
	Method Serialize(stream:TStream)
		m_pos.Serialize(stream)
		m_color.Serialize(stream)
		WriteLString(stream, m_font.m_name)
		stream.WriteByte(m_vcenter)
		stream.WriteByte(m_hcenter)
		WriteLString(stream, m_text)
	End Method
	
	Rem
		bbdoc: Deserialize the entity from the given stream.
		returns: The deserialized entity.
	End Rem
	Method DeSerialize:TProtogTextEntity(stream:TStream)
		m_pos = New TVec2.DeSerialize(stream)
		m_color = New TProtogColor.DeSerialize(stream)
		m_font = TProtogFont.GetFontFromName(ReadLString(stream))
		m_vcenter = Int(stream.ReadByte())
		m_hcenter = Int(stream.ReadByte())
		m_text = ReadLString(stream)
		Return Self
	End Method
	
	Rem
		bbdoc: Create a copy of the entity
		returns: A clone of the entity.
	End Rem
	Method Copy:TProtogTextEntity()
		Local clone:TProtogTextEntity
		clone = New TProtogTextEntity.Create(m_text, m_font, m_pos.Copy(), m_color.Copy())
		clone.m_vcenter = m_vcenter
		clone.m_hcenter = m_hcenter
		Return clone
	End Method
	
'#end region (Data handlers)
	
End Type

Rem
	bbdoc: Protog2D sprite (texture) entity.
End Rem
Type TProtogSpriteEntity Extends TProtogEntity
	
	Field m_texture:TProtogTexture
	Field m_size:TVec2
	Field m_flipped:Int = False
	
	Method New()
		m_size = New TVec2
	End Method
	
	Rem
		bbdoc: Create a new TProtogSpriteEntity.
		returns: The new TProtogSpriteEntity (itself).
		about: The default value for @pos and @color will be used if one is Null.<br/>
		The default size will be the size of the given texture (if it is not Null).
	End Rem
	Method Create:TProtogSpriteEntity(texture:TProtogTexture, pos:TVec2 = Null, color:TProtogColor = Null)
		SetTexture(texture, True)
		If pos = Null Then m_pos = GetDefaultPos().Copy() Else m_pos = pos
		If color = Null Then m_color = GetDefaultColor().Copy() Else m_color = color
		
		Return Self
	End Method
	
'#region Field accessors
	
	Rem
		bbdoc: Set the size for the sprite.
		returns: Nothing.
		about: @size is <b>not</b> copied.
	End Rem
	Method SetSize(size:TVec2)
		m_size = size
	End Method
	
	Rem
		bbdoc: Set the size for the sprite to the given parameters.
		returns: Nothing.
	End Rem
	Method SetSizeParams(x:Float, y:Float)
		m_size.Set(x, y)
	End Method
	
	Rem
		bbdoc: Set the entity's texture.
		returns: Nothing.
		about: If @updatesize is True, the entity's size will be set to the given texture (or to [128.0, 128.0] if the texture is Null).
	End Rem
	Method SetTexture(texture:TProtogTexture, updatesize:Int = True)
		m_texture = texture
		If updatesize = True
			If m_texture <> Null
				SetSizeParams(m_texture.m_width, m_texture.m_height)
			Else
				SetSizeParams(128.0, 128.0)
			End If
		End If
	End Method
	
	Rem
		bbdoc: Get the sprite's size.
		returns: The sprite's size vector.
		about: The returned value is <b>not</b> a copy of the size vector.
	End Rem
	Method GetSize:TVec2()
		Return m_size
	End Method
	
	Rem
		bbdoc: Turn on or off texture flipping.
		returns: Nothing.
		about: If @flipped is True the texture will be drawn upside-down. If @flipped is False the texture is drawn normally.
	End Rem
	Method SetFlipped(flipped:Int)
		m_flipped = flipped
	End Method
	
'#end region (Field accessors)
	
'#region Entity function
	
	Rem
		bbdoc: Render the entity.
		returns: Nothing.
		about: If @bind is True, the texture will be bound before rendering.
	End Rem
	Method Render(bind:Int = True)
		Local quad:TVec4
		quad = New TVec4.CreateFromVec2(m_pos, m_pos.AddVecNew(m_size))
		
		m_color.Bind()
		If bind = True
			m_texture.Bind()
		End If
		m_texture.Render(quad, m_flipped)
		If bind = True
			m_texture.Unbind()
		End If
	End Method
	
	Rem
		bbdoc: Update the entity.
		returns: Nothing.
	End Rem
	Method Update()
	End Method
	
'#end region (Entity function)
	
'#region Data handlers
	
	Rem
		bbdoc: Serialize the entity to the given stream.
		returns: Nothing.
	End Rem
	Method Serialize(stream:TStream)
	End Method
	
	Rem
		bbdoc: Deserialize the entity from the given stream.
		returns: The deserialized entity.
	End Rem
	Method DeSerialize:TProtogSpriteEntity(stream:TStream)
	End Method
	
	Rem
		bbdoc: Create a copy of the entity
		returns: A clone of the entity.
	End Rem
	Method Copy:TProtogSpriteEntity()
		Local clone:TProtogSpriteEntity
		clone = New TProtogSpriteEntity.Create(m_texture, m_pos, m_color)
		clone.SetFlipped(m_flipped)
		clone.SetSize(m_size.Copy())
		Return clone
	End Method
	
'#end region (Data handlers)
	
End Type

















