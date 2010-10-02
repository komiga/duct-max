
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
	bbdoc: #dTileMap object position.
End Rem
Type dMapPos
	
	Field m_x:Int, m_y:Int, m_z:Int
	
	Rem
		bbdoc: Create a new position.
		returns: Itself.
	End Rem
	Method Create:dMapPos(x:Int, y:Int, z:Int)
		Set(x, y, z)
		Return Self
	End Method
	
'#region Field accessors
	
	Rem
		bbdoc: Set the position for this map position by the given map position.
		returns: Nothing.
	End Rem
	Method SetByPos(pos:dMapPos)
		m_x = pos.m_x
		m_y = pos.m_y
		m_z = pos.m_z
	End Method
	
	Rem
		bbdoc: Set the position for this map position.
		returns: Nothing.
	End Rem
	Method Set(x:Int, y:Int, z:Int)
		m_x = x
		m_y = y
		SetZ(z)
	End Method
	
	Rem
		bbdoc: Get the position for this map position.
		returns: Nothing. The parameters are set to their respective values.
	End Rem
	Method Get(x:Int Var, y:Int Var, z:Int Var)
		x = m_x
		y = m_y
		z = m_z
	End Method
	
	Rem
		bbdoc: Set the x position for this map position.
		returns: Nothing.
	End Rem
	Method SetX(x:Int)
		m_x = x
	End Method
	
	Rem
		bbdoc: Get the x position for this map position.
		returns: The x position for this map position.
	End Rem
	Method GetX:Int()
		Return m_x
	End Method
	
	Rem
		bbdoc: Set the y position for this map position.
		returns: Nothing.
	End Rem
	Method SetY(y:Int)
		m_y = y
	End Method
	
	Rem
		bbdoc: Get the y position for this map position.
		returns: The y position for this map position.
	End Rem
	Method GetY:Int()
		Return m_y
	End Method
	
	Rem
		bbdoc: Set the z position for this map position.
		returns: Nothing.
	End Rem
	Method SetZ(z:Int)
		If z < -127
			m_z = -127
		Else If z > 127
			m_z = 127
		Else
			m_z = z
		End If
	End Method
	
	Rem
		bbdoc: Get the z position for this map position.
		returns: The z position for this map position.
	End Rem
	Method GetZ:Int()
		Return m_Z
	End Method
	
'#end region Field accessors
	
	Rem
		bbdoc: Check if this position and the given position are equal.
		returns: True if both positions are equal, or False if they are not.
	End Rem
	Method Equals:Int(pos:dMapPos)
		If (pos.m_x = m_x) And (pos.m_y = m_y) And (pos.m_z = m_z)
			Return True
		End If
		Return False
	End Method
	
	Rem
		bbdoc: Get the distance between the two positions.
		returns: The distance (in tiles) between the two positions.
	End Rem
	Method DistanceTo:Int(pos:dMapPos)
		Return Sqr((pos.m_x - m_x) * (pos.m_x - m_x) + (pos.m_y - m_y) * (pos.m_y - m_y))
	End Method
	
	Rem
		bbdoc: Check if the two positions are within the given range of eachother.
		returns: True if the positions are within @range, or False if they are not.
	End Rem
	Method IsInRange:Int(pos:dMapPos, range:Int)
		Return (m_x >= (pos.m_x - range)) And ..
				(m_x <= (pos.m_x + range)) And ..
				(m_y >= (pos.m_y - range)) And ..
				(m_y <= (pos.m_y + range))
	End Method
	
End Type

