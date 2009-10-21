
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
	
	mapenv.bmx (Contains: TMapEnvironment, )
	
End Rem

Rem
	bbdoc: The MapEnvironment type.
End Rem
Type TMapEnvironment
	
	Field m_ambientcolor:TProtogColor
	
	Method New()
		 m_ambientcolor = New TProtogColor.Create(1.0, 1.0, 1.0, 1.0)
	End Method
	
	Rem
		bbdoc: Create a TMapEnvironment.
		returns: The new TMapEnvironment (itself).
	End Rem
	Method Create:TMapEnvironment(ambient_red:Float = 1.0, ambient_green:Float = 1.0, ambient_blue:Float = 1.0)
		SetAmbientColorParams(ambient_red, ambient_green, ambient_blue)
		Return Self
	End Method
	
'#region Field accessors
	
	Rem
		bbdoc: Set the ambient color by the parameters given.
		returns: Nothing.
		about: #UpdateGLLight is called when the color is set.
	End Rem
	Method SetAmbientColorParams(red:Float, green:Float, blue:Float)
		m_ambientcolor.SetColor(red, green, blue)
		UpdateGLLight()
	End Method
	
	Rem
		bbdoc: Set the ambient color.
		returns: Nothing.
		about: NOTE: The given object is not copied.<br/>
		#UpdateGLLight is called when the color is set.
	End Rem
	Method SetAmbientColor(color:TProtogColor)
		m_ambientcolor = color
		UpdateGLLight()
	End Method
	
	Rem
		bbdoc: Get the ambient color.
		returns: Nothing.
		about: NOTE: This is not a clone of the actual object, use with care.
	End Rem
	Method GetAmbientColor:TProtogColor()
		Return m_ambientcolor
	End Method
	
'#end region (Field accessors)
	
	Rem
		bbdoc: Bind the ambient color.
		returns: Nothing.
	End Rem
	Method BindAmbientColor(alpha:Int = True)
		m_ambientcolor.Bind(alpha)
	End Method
	
	Rem
		bbdoc: Update the OpenGL ambient light for TDrawnTiles.
		returns: Nothing.
	End Rem
	Method UpdateGLLight()
		If m_ambientcolor <> Null
			'ambient[0] = ambient_color[0] / 255.0
			'ambient[1] = ambient_color[1] / 255.0
			'ambient[2] = ambient_color[2] / 255.0
			'ambient[3] = 1.0
			'glLightModelfv(GL_LIGHT_MODEL_AMBIENT, ambient)
			
			glLightfv(TTileMap.USING_GL_LIGHT, GL_DIFFUSE, Varptr(m_ambientcolor.m_red))
			
			'glLightfv(TTileMap.USING_GL_LIGHT, GL_DIFFUSE, colors)
			'glLightfv(TTileMap.USING_GL_LIGHT, GL_SPECULAR, colors)
		End If
	End Method
	
End Type










































