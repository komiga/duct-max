
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
	
	protog.bmx (Contains: TProtog2DGraphics, TProtog2DDriver, )
	
	TODO:
		
	
End Rem

Extern
	Function bbGLGraphicsShareContexts()
	Function bbGLGraphicsGraphicsModes(buf:Byte Ptr, size:Int)
	Function bbGLGraphicsAttachGraphics:Byte Ptr(widget:Int, flags:Int)
	Function bbGLGraphicsCreateGraphics:Byte Ptr(width:Int, height:Int, depth:Int, hertz:Int, flags:Int)
	Function bbGLGraphicsGetSettings:Int(context:Byte Ptr, width:Int Var, height:Int Var, depth:Int Var, hertz:Int Var, flags:Int Var)
	Function bbGLGraphicsClose(context:Byte Ptr)
	Function bbGLGraphicsSetGraphics(context:Byte Ptr)
	Function bbGLGraphicsFlip(sync:Int)
End Extern

Rem
	bbdoc: Masking blend.
	about: Pixels will only be drawn if their alpha component is greater than 0.5.
End Rem
Const BLEND_MASK:Int = 1
Rem
	bbdoc: Solid blend.
	about: Pixels, when drawn, will overwrite the pixel behind them entirely (alpha setting does not affect this state).
End Rem
Const BLEND_SOLID:Int = 2
Rem
	bbdoc: Alpha blend.
	about: Alpha blends drawn pixels with the pixels behind them.
End Rem
Const BLEND_ALPHA:Int = 3
Rem
	bbdoc: Light blend.
	about: This blend state will add the background pixel and drawn pixel values together (creating a lighting effect).
End Rem
Const BLEND_LIGHT:Int = 4
Rem
	bbdoc: Light blend.
	about: This blend state will multiply the background pixel and drawn pixel values together (creating a shading effect).
End Rem
Const BLEND_SHADE:Int = 5

Rem
	bbdoc: Protog2D graphics.
End Rem
Type TProtog2DGraphics Extends TGraphics
	
	Field m_context:Byte Ptr
	
	Rem
		bbdoc: Get the driver for the TProtog2DGraphics.
		returns: The driver for the graphical context.
		about: NOTE: This is the same as calling #{TProtog2DDriver.GetInstance}()
	End Rem
	Method Driver:TProtog2DDriver()
		Assert m_context
		Return TProtog2DDriver.GetInstance()
	End Method
	
	Rem
		bbdoc: Get the settings for the graphical context.
		returns: Nothing (values are passed back via the parameters).
	End Rem
	Method GetSettings(width:Int Var, height:Int Var, depth:Int Var, hertz:Int Var, flags:Int Var)
		Assert m_context
		Local w:Int, h:Int, d:Int, r:Int, f:Int
		bbGLGraphicsGetSettings(m_context, w, h, d, r, f)
		width = w
		height = h
		depth = d
		hertz = r
		flags = f
	End Method
	
	Rem
		bbdoc: Close the graphical context.
		returns: Nothing.
	End Rem
	Method Close()
		If m_context <> Null
			bbGLGraphicsClose(m_context)
			m_context = Null
		End If
	End Method
	
End Type

Rem
	bbdoc: Protog2D graphics driver.
	about: This is an automatically created singleton type (do not create any instances of it).
End Rem
Type TProtog2DDriver Extends TGraphicsDriver
	Const GL_BGR:Int = $80E0
	Const GL_BGRA:Int = $80E1
	Const GL_CLAMP_TO_EDGE:Int = $812F
	Const GL_CLAMP_TO_BORDER:Int = $812D
	
	Global m_instance:TProtog2DDriver
	Global m_glewinitiated:Int = False
	Global m_gl_maxtexturesize:Int
	
	Global m_drawcolor:TVec4 = New TVec4.Create(1.0, 1.0, 1.0, 1.0)
	
	Global m_state_blend:Int
	Global m_boundtexture:Int, m_state_tex2denabled:Int
	
	Global m_gwidth:Int, m_gheight:Int
	
	Global m_renderbuffer:TProtogFrameBuffer, m_renderbuffer_bound:Int
	Global m_renderbuffer_texture:Int
	
'#region Global-based stuffs
	
	Rem
		bbdoc: Get the singleton instance for the Protog2D driver.
		returns: Nothing.
	End Rem
	Function GetInstance:TProtog2DDriver()
		Return m_instance
	End Function
	
	Rem
		bbdoc: Initiate global variables and states.
		returns: Nothing.
	End Rem
	Function InitGlobal()
		If m_instance = Null
			m_instance = New TProtog2DDriver
		End If
	End Function
	
	Rem
		bbdoc: Initiate Glew and some variables.
		returns: Nothing.
	End Rem
	Function InitGlew()
		pub.glew.glewInit()
		m_glewinitiated = True
		
		If m_gl_maxtexturesize = 0
			glGetIntegerv(GL_MAX_TEXTURE_SIZE, Varptr(m_gl_maxtexturesize))
		End If
	End Function
	
	Rem
		bbdoc: Check the FRAMEBUFFER_EXT status.
		returns: True if the extension is supported, False if it is not, or -1 if the status was unknown (also *not* supported).
	End Rem 
	Function CheckFrameBufferStatus:Int()
		Local status:Int
		
		status = glCheckFramebufferStatusEXT(GL_FRAMEBUFFER_EXT)
		Select status
			Case GL_FRAMEBUFFER_COMPLETE_EXT
				Return True
				
			Case GL_FRAMEBUFFER_UNSUPPORTED_EXT
				Return False
				
			Default
				DebugLog("(TProtog2DDriver.CheckFrameBufferStatus) Unknown FBO_EXT status (status = " + status + ")")
				Return - 1
				
		End Select
		
	End Function
	
'#end region (Global-based stuffs)
	
'#region Extended methods
	
	Rem
		bbdoc: Get the graphics modes that can be used for a graphical context.
		returns: Nothing.
	End Rem
	Method GraphicsModes:TGraphicsMode[] ()
		Local buf:Int[4096]
		Local count:Int = bbGLGraphicsGraphicsModes(buf, 1024)
		Local modes:TGraphicsMode[count], p:Int Ptr = buf
		For Local i:Int = 0 Until count
			Local t:TGraphicsMode = New TGraphicsMode
			t.width = p[0]
			t.height = p[1]
			t.depth = p[2]
			t.hertz = p[3]
			modes[i] = t
			p:+4
		Next
		Return modes
	End Method
	
	Rem
		bbdoc: Attach a 'widget' to a new graphical context.
		returns: A new graphical context with the attached widget.
		about: NOTE: This method is used internally by BlitzMax's graphics system, you probably won't need to touch this.
	End Rem
	Method AttachGraphics:TProtog2DGraphics(widget:Int, flags:Int)
		Local gc:TProtog2DGraphics = New TProtog2DGraphics
		gc.m_context = bbGLGraphicsAttachGraphics(widget, flags)
		Return gc
	End Method
	
	Rem
		bbdoc: Create a new Protog2D graphical context.
		returns: Nothing.
		about: NOTE: This method is used internally by BlitzMax's graphics system, you probably won't need to touch this.
	End Rem
	Method CreateGraphics:TProtog2DGraphics(width:Int, height:Int, depth:Int, hertz:Int, flags:Int)
		Local gc:TProtog2DGraphics = New TProtog2DGraphics
		gc.m_context = bbGLGraphicsCreateGraphics(width, height, depth, hertz, flags)
		Return gc
	End Method
	
	Method SetGraphics(gcontext:TGraphics)
		
		'DebugLog("(TProtog2DDriver.SetGraphics)")
		
		If gcontext = Null
			'TMax2DGraphics.ClearCurrent()
			'Super.SetGraphics(Null)
			bbGLGraphicsSetGraphics(Null)
		Else
			Local p2d_gcontext:TProtog2DGraphics = TProtog2DGraphics(gcontext)
			Assert p2d_gcontext, "(duct.protog2d.TProtog2DDriver.SetGraphics) Graphics context is not a Protog2DGraphics instance"
			
			'Super.SetGraphics(p2d_gcontext)
			
			Local context:Byte Ptr
			If p2d_gcontext <> Null
				context = p2d_gcontext.m_context
			End If
			bbGLGraphicsSetGraphics(context)
			
			ResetGLContext(p2d_gcontext)
			'm2d_gcontext.MakeCurrent()
		End If
		
	End Method
	
'#end region (Extended methods)
	
	Rem
		bbdoc: Reset the OpenGL context.
		returns: Nothing.
	End Rem
	Method ResetGLContext(gcontext:TProtog2DGraphics)
		Local gd:Int, gr:Int, gf:Int
		
		If m_glewinitiated = False
			InitGlew()
		End If
		
		gcontext.GetSettings(m_gwidth, m_gheight, gd, gr, gf)
		
		m_state_blend = 0
		m_boundtexture = 0
		m_state_tex2denabled = 0
		
		glDisable(GL_TEXTURE_2D)
		glMatrixMode(GL_PROJECTION)
		glLoadIdentity()
		glOrtho(0, m_gwidth, m_gheight, 0, - 1, 1)
		glMatrixMode(GL_MODELVIEW)
		glViewport(0, 0, m_gwidth, m_gheight)
		
		If m_renderbuffer <> Null
			DestroyRenderBuffer()
		End If
		
		' Setup our FBO
		m_renderbuffer = New TProtogFrameBuffer
		BindRenderBuffer()
		
		m_renderbuffer.AttachTexture(0, New TGLTexture.CreateFromSize(m_gwidth, m_gheight, TEXTURE_RECTANGULAR), True)
		m_renderbuffer_texture = m_renderbuffer.m_colorbuffers[0].m_handle
		
		'DebugLog("(TProtog2DDriver.ResetGLContext) renderbuffer = " + m_renderbuffer + " renderbuffer_texture = " + m_renderbuffer_texture + "~n~t~t" + ..
		'		"gwidth = " + m_gwidth + " gheight = " + m_gheight)
		
		m_renderbuffer.SetDrawBuffers()
		
	End Method
	
'#region Renderbuffer
	
	Rem
		bbdoc: Destroy the renderbuffer.
		returns: Nothing.
	End Rem
	Method DestroyRenderBuffer()
		m_renderbuffer.Destroy()
		m_renderbuffer = Null
		m_renderbuffer_texture = -1
	End Method
	
	Rem
		bbdoc: Bind the renderbuffer (anything drawn will go to the renderbuffer).
		returns: Nothing.
	End Rem
	Method BindRenderBuffer()
		If m_renderbuffer_bound = False
			m_renderbuffer.Bind()
			m_renderbuffer_bound = True
		End If
	End Method
	
	Rem
		bbdoc: Unbind the renderbuffer (will allow rendering to the backbuffer).
		returns: Nothing.
	End Rem
	Method UnbindRenderBuffer()
		If m_renderbuffer_bound = True
			TProtogFrameBuffer.UnBind()
			m_renderbuffer_bound = False
		End If
	End Method
	
	Rem
		bbdoc: Draw the renderbuffer.
		returns: Nothing.
		about: This is called automatically before the backbuffer is flipped.
	End Rem
	Method DrawRenderBuffer()
		Local lastblend:Int = m_state_blend
		Local lastrb_bound:Int = m_renderbuffer_bound
		Local last_texture:Int = m_boundtexture
		
		If lastrb_bound = True
			UnbindRenderBuffer()
		End If
		
		SetBlend(BLEND_SOLID)
		EnableTexture(m_renderbuffer_texture)
		
		glColor4f(1.0, 1.0, 1.0, 1.0)
		
		glBegin(GL_QUADS)
			glTexCoord2f(0.0, 0.0) ; glVertex2f(0.0, m_gheight)
			glTexCoord2f(1.0, 0.0) ; glVertex2f(m_gwidth, m_gheight)
			glTexCoord2f(1.0, 1.0) ; glVertex2f(m_gwidth, 0.0)
			glTexCoord2f(0.0, 1.0) ; glVertex2f(0.0, 0.0)
		glEnd()
		
		_SetDrawingColor()
		SetBlend(lastblend)
		BindTexture(last_texture)
		
		If lastrb_bound = True
			BindRenderBuffer()
		End If
		
	End Method
	
'#end region (Renderbuffer)
	
'#region State functions
	
	Rem
		bbdoc: Draw the render buffer, and flip the backbuffer.
		returns: Nothing.
		about: This is used internally (sadly) by #{brl.graphics}.<br />
		Call #{brl.graphics.Flip} to flip the backbuffer, instead of this (it will call this method after it does the syncing voodoo).
	End Rem
	Method Flip(sync:Int)
		'DebugLog("(TProtog2DDriver.Flip)")
		
		DrawRenderBuffer()
		bbGLGraphicsFlip(sync)
		
	End Method
	
	Method ToString:String()
		Return "Protog2D"
	End Method
	
	Rem
		bbdoc: Set the blending mode.
		returns: Nothing.
	End Rem
	Function SetBlend(blend:Int)
		
		If blend <> m_state_blend
			
			m_state_blend = blend
			
			Select blend
				Case BLEND_MASK
					glDisable(GL_BLEND)
					glEnable(GL_ALPHA_TEST)
					glAlphaFunc(GL_GEQUAL, 0.5)
					
				Case BLEND_SOLID
					glDisable(GL_BLEND)
					glDisable(GL_ALPHA_TEST)
					
				Case BLEND_ALPHA
					glEnable(GL_BLEND)
					glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)
					glDisable(GL_ALPHA_TEST)
					
				Case BLEND_LIGHT
					glEnable(GL_BLEND)
					glBlendFunc(GL_SRC_ALPHA, GL_ONE)
					glDisable(GL_ALPHA_TEST)
					
				Case BLEND_SHADE
					glEnable(GL_BLEND)
					glBlendFunc(GL_DST_COLOR, GL_ZERO)
					glDisable(GL_ALPHA_TEST)
					
				Default
					glDisable(GL_BLEND)
					glDisable(GL_ALPHA_TEST)
					
			End Select
			
		End If
		
	End Function
	
	Rem
		bbdoc: Set the alpha value for the drawing color.
		returns: Nothing.
	End Rem
	Function SetDrawingAlpha(alpha:Float)
		If alpha > 1.0 alpha = 1.0
		If alpha < 0.0 alpha = 0.0
		m_drawcolor.m_w = alpha
		
		glColor4fv(Varptr(m_drawcolor.m_x))
	End Function
	
	Rem
		bbdoc: Set the drawing color from float values.
		returns: Nothing.
	End Rem
	Function SetDrawingColor(red:Float, green:Float, blue:Float)
		m_drawcolor.m_x = red
		m_drawcolor.m_y = green
		m_drawcolor.m_z = blue
		
		glColor4fv(Varptr(m_drawcolor.m_x))
	End Function
	
	Rem
		bbdoc: Set the drawing color via a vector.
		returns: Nothing.
	End Rem
	Function SetDrawingColorVector(vec:TVec4)
		m_drawcolor = vec.Copy()
		glColor4fv(Varptr(m_drawcolor.m_x))
	End Function
	
	Rem
		bbdoc: Set the drawing color to the current drawing color (e.g. if you need the original color back and you changed it manually with glColor#f).
		returns: Nothing.
	End Rem
	Function _SetDrawingColor()
		glColor4fv(Varptr(m_drawcolor.m_x))
	End Function
	
	Rem
		bbdoc: Set the color to be overlayed on the screen when #Cls is called.
		returns: Nothing.
		about: @color maps to the RGB values just as the vector's fields are defined (x=r, y=g, z=b).
	End Rem
	Function SetClsColor(color:TVec3, alpha:Float = 1.0)
		glClearColor(color.m_x, color.m_y, color.m_z, alpha)
	End Function
	
	Rem
		bbdoc: Set the graphical viewport (anything which is drawn outside of the current viewport will not appear on the screen).
		returns: Nothing.
	End Rem
	Method SetViewport(x:Int, y:Int, w:Int, h:Int)
		If x = 0 And y = 0 And w = m_gwidth And h = m_gheight
			glDisable(GL_SCISSOR_TEST)
		Else
			glEnable(GL_SCISSOR_TEST)
			glScissor(x, m_gheight - y - h, w, h)
		End If
	End Method
	
	Rem
		bbdoc: Clear the screen.
		returns: Nothing.
		about: Either this function, or #{brl.graphics.Cls} can be called to clear the screen.
	End Rem
	Method Cls()
		glClear(GL_COLOR_BUFFER_BIT)
	End Method
	
'#end region (State functions)
	
	Rem
	Method Plot(x:Float, y:Float)
		
		DisableTex()
		glBegin(GL_POINTS)
			glVertex2f(x + 0.5, y + 0.5)
		glEnd()
		
	End Method
	
	Method DrawLine(x0:Float, y0:Float, x1:Float, y1:Float, tx:Float, ty:Float)
		
		DisableTex()
		glBegin(GL_LINES)
			glVertex2f(x0 * ix + y0 * iy + tx + 0.5, x0 * jx + y0 * jy + ty + 0.5)
			glVertex2f(x1 * ix + y1 * iy + tx + 0.5, x1 * jx + y1 * jy + ty + 0.5)
		glEnd()
		
	End Method
	
	Method DrawRect(x0:Float, y0:Float, x1:Float, y1:Float, tx:Float, ty:Float)
		
		DisableTex()
		glBegin(GL_QUADS)
			glVertex2f(x0 * ix + y0 * iy + tx, x0 * jx + y0 * jy + ty)
			glVertex2f(x1 * ix + y0 * iy + tx, x1 * jx + y0 * jy + ty)
			glVertex2f(x1 * ix + y1 * iy + tx, x1 * jx + y1 * jy + ty)
			glVertex2f(x0 * ix + y1 * iy + tx, x0 * jx + y1 * jy + ty)
		glEnd()
		
	End Method
	
	Method DrawOval(x0:Float, y0:Float, x1:Float, y1:Float, tx:Float, ty:Float)
		Local th:Float, x:Float, y:Float
		Local xr:Float = (x1 - x0) * 0.5
		Local yr:Float = (y1 - y0) * 0.5
		Local segs:Int = Abs(xr) + Abs(yr)
		
		segs = Max(segs, 12) & ~3
		
		x0:+xr
		y0:+yr
		
		DisableTex()
		glBegin(GL_POLYGON)
		
		For Local i:Int = 0 Until segs
			th = i * 360.0 / segs
			x = x0 + Cos(th) * xr
			y = y0 - Sin(th) * yr
			
			glVertex2f(x * ix + y * iy + tx, x * jx + y * jy + ty)
			
		Next
		
		glEnd()
		
	End Method
	
	Method DrawPoly(xy:Float[], handle_x:Float, handle_y:Float, origin_x:Float, origin_y:Float)
		Local x:Float, y:Float
		
		If xy.length < 6 Or (xy.length & 1) Return
		
		DisableTex()
		glBegin(GL_POLYGON)
		
		For Local i:Int = 0 Until xy.Length Step 2
			x = xy[i + 0] + handle_x
			y = xy[i + 1] + handle_y
			
			glVertex2f(x * ix + y * iy + origin_x, x * jx + y * jy + origin_y)
			
		Next
		
		glEnd()
		
	End Method
	End Rem
	
'#region Pixmaps
	
	Rem
		bbdoc: Draw the given pixmap at the position given.
		returns: Nothing.
	End Rem
	Method DrawPixmap(p:TPixmap, x:Int, y:Int)
		Local blend:Int = m_state_blend
		Disable2DTexturing()
		SetBlend(BLEND_SOLID)
		
		Local t:TPixmap = YFlipPixmap(p)
		
		If t.format <> PF_RGBA8888 Then t = ConvertPixmap(t, PF_RGBA8888)
		
		glRasterPos2i(0, 0)
		glBitmap(0, 0, 0, 0, x, - y - t.height, Null)
		glDrawPixels(t.width, t.height, GL_RGBA, GL_UNSIGNED_BYTE, t.pixels)
		
		SetBlend(blend)
		
	End Method
	
	Rem
		bbdoc: Grab the given area into a pixmap.
		returns: Nothing.
	End Rem
	Method GrabPixmap:TPixmap(x:Int, y:Int, w:Int, h:Int)
		Local blend:Int = m_state_blend
		SetBlend(BLEND_SOLID)
		
		Local p:TPixmap = CreatePixmap(w, h, PF_RGBA8888)
		
		glReadPixels(x, m_gheight - h - y, w, h, GL_RGBA, GL_UNSIGNED_BYTE, p.pixels)
		p = YFlipPixmap(p)
		
		SetBlend(blend)
		
		Return p
		
	End Method
	
'#end region (Pixmaps)
	
	Rem
		bbdoc: Bind the given texture handle.
		returns: Nothing.
	End Rem
	Function BindTexture(texture:Int)
		If texture <> m_boundtexture
			glBindTexture(GL_TEXTURE_2D, texture)
			m_boundtexture = texture
		End If
	End Function
	
	Rem
		bbdoc: Enable GL_TEXTURE_2D and bind the given texture handle.
		returns: Nothing.
	End Rem
	Function EnableTexture(texture:Int)
		BindTexture(texture)
		
		If m_state_tex2denabled = False
			glEnable(GL_TEXTURE_2D)
			m_state_tex2denabled = True
		End If
	End Function
	
	Rem
		bbdoc: Disable GL_TEXTURE_2D.
		returns: Nothing.
	End Rem
	Function Disable2DTexturing()
		If m_state_tex2denabled = True
			glDisable(GL_TEXTURE_2D)
			m_state_tex2denabled = False
		End If
	End Function
	
'#region Texture initiation stuffs
	
	Function CreateTex:Int(width:Int, height:Int, flags:Int)
		Local name:Int
		
		glGenTextures(1, Varptr(name))
		glBindTexture(GL_TEXTURE_2D, name)
		
		' Set texture parameters
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE)
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE)
		
		If flags & TEXTURE_FILTER
			glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR)
			
			If flags & TEXTURE_MIPMAP
				glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR)
			Else
				glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR)
			End If
		Else
			glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST)
			
			If flags & TEXTURE_MIPMAP
				glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST_MIPMAP_NEAREST)
			Else
				glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST)
			End If
		End If
		
		Local mip_level:Int
		
		Repeat
			glTexImage2D(GL_TEXTURE_2D, mip_level, GL_RGBA8, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, Null)
			If Not (flags & TEXTURE_MIPMAP) Exit
			If width = 1 And height = 1 Then Exit
			If width > 1 Then width:/2
			If height > 1 Then height:/2
			
			mip_level:+1
		Forever
		
		Return name
		
	End Function
	
	Function UploadTex(pixmap:TPixmap, flags:Int)
		Local mip_level:Int
		
		If pixmap.format <> PF_RGBA8888
			pixmap = pixmap.Convert(PF_RGBA8888)
		End If
		
		Repeat
			glPixelStorei(GL_UNPACK_ROW_LENGTH, pixmap.pitch / BytesPerPixel[pixmap.format])
			glTexSubImage2D(GL_TEXTURE_2D, mip_level, 0, 0, pixmap.width, pixmap.height, GL_RGBA, GL_UNSIGNED_BYTE, pixmap.pixels)
			
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
		
	End Function
	
	Function AdjustTexSize(width:Int Var, height:Int Var)
		
		width = Pow2Size(width)
		height = Pow2Size(height)
		
		width = Max(1, width)
		width = Min(width, m_gl_maxtexturesize)
		height = Max(1, height)
		height = Min(height, m_gl_maxtexturesize)
		
		Rem
		Local t:Int
		
		' Calc texture size
		width = Pow2Size(width)
		height = Pow2Size(height)
		
		Repeat
			
			glTexImage2D(GL_PROXY_TEXTURE_2D, 0, 4, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, Null)
			glGetTexLevelParameteriv(GL_PROXY_TEXTURE_2D, 0, GL_TEXTURE_WIDTH, Varptr(t))
			
			If t <> 0 Then Exit
			If width = 1 And height = 1 Then RuntimeError("Unable to calculate tex size")
			If width > 1 Then width:/2
			If height > 1 Then height:/2
			
		Forever
		End Rem
		
	End Function
	
'#end region (Texture initiation stuffs)
	
End Type

Rem
	bbdoc: Get the GLMax2DExt driver instance.
	returns: The current instance of the GLMax2DExt driver.
	about: The returned driver can be used with #SetGraphicsDriver to enable the extended OpenGL Max2D rendering driver.
End Rem
Function Protog2DDriver:TProtog2DDriver()
	Return TProtog2DDriver.GetInstance()
End Function

TProtog2DDriver.InitGlobal()
SetGraphicsDriver(Protog2DDriver())

















