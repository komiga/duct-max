
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
' vec2.bmx (Contains: TVec2, )
' 
' 

Rem
	bbdoc: The 2d (x & y) vector module.
End Rem
Type TVec2
	
	Field x:Float, y:Float
		
		Rem
			bbdoc: Create a 2d vector.
			returns: The created vector (itself).
		End Rem
		Method Create:TVec2(_x:Float, _y:Float)
			
			x = _x
			y = _y
			
			Return Self
			
		End Method
		
		Rem
			bbdoc: Get a copy of this vector.
			returns: A clone of this vector.
		End Rem
		Method Copy:TVec2()
			
			Return New TVec2.Create(x, y)
			
		End Method
		
		Rem
			bbdoc: Get the vector's values.
			returns: Nothing. @_x and @_y will contain the values of the vector.
		End Rem
		Method Get(_x:Float Var, _y:Float Var)
			
			_x = x
			_y = y
			
		End Method
		
		Rem
			bbdoc: Set the vector's values.
			returns: Nothing.
		End Rem
		Method Set(_x:Float, _y:Float)
			
			x = _x
			y = _y
			
		End Method
		
		Rem
			bbdoc: Get the vector's angle.
			returns: The angle of the vector.
		End Rem
		Method GetAngle:Float()
			
			Return ATan2(y, x)
			
		End Method
		
		Rem
			bbdoc: Rotate the vector to an angle.
			returns: Nothing.
		End Rem
		Method Rotate(ang:Float)
			Local xprime:Float = Cos(ang) * x - Sin(ang) * y
			Local yprime:Float = Sin(ang) * x + Cos(ang) * y
			
			x = xprime
			y = yprime
			
		End Method
		
		Rem
			bbdoc: Add the given values to this vector.
			returns: Nothing.
		End Rem
		Method Add(_x:Float, _y:Float)
			
			x:+_x
			y:+_y
			
		End Method
		
		Rem
			bbdoc: Add the given vector to this vector.
			returns: Nothing.
		End Rem
		Method AddVec(vec:TVec2)
			If vec = Null Return
			
			x:+vec.x
			y:+vec.y
			
		End Method
		
		Rem
			bbdoc: Subtract this vector by the values given.
			returns: Nothing.
		End Rem
		Method Subtract(_x:Float, _y:Float)
			
			x:-_x
			y:-_y
			
		End Method
		
		Rem
			bbdoc: Subtract this vector by another vector.
			returns: Nothing.
		End Rem
		Method SubtractVec(vec:TVec2)
			If vec = Null Return
			
			x:-vec.x
			y:-vec.y
			
		End Method
		
		Rem
			bbdoc: Multiply this vector by the values given.
			returns: Nothing.
		End Rem
		Method Multiply(_x:Float, _y:Float)
			
			x:*_x
			y:*_y
			
		End Method
		
		Rem
			bbdoc: Multiply this vector by another vector.
			returns: Nothing.
		End Rem
		Method MultiplyVec(vec:TVec2)
			If vec = Null Return
			
			x:*vec.x
			y:*vec.y
			
		End Method
		
		Rem
			bbdoc: Divide this vector by the values given.
			returns: Nothing.
			about: This does check if the divisors are zero.
		End Rem
		Method Divide(_x:Float, _y:Float)
			
			If x <> 0 And y <> 0
				x:/_x
				y:/_y
			End If
			
		End Method
		
		Rem
			bbdoc: Divide this vector by another vector.
			returns: Nothing.
			about: This does check if the given vector's values are zero.
		End Rem
		Method DivideVec(vec:TVec2)
			If vec = Null Return
			
			If vec.x <> 0 And vec.y <> 0
				x:/vec.x
				y:/vec.y
			End If
			
		End Method
		
		Rem
			bbdoc: Get the dot product of this vector and the vector given.
			returns: The dot product of the two vectors.
		End Rem
		Method DotProduct:Float(vec:TVec2)
			
			Return x * vec.x + y * vec.y
			
		End Method
		
		Rem
			bbdoc: Get the angle difference between this vector and the vector given.
			returns: The difference, in angles, between this and the given vector.
		End Rem
		Method GetAngleDiff:Float(vec:TVec2)
			If vec = Null Return 0.0
			
			Return Abs(TrueMod(ATan2(y, x) + 180 - ATan2(vec.y, vec.x), 360) - 180)
			
		End Method
		
		Rem
			bbdoc: Get this vector reflected upon another.
			returns: A new vector that is the result of this vector reflecting off of @vec.
		End Rem
		Method Reflected:TVec2(vec:TVec2)
			Local vecn:TVec2 = vec.Normalized()
			Local vec1:TVec2 = Copy()
			Local vecn_DOT_vec1:Float = vecn.DotProduct(vec1)
			
			vecn.Multiply(2 * vecn_DOT_vec1, 2 * vecn_DOT_vec1)
			
			vec1.SubtractVec(vecn)
			
			Return vec1
			
		End Method
		
		Rem
			bbdoc: Get a normalized vector of this vector.
			returns: This vector normalized.
		End Rem
		Method Normalized:TVec2() 
			Local magn:Float = GetMagnitude()
			Local vector:TVec2 = Copy()
			
			If magn <> 0
				
				vector.x = x / magn
				vector.y = y / magn
				
			End If
			
			Return vector
			
		End Method
		
		Rem
			bbdoc: Get the length (magnitude) of the vector.
			returns: The magnitude of the vector.
		End Rem
		Method GetMagnitude:Float()
			
			Return Sqr(x * x + y * y)
			
		End Method
		
End Type



































