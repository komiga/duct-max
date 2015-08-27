
Rem
Copyright (c) 2010 plash <plash@komiga.com>

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
	Local xc:Int, yc:Int
	Local pos:dVec2 = dProtog2DDriver.GetViewportPosition()
	Local size:dVec2 = dProtog2DDriver.GetViewportSize()
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

