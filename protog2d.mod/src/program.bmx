
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
	bbdoc: A high-level wrapper for OpenGL GLSL shaders.
End Rem
Type dProtogShader
	
	Field m_handle:Int
	Field m_validated:Int
	
	Field m_material:dProtogMaterial, m_params:dProtogShaderParamMap
	
	Method New()
		m_params = New dProtogShaderParamMap
	End Method
	
	Method Delete()
		Destroy()
	End Method
	
'#region Constructors and deconstructor
	
	Rem
		bbdoc: Create a shader from the given shader sources.
		returns: Itself.
		about: The material given is expected to already have the parameters set for the uniforms in the shader(s).<br>
		Warning: An exception will be thrown if any of the parameters are Null.
	End Rem
	Method CreateFromSources:dProtogShader(vert_source:String, frag_source:String, material:dProtogMaterial)
		If (vert_source Or frag_source) And material
			Local vert_shader:Int, frag_shader:Int
			m_material = material
			If vert_source
				vert_shader = dShaderAssist.CompileShader(GL_VERTEX_SHADER, vert_source)
			End If
			If frag_source
				frag_shader = dShaderAssist.CompileShader(GL_FRAGMENT_SHADER, frag_source)
			End If
			DebugLog("(dProtogShader.CreateFromSources) vert_shader <> 0 = " + vert_shader <> 0 + " frag_shader <> 0 = " + frag_shader <> 0)
			m_handle = dShaderAssist.LinkProgram(vert_shader, frag_shader)
			
			If vert_shader
				glDeleteShader(vert_shader)
			End If
			If frag_shader
				glDeleteShader(frag_shader)
			End If
			dProtog2DDriver.SetupHeader(m_material)
			
			Local uniforms:Int = 0, unit:Int = 0
			GetIntParameter(GL_ACTIVE_UNIFORMS, Varptr(uniforms))
			Local name:Byte[], name_max_len:Int, sname:String
			GetIntParameter(GL_ACTIVE_UNIFORM_MAX_LENGTH, Varptr(name_max_len))
			For Local i:Int = 0 Until uniforms
				Local size:Int, utype:Int, location:Int
				Local param:dProtogParam, sparam:dProtogShaderParam
				name = New Byte[name_max_len]
				glGetActiveUniform(m_handle, i, name_max_len, Null, Varptr(size), Varptr(utype), name)
				sname = String.FromCString(name) ' dShaderAssist.NullishBytesToString(name)
				'sname = String.FromCString(name)
				'sname = String.FromBytes(name, name_max_len - 1)
				
				DebugLog("(dProtogShader.CreateFromSources) size = " + size + " utype = " + utype + " name_max_len = " + name_max_len + " length = " + sname.Length)
				DebugLog("(dProtogShader.CreateFromSources) sname = ~q" + sname + "~q")
				' Skip over standard OpenGL uniforms
				If sname.StartsWith("gl_") = True ' Or sname.StartsWith("p2d_") = True
					Continue
				End If
				
				location = GetUniformLocationFromName(sname)
				DebugLog("(dProtogShader.CreateFromSources) location = " + String(location) + " i = " + String(i))
				If location = -1
					Throw "(dProtogShader.CreateFromSources) Location is -1, uniform name string corrupt"
				End If
				
				Local pname:String, bloc:Int
				bloc = sname.Find("[")
				If bloc > -1
					pname = sname[..bloc]
				Else
					pname = sname
				End If
				Select utype
					Case GL_INT, GL_FLOAT, GL_FLOAT_VEC2, GL_FLOAT_VEC3, GL_FLOAT_VEC4
						param = m_material.GetParam(pname)
					'Case GL_FLOAT_MAT4
					'	...
					Case GL_SAMPLER_2D, GL_SAMPLER_2D_RECT_ARB
						Local texparam:dProtogTextureParam
						texparam = m_material.GetTextureParam(pname)
						If texparam
							Local texture:dGLTexture
							If texparam.m_texture
								texture = texparam.m_texture.m_gltexture
							End If
							If texture
								Select utype
									Case GL_SAMPLER_2D
										If texture.m_target <> GL_TEXTURE_2D
											Throw "(dProtogShader.CreateFromSources) [GL_SAMPLER_2D] Param texture target does not match `" + sname + "`'s target"
										End If
									Case GL_SAMPLER_2D_RECT_ARB
										If texture.m_target <> GL_TEXTURE_RECTANGLE_EXT
											Throw "(dProtogShader.CreateFromSources) [GL_SAMPLER_2D_RECT_ARB] Param texture target does not match `" + sname + "`'s target"
										End If
								End Select
								param = texparam
								unit:+ 1
							Else
								DebugLog("(dProtogShader.CreateFromSources) Texture for parameter is Null (" + String(sname) + ")")
							End If
						Else
							DebugLog("(dProtogShader.CreateFromSources) Could not get parameter as texture parameter (" + String(sname) + ")")
						End If
					Default
						DebugLog("(dProtogShader.CreateFromSources) Failed to recognize uniform type " + String(utype) + " (not supported)")
				End Select
				If Not param
					Throw "(dProtogShader.CreateFromSources) Failed to retrieve parameter of type " + String(utype) + "; sname = " + sname + "; pname = " + pname
				End If
				sparam = New dProtogShaderParam.Create(sname, param, location, utype, size, unit)
				m_params.Insert(sparam)
				DebugLog(sparam.ToString())
			Next
		Else
			Throw "(dProtogShader.CreateFromSources) Failed to create shader, either one of the shader sources or the material is Null~n" + ..
				"~t['@vert_source=Null'~t= " + String(vert_source = Null) + "~n" + ..
				"~t'@frag_source=Null'~t= " + String(frag_source = Null) + "~n" + ..
				"~t'@material=Null'~t= " + String(material = Null) + "]"
		End If
		Return Self
	End Method
	
	Rem
		bbdoc: Create a shader from the given shader source files.
		returns: Itself.
		about: See #CreateFromSources for more information.
	End Rem
	Method CreateFromSourceFiles:dProtogShader(vert_path:String, frag_path:String, material:dProtogMaterial)
		Local vert_source:String, frag_source:String
		If vert_path
			vert_source = dShaderAssist.SourceFromFile(vert_path, True)
		End If
		If frag_path
			frag_source = dShaderAssist.SourceFromFile(frag_path, True)
		End If
		Return CreateFromSources(vert_source, frag_source, material)
	End Method
	
	Rem
		bbdoc: Create a shader from the given dual shader source.
		returns: Itself.
		about: See #CreateFromSources for more information.
	End Rem
	Method CreateFromDualSource:dProtogShader(source:String, material:dProtogMaterial, use_vertex:Int = True, use_fragment:Int = True)
		Local shader:_dShaderSource = dShaderAssist.SplitDualShaderSource(source)
		If Not use_vertex
			shader.m_vert = Null
		End If
		If Not use_fragment
			shader.m_frag = Null
		End If
		Return CreateFromSources(shader.m_vert, shader.m_frag, material)
	End Method
	
	Rem
		bbdoc: Create a shader from the given dual shader source file.
		returns: Itself.
		about: See #CreateFromSources for more information.
	End Rem
	Method CreateFromDualFile:dProtogShader(path:String, material:dProtogMaterial, use_vertex:Int = True, use_fragment:Int = True)
		Local shader:_dShaderSource
		shader = dShaderAssist.SplitDualShaderFile(path)
		If Not use_vertex
			shader.m_vert = Null
		End If
		If Not use_fragment
			shader.m_frag = Null
		End If
		Return CreateFromSources(shader.m_vert, shader.m_frag, material)
	End Method
	
	Rem
		bbdoc: Destroy the shader.
		returns: Nothing.
	End Rem
	Method Destroy()
		If m_handle <> 0
			glDeleteProgram(m_handle)
			m_handle = 0
		End If
	End Method
	
'#end region Constructors and deconstructor
	
'#region Shader function
	
	Rem
		bbdoc: Activate the shader.
		returns: Nothing.
	End Rem
	Method Activate()
		Local sparam:dProtogShaderParam
		glUseProgram(m_handle)
		For sparam = EachIn m_params.ValueEnumerator()
			sparam.Bind()
		Next
	End Method
	
	Rem
		bbdoc: Deactivate the shader program.
		returns: Nothing.
	End Rem
	Method Deactivate()
		Local sparam:dProtogShaderParam
		For sparam = EachIn m_params.ValueEnumerator()
			sparam.Unbind()
		Next
		glUseProgram(0)
	End Method
	
'#end region Shader function
	
'#region Field accessors
	
	Rem
		bbdoc: Get an integer parameter for the shader.
		returns: Nothing.
	End Rem
	Method GetIntParameter:Int(param:Int, data:Int Ptr)
		glGetProgramiv(m_handle, param, data)
	End Method
	
	Rem
		bbdoc: Get the handle for the shader.
		returns: The handle for the shader.
	End Rem
	Method GetHandle:Int()
		Return m_handle
	End Method
	
	Rem
		bbdoc: Get the shader's material.
		returns: The material for the shader.
	End Rem
	Method GetMaterial:dProtogMaterial()
		Return m_material
	End Method
	
'#end region Field accessors
	
'#region Uniform/Attribute handlers
	
	Rem
		bbdoc: Get the location of an attribute from the name given.
		returns: The location for the attribute, or -1 if no attribute with the given 
		name exists (or the name is prepended by "gl_" - which is reserved for internal use by OpenGL).
	End Rem
	Method GetAttribLocationFromName:Int(name:String)
		Local namec:Byte Ptr = name.ToCString()
		Local attrib:Int
		attrib = glGetAttribLocation(m_handle, namec)
		MemFree(namec)
		Return attrib
	End Method
	
	Rem
		bbdoc: Get the location of a uniform from the name given.
		returns: The location for the uniform, or -1 if no uniform with the given 
		name exists (or the name is prepended by "gl_" - which is reserved for internal use by OpenGL).
	End Rem
	Method GetUniformLocationFromName:Int(name:String)
		Local namec:Byte Ptr = name.ToCString()
		Local uni:Int
		uni = glGetUniformLocation(m_handle, namec)
		MemFree(namec)
		Return uni
	End Method
	
'#end region Uniform/Attribute handlers
	
End Type

Rem
	bbdoc: Some assistant functions for #dProtogShader.
End Rem
Type dShaderAssist
	
	Const m_le:String = "~n"
	Const shader_header:String = "// Shader header" + m_le + ..
		"//@common" + m_le + ..
		"#version 120" + m_le + ..
		"#extension GL_ARB_texture_rectangle : enable" + m_le + ..
		"" + m_le + ..
		"uniform vec2 p2d_windowsize;" + m_le + ..
		"uniform vec2 p2d_viewportposition;" + m_le + ..
		"uniform sampler2DRect p2d_rendertexture;" + m_le + ..
		"uniform vec2 p2d_viewportsize;" + m_le + ..
		m_le
	
	Rem
		bbdoc: Create and link a program to the two given shader handles.
		returns: the shader's handle (may throw an exception if the shader could not be linked - the exception's string will contain the shader's infolog).
	End Rem
	Function LinkProgram:Int(vert_shader:Int, frag_shader:Int)
		Local program:Int = glCreateProgram()
		If vert_shader <> 0
			glAttachShader(program, vert_shader)
		End If
		If frag_shader <> 0
			glAttachShader(program, frag_shader)
		End If
		
		'glBindAttribLocation(program, 0, "Attrib0")
		'glBindAttribLocation(program, 1, "Attrib1")
		'glBindAttribLocation(program, 2, "Attrib2")
		'glBindAttribLocation(program, 3, "Attrib3")
		'glBindAttribLocation(program, 4, "Attrib4")
		'glBindAttribLocation(program, 5, "Attrib5")
		'glBindAttribLocation(program, 6, "Attrib6")
		'glBindAttribLocation(program, 7, "Attrib7")
		'glBindAttribLocation(program, 0, "p2d_Vertex")
		'glBindAttribLocation(program, 1, "p2d_Normal")
		'glBindAttribLocation(program, 2, "p2d_Tangent")
		'glBindAttribLocation(program, 3, "p2d_TexCoords0")
		'glBindAttribLocation(program, 4, "p2d_TexCoords1")
		'glBindAttribLocation(program, 5, "p2d_Weights")
		'glBindAttribLocation(program, 6, "p2d_Bones")
		
		Local status:Int
		glLinkProgram(program)
		glGetProgramiv(program, GL_LINK_STATUS, Varptr(status))
		If status = False
			Throw "(dShaderAssist.LinkProgram) Failed to link program~nInfolog:~n" + ProgramInfoLog(program)
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
		Local csource:Byte Ptr = shader_source.ToCString()
		Local shader:Int = glCreateShader(shader_type)
		glShaderSource(shader, 1, Varptr(csource), Null)
		glCompileShader(shader)
		MemFree(csource)
		Local status:Int
		glGetShaderiv(shader, GL_COMPILE_STATUS, Varptr(status))
		If status = False
			Local stream:TRamStream, n:Int = 1
			Print("Shader source:")
			stream = CreateRamStream(shader_source, shader_source.Length, True, False)
			While stream.Eof() = False
				Print(n + ":~t" + stream.ReadLine())
				n:+1
			Wend
			stream.Close()
			Throw "(dShaderAssist.CompileShader) Failed to compile shader~nInfolog:~n" + ShaderInfoLog(shader)
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
		bbdoc: Read shader source from a file (separates lines by #m_le).
		returns: The source from the given file (may throw an exception if the stream could not be opened).
	End Rem
	Function SourceFromFile:String(path:String, header:Int)
		Local source:String
		If header
			source = shader_header
		End If
		Local stream:TStream = ReadStream(path)
		If stream
			While Not stream.Eof()
				source:+ stream.ReadLine() + m_le
			Wend
			stream.Close()
			Return source
		Else
			Throw "(dShaderAssist.SourceFromFile) Failed to open source file: " + path
		End If
	End Function
	
	Rem
		bbdoc: Seperate/split a dual shader source string into two separate strings.
		returns: A _dShaderSource containing both sources.
		about: A dual shader contains both the fragment and vertex shaders in one file (seperated by the '//@common', '//@vertex' and '//@fragment' comments; ala bmx3d).
	End Rem
	Function SplitDualShaderSource:_dShaderSource(source:String)
		Local set:Int = -1, common_source:String = shader_header
		Local stream:TRamStream, temp:String
		Local shader:_dShaderSource
		If source
			shader = New _dShaderSource
			stream = CreateRamStream(source, source.Length, True, False)
			While stream.Eof() = False
				temp = stream.ReadLine()
				If temp.Find("//@common") = 0
					common_source:+ temp + m_le
					set = 0
				Else If temp.Find("//@vertex") = 0
					shader.m_vert:+ temp + m_le
					set = 1
				Else If temp.Find("//@fragment") = 0
					shader.m_frag:+ temp + m_le
					set = 2
				Else If set = 0
					common_source:+ temp + m_le
				Else If set = 1
					shader.m_vert:+ temp + m_le
				Else If set = 2
					shader.m_frag:+ temp + m_le
				End If
			Wend
			stream.Close()
			shader.m_vert = common_source + shader.m_vert
			shader.m_frag = common_source + shader.m_frag
			Return shader
		Else
			Throw "(dShaderAssist.SplitDualShaderSource) Failed to split shader source, @source = Null"
		End If
	End Function
	
	Rem
		bbdoc: Seperate/split a dual shader file into two separate strings.
		returns: A _dShaderSource containing both sources.
		about: A dual shader contains both the fragment and vertex shaders in one file (seperated by the '//@common', '//@vertex' and '//@fragment' comments; ala bmx3d).
	End Rem
	Function SplitDualShaderFile:_dShaderSource(path:String)
		Local source:String = SourceFromFile(path, False)
		Return SplitDualShaderSource(source)
	End Function
	
	'Rem
	'	bbdoc: Convert the given byte array to a Null-removed string.
	'	returns: Nothing.
	'End Rem
	'Function NullishBytesToString:String(bytes:Byte[])
	'	'Local index:Int
	'	'For index = 0 To bytes.length - 1
	'		'DebugLog("(dShaderAssist.NullishBytesToString) index = " + index + " bytes[index] = " + bytes[index])
	'		'If bytes[index] = 0
	'		'	Exit
	'		'End If
	'	'Next
	'	Return String.FromCString(bytes) 'String.FromBytes(bytes, index)
	'End Function
	
End Type

Type _dShaderSource
	Field m_vert:String
	Field m_frag:String
End Type

