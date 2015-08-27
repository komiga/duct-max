
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
	bbdoc: An exception for #ReadNString errors.
End Rem
Type dCStringReadException
	
	Method ToString:String()
		Return "Failed to read newline terminated string"
	End Method
	
End Type

Rem
	bbdoc: duct stream functions.
End Rem
Type dStreamIO

	Rem
		bbdoc: Read a null-terminated string from the given stream.
		returns: A string.
		about: This function may throw a dCStringReadException (search went past the max buffer), or it may throw a TStreamReadException (no more data to be read).
	End Rem
	Function ReadCString:String(stream:TStream, maxbuffer:Int = 256)
		Local str:String, buf:Byte[1024], p:Int, count:Int
		Local n:Byte
		Repeat
			n = stream.ReadByte() 'Read(VarPtr n, 1) <> 1 Exit
			' Reached the newline character?
			If n = 0 Then Exit
			' Beyond the search amount?
			If p > maxbuffer Then Throw New dCStringReadException
			If stream.Eof() = True Then Throw New TStreamReadException
			buf[p] = n; p:+ 1
			If p <> buf.Length Then Continue
			str:+ String.FromBytes(buf, p)
			p = 0
		Forever
		If p Then str:+ String.FromBytes(buf, p)
		Return str
	End Function

	Rem
		bbdoc: Write a null-terminated string to the given stream.
		returns: Nothing.
	End Rem
	Function WriteCString(stream:TStream, value:String)
		stream.WriteString(value + "~0")
	End Function

	Rem
		bbdoc: Read a length-preceded string from the given stream.
		returns: A string.
	End Rem
	Function ReadLString:String(stream:TStream)
		Return stream.ReadString(stream.ReadInt())
	End Function

	Rem
		bbdoc: Write a length-preceded string to the given stream.
		returns: Nothing.
	End Rem
	Function WriteLString(stream:TStream, value:String)
		stream.WriteInt(value.Length)
		stream.WriteString(value)
	End Function
	
End Type

