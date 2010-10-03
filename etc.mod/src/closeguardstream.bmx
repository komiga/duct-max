
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

Rem
	bbdoc: Close-guard stream wrapper.
	about: This type will wrap a stream in the same was as brl.stream's TStreamWrapper, but does @not close the stream when told to.
End Rem
Type dCloseGuardStreamWrapper Extends TStreamWrapper
	
	Rem
		bbdoc: Create a close-guard stream wrapper.
		returns: Itself.
	End Rem
	Method Create:dCloseGuardStreamWrapper(stream:TStream)
		SetStream(stream)
		Return Self
	End Method
	
'#region Field accessors
	
	Rem
		bbdoc: Set the wrapper's stream.
		returns: Nothing.
	End Rem
	Method SetStream(stream:TStream)
		_stream = stream
	End Method
	
	Rem
		bbdoc: Get the wrapper's stream.
		returns: The wrapper's stream.
	End Rem
	Method GetStream:TStream()
		Return _stream
	End Method
	
'#end region Field accessors
	
	Method Close()
		' neener neener
	End Method
	
End Type

