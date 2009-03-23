
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

' 
' tobjectmap.bmx (Contains: TObjectMap, )
' 
'

Rem
	bbdoc: The TObjectMap type.
	about: Intended as an abstract type, but still usable otherwise.
End Rem
Type TObjectMap
	
	Field _count:Int
	Field _map:TMap
	
		Method New()
			
			_map = New TMap
			
		End Method
		
		Rem
		Method Create:TObjectMap()
			
			Return Self
			
		End Method
		End Rem
		
		Rem
			bbdoc: Insert an object into the map.
			returns: Nothing.
			about: This method does not provide Null checking.
		End Rem
		Method _Insert(key:Object, value:Object)
			
			_map.Insert(key, value)
			_count:+1
			
		End Method
		
		Rem
			bbdoc: Remove a key from the map.
			returns: True if the key was removed from the map, or False if it was not.
			about: Count is lowered by 1 if the key was removed.
		End Rem
		Method _Remove:Int(key:Object)
			
			If _map.Remove(key) = True
				
				_count:-1
				Return True
				
			End If
			
			Return False
			
		End Method
		
		Rem
			bbdoc: Get a value by it's key.
			returns: An object or Null (not found).
		End Rem
		Method _ValueByKey:Object(key:Object)
			
			Return _map.ValueForKey(key)
			
		End Method
		
		Rem
			bbdoc: Check if a key is in the map.
			returns: True if the key is in the map, or False if it is not.
		End Rem
		Method _Contains:Int(key:Object)
			
			Return _map.Contains(key)
			
		End Method
		
		Rem
			bbdoc: Clear the map.
			returns: Nothing.
			about: Count is zeroed.
		End Rem
		Method Clear()
			
			_map.Clear()
			_count = 0
			
		End Method
		
		Rem
			bbdoc: 
			returns: Nothing.
			about: 
		End Rem
		Method Count:Int()
			
			Return _count
			
		End Method
		
End Type

























