
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
bbdoc: Max2D TImage writer/reader module.
End Rem
Module duct.imageio

ModuleInfo "Version: 0.4"
ModuleInfo "Copyright: plash <plash@komiga.com>"
ModuleInfo "License: MIT"

ModuleInfo "History: Version 0.4"
ModuleInfo "History: Changed some documentation"
ModuleInfo "History: Version 0.3"
ModuleInfo "History: Fixed documentation, license"
ModuleInfo "History: Renamed TImageIO to dImageIO"
ModuleInfo "History: Updated for API change"
ModuleInfo "History: Version 0.2"
ModuleInfo "History: General cleanup"
ModuleInfo "History: Version 0.1"
ModuleInfo "History: Initial release"

Import brl.stream
Import brl.max2d

Import duct.objectio

Rem
	bbdoc: duct Max2D TImage reader/writer.
End Rem
Type dImageIO
	
	Rem
		bbdoc: Read an image from the given stream.
		returns: An image.
		about: NOTE: This does not check if the stream is Null.
	End Rem
	Function Read:TImage(stream:TStream)
		Local image:TImage = New TImage
		image.width = stream.ReadInt()
		image.height = stream.ReadInt()
		image.flags = stream.ReadInt()
		
		image.mask_r = stream.ReadInt()
		image.mask_g = stream.ReadInt()
		image.mask_b = stream.ReadInt()
		
		image.handle_x = stream.ReadFloat()
		image.handle_y = stream.ReadFloat()
		
		Local count:Int = stream.ReadInt()
		image.pixmaps = New TPixmap[count]
		For Local i:Int = 0 Until count
			image.pixmaps[i] = dPixmapIO.Read(stream)
		Next
		image.frames = New TImageFrame[count]
		image.seqs = New Int[count]
		Return image
	End Function
	
	Rem
		bbdoc: Write the given image to the given stream.
		returns: Nothing.
		about: NOTE: This does not check if the stream is Null.
	End Rem
	Function Write(image:TImage, stream:TStream)
		stream.WriteInt(image.width)
		stream.WriteInt(image.height)
		stream.WriteInt(image.flags)
		
		stream.WriteInt(image.mask_r)
		stream.WriteInt(image.mask_g)
		stream.WriteInt(image.mask_b)
		
		stream.WriteFloat(image.handle_x)
		stream.WriteFloat(image.handle_y)
		
		stream.WriteInt(image.pixmaps.length)
		For Local pixmap:TPixmap = EachIn image.pixmaps
			dPixmapIO.Write(pixmap, stream)
		Next
	End Function
	
End Type

