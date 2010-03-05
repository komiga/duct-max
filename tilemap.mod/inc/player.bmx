
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
	bbdoc: Generic #dTileMap player.
	about: This type is abstract, you must extend it.
End Rem
Type dTileMapPlayer Abstract
	
	Field m_visrange:Int
	Field m_pos:dMapPos
	Field m_animmovement:dVec3
	
	Method New()
		m_pos = New dMapPos
		m_animmovement = New dVec3
	End Method
	
	Rem
		bbdoc: Initiate the player.
		returns: Nothing.
		about: The position and animation movement fields are automatically created when a new instance is created.
	End Rem
	Method Init(visrange:Int)
		SetVisRange(visrange)
	End Method
	
'#region Field accessors
	
	Rem
		bbdoc: Set the visibility range for the player.
		returns: Nothing.
		about: @visrange will be clamped to [a>=1].
	End Rem
	Method SetVisRange(visrange:Int)
		If visrange < 1
			m_visrange = 1
		Else
			m_visrange = visrange
		End If
	End Method
	
	Rem
		bbdoc: Get the visibility range for the player.
		returns: The player's visibility range.
	End Rem
	Method GetVisRange:Int()
		Return m_visrange
	End Method
	
	Rem
		bbdoc: Set the player's position by the given values.
		returns: Nothing.
		about: NOTE: The parameters given should already have been clamped to the map's size.
	End Rem
	Method SetPositionParams(x:Int, y:Int, z:Int)
		m_pos.m_x = x
		m_pos.m_y = y
		m_pos.SetZ(z)
	End Method
	
'#end region (Field accessors)
	
End Type

