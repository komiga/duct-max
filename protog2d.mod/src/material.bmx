
Rem
Copyright (c) 2010 plash <plash@komiga.com>

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
	bbdoc: Protog's material type; Stores #dProtogParam objects for rendering properties.<br>
	about: See #dProtogParam for more information on the specific types of parameters.
End Rem
Type dProtogMaterial Extends dObjectMap
	
	Field m_name:String
	
	Rem
		bbdoc: Create a material.
		returns: Itself.
	End Rem
	Method Create:dProtogMaterial(name:String = Null)
		SetName(name)
		Return Self
	End Method
	
'#region Collections
	
	Rem
		bbdoc: Get a param from the material.
		returns: A dProtogParam for the given name, or Null if the given name was not found within the material.
	End Rem
	Method GetParam:dProtogParam(name:String)
		Return dProtogParam(_ObjectWithKey(name))
	End Method
	
	Rem
		bbdoc: Set an int value in the material.
		returns: Nothing.
	End Rem
	Method SetInt(name:String, value:Int)
		Local param:dProtogIntParam = GetIntParam(name)
		If Not param
			param = New dProtogIntParam.Create(name, value)
			_InsertParam(param)
		Else
			param.Set(value)
		End If
	End Method
	
	Rem
		bbdoc: Get an int param from the material.
		returns: A dProtogIntParam for the given name, or Null if the given name was not found within the material.
		about: NOTE: This will throw an exception if it finds a parameter with the name given that is @not a dProtogFloatParam.
	End Rem
	Method GetIntParam:dProtogIntParam(name:String)
		Local param:dProtogParam = dProtogParam(_ObjectWithKey(name))
		Local iparam:dProtogIntParam = dProtogIntParam(param)
		If iparam And param
			Throw "(duct.protog2d.dProtogMaterial.GetIntParam) Parameter of name '" + name + "' is not a dProtogIntParam!~n~t[param.ParamType() = " + param.ParamType() + "]"
		End If
		Return iparam
	End Method
	
	Rem
		bbdoc: Set a float value in the material.
		returns: Nothing.
	End Rem
	Method SetFloat(name:String, value:Float)
		Local param:dProtogFloatParam = GetFloatParam(name)
		If Not param
			param = New dProtogFloatParam.Create(name, value)
			_InsertParam(param)
		Else
			param.Set(value)
		End If
	End Method
	
	Rem
		bbdoc: Get a float param from the material.
		returns: A dProtogFLoatParam for the given name, or Null if the given name was not found within the material.
		about: NOTE: This will throw an exception if it finds a parameter with the name given that is @not a dProtogFloatParam.
	End Rem
	Method GetFloatParam:dProtogFloatParam(name:String)
		Local param:dProtogParam = dProtogParam(_ObjectWithKey(name))
		Local fparam:dProtogFloatParam = dProtogFloatParam(param)
		If Not fparam And param
			Throw "(duct.protog2d.dProtogMaterial.GetFloatParam) Parameter of name '" + name + "' is not a dProtogFloatParam!~n~t[param.ParamType() = " + param.ParamType() + "]"
		End If
		Return fparam
	End Method
	
	Rem
		bbdoc: Set a color value in the material.
		returns: Nothing.
	End Rem
	Method SetColor(name:String, color:dProtogColor)
		Local param:dProtogColorParam = GetColorParam(name)
		If Not param
			param = New dProtogColorParam.Create(name, color)
			_InsertParam(param)
		Else
			param.Set(color)
		End If
	End Method
	
	Rem
		bbdoc: Get a color param from the material.
		returns: A dProtogColorParam for the given name, or Null if the given name was not found within the material.
		about: NOTE: This will throw an exception if it finds a parameter with the name given that is @not a dProtogColorParam.
	End Rem
	Method GetColorParam:dProtogColorParam(name:String)
		Local param:dProtogParam = dProtogParam(_ObjectWithKey(name))
		Local vparam:dProtogColorParam = dProtogColorParam(param)
		If Not vparam And param
			Throw "(duct.protog2d.dProtogMaterial.GetColorParam) Parameter of name '" + name + "' is not a dProtogColorParam!~n~t[param.ParamType() = " + param.ParamType() + "]"
		End If
		Return vparam
	End Method
	
	Rem
		bbdoc: Set a Vec2 value in the material.
		returns: Nothing.
	End Rem
	Method SetVec2(name:String, vector:dVec2)
		Local param:dProtogVec2Param = GetVec2Param(name)
		If Not param
			param = New dProtogVec2Param.Create(name, vector)
			_InsertParam(param)
		Else
			param.Set(vector)
		End If
	End Method
	
	Rem
		bbdoc: Get a Vec2 param from the material.
		returns: A dProtogVec2Param for the given name, or Null if the given name was not found within the material.
		about: NOTE: This will throw an exception if it finds a parameter with the name given that is @not a dProtogVec2Param.
	End Rem
	Method GetVec2Param:dProtogVec2Param(name:String)
		Local param:dProtogParam = dProtogParam(_ObjectWithKey(name))
		Local vparam:dProtogVec2Param = dProtogVec2Param(param)
		If Not vparam And param
			Throw "(duct.protog2d.dProtogMaterial.GetVec2Param) Parameter of name '" + name + "' is not a dProtogVec2Param!~n~t[param.ParamType() = " + param.ParamType() + "]"
		End If
		Return vparam
	End Method
	
	Rem
		bbdoc: Set a Vec3 value in the material.
		returns: Nothing.
	End Rem
	Method SetVec3(name:String, vector:dVec3)
		Local param:dProtogVec3Param = GetVec3Param(name)
		If Not param
			param = New dProtogVec3Param.Create(name, vector)
			_InsertParam(param)
		Else
			param.Set(vector)
		End If
	End Method
	
	Rem
		bbdoc: Get a Vec3 param from the material.
		returns: A dProtogVec3Param for the given name, or Null if the given name was not found within the material.
		about: NOTE: This will throw an exception if it finds a parameter with the name given that is @not a dProtogVec3Param.
	End Rem
	Method GetVec3Param:dProtogVec3Param(name:String)
		Local param:dProtogParam = dProtogParam(_ObjectWithKey(name))
		Local vparam:dProtogVec3Param = dProtogVec3Param(param)
		If Not vparam And param
			Throw "(duct.protog2d.dProtogMaterial.GetVec3Param) Parameter of name '" + name + "' is not a dProtogVec3Param!~n~t[param.ParamType() = " + param.ParamType() + "]"
		End If
		Return vparam
	End Method
	
	Rem
		bbdoc: Set a Vec4 value in the material.
		returns: Nothing.
	End Rem
	Method SetVec4(name:String, vector:dVec4)
		Local param:dProtogVec4Param = GetVec4Param(name)
		If Not param
			param = New dProtogVec4Param.Create(name, vector)
			_InsertParam(param)
		Else
			param.Set(vector)
		End If
	End Method
	
	Rem
		bbdoc: Get a Vec4 param from the material.
		returns: A dProtogVec4Param for the given name, or Null if the given name was not found within the material.
		about: NOTE: This will throw an exception if it finds a parameter with the name given that is @not a dProtogVec4Param.
	End Rem
	Method GetVec4Param:dProtogVec4Param(name:String)
		Local param:dProtogParam = dProtogParam(_ObjectWithKey(name))
		Local vparam:dProtogVec4Param = dProtogVec4Param(param)
		If Not vparam And param
			Throw "(duct.protog2d.dProtogMaterial.GetVec4Param) Parameter of name '" + name + "' is not a dProtogVec4Param!~n~t[param.ParamType() = " + param.ParamType() + "]"
		End If
		Return vparam
	End Method
	
	Rem
		bbdoc: Set a texture value in the material.
		returns: Nothing.
	End Rem
	Method SetTexture(name:String, texture:dProtogTexture)
		Local param:dProtogTextureParam = GetTextureParam(name)
		If Not param
			param = New dProtogTextureParam.Create(name, texture)
			_InsertParam(param)
		Else
			param.Set(texture)
		End If
	End Method
	
	Rem
		bbdoc: Get a texture param from the material.
		returns: A dProtogTextureParam for the given name, or Null if the given name was not found within the material.
		about: NOTE: This will throw an exception if it finds a parameter with the name given that is @not a dProtogTextureParam.
	End Rem
	Method GetTextureParam:dProtogTextureParam(name:String)
		Local param:dProtogParam = dProtogParam(_ObjectWithKey(name))
		Local vparam:dProtogTextureParam = dProtogTextureParam(param)
		If Not vparam And param
			Throw "(duct.protog2d.dProtogMaterial.GetTextureParam) Parameter of name '" + name + "' is not a dProtogTextureParam!~n~t[param.ParamType() = " + param.ParamType() + "]"
		End If
		Return vparam
	End Method
	
	Method _InsertParam(param:dProtogParam)
		_Insert(param.m_name, param)
	End Method
	
'#end region Collections
	
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
	
'#end region Field accessors
	
End Type

