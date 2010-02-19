
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
	
	dapp.bmx (Contains: TDApp, )
	
End Rem

Rem
	bbdoc: The DApp type.
	about: Abstract base for wxMax-style Application framework.
End Rem
Type TDApp Abstract
	
	Method New()
	End Method
	
	Rem
		bbdoc: Create a new DApp.
		returns: The new DApp (itself).
	End Rem
	Method Create:TDApp()
		OnInit()
		Return Self
	End Method
	
	Rem
		bbdoc: This method is called when the DApp is initialized.
		returns: Nothing.
	End Rem
	Method OnInit() Abstract
	
	Rem
		bbdoc: This method is called when the DApp is shutdown.
		returns: Nothing.
	End Rem
	Method OnExit() Abstract
	
	Rem
		bbdoc: Run the DApp.
		returns: Nothing.
	End Rem
	Method Run() Abstract
	
End Type

