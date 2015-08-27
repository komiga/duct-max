
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

SuperStrict

Rem
bbdoc: duct integer map (binary tree).
End Rem
Module duct.intmap

ModuleInfo "Version: 0.6"
ModuleInfo "Copyright: plash <plash@komiga.com>"
ModuleInfo "License: MIT"

ModuleInfo "History: Version 0.6"
ModuleInfo "History: Prevent enumerator pre-deallocation in HasNext"
ModuleInfo "History: Version 0.5"
ModuleInfo "History: dIntMap now safely removes null entries when a Null object is inserted"
ModuleInfo "History: Added documentation to dIntMapStandardEnum and dIntMapReverseEnum"
ModuleInfo "History: Added CurrentObject, CurrentKey and GrabNext to dIntMapStandardEnum and dIntMapReverseEnum"
ModuleInfo "History: Version 0.4"
ModuleInfo "History: Added Null return in dIntMap.ForKey for non-Null gets (insignificant)"
ModuleInfo "History: Changed enumerator types to use duct.enumerator"
ModuleInfo "History: Corrected C++ code (added some consts, removed the success parameter from bmx_intmap_getlastkey)"
ModuleInfo "History: Added IsEmpty to dIntMap"
ModuleInfo "History: Added GetLastObject and GetLastKey to dIntMap"
ModuleInfo "History: Added reversed enumeration"
ModuleInfo "History: Corrected assert message in dIntMap.Insert"
ModuleInfo "History: dIntMap.Remove now returns True or False for success/failure"
ModuleInfo "History: Corrected extern function signature for bmx_intmap_remove (it doesn't return anything)"
ModuleInfo "History: Version 0.3"
ModuleInfo "History: Fixed documentation, license, examples"
ModuleInfo "History: Renamed TIntMapEnumerator to dIntMapEnumerator"
ModuleInfo "History: Renamed TIntMap to dIntMap"
ModuleInfo "History: Version 0.2"
ModuleInfo "History: General cleanup"
ModuleInfo "History: Version 0.1"
ModuleInfo "History: Initial release"

Import brl.blitz
Import duct.enumerator

Import "intmap.cpp"

Extern "c"
	Type dCIntMap
	End Type
	Function bmx_intmap_create:dCIntMap()
	Function bmx_intmap_delete(imap:dCIntMap)
	
	Function bmx_intmap_clear(imap:dCIntMap)
	Function bmx_intmap_size:Int(imap:dCIntMap)
	Function bmx_intmap_isempty:Int(imap:dCIntMap)
	Function bmx_intmap_contains:Int(imap:dCIntMap, key:Int)
	
	Function bmx_intmap_remove(imap:dCIntMap, key:Int)
	Function bmx_intmap_set(imap:dCIntMap, key:Int, obj:Object)
	Function bmx_intmap_get:Object(imap:dCIntMap, key:Int)
	
	Function bmx_intmap_getlastobj:Object(imap:dCIntMap)
	Function bmx_intmap_getlastkey:Int(imap:dCIntMap)
	
	' Iterator
	Type dCIntMapIter
	End Type
	Function bmx_intmap_iter_first:dCIntMapIter(imap:dCIntMap)
	Function bmx_intmap_iter_next(iter:dCIntMapIter)
	Function bmx_intmap_iter_hasnext:Int(imap:dCIntMap, iter:dCIntMapIter)
	Function bmx_intmap_iter_getobject:Object(iter:dCIntMapIter)
	Function bmx_intmap_iter_getkey:Int(iter:dCIntMapIter)
	Function bmx_intmap_iter_delete(iter:dCIntMapIter)
	
	' Reverse iterator
	Type dCIntMapReverseIter
	End Type
	Function bmx_intmap_riter_first:dCIntMapReverseIter(imap:dCIntMap)
	Function bmx_intmap_riter_next(iter:dCIntMapReverseIter)
	Function bmx_intmap_riter_hasnext:Int(imap:dCIntMap, iter:dCIntMapReverseIter)
	Function bmx_intmap_riter_getobject:Object(iter:dCIntMapReverseIter)
	Function bmx_intmap_riter_getkey:Int(iter:dCIntMapReverseIter)
	Function bmx_intmap_riter_delete(iter:dCIntMapReverseIter)
End Extern

Rem
	bbdoc: duct integer-key based binary tree.
End Rem
Type dIntMap
	
	Field m_cmap:dCIntMap
	
	Method New()
		m_cmap = bmx_intmap_create()
	End Method
	
	Method Delete()
		If m_cmap
			bmx_intmap_delete(m_cmap)
			m_cmap = Null
		End If
	End Method
	
	Rem
		bbdoc: Remove the given key from the map.
		returns: True if the object with the given key was removed, or False if it was not (key not found).
	End Rem
	Method Remove:Int(key:Int)
		If bmx_intmap_contains(m_cmap, key) = True
			bmx_intmap_remove(m_cmap, key)
			Return True
		End If
		Return False
	End Method
	
	Rem
		bbdoc: Insert an object into the map.
		returns: Nothing.
	End Rem
	Method Insert(key:Int, obj:Object)
		'Assert obj, "(dIntMap.Insert) Cannot set key (" + String(key) + ") to Null!"
		bmx_intmap_set(m_cmap, key, obj)
	End Method
	
	Rem
		bbdoc: Get an object for the given key.
		returns: An object with the given key, or Null if there is no object with the key given.
	End Rem
	Method ForKey:Object(key:Int)
		If Contains(key) = True
			Return bmx_intmap_get(m_cmap, key)
		End If
		Return Null
	End Method
	
	Rem
		bbdoc: Get the last object.
		returns: The last object, or Null if the map is empty.
	End Rem
	Method GetLastObject:Object()
		Return bmx_intmap_getlastobj(m_cmap)
	End Method
	
	Rem
		bbdoc: Get the last key.
		returns: The last key in the map.
		about: @success will be set to False if the map is empty.
	End Rem
	Method GetLastKey:Int(success:Int Var)
		If Not IsEmpty()
			success = True
			Return bmx_intmap_getlastkey(m_cmap)
		End If
		success = False
		Return 0
	End Method
	
	Rem
		bbdoc: Clear the map.
		returns: Nothing.
	End Rem
	Method Clear()
		bmx_intmap_clear(m_cmap)
	End Method
	
	Rem
		bbdoc: Get the number of objects in the map.
		returns: The number of objects in the map.
	End Rem
	Method Count:Int()
		Return bmx_intmap_size(m_cmap)
	End Method
	
	Rem
		bbdoc: Check if the map is empty.
		returns: True if the map is empty, or False if it is not.
	End Rem
	Method IsEmpty:Int()
		Return bmx_intmap_isempty(m_cmap)
	End Method
	
	Rem
		bbdoc: Check if the map contains the given key.
		Returns: True if the given key is in the map, or False if it is not.
	End Rem
	Method Contains:Int(key:Int)
		Return bmx_intmap_contains(m_cmap, key)
	End Method
	
	Rem
		bbdoc: Get an object enumerator for the map.
		returns: An object enumerator.
	End Rem
	Method ObjectEnumerator:dIntMapStandardEnum()
		Return New dIntMapStandardEnum.Create(m_cmap)
	End Method
	
	Rem
		bbdoc: Get a reverse object enumerator for the map.
		returns: A reverse object enumerator.
	End Rem
	Method ReverseEnumerator:dIntMapReverseEnum()
		Return New dIntMapReverseEnum.Create(m_cmap)
	End Method
	
End Type

Rem
	bbdoc: #dIntMap standard enumerator.
End Rem
Type dIntMapStandardEnum Extends dEnumerator
	  
	Field m_cmap:dCIntMap, m_iter:dCIntMapIter
	
	Method Delete()
		Free()
	End Method
	
	Method Free()
		If m_iter
			bmx_intmap_iter_delete(m_iter)
			m_iter = Null
		End If
	End Method
	
	Method Create:dIntMapStandardEnum(cmap:dCIntMap)
		m_cmap = cmap
		m_iter = bmx_intmap_iter_first(m_cmap)
		Return Self
	End Method
	
	Rem
		bbdoc: Get the next-pair state.
		returns: True if the enumerator has another pair, or False if it does not.
	End Rem
	Method HasNext:Int()
		Local has:Int = bmx_intmap_iter_hasnext(m_cmap, m_iter)
		' Don't free the iterator, HasNext might be called again by user
		'If Not has
		'	Free()
		'End If
		Return has
	End Method
	
	Rem
		bbdoc: Get the current object and grab the next pair.
		returns: The current object.
	End Rem
	Method NextObject:Object()
		Local value:Object = bmx_intmap_iter_getobject(m_iter)
		bmx_intmap_iter_next(m_iter)
		Return value
	End Method
	
	Rem
		bbdoc: Get the current key and grab the next pair.
		returns: The current key.
	End Rem
	Method NextKey:Int()
		Local value:Int = bmx_intmap_iter_getkey(m_iter)
		bmx_intmap_iter_next(m_iter)
		Return value
	End Method
	
	Rem
		bbdoc: Get the current object without grabbing the next pair.
		returns: The current object.
	End Rem
	Method CurrentObject:Object()
		Local value:Object = bmx_intmap_iter_getobject(m_iter)
		Return value
	End Method
	
	Rem
		bbdoc: Get the current key without grabbing the next pair.
		returns: The current key.
	End Rem
	Method CurrentKey:Int()
		Local value:Int = bmx_intmap_iter_getkey(m_iter)
		Return value
	End Method
	
	Rem
		bbdoc: Go to the next pair in the iterator.
		returns: Nothing.
		about: Only do this if you know there is another pair to grab (#HasNext).
	End Rem
	Method GrabNext()
		bmx_intmap_iter_next(m_iter)
	End Method
	
End Type

Rem
	bbdoc: #dIntMap reverse enumerator.
End Rem
Type dIntMapReverseEnum Extends dEnumerator
	
	Field m_cmap:dCIntMap, m_iter:dCIntMapReverseIter
	
	Method Delete()
		Free()
	End Method
	
	Method Free()
		If m_iter
			bmx_intmap_riter_delete(m_iter)
			m_iter = Null
		End If
	End Method
	
	Method Create:dIntMapReverseEnum(cmap:dCIntMap)
		m_cmap = cmap
		m_iter = bmx_intmap_riter_first(m_cmap)
		Return Self
	End Method
	
	Rem
		bbdoc: Get the next-pair state.
		returns: True if the enumerator has another pair, or False if it does not.
	End Rem
	Method HasNext:Int()
		Local has:Int = bmx_intmap_riter_hasnext(m_cmap, m_iter)
		' Don't free the iterator, HasNext might be called again by user
		'If Not has
		'	Free()
		'End If
		Return has
	End Method
	
	Rem
		bbdoc: Get the current object and grab the next pair.
		returns: The current object.
	End Rem
	Method NextObject:Object()
		Local value:Object = bmx_intmap_riter_getobject(m_iter)
		bmx_intmap_riter_next(m_iter)
		Return value
	End Method
	
	Rem
		bbdoc: Get the current key and grab the next pair.
		returns: The current key.
	End Rem
	Method NextKey:Int()
		Local value:Int = bmx_intmap_riter_getkey(m_iter)
		bmx_intmap_riter_next(m_iter)
		Return value
	End Method
	
	Rem
		bbdoc: Get the current object without grabbing the next pair.
		returns: The current object.
	End Rem
	Method CurrentObject:Object()
		Local value:Object = bmx_intmap_riter_getobject(m_iter)
		Return value
	End Method
	
	Rem
		bbdoc: Get the current key without grabbing the next pair.
		returns: The current key.
	End Rem
	Method CurrentKey:Int()
		Local value:Int = bmx_intmap_riter_getkey(m_iter)
		Return value
	End Method
	
	Rem
		bbdoc: Go to the next pair in the iterator.
		returns: Nothing.
		about: Only do this if you know there is another pair to grab (#HasNext).
	End Rem
	Method GrabNext()
		bmx_intmap_riter_next(m_iter)
	End Method
	
End Type

