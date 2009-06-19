
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
	
	nstring.bmx (TNStringReadException, ReadNString(), WriteNString(), ReadLString(), WriteLString(), )
	
End Rem

Rem
	bbdoc: The TNStringReadException type.
End Rem
Type TNStringReadException
	
	Method ToString:String()
		
		Return "Failed to read the newline terminated string"
		
	End Method
	
End Type

Rem
	bbdoc: Read newline-terminated String from a Stream.
	returns: A string.
	about: This function may throw a TNStringReadException (search went past the max buffer), or it may throw a TStreamReadException (no more data to be read).
End Rem
Function ReadNString:String(stream:TStream, maxbuffer:Int = 256)
	
  Local str:String, Buf:Byte[1024], p:Int, count:Int
	
	Repeat
	  Local n:Byte
	  
		n = stream.ReadByte() 'Read(VarPtr n, 1) <> 1 Exit
		
		'Reached the newline character?
		If n = 10 Then Exit
		
		'Beyond the search amount?
		If p > maxbuffer Then Throw New TNStringReadException
		If stream.Eof() = True Then Throw New TStreamReadException
		
		Buf[p] = n; p:+1
		
		If p <> Buf.Length Then Continue
		str:+String.FromBytes(Buf, p)
		
		p = 0
		
	Forever
	
	If p Then str:+String.FromBytes(Buf, p)
	
   Return str
   
End Function

Rem
	bbdoc: Write newline-terminated String to a Stream.
	returns: Nothing.
End Rem
Function WriteNString(stream:TStream, value:String)
	
	stream.WriteString(value + "~n")
	
End Function

Rem
	bbdoc: Read a length-defined String from a Stream.
	returns: A String read from the given Stream.
End Rem
Function ReadLString:String(stream:TStream)
	
	stream.ReadString(stream.ReadInt())
	
End Function

Rem
	bbdoc: Write a length-defined String to a Stream.
	returns: Nothing.
End Rem
Function WriteLString(stream:TStream, value:String)
	
	stream.WriteInt(value.Length)
	stream.WriteString(value)
	
End Function





















