
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
	
	material.bmx (Contains: TGLMaterial, )
	
	TODO:
		
	
End Rem

Rem
	bbdoc: Protog's material type; Stores #{TGLParam} objects for rendering properties.<br />
	See #{TGLParam} for more information on the specific types of parameters.
End Rem
Type TGLMaterial Extends TObjectMap
	
	Field m_name:String
	
	Method New()
	End Method
	
	Rem
		bbdoc: Create a new GLMaterial.
		returns: The new material (itself).
	End Rem
	Method Create:TGLMaterial(name:String = Null)
		SetName(name)
		Return Self
	End Method
	
	'#region Collections
	
	Rem
		bbdoc: Set a float value in the material.
		returns: Nothing.
	End Rem
	Method SetFloat(name:String, value:Float)
		Local param:TGLFloatParam
		
		param = GetFloatParam(name)
		
		If param = Null
			param = New TGLFloatParam.Create(name, value)
			_InsertParam(param)
		Else
			param.Set(value)
		End If
		
	End Method
	
	Rem
		bbdoc: Get a float param from the material.
		returns: A GLFLoatParam for the given name, or Null if the given name was not found within the material.
		about: NOTE: This will throw an exception if it finds a parameter with the name given that is <b>not</b> a GLFloatParam.
	End Rem
	Method GetFloatParam:TGLFloatParam(name:String)
		Local param:TGLParam, fparam:TGLFloatParam
		
		param = TGLParam(_ValueByKey(name))
		fparam = TGLFloatParam(param)
		
		If fparam = Null And param <> Null
			Throw("(duct.protog2d.TGLMaterial.GetFloatParam) Parameter of name '" + name + "' is not a GLFloatParam!~n~t" + ..
				"[param.ParamType() = " + param.ParamType() + "]")
		End If
		
		Return fparam
		
	End Method
	
	Rem
		bbdoc: Set a Vec2 value in the material.
		returns: Nothing.
	End Rem
	Method SetVec2(name:String, vector:TVec2)
		Local param:TGLVec2Param
		
		param = GetVec2Param(name)
		
		If param = Null
			param = New TGLVec2Param.Create(name, vector)
			_InsertParam(param)
		Else
			param.Set(vector)
		End If
		
	End Method
	
	Rem
		bbdoc: Get a Vec2 param from the material.
		returns: A GLVec2Param for the given name, or Null if the given name was not found within the material.
		about: NOTE: This will throw an exception if it finds a parameter with the name given that is <b>not</b> a GLVec2Param.
	End Rem
	Method GetVec2Param:TGLVec2Param(name:String)
		Local param:TGLParam, vparam:TGLVec2Param
		
		param = TGLParam(_ValueByKey(name))
		vparam = TGLVec2Param(param)
		
		If vparam = Null And param <> Null
			Throw("(duct.protog2d.TGLMaterial.GetVec2Param) Parameter of name '" + name + "' is not a GLVec2Param!~n~t" + ..
				"[param.ParamType() = " + param.ParamType() + "]")
		End If
		
		Return vparam
		
	End Method
	
	Rem
		bbdoc: Set a Vec3 value in the material.
		returns: Nothing.
	End Rem
	Method SetVec3(name:String, vector:TVec3)
		Local param:TGLVec3Param
		
		param = GetVec3Param(name)
		
		If param = Null
			param = New TGLVec3Param.Create(name, vector)
			_InsertParam(param)
		Else
			param.Set(vector)
		End If
		
	End Method
	
	Rem
		bbdoc: Get a Vec3 param from the material.
		returns: A GLVec3Param for the given name, or Null if the given name was not found within the material.
		about: NOTE: This will throw an exception if it finds a parameter with the name given that is <b>not</b> a GLVec3Param.
	End Rem
	Method GetVec3Param:TGLVec3Param(name:String)
		Local param:TGLParam, vparam:TGLVec3Param
		
		param = TGLParam(_ValueByKey(name))
		vparam = TGLVec3Param(param)
		
		If vparam = Null And param <> Null
			Throw("(duct.protog2d.TGLMaterial.GetVec3Param) Parameter of name '" + name + "' is not a GLVec3Param!~n~t" + ..
				"[param.ParamType() = " + param.ParamType() + "]")
		End If
		
		Return vparam
		
	End Method
	
	Rem
		bbdoc: Set a Vec4 value in the material.
		returns: Nothing.
	End Rem
	Method SetVec4(name:String, vector:TVec4)
		Local param:TGLVec4Param
		
		param = GetVec4Param(name)
		
		If param = Null
			param = New TGLVec4Param.Create(name, vector)
			_InsertParam(param)
		Else
			param.Set(vector)
		End If
		
	End Method
	
	Rem
		bbdoc: Get a Vec4 param from the material.
		returns: A GLVec4Param for the given name, or Null if the given name was not found within the material.
		about: NOTE: This will throw an exception if it finds a parameter with the name given that is <b>not</b> a GLVec4Param.
	End Rem
	Method GetVec4Param:TGLVec4Param(name:String)
		Local param:TGLParam, vparam:TGLVec4Param
		
		param = TGLParam(_ValueByKey(name))
		vparam = TGLVec4Param(param)
		
		If vparam = Null And param <> Null
			Throw("(duct.protog2d.TGLMaterial.GetVec4Param) Parameter of name '" + name + "' is not a GLVec4Param!~n~t" + ..
				"[param.ParamType() = " + param.ParamType() + "]")
		End If
		
		Return vparam
		
	End Method
	
	Rem
		bbdoc: Set a texture value in the material.
		returns: Nothing.
	End Rem
	Method SetTexture(name:String, texture:TProtogTexture)
		Local param:TGLTextureParam
		
		param = GetTextureParam(name)
		
		If param = Null
			param = New TGLTextureParam.Create(name, texture)
			_InsertParam(param)
		Else
			param.Set(texture)
		End If
		
	End Method
	
	Rem
		bbdoc: Get a texture param from the material.
		returns: A GLTextureParam for the given name, or Null if the given name was not found within the material.
		about: NOTE: This will throw an exception if it finds a parameter with the name given that is <b>not</b> a GLTextureParam.
	End Rem
	Method GetTextureParam:TGLTextureParam(name:String)
		Local param:TGLParam, vparam:TGLTextureParam
		
		param = TGLParam(_ValueByKey(name))
		vparam = TGLTextureParam(param)
		
		If vparam = Null And param <> Null
			Throw("(duct.protog2d.TGLMaterial.GetTextureParam) Parameter of name '" + name + ..
				"' is not a GLTextureParam! [param.ParamType() = " + param.ParamType() + "]")
		End If
		
		Return vparam
		
	End Method
	
	Method _InsertParam(param:TGLParam)
		_Insert(param.m_name, param)
	End Method
	
	'#end region (Collections)
	
	'#region Field accessors
	
	Rem
		bbdoc: Set the name for the material.
		returns: Nothing.
	End Rem
	Method SetName(name:String)
		m_name = name
	End Method
	
	Rem
		bbdoc: Get the material's name
		returns: The name of the material.
		about: 
	End Rem
	Method GetName:String()
		Return m_name
	End Method
	
	'#end region (Field accessors)
	
End Type

























































