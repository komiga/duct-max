
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
	bbdoc: Named parameters for #dProtogMaterial.
	about: Extending types: #dProtogFloatParam, #dProtogTextureParam, #dProtogVec2Param, #dProtogVec3Param, #dProtogVec4Param, #dProtogShaderParam).
End Rem
Type dProtogParam Abstract
	
	'Field m_changed:Int = False
	Field m_name:String
	
	Rem
		bbdoc: Create a dProtogParam.
		returns: Itself.
	End Rem
	Method _Init(name:String)
		m_name = name
	End Method
	
'#region Field accessors
	
	Rem
		bbdoc: Get the param's name.
		returns: The name of the param.
	End Rem
	Method GetName:String()
		Return m_name
	End Method
	
	'Rem
	'	bbdoc: Set the parameter's value-changed state.
	'	returns: Nothing.
	'	about: @changed is used in #dProtogShaderParam to re-grab the value's pointer.
	'End Rem
	'Method SetChanged(changed:Int)
	'	m_changed = changed
	'End Method
	
	'Rem
	'	bbdoc: Get the parameter's value-changed status.
	'	returns: Nothing.
	'	about: @changed is used in #dProtogShaderParam to re-grab the value's pointer.
	'End Rem
	'Method GetChanged:Int()
	'	Return m_changed
	'End Method
	
'#end region Field accessors
	
'#region Shader
	
	Rem
		bbdoc: Get the pointer to the value's first field in the param.
		returns: A pointer to the parameter's value.
	End Rem
	Method GetPointer:Byte Ptr() Abstract
	
	Rem
		bbdoc: Get the number of indices in the param's value.
		returns: The number of indices for the param's value.
	End Rem
	Method GetValueCount:Int() Abstract
	
'#end region Shader
	
	Rem
		bbdoc: Get the string definition of this parameter type.
		returns: The string definition of this parameter type.
	End Rem
	Method ParamType:String() Abstract
	
End Type

Rem
	bbdoc: Protog Int parameter.
End Rem
Type dProtogIntParam Extends dProtogParam
	
	Field m_value:Int
	
	Rem
		bbdoc: Create a dProtogIntParam.
		returns: Itself.
	End Rem
	Method Create:dProtogIntParam(name:String, value:Int)
		_Init(name)
		Set(value)
		Return Self
	End Method
	
'#region Field accessors
	
	Rem
		bbdoc: Set the integer value for this parameter.
		returns: Nothing.
	End Rem
	Method Set(value:Int)
		m_value = value
	End Method
	
	Rem
		bbdoc: Get the integer value for this parameter.
		returns: The integer value for this parameter.
	End Rem
	Method Get:Int()
		Return m_value
	End Method
	
'#end region Field accessors
	
'#region Shader
	
	Rem
		bbdoc: Get the pointer to the value's first field in the param.
		returns: A pointer to the parameter's value.
	End Rem
	Method GetPointer:Byte Ptr()
		Return Varptr(m_value)
	End Method
	
	Rem
		bbdoc: Get the number of indices in the param's value.
		returns: The number of indices for the param's value.
	End Rem
	Method GetValueCount:Int()
		Return 1
	End Method
	
'#end region Shader
	
	Rem
		bbdoc: Get the string definition of this parameter type.
		returns: The string definition of this parameter type.
	End Rem
	Method ParamType:String()
		Return "Int"
	End Method
	
End Type

Rem
	bbdoc: Protog Float parameter.
End Rem
Type dProtogFloatParam Extends dProtogParam
	
	Field m_value:Float
	
	Rem
		bbdoc: Create a dProtogFloatParam.
		returns: Itself.
	End Rem
	Method Create:dProtogFloatParam(name:String, value:Float)
		_Init(name)
		Set(value)
		Return Self
	End Method
	
'#region Field accessors
	
	Rem
		bbdoc: Set the float value for this parameter.
		returns: Nothing.
	End Rem
	Method Set(value:Float)
		m_value = value
	End Method
	
	Rem
		bbdoc: Get the float value for this parameter.
		returns: The float value for this parameter.
	End Rem
	Method Get:Float()
		Return m_value
	End Method
	
'#end region Field accessors
	
'#region Shader
	
	Rem
		bbdoc: Get the pointer to the value's first field in the param.
		returns: A pointer to the parameter's value.
	End Rem
	Method GetPointer:Byte Ptr()
		Return Varptr(m_value)
	End Method
	
	Rem
		bbdoc: Get the number of indices in the param's value.
		returns: The number of indices for the param's value.
	End Rem
	Method GetValueCount:Int()
		Return 1
	End Method
	
'#end region Shader
	
	Rem
		bbdoc: Get the string definition of this parameter type.
		returns: The string definition of this parameter type.
	End Rem
	Method ParamType:String()
		Return "Float"
	End Method
	
End Type

Rem
	bbdoc: #dProtogTexture parameter.
End Rem
Type dProtogTextureParam Extends dProtogParam
	
	Field m_texture:dProtogTexture
	
	Rem
		bbdoc: Create a dProtogTextureParam.
		returns: Itself.
	End Rem
	Method Create:dProtogTextureParam(name:String, texture:dProtogTexture)
		_Init(name)
		Set(texture)
		Return Self
	End Method
	
'#region Field accessors
	
	Rem
		bbdoc: Set the texture for this parameter.
		returns: Nothing.
	End Rem
	Method Set(texture:dProtogTexture)
		'If m_texture <> texture
		'	SetChanged(True)
		'End If
		m_texture = texture
	End Method
	
	Rem
		bbdoc: Get the texture for this parameter.
		returns: The texture for this parameter.
	End Rem
	Method Get:dProtogTexture()
		Return m_texture
	End Method
	
'#end region Field accessors
	
'#region Shader
	
	Rem
		bbdoc: Get the pointer to the value's first field in the param.
		returns: A pointer to the parameter's value.
	End Rem
	Method GetPointer:Byte Ptr()
		If m_texture.m_gltexture
			Return Varptr(m_texture.m_gltexture.m_handle)
		End If
		Return Null
	End Method
	
	Rem
		bbdoc: Get the number of indices in the param's value.
		returns: The number of indices for the param's value.
	End Rem
	Method GetValueCount:Int()
		Return 1
	End Method
	
'#end region Shader
	
	Rem
		bbdoc: Get the string definition of this parameter type.
		returns: The string definition of this parameter type.
	End Rem
	Method ParamType:String()
		Return "Texture"
	End Method
	
End Type

Rem
	bbdoc: #dProtogColor parameter.
End Rem
Type dProtogColorParam Extends dProtogParam
	
	Field m_color:dProtogColor
	
	Rem
		bbdoc: Create a dProtogColorParam.
		returns: Itself.
	End Rem
	Method Create:dProtogColorParam(name:String, color:dProtogColor)
		_Init(name)
		Set(color)
		Return Self
	End Method
	
'#region Field accessors
	
	Rem
		bbdoc: Set the color for this parameter.
		returns: Nothing.
	End Rem
	Method Set(color:dProtogColor)
		'If m_color <> color
		'	SetChanged(True)
		'End If
		m_color = color
	End Method
	
	Rem
		bbdoc: Get the color for this parameter.
		returns: The color for this parameter.
	End Rem
	Method Get:dProtogColor()
		Return m_color
	End Method
	
'#end region Field accessors
	
'#region Shader
	
	Rem
		bbdoc: Get the pointer to the value's first field in the param.
		returns: A pointer to the parameter's value.
	End Rem
	Method GetPointer:Byte Ptr()
		Return Varptr(m_color.m_red)
	End Method
	
	Rem
		bbdoc: Get the number of indices in the param's value.
		returns: The number of indices for the param's value.
	End Rem
	Method GetValueCount:Int()
		Return 1
	End Method
	
'#end region Shader
	
	Rem
		bbdoc: Get the string definition of this parameter type.
		returns: The string definition of this parameter type.
	End Rem
	Method ParamType:String()
		Return "Color"
	End Method
	
End Type

Rem
	bbdoc: dVec2 parameter.
End Rem
Type dProtogVec2Param Extends dProtogParam
	
	Field m_vector:dVec2
	
	Rem
		bbdoc: Create a dProtogVec2Param.
		returns: Itself.
	End Rem
	Method Create:dProtogVec2Param(name:String, vector:dVec2)
		_Init(name)
		Set(vector)
		Return Self
	End Method
	
'#region Field accessors
	
	Rem
		bbdoc: Set the vector for this parameter.
		returns: Nothing.
	End Rem
	Method Set(vector:dVec2)
		'If m_vector <> vector
		'	SetChanged(True)
		'End If
		m_vector = vector
	End Method
	
	Rem
		bbdoc: Get the vector for this parameter.
		returns: The vector for this parameter.
	End Rem
	Method Get:dVec2()
		Return m_vector
	End Method
	
'#end region Field accessors
	
'#region Shader
	
	Rem
		bbdoc: Get the pointer to the value's first field in the param.
		returns: A pointer to the parameter's value.
	End Rem
	Method GetPointer:Byte Ptr()
		Return Varptr(m_vector.m_x)
	End Method
	
	Rem
		bbdoc: Get the number of indices in the param's value.
		returns: The number of indices for the param's value.
	End Rem
	Method GetValueCount:Int()
		Return 1
	End Method
	
'#end region Shader
	
	Rem
		bbdoc: Get the string definition of this parameter type.
		returns: The string definition of this parameter type.
	End Rem
	Method ParamType:String()
		Return "Vec2"
	End Method
	
End Type

Rem
	bbdoc: dVec2 array parameter.
End Rem
Type dProtogVec2ArrayParam Extends dProtogParam
	
	Field m_vectors:dVec2[]
	
	Rem
		bbdoc: Create a dProtogVec2ArrayParam.
		returns: Itself.
	End Rem
	Method Create:dProtogVec2ArrayParam(name:String, vectors:dVec2[])
		_Init(name)
		Set(vectors)
		Return Self
	End Method
	
'#region Field accessors
	
	Rem
		bbdoc: Set the vector array for this parameter.
		returns: Nothing.
	End Rem
	Method Set(vectors:dVec2[])
		'If m_vectors <> vectors
		'	SetChanged(True)
		'End If
		m_vectors = vectors
	End Method
	
	Rem
		bbdoc: Get the vector array for this parameter.
		returns: The vector array for this parameter.
	End Rem
	Method Get:dVec2[]()
		Return m_vectors
	End Method
	
'#end region Field accessors
	
'#region Shader
	
	Rem
		bbdoc: Get the pointer to the value's first field in the param.
		returns: A pointer to the parameter's value.
	End Rem
	Method GetPointer:Byte Ptr()
		If m_vectors
			Return Varptr(m_vectors[0].m_x)
		End If
		Return Null
	End Method
	
	Rem
		bbdoc: Get the number of indices in the param's value.
		returns: The number of indices for the param's value.
	End Rem
	Method GetValueCount:Int()
		If m_vectors
			Return m_vectors.Length
		End If
		Return 0
	End Method
	
'#end region Shader
	
	Rem
		bbdoc: Get the string definition of this parameter type.
		returns: The string definition of this parameter type.
	End Rem
	Method ParamType:String()
		Return "Vec2Array"
	End Method
	
End Type

Rem
	bbdoc: dVec3 parameter (for #dProtogMaterial).
End Rem
Type dProtogVec3Param Extends dProtogParam
	
	Field m_vector:dVec3
	
	Rem
		bbdoc: Create a dProtogVec3Param.
		returns: Itself.
	End Rem
	Method Create:dProtogVec3Param(name:String, vector:dVec3)
		_Init(name)
		Set(vector)
		Return Self
	End Method
	
'#region Field accessors
	
	Rem
		bbdoc: Set the vector for this parameter.
		returns: Nothing.
	End Rem
	Method Set(vector:dVec3)
		'If m_vector <> vector
		'	SetChanged(True)
		'End If
		m_vector = vector
	End Method
	
	Rem
		bbdoc: Get the vector for this parameter.
		returns: The vector for this parameter.
	End Rem
	Method Get:dVec3()
		Return m_vector
	End Method
	
'#end region Field accessors
	
'#region Shader
	
	Rem
		bbdoc: Get the pointer to the value's first field in the param.
		returns: A pointer to the parameter's value.
	End Rem
	Method GetPointer:Byte Ptr()
		Return Varptr(m_vector.m_x)
	End Method
	
	Rem
		bbdoc: Get the number of indices in the param's value.
		returns: The number of indices for the param's value.
	End Rem
	Method GetValueCount:Int()
		Return 1
	End Method
	
'#end region Shader
	
	Rem
		bbdoc: Get the string definition of this parameter type.
		returns: The string definition of this parameter type.
	End Rem
	Method ParamType:String()
		Return "Vec3"
	End Method
	
End Type

Rem
	bbdoc: dVec4 parameter (for #dProtogMaterial).
End Rem
Type dProtogVec4Param Extends dProtogParam
	
	Field m_vector:dVec4
	
	Rem
		bbdoc: Create a dProtogVec4Param.
		returns: Itself.
	End Rem
	Method Create:dProtogVec4Param(name:String, vector:dVec4)
		_Init(name)
		Set(vector)
		Return Self
	End Method
	
'#region Field accessors
	
	Rem
		bbdoc: Set the vector for this parameter.
		returns: Nothing.
	End Rem
	Method Set(vector:dVec4)
		'If m_vector <> vector
		'	SetChanged(True)
		'End If
		m_vector = vector
	End Method
	
	Rem
		bbdoc: Get the vector for this parameter.
		returns: The vector for this parameter.
	End Rem
	Method Get:dVec4()
		Return m_vector
	End Method
	
'#end region Field accessors
	
'#region Shader
	
	Rem
		bbdoc: Get the pointer to the value's first field in the param.
		returns: A pointer to the parameter's value.
	End Rem
	Method GetPointer:Byte Ptr()
		Return Varptr(m_vector.m_x)
	End Method
	
	Rem
		bbdoc: Get the number of indices in the param's value.
		returns: The number of indices for the param's value.
	End Rem
	Method GetValueCount:Int()
		Return 1
	End Method
	
'#end region Shader
	
	Rem
		bbdoc: Get the string definition of this parameter type.
		returns: The string definition of this parameter type.
	End Rem
	Method ParamType:String()
		Return "Vec4"
	End Method
	
End Type

Rem
	bbdoc: The wrapper parameter type for #dProtogShader.
	about: This type is primarily used internally (you will likely never need to use this).
End Rem
Type dProtogShaderParam Extends dProtogParam
	
	Const m_vectype:Int = 1
	Const m_colortype:Int = 2
	
	Field m_param:dProtogParam
	
	Field m_location:Int, m_utype:Int
	Field m_size:Int, m_unit:Int
	
	'Field m_pcount:Int = 1
	'Field m_pointer:Byte Ptr = Null
	
	Rem
		bbdoc: Create a dProtogShaderParam.
		returns: The new dProtogShaderParam (itself).
	End Rem
	Method Create:dProtogShaderParam(name:String, param:dProtogParam, location:Int, utype:Int, size:Int, unit:Int)
		_Init(name)
		m_param = param
		m_location = location
		m_utype = utype
		m_size = size
		m_unit = unit
		Return Self
	End Method
	
'#region Shader
	
	'Rem
	'	bbdoc: Validate the param.
	'	returns: Nothing.
	'	about: This will grab the param's pointer for uniform binding.
	'End Rem
	'Method Validate()
	'	If m_param.GetChanged() = True
	'		m_pointer = m_param.GetPointer()
	'		m_pcount = m_param.GetValueCount()
	'		m_param.SetChanged(False)
	'	End If
	'End Method
	
	Rem
		bbdoc: Bind the dProtogShaderParam.
		returns: Nothing.
	End Rem
	Method Bind()
		Local pointer:Byte Ptr = m_param.GetPointer()
		Local count:Int = m_param.GetValueCount()
		'DebugLog("(dProtogShaderParam.Bind) pointer = " + Int(pointer) + " count = " + count + " m_utype = " + m_utype + " m_param.GetName() = " + m_param.GetName())
		If pointer And count > 0
			Select m_utype
				Case GL_INT
					glUniform1iv(m_location, count, Int Ptr(pointer))
				Case GL_FLOAT
					glUniform1fv(m_location, count, Float Ptr(pointer))
				Case GL_FLOAT_VEC2
					glUniform2fv(m_location, count, Float Ptr(pointer))
				Case GL_FLOAT_VEC3
					glUniform3fv(m_location, count, Float Ptr(pointer))
				Case GL_FLOAT_VEC4
					glUniform4fv(m_location, count, Float Ptr(pointer))
				'Case GL_FLOAT_MAT4
				'	Local n:Int = m_param.ValueCount() / 16
				'	glUniformMatrix4fv(m_location, n, GL_FALSE, m_pointer)
				Case GL_SAMPLER_2D, GL_SAMPLER_2D_RECT_ARB
					If count > 1
						'Local index:Int
						'For index = 0 To count - 1
						'	glUniform1i(m_location, m_unit)
						'	glActiveTexture(GL_TEXTURE0 + m_unit)
						'	dProtogTextureParam(m_param).m_texture.Bind()
						'Next
						DebugLog("(dProtogShaderParam.Bind) Uniform texture arrays are not supported")
					Else
						Local gltex:dGLTexture
						
						gltex = dProtogTextureParam(m_param).m_texture.m_gltexture
						If gltex
							glUniform1i(m_location, m_unit)
							glActiveTexture(GL_TEXTURE0 + m_unit)
							gltex.Bind(True)
							glActiveTexture(GL_TEXTURE0)
						Else
							Throw "(dProtogShaderParam.Bind) Unable to bind texture for parameter, Null texture! (" + m_name + ")"
						End If
					End If
					
				Default
					Throw "(dProtogShaderParam.Bind) Failed to recognize parameter type; m_utype = " + m_utype
			End Select
		End If
		
	End Method
	
	Rem
		bbdoc: Unbind the dProtogShaderParam.
		returns: Nothing.
	End Rem
	Method Unbind()
		Local pointer:Byte Ptr = m_param.GetPointer()
		Local count:Int = m_param.GetValueCount()
		'DebugLog("(dProtogShaderParam.Unbind) pointer = " + Int(pointer) + " count = " + count + " m_utype = " + m_utype + " m_param.GetName() = " + m_param.GetName())
		If pointer And count > 0
			Select m_utype
				Case GL_INT
					'glUniform1iv(m_location, count, Int Ptr(pointer))
				Case GL_FLOAT
					'glUniform1fv(m_location, count, Float Ptr(pointer))
				Case GL_FLOAT_VEC2
					'glUniform2fv(m_location, count, Float Ptr(pointer))
				Case GL_FLOAT_VEC3
					'glUniform3fv(m_location, count, Float Ptr(pointer))
				Case GL_FLOAT_VEC4
					'glUniform4fv(m_location, count, Float Ptr(pointer))
				'Case GL_FLOAT_MAT4
				'	Local n:Int = m_param.ValueCount() / 16
				'	glUniformMatrix4fv(m_location, n, GL_FALSE, m_pointer)
				Case GL_SAMPLER_2D, GL_SAMPLER_2D_RECT_ARB
					If count > 1
						'Local index:Int
						'For index = 0 To count - 1
						'	glUniform1i(m_location, m_unit)
						'	glActiveTexture(GL_TEXTURE0 + m_unit)
						'	dProtogTextureParam(m_param).m_texture.Bind()
						'Next
						DebugLog("(dProtogShaderParam.Unbind) Uniform texture arrays are not supported")
					Else
						Local gltex:dGLTexture = dProtogTextureParam(m_param).m_texture.m_gltexture
						If gltex
							glActiveTexture(GL_TEXTURE0 + m_unit)
							gltex.Unbind()
							glActiveTexture(GL_TEXTURE0)
						Else
							Throw "(dProtogShaderParam.UnBind) Unable to bind texture for parameter, Null texture! (" + m_name + ")"
						End If
					End If
					
				Default
					Throw "(dProtogShaderParam.Unbind) Failed to recognize parameter type; m_utype = " + m_utype
			End Select
		End If
		
	End Method
	
	Rem
		bbdoc: Not in use for this type.
		returns: Null.
	End Rem
	Method GetPointer:Byte Ptr()
		Return Null
	End Method
	
	Rem
		bbdoc: Get the number of indices in the param's value.
		returns: The number of indices for the param's value.
	End Rem
	Method GetValueCount:Int()
		Return 1
	End Method
	
'#end region Shader
	
	Rem
		bbdoc: Get the string definition of this parameter type.
		returns: The string definition of this parameter type.
	End Rem
	Method ParamType:String()
		Return "ShaderParam"
	End Method
	
	Method ToString:String()
		Return "m_name = " + m_name + " m_location = " + m_location + " m_utype = " + m_utype + " m_size = " + m_size + " m_unit = " + m_unit
	End Method
	
End Type

Rem
	bbdoc: #dProtogShaderParam collection map.
	about: This type is primarely used internally (you will likely never need to use this).
End Rem
Type dProtogShaderParamMap Extends dObjectMap
	
	Rem
		bbdoc: Create a dProtogShaderParamMap.
		returns: Itself.
	End Rem
	Method Create:dProtogShaderParamMap()
		Return Self
	End Method
	
'#region Collections
	
	Rem
		bbdoc: Insert a parameter into the map.
		returns: Nothing.
	End Rem
	Method Insert(param:dProtogShaderParam)
		_Insert(param.m_name, param)
	End Method
	
	Rem
		bbdoc: Remove a parameter from the map by the name given.
		returns: True if the parameter was removed, or False if it was not removed (does not exist in map).
	End Rem
	Method Remove:Int(param_name:String)
		Return _Remove(param_name)
	End Method
	
	Rem
		bbdoc: Check if the map contains a parameter by the name given.
		returns: True if the parameter is in the map, or False if it is not in the map.
	End Rem
	Method Contains:Int(param_name:String)
		Return _Contains(param_name)
	End Method
	
'#end region Collections
	
End Type

