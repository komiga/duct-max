
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
	
	program.bmx (Contains: TGLSLProgram, TShaderAssist, )
	
	TODO:
		[TGLSLProgram] Add a shader header containing the default vertex shader attributes and common uniforms
		
End Rem

Rem
	bbdoc: A high-level wrapper for OpenGL GLSL shader programs.
End Rem
Type TGLSLProgram
	
	Field m_handle:Int
	Field m_validated:Int
	
	Field m_material:TGLMaterial, m_params:TGLSLParamMap
	
		Method New()
			m_params = New TGLSLParamMap.Create()
		End Method
		
		Method Delete()
			Destroy()
		End Method
		
		Rem
			bbdoc: Create a new #{TGLSLProgram} from the given shader sources.
			returns: The new program (itself).
			about: The material given is expected to already have the parameters set for the uniforms in the shader(s).<br />
			Warning: An exception will be thrown if any of the parameters are Null.
		End Rem
		Method CreateFromSources:TGLSLProgram(vert_source:String, frag_source:String, material:TGLMaterial)
			
			If vert_source <> Null And frag_source <> Null And material <> Null
				Local vert_shader:Int, frag_shader:Int
				
				m_material = material
				
				vert_shader = TShaderAssist.CompileShader(GL_VERTEX_SHADER, vert_source)
				frag_shader = TShaderAssist.CompileShader(GL_FRAGMENT_SHADER, frag_source)
				
				m_handle = TShaderAssist.LinkProgram(vert_shader, frag_shader)
				
				glDeleteShader(vert_shader)
				glDeleteShader(frag_shader)
				
				Local uniforms:Int = 0, unit:Int = -1
				GetIntParameter(GL_ACTIVE_UNIFORMS, Varptr(uniforms))
				
				Local name:Byte[], name_max_len:Int, sname:String
				GetIntParameter(GL_ACTIVE_UNIFORM_MAX_LENGTH, Varptr(name_max_len))
				For Local i:Int = 0 To uniforms - 1
					Local size:Int, utype:Int, location:Int
					Local param:TGLParam, glslparam:TGLSLParam
					
					name = New Byte[name_max_len]
					glGetActiveUniform(m_handle, i, name_max_len - 1, Null, Varptr(size), Varptr(utype), name)
					
					sname = String.FromBytes(name, name_max_len - 1)
					
					DebugLog("(duct.protog2d.TGLSLProgram.CreateFromSources) name = " + sname)
					
					' Skip over standard OpenGL uniforms
					If sname.StartsWith("gl_") = True
						Continue
					End If
					
					location = GetUniformLocationFromName(sname)
					
					DebugLog("(duct.protog2d.TGLSLProgram.CreateFromSources) location = " + String(location) + " i = " + String(i))
					
					Select utype
						Case GL_FLOAT
							param = m_material.GetFloatParam(sname)
						Case GL_FLOAT_VEC2
							param = m_material.GetVec2Param(sname)
						Case GL_FLOAT_VEC3
							param = m_material.GetVec3Param(sname)
						Case GL_FLOAT_VEC4
							param = m_material.GetVec4Param(sname)
						'Case GL_FLOAT_MAT4
						'	...
						Case GL_SAMPLER_2D', GL_SAMPLER_2D_RECT_ARB
							param = m_material.GetTextureParam(sname)
							unit:+1
							
						Default
							DebugLog("(duct.protog2d.TGLSLProgram.CreateFromSources) Failed to recognize uniform type " + String(utype) + " (not supported)")
							
					End Select
					
					If param = Null
						Throw("(duct.protog2d.TGLSLProgram.CreateFromSources) Failed to retrieve parameter of type " + String(utype))
					End If
					
					'CParam * p = CParam::ForName(name)
					'params.push_back(p)
					'GLParam * glp = New GLParam(p, size, utype, glGetUniformLocation(m_handle, name), unit)
					
					glslparam = New TGLSLParam.Create(sname, param, location, utype, size, unit)
					m_params.Insert(glslparam)
					
				Next
				
				'CheckGL()
				
			Else
				Throw("(duct.protog2d.TGLSLProgram.CreateFromSources) Failed to create shader, either one of the shader sources or the material is Null~n" + ..
					"~t['@vert_source=Null'~t= " + String(vert_source = Null) + "~n" + ..
					"~t'@frag_source=Null'~t= " + String(frag_source = Null) + "~n" + ..
					"~t'@material=Null'~t=" + String(material = Null) + "]")
			End If
			
			Return Self
		End Method
		
		Rem
			bbdoc: Create a new #{TGLSLProgram} from the given shader source files.
			returns: The new program (itself).
			about: See #{CreateFromSources} for more information.
		End Rem
		Method CreateFromSourceFiles:TGLSLProgram(vert_url:Object, frag_url:Object, material:TGLMaterial)
			Local vert_source:String, frag_source:String
			vert_source = TShaderAssist.SourceFromFile(vert_url)
			frag_source = TShaderAssist.SourceFromFile(frag_url)
			Return CreateFromSources(vert_source, frag_source, material)
		End Method
		
		Rem
			bbdoc: Create a new #{TGLSLProgram} from the given dual shader source.
			returns: The new program (itself).
			about: See #{CreateFromSources} for more information.
		End Rem
		Method CreateFromDualSource:TGLSLProgram(source:String, material:TGLMaterial)
			Local vert_source:String, frag_source:String
			TShaderAssist.SplitDualShaderSource(source, vert_source, frag_source)
			Return CreateFromSources(vert_source, frag_source, material)
		End Method
		
		Rem
			bbdoc: Create a new #{TGLSLProgram} from the given dual shader source file.
			returns: The new program (itself).
			about: See #{CreateFromSources} for more information.
		End Rem
		Method CreateFromDualFile:TGLSLProgram(url:Object, material:TGLMaterial)
			Local vert_source:String, frag_source:String
			TShaderAssist.SplitDualShaderFile(url, vert_source, frag_source)
			Return CreateFromSources(vert_source, frag_source, material)
		End Method
		
		Rem
			bbdoc: Destroy the #{TGLSLProgram}.
			returns: Nothing.
		End Rem
		Method Destroy()
			If m_handle <> 0
				glDeleteProgram(m_handle)
				m_handle = 0
			End If
		End Method
		
		Rem
			bbdoc: Activate the program.
			returns: Nothing.
		End Rem
		Method Activate()
			glUseProgram(m_handle)
		End Method
		
		Rem
			bbdoc: Deactivate the program.
			returns: Nothing.
		End Rem
		Method Deactivate()
			glUseProgram(0)
		End Method
		
		'#region Field accessors
		Rem
			bbdoc: Get an integer parameter for the program.
			returns: Nothing.
		End Rem
		Method GetIntParameter:Int(param:Int, data:Int Ptr)
			glGetProgramiv(m_handle, param, data)
		End Method
		
		Rem
			bbdoc: Get the handle for the program.
			returns: The handle for the program.
		End Rem
		Method GetHandle:Int()
			Return m_handle
		End Method
		
		Rem
			bbdoc: Get the program's material.
			returns: The material for the program.
		End Rem
		Method GetMaterial:TGLMaterial()
			Return m_material
		End Method
		
		'#end region (Field accessors)
		
		'#region Uniform/Attribute handlers
		
		Rem
			bbdoc: Get the location of an attribute from the name given.
			returns: The location for the attribute, or -1 if no attribute with the given 
				name exists (or the name is prepended by "gl_" - which is reserved for internal use by OpenGL).
		End Rem
		Method GetAttribLocationFromName:Int(name:String)
			glGetAttribLocation(m_handle, name.ToCString())
		End Method
		
		Rem
			bbdoc: Get the location of a uniform from the name given.
			returns: The location for the uniform, or -1 if no uniform with the given 
				name exists (or the name is prepended by "gl_" - which is reserved for internal use by OpenGL).
		End Rem
		Method GetUniformLocationFromName:Int(name:String)
			Return glGetUniformLocation(m_handle, name.ToCString())
		End Method
		
		'#end region (Uniform/Attribute handlers)
		
End Type

Rem
	bbdoc: Some assistant functions for #{TGLSLProgram}.
End Rem
Type TShaderAssist
	
	Rem
		bbdoc: Create and link a program to the two given shader handles.
		returns: The program's handle (may throw an exception if the program could not be linked - the exception's string will contain the program's infolog).
	End Rem
	Function LinkProgram:Int(vert_shader:Int, frag_shader:Int)
		Local program:Int, status:Int
		
		program = glCreateProgram()
		
		glAttachShader(program, vert_shader)
		glAttachShader(program, frag_shader)
		
	'	glBindAttribLocation(program, 0, "Attrib0")
	'	glBindAttribLocation(program, 1, "Attrib1")
	'	glBindAttribLocation(program, 2, "Attrib2")
	'	glBindAttribLocation(program, 3, "Attrib3")
	'	glBindAttribLocation(program, 4, "Attrib4")
	'	glBindAttribLocation(program, 5, "Attrib5")
	'	glBindAttribLocation(program, 6, "Attrib6")
	'	glBindAttribLocation(program, 7, "Attrib7")
	'	glBindAttribLocation(program, 0, "bb_Vertex")
	'	glBindAttribLocation(program, 1, "bb_Normal")
	'	glBindAttribLocation(program, 2, "bb_Tangent")
	'	glBindAttribLocation(program, 3, "bb_TexCoords0")
	'	glBindAttribLocation(program, 4, "bb_TexCoords1")
	'	glBindAttribLocation(program, 5, "bb_Weights")
	'	glBindAttribLocation(program, 6, "bb_Bones")
		
		glLinkProgram(program)
		
		glGetProgramiv(program, GL_LINK_STATUS, Varptr(status))
		
		If status = False
			
			Throw("(duct.protog2d.LinkProgram) Failed to link program~n" + ..
					"Infolog:~n" + ProgramInfoLog(program))
			
		End If
		
		Return program
		
	End Function
	
	Rem
		bbdoc: Get the shader program infolog.
		returns: The infolog for the given shader program handle.
	End Rem
	Function ProgramInfoLog:String(program:Int)
		Local buf:Byte[2048]
		
		glGetProgramInfoLog(program, 2047, Null, buf)
		
		Return String.FromBytes(buf, 2047)
		
	End Function
	
	Rem
		bbdoc: Compile a shader to the given type and with the given source.
		returns: The shader handle (may throw an exception if an error occured - the exception string will contain the shader's infolog).
	End Rem
	Function CompileShader:Int(shader_type:Int, shader_source:String)
		Local shader:Int, status:Int
		Local csource:Byte Ptr = shader_source.ToCString()
		
		shader = glCreateShader(shader_type)
		glShaderSource(shader, 1, Varptr(csource), Null)
		glCompileShader(shader)
		
		glGetShaderiv(shader, GL_COMPILE_STATUS, Varptr(status))
		
		If status = False
			Local stream:TRamStream, n:Int
			Print("Shader source:")
			stream = CreateRamStream(shader_source, shader_source.Length, True, False)
			While stream.Eof() = False
				Print(n + ":~t" + stream.ReadLine())
				n:+1
			Wend
			stream.Close()
			Throw("(duct.protog2d.CompileShader) Failed to compile shader~n" + ..
					"Infolog:~n" + ShaderInfoLog(shader))
		End If
		
		Return shader
		
	End Function
	
	Rem
		bbdoc: Get the info log for a shader.
		returns: A string containing the infolog for the given shader handle.
	End Rem
	Function ShaderInfoLog:String(shader:Int)
		Local buf:Byte[2048]
		glGetShaderInfoLog(shader, 2047, Null, buf)
		Return String.FromBytes(buf, 2047)
	End Function
	
	Rem
		bbdoc: Read shader source from a file (separates lines by "~n").
		returns: The source from the given file (may throw an exception if the stream could not be opened).
	End Rem
	Function SourceFromFile:String(url:Object)
		Local stream:TStream, source:String
		
		stream = ReadStream(url)
		
		If stream <> Null
			While stream.Eof() = False
				source:+stream.ReadLine() + "~n"
			Wend
			stream.Close()
			Return source
		Else
			Throw("(duct.protog2d.SourceFromFile) Failed to open source file: " + url.ToString())
		End If
		
	End Function
	
	Rem
		bbdoc: Seperate/split a dual shader source string into two separate strings.
		returns: Nothing.
		about: A dual shader contains both the fragment and vertex shaders in one file (seperated by the '//@common', '//@vertex' and '//@fragment' comments; ala bmx3d).
	End Rem
	Function SplitDualShaderSource(source:String, vert_source:String Var, frag_source:String Var)
		Local set:Int = -1, common_source:String
		Local stream:TRamStream, temp:String
		
		If source <> Null
			stream = CreateRamStream(source, source.Length, True, False)
			While stream.Eof() = False
				temp = stream.ReadLine()
				If temp.Find("//@common") = 0
					set = 0
				Else If temp.Find("//@vertex") = 0
					set = 1
				Else If temp.Find("//@fragment") = 0
					set = 2
				Else If set = 0
					common_source:+temp + "~n"
				Else If set = 1
					vert_source:+temp + "~n"
				Else If set = 2
					frag_source:+temp + "~n"
				End If
			Wend
			
			stream.Close()
			
			vert_source = common_source + vert_source
			frag_source = common_source + frag_source
		Else
			Throw("(duct.protog2d.SplitDualShaderSource) Failed to split shader source, @source = Null")
		End If
		
	End Function
	
	Rem
		bbdoc: Seperate/split a dual shader file into two separate strings.
		returns: Nothing.
		about: A dual shader contains both the fragment and vertex shaders in one file (seperated by the '//@vertex' and '//@fragment' comments; ala bmx3d).
	End Rem
	Function SplitDualShaderFile(url:Object, vert_source:String Var, frag_source:String Var)
		Local source:String
		source = SourceFromFile(url)
		SplitDualShaderSource(source, vert_source, frag_source)
	End Function
	
End Type























































