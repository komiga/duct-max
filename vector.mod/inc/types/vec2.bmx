
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
	
	vec2.bmx (Contains: TVec2, )
	
End Rem

Rem
	bbdoc: The 2d (x & y) vector type.
End Rem
Type TVec2
	
	Field m_x:Float, m_y:Float
		
		Rem
			bbdoc: Create a new Vec2.
			returns: The new vector (itself).
		End Rem
		Method Create:TVec2(x:Float, y:Float)
			
			m_x = x
			m_y = y
			
			Return Self
			
		End Method
		
		Rem
			bbdoc: Get a copy of this vector.
			returns: A clone of this vector.
		End Rem
		Method Copy:TVec2()
			
			Return New TVec2.Create(m_x, m_y)
			
		End Method
		
		'#region Field accessors
		
		Rem
			bbdoc: Get the vector's values.
			returns: Nothing. @_x and @_y will contain the values of the vector.
		End Rem
		Method Get(x:Float Var, y:Float Var)
			
			x = m_x
			y = m_y
			
		End Method
		
		Rem
			bbdoc: Set the vector's values.
			returns: Nothing.
		End Rem
		Method Set(x:Float, y:Float)
			
			m_x = x
			m_y = y
			
		End Method
		
		Rem
			bbdoc: Set the vector's values by the given vector.
			returns: Nothing.
			about: This will <b>NOT</b> check if @vec is Null.
		End Rem
		Method SetVec(vec:TVec2)
			
			m_x = vec.m_x
			m_y = vec.m_y
			
		End Method
		
		'#end region (Field accessors)
		
		Rem
			bbdoc: Get the vector's angle.
			returns: The angle of the vector.
		End Rem
		Method GetAngle:Float()
			
			Return ATan2(m_y, m_x)
			
		End Method
		
		Rem
			bbdoc: Rotate the vector to an angle.
			returns: Nothing.
		End Rem
		Method Rotate(ang:Float)
			Local xprime:Float = Cos(ang) * m_x - Sin(ang) * m_y
			Local yprime:Float = Sin(ang) * m_x + Cos(ang) * m_y
			
			m_x = xprime
			m_y = yprime
			
		End Method
		
		Rem
			bbdoc: Rotate the vector to an angle, and stuff the result into a new vector.
			returns: A new vector with the result.
		End Rem
		Method RotateNew:TVec2(ang:Float)
			Local xprime:Float = Cos(ang) * m_x - Sin(ang) * m_y
			Local yprime:Float = Sin(ang) * m_x + Cos(ang) * m_y
			
			Return New TVec2.Create(xprime, yprime)
			
		End Method
		
		Rem
			bbdoc: Add the given values to this vector.
			returns: Nothing.
		End Rem
		Method AddParams(x:Float, y:Float)
			
			m_x:+x
			m_y:+y
			
		End Method
		
		Rem
			bbdoc: Add the given values to this vector, and stuff the result into a new vector.
			returns: A new vector for the result.
		End Rem
		Method AddParamsNew:TVec2(x:Float, y:Float)
			
			Return New TVec2.Create(m_x + x, m_y + y)
			
		End Method
		
		Rem
			bbdoc: Add the given vector to this vector.
			returns: Nothing.
			about: Warning: This does not check if @vec is Null!
		End Rem
		Method AddVec(vec:TVec2)
			
			m_x:+vec.m_x
			m_y:+vec.m_y
			
		End Method
		
		Rem
			bbdoc: Add the given vector to this vector, and stuff the result into a new vector.
			returns: A new vector with the result.
			about: Warning: This does not check if @vec is Null!
		End Rem
		Method AddVecNew:TVec2(vec:TVec2)
			
			Return New TVec2.Create(m_x + vec.m_x, m_y + vec.m_y)
			
		End Method
		
		Rem
			bbdoc: Subtract this vector by the values given.
			returns: Nothing.
		End Rem
		Method SubtractParams(x:Float, y:Float)
			
			m_x:-x
			m_y:-y
			
		End Method
		
		Rem
			bbdoc: Subtract this vector by the values given, and stuff the result into a new vector.
			returns: A new vector with the result.
		End Rem
		Method SubtractParamsNew:TVec2(x:Float, y:Float)
			
			Return New TVec2.Create(m_x - x, m_y - y)
			
		End Method
		
		Rem
			bbdoc: Subtract this vector by another vector.
			returns: Nothing.
			about: Warning: This does not check if @vec is Null!
		End Rem
		Method SubtractVec(vec:TVec2)
			
			m_x:-vec.m_x
			m_y:-vec.m_y
			
		End Method
		
		Rem
			bbdoc: Subtract this vector by another vector, and stuff the result into a new vector.
			returns: A new vector with the result.
			about: Warning: This does not check if @vec is Null!
		End Rem
		Method SubtractVecNew:TVec2(vec:TVec2)
			
			Return New TVec2.Create(m_x - vec.m_x, m_y - vec.m_y)
			
		End Method
		
		Rem
			bbdoc: Multiply this vector by the values given.
			returns: Nothing.
		End Rem
		Method MultiplyParams(x:Float, y:Float)
			
			m_x:*x
			m_y:*y
			
		End Method
		
		Rem
			bbdoc: Multiply this vector by the values given, and stuff the result into a new vector.
			returns: A new vector with the result.
		End Rem
		Method MultiplyParamsNew:TVec2(x:Float, y:Float)
			
			Return New TVec2.Create(m_x * x, m_y * y)
			
		End Method
		
		Rem
			bbdoc: Multiply this vector by another vector.
			returns: Nothing.
			about: Warning: This does not check if @vec is Null!
		End Rem
		Method MultiplyVec(vec:TVec2)
			
			m_x:*vec.m_x
			m_y:*vec.m_y
			
		End Method
		
		Rem
			bbdoc: Multiply this vector by another vector, and stuff the result into a new vector.
			returns: A new vector with the result.
			about: Warning: This does not check if @vec is Null!
		End Rem
		Method MultiplyVecNew:TVec2(vec:TVec2)
			
			Return New TVec2.Create(m_x * vec.m_x, m_y * vec.m_y)
			
		End Method
		
		Rem
			bbdoc: Divide this vector by the scalar given.
			returns: Nothing.
			about: This will check if the divisor is zero.
		End Rem
		Method DivideParams(scalar:Float)
			
			If scalar <> 0
				
				m_x:/scalar
				m_y:/scalar
				
			End If
			
		End Method
		
		Rem
			bbdoc: Divide this vector by the values given, and stuff the result into a new vector.
			returns: A new vector with the result.
			about: This will check if the divisor is zero. If the scalar is zero the returning vector will be the a copy of this vector.
		End Rem
		Method DivideParamsNew:TVec2(scalar:Float)
			Local nvec:TVec2 = Copy()
			
			If scalar <> 0
				
				nvec.m_x:/scalar
				nvec.m_y:/scalar
				
			End If
			
			Return nvec
			
		End Method
		
		Rem
			bbdoc: Get the dot product of this vector and the values given.
			returns: The dot product if this vector and the values given.
		End Rem
		Method DotProductParams:Float(x:Float, y:Float)
			
			Return m_x * x + m_y * y
			
		End Method
		
		Rem
			bbdoc: Get the dot product of this vector and the vector given.
			returns: The dot product of the two vectors.
			about: Warning: This method does not check if the given vector is Null.
		End Rem
		Method DotProductVec:Float(vec:TVec2)
			
			Return m_x * vec.m_x + m_y * vec.m_y
			
		End Method
		
		Rem
			bbdoc: Get the angle difference between this vector and the values given.
			returns: The difference, in angles, between this vector and the given values.
		End Rem
		Method GetAngleDiffParams:Float(x:Float, y:Float)
			
			Return Abs(TrueMod(ATan2(m_y, m_x) + 180 - ATan2(y, x), 360) - 180)
			
		End Method
		
		Rem
			bbdoc: Get the angle difference between this vector and the vector given.
			returns: The difference, in angles, between this vector and the given vector.
			about: If the given vector (@vec) is Null, the return value will be 0.0
		End Rem
		Method GetAngleDiffVec:Float(vec:TVec2)
			
			If vec = Null
				
				Return 0.0
				
			Else
				
				Return Abs(TrueMod(ATan2(m_y, m_x) + 180 - ATan2(vec.m_y, vec.m_x), 360) - 180)
				
			End If
			
		End Method
		
		Rem
			bbdoc: Get this vector reflected upon the given values.
			returns: A new vector that is the result of this vector reflecting off the given values.
		End Rem
		Method GetReflectedParamsNew:TVec2(x:Float, y:Float)
			
			Return GetReflectedVecNew(New TVec2.Create(x, y))
			
		End Method
		
		Rem
			bbdoc: Get this vector reflected upon another.
			returns: A new vector that is the result of this vector reflecting off of @vec.
			about: This method does not check if @vec is Null.
		End Rem
		Method GetReflectedVecNew:TVec2(vec:TVec2)
			Local vecnormal:TVec2 = vec.NormalizeNew()
			Local clone:TVec2 = Copy()
			Local dotp:Float = vecnormal.DotProductVec(clone)
			
			vecnormal.MultiplyParams(2 * dotp, 2 * dotp)
			
			clone.SubtractVec(vecnormal)
			
			Return clone
			
		End Method
		
		Rem
			bbdoc: Normalize this vector.
			returns: Nothing.
		End Rem
		Method Normalize()
			Local magn:Float = GetMagnitude()
			
			If magn <> 0
				
				m_x:/magn
				m_y:/magn
				
			End If
			
		End Method
		
		Rem
			bbdoc: Get the normalized version of this vector.
			returns: A new vector containing the normalized version of this vector.
			about: See also #Normalize.
		End Rem
		Method NormalizeNew:TVec2()
			Local clone:TVec2 = Copy()
			
			clone.Normalize()
			
			Return clone
			
		End Method
		
		Rem
			bbdoc: Get the length (magnitude) of the vector.
			returns: The magnitude of the vector.
		End Rem
		Method GetMagnitude:Float()
			
			Return Sqr(m_x * m_x + m_y * m_y)
			
		End Method
		
End Type



































