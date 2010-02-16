
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
	
	color.bmx (Contains: TProtogColor, )
	
	TODO:
		
End Rem

Rem
	bbdoc: Protog2D color.
End Rem
Type TProtogColor
	
	Rem
		bbdoc: Template for TProtogColor objects.
		about: Format is: color <red> <green> <blue> <alpha>
	End Rem
	Global m_template:TTemplate = New TTemplate.Create(["color"], [[TV_FLOAT], [TV_FLOAT], [TV_FLOAT], [TV_FLOAT] ])
	
	Field m_red:Float, m_green:Float, m_blue:Float
	Field m_alpha:Float
	
	Method New()
		m_red = 1.0
		m_green = 1.0
		m_blue = 1.0
		m_alpha = 1.0
	End Method
	
	Rem
		bbdoc: Create a new TProtogColor.
		returns: The new TProtogColor (itself).
		about: NOTE: If you need the color to be initiated to 1.0, 1.0, 1.0, 1.0, there is no need to call this method (initial values are 1.0).
	End Rem
	Method Create:TProtogColor(red:Float = 1.0, green:Float = 1.0, blue:Float = 1.0, alpha:Float = 1.0)
		SetColor(red, green, blue)
		SetAlpha(alpha)
		Return Self
	End Method
	
'#region Field accessors
	
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
		bbdoc: Set the color from the given TProtogColor.
		returns: Nothing.
		about: If @alpha is True, the alpha value from the given color will be set also.
	End Rem
	Method SetFromColor(color:TProtogColor, alpha:Int = True)
		m_red = color.m_red
		m_green = color.m_green
		m_blue = color.m_blue
		If alpha = True
			m_alpha = color.m_alpha
		End If
	End Method
	
	Rem
		bbdoc: Get the color.
		returns: Nothing (the variables are passed back through the parameters).
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
	
'#end region (Field accessors)
	
'#region OpenGL
	
	Rem
		bbdoc: Bind the color to the OpenGL context.
		returns: Nothing.
		about: If @alpha is True, the color's alpha component will also be bound.
	End Rem
	Method Bind(alpha:Int = True)
		TProtog2DDriver.BindPColor(Self, alpha)
	End Method
	
'#end region (OpenGL)
	
'#region Data handling
	
	Rem
		bbdoc: Deserialize a color from the given stream.
		returns: The deserialized color (itself).
	End Rem
	Method DeSerialize:TProtogColor(stream:TStream)
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
		bbdoc: Convert the color into a TIdentifier.
		returns: The identifier for the color.
	End Rem
	Method ToIdentifier:TIdentifier()
		Local iden:TIdentifier
		iden = New TIdentifier.CreateByData(m_template.m_iden[0])
		iden.AddValue(New TFloatVariable.Create(Null, m_red))
		iden.AddValue(New TFloatVariable.Create(Null, m_green))
		iden.AddValue(New TFloatVariable.Create(Null, m_blue))
		iden.AddValue(New TFloatVariable.Create(Null, m_alpha))
		Return iden
	End Method
	
	Rem
		bbdoc: Convert a TIdentifier to a TProtogColor.
		returns: The TProtogColor for the given identifier (itself).
		about: NOTE: You will need to check yourself if the given identifier matches the TProtogColor's template (see #ValidateIdentifier).
	End Rem
	Method FromIdentifier:TProtogColor(iden:TIdentifier)
		m_red = TFloatVariable(iden.GetValueAtIndex(0)).Get()
		m_green = TFloatVariable(iden.GetValueAtIndex(1)).Get()
		m_blue = TFloatVariable(iden.GetValueAtIndex(2)).Get()
		m_alpha = TFloatVariable(iden.GetValueAtIndex(3)).Get()
		Return Self
	End Method
	
	Rem
		bbdoc: Try to validate the given identifier against the TProtogColor's template.
		returns: True if the given identifier matches the template, or False if it does not.
	End Rem
	Method ValidateIdentifier:Int(iden:TIdentifier)
		Return m_template.ValidateIdentifier(iden)
	End Method
	
	Rem
		bbdoc: Create a clone of the color.
		returns: A clone of the color.
	End Rem
	Method Copy:TProtogColor()
		Local clone:TProtogColor
		clone = New TProtogColor.Create(m_red, m_green, m_blue, m_alpha)
		Return clone
	End Method
	
'#end region (Data handling)
	
End Type

