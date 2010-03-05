
Rem
Copyright (c) 2010 Tim Howard

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
	bbdoc: duct 4-dimensional (x,y,z,w) vector.
End Rem
Type dVec4
	
	Field m_x:Float, m_y:Float, m_z:Float, m_w:Float
	
	Rem
		bbdoc: Create a new 4d vector.
		returns: Itself.
	End Rem
	Method Create:dVec4(x:Float, y:Float, z:Float, w:Float)
		m_x = x
		m_y = y
		m_z = z
		m_w = w
		Return Self
	End Method
	
	Rem
		bbdoc: Create a new dVec4 from the values in the given vectors.
		returns: The new vector (itself).
	End Rem
	Method CreateFromVec2:dVec4(xy:dVec2, zw:dVec2)
		m_x = xy.m_x
		m_y = xy.m_y
		m_z = zw.m_x
		m_w = zw.m_y
		Return Self
	End Method
	
'#region Field accessors
	
	Rem
		bbdoc: Get the vector's values.
		returns: Nothing. @x, @y, @z and @w will contain the values of the vector.
	End Rem
	Method Get(x:Float Var, y:Float Var, z:Float Var, w:Float Var)
		x = m_x
		y = m_y
		z = m_z
		w = m_w
	End Method
	
	Rem
		bbdoc: Set the vector's values.
		returns: Nothing.
	End Rem
	Method Set(x:Float, y:Float, z:Float, w:Float)
		m_x = x
		m_y = y
		m_z = z
		m_w = w
	End Method
	
	Rem
		bbdoc: Set the vector's values by the given vector.
		returns: Nothing.
		about: Warning: An assert will be thrown if @vec is Null (only applies in Debug mode).
	End Rem
	Method SetVec(vec:dVec4)
		Assert vec, "(dVec4.SetVec) @vec is Null!"
		m_x = vec.m_x
		m_y = vec.m_y
		m_z = vec.m_z
		m_w = vec.m_w
	End Method
	
'#end region (Field accessors)
	
'#region Mathematics
	
	Rem
		bbdoc: Add the given values to this vector.
		returns: Nothing.
	End Rem
	Method AddParams(x:Float, y:Float, z:Float, w:Float)
		m_x:+x
		m_y:+y
		m_z:+z
		m_w:+w
	End Method
	
	Rem
		bbdoc: Add the given values to this vector, and stuff the result into a new vector.
		returns: A new vector for the result.
	End Rem
	Method AddParamsNew:dVec4(x:Float, y:Float, z:Float, w:Float)
		Return New dVec4.Create(m_x + x, m_y + y, m_z + z, m_w + w)
	End Method
	
	Rem
		bbdoc: Add the given vector to this vector.
		returns: Nothing.
		about: Warning: An assert will be thrown if @vec is Null (only applies in Debug mode).
	End Rem
	Method AddVec(vec:dVec4)
		Assert vec, "(dVec4.AddVec) @vec is Null!"
		m_x:+vec.m_x
		m_y:+vec.m_y
		m_z:+vec.m_z
		m_w:+vec.m_w
	End Method
	
	Rem
		bbdoc: Add the given vector to this vector, and stuff the result into a new vector.
		returns: A new vector for the result.
		about: Warning: An assert will be thrown if @vec is Null (only applies in Debug mode).
	End Rem
	Method AddVecNew:dVec4(vec:dVec4)
		Assert vec, "(dVec4.AddVecNew) @vec is Null!"
		Return New dVec4.Create(m_x + vec.m_x, m_y + vec.m_y, m_z + vec.m_z, m_w + vec.m_w)
	End Method
	
	Rem
		bbdoc: Subtract this vector by the values given.
		returns: Nothing.
	End Rem
	Method SubtractParams(x:Float, y:Float, z:Float, w:Float)
		m_x:-x
		m_y:-y
		m_z:-z
		m_w:-w
	End Method
	
	Rem
		bbdoc: Subtract this vector by the values given, and stuff the result into a new vector.
		returns: A new vector for the result.
	End Rem
	Method SubtractParamsNew:dVec4(x:Float, y:Float, z:Float, w:Float)
		Return New dVec4.Create(m_x - x, m_y - y, m_z - z, m_w - w)
	End Method
	
	Rem
		bbdoc: Subtract this vector by another vector.
		returns: Nothing.
		about: Warning: An assert will be thrown if @vec is Null (only applies in Debug mode).
	End Rem
	Method SubtractVec(vec:dVec4)
		Assert vec, "(dVec4.SubtractVec) @vec is Null!"
		m_x:-vec.m_x
		m_y:-vec.m_y
		m_z:-vec.m_z
		m_w:-vec.m_w
	End Method
	
	Rem
		bbdoc: Subtract this vector by another vector, and stuff the result into a new vector.
		returns: A new vector for the result.
		about: Warning: An assert will be thrown if @vec is Null (only applies in Debug mode).
	End Rem
	Method SubtractVecNew:dVec4(vec:dVec4)
		Assert vec, "(dVec4.SubtractVecNew) @vec is Null!"
		Return New dVec4.Create(m_x - vec.m_x, m_y - vec.m_y, m_z - vec.m_z, m_w - vec.m_w)
	End Method
	
	Rem
		bbdoc: Multiply this vector by the values given.
		returns: Nothing.
	End Rem
	Method MultiplyParams(x:Float, y:Float, z:Float, w:Float)
		m_x:*x
		m_y:*y
		m_z:*z
		m_w:*w
	End Method
	
	Rem
		bbdoc: Multiply this vector by the values given, and stuff the result into a new vector.
		returns: A new vector for the result.
	End Rem
	Method MultiplyParamsNew:dVec4(x:Float, y:Float, z:Float, w:Float)
		Return New dVec4.Create(m_x * x, m_y * y, m_z * z, m_w * w)
	End Method
	
	Rem
		bbdoc: Multiply this vector by another vector.
		returns: Nothing.
		about: Warning: An assert will be thrown if @vec is Null (only applies in Debug mode).
	End Rem
	Method MultiplyVec(vec:dVec4)
		Assert vec, "(dVec4.MultiplyVec) @vec is Null!"
		m_x:*vec.m_x
		m_y:*vec.m_y
		m_z:*vec.m_z
		m_w:*vec.m_w
	End Method
	
	Rem
		bbdoc: Multiply this vector by another vector, and stuff the result into a new vector.
		returns: A new vector for the result.
		about: Warning: An assert will be thrown if @vec is Null (only applies in Debug mode).
	End Rem
	Method MultiplyVecNew:dVec4(vec:dVec4)
		Assert vec, "(dVec4.MultiplyVecNew) @vec is Null!"
		Return New dVec4.Create(m_x * vec.m_x, m_y * vec.m_y, m_z * vec.m_z, m_w * vec.m_w)
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
			m_w:/scalar
		End If
	End Method
	
	Rem
		bbdoc: Divide this vector by the scalar given, and stuff the result into a new vector.
		returns: A new vector for the result.
		about: This will check if the divisor is zero.
	End Rem
	Method DivideParamsNew:dVec4(scalar:Float)
		Local nvec:dVec4 = Copy()
		If scalar <> 0
			nvec.m_x:/scalar
			nvec.m_y:/scalar
			nvec.m_z:/scalar
			nvec.m_w:/scalar
		End If
		Return nvec
	End Method
	
'#end region (Mathematics)
	
'#region (Mathemagics)
	
	Rem
		bbdoc: Get the dot product of this vector and the given values.
		returns: The dot product of this vector and the given values.
	End Rem
	Method DotProductParams:Float(x:Float, y:Float, z:Float, w:Float)
		Return m_x * x + m_y * y + m_z * z + m_w * w
	End Method
	
	Rem
		bbdoc: Get the dot product of this vector and the vector given.
		returns: The dot product of the two vectors.
		about: Warning: An assert will be thrown if @vec is Null (only applies in Debug mode).
	End Rem
	Method DotProductVec:Float(vec:dVec4)
		Assert vec, "(dVec4.DotProductVec) @vec is Null!"
		Return m_x * vec.m_x + m_y * vec.m_y + m_z * vec.m_z + m_w * vec.m_w
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
			m_W:/magn
		End If
	End Method
	
	Rem
		bbdoc: Get a normalized vector of this vector.
		returns: This vector normalized.
		about: See also #Normalize.
	End Rem
	Method NormalizeNew:dVec4()
		Local vector:dVec4 = Copy()
		vector.Normalize()
		Return vector
	End Method
	
	Rem
		bbdoc: Get the length (magnitude) of the vector.
		returns: The magnitude of the vector.
	End Rem
	Method GetMagnitude:Float()
		Return Sqr(m_x * m_x + m_y * m_y + m_z * m_z + m_w * m_w)
	End Method
	
'#end region (Mathemagics)
	
'#region Data handling
	
	Rem
		bbdoc: Get a copy of this vector.
		returns: A clone of this vector.
	End Rem
	Method Copy:dVec4()
		Return New dVec4.Create(m_x, m_y, m_z, m_w)
	End Method
	
	Rem
		bbdoc: Serialize the vector to the given stream.
		returns: Nothing.
	End Rem
	Method Serialize(stream:TStream)
		stream.WriteFloat(m_x)
		stream.WriteFloat(m_y)
		stream.WriteFloat(m_z)
		stream.WriteFloat(m_w)
	End Method
	
	Rem
		bbdoc: Deserialize a vector from the given stream
		returns: Nothing.
	End Rem
	Method DeSerialize:dVec4(stream:TStream)
		m_x = stream.ReadFloat()
		m_y = stream.ReadFloat()
		m_z = stream.ReadFloat()
		m_w = stream.ReadFloat()
		Return Self
	End Method
	
'#end region (Data handling)
	
End Type

