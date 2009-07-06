
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
End Rem

SuperStrict

Rem
bbdoc: Extended OpenGL graphics driver for Max2D
End Rem
Module duct.glmax2dext

ModuleInfo "Version: 0.1"
ModuleInfo "Copyright: Tim Howard"
ModuleInfo "License: MIT"

ModuleInfo "History: 0.1"
ModuleInfo "History: Added pub.glew init calls and renamed several things"
ModuleInfo "History: Code copied from http://www.blitzbasic.com/Community/posts.php?topic=85304"

Import pub.glew
Import brl.max2d
Import brl.GLGraphics
Import duct.etc

Private

' The code would be too massively ugly (and hard to work with) if
' _TGLMax2DExtAssistant was prepended to all the uses of these variables
Global ix:Float, iy:Float, jx:Float, jy:Float

Public

Type _TGLMax2DExtAssistant
	
	Global m_driver:TGLMax2DExtDriver
	
	Const GL_BGR:Int = $80E0
	Const GL_BGRA:Int = $80E1
	Const GL_CLAMP_TO_EDGE:Int = $812F
	Const GL_CLAMP_TO_BORDER:Int = $812D
	
	' These parameters are simply for direct access (instead of calling GetTransformVars,
	' you can just access these pointers)
	Global p_ix:Float Ptr, p_iy:Float Ptr, p_jx:Float Ptr, p_jy:Float Ptr
	Global color4ub:Byte[4]
	
	Global state_blend:Int
	Global state_boundtex:Int
	Global state_texenabled:Int
	
	Function BindTex(name:Int)
		
		If name <> state_boundtex
			glBindTexture(GL_TEXTURE_2D, name)
			state_boundtex = name
		End If
		
	End Function
	
	Function EnableTex(name:Int)
		
		BindTex(name)
		
		If state_texenabled = False
			
			glEnable(GL_TEXTURE_2D)
			state_texenabled = True
			
		End If
		
	End Function
	
	Function DisableTex()
		
		If state_texenabled = True
			
			glDisable(GL_TEXTURE_2D)
			state_texenabled = False
			
		End If
		
	End Function
	
	Function GetInstance:TGLMax2DExtDriver()
		
		Return m_driver
		
	End Function
	
	Function CreateTex:Int(width:Int, height:Int, flags:Int)
		Local name:Int
		
		glGenTextures(1, Varptr(name))
		
		glBindTexture(GL_TEXTURE_2D, name)
		
		'set texture parameters
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE)
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE)
		
		If flags & FILTEREDIMAGE
			
			glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR)
			
			If flags & MIPMAPPEDIMAGE
				glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR)
			Else
				glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR)
			End If
			
		Else
			
			glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST)
			
			If flags & MIPMAPPEDIMAGE
				glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST_MIPMAP_NEAREST)
			Else
				glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST)
			End If
			
		End If
		
		Local mip_level:Int
		
		Repeat
			
			glTexImage2D(GL_TEXTURE_2D, mip_level, GL_RGBA8, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, Null)
			
			If Not (flags & MIPMAPPEDIMAGE) Exit
			If width = 1 And height = 1 Then Exit
			If width > 1 Then width:/2
			If height > 1 Then height:/2
			
			mip_level:+1
			
		Forever
		
		Return name
		
	End Function
	
	Function UploadTex(pixmap:TPixmap, flags:Int)
		Local mip_level:Int
		
		Repeat
			
			glPixelStorei(GL_UNPACK_ROW_LENGTH, pixmap.pitch / BytesPerPixel[pixmap.format])
			glTexSubImage2D(GL_TEXTURE_2D, mip_level, 0, 0, pixmap.width, pixmap.height, GL_RGBA, GL_UNSIGNED_BYTE, pixmap.pixels)
			
			If Not (flags & MIPMAPPEDIMAGE) Exit
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
		Local t:Int
		
		'calc texture size
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
		
	End Function
	
	Function ResetGLContext()
		
		state_blend = 0
		state_boundtex = 0
		state_texenabled = 0
		
	End Function
	
	Function SetBlend(blend:Int)
		
		If blend <> state_blend
			
			state_blend = blend
			
			Select blend
				Case MASKBLEND
					glDisable(GL_BLEND)
					glEnable(GL_ALPHA_TEST)
					glAlphaFunc(GL_GEQUAL, 0.5)
					
				Case SOLIDBLEND
					glDisable(GL_BLEND)
					glDisable(GL_ALPHA_TEST)
					
				Case ALPHABLEND
					glEnable(GL_BLEND)
					glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)
					glDisable(GL_ALPHA_TEST)
					
				Case LIGHTBLEND
					glEnable(GL_BLEND)
					glBlendFunc(GL_SRC_ALPHA, GL_ONE)
					glDisable(GL_ALPHA_TEST)
					
				Case SHADEBLEND
					glEnable(GL_BLEND)
					glBlendFunc(GL_DST_COLOR, GL_ZERO)
					glDisable(GL_ALPHA_TEST)
					
				Default
					glDisable(GL_BLEND)
					glDisable(GL_ALPHA_TEST)
					
			End Select
			
		End If
		
	End Function
	
	Function SetAlpha(alpha:Float)
		
		If alpha > 1.0 alpha = 1.0
		If alpha < 0.0 alpha = 0.0
		color4ub[3] = alpha * 255
		
		glColor4ubv(color4ub)
		
	End Function
	
	Function SetColor(red:Int, green:Int, blue:Int)
		
		color4ub[0] = Min(Max(red, 0), 255)
		color4ub[1] = Min(Max(green, 0), 255)
		color4ub[2] = Min(Max(blue, 0), 255)
		
		glColor4ubv(color4ub)
		
	End Function
	
	Function _SetColor()
		
		glColor4ubv(color4ub)
		
	End Function
	
	Function GetTransformVars(_ix:Float, _iy:Float, _jx:Float, _jy:Float)
		
		_ix = ix
		_iy = iy
		_jx = jx
		_jy = jy
		
	End Function
	
End Type

Type TGLImageFrame Extends TImageFrame
	
	Field u0:Float, v0:Float, u1:Float, v1:Float
	Field name:Int, seq:Int
	
	Method New()
		
		seq = GraphicsSeq
		
	End Method
	
	Method Delete()
		
		If seq <> Null
			
			If seq = GraphicsSeq
				glDeleteTextures(1, Varptr(name))
			End If
			
			seq = 0
			
		End If
		
	End Method
	
	Method Draw(x0:Float, y0:Float, x1:Float, y1:Float, tx:Float, ty:Float)
		
		Assert seq = GraphicsSeq Else "Image does not exist"
		
		_TGLMax2DExtAssistant.EnableTex(name)
		glBegin(GL_QUADS)
			glTexCoord2f(u0, v0)
			glVertex2f(x0 * ix + y0 * iy + tx, x0 * jx + y0 * jy + ty)
			glTexCoord2f(u1, v0)
			glVertex2f(x1 * ix + y0 * iy + tx, x1 * jx + y0 * jy + ty)
			glTexCoord2f(u1, v1)
			glVertex2f(x1 * ix + y1 * iy + tx, x1 * jx + y1 * jy + ty)
			glTexCoord2f(u0, v1)
			glVertex2f(x0 * ix + y1 * iy + tx, x0 * jx + y1 * jy + ty)
		glEnd()
		
	End Method
	
	Function CreateFromPixmap:TGLImageFrame(src:TPixmap, flags:Int)
		Local tex_w:Int = src.width
		Local tex_h:Int = src.height
		
		'determine tex size
		_TGLMax2DExtAssistant.AdjustTexSize(tex_w, tex_h)
		
		'make sure pixmap fits texture
		Local width:Int = Min(src.width, tex_w)
		Local height:Int = Min(src.height, tex_h)
		If src.width <> width Or src.height <> height
			src = ResizePixmap(src, width, height)
		End If
		
		'create texture pixmap
		Local tex:TPixmap = src
		
		'"smear" right/bottom edges if necessary
		If width < tex_w Or height < tex_h
			
			tex = TPixmap.Create(tex_w, tex_h, PF_RGBA8888)
			
			tex.Paste(src, 0, 0)
			
			If width < tex_w
				
				tex.Paste(src.Window(width - 1, 0, 1, height), width, 0)
				
			End If
			
			If height < tex_h
				
				tex.Paste(src.Window(0, height - 1, width, 1), 0, height)
				
				If width < tex_w
					tex.Paste(src.Window(width - 1, height - 1, 1, 1), width, height)
				End If
				
			End If
			
		Else
			
			If tex.format <> PF_RGBA8888
				tex = tex.Convert(PF_RGBA8888)
			End If
			
		End If
		
		'create tex
		Local name:Int = _TGLMax2DExtAssistant.CreateTex(tex_w, tex_h, flags)
		
		'upload it
		_TGLMax2DExtAssistant.UploadTex(tex, flags)
		
		'done!
		Local frame:TGLImageFrame = New TGLImageFrame
		frame.name = name
		frame.u1 = Float(width) / Float(tex_w)
		frame.v1 = Float(height) / Float(tex_h)
		
		Return frame
		
	End Function
	
End Type


Type TGLMax2DExtDriver Extends TMax2DDriver
	
	Global m_glewinitiated:Int = False
	Global m_gldriver:TGLGraphicsDriver
	
	Field m_gwidth:Int, m_gheight:Int
	
	Field m_renderbuffer:Int, m_renderbuffer_bound:Int
	Field m_renderbuffer_texture:Int
	
	Function GetInstance:TGLMax2DExtDriver()
		
		Return _TGLMax2DExtAssistant.m_driver
		
	End Function
	
	Function InitGlobal()
		
		_TGLMax2DExtAssistant.m_driver = New TGLMax2DExtDriver
		m_gldriver = GLGraphicsDriver()
		
	End Function
	
	Function InitGlew()
		
		pub.glew.glewInit()
		m_glewinitiated = True
		
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
				DebugLog("(TGLMax2DExtDriver.CheckFrameBufferStatus) Unknown FBO_EXT status (status = " + status + ")")
				Return - 1
				
		End Select
		
	End Function
	
	Rem
		bbdoc: Get the graphics modes that can be used for a graphical context.
		returns: Nothing.
	End Rem
	Method GraphicsModes:TGraphicsMode[] ()
		
		Return m_gldriver.GraphicsModes()
		
	End Method
	
	Method AttachGraphics:TMax2DGraphics(widget:Int, flags:Int)
		Local gcontext:TGLGraphics
		
		gcontext = m_gldriver.AttachGraphics(widget, flags)
		
		'If m_glewinitiated:Int = False
		'	InitGlew()
		'End If
		
		If gcontext <> Null
			
			Return TMax2DGraphics.Create(gcontext, Self)
			
		End If
		
		Return Null
		
	End Method
	
	Method CreateGraphics:TMax2DGraphics(width:Int, height:Int, depth:Int, hertz:Int, flags:Int)
		Local gcontext:TGLGraphics
		
		gcontext = m_gldriver.CreateGraphics(width, height, depth, hertz, flags)
		
		'If m_glewinitiated:Int = False
		'	InitGlew()
		'End If
		
		If gcontext <> Null
			
			Return TMax2DGraphics.Create(gcontext, Self)
			
		End If
		
		Return Null
		
	End Method
	
	Method SetGraphics(gcontext:TGraphics)
		
		'DebugLog("(TGLMax2DExtDriver.SetGraphics)")
		
		If gcontext = Null
			
			DestoryBuffers()
			TMax2DGraphics.ClearCurrent()
			m_gldriver.SetGraphics(Null)
			
		Else
			
			Local m2d_gcontext:TMax2DGraphics = TMax2DGraphics(gcontext)
			Assert m2d_gcontext And TGLGraphics(m2d_gcontext._graphics)
			
			m_gldriver.SetGraphics(m2d_gcontext._graphics)
			
			ResetGLContext(m2d_gcontext)
			
			m2d_gcontext.MakeCurrent()
			
		End If
		
	End Method
	
	Rem
		bbdoc: Reset the OpenGL context.
		returns: Nothing.
	End Rem
	Method ResetGLContext(gcontext:TGraphics)
		Local gd:Int, gr:Int, gf:Int
		
		'DebugLog("(TGLMax2DExtDriver.ResetGLContext)")
		
		If m_glewinitiated:Int = False
			InitGlew()
		End If
		
		gcontext.GetSettings(m_gwidth, m_gheight, gd, gr, gf)
		
		_TGLMax2DExtAssistant.ResetGLContext()
		
		glDisable(GL_TEXTURE_2D)
		glMatrixMode(GL_PROJECTION)
		glLoadIdentity()
		glOrtho(0, m_gwidth, m_gheight, 0, - 1, 1)
		glMatrixMode(GL_MODELVIEW)
		glViewport(0, 0, m_gwidth, m_gheight)
		
		If m_renderbuffer <> 0
			DestoryBuffers()
		End If
		
		' Setup our FBO
		glGenFramebuffersEXT(1, Varptr(m_renderbuffer))
		BindRenderBuffer()
		
		' Now setup a texture to render to
		glGenTextures(1, Varptr(m_renderbuffer_texture))
		_TGLMax2DExtAssistant.BindTex(m_renderbuffer_texture)
		glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA8, m_gwidth, m_gheight, 0, GL_RGBA, GL_UNSIGNED_BYTE, Null) ' Currently using non-pot texture
		glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE)
		glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE)
		glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR)
		glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR)
		
		' The following 3 lines enable mipmap filtering and generate the mipmap data
		'glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR)
		'glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR)
		'glGenerateMipmapEXT(GL_TEXTURE_2D)
		
		' And attach it to the FBO so we can render to it
		glFramebufferTexture2DEXT(GL_FRAMEBUFFER_EXT, GL_COLOR_ATTACHMENT0_EXT, GL_TEXTURE_2D, m_renderbuffer_texture, 0)
		
		'UnbindRenderBuffer()
		
		DebugLog("(TGLMax2DExtDriver.ResetGLContext) renderbuffer = " + m_renderbuffer + " renderbuffer_texture = " + m_renderbuffer_texture + "~n~t~t" + ..
				"gwidth = " + m_gwidth + " gheight = " + m_gheight)
		
	End Method
	
	Method DestoryBuffers()
		
		UnbindRenderBuffer()
		
		glDeleteFramebuffersEXT(1, Varptr(m_renderbuffer))
		'glDeleteRenderbuffersEXT(1, Varptr(depthBuffer))
		glDeleteTextures(1, Varptr(m_renderbuffer_texture))
		
	End Method
	
	Rem
		bbdoc: Bind the renderbuffer (anything drawn will go to the renderbuffer).
		returns: Nothing.
	End Rem
	Method BindRenderBuffer()
		
		If m_renderbuffer_bound = False
			glBindFramebufferEXT(GL_FRAMEBUFFER_EXT, m_renderbuffer)
			m_renderbuffer_bound = True
		End If
		
	End Method
	
	Rem
		bbdoc: Unbind the renderbuffer (will allow rendering to the backbuffer).
		returns: Nothing.
	End Rem
	Method UnbindRenderBuffer()
		
		If m_renderbuffer_bound = True
			glBindFramebufferEXT(GL_FRAMEBUFFER_EXT, 0)
			m_renderbuffer_bound = False
		End If
		
	End Method
	
	Method DrawRenderBuffer()
		Local lastblend:Int = _TGLMax2DExtAssistant.state_blend
		Local lastrb_bound:Int = m_renderbuffer_bound
		
		If lastrb_bound = True
			UnbindRenderBuffer()
		End If
		
		_TGLMax2DExtAssistant.SetBlend(SOLIDBLEND)
		_TGLMax2DExtAssistant.EnableTex(m_renderbuffer_texture)
		
		glColor4f(1.0, 1.0, 1.0, 1.0)
		
		glBegin(GL_QUADS)
			glTexCoord2f(0.0, 0.0) ; glVertex2f(0.0, m_gheight)
			glTexCoord2f(1.0, 0.0) ; glVertex2f(m_gwidth, m_gheight)
			glTexCoord2f(1.0, 1.0) ; glVertex2f(m_gwidth, 0.0)
			glTexCoord2f(0.0, 1.0) ; glVertex2f(0.0, 0.0)
		glEnd()
		
		_TGLMax2DExtAssistant._SetColor()
		_TGLMax2DExtAssistant.SetBlend(lastblend)
		
		If lastrb_bound = True
			BindRenderBuffer()
		End If
		
	End Method
	
	Method Flip(sync:Int)
		
		'DebugLog("(TGLMax2DExtDriver.Flip)")
		
		If m_renderbuffer_bound = True
			DrawRenderBuffer()
		End If
		
		m_gldriver.Flip(sync)
		
	End Method
	
	Method ToString:String()
		
		Return "OpenGL Extended"
		
	End Method
	
	Method CreateFrameFromPixmap:TGLImageFrame(pixmap:TPixmap, flags:Int)
		Local frame:TGLImageFrame
		
		frame = TGLImageFrame.CreateFromPixmap(pixmap, flags)
		
		Return frame
		
	End Method
	
	Method SetBlend(blend:Int)
		
		_TGLMax2DExtAssistant.SetBlend(blend)
		
	End Method
	
	Method SetAlpha(alpha:Float)
		
		_TGLMax2DExtAssistant.SetAlpha(alpha)
		
	End Method
	
	Method SetLineWidth(width:Float)
		
		glLineWidth(width)
		
	End Method
	
	Method SetColor(red:Int, green:Int, blue:Int)
		
		_TGLMax2DExtAssistant.SetColor(red, green, blue)
		
	End Method
	
	Method SetClsColor(red:Int, green:Int, blue:Int)
		
		red = Min(Max(red, 0), 255)
		green = Min(Max(green, 0), 255)
		blue = Min(Max(blue, 0), 255)
		
		glClearColor(red / 255.0, green / 255.0, blue / 255.0, 1.0)
		
	End Method
	
	Method SetViewport(x:Int, y:Int, w:Int, h:Int)
		
		If x = 0 And y = 0 And w = GraphicsWidth() And h = GraphicsHeight()
			
			glDisable(GL_SCISSOR_TEST)
			
		Else
			
			glEnable(GL_SCISSOR_TEST)
			glScissor(x, GraphicsHeight() - y - h, w, h)
			
		End If
		
	End Method
	
	Method SetTransform(xx:Float, xy:Float, yx:Float, yy:Float)
		
		ix = xx
		iy = xy
		jx = yx
		jy = yy
		
	End Method
	
	Method Cls()
		
		glClear(GL_COLOR_BUFFER_BIT)
		
	End Method
	
	Method Plot(x:Float, y:Float)
		
		_TGLMax2DExtAssistant.DisableTex()
		glBegin(GL_POINTS)
			glVertex2f(x + 0.5, y + 0.5)
		glEnd()
		
	End Method
	
	Method DrawLine(x0:Float, y0:Float, x1:Float, y1:Float, tx:Float, ty:Float)
		
		_TGLMax2DExtAssistant.DisableTex()
		glBegin(GL_LINES)
			glVertex2f(x0 * ix + y0 * iy + tx + 0.5, x0 * jx + y0 * jy + ty + 0.5)
			glVertex2f(x1 * ix + y1 * iy + tx + 0.5, x1 * jx + y1 * jy + ty + 0.5)
		glEnd()
		
	End Method
	
	Method DrawRect(x0:Float, y0:Float, x1:Float, y1:Float, tx:Float, ty:Float)
		
		_TGLMax2DExtAssistant.DisableTex()
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
		
		_TGLMax2DExtAssistant.DisableTex()
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
		
		_TGLMax2DExtAssistant.DisableTex()
		glBegin(GL_POLYGON)
		
		For Local i:Int = 0 Until xy.Length Step 2
			x = xy[i + 0] + handle_x
			y = xy[i + 1] + handle_y
			
			glVertex2f(x * ix + y * iy + origin_x, x * jx + y * jy + origin_y)
			
		Next
		
		glEnd()
		
	End Method
	
	Method DrawPixmap(p:TPixmap, x:Int, y:Int)
		Local blend:Int = _TGLMax2DExtAssistant.state_blend
		_TGLMax2DExtAssistant.DisableTex()
		_TGLMax2DExtAssistant.SetBlend(SOLIDBLEND)
		
		Local t:TPixmap = YFlipPixmap(p)
		
		If t.format <> PF_RGBA8888 Then t = ConvertPixmap(t, PF_RGBA8888)
		
		glRasterPos2i(0, 0)
		glBitmap(0, 0, 0, 0, x, - y - t.height, Null)
		glDrawPixels(t.width, t.height, GL_RGBA, GL_UNSIGNED_BYTE, t.pixels)
		
		_TGLMax2DExtAssistant.SetBlend(blend)
		
	End Method
	
	Method GrabPixmap:TPixmap(x:Int, y:Int, w:Int, h:Int)
		Local blend:Int = _TGLMax2DExtAssistant.state_blend
		_TGLMax2DExtAssistant.SetBlend(SOLIDBLEND)
		
		Local p:TPixmap = CreatePixmap(w, h, PF_RGBA8888)
		
		glReadPixels(x, GraphicsHeight() - h - y, w, h, GL_RGBA, GL_UNSIGNED_BYTE, p.pixels)
		p = YFlipPixmap(p)
		
		_TGLMax2DExtAssistant.SetBlend(blend)
		
		Return p
		
	End Method
	
End Type

Rem
	bbdoc: Get the GLMax2DExt driver instance.
	returns: The current instance of the GLMax2DExt driver.
	about: The returned driver can be used with #SetGraphicsDriver to enable the extended OpenGL Max2D rendering driver.
End Rem
Function GLMax2DExtDriver:TGLMax2DExtDriver()
	
	Return _TGLMax2DExtAssistant.m_driver
	
End Function

_TGLMax2DExtAssistant.p_ix = Varptr(ix)
_TGLMax2DExtAssistant.p_iy = Varptr(iy)
_TGLMax2DExtAssistant.p_jx = Varptr(jx)
_TGLMax2DExtAssistant.p_jy = Varptr(jy)

TGLMax2DExtDriver.InitGlobal()
SetGraphicsDriver(GLMax2DExtDriver())































