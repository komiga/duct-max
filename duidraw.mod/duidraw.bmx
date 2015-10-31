
Rem
Copyright (c) 2010 Coranna Howard <me@komiga.com>

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
bbdoc: dui rendering routines module
End Rem
Module duct.duidraw

ModuleInfo "Version: 1.3"
ModuleInfo "Copyright: Liam McGuigan (FryGUI creator)"
ModuleInfo "Copyright: Coranna Howard <me@komiga.com> (dui is a heavily modified FryGUI)"
ModuleInfo "License: MIT"

ModuleInfo "History: Version 1.3"
ModuleInfo "History: General cleanup"
ModuleInfo "History: Version 1.2"
ModuleInfo "History: Fixed license"
ModuleInfo "History: Updated for TProtog* to dProtog* rename"
ModuleInfo "History: Version 1.1"
ModuleInfo "History: General cleanup"
ModuleInfo "History: Version 1.01"
ModuleInfo "History: Cleanup"
ModuleInfo "History: Version 1.0"
ModuleInfo "History: Initial release"

Import duct.protog2d

Rem
	bbdoc: The dui font manager.
End Rem
Type duiFontManager
	
	Global m_default_font:dProtogFont
	
	Rem
		bbdoc: Render text using the given font.
		returns: Nothing.
		about: The default font will be used if the given font is Null.
	End Rem
	Function RenderString(text:String, font:dProtogFont, x:Float, y:Float, hcenter:Int = False, vcenter:Int = False)
		If Not font Then font = m_default_font
		If font
			font.RenderStringParams(text, x, y, hcenter, vcenter)
		End If
	End Function
	
	Rem
		bbdoc: Get the width of the given string.
		returns: The width of the given string, or 8.0 if the given font and the default font are both Null (unable to calculate anything).
		about: The default font will be used if the given font is Null.
	End Rem
	Function StringWidth:Float(_string:String, font:dProtogFont)
		If Not font Then font = m_default_font
		If font
			Return font.StringWidth(_string)
		End If
		Return 8.0
	End Function
	
	Rem
		bbdoc: Get the height of the given string.
		returns: The height of the given string, or 16.0 if the given font and the default font are both Null (unable to calculate anything).
		about: The default font will be used if the given font is Null.
	End Rem
	Function StringHeight:Float(_string:String, font:dProtogFont)
		If Not font Then font = m_default_font
		If font
			Return font.StringHeight(_string)
		End If
		Return 16.0
	End Function
	
	Rem
		bbdoc: Set the default font.
		returns: Nothing.
	End Rem
	Function SetDefaultFont(font:dProtogFont)
		m_default_font = font
	End Function
	
End Type

Rem
	bbdoc: Set the viewport.
	returns: Nothing.
	about: This will create a viewport inside of the current viewport (dimensions are clamped to the size of the current viewport).
End Rem
Function dui_SetViewport(x:Int, y:Int, width:Int, height:Int)
	Local pos:dVec2 = dProtog2DDriver.GetViewportPosition()
	Local size:dVec2 = dProtog2DDriver.GetViewportSize()
	If x < 0
		width:+ x
		x = 0
	End If
	If y < 0
		height:+ y
		y = 0
	End If
	If x < pos.m_x
		x = pos.m_x
	End If
	If x > (pos.m_x + size.m_x)
		x = (pos.m_x + size.m_x)
	End If
	If (x + width) > (pos.m_x + size.m_x)
		width = (pos.m_x + size.m_x) - x
	End If
	If y < pos.m_y
		y = pos.m_y
	End If
	If y > (pos.m_y + size.m_y)
		y = (pos.m_y + size.m_y)
	End If
	If (y + height) > (pos.m_y + size.m_y)
		height = (pos.m_y + size.m_y) - y
	End If
	dProtog2DDriver.SetViewportParams(x, y, width, height)
End Function

