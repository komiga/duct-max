
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
	bbdoc: Simple millisecond timer.
End Rem
Type dMSTimer
	
	Field m_ms:Int, m_needsreset:Int
	Field m_length:Int
	
	Rem
		bbdoc: Create a millisecond timer.
		returns: Itself.
	End Rem
	Method Create:dMSTimer(length:Int)
		Reset()
		SetLength(length)
		Return Self
	End Method
	
	Rem
		bbdoc: Update the timer.
		returns: True if the timer ticked, or False if it did not.
		about: This will call #OnTick (which does nothing unless you override it) and #Reset if the timer ticked.
	End Rem
	Method Update:Int()
		If MilliSecs() > m_ms
			OnTick()
			Reset()
			Return True
		End If
		Return False
	End Method
	
	Rem
		bbdoc: Reset the timer.
		returns: Nothing.
		about: @addms will be added to the new point in time.
	End Rem
	Method Reset(msadd:Int = 0)
		m_ms = MilliSecs() + m_length
		m_ms:+ msadd
	End Method
	
	Rem
		bbdoc: Set the length of the timer.
		returns: Nothing.
	End Rem
	Method SetLength(length:Int)
		m_length = length
	End Method
	
	Rem
		bbdoc: Get the length of the timer.
		returns: The length of the timer.
	End Rem
	Method GetLength:Int()
		Return m_length
	End Method
	
	Rem
		bbdoc: Set the current time (milliseconds) of the timer.
		returns: Nothing.
	End Rem
	Method SetMS(ms:Int)
		m_ms = ms
	End Method
	
	Rem
		bbdoc: Add milliseconds to the counter.
		returns: Nothing.
	End Rem
	Method AddMS(msadd:Int)
		m_ms:+ msadd
	End Method
	
	Rem
		bbdoc: Get the current time (milliseconds) of the timer.
		returns: The current time (milliseconds) of the timer.
	End Rem
	Method GetMS:Int()
		Return m_ms
	End Method
	
	Rem
		bbdoc: Called when the timer ticks.
		returns: Nothing.
		about: This method does nothing unless you override it.
	End Rem
	Method OnTick()
	End Method
	
End Type

