
Rem
	extra.bmx (Contains: dui_VirtualGraphics(), MouseIn and point-in routines, )
End Rem

Rem
	bbdoc: Set virtual graphics resolution.
	returns: Nothing.
End Rem
Function dui_VirtualGraphics(width:Int = 640, Height:Int = 480)

	?Win32
	Local D3D7Driver:TD3D7Max2DDriver = TD3D7Max2DDriver(_max2dDriver)
	
	If D3D7Driver
		Local Matrix:Float[] = [2.0 / width, 0.0, 0.0, 0.0,  ..
			0.0, - 2.0 / Height, 0.0, 0.0,  ..
			0.0, 0.0, 1.0, 0.0,  ..
			- 1 - (1.0 / width), 1 + (1.0 / Height), 1.0, 1.0]
		
		D3D7Driver.device.SetTransform(D3DTS_PROJECTION, Matrix)
		
	Else
	?
		
		glMatrixMode(GL_PROJECTION)
		glLoadIdentity()
		glortho(0, width, height, 0, 0, 1)
		glMatrixMode(GL_MODELVIEW)
		glLoadIdentity()
		
	?win32
	End If
	?
	
End Function

Rem
	bbdoc: Check if the mouse is within a rectangle.
	returns: True if the mouse is within the given rectangle, or False if it is not.
	about: Used by the GUI to determine if the mouse is within a given area.
End Rem
Function dui_MouseIn:Int(x:Int, y:Int, w:Int, h:Int)
	
	If MouseX() >= X And MouseX() <= (X + w) And MouseY() >= Y And MouseY() <= (Y + h)
		Return True
	Else
		Return False
	End If
	
End Function

Rem
	bbdoc: Check if the mouse is within a circle.
	returns: True if the mouse is in the given circle, or False if it is not.
	about: Used by the GUI to determine if the mouse is within a given area.
End Rem
Function dui_MouseInCircle:Int(x:Int, y:Int, radius:Float)
	
	'uses basic trigonometry.
	Local xdist:Float = Abs(x - MouseX())
	Local ydist:Float = Abs(y - MouseY())
	Local dist:Float = Sqr(Float(xdist * xdist) + Float(ydist * ydist))
	
	If dist < radius Then Return True Else Return false
	
End Function

Rem
	bbdoc: Check if a rectangle is inside the viewport, at least partially.
	returns: True if the given rectangle is within the viewport dimensions, or False if it is not.
	about: Used by the system to avoid drawing things you can't see anyway
End Rem
Function dui_IsInViewport:Int(x:Int, y:Int, w:Int, h:Int)
	
	'get viewport settings
	Local vx:Int, vy:Int, vw:Int, vh:Int
	GetViewport(vx, vy, vw, vh)
	
	'set up collision flags
	Local xc:Int = False
	Local yc:Int = False
	
	'check for overlap
	'check if there's a collision on the x axis
	If (X < vx) And (X + w) >= vx Then xc = True
	If (X >= vx) And (X <= (vx + vw)) Then xc = True
	
	'check if there's a collision on the y axis
	If (Y < vy) And (Y + w) >= vy Then yc = True
	If (Y >= vy) And (Y <= (vy + vh)) Then yc = True
	
	'return the value
	Return (yc And xc)
	
End Function	


















