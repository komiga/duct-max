
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
	
	graphical.bmx (Contains:  TPixmapIO, TImageIO)
	
End Rem

Rem
	bbdoc: The pixmap reader/writer type.
End Rem
Type TPixmapIO
	
	Rem
		bbdoc: Read a pixmap from a stream
		returns: The read pixmap.
		about: This does not check if the stream is Null.
	End Rem
	Function Read:TPixmap(stream:TStream)
		Const align:Int = 4
		Local pixmap:TPixmap, width:Int, height:Int, format:Int, pitch:Int, capacity:Int, y:Int
		
		pixmap:TPixmap = New TPixmap
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
		
		For y = 0 Until pixmap.height
			
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
		Local y:Int
		
		stream.WriteInt(pixmap.width)
		stream.WriteInt(pixmap.height)
		stream.WriteInt(pixmap.format)
		
		For y = 0 Until pixmap.height
			
			stream.WriteBytes(pixmap.PixelPtr(0, y), pixmap.width * BytesPerPixel[pixmap.format])
			
		Next
		
	End Function
	
End Type

Rem
	bbdoc: The image reader/writer type.
End Rem
Type TImageIO
	
	Rem
		bbdoc: Read an image from a stream.
		returns: The read image.
		about: This does not check if the stream is Null.
	End Rem
	Function Read:TImage(stream:TStream)
		Local image:TImage, count:Int, i:Int
		
		image = New TImage
		
		image.width = stream.ReadInt()
		image.height = stream.ReadInt()
		image.flags = stream.ReadInt()
		
		image.mask_r = stream.ReadInt()
		image.mask_g = stream.ReadInt()
		image.mask_b = stream.ReadInt()
		
		image.handle_x = stream.ReadFloat()
		image.handle_y = stream.ReadFloat()
		
		count = stream.ReadInt()
		
		image.pixmaps = New TPixmap[count]
		For i = 0 Until count
			
			image.pixmaps[i] = TPixmapIO.Read(stream)
			
		Next
		
		image.frames = New TImageFrame[count]
		image.seqs = New Int[count]
		
		Return image
		
	End Function
	
	Rem
		bbdoc: Write an image to a stream.
		returns: Nothing.
		about: This does not check if the stream is Null.
	End Rem
	Function Write(image:TImage, stream:TStream)
		Local pixmap:TPixmap
		
		stream.WriteInt(image.width)
		stream.WriteInt(image.height)
		stream.WriteInt(image.flags)
		
		stream.WriteInt(image.mask_r)
		stream.WriteInt(image.mask_g)
		stream.WriteInt(image.mask_b)
		
		stream.WriteFloat(image.handle_x)
		stream.WriteFloat(image.handle_y)
		
		stream.WriteInt(image.pixmaps.length)
		
		For pixmap = EachIn image.pixmaps
			
			TPixmapIO.Write(pixmap, stream)
			
		Next
		
	End Function
	
End Type
































