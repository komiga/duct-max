
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
bbdoc: duct abstract enumerator.
End Rem
Module duct.enumerator

ModuleInfo "Version: 0.1"
ModuleInfo "Copyright: Coranna Howard <me@komiga.com>"
ModuleInfo "License: MIT"

ModuleInfo "History: Version 0.1"
ModuleInfo "History: Initial release"

Import brl.blitz

Rem
	bbdoc: duct abstract object enumerator.
End Rem
Type dEnumerator Abstract
	
	Rem
		bbdoc: Check if the enumerator has another object.
		returns: True if there is another object, False if not.
	End Rem
	Method HasNext:Int() Abstract
	
	Rem
		bbdoc: Get the next object in the enumerator.
		returns: The next object.
	End Rem
	Method NextObject:Object() Abstract
	
End Type

Rem
	bbdoc: duct abstract integer enumerator.
End Rem
Type dIntEnumerator Abstract
	
	Rem
		bbdoc: Check if the enumerator has another integer.
		returns: True if there is another integer, False if not.
	End Rem
	Method HasNext:Int() Abstract
	
	Rem
		bbdoc: Get the next integer in the enumerator.
		returns: The next integer.
	End Rem
	Method NextInt:Int() Abstract
	
End Type

