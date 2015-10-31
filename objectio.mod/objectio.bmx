
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
bbdoc: Object writer/reader module
End Rem
Module duct.objectio

ModuleInfo "Version: 0.5"
ModuleInfo "Copyright: Coranna Howard <me@komiga.com>"
ModuleInfo "License: MIT"

ModuleInfo "History: Version 0.5"
ModuleInfo "History: Fixed documentation, license"
ModuleInfo "History: Renamed TPixmapIO to dPixmapIO"
ModuleInfo "History: Version 0.4"
ModuleInfo "History: General cleanup"
ModuleInfo "History: Version 0.3"
ModuleInfo "History: Cleanup"
ModuleInfo "History: Version 0.2"
ModuleInfo "History: Changed license headers"
ModuleInfo "History: Version 0.1"
ModuleInfo "History: Added TPixmapWriter and TImageWriter"
ModuleInfo "History: Initial release"

Import brl.stream
Import brl.pixmap

Rem
	bbdoc: duct pixmap reading/writing functions.
End Rem
Type dPixmapIO
	
	Rem
		bbdoc: Read a pixmap from a stream
		returns: The read pixmap.
		about: This does not check if the stream is Null.
	End Rem
	Function Read:TPixmap(stream:TStream)
		Const align:Int = 4
		Local width:Int, height:Int, format:Int, pitch:Int, capacity:Int
		Local pixmap:TPixmap = New TPixmap
		width = stream.ReadInt()
		height = stream.ReadInt()
		format = stream.ReadInt()
		
		pitch = width * BytesPerPixel[format]
		pitch = (pitch + (align - 1)) / align * align
		capacity = pitch * height
		
		pixmap.pixels = MemAlloc(capacity)
		pixmap.width = width
		pixmap.height = height
		pixmap.pitch = pitch
		pixmap.format = format
		pixmap.capacity = capacity
		
		For Local y:Int = 0 Until pixmap.height
			stream.ReadBytes(pixmap.PixelPtr(0, y), pixmap.width * BytesPerPixel[pixmap.format])
		Next
		Return pixmap
	End Function
	
	Rem
		bbdoc: Write a pixmap to a stream.
		returns: Nothing.
		about: This does not check if the stream is Null.
	End Rem
	Function Write(pixmap:TPixmap, stream:TStream)
		stream.WriteInt(pixmap.width)
		stream.WriteInt(pixmap.height)
		stream.WriteInt(pixmap.format)
		For Local y:Int = 0 Until pixmap.height
			stream.WriteBytes(pixmap.PixelPtr(0, y), pixmap.width * BytesPerPixel[pixmap.format])
		Next
	End Function
	
End Type

