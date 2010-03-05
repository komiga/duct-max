
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

Rem
	bbdoc: Protog2D primitive rendering functions.
End Rem
Type dProtogPrimitives
	
	Rem
		bbdoc: Draw a rectangle to the given positions.
		returns: Nothing.
		about: If @filled is true the rectangle will be filled, if it is false the rectangle will be hollow.
	End Rem
	Function DrawRectangle(x0:Float, y0:Float, x1:Float, y1:Float, filled:Int = True)
		If filled = True
			glBegin(GL_QUADS)
		Else
			glBegin(GL_LINE_LOOP)
		End If
			glVertex2f(x0, y0)
			glVertex2f(x1, y0)
			glVertex2f(x1, y1)
			glVertex2f(x0, y1)
		glEnd()
	End Function
	
	Rem
		bbdoc: Draw a rectangle to the given size.
		returns: Nothing.
		about: If @filled is true the rectangle will be filled, if it is false the rectangle will be hollow.
	End Rem
	Function DrawRectangleToSize(x:Float, y:Float, width:Float, height:Float, filled:Int = True)
		DrawRectangle(x, y, x + width, y + height, filled)
	End Function
	
	Rem
		bbdoc: Draw a rectangle to the given vectors (using @size as the width and height).
		returns: Nothing.
		about: If @filled is true the rectangle will be filled, if it is false the rectangle will be hollow.
	End Rem
	Function DrawRectangleToSizeVec2(pos:dVec2, size:dVec2, filled:Int = True)
		DrawRectangle(pos.m_x, pos.m_y, pos.m_x + size.m_x, pos.m_y + size.m_y, filled)
	End Function
	
	Rem
		bbdoc: Draw a rectangle to the given size.
		returns: Nothing.
		about: If @filled is true the rectangle will be filled, if it is false the rectangle will be hollow.
	End Rem
	Function DrawRectangleToSizeVec4(dimensions:dVec4, filled:Int = True)
		DrawRectangle(dimensions.m_x, dimensions.m_y, dimensions.m_x + dimensions.m_z, dimensions.m_y + dimensions.m_w, filled)
	End Function
	
	Rem
		bbdoc: Draw a rectangle to the given size.
		returns: Nothing.
		about: If @filled is true the rectangle will be filled, if it is false the rectangle will be hollow.
	End Rem
	Function DrawRectangleVec4(dimensions:dVec4, filled:Int = True)
		DrawRectangle(dimensions.m_x, dimensions.m_y, dimensions.m_z, dimensions.m_w, filled)
	End Function
	
	Rem
		bbdoc: Draw a line to the two given positions.
		returns: Nothing.
	End Rem
	Function DrawLine(x0:Float, y0:Float, x1:Float, y1:Float)
		glBegin(GL_LINES)
			glVertex2f(x0 + 0.5, y0 + 0.5)
			glVertex2f(x1 + 0.5, y1 + 0.5)
		glEnd()
	End Function
	
	Rem
		bbdoc: Draw a line to the two given vectors.
		returns: Nothing.
	End Rem
	Function DrawLineVec2(vec0:dVec2, vec1:dVec2)
		glBegin(GL_LINES)
			glVertex2f(vec0.m_x + 0.5, vec0.m_y + 0.5)
			glVertex2f(vec1.m_x + 0.5, vec1.m_y + 0.5)
		glEnd()
	End Function
	
	Rem
		bbdoc: Draw a line to the two given vectors.
		returns: Nothing.
	End Rem
	Function DrawLineVec4(vec:dVec4)
		glBegin(GL_LINES)
			glVertex2f(vec.m_x + 0.5, vec.m_y + 0.5)
			glVertex2f(vec.m_z + 0.5, vec.m_w + 0.5)
		glEnd()
	End Function
	
End Type

