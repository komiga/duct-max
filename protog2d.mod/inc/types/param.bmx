
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
	
	param.bmx (Contains: TGLParam, TGLFloatParam, TGLTextureParam, TGLVec2Param, TGLVec3Param, TGLVec4Param, TGLSLParam, TGLSLParamMap, )
	
	TODO:
		
	
End Rem

Rem
	bbdoc: High-level wrapper for shader uniforms.<br />
	about: Extending types: #{TGLFloatParam}, #{TGLTextureParam}, #{TGLVec2Param}, #{TGLVec3Param}, #{TGLVec4Param}).
End Rem
Type TGLParam Abstract
	
	Field m_name:String
	
	Method New()
	End Method
	
	Rem
		bbdoc: Create a new GLParam.
		returns: The new GLParam (itself).
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
	
	'#end region (Field accessors)
	
	Rem
		bbdoc: Get the string definition of this parameter type.
		returns: The string definition of this parameter type.
	End Rem
	Method ParamType:String() Abstract
	
End Type

Rem
	bbdoc: Float parameter (for #{TGLMaterial}).
End Rem
Type TGLFloatParam Extends TGLParam
	
	Field m_value:Float
	
	Method New()
	End Method
	
	Rem
		bbdoc: Create a new GLFloatParam.
		returns: The new parameter (itself).
	End Rem
	Method Create:TGLFloatParam(name:String, value:Float)
		
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
	
	Rem
		bbdoc: Get the string definition of this parameter type.
		returns: The string definition of this parameter type.
	End Rem
	Method ParamType:String()
		
		Return "Float"
		
	End Method
	
End Type

Rem
	bbdoc: #{TGLTexture} parameter (for #{TGLMaterial}).
End Rem
Type TGLTextureParam Extends TGLParam
	
	Field m_texture:TProtogTexture
	
	Method New()
	End Method
	
	Rem
		bbdoc: Create a new GLTextureParam.
		returns: The new parameter (itself).
	End Rem
	Method Create:TGLTextureParam(name:String, texture:TProtogTexture)
		
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
	
	Rem
		bbdoc: Get the string definition of this parameter type.
		returns: The string definition of this parameter type.
	End Rem
	Method ParamType:String()
		
		Return "Texture"
		
	End Method
	
End Type

Rem
	bbdoc: #{TVec2} paramter (for #{TGLMaterial}).
End Rem
Type TGLVec2Param Extends TGLParam
	
	Field m_vector:TVec2
	
	Method New()
	End Method
	
	Rem
		bbdoc: Create a new GLVec2Param.
		returns: The new parameter (itself).
	End Rem
	Method Create:TGLVec2Param(name:String, vector:TVec2)
		
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
	
	Rem
		bbdoc: Get the string definition of this parameter type.
		returns: The string definition of this parameter type.
	End Rem
	Method ParamType:String()
		
		Return "Vec2"
		
	End Method
	
End Type

Rem
	bbdoc: #{TVec3} paramter (for #{TGLMaterial}).
End Rem
Type TGLVec3Param Extends TGLParam
	
	Field m_vector:TVec3
	
	Method New()
	End Method
	
	Rem
		bbdoc: Create a new GLVec3Param.
		returns: The new parameter (itself).
	End Rem
	Method Create:TGLVec3Param(name:String, vector:TVec3)
		
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
	
	Rem
		bbdoc: Get the string definition of this parameter type.
		returns: The string definition of this parameter type.
	End Rem
	Method ParamType:String()
		
		Return "Vec3"
		
	End Method
	
End Type

Rem
	bbdoc: #{TVec4} paramter (for #{TGLMaterial}).
End Rem
Type TGLVec4Param Extends TGLParam
	
	Field m_vector:TVec4
	
	Method New()
	End Method
	
	Rem
		bbdoc: Create a new GLVec4Param.
		returns: The new parameter (itself).
	End Rem
	Method Create:TGLVec4Param(name:String, vector:TVec4)
		
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
	
	Rem
		bbdoc: Get the string definition of this parameter type.
		returns: The string definition of this parameter type.
	End Rem
	Method ParamType:String()
		
		Return "Vec4"
		
	End Method
	
End Type

Rem
	bbdoc: The wrapper parameter type for #{TGLSLProgram}.
	about: This type is primarely used internally (you will likely never need to use this).
End Rem
Type TGLSLParam Extends TGLParam
	
	Field m_param:TGLParam
	
	Field m_location:Int, m_utype:Int
	Field m_size:Int, m_unit:Int
	
	Method New()
	End Method
	
	Rem
		bbdoc: Create a new GLSLParam.
		returns: The new GLSLParam (itself).
	End Rem
	Method Create:TGLSLParam(name:String, param:TGLParam, location:Int, utype:Int, size:Int, unit:Int)
		
		_Init(name)
		
		m_param = param
		
		m_location = location
		m_utype = utype
		m_size = size
		m_unit = unit
		
		Return Self
		
	End Method
	
	Rem
		bbdoc: Bind the GLSLParam.
		returns: Nothing.
	End Rem
	Method Bind()
		
		Select m_utype
			Case GL_FLOAT
				'glUniform1fv(m_location, _param.Count(), Varptr(TGLFloatParam(m_param).m_value)))
				glUniform1f(m_location, TGLFloatParam(m_param).m_value)
				
			Case GL_FLOAT_VEC2
				glUniform2fv(m_location, 1, Varptr(TGLVec2Param(m_param).m_vector.m_x))
				
			Case GL_FLOAT_VEC3
				glUniform3fv(m_location, 1, Varptr(TGLVec3Param(m_param).m_vector.m_x))
				
			Case GL_FLOAT_VEC4
				glUniform4fv(m_location, 1, Varptr(TGLVec4Param(m_param).m_vector.m_x))
				
			'Case GL_FLOAT_MAT4
			'	Local n:Int = _param.Count() / 16
			'	glUniformMatrix4fv(_glloc, n, GL_FALSE, _param.FloatValue())
			'	
			Case GL_SAMPLER_2D', GL_SAMPLER_2D_RECT_ARB
				glUniform1i(m_location, m_unit)
				glActiveTexture(GL_TEXTURE0 + m_unit)
				TGLTextureParam(m_param).m_texture.m_gltexture.Bind()
				
		End Select
		
	End Method
	
	Rem
		bbdoc: Get the string definition of this parameter type.
		returns: The string definition of this parameter type.
	End Rem
	Method ParamType:String()
		Return "GLSLParam"
	End Method
	
End Type

Rem
	bbdoc: #{TGLSLParam} collection map.
	about: This type is primarely used internally (you will likely never need to use this).
End Rem
Type TGLSLParamMap Extends TObjectMap
	
	Method New()
	End Method
	
	Rem
		bbdoc: Create a new GLSLParamMap.
		returns: The new GLSLParamMap (itself).
	End Rem
	Method Create:TGLSLParamMap()
		
		Return Self
		
	End Method
	
	'#region Collections
	
	Rem
		bbdoc: Insert a parameter into the map.
		returns: Nothing.
	End Rem
	Method Insert(param:TGLSLParam)
		
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























































