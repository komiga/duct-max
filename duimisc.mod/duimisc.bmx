
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

SuperStrict

Rem
bbdoc: dui miscellaneous module
End Rem
Module duct.duimisc

ModuleInfo "Version: 1.2"
ModuleInfo "Copyright: Liam McGuigan (FryGUI creator)"
ModuleInfo "Copyright: Coranna Howard <me@komiga.com> (dui is a heavily modified FryGUI)"
ModuleInfo "License: MIT"

ModuleInfo "History: Version 1.2"
ModuleInfo "History: General cleanup"
ModuleInfo "History: Version 1.01"
ModuleInfo "History: Cleanup"
ModuleInfo "History: Version 1.0"
ModuleInfo "History: Initial release"

Import brl.retro

Rem
	bbdoc: Remove an element from an array of integers.
	returns: Nothing.
End Rem
Function RemoveArrayElement(array:Int[] Var, element:Int)
	array[element] = array[array.length - 1]
	array = array[..array.length - 1]
End Function

Rem
	bbdoc: Remove an element from an array of strings.
	returns: Nothing.
End Rem
Function RemoveArrayElementStr(array:String[] Var, element:Int)
	array[element] = array[array.length - 1]
	array = array[..array.length - 1]
End Function

Rem
	bbdoc: Split a string into an array, with a given @separator.
	returns: a string array containing the components of the string.
	about: Used by the GUI to fetch a gadget, given its URL.
End Rem
Function dui_SplitString:String[] (str:String, separator:String)
	Local textarray:String[1]
	Local rtext:String = str
	Local index:Int = 0
	Repeat
		If rtext.Length = 0
			Exit
		End If
		Local sp_p:Int = rtext.Find(separator)
		If sp_p = -1
			textarray[index] = rtext
			Exit
		End If
		textarray[index] = rtext[..sp_p]
		rtext = rtext[rtext.Length - (rtext.Length - sp_p) - 1..]
		index:+1
		textarray = textarray[..index + 1]
	Forever
	Return textarray
End Function

Rem
	bbdoc: Set RGB values from a 24-bit Hex string.
	returns: Nothing.
	about: Decodes @col, and stores it in the @r @g and @b variables.
End Rem
Function dui_HexColor(col:String, r:Int Var, g:Int Var, b:Int Var)
	If col.Length = 6
		r = Int("$" + col[0..2])
		g = Int("$" + col[2..4])
		b = Int("$" + col[4..6])
	End If
End Function

Rem
	bbdoc: Return a color value in hex.
	returns: A hexidecimal color value.
End Rem
Function dui_ColorToHex:String(color:Int[])
	Return Hex(color[0])[6..8] + Hex(color[1])[6..8] + Hex(color[2])[6..8]
End Function

Rem
	bbdoc: Find the point of intersection of two lines.
	returns: True if the lines intersect (@xi and @yi will be the point of intersection), or False if they do not intersect. 
End Rem
Function dui_LineIntersection:Int(xi:Float Var, yi:Float Var, x1:Float, y1:Float, x2:Float, y2:Float, x3:Float, y3:Float, x4:Float, y4:Float)
	Local l1x:Float = x2 - x1
	Local l1y:Float = y2 - y1
	Local l2x:Float = x4 - x3
	Local l2y:Float = y4 - y3
	Local l1d:Float = (y3 - y1 + (l2y / l2x) * (x1 - x3)) / (l1y - l2y * l1x / l2x)
	If l1d >= 0 And l1d <= 1		' If intersection lies on first line
		Local l2d:Float = (x1 + l1x * l1d - x3) / l2x
		If l2d >= 0 And l2d <= 1	' If intersection also lies on second line
			xi = x1 + l1d * l1x
			yi = y1 + l1d * l1y
			Return True
		End If
	End If
	Return False
End Function

Rem
	bbdoc: Get the index for a string in a string array.
	returns: The index of the string if it was found, or -1 if it was not found in the array.
	about: NOTE: This is not case sensitive.
End Rem
Function dui_SelectString:Int(array:String[], str:String)
	str = str.ToLower()
	For Local count:Int = 0 Until array.Length
		If array[count].ToLower() = str
			Return count
		End If
	Next
	Return -1
End Function

