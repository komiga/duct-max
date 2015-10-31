
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

Rem
	bbdoc: String builder (useful for large string concatenations, where normal means are not efficient enough).
End Rem
Type dStringBuilder Extends TListEx
	
	Rem
		bbdoc: Create a string builder.
		returns: Itself.
	End Rem
	Method Create:dStringBuilder()
		Return Self
	End End Method
	
	Rem
		bbdoc: Add a string to the builder.
		returns: Nothing.
	End Rem
	Method Add(what:String)
		AddLast(what)
	End Method
	
	Rem
		bbdoc: Add a string to the builder multiple times.
		returns: Nothing.
	End Rem
	Method AddMultiple(what:String, times:Int)
		For Local i:Int = 0 Until times
			AddLast(what)
		Next
	End Method
	
	Rem
		bbdoc: Undo the last addition.
		returns: Nothing.
	End Rem
	Method Undo()
		RemoveLast()
	End Method
	
	Rem
		bbdoc: Build an array from the builder's strings.
		returns: A concatenation of all the builder's strings.
	End Rem
	Method BuildArray:String[]()
		Local strings:String[] = New String[m_count]
		Local i:Int
		For Local str:String = EachIn Self
			strings[i] = str
			i:+ 1
		Next
		Return strings
	End Method
	
	Rem
		bbdoc: Build a string from the builder's strings.
		returns: A concatenation of all the builder's strings.
	End Rem
	Method BuildString:String()
		Return "".Join(BuildArray())
	End Method
	
	Rem
		bbdoc: Get a clone of the string builder.
		returns: A copy of the string builder.
	End Rem
	Method Copy:dStringBuilder()
		Super.Copy()
		Return Self
	End Method
	
End Type

