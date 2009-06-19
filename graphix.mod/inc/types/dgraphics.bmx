
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
	
	dgraphics.bmx (Contains: TDGraphics, )
	
	TODO:
		Wrap the graphical context completely (get access to the driver, and stop using SetGraphicsDriver).
		
	
End Rem

Rem
	bbdoc: The DGraphics OpenGL driver.
End Rem
Const DGFX_DRIVER_OGL:Int = 1
Rem
	bbdoc: The DGraphics D3D7 driver.
End Rem
Const DGFX_DRIVER_D3D7:Int = 2

Rem
	bbdoc: The DGraphics type.
End Rem
Type TDGraphics
	
	Field m_width:Int, m_height:Int, m_depth:Int, m_hertz:Int, m_flags:Int
	Field m_driver:Int
	Field m_gfx:TMax2DGraphics
	
		Method New()
		End Method
		
		Rem
			bbdoc: Create a new DGraphics.
			returns: The new DGraphics (itself).
		End Rem
		Method Create:TDGraphics(gdriver:Int, width:Int, height:Int, depth:Int = 0, hertz:Int = 60, flags:Int = 0)
			
			SetWidth(width)
			SetHeight(height)
			
			SetDriver(gdriver, False)
			
			Return Self
			
		End Method
		
		Rem
			bbdoc: Set the driver for this DGraphics.
			returns: True if the driver was set, or False if it was not (invalid driver).
		End Rem
		Method SetDriver:Int(gdriver:Int, remake_gwindow:Int = True)
			
			m_driver = gdriver
			
			Select m_driver
				Case DGFX_DRIVER_OGL
					SetGraphicsDriver(GLMax2DDriver())
					
				Case DGFX_DRIVER_D3D7
					?Win32
						SetGraphicsDriver(D3D7Max2DDriver())
					?
					
				Default
					Return False
					
			End Select
			
			If remake_gwindow = True
				StartGraphics()
			End If
			
			Return True
			
		End Method
		
		Rem
			bbdoc: Get the current driver.
			returns: The current driver for this DGraphics.
		End Rem
		Method GetDriver:Int()
			
			Return m_driver
			
		End Method
		
		Rem
			bbdoc: Start the graphics window.
			returns: Nothing.
		End Rem
		Method StartGraphics()
			
			m_gfx = TMax2DGraphics(Graphics(m_width, m_height, m_depth, m_hertz, m_flags))
			
		End Method
		
		Rem
			bbdoc: Set the dimensions for the graphics window.
			returns: Nothing.
		End Rem
		Method SetDimensions(width:Int, height:Int, remake_gwindow:Int = True)
			
			SetWidth(width)
			SetHeight(height)
			
			If remake_gwindow = True
				StartGraphics()
			End If
			
		End Method
		
		Rem
			bbdoc: Set the width for the graphics window.
			returns: Nothing.
		End Rem
		Method SetWidth(width:Int)
			
			m_width = width
			
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
		End Rem
		Method SetHeight(height:Int)
			
			m_height = height
			
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
		End Rem
		Method SetDepth(depth:Int, remake_gwindow:Int = True)
			
			m_depth = depth
			
			If remake_gwindow = True
				StartGraphics()
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
		End Rem
		Method SetHertz(hertz:Int, remake_gwindow:Int = True)
			
			m_hertz = hertz
			
			If remake_gwindow = True
				StartGraphics()
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
		End Rem
		Method SetFlags(flags:Int, remake_gwindow:Int = True)
			
			m_flags = flags
			
			If remake_gwindow = True
				StartGraphics()
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
		Method GetGraphics:TMax2DGraphics()
			
			Return m_gfx
			
		End Method
		
		Rem
			bbdoc: Clear the screen.
			Returns: Nothing.
		End Rem
		Method Cls()
			
			brl.max2d.Cls()
			
		End Method
		
		Rem
			bbdoc: Flip the backbuffer.
			returns: Nothing.
		End Rem
		Method Flip(sync:Int = -1)
			
			brl.Graphics.Flip(sync)
			
		End Method
		
End Type












































