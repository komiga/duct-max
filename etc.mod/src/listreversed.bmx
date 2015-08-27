
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

Rem
	bbdoc: Enumeration implementation for #TListReversed.
End Rem
Type TListReversedEnum Extends TListEnum
	
	Rem
		bbdoc: Check if the enumerator has another link.
		returns: True if there is another object to be inspected.
	End Rem
	Method HasNext:Int()
		Return _link._value <> _link
	End Method
	
	Rem
		bbdoc: Get the next object.
		returns: The next object.
	End Rem
	Method NextObject:Object()
		Local value:Object = _link._value
		Assert value <> _link
		_link = _link._pred
		Return value
	End Method
	
End Type

Rem
	bbdoc: Reversed list (for enumerating a list backwards).
	about: Understood to be Public Domain. Thanks to Merx and more specifically (for this bit) Brucey.<br>
	Reference: http://www.blitzbasic.com/Community/posts.php?topic=82916
End Rem
Type TListReversed Extends TList
	
	Field m_orighead:TLink
	
	Method Delete()
		_head = m_orighead
	End Method
	
	Rem
		bbdoc: Create a new reversed list.
		returns: Itself.
		about: NOTE: This creates a wrapper around the given list - it does <b>not</b> create a copy of it.
	End Rem
	Method Create:TListReversed(list:TList)
		m_orighead = _head
		_head = list._head._pred
		Return Self
	End Method
	
	Rem
		bbdoc: Object enumerator for the list
		returns: The object enumerator for the list.
	End Rem
	Method ObjectEnumerator:TListReversedEnum()
		Local enum:TListReversedEnum = New TListReversedEnum
		enum._link = _head
		Return enum
	End Method
	
End Type

