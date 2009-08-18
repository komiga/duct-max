
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
End Rem

SuperStrict

Rem
bbdoc: IntMap (binary tree).
End Rem
Module duct.intmap

ModuleInfo "Version: 0.1"
ModuleInfo "Copyright: Tim Howard"
ModuleInfo "License: MIT"

ModuleInfo "History: Version 0.1"
ModuleInfo "History: Initial release"

' Used modules
Import brl.blitz

Import "intmap.cpp"

Extern
	Function bmx_intmap_create:Byte Ptr()
	Function bmx_intmap_delete(imap:Byte Ptr)
	
	Function bmx_intmap_clear(imap:Byte Ptr)
	Function bmx_intmap_size:Int(imap:Byte Ptr)
	Function bmx_intmap_contains:Int(imap:Byte Ptr, key:Int)
	
	Function bmx_intmap_remove:Object(imap:Byte Ptr, key:Int)
	Function bmx_intmap_set(imap:Byte Ptr, key:Int, obj:Object)
	Function bmx_intmap_get:Object(imap:Byte Ptr, key:Int)
	
	Function bmx_intmap_iter_first:Byte Ptr(imap:Byte Ptr)
	Function bmx_intmap_iter_next:Byte Ptr(iter:Byte Ptr)
	Function bmx_intmap_iter_hasnext:Int(imap:Byte Ptr, iter:Byte Ptr)
	Function bmx_intmap_iter_getobject:Object(iter:Byte Ptr)
	Function bmx_intmap_iter_delete(iter:Byte Ptr)
End Extern

Rem
	bbdoc: Integer-key based binary tree.
End Rem
Type TIntMap
	
	Field m_pointer:Byte Ptr
	
	Method New()
		m_pointer = bmx_intmap_create()
	End Method
	
	Method Delete()
		bmx_intmap_delete(m_pointer)
		m_pointer = Null
	End Method
	
	Rem
		bbdoc: Remove the given key from the map.
		returns: Nothing.
	End Rem
	Method Remove(key:Int)
		If bmx_intmap_contains(m_pointer, key) = True
			bmx_intmap_remove(m_pointer, key)
		End If
	End Method
	
	Rem
		bbdoc: Insert an object into the map.
		returns: Nothing.
	End Rem
	Method Insert(key:Int, obj:Object)
		Assert obj, "(duct.intmap.TIntMap) Cannot set key (" + String(key) + ") to Null!"
		If obj <> Null
			bmx_intmap_set(m_pointer, key, obj)
		End If
	End Method
	
	Rem
		bbdoc: Get an object for the given key.
		returns: An object with the given key, or Null if there is no object with the key given.
	End Rem
	Method ForKey:Object(key:Int)
		If Contains(key) = True
			Return bmx_intmap_get(m_pointer, key)
		End If
	End Method
	
	Rem
		bbdoc: Clear the map.
		returns: Nothing.
	End Rem
	Method Clear()
		bmx_intmap_clear(m_pointer)
	End Method
	
	Rem
		bbdoc: Get the number of objects in the map.
		returns: Nothing.
	End Rem
	Method Count:Int()
		Return bmx_intmap_size(m_pointer)
	End Method
	
	Rem
		bbdoc: Returns whether or not the map contains the given key.
	End Rem
	Method Contains:Int(key:Int)
		Return bmx_intmap_contains(m_pointer, key)
	End Method
	
	Method ObjectEnumerator:TIntMapEnumerator()
		Local enum:TIntMapEnumerator
		enum = New TIntMapEnumerator.Create(m_pointer)
		Return enum
	End Method
	
End Type

Rem
	bbdoc: #TIntMap enumerator (enabled EachIn support).
End Rem
Type TIntMapEnumerator
	  
	Field m_intmap:Byte Ptr, m_iter:Byte Ptr
	
	'Method Delete()
	'	bmx_intmap_iter_delete(m_iter)
	'End Method
	
	Method Create:TIntMapEnumerator(intmap:Byte Ptr)
		m_intmap = intmap
		m_iter = bmx_intmap_iter_first(m_intmap)
		Return Self
	End Method
	
	Method HasNext:Int()
		Local has:Int = bmx_intmap_iter_hasnext(m_intmap, m_iter)
		If has = False
			bmx_intmap_iter_delete(m_iter)
		End If
		Return has
	End Method
	
	Method NextObject:Object()
		Local value:Object
		value = bmx_intmap_iter_getobject(m_iter)
		m_iter = bmx_intmap_iter_next(m_iter)
		Return value
	End Method
	
End Type

































