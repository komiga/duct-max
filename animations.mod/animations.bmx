
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

SuperStrict

Rem
bbdoc: 2D animations module
End Rem
Module duct.animations

ModuleInfo "Version: 0.21"
ModuleInfo "Credits: Indiepath for the initial single surface code"
ModuleInfo "Copyright: plash <plash@komiga.com>"
ModuleInfo "License: MIT"

ModuleInfo "History: Version 0.21"
ModuleInfo "History: Fixed documentation, license"
ModuleInfo "History: Renamed TAnimSequence to dAnimSequence"
ModuleInfo "History: General cleanup"
ModuleInfo "History: Merged includes"
ModuleInfo "History: Version 0.20"
ModuleInfo "History: Fixed changed dependency (imports duct.imageio)"
ModuleInfo "History: Version 0.19"
ModuleInfo "History: General code cleanup"
ModuleInfo "History: Version 0.18"
ModuleInfo "History: Updated to use objectio (image reading and writing) for serialization and deserialization"
ModuleInfo "History: Version 0.17"
ModuleInfo "History: Initial release"

Import brl.stream
Import brl.glmax2d
?Win32
	Import brl.d3d7max2d
?

Import brl.pngloader
Import brl.bmploader
Import brl.jpgloader

Import duct.imageio
Import duct.etc

Rem
	bbdoc: duct single-surface animation sequence.
	about: Credits to Indiepath for the initial single surface code.
End Rem
Type dAnimSequence
	
	Field m_image:TImage
	Field m_framewidth:Float, m_frameheight:Float
	
	Field m_currentframe:Int
	Field m_frames:Int, m_startframe:Int
	Field m_u0:Float[], m_v0:Float[]
	Field m_u1:Float[], m_v1:Float[]
	
	Rem
		bbdoc: Create a new sequence.
		returns: Itself.
		about: @startframe is zero based, whereas @frames is not.
	End Rem
	Method Create:dAnimSequence(image:Object, startframe:Int, frames:Int, framewidth:Float, frameheight:Float, image_flags:Int = -1)
		SetStartFrame(startframe)
		SetFrameCount(frames)
		SetFrameSize(framewidth, frameheight)
		SetImage(image, image_flags)
		Return Self
	End Method
	
'#region Field accessors
	
	Rem
		bbdoc: Set the image for the sequence.
		returns: True if the image was set, or False if it was not.
		about: NOTE: This will recalculate the frame coordinates.<br/>
		@url can be either a TPixmap or a TImage.
	End Rem
	Method SetImage:Int(url:Object, imageflags:Int = -1)
		Local tmpimage:TImage = TImage(url)
		If tmpimage = Null
			tmpimage = LoadImage(url, imageflags)
			If tmpimage = Null
				Return False
			End If
		End If
		m_image = tmpimage
		RecalculateFrames()
		Return True
	End Method
	
	Rem
		bbdoc: Set the size of each frame in the sequence.
		returns: Nothing.
	End Rem
	Method SetFrameSize(width:Float, height:Float)
		m_framewidth = width
		m_frameheight = height
	End Method
	
	Rem
		bbdoc: Set the number of frames in the sequence.
		returns: Nothing.
		about: @frames is not zero based; Note that when you set the frame count, the frame coords are reset (recalculation is needed).
	End Rem
	Method SetFrameCount(frames:Int)
		m_frames = frames
		m_u0 = New Float[m_frames]
		m_v0 = New Float[m_frames]
		m_u1 = New Float[m_frames]
		m_v1 = New Float[m_frames]
	End Method
	
	Rem
		bbdoc: Get the number of frames in the sequence.
		returns: The frame count for the sequence (not zero based).
	End Rem
	Method GetFrameCount:Int()
		Return m_frames
	End Method
	
	Rem
		bbdoc: Set the beginning frame on the image.
		returns: Nothing.
		about: @startframe is zero based.
	End Rem
	Method SetStartFrame(startframe:Int)
		m_startframe = startframe
	End Method
	
	Rem
		bbdoc: Get the beginning frame in the sequence.
		returns: The beginning frame in the sequence (zero based).
	End Rem
	Method GetStartFrame:Int()
		Return m_startframe
	End Method
	
'#end region (Field accessors)
	
	Rem
		bbdoc: Check if the image has a frame.
		returns: True if the given frame is in the sequence, or False if it is not.
		about: @frame is zero based.
	End Rem
	Method HasFrame:Int(frame:Int)
		If frame >= 0 And frame < m_frames
			Return True
		End If
		Return False
	End Method
	
	Rem
		bbdoc: Recalculate the frame coordinates.
		returns: Nothing.
	End Rem
	Method RecalculateFrames()
		Local tx:Float, ty:Float, x_cells:Int
		Local xdelta:Float = m_image.width / Pow2Size(m_image.width)
		Local ydelta:Float = m_image.height / Pow2Size(m_image.height)
		
		x_cells = m_image.width / m_framewidth
		For Local f:Int = m_startframe To m_frames - 1
			tx = (f Mod x_cells * m_framewidth) * xdelta
			ty = (f / x_cells * m_frameheight) * ydelta
			m_u0[f] = Float(tx) / Float(m_image.width)
			m_v0[f] = Float(ty) / Float(m_image.height)
			m_u1[f] = Float(tx + m_framewidth * xdelta) / Float(m_image.width)
			m_v1[f] = Float(ty + m_frameheight * ydelta) / Float(m_image.height)
		Next
		' Reset the current drawframe to the startframe
		m_currentframe = -1
		SetDrawFrame(m_startframe)
	End Method
	
	Rem
		bbdoc: Draw the current frame.
		returns: Nothing.
		about: You can use @width and @height to stretch or compact the frame (the default values of the parameters mean the full size of the frame).
	End Rem
	Method Draw(x:Float, y:Float, width:Float = 0.0, height:Float = 0.0)
		If width = 0.0 Then width = m_framewidth
		If height = 0.0 Then height = m_frameheight
		DrawImageRect(m_image, x, y, width, height, 0)
	End Method
	
	Rem
		bbdoc: Set the current drawing frame.
		returns: Nothing.
		about: @frame is zero based. @flipx and @flipy will flip the frame horizontally or vertically, respectively, if they are True.
	End Rem
	Method SetDrawFrame(frame:Int, flipx:Int = False, flipy:Int = False)
		Local iframe:TImageFrame, su0:Float, su1:Float, sv0:Float, sv1:Float
		
		If HasFrame(frame) = True And m_currentframe <> frame
			iframe = m_image.Frame(0)
			If flipx = False
				su0 = m_u0[frame]
				su1 = m_u1[frame]
			Else
				su0 = m_u1[frame]
				su1 = m_u0[frame]
			End If
			If flipy = False
				sv0 = m_v0[frame]
				sv1 = m_v1[frame]
			Else
				sv0 = m_v1[frame]
				sv1 = m_v0[frame]
			End If
			
			' Only bother checking if we are on Windows!
			?Win32
			Local dxframe:TD3D7ImageFrame = TD3D7ImageFrame(iframe)
			If dxframe <> Null
				dxframe.SetUV(su0, sv0, su1, sv1)
			Else
			?
				Local glframe:TGLImageFrame = TGLImageFrame(iframe)
				glframe.u0 = su0
				glframe.u1 = su1
				glframe.v0 = sv0
				glframe.v1 = sv1
			?win32
			End If
			?
			m_currentframe = frame
		End If
	End Method
	
	Rem
		bbdoc: Serialize the sequence into a stream.
		returns: Nothing.
		about: Pass @doimage as True if you wish to write the image as well.
	End Rem
	Method Serialize(stream:TStream, doimage:Int = False)
		stream.WriteFloat(m_framewidth)
		stream.WriteFloat(m_frameheight)
		stream.WriteInt(m_frames)
		stream.WriteInt(m_startframe)
		If doimage = True
			dImageIO.Write(m_image, stream)
		End If
	End Method
	
	Rem
		bbdoc: Deserialize the sequence from a stream.
		returns: The deserialized sequence (itself).
		about: Pass @doimage as True if you with to read the image as well.<br/>
		If it is not passed, the method will not seek the stream over that section if it was 
		written with #Serialize (you <b>must</b> use the same exact loading and saving flow).
	End Rem
	Method Deserialize:dAnimSequence(stream:TStream, doimage:Int = False)
		m_framewidth = stream.ReadFloat()
		m_frameheight = stream.ReadFloat()
		m_frames = stream.ReadInt()
		m_startframe = stream.ReadInt()
		If doimage = True
			SetImage(dImageIO.Read(stream))
		End If
		Return Self
	End Method
	
	Rem
		bbdoc: Load an sequence from the given stream.
		returns: The deserialized sequence.
		about: This will create a new sequence and deserialize it from the stream.
	End Rem
	Function Load:dAnimSequence(stream:TStream)
		Return New dAnimSequence.Deserialize(stream)
	End Function
	
End Type

