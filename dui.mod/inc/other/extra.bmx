
Rem
	extra.bmx (Contains: dui_MouseIn(), dui_MouseInCircle(), dui_IsInViewport(),  )
End Rem

Rem
	bbdoc: Check if the mouse is within a rectangle.
	returns: True if the mouse is within the given rectangle, or False if it is not.
	about: Used by the GUI to determine if the mouse is within a given area.
End Rem
Function dui_MouseIn:Int(x:Int, y:Int, w:Int, h:Int)
	If MouseX() >= x And MouseX() <= (x + w) And MouseY() >= y And MouseY() <= (y + h)
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
	Local xdist:Float = Abs(x - MouseX())
	Local ydist:Float = Abs(y - MouseY())
	Local dist:Float = Sqr(Float(xdist * xdist) + Float(ydist * ydist))
	
	If dist < radius
		Return True
	Else
		Return False
	End If
End Function

Rem
	bbdoc: Check if a rectangle is inside the viewport, at least partially.
	returns: True if the given rectangle is within the viewport dimensions, or False if it is not.
	about: Used by the system to avoid drawing things you can't see anyway
End Rem
Function dui_IsInViewport:Int(x:Int, y:Int, w:Int, h:Int)
	Local pos:TVec2, size:TVec2
	Local xc:Int, yc:Int
	
	pos = TProtog2DDriver.GetViewportPosition()
	size = TProtog2DDriver.GetViewportSize()
	
	If (x < pos.m_x) And (x + w) >= pos.m_x
		xc = True
	End If
	If (x >= pos.m_x) And (x <= (pos.m_x + size.m_x))
		xc = True
	End If
	
	If (y < pos.m_y) And (y + w) >= pos.m_y
		yc = True
	End If
	If (y >= pos.m_y) And (y <= (pos.m_y + size.m_y))
		yc = True
	End If
	Return (yc And xc)
End Function

