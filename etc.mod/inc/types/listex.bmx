
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
	
	listex.bmx (Contains: TListEx, )
	
	TODO:
		
End Rem

Rem
	bbdoc: Extended list type (corrects horrible counting implementation in BRL.LinkedList).
End Rem
Type TListEx Extends TList
	
	Field m_count:Int
	
	Rem
		bbdoc: Create a new TListEx.
		returns: The new TListEx (itself).
		about: This method does nothing (you can simply call #{New TListEx}).
	End Rem
	Method Create:TListEx()
		Return Self
	End Method
	
	Rem
		bbdoc: Insert the given value after the given link.
		returns: The link that was added to the list.
	End Rem
	Method InsertAfterLink:TLink(value:Object, pred:TLink)
		Local link:TLink
		link = Super.InsertAfterLink(value, pred)
		If link <> Null
			m_count:+1
		End If
		Return link
	End Method
	
	Rem
		bbdoc: Insert the given value before the given link.
		returns: The link that was added to the list.
	End Rem
	Method InsertBeforeLink:TLink(value:Object, succ:TLink)
		Local link:TLink
		link = Super.InsertBeforeLink(value, succ)
		If link <> Null
			m_count:+1
		End If
		Return link
	End Method
	
	Rem
		bbdoc: Remove the given object from the list.
		returns: True if the object was removed, or False if it was not (either the given value is Null or it was not found in the list).
	End Rem
	Method Remove:Int(value:Object)
		Local removed:Int = Super.Remove(value) = True
		If removed = True
			m_count:-1
		End If
		Return removed
	End Method
	
	Rem
		bbdoc: Remove the first object from the list.
		returns: The object that was removed, or Null if the list is empty.
	End Rem
	Method RemoveFirst:Object()
		Local obj:Object = Super.RemoveFirst()
		If obj <> Null
			m_count:-1
		End If
		Return obj
	End Method
	
	Rem
		bbdoc: Remove the last object from the list.
		returns: The object that was removed, or Null if the list is empty.
	End Rem
	Method RemoveLast:Object()
		Local obj:Object = Super.RemoveLast()
		If obj <> Null
			m_count:-1
		End If
		Return obj
	End Method
	
	Rem
		bbdoc: Clear the list.
		returns: Nothing.
	End Rem
	Method Clear()
		Super.Clear()
		m_count = 0
	End Method
	
	Rem
		bbdoc: Get the number of items in the list.
		returns: The value count of the list.
	End Rem
	Method Count:Int()
		Return m_count
	End Method
	
	Rem
		bbdoc: Create a new list containing the values of the list in reverse-order.
		returns: The list containing the values in reversed order.
	End Rem
	Method Reversed:TListEx()
		Local list:TListEx = New TListEx
		Local link:TLink = _head._succ
		While link <> _head
			list.AddFirst(link._value)
			link = link._succ
		Wend
		list.m_count = m_count
		Return list
	End Method
	
	Rem
		bbdoc: Convert an array to a TListEx.
		returns: The new TListEx from the given array.
	End Rem
	Function FromArray:TListEx(arr:Object[])
		Local list:TListEx = New TListEx
		For Local index:Int = 0 To arr.Length - 1
			list.AddLast(arr[index])
		Next
		list.m_count = arr.Length
		Return list
	End Function
	
	Rem
		bbdoc: Get an exact copy of the list.
		returns: A copy of the list (does not replicate objects within).
	End Rem
	Method Copy:TListEx()
		Local list:TListEx = New TListEx
		Local link:TLink = _head._succ
		While link <> _head
			list.AddLast(link._value)
			link = link._succ
		Wend
		Return list
	End Method
	
End Type

