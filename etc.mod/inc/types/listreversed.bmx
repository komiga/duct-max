
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
	
	listreversed.bmx (Contains: TListReversedEnum, TListReversed, )
	
End Rem

Type TListReversedEnum Extends TListEnum
	
	Method HasNext:Int()
		Return _link._value <> _link
	End Method
	
	Method NextObject:Object()
		Local value:Object = _link._value
		
		Assert value <> _link
		_link = _link._pred
		Return value
	End Method
	
End Type

Rem
	bbdoc: The ListReversed type.
	about: Reversed list (can be used to enumerate a list backwards).<br />
	Understood to be Public Domain, thanks to Merx and more specifically (for this bit) Brucey.<br />
	Thread: http://www.blitzbasic.com/Community/posts.php?topic=82916
End Rem
Type TListReversed Extends TList
	
	Field m_orighead:TLink
	
	Method Delete()
		_head = m_orighead
	End Method
	
	Rem
		bbdoc: Create a new ListReversed..
		returns: The new ListReversed (itself).
		about: NOTE: This creates a wrapper around the given list - it does <b>not</b> create a copy of it.
	End Rem
	Method Create:TListReversed(list:TList)
		m_orighead = _head
		_head = list._head._pred
		Return Self
	End Method
	
	Method ObjectEnumerator:TListEnum()
		Local enum:TListReversedEnum = New TListReversedEnum
		
		enum._link = _head
		Return enum
	End Method
	
End Type

