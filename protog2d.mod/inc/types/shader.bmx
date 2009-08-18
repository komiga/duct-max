
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
	
	shader.bmx (Contains: TGLSLShader, )
	
	TODO:
		
	
End Rem

Rem
	bbdoc: The OpenGL GLSLShader type.
	about: This type is a high-level wrapper for OpenGL GLSL shaders.
End Rem
Type TGLSLShader
	
	Field m_type:Int
	Field m_handle:Int, m_compiled:Int
	
		Method New()
		End Method
		
		Method Delete()
			
			Destroy()
			
		End Method
		
		Rem
			bbdoc: Create a new shader.
			returns: The new shader (itself).
		End Rem
		Method Create:TGLSLShader(shadertype:Int)
			
			m_type = shadertype
			m_handle = glCreateShader(shadertype)
			
			Return Self
			
		End Method
		
		Rem
			bbdoc: Delete/destroy the shader.
			returns: Nothing.
		End Rem
		Method Destroy()
			
			glDeleteShader(m_handle)
			m_handle = -1
			
		End Method
		
		Rem
			bbdoc: Compile the shader.
			returns: True if the shader was successfully compiled, or False if it failed to compile.
			about: NOTE: You can also check if the shader was compiled by using #IsCompiled.
		End Rem
		Method Compile:Int()
			
			glCompileShader(m_handle)
  			GetIntParameter(GL_COMPILE_STATUS, Varptr(m_compiled))
			
			Return m_compiled
			
		End Method
		
		'#region Field accessors
		
		Rem
			bbdoc: Set the source code for the shader.
			returns: Nothing.
		End Rem
		Method SetSource(source:String)
			Local zsource:Byte Ptr
			
			zsource = source.ToCString()
			
			glShaderSource(m_handle, 1, Varptr(zsource), Null)
			
		End Method
		
		Rem
			bbdoc: Get the shader's source code.
			returns: The shader's source code.
		End Rem
		Method GetSource:String()
			Local source:Byte Ptr, length:Int
			
			GetIntParameter(GL_SHADER_SOURCE_LENGTH, Varptr(length))
			
			glGetShaderSource(m_handle, 1, Varptr(length), source)
			
			Return String.FromBytes(source, length)
			
		End Method
		
		Rem
			bbdoc: Get an integer parameter for the shader.
			returns: Nothing.
		End Rem
		Method GetIntParameter:Int(param:Int, data:Int Ptr)
			
			glGetShaderiv(m_handle, param, data)
			
		End Method
		
		Rem
			bbdoc: Get the log for the shader (shows any linking/compiling errors).
			returns: The log for the shader.
		End Rem
		Method GetLog:String()
			Local infolog:Byte Ptr, length:Int
			
			GetIntParameter(GL_INFO_LOG_LENGTH, Varptr(length))
			
			'infolog = New Byte[length]
			glGetShaderInfoLog(m_handle, length, Varptr(length), infolog)
			
			Return String.FromBytes(infolog, length)
			
		End Method
		
		Rem
			bbdoc: Get the shader's type (either GL_VERTEX_SHADER or GL_FRAGMENT_SHADER).
			returns: The shader's type (vertex or fragment).
		End Rem
		Method GetType:Int()
			
			Return m_type
			
		End Method
		
		Rem
			bbdoc: Check if the shader has been compiled.
			returns: Nothing.
		End Rem
		Method IsCompiled:Int()
			
			Return m_compiled
			
		End Method
		
		Rem
			bbdoc: Get the shader's handle.
			returns: The shader's handle.
		End Rem
		Method GetHandle:Int()
			
			Return m_handle
			
		End Method
		
		'#end region
		
		Rem
			bbdoc: Seperate/split a dual shader source string into two separate strings.
			returns: Nothing.
			about: A dual shader contains both the fragment and vertex shaders in one file (seperated by the '//@vertex' and '//@fragment' comments; ala bmx3d).
		End Rem
		Function SplitDualShaderSource(source:String, fragment_source:String Var, vertex_source:String Var)
			Local stream:TRamStream
			
			stream = CreateRamStream(source, source.Length, True, False)
			
			While stream.Eof() = False
				
				
				
			Wend
			
			stream.Close()
			
		End Function
		
		Rem
			bbdoc: Seperate/split a dual shader file into two separate strings.
			returns: Nothing.
			about: A dual shader contains both the fragment and vertex shaders in one file (seperated by the '//@vertex' and '//@fragment' comments; ala bmx3d).
		End Rem
		Function SplitDualShaderFile(url:String, fragment_source:String Var, vertex_source:String Var)
			
			
			
		End Function
		
End Type
























































