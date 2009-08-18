
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
	
	fbo.bmx (Contains: TProtogFrameBuffer, )
	
	TODO:
		
	
End Rem

Rem
	bbdoc: Protog2D framebuffer object (FBO) type.
End Rem
Type TProtogFrameBuffer
	
	Field m_handle:Int, m_seq:Int
	
	' 4 possible colorbuffers (should be a decent maximum, especially for old hardware)
	Field m_colorbuffers:TGLTexture[4]
	
		Method New()
			m_handle = -1
			m_seq = GraphicsSeq
			glGenFramebuffersEXT(1, Varptr(m_handle))
		End Method
		
		Method Delete()
			Destroy()
		End Method
		
		Rem
			bbdoc: Destroy the framebuffer.
			returns: Nothing.
		End Rem
		Method Destroy()
			If m_handle <> - 1 And m_seq = GraphicsSeq
				Local index:Int
				
				UnBind()
				
				' Detach all attached textures
				For index = 0 To m_colorbuffers.Length - 1
					DetachTexture(index)
				Next
				
				' Delete the framebuffer
				glDeleteFramebuffersEXT(1, Varptr(m_handle))
				m_handle = -1
			End If
		End Method
		
		Rem
			bbdoc: Bind the texture at the given index.
			returns: Nothing.
			about: The @index parameter must be 0-3 (%{instead of} a GL_COLOR_ATTACHMENT<b><i>n</i></b>_EXT constant).<br />
			An exception will be asserted if the index is out of bounds (only in debug mode).<br />
			If the value at the given index is Null nothing will happen.
		End Rem
		Method BindTexture(index:Int)
			
			Assert index > - 1 And index < 4,  ..
				"(duct.Protog2D.TProtogFrameBuffer.AttachTexture) @index (=" + String(index) + ") is not within bounds! (it must be 0-3)"
			
			If m_colorbuffers[index] <> Null
				m_colorbuffers[index].Bind()
			End If
			
		End Method
		
		Rem
			bbdoc: Bind the framebuffer.
			returns: Nothing.
		End Rem
		Method Bind()
			If m_handle <> - 1
				glBindFramebufferEXT(GL_FRAMEBUFFER_EXT, m_handle)
			End If
		End Method
		
		Rem
			bbdoc: Unbind any set framebuffer.
			returns: Nothing.
		End Rem
		Function Unbind()
			glBindFramebufferEXT(GL_FRAMEBUFFER_EXT, 0)
		End Function
		
		Rem
			bbdoc: Set the current target buffers for the framebuffer.
			returns: Nothing.
			about: If a single colorbuffer has not been set, GL_NONE will be in its place for the set buffer.
		End Rem
		Method SetDrawBuffers()
			Local buffers:Int[4], index:Int
			
			For index = 0 To m_colorbuffers.Length - 1
				If m_colorbuffers[index] <> Null
					buffers[index] = GL_COLOR_ATTACHMENT0_EXT + index
				Else
					buffers[index] = GL_NONE
				End If
			Next
			
			glDrawBuffers(buffers.Length, buffers)
			
		End Method
		
		Rem
			bbdoc: Attach a colorbuffer texture to the framebuffer at the given index.
			returns: Nothing.
			about: The @index parameter must be 0-3 (%{instead of} a GL_COLOR_ATTACHMENT<b><i>n</i></b>_EXT constant).<br />
			An exception will be asserted if the index is out of bounds (only in debug mode).<br />
			If you attempt to set a texture to an index which already has a texture, this method will silently return (use the @override parameter to override this behavior).
		End Rem
		Method AttachTexture(index:Int, texture:TGLTexture, override:Int = False)
			
			Assert index > - 1 And index < 4,  ..
				"(duct.Protog2D.TProtogFrameBuffer.AttachTexture) @index (=" + String(index) + ") is not within bounds! (it must be 0-3)"
			
			If m_colorbuffers[index] = Null Or override = True
				glFramebufferTexture2DEXT(GL_FRAMEBUFFER_EXT, GL_COLOR_ATTACHMENT0_EXT + index, GL_TEXTURE_2D, texture.m_handle, 0)
				
				Assert glCheckFramebufferStatusEXT(GL_FRAMEBUFFER_EXT) = GL_FRAMEBUFFER_COMPLETE_EXT,  ..
					"(duct.Protog2D.TProtogFrameBuffer.AttachTexture) glCheckFramebufferStatusEXT <> GL_FRAMEBUFFER_COMPLETE_EXT"
				
				m_colorbuffers[index] = texture
				
			End If
			
		End Method
		
		Rem
			bbdoc: Detach a colorbuffer texture at the given index.
			returns: Nothing.
			about: The @index parameter must be 0-3 (%{instead of} a GL_COLOR_ATTACHMENT<b><i>n</i></b>_EXT constant).<br />
			An exception will be asserted if the index is out of bounds (only in debug mode).
		End Rem
		Method DetachTexture(index:Int)
			
			Assert index > - 1 And index < 4,  ..
				"(duct.Protog2D.TProtogFrameBuffer.DetachTexture) @index (=" + String(index) + ") is not within bounds! (it must be 0-3)"
			
			If m_colorbuffers[index] <> Null
				glFramebufferTexture2DEXT(GL_FRAMEBUFFER_EXT, GL_COLOR_ATTACHMENT0_EXT + index, GL_TEXTURE_2D, 0, 0)
				m_colorbuffers[index] = Null
			End If
			
		End Method
		
End Type


























































