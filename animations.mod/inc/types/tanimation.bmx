
' Copyright (c) 2009 Tim Howard
' 
' Permission is hereby granted, free of charge, to any person obtaining a copy
' of this software and associated documentation files (the "Software"), to deal
' in the Software without restriction, including without limitation the rights
' to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
' copies of the Software, and to permit persons to whom the Software is
' furnished to do so, subject to the following conditions:
' 
' The above copyright notice and this permission notice shall be included in
' all copies or substantial portions of the Software.
' 
' THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
' IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
' FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
' AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
' LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
' OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
' THE SOFTWARE.
' 

' 
' tanimation.bmx (Contains: TAnimSequence, )
' 
' 

Rem
	bbdoc: The TAnimSequence Type.
	about: Credits to Indiepath for the basic single surface code.
End Rem
Type TAnimSequence
	
	Field Image:TImage
	Field width:Float
	Field Height:Float
	
	Field currentframe:Int
	Field Frames:Int, startframe:Int
	Field u0:Float[], v0:Float[]
	Field u1:Float[], v1:Float[]
		
		Rem
			bbdoc: Create a TAnimSequence.
			returns: The created TAnimSequence.
			about: @_startframe is zero based, whereas @_frames is not.
		End Rem
		Method Create:TAnimSequence(_image:Object, _startframe:Int, _frames:Int, _width:Float, _height:Float, imageflags:Int = -1)
			
			SetStartFrame(_startframe)
			SetFrameCount(_frames)
			
			SetFrameSize(_width, _height)
			
			SetImage(_image)
			
			Return Self
			
		End Method
		
		Rem
			bbdoc: Set the image for the animation.
			returns: True if the image was set, or False if it was not.
			about: NOTE: This will recalculate the frame coordinates.
		End Rem
		Method SetImage:Int(url:Object, imageflags:Int = -1)
			Local tmpimage:TImage = TImage(url)
			
			If tmpimage = Null
				
				tmpimage = LoadImage(url, imageflags)
				If tmpimage = Null Then Return False
				
			End If
			
			Image = tmpimage
			
			RecalculateFrames()
			
			Return True
			
		End Method
		
		Rem
			bbdoc: Check if the image has a frame.
			returns: True If the frame is in the animation or False if it is not.
			about: @_frame is zero based.
		End Rem
		Method HasFrame:Int(_frame:Int)
			
			If _frame >= 0 And _frame < Frames Then Return True
			
		   Return False
		   
		End Method
		
		Rem
			bbdoc: Set the size of each frame.
			returns: Nothing.
		End Rem
		Method SetFrameSize(_width:Float, _height:Float)
			
			width = _width
			height = _height
			
		End Method
		
		Rem
			bbdoc: Set the number of frames in the animation.
			returns: Nothing.
			about: @_frames is not zero based; note that when you set the framecount, the frame coords are reset (recalculation is needed).
		End Rem
		Method SetFrameCount(_frames:Int)
			
			Frames = _frames
			
			u0 = New Float[Frames]
			v0 = New Float[Frames]
			u1 = New Float[Frames]
			v1 = New Float[Frames]
			
		End Method
		
		Rem
			bbdoc: Get the number of frames in the animation.
			returns: The frame count for the animation (not zero based).
		End Rem
		Method GetFrameCount:Int()
			
			Return Frames
			
		End Method
		
		Rem
			bbdoc: Set the frame to begin at on the image.
			returns: Nothing.
			about: @_startframe is zero based.
		End Rem
		Method SetStartFrame(_startframe:Int)
			
			startframe = _startframe
			
		End Method
		
		Rem
			bbdoc: Get the start frame.
			returns: The beginning frame on the image (zero based).
		End Rem
		Method GetStartFrame:Int()
			
			Return startframe
			
		End Method
		
		Rem
			bbdoc: Recalculate the frame coordinates.
			returns: Nothing.
		End Rem
		Method RecalculateFrames()
		  Local tx:Float, ty:Float, x_cells:Int
		  Local xDelta:Float = Image.width / Pow2Size(Image.width)
		  Local yDelta:Float = Image.height / Pow2Size(Image.height)
		  
			x_cells = Image.width / width
			
			For Local f:Int = startframe To Frames - 1
				
				tx = (f Mod x_cells * width) * xdelta
				ty = (f / x_cells * height) * ydelta
				
				u0[f] = Float(tx) / Float(Image.width)
				v0[f] = Float(ty) / Float(Image.height)
				u1[f] = Float(tx + width * xdelta) / Float(Image.width)
				v1[f] = Float(ty + height * ydelta) / Float(Image.height)
				
			Next
			
			' Reset the current drawframe to the startframe
			currentframe = -1
			SetDrawFrame(startframe)
			
		End Method
		
		Rem
			bbdoc: Draw the current frame.
			returns: Nothing.
		End Rem
		Method Draw(X:Float, Y:Float, _width:Float = 0.0, _height:Float = 0.0)
			
			If _width = 0.0 Then _width = width
			If _height = 0.0 Then _height = Height
			
			DrawImageRect(Image, X, Y, _width, _height, 0)
			
		End Method
		
		Rem
			bbdoc: Set the frame to be drawn.
			returns: Nothing.
			about: @Frame is zero based.
		End Rem
		Method SetDrawFrame(Frame:Int, flipx:Int = False, flipy:Int = False)
		  Local iframe:TImageFrame, su0:Float, su1:Float, sv0:Float, sv1:Float
		  
			If HasFrame(Frame) And currentframe <> Frame
				
				iframe = Image.Frame(0)
				
				If flipx = False
					su0 = u0[Frame]
					su1 = u1[Frame]
				Else
					su0 = u1[Frame]
					su1 = u0[Frame]
				End If
				
				If flipy = False
					sv0 = v0[Frame]
					sv1 = v1[Frame]
				Else
					sv0 = v1[Frame]
					sv1 = v0[Frame]
				End If
				
				' Only bother checking if we are on Windows!
				?win32
				If TD3D7ImageFrame(iframe)
					
					TD3D7ImageFrame(iframe).SetUV(su0, sv0, su1, sv1)
					
				Else
				?
					Local GLFrame:TGLImageFrame = TGLImageFrame(iframe)
					
					GLFrame.u0 = su0
					GLFrame.u1 = su1
					GLFrame.v0 = sv0
					GLFrame.v1 = sv1
				
				?win32
				EndIf
				?
				
				currentframe = Frame
				
			End If
			
		End Method
		
		Rem
			bbdoc: Serialize the animation into a stream.
			returns: Nothing.
			about: Pass @doimage as True if you wish to write the image as well.
		End Rem
		Method Serialize(stream:TStream, doimage:Int = False)
			
			stream.WriteInt(width)
			stream.WriteInt(height)
			
			stream.WriteInt(GetFrameCount())
			stream.WriteInt(GetStartFrame())
			
			If doimage = True Then TImageIO.Write(Image, stream)
			
		End Method
		
		Rem
			bbdoc: Deserialize the animation from a stream.
			returns: Itself.
		End Rem
		Method DeSerialize:TAnimSequence(stream:TStream, doimage:Int = False)
			
			SetFrameSize(stream.ReadInt(), stream.ReadInt())
			
			SetFrameCount(stream.ReadInt())
			SetStartFrame(stream.ReadInt())
			
			If doimage = True
				
				SetImage(TImageIO.Read(stream))
				
			End If
			
			Return Self
			
		End Method
		
		Rem
			bbdoc: Load a new animation from a stream
			returns: The loaded animation
			about: This will create a new animation and deserialize it from the stream
		End Rem
		Function Load:TAnimSequence(stream:TStream)
			Local aseq:TAnimSequence
			
			aseq = New TAnimSequence.DeSerialize(stream)
			
			Return aseq
			
		End Function
		
End Type







































