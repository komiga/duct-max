
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
' vec3.bmx (Contains: TVec3, )
' 
' 

Rem
	bbdoc: The 3d (x, y & z) vector module.
End Rem
Type TVec3
	
	Field x:Float, y:Float, z:Float
		
		Rem
			bbdoc: Create a 3d vector.
			returns: The created vector (itself).
		End Rem
		Method Create:TVec3(_x:Float, _y:Float, _z:Float)
			
			x = _x
			y = _y
			z = _z
			
			Return Self
			
		End Method
		
		Rem
			bbdoc: Get a copy of this vector.
			returns: A clone of this vector.
		End Rem
		Method Copy:TVec3()
			
			Return New TVec3.Create(x, y, z)
			
		End Method
		
		Rem
			bbdoc: Get the vector's values.
			returns: Nothing. @_x, @_y and @_z will contain the values of the vector.
		End Rem
		Method Get(_x:Float Var, _y:Float Var, _z:Float Var)
			
			_x = x
			_y = y
			_z = z
			
		End Method
		
		Rem
			bbdoc: Set the vector's values.
			returns: Nothing.
		End Rem
		Method Set(_x:Float, _y:Float, _z:Float)
			
			x = _x
			y = _y
			z = _z
			
		End Method
		
		Rem
			bbdoc: Get the vector's angle.
			returns: The angle of the vector.
		End Rem
		Method GetAngle:Float()
			
			Return ATan2(y, Sqr(x * x + z * z))
			
		End Method
		
		Rem
			bbdoc: Add the given values to this vector.
			returns: Nothing.
		End Rem
		Method Add(_x:Float, _y:Float, _z:Float)
			
			x:+_x
			y:+_y
			z:+_z
			
		End Method
		
		Rem
			bbdoc: Add the given vector to this vector.
			returns: Nothing.
		End Rem
		Method AddVec(vec:TVec3)
			If vec = Null Return
			
			x:+vec.x
			y:+vec.y
			z:+vec.z
			
		End Method
		
		Rem
			bbdoc: Subtract this vector by the values given.
			returns: Nothing.
		End Rem
		Method Subtract(_x:Float, _y:Float, _z:Float)
			
			x:-_x
			y:-_y
			z:-_z
			
		End Method
		
		Rem
			bbdoc: Subtract this vector by another vector.
			returns: Nothing.
		End Rem
		Method SubtractVec(vec:TVec3)
			If vec = Null Return
			
			x:-vec.x
			y:-vec.y
			z:-vec.z
			
		End Method
		
		Rem
			bbdoc: Multiply this vector by the values given.
			returns: Nothing.
		End Rem
		Method Multiply(_x:Float, _y:Float, _z:Float)
			
			x:*_x
			y:*_y
			z:*_z
			
		End Method
		
		Rem
			bbdoc: Multiply this vector by another vector.
			returns: Nothing.
		End Rem
		Method MultiplyVec(vec:TVec3)
			If vec = Null Return
			
			x:*vec.x
			y:*vec.y
			z:*vec.z
			
		End Method
		
		Rem
			bbdoc: Divide this vector by the values given.
			returns: Nothing.
			about: This does check if the divisors are zero.
		End Rem
		Method Divide(_x:Float, _y:Float, _z:Float)
			
			If _x <> 0 And _y <> 0 And _z <> 0
				x:/_x
				y:/_y
				z:/_z
			End If
			
		End Method
		
		Rem
			bbdoc: Divide this vector by another vector.
			returns: Nothing.
			about: This does check if the given vector's values are zero.
		End Rem
		Method DivideVec(vec:TVec3)
			If vec = Null Return
			
			If vec.x <> 0 And vec.y <> 0 And vec.z <> 0
				x:/vec.x
				y:/vec.y
				z:/vec.z
			End If
			
		End Method
		
		Rem
			bbdoc: Get the dot product of this vector and the vector given.
			returns: The dot product of the two vectors.
		End Rem
		Method DotProduct:Float(vec:TVec3)
			
			Return x * vec.x + y * vec.y + z * vec.z
			
		End Method
		
		Rem
			bbdoc: Get this vector reflected upon another.
			returns: A new vector that is the result of this vector reflecting off the given vector.
		End Rem
		Method Reflected:TVec3(vec:TVec3)
			Local vecn:TVec3 = vec.Normalized()
			Local vec1:TVec3 = Copy()
			Local vecn_DOT_vec1:Float = vecn.DotProduct(vec1)
			
			vecn.Multiply(2 * vecn_DOT_vec1, 2 * vecn_DOT_vec1, 2 * vecn_DOT_vec1)
			
			vec1.SubtractVec(vecn)
			
			Return vec1
			
		End Method
		
		Rem
			bbdoc: Get a normalized vector of this vector.
			returns: This vector normalized.
			about: See also #Normalize.
		End Rem
		Method Normalized:TVec3() 
			Local vector:TVec3 = Copy()
			
			vector.Normalize()
			
			Return vector
			
		End Method
		
		Rem
			bbdoc: Normalize this vector.
			returns: Nothing.
		End Rem
		Method Normalize() 
			Local magn:Float = GetMagnitude()
			
			If magn <> 0
				
				x:/magn
				y:/magn
				z:/magn
				
			End If
			
		End Method
		
		Rem
			bbdoc: Get the length (magnitude) of the vector.
			returns: The magnitude of the vector.
		End Rem
		Method GetMagnitude:Float()
			
			Return Sqr(x * x + y * y + z * z)
			
		End Method
		
		
		Rem
			bbdoc: Cross multiply two vectors.
			returns: The cross product of the two given vectors.
		End Rem
		Function CrossProduct:TVec3( vec1:TVec3, vec2:TVec3 )
			
			Return New TVec3.Create(vec1.y * vec2.z - vec1.z * vec2.y, vec1.z * vec2.x - vec1.x * vec2.z, vec1.x * vec2.y - vec1.y * vec2.x)
			
		End Function
		
End Type




































