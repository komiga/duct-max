
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
	
	entity.bmx (Contains: TDEntity, )
	
End Rem

Rem
	bbdoc: The DEntity type.
	about: 2D entity - in the future this may be very comparable to the 3D entity system found in Blitz3D/BMax3D (but still 2D).
End Rem
Type TDEntity
	
	Field m_pos:TVec2, m_handle:TVec2
	Field m_rotation:Float, m_scale:TVec2
	
	Field m_color:TDColor
	
		Method New()
			
			m_pos = New TVec2.Create(0.0, 0.0)
			m_handle = New TVec2.Create(0.0, 0.0)
			
			m_scale = New TVec2.Create(1.0, 1.0)
			
		End Method
		
		Rem
			bbdoc: Create a new DEntity
			returns: The new DEntity (itself).
		End Rem
		Method Create:TDEntity(xpos:Float, ypos:Float)
			
			m_pos.Set(xpos, ypos)
			
			Return Self
			
		End Method
		
End Type








































