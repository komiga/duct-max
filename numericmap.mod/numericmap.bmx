
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

SuperStrict

Rem
bbdoc: duct numeric map (int-int key-value binary tree).
End Rem
Module duct.numericmap

ModuleInfo "Version: 0.2"
ModuleInfo "Copyright: Tim Howard"
ModuleInfo "License: MIT"

ModuleInfo "History: Version 0.2"
ModuleInfo "History: General cleanup"
ModuleInfo "History: Version 0.1"
ModuleInfo "History: Initial release"

Import brl.blitz
Import duct.enumerator

Import "numericmap.cpp"

Extern "c"
	Type dCNumericMap
	End Type
	Function bmx_numericmap_create:dCNumericMap()
	Function bmx_numericmap_delete(nmap:dCNumericMap)
	
	Function bmx_numericmap_clear(nmap:dCNumericMap)
	Function bmx_numericmap_size:Int(nmap:dCNumericMap)
	Function bmx_numericmap_isempty:Int(nmap:dCNumericMap)
	Function bmx_numericmap_contains:Int(nmap:dCNumericMap, key:Int)
	
	Function bmx_numericmap_remove(nmap:dCNumericMap, key:Int)
	Function bmx_numericmap_set(nmap:dCNumericMap, key:Int, value:Int)
	Function bmx_numericmap_get:Int(nmap:dCNumericMap, key:Int)
	
	Function bmx_numericmap_getlastvalue:Int(nmap:dCNumericMap)
	Function bmx_numericmap_getlastkey:Int(nmap:dCNumericMap)
	
	' Iterator
	Type dCNumericMapIter
	End Type
	Function bmx_numericmap_iter_first:dCNumericMapIter(nmap:dCNumericMap)
	Function bmx_numericmap_iter_next(iter:dCNumericMapIter)
	Function bmx_numericmap_iter_hasnext:Int(nmap:dCNumericMap, iter:dCNumericMapIter)
	Function bmx_numericmap_iter_getvalue:Int(iter:dCNumericMapIter)
	Function bmx_numericmap_iter_getkey:Int(iter:dCNumericMapIter)
	Function bmx_numericmap_iter_delete(iter:dCNumericMapIter)
	
	' Reverse iterator
	Type dCNumericMapReverseIter
	End Type
	Function bmx_numericmap_riter_first:dCNumericMapReverseIter(nmap:dCNumericMap)
	Function bmx_numericmap_riter_next(iter:dCNumericMapReverseIter)
	Function bmx_numericmap_riter_hasnext:Int(nmap:dCNumericMap, iter:dCNumericMapReverseIter)
	Function bmx_numericmap_riter_getvalue:Int(iter:dCNumericMapReverseIter)
	Function bmx_numericmap_riter_getkey:Int(iter:dCNumericMapReverseIter)
	Function bmx_numericmap_riter_delete(iter:dCNumericMapReverseIter)
End Extern

Rem
	bbdoc: duct integer-key, integer-value based binary tree.
End Rem
Type dNumericMap
	
	Field m_cmap:dCNumericMap
	
	Method New()
		m_cmap = bmx_numericmap_create()
	End Method
	
	Method Delete()
		If m_cmap
			bmx_numericmap_delete(m_cmap)
			m_cmap = Null
		End If
	End Method
	
	Rem
		bbdoc: Remove the given key from the map.
		returns: True if the value with the given key was removed, or False if it was not (key not found).
	End Rem
	Method Remove:Int(key:Int)
		If bmx_numericmap_contains(m_cmap, key) = True
			bmx_numericmap_remove(m_cmap, key)
			Return True
		End If
		Return False
	End Method
	
	Rem
		bbdoc: Insert an integer into the map.
		returns: Nothing.
	End Rem
	Method Insert(key:Int, value:Int)
		bmx_numericmap_set(m_cmap, key, value)
	End Method
	
	Rem
		bbdoc: Get a value for the given key.
		returns: An integer with the given key, or Null if there is no value with the key given.
	End Rem
	Method ForKey:Int(key:Int)
		If Contains(key)
			Return bmx_numericmap_get(m_cmap, key)
		End If
		Return 0
	End Method
	
	Rem
		bbdoc: Get the last value.
		returns: The last value, or Null if the map is empty.
	End Rem
	Method GetLastValue:Int()
		Return bmx_numericmap_getlastvalue(m_cmap)
	End Method
	
	Rem
		bbdoc: Get the last key.
		returns: The last key in the map.
		about: @success will be set to False if the map is empty, or to True if the map is not empty.
	End Rem
	Method GetLastKey:Int(success:Int Var)
		If Not IsEmpty()
			success = True
			Return bmx_numericmap_getlastkey(m_cmap)
		End If
		success = False
		Return 0
	End Method
	
	Rem
		bbdoc: Clear the map.
		returns: Nothing.
	End Rem
	Method Clear()
		bmx_numericmap_clear(m_cmap)
	End Method
	
	Rem
		bbdoc: Get the number of values in the map.
		returns: The number of values in the map.
	End Rem
	Method Count:Int()
		Return bmx_numericmap_size(m_cmap)
	End Method
	
	Rem
		bbdoc: Check if the map is empty.
		returns: True if the map is empty, or False if it is not.
	End Rem
	Method IsEmpty:Int()
		Return bmx_numericmap_isempty(m_cmap)
	End Method
	
	Rem
		bbdoc: Check if the map contains the given key.
		Returns: True if the given key is in the map, or False if it is not.
	End Rem
	Method Contains:Int(key:Int)
		Return bmx_numericmap_contains(m_cmap, key)
	End Method
	
	Rem
		bbdoc: Get a value enumerator for the map.
		returns: A value enumerator.
	End Rem
	Method ValueEnumerator:dNumericMapStandardEnum()
		Return New dNumericMapStandardEnum.Create(m_cmap)
	End Method
	
	Rem
		bbdoc: Get a reverse enumerator for the map.
		returns: A reverse enumerator.
	End Rem
	Method ReverseEnumerator:dNumericMapReverseEnum()
		Return New dNumericMapReverseEnum.Create(m_cmap)
	End Method
	
End Type

Rem
	bbdoc: #dNumericMap standard enumerator.
End Rem
Type dNumericMapStandardEnum Extends dIntEnumerator
	
	Field m_cmap:dCNumericMap, m_iter:dCNumericMapIter
	
	Method Delete()
		Free()
	End Method
	
	Method Free()
		If m_iter
			bmx_numericmap_iter_delete(m_iter)
			m_iter = Null
		End If
	End Method
	
	Rem
		bbdoc: Create a standard #dNumericMap enumerator.
		returns: Itself.
	End Rem
	Method Create:dNumericMapStandardEnum(cmap:dCNumericMap)
		m_cmap = cmap
		m_iter = bmx_numericmap_iter_first(m_cmap)
		Return Self
	End Method
	
	Rem
		bbdoc: Check if the enumerator has another number.
		returns: Nothing.
	End Rem
	Method HasNext:Int()
		Local has:Int = bmx_numericmap_iter_hasnext(m_cmap, m_iter)
		If has Then Free()
		Return has
	End Method
	
	Rem
		bbdoc: Get the next integer value.
		returns: The next integer.
	End Rem
	Method NextInt:Int()
		Local value:Int = bmx_numericmap_iter_getvalue(m_iter)
		bmx_numericmap_iter_next(m_iter)
		Return value
	End Method
	
	Rem
		bbdoc: Get the next key.
		returns: The next key.
	End Rem
	Method NextKey:Int()
		Local value:Int = bmx_numericmap_iter_getkey(m_iter)
		bmx_numericmap_iter_next(m_iter)
		Return value
	End Method
	
End Type

Rem
	bbdoc: #dNumericMap reverse enumerator.
End Rem
Type dNumericMapReverseEnum Extends dIntEnumerator
	
	Field m_cmap:dCNumericMap, m_iter:dCNumericMapReverseIter
	
	Method Delete()
		Free()
	End Method
	
	Method Free()
		If m_iter
			bmx_numericmap_riter_delete(m_iter)
			m_iter = Null
		End If
	End Method
	
	Rem
		bbdoc: Create a reversed #dNumericMap enumerator.
		returns: Itself.
	End Rem
	Method Create:dNumericMapReverseEnum(cmap:dCNumericMap)
		m_cmap = cmap
		m_iter = bmx_numericmap_riter_first(m_cmap)
		Return Self
	End Method
	
	Rem
		bbdoc: Check if the enumerator has another number.
		returns: Nothing.
	End Rem
	Method HasNext:Int()
		Local has:Int = bmx_numericmap_riter_hasnext(m_cmap, m_iter)
		If has Then Free()
		Return has
	End Method
	
	Rem
		bbdoc: Get the next integer value.
		returns: The next integer.
	End Rem
	Method NextInt:Int()
		Local value:Int = bmx_numericmap_riter_getvalue(m_iter)
		bmx_numericmap_riter_next(m_iter)
		Return value
	End Method
	
	Rem
		bbdoc: Get the next key.
		returns: The next key.
	End Rem
	Method NextKey:Int()
		Local value:Int = bmx_numericmap_riter_getkey(m_iter)
		bmx_numericmap_riter_next(m_iter)
		Return value
	End Method
	
End Type

