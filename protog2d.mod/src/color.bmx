
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

Rem
	bbdoc: Protog2D color.
End Rem
Type dProtogColor
	
	Rem
		bbdoc: Template for #dProtogColor.
		about: Format is: color <red> <green> <blue> <alpha>
	End Rem
	Global m_template:dTemplate = New dTemplate.Create(["color"], [[TV_FLOAT], [TV_FLOAT], [TV_FLOAT], [TV_FLOAT]])
	
	Field m_red:Float, m_green:Float, m_blue:Float
	Field m_alpha:Float
	
	Method New()
		m_red = 1.0
		m_green = 1.0
		m_blue = 1.0
		m_alpha = 1.0
	End Method
	
	Rem
		bbdoc: Create a new color.
		returns: Itself.
		about: NOTE: If you need the color to be initiated to 1.0, 1.0, 1.0, 1.0, there is no need to call this method (initial values are 1.0).
	End Rem
	Method Create:dProtogColor(red:Float = 1.0, green:Float = 1.0, blue:Float = 1.0, alpha:Float = 1.0)
		SetColor(red, green, blue)
		SetAlpha(alpha)
		Return Self
	End Method
	
'#region Field accessors
	
	Rem
		bbdoc: Set the color and alpha.
		returns: Nothing.
	End Rem
	Method Set(red:Float, green:Float, blue:Float, alpha:Float)
		m_red = red
		m_green = green
		m_blue = blue
		m_alpha = alpha
	End Method
	
	Rem
		bbdoc: Set the color.
		returns: Nothing.
	End Rem
	Method SetColor(red:Float, green:Float, blue:Float)
		m_red = red
		m_green = green
		m_blue = blue
	End Method
	
	Rem
		bbdoc: Set the color from the given color.
		returns: Nothing.
		about: If @alpha is True, the alpha value from the given color will also be taken.
	End Rem
	Method SetFromColor(color:dProtogColor, alpha:Int = True)
		m_red = color.m_red
		m_green = color.m_green
		m_blue = color.m_blue
		If alpha = True
			m_alpha = color.m_alpha
		End If
	End Method
	
	Rem
		bbdoc: Get the color and alpha.
		returns: Nothing (the given parameters are set).
	End Rem
	Method Get(red:Float Var, green:Float Var, blue:Float Var, alpha:Float Var)
		red = m_red
		green = m_green
		blue = m_blue
		alpha = m_alpha
	End Method
	
	Rem
		bbdoc: Get the color.
		returns: Nothing (the given parameters are set).
	End Rem
	Method GetColor(red:Float Var, green:Float Var, blue:Float Var)
		red = m_red
		green = m_green
		blue = m_blue
	End Method
	
	Rem
		bbdoc: Set the alpha.
		returns: Nothing.
	End Rem
	Method SetAlpha(alpha:Float)
		m_alpha = alpha
	End Method
	
	Rem
		bbdoc: Get the alpha.
		returns: The alpha component of the color.
	End Rem
	Method GetAlpha:Float()
		Return m_alpha
	End Method
	
'#end region Field accessors
	
'#region OpenGL
	
	Rem
		bbdoc: Bind the color to the OpenGL context.
		returns: Nothing.
		about: If @alpha is True, the color's alpha component will also be bound.
	End Rem
	Method Bind(alpha:Int = True)
		dProtog2DDriver.BindPColor(Self, alpha)
	End Method
	
'#end region OpenGL
	
'#region Data handling
	
	Rem
		bbdoc: Deserialize a color from the given stream.
		returns: The deserialized color (itself).
	End Rem
	Method Deserialize:dProtogColor(stream:TStream)
		m_red = stream.ReadFloat()
		m_green = stream.ReadFloat()
		m_blue = stream.ReadFloat()
		m_alpha = stream.ReadFloat()
		Return Self
	End Method
	
	Rem
		bbdoc: Serialize the color to the given stream.
		returns: Nothing.
	End Rem
	Method Serialize(stream:TStream)
		stream.WriteFloat(m_red)
		stream.WriteFloat(m_green)
		stream.WriteFloat(m_blue)
		stream.WriteFloat(m_alpha)
	End Method
	
	Rem
		bbdoc: Convert the color into an identifier.
		returns: The identifier for the color.
	End Rem
	Method ToIdentifier:dIdentifier()
		Local iden:dIdentifier = New dIdentifier.Create(m_template.m_iden[0])
		iden.AddVariable(New dFloatVariable.Create(, m_red))
		iden.AddVariable(New dFloatVariable.Create(, m_green))
		iden.AddVariable(New dFloatVariable.Create(, m_blue))
		iden.AddVariable(New dFloatVariable.Create(, m_alpha))
		Return iden
	End Method
	
	Rem
		bbdoc: Convert the given identifier to a color.
		returns: The dProtogColor for the given identifier (itself).
		about: NOTE: You will need to check yourself if the given identifier matches the dProtogColor template (see #ValidateIdentifier).
	End Rem
	Method FromIdentifier:dProtogColor(iden:dIdentifier)
		m_red = dFloatVariable(iden.GetVariableAtIndex(0)).Get()
		m_green = dFloatVariable(iden.GetVariableAtIndex(1)).Get()
		m_blue = dFloatVariable(iden.GetVariableAtIndex(2)).Get()
		m_alpha = dFloatVariable(iden.GetVariableAtIndex(3)).Get()
		Return Self
	End Method
	
	Rem
		bbdoc: Try to validate the given identifier against the color's template.
		returns: True if the given identifier matches the template, or False if it does not.
	End Rem
	Method ValidateIdentifier:Int(iden:dIdentifier)
		Return m_template.ValidateIdentifier(iden)
	End Method
	
	Rem
		bbdoc: Create a clone of the color.
		returns: A clone of the color.
	End Rem
	Method Copy:dProtogColor()
		Local clone:dProtogColor = New dProtogColor.Create(m_red, m_green, m_blue, m_alpha)
		Return clone
	End Method
	
'#end region Data handling
	
End Type

