
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
	
	param.bmx (Contains: TProtogParam, TProtogIntParam, TProtogFloatParam, TProtogTextureParam, TProtogVec2Param, TProtogVec3Param, TProtogVec4Param, TProtogShaderParam, TProtogShaderParamMap, )
	
	TODO:
		
	
End Rem

Rem
	bbdoc: Named parameters for #TProtogMaterial.
	about: Extending types: #TProtogFloatParam, #TProtogTextureParam, #TProtogVec2Param, #TProtogVec3Param, #TProtogVec4Param, #TProtogShaderParam).
End Rem
Type TProtogParam Abstract
	
	'Field m_changed:Int = False
	Field m_name:String
	
	Method New()
	End Method
	
	Rem
		bbdoc: Create a new TProtogParam.
		returns: The new TProtogParam (itself).
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
	'	about: @changed is used in #TProtogShaderParam to re-grab the value's pointer.
	'End Rem
	'Method SetChanged(changed:Int)
	'	m_changed = changed
	'End Method
	
	'Rem
	'	bbdoc: Get the parameter's value-changed status.
	'	returns: Nothing.
	'	about: @changed is used in #TProtogShaderParam to re-grab the value's pointer.
	'End Rem
	'Method GetChanged:Int()
	'	Return m_changed
	'End Method
	
'#end region (Field accessors)
	
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
	
'#end region (Shader)
	
	Rem
		bbdoc: Get the string definition of this parameter type.
		returns: The string definition of this parameter type.
	End Rem
	Method ParamType:String() Abstract
	
End Type

Rem
	bbdoc: Int parameter.
End Rem
Type TProtogIntParam Extends TProtogParam
	
	Field m_value:Int
	
	Method New()
	End Method
	
	Rem
		bbdoc: Create a new TProtogIntParam.
		returns: The new parameter (itself).
	End Rem
	Method Create:TProtogIntParam(name:String, value:Int)
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
	
'#end region (Field accessors)
	
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
	
'#end region (Shader)
	
	Rem
		bbdoc: Get the string definition of this parameter type.
		returns: The string definition of this parameter type.
	End Rem
	Method ParamType:String()
		Return "Int"
	End Method
	
End Type

Rem
	bbdoc: Float parameter.
End Rem
Type TProtogFloatParam Extends TProtogParam
	
	Field m_value:Float
	
	Method New()
	End Method
	
	Rem
		bbdoc: Create a new TProtogFloatParam.
		returns: The new parameter (itself).
	End Rem
	Method Create:TProtogFloatParam(name:String, value:Float)
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
	
'#end region (Field accessors)
	
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
	
'#end region (Shader)
	
	Rem
		bbdoc: Get the string definition of this parameter type.
		returns: The string definition of this parameter type.
	End Rem
	Method ParamType:String()
		Return "Float"
	End Method
	
End Type

Rem
	bbdoc: #TProtogTexture parameter.
End Rem
Type TProtogTextureParam Extends TProtogParam
	
	Field m_texture:TProtogTexture
	
	Method New()
	End Method
	
	Rem
		bbdoc: Create a new TProtogTextureParam.
		returns: The new parameter (itself).
	End Rem
	Method Create:TProtogTextureParam(name:String, texture:TProtogTexture)
		_Init(name)
		Set(texture)
		Return Self
	End Method
	
'#region Field accessors
	
	Rem
		bbdoc: Set the texture for this parameter.
		returns: Nothing.
	End Rem
	Method Set(texture:TProtogTexture)
		'If m_texture <> texture
		'	SetChanged(True)
		'End If
		m_texture = texture
	End Method
	
	Rem
		bbdoc: Get the texture for this parameter.
		returns: The texture for this parameter.
	End Rem
	Method Get:TProtogTexture()
		Return m_texture
	End Method
	
'#end region (Field accessors)
	
'#region Shader
	
	Rem
		bbdoc: Get the pointer to the value's first field in the param.
		returns: A pointer to the parameter's value.
	End Rem
	Method GetPointer:Byte Ptr()
		If m_texture.m_gltexture <> Null
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
	
'#end region (Shader)
	
	Rem
		bbdoc: Get the string definition of this parameter type.
		returns: The string definition of this parameter type.
	End Rem
	Method ParamType:String()
		Return "Texture"
	End Method
	
End Type

Rem
	bbdoc: #TProtogColor parameter.
End Rem
Type TProtogColorParam Extends TProtogParam
	
	Field m_color:TProtogColor
	
	Method New()
	End Method
	
	Rem
		bbdoc: Create a new TProtogColorParam.
		returns: The new parameter (itself).
	End Rem
	Method Create:TProtogColorParam(name:String, color:TProtogColor)
		_Init(name)
		Set(color)
		Return Self
	End Method
	
'#region Field accessors
	
	Rem
		bbdoc: Set the color for this parameter.
		returns: Nothing.
	End Rem
	Method Set(color:TProtogColor)
		'If m_color <> color
		'	SetChanged(True)
		'End If
		m_color = color
	End Method
	
	Rem
		bbdoc: Get the color for this parameter.
		returns: The color for this parameter.
	End Rem
	Method Get:TProtogColor()
		Return m_color
	End Method
	
'#end region (Field accessors)
	
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
	
'#end region (Shader)
	
	Rem
		bbdoc: Get the string definition of this parameter type.
		returns: The string definition of this parameter type.
	End Rem
	Method ParamType:String()
		Return "Color"
	End Method
	
End Type

Rem
	bbdoc: #TVec2 parameter.
End Rem
Type TProtogVec2Param Extends TProtogParam
	
	Field m_vector:TVec2
	
	Method New()
	End Method
	
	Rem
		bbdoc: Create a new TProtogVec2Param.
		returns: The new parameter (itself).
	End Rem
	Method Create:TProtogVec2Param(name:String, vector:TVec2)
		_Init(name)
		Set(vector)
		Return Self
	End Method
	
'#region Field accessors
	
	Rem
		bbdoc: Set the vector for this parameter.
		returns: Nothing.
	End Rem
	Method Set(vector:TVec2)
		'If m_vector <> vector
		'	SetChanged(True)
		'End If
		m_vector = vector
	End Method
	
	Rem
		bbdoc: Get the vector for this parameter.
		returns: The vector for this parameter.
	End Rem
	Method Get:TVec2()
		Return m_vector
	End Method
	
'#end region (Field accessors)
	
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
	
'#end region (Shader)
	
	Rem
		bbdoc: Get the string definition of this parameter type.
		returns: The string definition of this parameter type.
	End Rem
	Method ParamType:String()
		Return "Vec2"
	End Method
	
End Type

Rem
	bbdoc: #TVec2 array parameter.
End Rem
Type TProtogVec2ArrayParam Extends TProtogParam
	
	Field m_vectors:TVec2[]
	
	Method New()
	End Method
	
	Rem
		bbdoc: Create a new TProtogVec2ArrayParam.
		returns: The new parameter (itself).
	End Rem
	Method Create:TProtogVec2ArrayParam(name:String, vectors:TVec2[])
		_Init(name)
		Set(vectors)
		Return Self
	End Method
	
'#region Field accessors
	
	Rem
		bbdoc: Set the vector array for this parameter.
		returns: Nothing.
	End Rem
	Method Set(vectors:TVec2[])
		'If m_vectors <> vectors
		'	SetChanged(True)
		'End If
		m_vectors = vectors
	End Method
	
	Rem
		bbdoc: Get the vector array for this parameter.
		returns: The vector array for this parameter.
	End Rem
	Method Get:TVec2[] ()
		Return m_vectors
	End Method
	
'#end region (Field accessors)
	
'#region Shader
	
	Rem
		bbdoc: Get the pointer to the value's first field in the param.
		returns: A pointer to the parameter's value.
	End Rem
	Method GetPointer:Byte Ptr()
		If m_vectors <> Null
			Return Varptr(m_vectors[0].m_x)
		End If
		Return Null
	End Method
	
	Rem
		bbdoc: Get the number of indices in the param's value.
		returns: The number of indices for the param's value.
	End Rem
	Method GetValueCount:Int()
		If m_vectors <> Null
			Return m_vectors.Length
		End If
		Return 0
	End Method
	
'#end region (Shader)
	
	Rem
		bbdoc: Get the string definition of this parameter type.
		returns: The string definition of this parameter type.
	End Rem
	Method ParamType:String()
		Return "Vec2Array"
	End Method
	
End Type

Rem
	bbdoc: #TVec3 parameter (for #TProtogMaterial).
End Rem
Type TProtogVec3Param Extends TProtogParam
	
	Field m_vector:TVec3
	
	Method New()
	End Method
	
	Rem
		bbdoc: Create a new TProtogVec3Param.
		returns: The new parameter (itself).
	End Rem
	Method Create:TProtogVec3Param(name:String, vector:TVec3)
		_Init(name)
		Set(vector)
		Return Self
	End Method
	
'#region Field accessors
	
	Rem
		bbdoc: Set the vector for this parameter.
		returns: Nothing.
	End Rem
	Method Set(vector:TVec3)
		'If m_vector <> vector
		'	SetChanged(True)
		'End If
		m_vector = vector
	End Method
	
	Rem
		bbdoc: Get the vector for this parameter.
		returns: The vector for this parameter.
	End Rem
	Method Get:TVec3()
		Return m_vector
	End Method
	
'#end region (Field accessors)
	
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
	
'#end region (Shader)
	
	Rem
		bbdoc: Get the string definition of this parameter type.
		returns: The string definition of this parameter type.
	End Rem
	Method ParamType:String()
		Return "Vec3"
	End Method
	
End Type

Rem
	bbdoc: #TVec4 parameter (for #TProtogMaterial).
End Rem
Type TProtogVec4Param Extends TProtogParam
	
	Field m_vector:TVec4
	
	Method New()
	End Method
	
	Rem
		bbdoc: Create a new TProtogVec4Param.
		returns: The new parameter (itself).
	End Rem
	Method Create:TProtogVec4Param(name:String, vector:TVec4)
		_Init(name)
		Set(vector)
		Return Self
	End Method
	
'#region Field accessors
	
	Rem
		bbdoc: Set the vector for this parameter.
		returns: Nothing.
	End Rem
	Method Set(vector:TVec4)
		'If m_vector <> vector
		'	SetChanged(True)
		'End If
		m_vector = vector
	End Method
	
	Rem
		bbdoc: Get the vector for this parameter.
		returns: The vector for this parameter.
	End Rem
	Method Get:TVec4()
		Return m_vector
	End Method
	
'#end region (Field accessors)
	
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
	
'#end region (Shader)
	
	Rem
		bbdoc: Get the string definition of this parameter type.
		returns: The string definition of this parameter type.
	End Rem
	Method ParamType:String()
		Return "Vec4"
	End Method
	
End Type

Rem
	bbdoc: The wrapper parameter type for #TProtogShader.
	about: This type is primarily used internally (you will likely never need to use this).
End Rem
Type TProtogShaderParam Extends TProtogParam
	
	Const m_vectype:Int = 1
	Const m_colortype:Int = 2
	
	Field m_param:TProtogParam
	
	Field m_location:Int, m_utype:Int
	Field m_size:Int, m_unit:Int
	
	'Field m_pcount:Int = 1
	'Field m_pointer:Byte Ptr = Null
	
	Method New()
	End Method
	
	Rem
		bbdoc: Create a new TProtogShaderParam.
		returns: The new TProtogShaderParam (itself).
	End Rem
	Method Create:TProtogShaderParam(name:String, param:TProtogParam, location:Int, utype:Int, size:Int, unit:Int)
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
		bbdoc: Bind the TProtogShaderParam.
		returns: Nothing.
	End Rem
	Method Bind()
		Local pointer:Byte Ptr, count:Int
		
		pointer = m_param.GetPointer()
		count = m_param.GetValueCount()
		'DebugLog("(TProtogShaderParam.Bind) pointer = " + Int(pointer) + " count = " + count + " m_utype = " + m_utype + " m_param.GetName() = " + m_param.GetName())
		If pointer <> Null And count > 0
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
						'	TProtogTextureParam(m_param).m_texture.Bind()
						'Next
						DebugLog("(TProtogShaderParam.Bind) Uniform texture arrays are not supported")
					Else
						Local gltex:TGLTexture
						
						gltex = TProtogTextureParam(m_param).m_texture.m_gltexture
						If gltex <> Null
							glUniform1i(m_location, m_unit)
							glActiveTexture(GL_TEXTURE0 + m_unit)
							gltex.Bind(True)
							glActiveTexture(GL_TEXTURE0)
						Else
							Throw("(TProtogShaderParam.Bind) Unable to bind texture for parameter, Null texture! (" + m_name + ")")
						End If
					End If
					
				Default
					Throw("(TProtogShaderParam.Bind) Failed to recognize parameter type; m_utype = " + m_utype)
			End Select
		End If
		
	End Method
	
	Rem
		bbdoc: Unbind the TProtogShaderParam.
		returns: Nothing.
	End Rem
	Method Unbind()
		Local pointer:Byte Ptr, count:Int
		
		pointer = m_param.GetPointer()
		count = m_param.GetValueCount()
		'DebugLog("(TProtogShaderParam.Unbind) pointer = " + Int(pointer) + " count = " + count + " m_utype = " + m_utype + " m_param.GetName() = " + m_param.GetName())
		If pointer <> Null And count > 0
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
						'	TProtogTextureParam(m_param).m_texture.Bind()
						'Next
						DebugLog("(TProtogShaderParam.Unbind) Uniform texture arrays are not supported")
					Else
						Local gltex:TGLTexture
						
						gltex = TProtogTextureParam(m_param).m_texture.m_gltexture
						If gltex <> Null
							glActiveTexture(GL_TEXTURE0 + m_unit)
							gltex.Unbind()
							glActiveTexture(GL_TEXTURE0)
						Else
							Throw("(TProtogShaderParam.UnBind) Unable to bind texture for parameter, Null texture! (" + m_name + ")")
						End If
					End If
					
				Default
					Throw("(TProtogShaderParam.Unbind) Failed to recognize parameter type; m_utype = " + m_utype)
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
	
'#end region (Shader)
	
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
	bbdoc: #TProtogShaderParam collection map.
	about: This type is primarely used internally (you will likely never need to use this).
End Rem
Type TProtogShaderParamMap Extends TObjectMap
	
	Method New()
	End Method
	
	Rem
		bbdoc: Create a new TProtogShaderParamMap.
		returns: The new TProtogShaderParamMap (itself).
	End Rem
	Method Create:TProtogShaderParamMap()
		Return Self
	End Method
	
'#region Collections
	
	Rem
		bbdoc: Insert a parameter into the map.
		returns: Nothing.
	End Rem
	Method Insert(param:TProtogShaderParam)
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
	
'#end region (Collections)
	
End Type























































