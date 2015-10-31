
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
	bbdoc: duct Protog2D graphics (handles the Protog2D driver and graphical context).
End Rem
Type dProtogGraphics
	
	Field m_vsync:Int = -1
	Field m_width:Int, m_height:Int, m_depth:Int, m_hertz:Int, m_flags:Int
	
	Field m_gcontext:dProtog2DGraphics
	Field m_driver_context:dProtog2DDriver
	
	Rem
		bbdoc: Create a dProtogGraphics.
		returns: Itself.
	End Rem
	Method Create:dProtogGraphics(width:Int, height:Int, depth:Int = 0, hertz:Int = 60, flags:Int = GRAPHICS_BACKBUFFER | GRAPHICS_DEPTHBUFFER, vsync:Int = -1, create_window:Int = True)
		SetWidth(width, False)
		SetHeight(height, False)
		SetDepth(depth, False)
		SetHertz(hertz, False)
		SetFlags(flags, False)
		SetVSyncState(vsync)
		SetDriver(create_window)
		Return Self
	End Method
	
	Rem
		bbdoc: Set the graphics' driver.
		returns: Nothing.
	End Rem
	Method SetDriver(remake_gwindow:Int = True)
		m_driver_context = dProtog2DDriver.GetInstance()
		brl.Graphics.SetGraphicsDriver(m_driver_context)
		If remake_gwindow = True
			Local started:Int
			started = StartGraphics()
			Assert started, "Failed to create graphics mode to " + m_width + "x" + m_height + ", " + m_depth + " @" + m_hertz + "hz"
		End If
	End Method
	
	Rem
		bbdoc: Start the graphics window.
		returns: True if the graphics window was created, or False if it was not (invalid GraphicsMode).
	End Rem
	Method StartGraphics:Int()
		If brl.Graphics.GraphicsModeExists(m_width, m_height, m_depth, m_hertz) = True
			m_gcontext = dProtog2DGraphics(brl.Graphics.Graphics(m_width, m_height, m_depth, m_hertz, m_flags))
			Return True
		End If
		Return False
	End Method
	
'#region Field accessors
	
	Rem
		bbdoc: Get the driver context.
		returns: Nothing.
	End Rem
	Method GetDriverContext:dProtog2DDriver()
		Return m_driver_context
	End Method
	
	Rem
		bbdoc: Set the vertical sync state.
		returns: Nothing.
		about: @sync can be either -1 (automatic, also the default), 0 (off) or 1 (on).
	End Rem
	Method SetVSyncState(sync:Int = -1)
		Assert Not(sync < -1 Or sync > 1), "(dProtogGraphics.SetVSyncState) @sync must be either -1, 0, or 1"
		m_vsync = sync
	End Method
	
	Rem
		bbdoc: Get the vertical sync state.
		returns: The current VSync state.
		about: The return value will be either -1 (automatic), 0 (off) or 1 (on).
	End Rem
	Method GetVSyncState:Int()
		Return m_vsync
	End Method
	
	Rem
		bbdoc: Set the dimensions for the graphics window.
		returns: Nothing.
		about: If @remake_gwindow is True, the graphics context will be automatically re-opened.
	End Rem
	Method SetDimensions(width:Int, height:Int, remake_gwindow:Int = True)
		SetWidth(width)
		SetHeight(height)
		If remake_gwindow = True
			Local started:Int
			started = StartGraphics()
			Assert started, "Failed to create graphics mode to " + m_width + "x" + m_height + ", " + m_depth + " @" + m_hertz + "hz"
		End If
	End Method
	
	Rem
		bbdoc: Set the width for the graphics window.
		returns: Nothing.
		about: If @remake_gwindow is True, the graphics context will be automatically re-opened.
	End Rem
	Method SetWidth(width:Int, remake_gwindow:Int = True)
		m_width = width
		If remake_gwindow = True
			Local started:Int
			started = StartGraphics()
			Assert started, "Failed to create graphics mode to " + m_width + "x" + m_height + ", " + m_depth + " @" + m_hertz + "hz"
		End If
	End Method
	
	Rem
		bbdoc: Get the width for the graphics window.
		returns: Get the width of the graphics window.
	End Rem
	Method GetWidth:Int()
		Return m_width
	End Method
	
	Rem
		bbdoc: Set the height for the graphics window.
		returns: Nothing.
		about: If @remake_gwindow is True, the graphics context will be automatically re-opened.
	End Rem
	Method SetHeight(height:Int, remake_gwindow:Int = True)
		m_height = height
		If remake_gwindow = True
			Local started:Int
			started = StartGraphics()
			Assert started, "Failed to create graphics mode to " + m_width + "x" + m_height + ", " + m_depth + " @" + m_hertz + "hz"
		End If
	End Method
	
	Rem
		bbdoc: Get the height for the graphics window.
		returns: Get the height of the graphics window.
	End Rem
	Method GetHeight:Int()
		Return m_height
	End Method
	
	Rem
		bbdoc: Set the depth for the graphics window.
		returns: Nothing.
		about: If @remake_gwindow is True, the graphics context will be automatically re-opened.
	End Rem
	Method SetDepth(depth:Int, remake_gwindow:Int = True)
		m_depth = depth
		If remake_gwindow = True
			Local started:Int
			started = StartGraphics()
			Assert started, "Failed to create graphics mode to " + m_width + "x" + m_height + ", " + m_depth + " @" + m_hertz + "hz"
		End If
	End Method
	
	Rem
		bbdoc: Get the depth for the graphics window.
		returns: The depth of the graphics window.
	End Rem
	Method GetDepth:Int()
		Return m_depth
	End Method
	
	Rem
		bbdoc: Set the hertz for the graphics window.
		returns: Nothing.
		about: If @remake_gwindow is True, the graphics context will be automatically re-opened.
	End Rem
	Method SetHertz(hertz:Int, remake_gwindow:Int = True)
		m_hertz = hertz
		If remake_gwindow = True
			Local started:Int
			started = StartGraphics()
			Assert started, "Failed to create graphics mode to " + m_width + "x" + m_height + ", " + m_depth + " @" + m_hertz + "hz"
		End If
	End Method
	
	Rem
		bbdoc: Get the hertz for the graphics window.
		returns: The hertz for the graphics window.
	End Rem
	Method GetHertz:Int()
		Return m_hertz
	End Method
	
	Rem
		bbdoc: Set the flags for the graphics window.
		returns: Nothing.
		about: If @remake_gwindow is True, the graphics context will be automatically re-opened.
	End Rem
	Method SetFlags(flags:Int, remake_gwindow:Int = True)
		m_flags = flags
		If remake_gwindow = True
			Local started:Int
			started = StartGraphics()
			Assert started, "Failed to create graphics mode to " + m_width + "x" + m_height + ", " + m_depth + " @" + m_hertz + "hz"
		End If
	End Method
	
	Rem
		bbdoc: Get the flags for the graphics window.
		returns: The flags for the graphics window.
	End Rem
	Method GetFlags:Int()
		Return m_flags
	End Method
	
	Rem
		bbdoc: Get the current graphics context.
		returns: Nothing.
	End Rem
	Method GetGraphicsContext:dProtog2DGraphics()
		Return m_gcontext
	End Method
	
'#end region Field accessors
	
	Rem
		bbdoc: Close the graphical window.
		returns: Nothing.
	End Rem
	Method Close()
		'If m_driver_context <> Null
			'm_driver_context.DestroyRenderBuffer()
		'End If
		'If m_gcontext <> Null
		'	m_gcontext.Close()
		'End If
		brl.Graphics.EndGraphics()
	End Method
	
	Rem
		bbdoc: Clear the screen.
		Returns: Nothing.
	End Rem
	Method Cls()
		m_driver_context.Cls()
	End Method
	
	Rem
		bbdoc: Flip the backbuffer.
		returns: Nothing.
	End Rem
	Method Flip()
		brl.Graphics.Flip(m_vsync)
	End Method
	
End Type

Rem
	bbdoc: Wrapper type for Protog2D graphical applications (extend this).
End Rem
Type dProtogGraphicsApp Extends dGraphicsApp Abstract
	
	Field m_graphics:dProtogGraphics
	
	Rem
		bbdoc: Create a Protog2D graphics application.
		returns: Itself.
	End Rem
	Method Create:dProtogGraphicsApp()
		OnInit()
		Return Self
	End Method
	
	Rem
		bbdoc: This method is called when the app is initialized.
		returns: Nothing.
	End Rem
	Method OnInit() Abstract
	
	Rem
		bbdoc: This method is called when the app is shutdown.
		returns: Nothing.
		about: This method should be overloaded and call back to its super OnExit method (the graphical context is closed by the first implementation).
	End Rem
	Method OnExit()
		dProtog2DDriver.ClearGLContext()
		If m_graphics
			m_graphics.Close()
		End If
	End Method
	
	Rem
		bbdoc: Run the app.
		returns: Nothing.
	End Rem
	Method Run() Abstract
	
	Rem
		bbdoc: Do any rendering.
		returns: Nothing.
	End Rem
	Method Render() Abstract
	
	Rem
		bbdoc: Do logic updates (fps, mouse & keyboard input, etc).
		returns: Nothing.
	End Rem
	Method Update() Abstract
	
	Rem
		bbdoc: Shutdown the app.
		returns: Nothing.
		about: This will call OnExit.
	End Rem
	Method Shutdown()
		OnExit()
	End Method
	
End Type

