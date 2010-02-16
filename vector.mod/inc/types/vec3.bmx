
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
	
	vec3.bmx (Contains: TVec3, )
	
End Rem

Rem
	bbdoc: The 3-dimensional (x,y,z) vector type.
End Rem
Type TVec3
	
	Field m_x:Float, m_y:Float, m_z:Float
	
	Rem
		bbdoc: Create a new TVec3.
		returns: The new vector (itself).
	End Rem
	Method Create:TVec3(x:Float, y:Float, z:Float)
		m_x = x
		m_y = y
		m_z = z
		Return Self
	End Method
	
'#region Field accessors
	
	Rem
		bbdoc: Get the vector's values.
		returns: Nothing. @x, @y and @z will contain the values of the vector.
	End Rem
	Method Get(x:Float Var, y:Float Var, z:Float Var)
		x = m_x
		y = m_y
		z = m_z
	End Method
	
	Rem
		bbdoc: Set the vector's values.
		returns: Nothing.
	End Rem
	Method Set(x:Float, y:Float, z:Float)
		m_x = x
		m_y = y
		m_z = z
	End Method
	
	Rem
		bbdoc: Set the vector's values by the given vector.
		returns: Nothing.
		about: Warning: An assert will be thrown if @vec is Null (only applies in Debug mode).
	End Rem
	Method SetVec(vec:TVec3)
		Assert vec, "(TVec3.SetVec) @vec is Null!"
		m_x = vec.m_x
		m_y = vec.m_y
		m_z = vec.m_z
	End Method
	
'#end region (Field accessors)
	
'#region Mathematics
	
	Rem
		bbdoc: Get the vector's angle.
		returns: The angle of the vector.
	End Rem
	Method GetAngle:Float()
		Return ATan2(m_y, Sqr(m_x * m_x + m_z * m_z))
	End Method
	
	Rem
		bbdoc: Add the given values to this vector.
		returns: Nothing.
	End Rem
	Method AddParams(x:Float, y:Float, z:Float)
		m_x:+x
		m_y:+y
		m_z:+z
	End Method
	
	Rem
		bbdoc: Add the given values to this vector, and stuff the result into a new vector.
		returns: A new vector for the result.
	End Rem
	Method AddParamsNew:TVec3(x:Float, y:Float, z:Float)
		Return New TVec3.Create(m_x + x, m_y + y, m_z + z)
	End Method
	
	Rem
		bbdoc: Add the given vector to this vector.
		returns: Nothing.
		about: Warning: An assert will be thrown if @vec is Null (only applies in Debug mode).
	End Rem
	Method AddVec(vec:TVec3)
		Assert vec, "(TVec3.AddVec) @vec is Null!"
		m_x:+vec.m_x
		m_y:+vec.m_y
		m_z:+vec.m_z
	End Method
	
	Rem
		bbdoc: Add the given vector to this vector, and stuff the result into a new vector.
		returns: A new vector for the result.
		about: Warning: An assert will be thrown if @vec is Null (only applies in Debug mode).
	End Rem
	Method AddVecNew:TVec3(vec:TVec3)
		Assert vec, "(TVec3.AddVecNew) @vec is Null!"
		Return New TVec3.Create(m_x + vec.m_x, m_y + vec.m_y, m_z + vec.m_z)
	End Method
	
	Rem
		bbdoc: Subtract this vector by the values given.
		returns: Nothing.
	End Rem
	Method SubtractParams(x:Float, y:Float, z:Float)
		m_x:-x
		m_y:-y
		m_z:-z
	End Method
	
	Rem
		bbdoc: Subtract this vector by the values given, and stuff the result into a new vector.
		returns: A new vector for the result.
	End Rem
	Method SubtractParamsNew:TVec3(x:Float, y:Float, z:Float)
		Return New TVec3.Create(m_x - x, m_y - y, m_z - z)
	End Method
	
	Rem
		bbdoc: Subtract this vector by another vector.
		returns: Nothing.
		about: Warning: An assert will be thrown if @vec is Null (only applies in Debug mode).
	End Rem
	Method SubtractVec(vec:TVec3)
		Assert vec, "(TVec3.SubtractVec) @vec is Null!"
		m_x:-vec.m_x
		m_y:-vec.m_y
		m_z:-vec.m_z
	End Method
	
	Rem
		bbdoc: Subtract this vector by another vector, and stuff the result into a new vector.
		returns: A new vector for the result.
		about: Warning: An assert will be thrown if @vec is Null (only applies in Debug mode).
	End Rem
	Method SubtractVecNew:TVec3(vec:TVec3)
		Assert vec, "(TVec3.SubtractVecNew) @vec is Null!"
		Return New TVec3.Create(m_x - vec.m_x, m_y - vec.m_y, m_z - vec.m_z)
	End Method
	
	Rem
		bbdoc: Multiply this vector by the values given.
		returns: Nothing.
	End Rem
	Method MultiplyParams(x:Float, y:Float, z:Float)
		m_x:*x
		m_y:*y
		m_z:*z
	End Method
	
	Rem
		bbdoc: Multiply this vector by the values given, and stuff the result into a new vector.
		returns: A new vector for the result.
	End Rem
	Method MultiplyParamsNew:TVec3(x:Float, y:Float, z:Float)
		Return New TVec3.Create(m_x * x, m_y * y, m_z * z)
	End Method
	
	Rem
		bbdoc: Multiply this vector by another vector.
		returns: Nothing.
		about: Warning: An assert will be thrown if @vec is Null (only applies in Debug mode).
	End Rem
	Method MultiplyVec(vec:TVec3)
		Assert vec, "(TVec3.MultiplyVec) @vec is Null!"
		m_x:*vec.m_x
		m_y:*vec.m_y
		m_z:*vec.m_z
	End Method
	
	Rem
		bbdoc: Multiply this vector by another vector, and stuff the result into a new vector.
		returns: A new vector for the result.
		about: Warning: An assert will be thrown if @vec is Null (only applies in Debug mode).
	End Rem
	Method MultiplyVecNew:TVec3(vec:TVec3)
		Assert vec, "(TVec3.MultiplyVecNew) @vec is Null!"
		Return New TVec3.Create(m_x * vec.m_x, m_y * vec.m_y, m_z * vec.m_z)
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
			m_z:/scalar
		End If
	End Method
	
	Rem
		bbdoc: Divide this vector by the scalar given, and stuff the result into a new vector.
		returns: A new vector for the result.
		about: This will check if the divisor is zero.
	End Rem
	Method DivideParamsNew:TVec3(scalar:Float)
		Local nvec:TVec3 = Copy()
		If scalar <> 0
			nvec.m_x:/scalar
			nvec.m_y:/scalar
			nvec.m_z:/scalar
		End If
		Return nvec
	End Method
	
'#end region (Mathematics)
	
'#region Mathemagics
	
	Rem
		bbdoc: Get the dot product of this vector and the given values.
		returns: The dot product of this vector and the given values.
	End Rem
	Method DotProductParams:Float(x:Float, y:Float, z:Float)
		Return m_x * x + m_y * y + m_z * z
	End Method
	
	Rem
		bbdoc: Get the dot product of this vector and the vector given.
		returns: The dot product of the two vectors.
		about: Warning: An assert will be thrown if @vec is Null (only applies in Debug mode).
	End Rem
	Method DotProductVec:Float(vec:TVec3)
		Assert vec, "(TVec3.DotProductVec) @vec is Null!"
		Return m_x * vec.m_x + m_y * vec.m_y + m_z * vec.m_z
	End Method
	
	Rem
		bbdoc: Get this vector reflected upon the given values.
		returns: A new vector that is the result of this vector reflecting off the given values.
	End Rem
	Method GetReflectedParamsNew:TVec3(x:Float, y:Float, z:Float)
		Return GetReflectedVecNew(New TVec3.Create(x, y, z))
	End Method
	
	Rem
		bbdoc: Get this vector reflected upon another.
		returns: A new vector that is the result of this vector reflecting off of @vec.
		about: Warning: An assert will be thrown if @vec is Null (only applies in Debug mode).
	End Rem
	Method GetReflectedVecNew:TVec3(vec:TVec3)
		Local vecnormal:TVec3, clone:TVec3
		Local dotp:Float
		Assert vec, "(TVec3.GetReflectedVecNew) @vec is Null!"
		vecnormal = vec.NormalizeNew()
		clone = Copy()
		dotp = vecnormal.DotProductVec(clone)
		vecnormal.MultiplyParams(2 * dotp, 2 * dotp, 2 * dotp)
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
			m_z:/magn
			
		End If
	End Method
	
	Rem
		bbdoc: Get a normalized vector of this vector.
		returns: This vector normalized.
		about: See also #Normalize.
	End Rem
	Method NormalizeNew:TVec3()
		Local vector:TVec3 = Copy()
		vector.Normalize()
		Return vector
	End Method
	
	Rem
		bbdoc: Get the length (magnitude) of the vector.
		returns: The magnitude of the vector.
	End Rem
	Method GetMagnitude:Float()
		Return Sqr(m_x * m_x + m_y * m_y + m_z * m_z)
	End Method
	
	Rem
		bbdoc: Make this vector the cross product of the given values and this vector (Self CrossProduct [@x, @y, @z]).
		returns: Nothing.
	End Rem
	Method CrossProductParams(x:Float, y:Float, z:Float)
		Local cpx:Float, cpy:Float, cpz:Float
		cpx = m_y * z - m_z * y
		cpy = m_z * x - m_x * z
		cpz = m_x * y - m_y * x
		m_x = cpx
		m_y = cpy
		m_z = cpz
	End Method
	
	Rem
		bbdoc: Get the cross product of this vector and the given values (Self CrossProduct [@x, @y, @z]).
		returns: A new vector containing the result.
	End Rem
	Method CrossProductParamsNew:TVec3(x:Float, y:Float, z:Float)
		Return New TVec3.Create(m_y * z - m_z * y, m_z * x - m_x * z, m_x * y - m_y * x)
	End Method
	
	Rem
		bbdoc: Make this vector the cross product of the given vector and this vector (Self CrossProduct @vec).
		returns: Nothing.
		about: Warning: An assert will be thrown if @vec is Null (only applies in Debug mode).
	End Rem
	Method CrossProductVec(vec:TVec3)
		Local cpx:Float, cpy:Float, cpz:Float
		Assert vec, "(TVec3.CrossProductVec) @vec is Null!"
		cpx = m_y * vec.m_z - m_z * vec.m_y
		cpy = m_z * vec.m_x - m_x * vec.m_z
		cpz = m_x * vec.m_y - m_y * vec.m_x
		m_x = cpx
		m_y = cpy
		m_z = cpz
	End Method
	
	Rem
		bbdoc: Get the cross product of this vector and the given vector (Self CrossProduct [@x, @y, @z]).
		returns: A new vector containing the result.
		about: Warning: An assert will be thrown if @vec is Null (only applies in Debug mode).
	End Rem
	Method CrossProductVecNew:TVec3(vec:TVec3)
		Assert vec, "(TVec3.CrossProductVecNew) @vec is Null!"
		Return New TVec3.Create(m_y * vec.m_z - m_z * vec.m_y, m_z * vec.m_x - m_x * vec.m_z, m_x * vec.m_y - m_y * vec.m_x)
	End Method
	
'#end region (Mathemagics)
	
'#region Data handling
	
	Rem
		bbdoc: Get a copy of this vector.
		returns: A clone of this vector.
	End Rem
	Method Copy:TVec3()
		Return New TVec3.Create(m_x, m_y, m_z)
	End Method
	
	Rem
		bbdoc: Serialize the vector to the given stream.
		returns: Nothing.
	End Rem
	Method Serialize(stream:TStream)
		stream.WriteFloat(m_x)
		stream.WriteFloat(m_y)
		stream.WriteFloat(m_z)
	End Method
	
	Rem
		bbdoc: Deserialize a vector from the given stream
		returns: Nothing.
	End Rem
	Method DeSerialize:TVec3(stream:TStream)
		m_x = stream.ReadFloat()
		m_y = stream.ReadFloat()
		m_z = stream.ReadFloat()
		Return Self
	End Method
	
'#end region (Data handling)
	
End Type

