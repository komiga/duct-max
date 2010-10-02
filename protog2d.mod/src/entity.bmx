
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
	bbdoc: Base Protog2D entity.
	about: NOTE: This type is abstract.
End Rem
Type dProtogEntity Abstract
	
	Global m_default_pos:dVec2 = New dVec2.Create(0.0, 0.0)
	Global m_default_color:dProtogColor = New dProtogColor.Create()
	
	Field m_pos:dVec2
	Field m_color:dProtogColor
	
'#region Default values
	
	Rem
		bbdoc: Set the default position for new entities.
		returns: Nothing.
	End Rem
	Function SetDefaultPos(vector:dVec2)
		m_default_pos = vector
	End Function
	
	Rem
		bbdoc: Get the default position for new entities.
		returns: The default entity position vector.
	End Rem
	Function GetDefaultPos:dVec2()
		Return m_default_pos
	End Function
	
	Rem
		bbdoc: Set the default color for new entities.
		returns: Nothing.
	End Rem
	Function SetDefaultColor(color:dProtogColor)
		m_default_color = color
	End Function
	
	Rem
		bbdoc: Get the default color for new entities.
		returns: The default entity color.
	End Rem
	Function GetDefaultColor:dProtogColor()
		Return m_default_color
	End Function
	
'#end region Default values
	
'#region Field accessors
	
	Rem
		bbdoc: Set the position vector of the entity.
		returns: Nothing.
	End Rem
	Method SetPosition(vec:dVec2)
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
	Method GetPosition:dVec2()
		Return m_pos
	End Method
	
	Rem
		bbdoc: Set the entity's color.
		returns: Nothing.
	End Rem
	Method SetColor(color:dProtogColor)
		m_color = color
	End Method
	
	Rem
		bbdoc: Get the entity's color.
		returns: The entity's color.
		about: NOTE: The returned color is <b>not</b> a clone of the entity's color.
	End Rem
	Method GetColor:dProtogColor()
		Return m_color
	End Method
	
'#end region Field accessors
	
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
	
'#end region Entity function
	
'#region Data handling
	
	Rem
		bbdoc: Serialize the entity to the given stream.
		returns: Nothing.
	End Rem
	Method Serialize(stream:TStream) Abstract
	
	Rem
		bbdoc: Deserialize the entity from the given stream.
		returns: The deserialized entity.
	End Rem
	Method Deserialize:dProtogEntity(stream:TStream) Abstract
	
	Rem
		bbdoc: Create a copy of the entity
		returns: A clone of the entity.
	End Rem
	Method Copy:dProtogEntity() Abstract
	
'#end region Data handling
	
End Type

Rem
	bbdoc: Generic Protog2D text entity.
End Rem
Type dProtogTextEntity Extends dProtogEntity
	
	Global m_default_font:dProtogFont
	
	Field m_vcenter:Int, m_hcenter:Int
	Field m_font:dProtogFont
	Field m_text:String, m_replacer:dTextReplacer
	
	Rem
		bbdoc: Create a new text entity.
		returns: Itself.
		about: The default value for @font, @pos and @color will be used if one is Null.
	End Rem
	Method Create:dProtogTextEntity(text:String, font:dProtogFont = Null, pos:dVec2 = Null, color:dProtogColor = Null)
		SetText(text)
		If Not font Then m_font = GetDefaultFont() Else SetFont(font)
		If Not pos Then m_pos = GetDefaultPos().Copy() Else SetPosition(pos)
		If Not color Then m_color = GetDefaultColor().Copy() Else SetColor(color)
		Return Self
	End Method
	
'#region Default values
	
	Rem
		bbdoc: Set the default font for new text entities.
		returns: Nothing.
	End Rem
	Function SetDefaultFont(font:dProtogFont)
		m_default_font = font
	End Function
	
	Rem
		bbdoc: Get the default font for new text entities.
		returns: The default font.
	End Rem
	Function GetDefaultFont:dProtogFont()
		Return m_default_font
	End Function
	
'#end region Default values
	
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
	Method SetFont(font:dProtogFont)
		m_font = font
	End Method
	
	Rem
		bbdoc: Get the entity's font.
		returns: The entity's font..
	End Rem
	Method GetFont:dProtogFont()
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
	
'#end region Field accessors
	
'#region Replacer
	
	Rem
		bbdoc: Setup/update the replacer.
		returns: Nothing.
		about: This must be called for #SetReplacementsWithName and #GetReplacementWithName.
	End Rem
	Method SetupReplacer(autoreplace:Int = True, beginiden:String = "{", endiden:String = "}")
		If Not m_replacer
			m_replacer = New dTextReplacer
		End If
		m_replacer.SetString(m_text)
		If autoreplace = True
			m_replacer.AutoReplacements(beginiden, endiden)
		End If
	End Method
	
	Rem
		bbdoc: Set a replacement string by the name of the dTextReplacement (e.g. "FOO" for the '{FOO}' part of the text).
		returns: True if the dTextReplacement value was set, or False if it was not (either could not find the given name or the replacer has not been setup - see #SetupReplacer).
	End Rem
	Method SetReplacementsWithName:Int(name:String, value:String, casesens:Int = False)
		If m_replacer
			Return m_replacer.SetReplacementsWithName(name, value, casesens)
		End If
		Return False
	End Method
	
	Rem
		bbdoc: Get a dTextReplacement by the name given.
		returns: The dTextReplacement with the name given, or Null if either the given name was not found or the replacer has not been setup - see #SetupReplacer.
	End Rem
	Method GetReplacementWithName:dTextReplacement(name:String, casesens:Int = False)
		If m_replacer
			Return m_replacer.GetReplacementWithName(name, casesens)
		End If
		Return Null
	End Method
	
'#end region Replacer
	
'#region Entity function
	
	Rem
		bbdoc: Render the entity.
		returns: Nothing.
		about: @bind does nothing.
	End Rem
	Method Render(bind:Int = True)
		m_color.Bind()
		If m_replacer
			m_font.RenderStringVec(m_replacer.DoReplacements(), m_pos, m_hcenter, m_vcenter)
		Else
			m_font.RenderStringVec(m_text, m_pos, m_hcenter, m_vcenter)
		End If
	End Method
	
	Rem
		bbdoc: Update the entity.
		returns: Nothing.
	End Rem
	Method Update()
	End Method
	
'#end region Entity function
	
'#region Data handling
	
	Rem
		bbdoc: Serialize the entity to the given stream.
		returns: Nothing.
	End Rem
	Method Serialize(stream:TStream)
		m_pos.Serialize(stream)
		m_color.Serialize(stream)
		dStreamIO.WriteLString(stream, m_font.m_name)
		stream.WriteByte(m_vcenter)
		stream.WriteByte(m_hcenter)
		dStreamIO.WriteLString(stream, m_text)
	End Method
	
	Rem
		bbdoc: Deserialize the entity from the given stream.
		returns: The deserialized entity.
	End Rem
	Method Deserialize:dProtogTextEntity(stream:TStream)
		m_pos = New dVec2.Deserialize(stream)
		m_color = New dProtogColor.Deserialize(stream)
		m_font = dProtogFont.GetFontFromName(dStreamIO.ReadLString(stream))
		m_vcenter = Int(stream.ReadByte())
		m_hcenter = Int(stream.ReadByte())
		m_text = dStreamIO.ReadLString(stream)
		Return Self
	End Method
	
	Rem
		bbdoc: Create a copy of the entity
		returns: A clone of the entity.
	End Rem
	Method Copy:dProtogTextEntity()
		Local clone:dProtogTextEntity = New dProtogTextEntity.Create(m_text, m_font, m_pos.Copy(), m_color.Copy())
		clone.m_vcenter = m_vcenter
		clone.m_hcenter = m_hcenter
		Return clone
	End Method
	
'#end region Data handling
	
End Type

Rem
	bbdoc: Protog2D sprite (texture) entity.
End Rem
Type dProtogSpriteEntity Extends dProtogEntity
	
	Field m_texture:dProtogTexture
	Field m_size:dVec2
	Field m_flipped:Int = False
	
	Method New()
		m_size = New dVec2
	End Method
	
	Rem
		bbdoc: Create a new sprite entity.
		returns: Itself.
		about: The default value for @pos and @color will be used if one is Null.<br>
		The default size will be the size of the given texture (if it is not Null).
	End Rem
	Method Create:dProtogSpriteEntity(texture:dProtogTexture, pos:dVec2 = Null, color:dProtogColor = Null)
		SetTexture(texture, True)
		If pos = Null Then m_pos = GetDefaultPos().Copy() Else SetPosition(pos)
		If color = Null Then m_color = GetDefaultColor().Copy() Else SetColor(color)
		Return Self
	End Method
	
'#region Field accessors
	
	Rem
		bbdoc: Set the size for the sprite.
		returns: Nothing.
		about: @size is <b>not</b> copied.
	End Rem
	Method SetSize(size:dVec2)
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
	Method SetTexture(texture:dProtogTexture, updatesize:Int = True)
		m_texture = texture
		If updatesize = True
			If m_texture
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
	Method GetSize:dVec2()
		Return m_size
	End Method
	
	Rem
		bbdoc: Turn on or off texture flipping.
		returns: Nothing.
		about: If @flipped is True the texture will be rendered upside-down. If @flipped is False the texture is rendered normally.
	End Rem
	Method SetFlipped(flipped:Int)
		m_flipped = flipped
	End Method
	
'#end region Field accessors
	
'#region Entity function
	
	Rem
		bbdoc: Render the entity.
		returns: Nothing.
		about: If @bind is True, the texture will be bound before rendering.
	End Rem
	Method Render(bind:Int = True)
		Local quad:dVec4 = New dVec4.CreateFromVec2(m_pos, m_pos.AddVecNew(m_size))
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
	
'#end region Entity function
	
'#region Data handling
	
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
	Method Deserialize:dProtogSpriteEntity(stream:TStream)
	End Method
	
	Rem
		bbdoc: Create a copy of the entity
		returns: A clone of the entity.
	End Rem
	Method Copy:dProtogSpriteEntity()
		Local clone:dProtogSpriteEntity
		clone = New dProtogSpriteEntity.Create(m_texture, m_pos, m_color)
		clone.SetFlipped(m_flipped)
		clone.SetSize(m_size.Copy())
		Return clone
	End Method
	
'#end region Data handling
	
End Type

