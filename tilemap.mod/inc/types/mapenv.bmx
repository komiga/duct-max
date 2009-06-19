
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
	
	Field m_amb_color:Int[3], m_light:TVec3
		
		Method New()
			
			m_amb_color = New Int[3]
			m_light = New TVec3.Create(1 / Sqr(3), - 1 / Sqr(3), 1.0)
			
		End Method
		
		Rem
			bbdoc: Create a new MapEnvironment
			returns: The new MapEnvironment (itself).
		End Rem
		Method Create:TMapEnvironment(ambient_r:Int, ambient_g:Int, ambient_b:Int)
			
			SetAmbientColor(ambient_r, ambient_g, ambient_b)
			
			Return Self
			
		End Method
		
		'#region Field accessors
		
		Rem
			bbdoc: Set the ambient color for the environment.
			returns: Nothing.
		End Rem
		Method SetAmbientColor(r:Int, g:Int, b:Int)
			
			m_amb_color[0] = r
			m_amb_color[1] = g
			m_amb_color[2] = b
			
			UpdateGLLight(m_amb_color)
			
		End Method
		
		Rem
			bbdoc: Get the environment's light vector.
			returns: The light vector (global light position) for the environment.
		End Rem
		Method GetLightVector:TVec3()
			
			Return m_light
			
		End Method
		
		'#end region (Field accessors)
		
		Rem
			bbdoc: Set the drawing color to the MapEnvironment's ambient color.
			returns: Nothing.
		End Rem
		Method SetDrawingColorAmbient()
			
			SetColor(m_amb_color[0], m_amb_color[1], m_amb_color[2])
			
		End Method
		
		Function UpdateGLLight(ambient_color:Int[])
			Local colors:Float[4]
			
			'ambient[0] = ambient_color[0] / 255.0
			'ambient[1] = ambient_color[1] / 255.0
			'ambient[2] = ambient_color[2] / 255.0
			'ambient[3] = 1.0
			'glLightModelfv(GL_LIGHT_MODEL_AMBIENT, ambient)
			
			colors[0] = ambient_color[0] / 255.0 * 2.0
			colors[1] = ambient_color[1] / 255.0 * 2.0
			colors[2] = ambient_color[2] / 255.0 * 2.0
			colors[3] = 1.0
			
			DebugLog(colors[0] + ", " + colors[1] + ", " + colors[2])
			
			glLightfv(TTileMap.USING_GL_LIGHT, GL_AMBIENT, colors)
			
			'glLightfv(TTileMap.USING_GL_LIGHT, GL_DIFFUSE, colors)
			'glLightfv(TTileMap.USING_GL_LIGHT, GL_SPECULAR, colors)
			
		End Function
		
End Type










































