
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
' tfpscounter.bmx (Contains: TFPSCounter, )
' 
' 

Rem
	bbdoc: The TFPSCounter type.
End Rem
Type TFPSCounter
	
	Global fps:Int, counter:Int, timer:TMSTimer = New TMSTimer.Create(1000)
		
		Rem
			bbdoc: Update the FPS counter.
			returns: Nothing.
			about: This should be called right after your Flip call.
		End Rem
		Function Update()
			
			counter:+1
			
			If timer.Update() = True
			
				fps = counter
				counter = 0
				
			End If
			
		End Function
		
		Rem
			bbdoc: Get the current FPS.
			returns: The current FPS (frames per-second).
		End Rem
		Function GetFPS:Int()
			
			Return fps
			
		End Function
		
End Type

































