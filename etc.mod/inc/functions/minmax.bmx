
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
	
	minmax.bmx (Contains: IntMin(), IntMax(), FloatMin(), FloatMax(), )
	
End Rem

Rem
	bbdoc: Round an integer (up) to @_min.
	returns: If @_value is less than @_min, @_min is returned, otherwise @_value is returned.
End Rem
Function IntMin:Int(_value:Int, _min:Int)
	
	If _value < _min Then Return _min
	
	Return _value
	
End Function

Rem
	bbdoc: Round an integer (down) to @_max.
	returns: If @_value is greater than @_max, @_max is returned, otherwise @_value is returned.
End Rem
Function IntMax:Int(_value:Int, _max:Int)
	
	If _value > _max Then Return _max
	
	Return _value
	
End Function


Rem
	bbdoc: Round a float (up) to @_min.
	returns: If @_value is less than @_min, @_min is returned, otherwise @_value is returned.
End Rem
Function FloatMin:Float(_value:Float, _min:Float)
	
	If _value < _min Then Return _min
	
	Return _value
	
End Function

Rem
	bbdoc: Round an float (down) to @_max.
	returns: If @_value is greater than @_max, @_max is returned, otherwise @_value is returned.
End Rem
Function FloatMax:Int(_value:Int, _max:Int)
	
	If _value > _max Then Return _max
	
	Return _value
	
End Function





















