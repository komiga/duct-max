
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
	
	material.bmx (Contains: TProtogMaterial, )
	
	TODO:
		
End Rem

Rem
	bbdoc: Protog's material type; Stores #TProtogParam objects for rendering properties.<br/>
	See #TProtogParam for more information on the specific types of parameters.
End Rem
Type TProtogMaterial Extends TObjectMap
	
	Field m_name:String
	
	Method New()
	End Method
	
	Rem
		bbdoc: Create a new TProtogMaterial.
		returns: The new material (itself).
	End Rem
	Method Create:TProtogMaterial(name:String = Null)
		SetName(name)
		Return Self
	End Method
	
'#region Collections
	
	Rem
		bbdoc: Get a param from the material.
		returns: A TProtogParam for the given name, or Null if the given name was not found within the material.
	End Rem
	Method GetParam:TProtogParam(name:String)
		Return TProtogParam(_ValueByKey(name))
	End Method
	
	Rem
		bbdoc: Set an int value in the material.
		returns: Nothing.
	End Rem
	Method SetInt(name:String, value:Int)
		Local param:TProtogIntParam = GetIntParam(name)
		If param = Null
			param = New TProtogIntParam.Create(name, value)
			_InsertParam(param)
		Else
			param.Set(value)
		End If
	End Method
	
	Rem
		bbdoc: Get an int param from the material.
		returns: A TProtogIntParam for the given name, or Null if the given name was not found within the material.
		about: NOTE: This will throw an exception if it finds a parameter with the name given that is @not a TProtogFloatParam.
	End Rem
	Method GetIntParam:TProtogIntParam(name:String)
		Local param:TProtogParam, iparam:TProtogIntParam
		
		param = TProtogParam(_ValueByKey(name))
		iparam = TProtogIntParam(param)
		If iparam = Null And param <> Null
			Throw("(duct.protog2d.TProtogMaterial.GetIntParam) Parameter of name '" + name + "' is not a TProtogIntParam!~n" + ..
				"~t[param.ParamType() = " + param.ParamType() + "]")
		End If
		Return iparam
	End Method
	
	Rem
		bbdoc: Set a float value in the material.
		returns: Nothing.
	End Rem
	Method SetFloat(name:String, value:Float)
		Local param:TProtogFloatParam = GetFloatParam(name)
		If param = Null
			param = New TProtogFloatParam.Create(name, value)
			_InsertParam(param)
		Else
			param.Set(value)
		End If
	End Method
	
	Rem
		bbdoc: Get a float param from the material.
		returns: A TProtogFLoatParam for the given name, or Null if the given name was not found within the material.
		about: NOTE: This will throw an exception if it finds a parameter with the name given that is @not a TProtogFloatParam.
	End Rem
	Method GetFloatParam:TProtogFloatParam(name:String)
		Local param:TProtogParam = TProtogParam(_ValueByKey(name))
		Local fparam:TProtogFloatParam = TProtogFloatParam(param)
		If fparam = Null And param <> Null
			Throw("(duct.protog2d.TProtogMaterial.GetFloatParam) Parameter of name '" + name + "' is not a TProtogFloatParam!~n" + ..
				"~t[param.ParamType() = " + param.ParamType() + "]")
		End If
		Return fparam
	End Method
	
	Rem
		bbdoc: Set a color value in the material.
		returns: Nothing.
	End Rem
	Method SetColor(name:String, color:TProtogColor)
		Local param:TProtogColorParam = GetColorParam(name)
		If param = Null
			param = New TProtogColorParam.Create(name, color)
			_InsertParam(param)
		Else
			param.Set(color)
		End If
	End Method
	
	Rem
		bbdoc: Get a color param from the material.
		returns: A TProtogColorParam for the given name, or Null if the given name was not found within the material.
		about: NOTE: This will throw an exception if it finds a parameter with the name given that is @not a TProtogColorParam.
	End Rem
	Method GetColorParam:TProtogColorParam(name:String)
		Local param:TProtogParam = TProtogParam(_ValueByKey(name))
		Local vparam:TProtogColorParam = TProtogColorParam(param)
		
		If vparam = Null And param <> Null
			Throw("(duct.protog2d.TProtogMaterial.GetColorParam) Parameter of name '" + name + "' is not a TProtogColorParam!~n" + ..
				"~t[param.ParamType() = " + param.ParamType() + "]")
		End If
		Return vparam
	End Method
	
	Rem
		bbdoc: Set a Vec2 value in the material.
		returns: Nothing.
	End Rem
	Method SetVec2(name:String, vector:TVec2)
		Local param:TProtogVec2Param = GetVec2Param(name)
		If param = Null
			param = New TProtogVec2Param.Create(name, vector)
			_InsertParam(param)
		Else
			param.Set(vector)
		End If
	End Method
	
	Rem
		bbdoc: Get a Vec2 param from the material.
		returns: A TProtogVec2Param for the given name, or Null if the given name was not found within the material.
		about: NOTE: This will throw an exception if it finds a parameter with the name given that is @not a TProtogVec2Param.
	End Rem
	Method GetVec2Param:TProtogVec2Param(name:String)
		Local param:TProtogParam = TProtogParam(_ValueByKey(name))
		Local vparam:TProtogVec2Param = TProtogVec2Param(param)
		If vparam = Null And param <> Null
			Throw("(duct.protog2d.TProtogMaterial.GetVec2Param) Parameter of name '" + name + "' is not a TProtogVec2Param!~n" + ..
				"~t[param.ParamType() = " + param.ParamType() + "]")
		End If
		Return vparam
	End Method
	
	Rem
		bbdoc: Set a Vec3 value in the material.
		returns: Nothing.
	End Rem
	Method SetVec3(name:String, vector:TVec3)
		Local param:TProtogVec3Param = GetVec3Param(name)
		If param = Null
			param = New TProtogVec3Param.Create(name, vector)
			_InsertParam(param)
		Else
			param.Set(vector)
		End If
	End Method
	
	Rem
		bbdoc: Get a Vec3 param from the material.
		returns: A TProtogVec3Param for the given name, or Null if the given name was not found within the material.
		about: NOTE: This will throw an exception if it finds a parameter with the name given that is @not a TProtogVec3Param.
	End Rem
	Method GetVec3Param:TProtogVec3Param(name:String)
		Local param:TProtogParam = TProtogParam(_ValueByKey(name))
		Local vparam:TProtogVec3Param = TProtogVec3Param(param)
		If vparam = Null And param <> Null
			Throw("(duct.protog2d.TProtogMaterial.GetVec3Param) Parameter of name '" + name + "' is not a TProtogVec3Param!~n" + ..
				"~t[param.ParamType() = " + param.ParamType() + "]")
		End If
		Return vparam
	End Method
	
	Rem
		bbdoc: Set a Vec4 value in the material.
		returns: Nothing.
	End Rem
	Method SetVec4(name:String, vector:TVec4)
		Local param:TProtogVec4Param = GetVec4Param(name)
		If param = Null
			param = New TProtogVec4Param.Create(name, vector)
			_InsertParam(param)
		Else
			param.Set(vector)
		End If
	End Method
	
	Rem
		bbdoc: Get a Vec4 param from the material.
		returns: A TProtogVec4Param for the given name, or Null if the given name was not found within the material.
		about: NOTE: This will throw an exception if it finds a parameter with the name given that is @not a TProtogVec4Param.
	End Rem
	Method GetVec4Param:TProtogVec4Param(name:String)
		Local param:TProtogParam = TProtogParam(_ValueByKey(name))
		Local vparam:TProtogVec4Param = TProtogVec4Param(param)
		If vparam = Null And param <> Null
			Throw("(duct.protog2d.TProtogMaterial.GetVec4Param) Parameter of name '" + name + "' is not a TProtogVec4Param!~n" + ..
				"~t[param.ParamType() = " + param.ParamType() + "]")
		End If
		Return vparam
	End Method
	
	Rem
		bbdoc: Set a texture value in the material.
		returns: Nothing.
	End Rem
	Method SetTexture(name:String, texture:TProtogTexture)
		Local param:TProtogTextureParam = GetTextureParam(name)
		If param = Null
			param = New TProtogTextureParam.Create(name, texture)
			_InsertParam(param)
		Else
			param.Set(texture)
		End If
	End Method
	
	Rem
		bbdoc: Get a texture param from the material.
		returns: A TProtogTextureParam for the given name, or Null if the given name was not found within the material.
		about: NOTE: This will throw an exception if it finds a parameter with the name given that is @not a TProtogTextureParam.
	End Rem
	Method GetTextureParam:TProtogTextureParam(name:String)
		Local param:TProtogParam = TProtogParam(_ValueByKey(name))
		Local vparam:TProtogTextureParam = TProtogTextureParam(param)
		If vparam = Null And param <> Null
			Throw("(duct.protog2d.TProtogMaterial.GetTextureParam) Parameter of name '" + name + ..
				"' is not a TProtogTextureParam!~n" + ..
				"~t[param.ParamType() = " + param.ParamType() + "]")
		End If
		Return vparam
	End Method
	
	Method _InsertParam(param:TProtogParam)
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

