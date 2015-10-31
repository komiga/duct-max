
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
	bbdoc: duct 2-dimensional (x,y) vector.
End Rem
Type dVec2
	
	Field m_x:Float, m_y:Float
	
	Rem
		bbdoc: Create a 2d vector.
		returns: Itself.
	End Rem
	Method Create:dVec2(x:Float, y:Float)
		m_x = x
		m_y = y
		Return Self
	End Method
	
'#region Field accessors
	
	Rem
		bbdoc: Get the vector's values.
		returns: Nothing. @x and @y will contain the values of the vector.
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
		about: Warning: An assert will be thrown if vec is Null (only applies in Debug mode).
	End Rem
	Method SetVec(vec:dVec2)
		Assert vec, "(dVec2.SetVec) vec is Null"
		m_x = vec.m_x
		m_y = vec.m_y
	End Method
	
'#end region Field accessors
	
'#region Mathematics
	
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
	Method RotateNew:dVec2(ang:Float)
		Local xprime:Float = Cos(ang) * m_x - Sin(ang) * m_y
		Local yprime:Float = Sin(ang) * m_x + Cos(ang) * m_y
		Return New dVec2.Create(xprime, yprime)
	End Method
	
	Rem
		bbdoc: Add the given values to this vector.
		returns: Nothing.
	End Rem
	Method AddParams(x:Float, y:Float)
		m_x:+ x
		m_y:+ y
	End Method
	
	Rem
		bbdoc: Add the given values to this vector, and stuff the result into a new vector.
		returns: A new vector for the result.
	End Rem
	Method AddParamsNew:dVec2(x:Float, y:Float)
		Return New dVec2.Create(m_x + x, m_y + y)
	End Method
	
	Rem
		bbdoc: Add the given vector to this vector.
		returns: Nothing.
		about: Warning: An assert will be thrown if vec is Null (only applies in Debug mode).
	End Rem
	Method AddVec(vec:dVec2)
		Assert vec, "(dVec2.AddVec) vec is Null"
		m_x:+ vec.m_x
		m_y:+ vec.m_y
	End Method
	
	Rem
		bbdoc: Add the given vector to this vector, and stuff the result into a new vector.
		returns: A new vector with the result.
		about: Warning: An assert will be thrown if vec is Null (only applies in Debug mode).
	End Rem
	Method AddVecNew:dVec2(vec:dVec2)
		Assert vec, "(dVec2.AddVecNew) vec is Null"
		Return New dVec2.Create(m_x + vec.m_x, m_y + vec.m_y)
	End Method
	
	Rem
		bbdoc: Subtract this vector by the values given.
		returns: Nothing.
	End Rem
	Method SubtractParams(x:Float, y:Float)
		m_x:- x
		m_y:- y
	End Method
	
	Rem
		bbdoc: Subtract this vector by the values given, and stuff the result into a new vector.
		returns: A new vector with the result.
	End Rem
	Method SubtractParamsNew:dVec2(x:Float, y:Float)
		Return New dVec2.Create(m_x - x, m_y - y)
	End Method
	
	Rem
		bbdoc: Subtract this vector by another vector.
		returns: Nothing.
		about: Warning: An assert will be thrown if vec is Null (only applies in Debug mode).
	End Rem
	Method SubtractVec(vec:dVec2)
		Assert vec, "(dVec2.SubtractVec) vec is Null"
		m_x:- vec.m_x
		m_y:- vec.m_y
	End Method
	
	Rem
		bbdoc: Subtract this vector by another vector, and stuff the result into a new vector.
		returns: A new vector with the result.
		about: Warning: An assert will be thrown if vec is Null (only applies in Debug mode).
	End Rem
	Method SubtractVecNew:dVec2(vec:dVec2)
		Assert vec, "(dVec2.SubtractVecNew) vec is Null"
		Return New dVec2.Create(m_x - vec.m_x, m_y - vec.m_y)
	End Method
	
	Rem
		bbdoc: Multiply this vector by the values given.
		returns: Nothing.
	End Rem
	Method MultiplyParams(x:Float, y:Float)
		m_x:* x
		m_y:* y
	End Method
	
	Rem
		bbdoc: Multiply this vector by the values given, and stuff the result into a new vector.
		returns: A new vector with the result.
	End Rem
	Method MultiplyParamsNew:dVec2(x:Float, y:Float)
		Return New dVec2.Create(m_x * x, m_y * y)
	End Method
	
	Rem
		bbdoc: Multiply this vector by another vector.
		returns: Nothing.
		about: Warning: An assert will be thrown if vec is Null (only applies in Debug mode).
	End Rem
	Method MultiplyVec(vec:dVec2)
		Assert vec, "(dVec2.MultiplyVec) vec is Null"
		m_x:* vec.m_x
		m_y:* vec.m_y
	End Method
	
	Rem
		bbdoc: Multiply this vector by another vector, and stuff the result into a new vector.
		returns: A new vector with the result.
		about: Warning: An assert will be thrown if vec is Null (only applies in Debug mode).
	End Rem
	Method MultiplyVecNew:dVec2(vec:dVec2)
		Assert vec, "(dVec2.MultiplyVecNew) vec is Null"
		Return New dVec2.Create(m_x * vec.m_x, m_y * vec.m_y)
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
	Method DivideParamsNew:dVec2(scalar:Float)
		Local nvec:dVec2 = Copy()
		If scalar <> 0
			nvec.m_x:/scalar
			nvec.m_y:/scalar
		End If
		Return nvec
	End Method
	
'#end region Mathematics
	
'#region Mathemagics
	
	Rem
		bbdoc: Get the dot product of this vector and the values given.
		returns: The dot product of this vector and the values given.
	End Rem
	Method DotProductParams:Float(x:Float, y:Float)
		Return m_x * x + m_y * y
	End Method
	
	Rem
		bbdoc: Get the dot product of this vector and the vector given.
		returns: The dot product of the two vectors.
		about: Warning: An assert will be thrown if vec is Null (only applies in Debug mode).
	End Rem
	Method DotProductVec:Float(vec:dVec2)
		Assert vec, "(dVec2.DotProductVec) vec is Null"
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
		about: Warning: An assert will be thrown if vec is Null (only applies in Debug mode).
	End Rem
	Method GetAngleDiffVec:Float(vec:dVec2)
		Assert vec, "(dVec2.GetAngleDiffVec) vec is Null"
		Return Abs(TrueMod(ATan2(m_y, m_x) + 180 - ATan2(vec.m_y, vec.m_x), 360) - 180)
	End Method
	
	Rem
		bbdoc: Get this vector reflected upon the given values.
		returns: A new vector that is the result of this vector reflecting off the given values.
	End Rem
	Method GetReflectedParamsNew:dVec2(x:Float, y:Float)
		Return GetReflectedVecNew(New dVec2.Create(x, y))
	End Method
	
	Rem
		bbdoc: Get this vector reflected upon another.
		returns: A new vector that is the result of this vector reflecting off of @vec.
		about: Warning: An assert will be thrown if vec is Null (only applies in Debug mode).
	End Rem
	Method GetReflectedVecNew:dVec2(vec:dVec2)
		Assert vec, "(dVec2.GetReflectedVecNew) vec is Null"
		Local vecnormal:dVec2 = vec.NormalizeNew()
		Local clone:dVec2 = Copy()
		Local dotp:Float = vecnormal.DotProductVec(clone)
		vecnormal.MultiplyParams(2.0 * dotp, 2.0 * dotp)
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
			m_x:/ magn
			m_y:/ magn
		End If
	End Method
	
	Rem
		bbdoc: Get the normalized version of this vector.
		returns: A new vector containing the normalized version of this vector.
		about: See also #Normalize.
	End Rem
	Method NormalizeNew:dVec2()
		Local clone:dVec2 = Copy()
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
	
'#end region Mathemagics
	
'#region Data handling
	
	Rem
		bbdoc: Get a copy of this vector.
		returns: A clone of this vector.
	End Rem
	Method Copy:dVec2()
		Return New dVec2.Create(m_x, m_y)
	End Method
	
	Rem
		bbdoc: Serialize the vector to the given stream.
		returns: Nothing.
	End Rem
	Method Serialize(stream:TStream)
		stream.WriteFloat(m_x)
		stream.WriteFloat(m_y)
	End Method
	
	Rem
		bbdoc: Deserialize a vector from the given stream
		returns: Nothing.
	End Rem
	Method DeSerialize:dVec2(stream:TStream)
		m_x = stream.ReadFloat()
		m_y = stream.ReadFloat()
		Return Self
	End Method
	
'#end region Data handling
	
End Type

