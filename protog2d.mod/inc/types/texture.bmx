
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
	bbdoc: This wraps OpenGL texture handles (names) in a high-level type.
End Rem
Type TGLTexture
	
	Field m_handle:Int, m_seq:Int
	Field m_uv:TVec4
	
	Method New()
		m_uv = New TVec4
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
		End If
		
	End Method
	
	Rem
		bbdoc: Create a new GLTexture from the OpenGL texture handle given.
		returns: The new GLTexture (itself).
	End Rem
	Method CreateFromHandle:TGLTexture(handle:Int, uv:TVec4)
		m_handle = handle
		' Unsure of the original meaning! (absence issue)
		m_uv = uv
		
		Return Self
	End Method
	
	Rem
		bbdoc: Create the texture from the size given.
		returns: Nothing.
	End Rem
	Method CreateFromSize:TGLTexture(width:Int, height:Int, flags:Int)
		Local texture_width:Int, texture_height:Int
		
		texture_width = width
		texture_height = height
		
		If flags & TEXTURE_RECTANGULAR = False
			TProtog2DDriver.AdjustTexSize(texture_width, texture_height)
			m_uv.m_y = Float(Min(width, texture_width)) / Float(texture_width)
			m_uv.m_w = Float(Min(height, texture_height)) / Float(texture_height)
		Else
			m_uv.m_y = Float(texture_width)
			m_uv.m_w = Float(texture_height)
		End If
		
		m_handle = TProtog2DDriver.CreateTex(texture_width, texture_height, flags)
		
		Return Self
		
	End Method
	
	Rem
		bbdoc: Create a GLTexture from the given pixmap.
		returns: The new GLTexture (itself).
	End Rem
	Method CreateFromPixmap:TGLTexture(pixmap:TPixmap, flags:Int)
		Local texture_pixmap:TPixmap
		Local texture_width:Int, texture_height:Int
		
		texture_pixmap = pixmap
		texture_width = pixmap.width
		texture_height = pixmap.height
		
		If flags & TEXTURE_RECTANGULAR = False
			
			' Adjust the pixmap's size (to the next power-of-two)
			TProtog2DDriver.AdjustTexSize(texture_width, texture_height)
			
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
			
			m_uv.m_y = Float(width) / Float(texture_width)
			m_uv.m_w = Float(height) / Float(texture_height)
			
		Else
			m_uv.m_y = Float(texture_width)
			m_uv.m_w = Float(texture_height)
		End If
		
		' Create the handle
		m_handle = TProtog2DDriver.CreateTex(texture_width, texture_height, flags)
		
		' Upload the pixmap to the new handle
		TProtog2DDriver.UploadTex(texture_pixmap, flags)
		
		Return Self
		
	End Method
	
	Rem
		bbdoc: Bind the texture.
		returns: Nothing.
	End Rem
	Method Bind()
		TProtog2DDriver.BindTexture(m_handle)
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
	
	Rem
		bbdoc: Create a ProtogTexture.
		returns: The new ProtogTexture (itself).
		about: If @upload is True the pixmap will be uploaded to OpenGL (creates the GL texture).
	End Rem
	Method Create:TProtogTexture(pixmap:TPixmap, flags:Int, upload:Int = True)
		
		m_flags = flags
		SetPixmap(pixmap, upload)
		
		Return Self
		
	End Method
	
	Rem
		bbdoc: Upload the texture's pixmap (creates the OpenGL handle for rendering).
		returns: Nothing.
	End Rem
	Method UploadPixmap()
		m_gltexture = New TGLTexture.CreateFromPixmap(m_pixmap, m_flags)
	End Method
	
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
	
	Rem
		bbdoc: Set the current frame for the animation.
		returns: Nothing.
		about: If @force is True, the current frame will be set regardless if it is 
			already the current frame (useful if you just recalculated the frames or changed some UVs).
	End Rem
	Method SetCurrentFrame(frame:Int, force:Int = False)
		If m_currentframe <> frame Or force = True
			m_currentframe = frame
			m_gltexture.SetUV(m_uv[m_currentframe])
		End If
	End Method
	
	Rem
		bbdoc: Recalculate the frame coordinates.
		returns: Nothing.
		about: NOTE: If the current frame is no longer valid (higher than the 
			new frame count) the current frame will be set to the highest frame.
	End Rem
	Method RecalculateFrames()
		Local tx:Float, ty:Float, x_cells:Int
		Local xdelta:Float = m_width / Pow2Size(m_width)
		Local ydelta:Float = m_height / Pow2Size(m_height)
		
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
		
		' Reset the current drawframe to the first frame if the current frame is no longer valid
		If m_currentframe > m_framecount - 1
			SetCurrentFrame(m_framecount - 1)
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
		about: If @upload is True (the default value), the new pixmap will be uploaded to OpenGL.<br />
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
		about: If @readpixmap is True, this method will attempt to read and set a pixmap from the stream.<br />
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

















