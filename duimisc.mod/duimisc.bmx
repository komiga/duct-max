
' Copyright (c) 2009 Tim Howard
' 
' Permission is hereby granted, free of charge, to any person obtaining a copy
' of this software and associated documentation files (the "Software"), to deal
' in the Software without restriction, including without limitation the rights
' to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
' copies of the Software, and to permit persons to whom the Software is
' furnished to do so, subject to the following conditions:
' 
' The above copyright notice and this permission notice shall be included in
' all copies or substantial portions of the Software.
' 
' THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
' IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
' FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
' AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
' LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
' OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
' THE SOFTWARE.
' 

SuperStrict

Rem
bbdoc: dui miscellaneous module
End Rem
Module duct.duimisc

ModuleInfo "Version: 1.0"
ModuleInfo "Copyright: Liam McGuigan (FryGUI creator), Tim Howard (dui is a largely modified FryGUI)"
ModuleInfo "License: MIT"

ModuleInfo "History: Version 1.0"
ModuleInfo "History: Initial release"

' Used modules
Import brl.linkedlist
Import brl.max2d
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
	
	Local Text_Array:String[1]
	Local R_Text:String = str
	Local i:Int = 0
	
	Repeat
		If R_Text.Length = 0 Then Exit
			Local sp_p:Int = R_Text.Find(separator)
			If sp_p = -1 Then
				Text_Array[I] = R_Text
				Exit
			End If
			
			Text_Array[I] = R_Text[..sp_p]
			R_Text = R_Text[R_Text.Length - (R_Text.Length - sp_p) - 1..]
			I:+1
			Text_Array = Text_Array[..I + 1]
			
	Forever
	
	Return Text_Array
	
End Function


Rem
	bbdoc: The list type is a base type, with a gLink field and methods to allow easy adding and removing from lists
End Rem
'Type ListType
'	
'	Field gLink:TLink
'	
'		Method AddLast(list:TList)
'			
'			gLink = list.AddLast(Self)
'			
'		End Method
'		
'		Method AddFirst(list:TList)
'			
'			gLink = list.AddFirst(Self)
'			
'		End Method
'		
'		Method Remove()
'			gLink.Remove()
'			gLink = Null
'			
'		End Method
'		
'End Type

Rem
	bbdoc: Set RGB values from a 24-bit Hex string.
	returns: Nothing.
	about: Decodes @col, and stores it in the @r @g and @b variables.
End Rem
Function dui_HexColour(col:String, r:Int Var, g:Int Var, b:Int Var)
	
	If col.Length = 6
		
		r = Int("$" + col[0..2])
		g = Int("$" + col[2..4])
		b = Int("$" + col[4..6])
		
	End If
	
End Function

Rem
	bbdoc: Return a colour value in hex.
	returns: A hexidecimal colour value.
End Rem
Function dui_ColourToHex:String(colour:Int[])
	
	Return Hex(colour[0])[6..8] + Hex(colour[1])[6..8] + Hex(colour[2])[6..8]
	
End Function

Rem
	bbdoc: Set the current drawing color using hex.
	returns: Nothing.
End Rem
Function dui_SetHexColour(col:String)

	Local r:Int, g:Int, b:Int
	dui_HexColour(col, r, g, b)
	
	SetColor(r, g, b)
	
End Function

Rem
	bbdoc: Find the point of intersection of two lines.
	returns: True if the lines intersect (@xi and @yi will be the point of intersection), or False if they do not intersect. 
End Rem
Function dui_LineIntersection:Int(xi:Float Var, yi:Float Var, x1:Float, y1:Float, x2:Float, y2:Float,  ..
									x3:Float, y3:Float, x4:Float, y4:Float)
	
	Local L1d:Float, L2d:Float
	Local L1x:Float, L1y:Float, L2x:Float, L2y:Float
	
	L1x = x2 - x1
	L1y = y2 - y1
	L2x = x4 - x3
	L2y = y4 - y3
	
	L1d = (y3 - y1 + (L2y / L2x) * (x1 - x3)) / (L1y - L2y * L1x / L2x)
	
	If L1d >= 0 And L1d <= 1		' If intersection lies on first line
		
		L2d = (x1 + L1x * L1d - x3) / L2x
		
		If L2d >= 0 And L2d <= 1	' If intersection also lies on second line
			xi = x1 + L1d * L1x
			yi = y1 + L1d * L1y
			
			Return True
		
		End If
		
	End If
	
	Return False
	
End Function

Rem
	bbdoc: Get an index for a string in a string array.
	returns: The index of the string if it was found, or -1 if it was not found in the array.
	about: This is not case sensitive.
End Rem
Function dui_SelectString:Int(array:String[], str:String)
	Local item:Int = -1
	
	str = str.ToLower()
	
	For Local count:Int = 0 To array.Length - 1
		
		If array[count].ToLower() = str Then item = count
		
	Next
	
	Return item
	
End Function
		

















