
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
' tmstimer.bmx (Contains: TMSTimer, )
' 
' 

Rem
	bbdoc: The millisecond-timer type.
End Rem
Type TMSTimer
	
	' Interal, holds the start value for the timer
	Field ms:Int
	
	' Indicates the timer needs to be reset
	Field needsreset:Int
	
	' In milliseconds, 1000ms = 1 second, 500ms = 0.5 seconds etc..
	Field length:Int
	
		Rem
			bbdoc: Create a millisecond timer.
			returns: The created timer (itself).
		End Rem
		Method Create:TMSTimer(_length:Int)
			
			Reset()
			
			length = _length
			
			Return Self
			
		End Method
		
		Rem
			bbdoc: Update the timer.
			returns: True if the timer ticked, or False if it did not.
			about: This will call Reset if the timer ticked.
		End Rem
		Method Update:Int()
			
			If MilliSecs() > GetMS()
				
				Reset()
				Return True
				
			Else
				
				Return False
				
			End If
			
		End Method
		
		Rem
			bbdoc: Reset the timer.
			returns: Nothing.
		End Rem
		Method Reset(_addms:Int = 0)
			
			SetMS(MilliSecs() + GetLength())
			If _addms <> 0 Then AddMS(_addms)
			
		End Method
		
		Rem
			bbdoc: Set the length of the timer.
			returns: Nothing.
		End Rem
		Method SetLength(_length:Int)
			
			length = _length
			
		End Method
		
		Rem
			bbdoc: Get the length of the timer.
			returns: The length of the timer.
		End Rem
		Method GetLength:Int()
			
			Return length
			
		End Method
		
		Rem
			bbdoc: Set the current point (milliseconds) of the timer.
			returns: Nothing.
		End Rem
		Method SetMS(_ms:Int)
			
			ms = _ms
			
		End Method
		
		Rem
			bbdoc: Add milliseconds to the counter.
			returns: Nothing.
		End Rem
		Method AddMS(_msadd:Int)
			
			ms:+_msadd
			
		End Method
		
		Rem
			bbdoc: Get the current point (milliseconds) of the timer.
			returns: The current point (milliseconds) of the timer.
		End Rem
		Method GetMS:Int()
			
			Return ms
			
		End Method
		
End Type





























