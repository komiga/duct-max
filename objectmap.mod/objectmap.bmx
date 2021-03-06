
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
bbdoc: Objectmap module
End Rem
Module duct.objectmap

ModuleInfo "Version: 0.4"
ModuleInfo "Copyright: Coranna Howard <me@komiga.com>"
ModuleInfo "License: MIT"

ModuleInfo "History: Version 0.4"
ModuleInfo "History: General cleanup"
ModuleInfo "History: Renamed dObjectMap._ValueByKey to _ObjectWithKey"
ModuleInfo "History: Version 0.3"
ModuleInfo "History: Fixed documentation, license"
ModuleInfo "History: Renamed TObjectMap to dObjectMap"
ModuleInfo "History: Version 0.2"
ModuleInfo "History: General cleanup"
ModuleInfo "History: Version 0.1"
ModuleInfo "History: Fixed Type formatting"
ModuleInfo "History: Version 0.07"
ModuleInfo "History: Moved all code to main source"
ModuleInfo "History: General code cleanup"
ModuleInfo "History: Added ValueEnumerator and KeyEnumerator to TObjectMap"
ModuleInfo "History: Version 0.06"
ModuleInfo "History: Added TObjectMap Clear, Count and Remove methods, now holds and manages the number of values in the map"
ModuleInfo "History: Version 0.05"
ModuleInfo "History: Corrected usage of syntax (in Returns, Cases, News and Selects)"
ModuleInfo "History: Version 0.04"
ModuleInfo "History: Initial release"

Import brl.map

Rem
	bbdoc: duct generic object map.
	about: This type is intended to be used abstractly (extend it), but is still usable otherwise.
End Rem
Type dObjectMap
	
	Field m_count:Int
	Field m_map:TMap
	
	Method New()
		m_map = New TMap
	End Method
	
	Rem
		bbdoc: Insert an object into the map.
		returns: Nothing.
		about: NOTE: This method does not provide Null checking.
	End Rem
	Method _Insert(key:Object, value:Object)
		m_map.Insert(key, value)
		m_count:+ 1
	End Method
	
	Rem
		bbdoc: Remove the object with the given key.
		returns: True if the object-key pair was removed, or False if the given key was not found.
	End Rem
	Method _Remove:Int(key:Object)
		If m_map.Remove(key)
			m_count:- 1
			Return True
		End If
		Return False
	End Method
	
	Rem
		bbdoc: Get a value with the given key.
		returns: The object with the given key, or Null if the key was not found.
	End Rem
	Method _ObjectWithKey:Object(key:Object)
		If Not key
			Return Null
		Else
			Return m_map.ValueForKey(key)
		End If
	End Method
	
	Rem
		bbdoc: Check if a key is in the map.
		returns: True if the key is in the map, or False if it is not.
	End Rem
	Method _Contains:Int(key:Object)
		Return m_map.Contains(key)
	End Method
	
	Rem
		bbdoc: Clear the map.
		returns: Nothing.
		about: NOTE: Count is zeroed.
	End Rem
	Method Clear()
		m_map.Clear()
		m_count = 0
	End Method
	
	Rem
		bbdoc: Get the number of entries in the map.
		returns: The number of entries in the map.
	End Rem
	Method Count:Int()
		Return m_count
	End Method
	
	Rem
		bbdoc: Get the value enumerator for the map.
		returns: A value enumerator for the map.
	End Rem
	Method ValueEnumerator:TMapEnumerator()
		Return m_map.Values()
	End Method
	
	Rem
		bbdoc: Get the key enumerator for the map.
		returns: A key enumerator for the map.
	End Rem
	Method KeyEnumerator:TMapEnumerator()
		Return m_map.Keys()
	End Method
	
End Type

