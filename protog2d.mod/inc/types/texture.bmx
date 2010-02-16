
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
	
	texture.bmx (Contains: TGLTexture, TProtogTexture, TProtogAnimTexture, )
	
	TODO:
		
	
End Rem

Rem
	bbdoc: The texture mipmap flag.
	about: If this flag is set to a texture, the pixmap data will be mipmapped upon generating the texture.
End Rem
Const TEXTURE_MIPMAP:Int = 1
Rem
	bbdoc: The texture filter flag.
	about: If this flag is set to a texture, the pixmap data will be filtered upon generating the texture.
End Rem
Const TEXTURE_FILTER:Int = 2
Rem
	bbdoc: The rectangular texture flag.
	about: If this flag is set to a texture, the pixmap uploaded to the texture will be left as-is (instead of being power-of-two'd -- the normal behavior of textures).
End Rem
Const TEXTURE_RECTANGULAR:Int = 4

Rem
	bbdoc: Texture format A8.
End Rem
Const FORMAT_A8:Int = 1
Rem
	bbdoc: Texture format I8.
End Rem
Const FORMAT_I8:Int = 2
Rem
	bbdoc: Texture format L8.
End Rem
Const FORMAT_L8:Int = 3
Rem
	bbdoc: Texture format LA8.
End Rem
Const FORMAT_LA8:Int = 4
Rem
	bbdoc: Texture format RGB8.
End Rem
Const FORMAT_RGB8:Int = 5
Rem
	bbdoc: Texture format RGBA8.
End Rem
Const FORMAT_RGBA8:Int = 6
Rem
	bbdoc: Texture format RGB10A2.
End Rem
Const FORMAT_RGB10A2:Int = 7
Rem
	bbdoc: Texture format RGBA16F.
End Rem
Const FORMAT_RGBA16F:Int = 8
Rem
	bbdoc: Texture format DEPTH.
End Rem
Const FORMAT_DEPTH:Int = 9

Rem
	bbdoc: OpenGL texture handle (name) wrapper.
End Rem
Type TGLTexture
	
	Field m_format:Int
	
	Field m_handle:Int, m_seq:Int
	Field m_target:Int
	
	Field m_uv:TVec4
	
	Method New()
		m_uv = New TVec4.Create(0.0, 0.0, 1.0, 1.0)
		m_seq = GraphicsSeq
	End Method
	
	Method Delete()
		Destroy()
	End Method
	
	Method Destroy()
		If m_handle <> 0 And m_seq = GraphicsSeq
			glDeleteTextures(1, Varptr(m_handle))
			m_handle = 0
			m_seq = 0
			m_target = 0
		End If
	End Method
	
'#region Constructors
	
	Rem
		bbdoc: Create a new GLTexture from the OpenGL texture handle given.
		returns: The new GLTexture (itself).
	End Rem
	Method CreateFromHandle:TGLTexture(handle:Int, uv:TVec4, format:Int = FORMAT_RGBA8, target:Int)
		m_handle = handle
		m_uv = uv.Copy()
		m_format = format
		m_target = target
		Return Self
	End Method
	
	Rem
		bbdoc: Create the texture from the size given.
		returns: Nothing.
	End Rem
	Method CreateFromSize:TGLTexture(width:Int, height:Int, flags:Int, format:Int = FORMAT_RGBA8)
		Local texture_width:Int, texture_height:Int
		
		texture_width = width
		texture_height = height
		
		m_format = format
		If flags & TEXTURE_RECTANGULAR
			m_target = GL_TEXTURE_RECTANGLE_EXT
			'm_format = FORMAT_RGBA8 'FORMAT_RGBA16F
		Else
			m_target = GL_TEXTURE_2D
			'm_format = FORMAT_RGBA8
		End If
		
		If flags & TEXTURE_RECTANGULAR = False
			AdjustTexSize(texture_width, texture_height)
			m_uv.m_z = Float(Min(width, texture_width)) / Float(texture_width)
			m_uv.m_w = Float(Min(height, texture_height)) / Float(texture_height)
		Else
			m_uv.m_z = Float(texture_width)
			m_uv.m_w = Float(texture_height)
		End If
		
		m_handle = GenTexture(texture_width, texture_height, m_target, m_format, flags)
		TProtog2DDriver.UnbindTextureTarget(m_target)
		
		Return Self
	End Method
	
	Rem
		bbdoc: Create a GLTexture from the given pixmap.
		returns: The new GLTexture (itself).
	End Rem
	Method CreateFromPixmap:TGLTexture(pixmap:TPixmap, flags:Int, format:Int = FORMAT_RGBA8)
		Local texture_pixmap:TPixmap
		Local texture_width:Int, texture_height:Int
		
		texture_pixmap = pixmap
		texture_width = pixmap.width
		texture_height = pixmap.height
		
		m_format = format
		If flags & TEXTURE_RECTANGULAR
			m_target = GL_TEXTURE_RECTANGLE_EXT
			'm_format = FORMAT_RGBA8 'FORMAT_RGBA16F
		Else
			m_target = GL_TEXTURE_2D
			'm_format = FORMAT_RGBA8
		End If
		
		If flags & TEXTURE_RECTANGULAR = False
			
			' Adjust the pixmap's size (to the next power-of-two)
			AdjustTexSize(texture_width, texture_height)
			
			' Make sure pixmap fits the texture
			Local width:Int = Min(pixmap.width, texture_width)
			Local height:Int = Min(pixmap.height, texture_height)
			If pixmap.width <> width Or pixmap.height <> height
				pixmap = ResizePixmap(pixmap, width, height)
			End If
			
			' Smear the right/bottom edges if necessary
			If texture_width > width Or texture_height > height
				texture_pixmap = TPixmap.Create(texture_width, texture_height, PF_RGBA8888)
				texture_pixmap.Paste(pixmap, 0, 0)
				
				If texture_width > width
					texture_pixmap.Paste(pixmap.Window(width - 1, 0, 1, height), width, 0)
				End If
				If texture_height > height
					texture_pixmap.Paste(pixmap.Window(0, height - 1, width, 1), 0, height)
					If texture_width > width
						texture_pixmap.Paste(pixmap.Window(width - 1, height - 1, 1, 1), width, height)
					End If
				End If
			End If
			
			m_uv.m_z = Float(width) / Float(texture_width)
			m_uv.m_w = Float(height) / Float(texture_height)
		Else
			m_uv.m_z = Float(texture_width)
			m_uv.m_w = Float(texture_height)
		End If
		
		' Create the handle
		m_handle = GenTexture(texture_width, texture_height, m_target, m_format, flags)
		
		' Upload the pixmap to the new handle
		UploadTex(texture_pixmap, m_target, m_format, flags)
		TProtog2DDriver.UnbindTextureTarget(m_target)
		Return Self
	End Method
	
'#end region (Constructors)
	
	Rem
		bbdoc: Bind the texture.
		returns: Nothing.
	End Rem
	Method Bind(enabletarget:Int = True)
		TProtog2DDriver.BindTexture(Self, enabletarget)
		'glBindTexture(GL_TEXTURE_2D, m_handle)
		'TProtog2DDriver.CheckForErrors("GLTexture.Bind::end")
	End Method
	
	Rem
		bbdoc: Unbind the texture's target.
		returns: Nothing.
	End Rem
	Method Unbind()
		TProtog2DDriver.UnbindTextureTarget(m_target)
	End Method
	
	Rem
		bbdoc: Render the texture (does not bind the texture).
		returns: Nothing.
	End Rem
	Method Render(quad:TVec4, flipped:Int = False)
		glBegin(GL_QUADS)
			If flipped = False
				glTexCoord2f(m_uv.m_x, m_uv.m_y) ; glVertex2f(quad.m_x, quad.m_y)
				glTexCoord2f(m_uv.m_z, m_uv.m_y) ; glVertex2f(quad.m_z, quad.m_y)
				glTexCoord2f(m_uv.m_z, m_uv.m_w) ; glVertex2f(quad.m_z, quad.m_w)
				glTexCoord2f(m_uv.m_x, m_uv.m_w) ; glVertex2f(quad.m_x, quad.m_w)
			Else If flipped = True
				glTexCoord2f(m_uv.m_x, m_uv.m_w) ; glVertex2f(quad.m_x, quad.m_y)
				glTexCoord2f(m_uv.m_z, m_uv.m_w) ; glVertex2f(quad.m_z, quad.m_y)
				glTexCoord2f(m_uv.m_z, m_uv.m_y) ; glVertex2f(quad.m_z, quad.m_w)
				glTexCoord2f(m_uv.m_x, m_uv.m_y) ; glVertex2f(quad.m_x, quad.m_w)
			End If
		glEnd()
	End Method
	
'#region Field accessors
	
	Rem
		bbdoc: Set the UV mapping vector for this GLTexture.
		returns: Nothing.
		about: NOTE: This does not make a copy of the given vector (if you're 
		passing a vector that you plan to reuse, you should pass in a copy of it instead).
	End Rem
	Method SetUV(vector:TVec4)
		m_uv = vector
	End Method
	Rem
		bbdoc: Get the UV mapping vector for this GLTexture.
		returns: The UV mapping vector for this GLTexture.
		about: NOTE: The vector returned is not a copy.
	End Rem
	Method GetUV:TVec4()
		Return m_uv
	End Method
	
'#end region (Field accessors)
	
'#region Initiation
	
	Rem
		bbdoc: Generate the texture and set parameters.
		returns: The texture's handle (aka name).
	End Rem
	Function GenTexture:Int(width:Int, height:Int, target:Int, format:Int, flags:Int)
		Local name:Int
		
		glGenTextures(1, Varptr(name))
		TProtog2DDriver.BindTextureHandle(target, name)
		
		' Set texture parameters
		glTexParameteri(target, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE)
		glTexParameteri(target, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE)
		If flags & TEXTURE_FILTER
			glTexParameteri(target, GL_TEXTURE_MAG_FILTER, GL_LINEAR)
			If flags & TEXTURE_MIPMAP
				glTexParameteri(target, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR)
			Else
				glTexParameteri(target, GL_TEXTURE_MIN_FILTER, GL_LINEAR)
			End If
		Else
			glTexParameteri(target, GL_TEXTURE_MAG_FILTER, GL_NEAREST)
			If flags & TEXTURE_MIPMAP
				glTexParameteri(target, GL_TEXTURE_MIN_FILTER, GL_NEAREST_MIPMAP_NEAREST)
			Else
				glTexParameteri(target, GL_TEXTURE_MIN_FILTER, GL_NEAREST)
			End If
		End If
'		TProtog2DDriver.CheckForErrors("GenTexture::2")
'		If flags & TEXTURE_MIPMAP
'			Local mip_level:Int, intformat:Int
'			Repeat
'				glTexImage2D(target, mip_level, intformat, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, Null)
'				If Not (flags & TEXTURE_MIPMAP) Exit
'				If width = 1 And height = 1 Then Exit
'				If width > 1 Then width:/2
'				If height > 1 Then height:/2
'				
'				mip_level:+1
'			Forever
'		End If
		
		'DebugLog("(TGLTexture.GenTexture) format = " + format + " target = " + target + " width = " + width + " height = " + height)
		glTexImage2D(target, 0, FormatToInternalFormat(format), width, height, 0, FormatToDataFormat(format), GL_UNSIGNED_BYTE, Null)
		
		TProtog2DDriver.CheckForErrors("GenTexture::end")
		Return name
	End Function
	
	Rem
		bbdoc: Upload the given pixmap to the bound texture.
		returns: Nothing.
	End Rem
	Function UploadTex(pixmap:TPixmap, target:Int, format:Int, flags:Int)
		Local mip_level:Int
		
		Assert FormatToDataFormat(format) = GL_RGBA, "(TProtogTexture.UploadTex) Cannot use format other than GL_RGBA for uploading"
		
		If pixmap.format <> PF_RGBA8888
			pixmap = pixmap.Convert(PF_RGBA8888)
		End If
		
		Repeat
			glPixelStorei(GL_UNPACK_ROW_LENGTH, pixmap.pitch / BytesPerPixel[PF_RGBA8888])
			glTexSubImage2D(target, mip_level, 0, 0, pixmap.width, pixmap.height, GL_RGBA, GL_UNSIGNED_BYTE, pixmap.pixels)
			'glTexSubImage2DEXT()
			
			If flags & TEXTURE_MIPMAP = False
				Exit
			End If
			
			If pixmap.width > 1 And pixmap.height > 1
				pixmap = ResizePixmap(pixmap, pixmap.width / 2, pixmap.height / 2)
			Else If pixmap.width > 1
				pixmap = ResizePixmap(pixmap, pixmap.width / 2, pixmap.height)
			Else If pixmap.height > 1
				pixmap = ResizePixmap(pixmap, pixmap.width, pixmap.height / 2)
			Else
				Exit
			End If
			
			mip_level:+1
		Forever
		
		glPixelStorei(GL_UNPACK_ROW_LENGTH, 0)
		TProtog2DDriver.CheckForErrors("UploadTex::end")
		
	End Function
	
	Rem
		bbdoc: Adjust the given texture size.
		returns: Nothing, @width and @height are changed.
	End Rem
	Function AdjustTexSize(width:Int Var, height:Int Var)
		width = Pow2Size(width)
		height = Pow2Size(height)
		
		width = Max(1, width)
		width = Min(width, TProtog2DDriver.GetMaxTextureSize())
		height = Max(1, height)
		height = Min(height, TProtog2DDriver.GetMaxTextureSize())
	End Function
	
'#end region (Initiation)
	
'#region Format
	
	Rem
		bbdoc: Get the internal (OpenGL) format for the given texture format.
		returns: The internal format for the given texture format.
	End Rem
	Function FormatToInternalFormat:Int(format:Int)
		Select format
			Case FORMAT_A8
				Return GL_ALPHA8
			Case FORMAT_I8
				Return GL_INTENSITY8
			Case FORMAT_L8
				Return GL_LUMINANCE8
			Case FORMAT_LA8
				Return GL_LUMINANCE8_ALPHA8
			Case FORMAT_RGB8
				Return GL_RGB8
			Case FORMAT_RGBA8
				Return GL_RGBA8
			Case FORMAT_RGB10A2
				Return GL_RGB10_A2
			Case FORMAT_RGBA16F
				Return GL_RGBA16F_ARB
			Case FORMAT_DEPTH
				Return GL_DEPTH_COMPONENT
		End Select
		Return 0
	End Function
	
	Rem
		bbdoc: Get the data (image/pixmap) format for the given texture format.
		returns: The data format for the given texture format.
	End Rem
	Function FormatToDataFormat:Int(format:Int)
		Select format
			Case FORMAT_A8
				Return GL_ALPHA
			Case FORMAT_I8
				Return GL_INTENSITY
			Case FORMAT_L8
				Return GL_LUMINANCE
			Case FORMAT_LA8
				Return GL_LUMINANCE_ALPHA
			Case FORMAT_RGB8
				Return GL_RGB
			Case FORMAT_RGBA8
				Return GL_RGBA
			Case FORMAT_RGB10A2
				Return GL_RGBA
			Case FORMAT_RGBA16F
				Return GL_RGBA
			Case FORMAT_DEPTH
				Return GL_DEPTH_COMPONENT
		End Select
		Return 0
	End Function
	
	Rem
		bbdoc: Get the number of bytes-per-texel for the given texture format.
		returns: The number of bytes that fit into a texel for the given texture format.
	End Rem
	Function FormatBytesPerTexel:Int(format:Int)
		Select format
			Case FORMAT_A8
				Return 1
			Case FORMAT_I8
				Return 1
			Case FORMAT_L8
				Return 1
			Case FORMAT_LA8
				Return 2
			Case FORMAT_RGB8
				Return 3
			Case FORMAT_RGBA8
				Return 4
			Case FORMAT_RGB10A2
				Return 4
			Case FORMAT_RGBA16F
				Return 8
			Case FORMAT_DEPTH
				Return 0
		End Select
		Return 0
	End Function
	
'#end region (Format)
	
End Type

Rem
	bbdoc: Single-texture wrapper for #TGLTexture.
End Rem
Type TProtogTexture
	
	Field m_pixmap:TPixmap
	Field m_gltexture:TGLTexture
	
	Field m_width:Int, m_height:Int, m_flags:Int
	
	Method New()
	End Method
	
'#region Constructors and deconstructor
	
	Rem
		bbdoc: Create a TProtogTexture.
		returns: The new TProtogTexture (itself).
		about: If @upload is True the pixmap will be uploaded to OpenGL (creates the GL texture).
	End Rem
	Method Create:TProtogTexture(pixmap:TPixmap, flags:Int, upload:Int = True)
		m_flags = flags
		SetPixmap(pixmap, upload)
		Return Self
	End Method
	
	Rem
		bbdoc: Create a TProtogTexture with the given TGLTexture.
		returns: The new TProtogTexture (itself).
	End Rem
	Method CreateFromGLTexture:TProtogTexture(texture:TGLTexture, flags:Int)
		m_flags = flags
		m_gltexture = texture
		Return Self
	End Method
	
	Rem
		bbdoc: Create a TProtogTexture with the given size.
		returns: The new TProtogTexture (itself).
	End Rem
	Method CreateFromSize:TProtogTexture(width:Int, height:Int, flags:Int, format:Int = FORMAT_RGBA8)
		m_flags = flags
		m_width = width
		m_height = height
		m_gltexture = New TGLTexture.CreateFromSize(width, height, flags, format)
		Return Self
	End Method
	
	Rem
		bbdoc: Upload the texture's pixmap (creates the OpenGL handle for rendering).
		returns: Nothing.
	End Rem
	Method UploadPixmap()
		m_gltexture = New TGLTexture.CreateFromPixmap(m_pixmap, m_flags)
	End Method
	
	Rem
		bbdoc: Destroy the texture.
		returns: Nothing.
	End Rem
	Method Destroy()
		m_pixmap = Null
		If m_gltexture <> Null
			m_gltexture.Destroy()
		End If
		m_width = 0; m_height = 0
		m_flags = 0
	End Method
	
'#end region (Constructors and deconstructor)
	
'#region OpenGL
	
	Rem
		bbdoc: Bind the texture.
		returns: Nothing.
	End Rem
	Method Bind(enabletarget:Int = True)
		m_gltexture.Bind(enabletarget)
	End Method
	
	Rem
		bbdoc: Unbind the texture's target.
		returns: Nothing.
	End Rem
	Method Unbind()
		m_gltexture.Unbind()
	End Method
	
	Rem
		bbdoc: Render the texture to the given rectangle (does not bind the texture).
		returns: Nothing.
	End Rem
	Method Render(quad:TVec4, flipped:Int = False)
		m_gltexture.Render(quad, flipped)
	End Method
	
	Rem
		bbdoc: Render the texture to the given vector, using the texture's width and height (does not bind the texture).
		returns: Nothing.
	End Rem
	Method RenderToPos(pos:TVec2, flipped:Int = False)
		m_gltexture.Render(New TVec4.CreateFromVec2(pos, pos.AddVecNew(New TVec2.Create(Float(m_width), Float(m_height)))), flipped)
	End Method
	
	Rem
		bbdoc: Render the texture to the given parameters, using the texture's width and height (does not bind the texture).
		returns: Nothing.
	End Rem
	Method RenderToPosParams(x:Float, y:Float, flipped:Int = False)
		RenderToPos(New TVec2.Create(x, y), flipped)
	End Method
	
'#end region (OpenGL)
	
'#region Data handlers
	
	Rem
		bbdoc: Serialize the texture into the given stream.
		returns: Nothing.
	End Rem
	Method Serialize(stream:TStream)
		stream.WriteInt(m_flags)
		TPixmapIO.Write(m_pixmap, stream)
	End Method
	
	Rem
		bbdoc: Deserialize a texture from the given stream.
		returns: The deserialized texture (itself).
		about: If @upload is True the pixmap will be uploaded (the GL texture will be created for the ProtogTexture).
	End Rem
	Method DeSerialize:TProtogTexture(stream:TStream, upload:Int = True)
		m_flags = stream.ReadInt()
		SetPixmap(TPixmapIO.Read(stream), upload)
		Return Self
	End Method
	
'#end region (Data handlers)
	
'#region Field accessors
	
	Rem
		bbdoc: Get the width of the texture.
		returns: The texture's width.
	End Rem
	Method GetWidth:Int()
		Return m_width
	End Method
	
	Rem
		bbdoc: Get the height of the texture.
		returns: The texture's height.
	End Rem
	Method GetHeight:Int()
		Return m_height
	End Method
	
	Rem
		bbdoc: Get the flags for the texture.
		returns: The flags for the texture.
	End Rem
	Method GetFlags:Int()
		Return m_flags
	End Method
	
	Rem
		bbdoc: Set the pixmap for the texture.
		returns: Nothing.
		about: If @upload is True (the default value), the new pixmap will be uploaded to OpenGL.
	End Rem
	Method SetPixmap(pixmap:TPixmap, upload:Int = True)
		Assert pixmap, "(duct.protog2d.TProtogTexture.SetPixmap) Null pixmaps are not allowed!"
		
		m_pixmap = pixmap
		
		m_gltexture = Null
		m_width = m_pixmap.width
		m_height = m_pixmap.height
		
		If upload = True
			UploadPixmap()
		End If
	End Method
	
	Rem
		bbdoc: Get the pixmap for the texture.
		returns: The texture's pixmap.
	End Rem
	Method GetPixmap:TPixmap()
		Return m_pixmap
	End Method
	
'#end region (Field accessors)
	
End Type

Rem
	bbdoc: Animated single-surface texture.
End Rem
Type TProtogAnimTexture
	
	Field m_pixmap:TPixmap
	Field m_gltexture:TGLTexture
	
	Field m_width:Int, m_height:Int, m_flags:Int
	
	Field m_framecount:Int, m_startframe:Int
	Field m_frame_width:Float, m_frame_height:Float
	Field m_currentframe:Int
	
	Field m_uv:TVec4[]
	
	Method New()
	End Method
	
	Rem
		bbdoc: Create a new ProtogAnimTexture.
		returns: The new ProtogAnimTexture (itself).
		about: If @upload is True the pixmap will be uploaded to OpenGL (creates the GL texture).
	End Rem
	Method Create:TProtogAnimTexture(pixmap:TPixmap, startframe:Int, framecount:Int, frame_width:Float, frame_height:Float, flags:Int, upload:Int = True)
		m_flags = flags
		SetStartFrame(startframe)
		SetFrameCount(framecount)
		SetFrameSize(frame_width, frame_height)
		SetPixmap(pixmap, upload)
		RecalculateFrames()
		Return Self
	End Method
	
'#region Frames
	
	Rem
		bbdoc: Set the current frame for the animation.
		returns: Nothing.
		about: If @force is True, the current frame will be set regardless if it is 
		already the current frame (useful if you just recalculated the frames or changed some UVs).
	End Rem
	Method SetCurrentFrame(frame:Int, force:Int = False)
		If m_currentframe <> frame Or force = True
			If HasFrame(frame) = True
				m_currentframe = frame
				m_gltexture.m_uv = m_uv[m_currentframe]
			End If
		End If
	End Method
	
	Rem
		bbdoc: Recalculate the frame coordinates.
		returns: Nothing.
		about: The current frame will be set again if it is still a valid frame, otherwise the first frame (0) is set.
	End Rem
	Method RecalculateFrames()
		Local tx:Float, ty:Float, x_cells:Int
		Local xdelta:Float, ydelta:Float
		If m_flags & TEXTURE_RECTANGULAR
			xdelta = 1
			ydelta = 1
		Else
			xdelta = m_width / Pow2Size(m_width)
			ydelta = m_height / Pow2Size(m_height)
		End If
		
		x_cells = m_width / m_frame_width
		
		Local vector:TVec4, frame:Int
		For frame = m_startframe To m_framecount - 1
			
			tx = (frame Mod x_cells * m_frame_width) * xdelta
			ty = (frame / x_cells * m_frame_height) * ydelta
			
			vector = New TVec4
			
			' Texture coordinate layout:
			' x---y     u0--v0
			' |   |  =  |    |
			' |   |     |    |
			' z---w     u1--v1
			vector.m_x = Float(tx) / Float(m_width)
			vector.m_y = Float(ty) / Float(m_height)
			vector.m_z = Float(tx + m_frame_width * xdelta) / Float(m_width)
			vector.m_w = Float(ty + m_frame_height * ydelta) / Float(m_height)
			
			m_uv[frame] = vector
		Next
		
		If HasFrame(m_currentframe) = True
			SetCurrentFrame(m_currentframe, True)
		Else
			SetCurrentFrame(0, True)
		End If
		
	End Method
	
	Rem
		bbdoc: Check if the texture has a frame.
		returns: True if the texture has the given frame, or False if it does not.
	End Rem
	Method HasFrame:Int(frame:Int)
		If frame > - 1 And frame < m_framecount
			Return True
		End If
		Return False
	End Method
	
'#end region (Frames)
	
'#region OpenGL
	
	Rem
		bbdoc: Bind the current texture.
		returns: Nothing.
	End Rem
	Method Bind()
		m_gltexture.Bind()
	End Method
	
	Rem
		bbdoc: Unbind the current texture's target.
		returns: Nothing.
	End Rem
	Method Unbind()
		m_gltexture.Unbind()
	End Method
	
	Rem
		bbdoc: Render the current frame to the given rectangle (does not bind the texture).
		returns: Nothing.
	End Rem
	Method Render(quad:TVec4, flipped:Int = False)
		m_gltexture.Render(quad, flipped)
	End Method
	
	Rem
		bbdoc: Render the current frame to the given position, using the cell width and height (does not bind the texture).
		returns: Nothing.
	End Rem
	Method RenderToPos(pos:TVec2, flipped:Int = False)
		m_gltexture.Render(New TVec4.CreateFromVec2(pos, pos.AddVecNew(New TVec2.Create(Float(m_frame_width), Float(m_frame_height)))), flipped)
	End Method
	
'#region (OpenGL)
	
'#region Field accessors
	
	Rem
		bbdoc: Get the width of the texture.
		returns: The texture's width.
	End Rem
	Method GetWidth:Int()
		Return m_width
	End Method
	
	Rem
		bbdoc: Get the height of the texture.
		returns: The texture's height.
	End Rem
	Method GetHeight:Int()
		Return m_height
	End Method
	
	Rem
		bbdoc: Get the flags for the texture.
		returns: The flags for the texture.
	End Rem
	Method GetFlags:Int()
		Return m_flags
	End Method
	
	Rem
		bbdoc: Upload the texture's pixmap (creates the OpenGL handle for rendering).
		returns: Nothing.
	End Rem
	Method UploadPixmap()
		m_gltexture = New TGLTexture.CreateFromPixmap(m_pixmap, m_flags)
	End Method
	
	Rem
		bbdoc: Set the pixmap for the texture.
		returns: Nothing.
		about: If @upload is True (the default value), the new pixmap will be uploaded to OpenGL.<br/>
			NOTE: You will need to call #RecalculateFrames if the new pixmap data is not the same size/etc.
	End Rem
	Method SetPixmap(pixmap:TPixmap, upload:Int = True)
		Assert pixmap, "(duct.protog2d.TProtogAnimTexture.SetPixmap) Null pixmaps are not allowed!"
		
		m_pixmap = pixmap
		m_gltexture = Null
		m_width = m_pixmap.width
		m_height = m_pixmap.height
		
		If upload = True
			UploadPixmap()
		End If
	End Method
	
	Rem
		bbdoc: Get the pixmap for the texture.
		returns: The texture's pixmap.
	End Rem
	Method GetPixmap:TPixmap()
		Return m_pixmap
	End Method
	
	Rem
		bbdoc: Set the start frame for the texture.
		returns: Nothing.
	End Rem
	Method SetStartFrame(startframe:Int)
		m_startframe = startframe
	End Method
	
	Rem
		bbdoc: Get the starting (first) frame for the texture.
		returns: The beginning frame for the texture.
	End Rem
	Method GetStartFrame:Int()
		Return m_startframe
	End Method
	
	Rem
		bbdoc: Set the frame count for the texture.
		returns: Nothing.
		about: NOTE: You must call #RecalculateFrames after calling this.
	End Rem
	Method SetFrameCount(framecount:Int)
		m_framecount = framecount
		m_uv = New TVec4[m_framecount]
	End Method
	
	Rem
		bbdoc: Get the number of frames in the texture.
		returns: The number of frames in the texture.
	End Rem
	Method GetFrameCount:Int()
		Return m_framecount
	End Method
	
	Rem
		bbdoc: Get the current frame for the texture.
		returns: The current frame in the texture.
	End Rem
	Method GetCurrentFrame:Int()
		Return m_currentframe
	End Method
	
	Rem
		bbdoc: Set the frame size for the texture.
		returns: Nothing.
		about: NOTE: You must call #RecalculateFrames after calling this.
	End Rem
	Method SetFrameSize(width:Float, height:Float)
		m_frame_width = width
		m_frame_height = height
	End Method
	
	Rem
		bbdoc: Set the width of each frame in the texture.
		returns: Nothing.
		about: NOTE: You must call #RecalculateFrames after calling this.
	End Rem
	Method SetFrameWidth(width:Float)
		m_frame_width = width
	End Method
	
	Rem
		bbdoc: Set the height of each frame in the texture.
		returns: Nothing.
		about: NOTE: You must call #RecalculateFrames after calling this.
	End Rem
	Method SetFrameHeight(height:Float)
		m_frame_height = height
	End Method
	
	Rem
		bbdoc: Get the width of each frame in the texture.
		returns: The width of each frame in the texture.
	End Rem
	Method GetFrameWidth:Float()
		Return m_frame_width
	End Method
	
	Rem
		bbdoc: Get the height of each frame in the texture.
		returns: The height of each frame in the texture.
	End Rem
	Method GetFrameHeight:Float()
		Return m_frame_height
	End Method
	
'#end region (Field accessors)
	
'#region Data handlers
	
	Rem
		bbdoc: Serialize the texture to a stream.
		returns: Nothing.
		about: If @writepixmap is True, the texture's pixmap will be written to the stream (replicate behavior in #DeSerialize).
	End Rem
	Method Serialize(stream:TStream, writepixmap:Int = True)
		stream.WriteInt(m_framecount)
		stream.WriteInt(m_startframe)
		stream.WriteFloat(m_frame_width)
		stream.WriteFloat(m_frame_height)
		
		If writepixmap = True
			stream.WriteInt(m_flags)
			TPixmapIO.Write(m_pixmap, stream)
		End If
	End Method
	
	Rem
		bbdoc: Deserialize a texture from the given stream.
		returns: The deserialized texture (itself).
		about: If @readpixmap is True, this method will attempt to read and set a pixmap from the stream.<br/>
		If @upload is True the pixmap will be uploaded (the GL texture will be created for the ProtogAnimTexture).
	End Rem
	Method DeSerialize:TProtogAnimTexture(stream:TStream, readpixmap:Int = True)
		m_framecount = stream.ReadInt()
		m_startframe = stream.ReadInt()
		m_frame_width = stream.ReadFloat()
		m_frame_height = stream.ReadFloat()
		
		If readpixmap = True
			m_flags = stream.ReadInt()
			SetPixmap(TPixmapIO.Read(stream), True)
		End If
		Return Self
	End Method
	
'#end region
	
End Type

