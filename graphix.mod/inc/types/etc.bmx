
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
	
	etc.bmx (Contains: TDColor, )
	
End Rem

Rem
	bbdoc: The DColor type.
	about: This type stores a color (specifically built for DEntity).
End Rem
Type TDColor
	
	Field m_red:Int, m_green:Int, m_blue:Int
	
		Rem
			bbdoc: Create a new DColor.
			returns: The new DColor (itself).
		End Rem
		Method Create:TDColor(r:Int, g:Int, b:Int)
			
			Set(r, g, b)
			
			Return Self
			
		End Method
		
		Rem
			bbdoc: Set the color.
			returns: Nothing.
		End Rem
		Method Set(r:Int, g:Int, b:Int)
			
			m_red = r
			m_green = g
			m_blue = b
			
		End Method
		
		Rem
			bbdoc: Get the color.
			returns: Nothing (the variables are passed back through the parameters).
		End Rem
		Method Get(r:Int Var, g:Int Var, b:Int Var)
			
			r = m_red
			g = m_green
			b = m_blue
			
		End Method
		
End Type














































