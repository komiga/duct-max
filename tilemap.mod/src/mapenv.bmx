
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
	bbdoc: #dTileMap environment.
End Rem
Type dMapEnvironment
	
	Field m_ambientcolor:dProtogColor
	
	Method New()
		 m_ambientcolor = New dProtogColor.Create(1.0, 1.0, 1.0, 1.0)
	End Method
	
	Rem
		bbdoc: Create a dMapEnvironment.
		returns: Itself.
	End Rem
	Method Create:dMapEnvironment(ambient_red:Float = 1.0, ambient_green:Float = 1.0, ambient_blue:Float = 1.0, ambient_alpha:Float = 1.0)
		SetAmbientColorParams(ambient_red, ambient_green, ambient_blue, ambient_alpha)
		Return Self
	End Method
	
'#region Field accessors
	
	Rem
		bbdoc: Set the ambient color by the parameters given.
		returns: Nothing.
		about: #UpdateGLLight is called when the color is set.
	End Rem
	Method SetAmbientColorParams(red:Float, green:Float, blue:Float, ambient_alpha:Float = 1.0)
		m_ambientcolor.Set(red, green, blue, ambient_alpha)
		UpdateGLLight()
	End Method
	
	Rem
		bbdoc: Set the ambient color.
		returns: Nothing.
		about: NOTE: The given object is not copied.<br>
		#UpdateGLLight is called when the color is set.
	End Rem
	Method SetAmbientColor(color:dProtogColor)
		m_ambientcolor = color
		UpdateGLLight()
	End Method
	
	Rem
		bbdoc: Get the ambient color.
		returns: Nothing.
		about: NOTE: This is not a clone of the actual object, use with care.
	End Rem
	Method GetAmbientColor:dProtogColor()
		Return m_ambientcolor
	End Method
	
'#end region Field accessors
	
	Rem
		bbdoc: Bind the ambient color.
		returns: Nothing.
	End Rem
	Method BindAmbientColor(alpha:Int = True)
		m_ambientcolor.Bind(alpha)
	End Method
	
	Rem
		bbdoc: Update the OpenGL ambient light for drawn tiles.
		returns: Nothing.
	End Rem
	Method UpdateGLLight()
		If m_ambientcolor
			glLightfv(dTileMap.USING_GL_LIGHT, GL_AMBIENT, Varptr(m_ambientcolor.m_red))
			'glLightfv(dTileMap.USING_GL_LIGHT, GL_SPECULAR, Varptr(m_ambientcolor.m_red))
		End If
	End Method
	
End Type

