
' Copyright (c) 2009 Tim Howard
' 
' Permission is hereby granted, free of charge, to any person obtaining a copy
' of this software and associated documentation files (the "Software"), to deal
' in the Software without restriction, including without limitation the rights
' to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
' copies of the Software, and to permit persons to whom the Software is
' furnished to do so, subject to the following conditions:
' 
' The above copyright notice and this permission notice shall be included in
' all copies or substantial portions of the Software.
' 
' THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
' IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
' FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
' AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
' LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
' OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
' THE SOFTWARE.
' 

' 
' mapenv.bmx (Contains: TMapEnvironment, )
' 
' 

Rem
	bbdoc: The map environment type.
End Rem
Type TMapEnvironment
	
	Field amb_color:Int[3], light:TVec3
		
		Method New()
			
			amb_color = New Int[3]
			light = New TVec3.Create(1 / Sqr(3), - 1 / Sqr(3), 1.0)
			
		End Method
		
		Rem
			bbdoc: Create a map environment
			returns: The created map environment (itself).
		End Rem
		Method Create:TMapEnvironment(ambient_r:Int, ambient_g:Int, ambient_b:Int)
			
			SetAmbientColor(ambient_r, ambient_g, ambient_b)
			
			Return Self
			
		End Method
		
		Rem
			bbdoc: Set the ambient color for the environment.
			returns: Nothing.
		End Rem
		Method SetAmbientColor(_r:Int, _g:Int, _b:Int)
			
			amb_color[0] = _r
			amb_color[1] = _g
			amb_color[2] = _b
			
		End Method
		
		Rem
			bbdoc: Get the environment's light vector.
			returns: The light vector for this environment.
		End Rem
		Method GetLightVector:tvec3()
			
			Return light
			
		End Method
		
End Type










































