
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
Type dProtog2DGraphics Extends TGraphics
	
	Field m_context:Byte Ptr
	
	Rem
		bbdoc: Get the driver for the dProtog2DGraphics.
		returns: The driver for the graphical context.
		about: NOTE: This is the same as calling #{dProtog2DDriver.GetInstance}()
	End Rem
	Method Driver:dProtog2DDriver()
		Assert m_context
		Return dProtog2DDriver.GetInstance()
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
		If m_context
			bbGLGraphicsClose(m_context)
			m_context = Null
		End If
	End Method
	
End Type

Rem
	bbdoc: Protog2D graphics driver.
	about: This is an automatically created singleton type (do not create any instances of it).
End Rem
Type dProtog2DDriver Extends TGraphicsDriver
	Const GL_BGR:Int = $80E0
	Const GL_BGRA:Int = $80E1
	Const GL_CLAMP_TO_EDGE:Int = $812F
	Const GL_CLAMP_TO_BORDER:Int = $812D
	
	Global m_instance:dProtog2DDriver
	Global m_glewinitiated:Int = False
	Global m_gl_maxtexturesize:Int
	
	Global m_state_blend:Int
	
	Global m_windowsize:dVec2 = New dVec2
	Global m_viewportpos:dVec2 = New dVec2, m_viewportsize:dVec2 = New dVec2
	
	Global m_color_curr:dProtogColor = New dProtogColor.Create()
	Global m_color_cls:dProtogColor = New dProtogColor.Create(0.0, 0.0, 0.0, 1.0)
	
	Global m_linewidth:Float
	Global m_activetexture:dGLTexture
	
	Global m_rendertexture:dProtogTexture', m_accumtexture1:dProtogTexture
	Global m_renderbuffer:dProtogFrameBuffer, m_onflip_renderbuffer:Int = True
	
	Global m_renderpasses:TListEx = New TListEx
	Global m_use_renderpasses:Int = True
	
'#region Global-based stuffs
	
	Rem
		bbdoc: Get the singleton instance for the Protog2D driver.
		returns: Nothing.
	End Rem
	Function GetInstance:dProtog2DDriver()
		Return m_instance
	End Function
	
	Rem
		bbdoc: Initiate global variables and states.
		returns: Nothing.
	End Rem
	Function InitGlobal()
		If Not m_instance
			m_instance = New dProtog2DDriver
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
		bbdoc: Get the maximum texture size.
		returns: The maximum texture size, according to OpenGL.
	End Rem
	Function GetMaxTextureSize:Int()
		Return m_gl_maxtexturesize
	End Function
	
'#end region Global-based stuffs
	
'#region Extended methods
	
	Rem
		bbdoc: Get the graphics modes that can be used for a graphical context.
		returns: Nothing.
	End Rem
	Method GraphicsModes:TGraphicsMode[]()
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
	Method AttachGraphics:dProtog2DGraphics(widget:Int, flags:Int)
		Local gc:dProtog2DGraphics = New dProtog2DGraphics
		gc.m_context = bbGLGraphicsAttachGraphics(widget, flags)
		Return gc
	End Method
	
	Rem
		bbdoc: Create a new Protog2D graphical context.
		returns: Nothing.
		about: NOTE: This method is used internally by BlitzMax's graphics system, you probably won't need to touch this.
	End Rem
	Method CreateGraphics:dProtog2DGraphics(width:Int, height:Int, depth:Int, hertz:Int, flags:Int)
		Local gc:dProtog2DGraphics = New dProtog2DGraphics
		gc.m_context = bbGLGraphicsCreateGraphics(width, height, depth, hertz, flags)
		Return gc
	End Method
	
	Rem
		bbdoc: Set the graphics context for the driver.
		returns: Nothing.
	End Rem
	Method SetGraphics(gcontext:TGraphics)
		'DebugLog("(dProtog2DDriver.SetGraphics)")
		If Not gcontext
			bbGLGraphicsSetGraphics(Null)
			ClearGLContext()
		Else
			Local p2d_gcontext:dProtog2DGraphics = dProtog2DGraphics(gcontext)
			Assert p2d_gcontext, "(duct.protog2d.dProtog2DDriver.SetGraphics) Graphics context is not a Protog2DGraphics instance"
			Local context:Byte Ptr
			If p2d_gcontext <> Null
				context = p2d_gcontext.m_context
			End If
			bbGLGraphicsSetGraphics(context)
			ResetGLContext(p2d_gcontext)
		End If
		
	End Method
	
'#end region Extended methods
	
'#region Context
	
	Rem
		bbdoc: Reset the OpenGL context.
		returns: Nothing.
	End Rem
	Function ResetGLContext(gcontext:dProtog2DGraphics)
		Local gwidth:Int, gheight:Int
		Local gd:Int, gr:Int, gf:Int
		If m_glewinitiated = False
			InitGlew()
		End If
		ClearGLContext()
		gcontext.GetSettings(gwidth, gheight, gd, gr, gf)
		m_windowsize.Set(Float(gwidth), Float(gheight))
		
		glViewport(0, 0, gwidth, gheight)
		glMatrixMode(GL_PROJECTION)
		glLoadIdentity()
		
		glOrtho(0.0, gwidth, gheight, 0.0, -10.0, 10.0)
		SetViewport(New dVec4.Create(0.0, 0.0, Float(gwidth), Float(gheight)))
		
		' Buffer textures
		Local colorbuffers:dProtogTexture[4] ', depthtexture:dProtogTexture
		m_rendertexture = New dProtogTexture.CreateFromSize(gwidth, gheight, TEXTURE_RECTANGULAR)
		'm_accumtexture1 = New dGLTexture.CreateFromSize(gwidth, gheight, TEXTURE_RECTANGULAR)
		'depthtexture = New dGLTexture.CreateFromSize(gwidth, gheight, FORMAT_DEPTH, TEXTURE_RECTANGULAR)
		colorbuffers[0] = m_rendertexture
		colorbuffers[1] = Null 'm_accumtexture1
		colorbuffers[2] = Null
		colorbuffers[3] = Null
		m_renderbuffer = New dProtogFrameBuffer.Create(colorbuffers)
		CheckForErrors("dProtog2DDriver.ResetGLContext::end")
		Cls()
		If m_onflip_renderbuffer
			BindRenderBuffer()
		End If
	End Function
	
	Rem
		bbdoc: Clear the OpenGL context (reset everything to the initial values).
		returns: Nothing.
	End Rem
	Function ClearGLContext()
		m_windowsize.Set(0.0, 0.0)
		m_viewportpos.Set(0.0, 0.0)
		m_viewportsize.Set(0.0, 0.0)
		m_linewidth = 0
		m_state_blend = 0
		DestroyRenderBuffer()
		
		Local shader:dProtogShader
		For shader = EachIn m_renderpasses
			shader.Destroy()
		Next
		m_renderpasses.Clear()
		UnbindTextureTarget(GL_TEXTURE_RECTANGLE_EXT)
		UnbindTextureTarget(GL_TEXTURE_2D)
		glActiveTexture(GL_TEXTURE0)
	End Function
	
	Rem
		bbdoc: Check for and throw an exception for any OpenGL errors that have occured.
		returns: The error that was retrieved.
		about: This will throw the error type if there is an error, if there is no error nothing will be done.
	End Rem
	Function CheckForErrors:String(name:String = "__GENERIC__", dthrow:Int = True)
		Local err:Int = glGetError()
		If err <> GL_NO_ERROR
			Local str:String
			Select err
				Case GL_INVALID_ENUM
					str = "INVALID ENUM"
				Case GL_INVALID_VALUE
					str = "INVALID VALUE"
				Case GL_INVALID_OPERATION
					str = "INVALID OPERATION"
				Case GL_STACK_OVERFLOW
					str = "STACK OVERFLOW"
				Case GL_STACK_UNDERFLOW
					str = "STACK UNDERFLOW"
				Case GL_OUT_OF_MEMORY
					str = "OUT OF MEMORY"
				Case GL_TABLE_TOO_LARGE
					str = "TABLE TOO LARGE"
				Default
					str = "UNKNOWN"
			End Select
			If dthrow = True
				Throw("(dProtog2DDriver.CheckForErrors -- " + name + ") GL error: " + str)
			End If
			Return str
		End If
		Return Null
	End Function
	
'#end region Context
		
'#region Renderpass & shaders
	
	Rem
		bbdoc: Turn on or off the use of renderpass shaders.
		returns: Nothing.
		about: If @use is True renderpass shaders will be used upon flipping the screen, if @use is False, they will not be used.
	End Rem
	Function UseRenderPasses(use:Int)
		m_use_renderpasses = use
	End Function
	
	Rem
		bbdoc: Add the given shader as a render pass shader (used when the renderbuffer is rendered).
		returns: Nothing.
	End Rem
	Function AddRenderPassShader(shader:dProtogShader)
		If m_renderpasses.Contains(shader) = False
			m_renderpasses.AddLast(shader)
		End If
	End Function
	
	Rem
		bbdoc: Remove the given shader from the renderpass phase.
		returns: True if the given shader was removed, or False if it was not (the given shader was not found in the renderpass list).
	End Rem
	Method RemoveRenderPassShader:Int(shader:dProtogShader)
		Return m_renderpasses.Remove(shader)
	End Method
	
	Rem
		bbdoc: Check if the given shader is being used in the renderpass phase.
		returns: True if the given shader is in the renderpass list, or False if it is not.
	End Rem
	Function ContainsRenderPassShader:Int(shader:dProtogShader)
		Return m_renderpasses.Contains(shader)
	End Function
	
	Rem
		bbdoc: Remove all renderpass shaders.
		returns: Nothing.
	End Rem
	Method ClearRenderPassShaders()
		m_renderpasses.Clear()
	End Method
	
	Rem
		bbdoc: Setup the header parameters on the given shader material.
		returns: Nothing.
	End Rem
	Function SetupHeader(mat:dProtogMaterial)
		mat.SetTexture("p2d_rendertexture", m_rendertexture) 'm_accumtexture1
		mat.SetVec2("p2d_windowsize", m_windowsize)
		mat.SetVec2("p2d_viewportposition", m_viewportpos)
		mat.SetVec2("p2d_viewportsize", m_viewportsize)
	End Function
	
'#end region Renderpass & shaders
	
'#region Renderbuffer
	
	Rem
		bbdoc: Destroy the renderbuffer.
		returns: Nothing.
	End Rem
	Function DestroyRenderBuffer()
		If m_renderbuffer
			m_renderbuffer.Destroy()
		End If
		m_renderbuffer = Null
		If m_rendertexture
			m_rendertexture.Destroy()
			m_rendertexture = Null
		End If
		'If m_accumtexture1
		'	m_accumtexture1.Destroy()
		'	m_accumtexture1 = Null
		'End If
	End Function
	Rem
		bbdoc: Bind the renderbuffer (anything drawn will go to the renderbuffer).
		returns: Nothing.
	End Rem
	Function BindRenderBuffer()
		m_renderbuffer.Bind()
	End Function
	Rem
		bbdoc: Unbind the renderbuffer (will allow rendering to the backbuffer).
		returns: Nothing.
	End Rem
	Function UnbindRenderBuffer()
		dProtogFrameBuffer.UnBind()
	End Function
	Rem
		bbdoc: Turn on or off the drawing/usage of the renderbuffer.
		returns: Nothing.
	End Rem
	Function SetRenderBufferOnFlip(on_off:Int)
		m_onflip_renderbuffer = on_off
	End Function
	
	Rem
		bbdoc: Render the renderbuffer.
		returns: Nothing.
		about: This is called automatically before the backbuffer is flipped.
	End Rem
	Function RenderRenderBuffer(bufferization:Int = True)
		Local lastblend:Int = m_state_blend
		Local vport:dVec4 = New dVec4.Create(m_viewportpos.m_x, m_viewportpos.m_y, m_viewportsize.m_x, m_viewportsize.m_y)
		SetBlend(BLEND_SOLID)
		glColor4f(1.0, 1.0, 1.0, 1.0)
		Local quad:dVec4 = New dVec4.Create(0.0, 0.0, m_windowsize.m_x, m_windowsize.m_y)
		SetViewport(quad)
		'Print(m_viewportsize.m_x + " by " + m_viewportsize.m_y)
		If m_use_renderpasses = True And m_renderpasses.m_count > 0
			Local enum:TListEnum = m_renderpasses.ObjectEnumerator(), shader:dProtogShader
			'm_renderbuffer.DetachTexture(1)
			'm_renderbuffer.BindRenderBuffer()
			While enum.HasNext()
				shader = dProtogShader(enum.NextObject())
				'shader.m_material.SetTexture("p2d_rendertexture", m_accumtexture1)
				shader.Activate()
				m_renderbuffer.Render(quad, 0)
				shader.Deactivate()
			Wend
			'm_renderbuffer.AttachTexture(1, m_accumtexture1)
			'm_renderbuffer.BindRenderBuffer()
		Else
			If bufferization
				UnbindRenderBuffer()
			End If
			m_renderbuffer.Render(quad, 0)
			If bufferization
				BindRenderBuffer()
			End If
		End If
		SetViewport(vport)
		SetBlend(lastblend)
	End Function
	
'#end region Renderbuffer
	
'#region Rendering
	
	Rem
		bbdoc: Render the render buffer, and flip the backbuffer.
		returns: Nothing.
		about: This is used internally (sadly) by #{brl.graphics}.<br>
		Call #{brl.graphics.Flip} to flip the backbuffer, instead of this (it will call this method after it does the syncing voodoo).
	End Rem
	Method Flip(sync:Int)
		If m_onflip_renderbuffer = True
			RenderRenderBuffer()
		End If
		bbGLGraphicsFlip(sync)
	End Method
	
'#end region Rendering
	
'#region State functions
	
	Method ToString:String()
		Return "Protog2D"
	End Method
	
	Rem
		bbdoc: Set the active (bound) texture.
		returns: Nothing.
	End Rem
	Function SetActiveTexture(texture:dGLTexture)
		m_activetexture = texture
	End Function
	Rem
		bbdoc: Get the active (bound) texture.
		returns: The active texture..
	End Rem
	Function GetActiveTexture:dGLTexture()
		Return m_activetexture
	End Function
	
	Rem
		bbdoc: Bind the given texture.
		returns: Nothing.
	End Rem
	Function BindTexture(texture:dGLTexture, enabletarget:Int = True)
		If enabletarget
			glEnable(texture.m_target)
		End If
		glBindTexture(texture.m_target, texture.m_handle)
		SetActiveTexture(texture)
	End Function
	Rem
		bbdoc: Bind the given texture handle.
		returns: Nothing.
	End Rem
	Function BindTextureHandle(target:Int, handle:Int)
		glEnable(target)
		glBindTexture(target, handle)
		'SetActiveTexture(Null)
	End Function
	Rem
		bbdoc: Unbind the given texture target.
		returns: Nothing.
	End Rem
	Function UnbindTextureTarget(target:Int)
		glBindTexture(target, 0)
		glDisable(target)
		'SetActiveTexture(Null)
	End Function
	
	Rem
		bbdoc: If a texture is currently active (bound), unbind it.
		returns: Nothing.
	End Rem
	Function UnbindActiveTexture()
		If m_activetexture
			m_activetexture.Unbind()
			SetActiveTexture(Null)
		End If
	End Function
	
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
		bbdoc: Get the current blend state.
		returns: The current blend state.
	End Rem
	Function GetBlend:Int()
		Return m_state_blend
	End Function
	
	Rem
		bbdoc: Bind the given dProtogColor.
		returns: Nothing.
		about: If @alpha is True, the color's alpha will also be bound.
	End Rem
	Function BindPColor(color:dProtogColor, alpha:Int = True)
		m_color_curr.SetFromColor(color, alpha)
		If alpha
			glColor4fv(Varptr(m_color_curr.m_red))
		Else
			glColor3fv(Varptr(m_color_curr.m_red))
		End If
	End Function
	
	Rem
		bbdoc: Bind the given parameters to the color state.
		returns: Nothing.
	End Rem
	Function BindColorParams(red:Float, green:Float, blue:Float)
		m_color_curr.SetColor(red, green, blue)
		glColor4fv(Varptr(m_color_curr.m_red))
	End Function
	
	Rem
		bbdoc: Get the currently bound color.
		returns: The bound color in a #dProtogColor.
		about: NOTE: The color that is returned is not the object that was bound. The color returned is simply a clone of it (depending on the alpha setting).
	End Rem
	Function GetBoundColor:dProtogColor()
		Return m_color_curr
	End Function
	
	Rem
		bbdoc: Set the current alpha value.
		returns: Nothing.
	End Rem
	Function SetAlpha(alpha:Float)
		m_color_curr.SetAlpha(alpha)
		glColor4fv(Varptr(m_color_curr.m_red))
	End Function
	
	Rem
		bbdoc: Get the current alpha value.
		returns: The current alpha value.
	End Rem
	Function GetAlpha:Float()
		Return m_color_curr.m_alpha
	End Function
	
	Rem
		bbdoc: Set the color to be overlayed on the screen when #Cls is called.
		returns: Nothing.
	End Rem
	Function SetClsColor(color:dProtogColor)
		glClearColor(color.m_red, color.m_green, color.m_blue, color.m_alpha)
		m_color_cls.SetFromColor(color, True)
	End Function
	
	Rem
		bbdoc: Get the clear-screen color.
		returns: The color used to clear the screen.
	End Rem
	Function GetClsColor:dProtogColor()
		Return m_color_cls
	End Function
	
	Rem
		bbdoc: Set the line width.
		returns: Nothing.
	End Rem
	Function SetLineWidth(width:Float)
		m_linewidth = width
		glLineWidth(width)
	End Function
	Rem
		bbdoc: Get the current line width.
		returns: The current line width.
	End Rem
	Function GetLineWidth:Float()
		Return m_linewidth
	End Function
	
	Rem
		bbdoc: Set the graphical viewport (anything which is drawn outside of the current viewport will not appear on the screen).
		returns: Nothing.
	End Rem
	Function SetViewport(vport:dVec4)
		If vport.m_x = 0 And vport.m_y = 0 And vport.m_z = m_windowsize.m_x And vport.m_w = m_windowsize.m_y
			glDisable(GL_SCISSOR_TEST)
		Else
			glEnable(GL_SCISSOR_TEST)
			glScissor(vport.m_x, m_windowsize.m_y - vport.m_y - vport.m_w, vport.m_z, vport.m_w)
		End If
		m_viewportpos.Set(vport.m_x, vport.m_y)
		m_viewportsize.Set(vport.m_z, vport.m_w)
	End Function
	
	Rem
		bbdoc: Set the graphical viewport (anything which is drawn outside of the current viewport will not appear on the screen).
		returns: Nothing.
	End Rem
	Function SetViewportParams(x:Float, y:Float, width:Float, height:Float)
		SetViewport(New dVec4.Create(x, y, width, height))
	End Function
	
	Rem
		bbdoc: Get the viewport position vector.
		returns: The viewport position vector.
		about: NOTE: The returned value is %not a copy of the original. If you need to change the viewport, do so using #SetViewport of #SetViewportParams.
	End Rem
	Function GetViewportPosition:dVec2()
		Return m_viewportpos
	End Function
	
	Rem
		bbdoc: Get the viewport size vector.
		returns: The viewport size vector.
	End Rem
	Function GetViewportSize:dVec2()
		Return m_viewportsize
	End Function
	
	Rem
		bbdoc: Clear the screen.
		returns: Nothing.
		about: Either this function, or #{brl.graphics.Cls} can be called to clear the screen.
	End Rem
	Function Cls()
		glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT)
	End Function
	
'#end region (State functions)
	
'#region Pixmaps
	
	'Rem
	'	bbdoc: Draw the given pixmap at the position given.
	'	returns: Nothing.
	'End Rem
	'Method DrawPixmap(p:TPixmap, x:Int, y:Int)
	'	Local lastblend:Int = m_state_blend
	'	Local t:TPixmap
	'	
	'	glDisable(GL_TEXTURE_2D)
	'	glDisable(GL_TEXTURE_RECTANGLE_EXT)
	'	SetBlend(BLEND_SOLID)
	'	
	'	t = YFlipPixmap(p)
	'	If t.format <> PF_RGBA8888 Then t = ConvertPixmap(t, PF_RGBA8888)
	'	glRasterPos2i(0, 0)
	'	glBitmap(0, 0, 0, 0, x, - y - t.height, Null)
	'	glDrawPixels(t.width, t.height, GL_RGBA, GL_UNSIGNED_BYTE, t.pixels)
	'	
	'	SetBlend(lastblend)
	'	glDisable(GL_TEXTURE_2D)
	'	glDisable(GL_TEXTURE_RECTANGLE_EXT)
	'End Method
	
	Rem
		bbdoc: Grab the given area into a pixmap.
		returns: Nothing.
	End Rem
	Method GrabPixmap:TPixmap(x:Int, y:Int, w:Int, h:Int)
		Local lastblend:Int = m_state_blend
		Local p:TPixmap
		SetBlend(BLEND_SOLID)
		p = CreatePixmap(w, h, PF_RGBA8888)
		glReadPixels(x, m_windowsize.m_y - h - y, w, h, GL_RGBA, GL_UNSIGNED_BYTE, p.pixels)
		p = YFlipPixmap(p)
		SetBlend(lastblend)
		Return p
	End Method
	
'#end region (Pixmaps)
	
End Type

Rem
	bbdoc: Get the Protog2D driver instance.
	returns: The current instance of the Protog2D driver.
	about: The returned driver can be used with #SetGraphicsDriver to enable the Protog2D driver.
End Rem
Function Protog2DDriver:dProtog2DDriver()
	Return dProtog2DDriver.GetInstance()
End Function

dProtog2DDriver.InitGlobal()
SetGraphicsDriver(dProtog2DDriver.GetInstance())

