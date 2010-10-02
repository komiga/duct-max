
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
	bbdoc: Protog2D framebuffer object (FBO) type.
End Rem
Type dProtogFrameBuffer
	
	Field m_handle:Int, m_seq:Int
	
	' 4 possible colorbuffers (should be a decent maximum, especially for old hardware)
	Field m_colorbuffers:dProtogTexture[4] ', m_depthbuffer:dProtogTexture
	Field m_glbuffers:Int[4]
	
	Method New()
		m_handle = -1
		m_seq = GraphicsSeq
	End Method
	
	Method Delete()
		Destroy()
	End Method
	
	Rem
		bbdoc: Destroy the framebuffer.
		returns: Nothing.
	End Rem
	Method Destroy()
		'DebugLog("(dProtogFrameBuffer.Destroy) m_handle = " + m_handle + " m_seq " + m_seq + " GraphicsSeq = " + GraphicsSeq)
		If m_handle <> -1 And m_seq = GraphicsSeq
			Bind()
			' Detach all attached textures
			For Local index:Int = 0 Until m_colorbuffers.Length
				DetachTexture(index)
			Next
			' Delete the framebuffer
			glDeleteFramebuffersEXT(1, Varptr(m_handle))
			Unbind()
			m_handle = -1
			m_seq = 0
		End If
	End Method
	
	Rem
		bbdoc: Create a new dProtogFrameBuffer and set the buffers to the given array.
		returns: The new dProtogFrameBuffer (itself).
	End Rem
	Method Create:dProtogFrameBuffer(colorbuffers:dProtogTexture[])
		glGenFramebuffersEXT(1, Varptr(m_handle))
		glBindFramebufferEXT(GL_FRAMEBUFFER_EXT, m_handle)
		SetColorBuffers(colorbuffers)
		'If depthbuffer
		'	m_depthbuffer = depthbuffer
		'	glFramebufferTexture2DEXT(GL_FRAMEBUFFER_EXT, GL_DEPTH_ATTACHMENT_EXT, depthbuffer.m_target, depthbuffer.m_handle, 0)
		'End If
		'If glCheckFramebufferStatusEXT(GL_FRAMEBUFFER_EXT) <> GL_FRAMEBUFFER_COMPLETE_EXT
		'	Throw("(dProtogFrameBuffer.Create) glCheckFramebufferStatusEXT <> GL_FRAMEBUFFER_COMPLETE_EXT")
		'End If
		Unbind()
		dProtog2DDriver.CheckForErrors("dProtogFrameBuffer.Create::end")
		Return Self
	End Method
	
'#region OpenGL
	
	Rem
		bbdoc: Bind the texture at the given index.
		returns: Nothing.
		about: The @index parameter must be 0-3 (%{instead of} a GL_COLOR_ATTACHMENT<b><i>n</i></b>_EXT constant).<br/>
		An exception will be asserted if the index is out of bounds (only in debug mode).<br/>
		If the value at the given index is Null nothing will happen.
	End Rem
	Method BindTexture(index:Int, enabletarget:Int = True)
		Assert index > -1 And index < 4, "(dProtogFrameBuffer.BindTexture) @index (=" + String(index) + ") is not within bounds! (it must be 0-3)"
		If m_glbuffers[index] <> GL_NONE
			m_colorbuffers[index].Bind(enabletarget)
		End If
	End Method
	
	Rem
		bbdoc: Unbind the texture at the given index.
		returns: Nothing.
		about: The @index parameter must be 0-3 (%{instead of} a GL_COLOR_ATTACHMENT<b><i>n</i></b>_EXT constant).<br/>
		An exception will be asserted if the index is out of bounds (only in debug mode).<br/>
		If the value at the given index is Null nothing will happen.
	End Rem
	Method UnbindTexture(index:Int)
		Assert index > -1 And index < 4, "(dProtogFrameBuffer.BindTexture) @index (=" + String(index) + ") is not within bounds! (it must be 0-3)"
		If m_glbuffers[index] <> GL_NONE
			m_colorbuffers[index].Unbind()
		End If
	End Method
	
	Rem
		bbdoc: Bind the framebuffer.
		returns: Nothing.
	End Rem
	Method Bind()
		If m_handle <> -1 And m_seq = GraphicsSeq
			glBindFramebufferEXT(GL_FRAMEBUFFER_EXT, m_handle)
			BindRenderBuffer()
		Else
			DebugLog("(dProtogFrameBuffer.Bind) Unable to bind (invalid graphics context): m_handle = " + m_handle + " m_seq = " + m_seq + " GraphicsSeq = " + GraphicsSeq)
		End If
	End Method
	
	Rem
		bbdoc: Bind the render buffer.
		returns: Nothing.
	End Rem
	Method BindRenderBuffer()
		If m_handle <> -1 And m_seq = GraphicsSeq
			glDrawBuffers(m_glbuffers.Length, m_glbuffers)
		Else
			DebugLog("(dProtogFrameBuffer.BindRenderBuffer) Unable to set render buffers (invalid graphics context): m_handle = " + m_handle + " m_seq = " + m_seq + " GraphicsSeq = " + GraphicsSeq)
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
		bbdoc: Render the framebuffer with the given dimensions.
		returns: Nothing.
		about: If @buffer is -1, no texture will be bound (allowing you to do batch render, by having the texture already bound), otherwise, it is used as the index for the texture to be bound.
	End Rem
	Method Render(quad:dVec4, buffer:Int, enabletarget:Int = True)
		If buffer > -1
			BindTexture(buffer, enabletarget)
		End If
		If dProtog2DDriver.GetActiveTexture()
			dProtog2DDriver.GetActiveTexture().Render(quad, True)
		Else
			DebugLog("(dProtogFrameBuffer.Render) Did not render dimensions - no active texture!")
		End If
		If buffer > -1
			UnbindTexture(buffer)
		End If
	End Method
	
'#end region (OpenGL)
	
'#region Color buffer
	
	Rem
		bbdoc: Set the render buffer for the framebuffer.
		returns: Nothing.
		about: The given array must be 4 elements.
	End Rem
	Method SetRenderBuffer(array:Int[])
		If array.Length = 4
			m_glbuffers = array
		Else
			DebugLog("(dProtogFrameBuffer.SetRenderBuffer) Unable to set render buffers (array length is not 4)")
		End If
	End Method
	
	Rem
		bbdoc: Set the colorbuffers array.
		returns: Nothing.
		about: The given array must be 4 elements.
	End Rem
	Method SetColorBuffers(colorbuffers:dProtogTexture[])
		If colorbuffers.Length = 4
			For Local index:Int = 0 Until colorbuffers.Length
				DetachTexture(index)
				If colorbuffers[index] = Null
					m_glbuffers[index] = GL_NONE
				Else
					AttachTexture(index, colorbuffers[index], False)
				End If
			Next
		Else
			DebugLog("(dProtogFrameBuffer.SetColorBuffers) Unable to set color buffers (array length is not 4)")
		End If
	End Method
	
	Rem
		bbdoc: Get the colorbuffer texture at the given index.
		returns: The texture at the given index.
	End Rem
	Method GetTexture:dProtogTexture(index:Int)
		Assert index > -1 And index < 4, "(dProtogFrameBuffer.GetTexture) @index (=" + String(index) + ") is not within bounds! (it must be 0-3)"
		Return m_colorbuffers[index]
	End Method
	
	Rem
		bbdoc: Attach a colorbuffer texture to the framebuffer at the given index.
		returns: Nothing.
		about: The @index parameter must be 0-3 (%{instead of} a GL_COLOR_ATTACHMENT<b><i>n</i></b>_EXT constant).<br/>
		An exception will be asserted if the index is out of bounds (only in debug mode).<br/>
		If you attempt to set a texture to an index which already has a texture, this method will silently return (use the @override parameter to override this behavior).
	End Rem
	Method AttachTexture(index:Int, texture:dProtogTexture, override:Int = False)
		Assert index > -1 And index < 4, "(dProtogFrameBuffer.AttachTexture) @index (=" + String(index) + ") is not within bounds! (it must be 0-3)"
		Assert texture, "(dProtogFrameBuffer.AttachTexture) @texture is Null!"
		If Not m_colorbuffers[index] Or override = True
			If m_colorbuffers[index]
				DetachTexture(index)
			End If
			glFramebufferTexture2DEXT(GL_FRAMEBUFFER_EXT, GL_COLOR_ATTACHMENT0_EXT + index, texture.m_gltexture.m_target, texture.m_gltexture.m_handle, 0)
			Local err:Int = glCheckFramebufferStatusEXT(GL_FRAMEBUFFER_EXT)
			If err <> GL_FRAMEBUFFER_COMPLETE_EXT
				Throw("(dProtogFrameBuffer.AttachTexture) glCheckFramebufferStatusEXT <> GL_FRAMEBUFFER_COMPLETE_EXT; GL_Error = " + dProtog2DDriver.CheckForErrors("FBO.AttachTexture::checkfbostatus", False) + " ; err = " + err)
			End If
			m_colorbuffers[index] = texture
			m_glbuffers[index] = GL_COLOR_ATTACHMENT0_EXT + index
		End If
	End Method
	
	Rem
		bbdoc: Detach a colorbuffer texture at the given index.
		returns: Nothing.
		about: The @index parameter must be 0-3 (%{instead of} a GL_COLOR_ATTACHMENT<b><i>n</i></b>_EXT constant).<br/>
		An exception will be asserted if the index is out of bounds (only in debug mode).
	End Rem
	Method DetachTexture(index:Int)
		Assert index > -1 And index < 4, "(dProtogFrameBuffer.DetachTexture) @index (=" + String(index) + ") is not within bounds! (it must be 0-3)"
		If m_colorbuffers[index]
			glFramebufferTexture2DEXT(GL_FRAMEBUFFER_EXT, GL_COLOR_ATTACHMENT0_EXT + index, m_colorbuffers[index].m_gltexture.m_target, 0, 0)
			m_colorbuffers[index] = Null
			m_glbuffers[index] = GL_NONE
		End If
	End Method
	
'#end region (Color buffer)
	
End Type

