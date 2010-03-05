
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

SuperStrict

Rem
bbdoc: dui drawing routines module
End Rem
Module duct.duidraw

ModuleInfo "Version: 1.2"
ModuleInfo "Copyright: Liam McGuigan (FryGUI creator)"
ModuleInfo "Copyright: Tim Howard (dui is a heavily modified FryGUI)"
ModuleInfo "License: MIT"

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
		If font = Null
			font = m_default_font
		End If
		If font <> Null
			font.DrawStringParams(text, x, y, hcenter, vcenter)
		End If
	End Function
	
	Rem
		bbdoc: Get the width of the given string.
		returns: The width of the given string, or 8.0 if the given font and the default font are both Null (unable to calculate anything).
		about: The default font will be used if the given font is Null.
	End Rem
	Function StringWidth:Float(_string:String, font:dProtogFont)
		If font = Null
			font = m_default_font
		End If
		If font <> Null
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
		If font = Null
			font = m_default_font
		End If
		If font <> Null
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
	Local pos:dVec2, size:dVec2
	pos = dProtog2DDriver.GetViewportPosition()
	size = dProtog2DDriver.GetViewportSize()
	
	If x < 0
		'DebugLog("(dui_SetViewport) x = " + x + ", width = " + width)
		width:+x
		x = 0
		'DebugLog("(dui_SetViewport) width = " + width)
	End If
	If y < 0
		'DebugLog("(dui_SetViewport) y = " + y + ", height = " + height)
		height:+y
		y = 0
		'DebugLog("(dui_SetViewport) height = " + height)
	End If
	
	' Set x and width
	If x < pos.m_x
		x = pos.m_x
	End If
	If x > (pos.m_x + size.m_x)
		x = (pos.m_x + size.m_x)
	End If
	If (x + width) > (pos.m_x + size.m_x)
		width = (pos.m_x + size.m_x) - x
	End If
	
	' Set y and height
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

'Rem
'	bbdoc: Duct UI font.
'End Rem
'Type dui_TFont
'	
'	Global m_list:TListEx = New TListEx
'	Global m_default_font:dui_TFont
'	
'	Field m_link:TLink
'	
'	Field m_pfont:dProtogFont, m_url:String, m_size:Int, m_style:Int
'	Field m_name:String
'	
'	Method New()
'		m_link = m_list.AddLast(Self)
'	End Method
'	
'	Method Delete()
'		If m_link <> Null
'			m_link.Remove()
'			m_link = Null
'		End If
'	End Method
'	
'	Rem
'		bbdoc: Create a font.
'		returns: The created font.
'		about: This does not attempt to load the font, see #Load.
'	End Rem
'	Method Create:dui_TFont(name:String, url:String, size:Int, style:Int = SMOOTHFONT)
'		SetName(name)
'		SetUrl(url)
'		SetSize(size)
'		SetStyle(style)
'		
'		Return Self
'	End Method
'	
''#region Field accessors
'	
'	Rem
'		bbdoc: Set the name of the font.
'		returns: Nothing.
'	End Rem
'	Method SetName(name:String)
'		m_name = name
'	End Method
'	
'	Rem
'		bbdoc: Get the name of the font.
'		returns: The name of the font.
'	End Rem
'	Method GetName:String()
'		Return m_name
'	End Method
'	
'	Rem
'		bbdoc: Set the url for the font
'		returns: Nothing.
'	End Rem
'	Method SetUrl(url:String)
'		m_url = url
'	End Method
'	
'	Rem
'		bbdoc: Get the url for the font.
'		returns: The url for the font.
'	End Rem
'	Method GetUrl:String()
'		Return m_url
'	End Method
'	
'	Rem
'		bbdoc: Set the size of the font.
'		returns: Nothing.
'	End Rem
'	Method SetSize(size:Int)
'		m_size = size
'	End Method
'	
'	Rem
'		bbdoc: Get the size of the font.
'		returns: The size of the font.
'	End Rem
'	Method GetSize:Int()
'		Return m_size
'	End Method
'	
'	Rem
'		bbdoc: Set the font style.
'		returns: Nothing.
'	End Rem
'	Method SetStyle(style:Int)
'		m_style = style
'	End Method
'	
'	Rem
'		bbdoc: Get the font style.
'		returns: The style for the font.
'	End Rem
'	Method GetStyle:Int()
'		Return m_style
'	End Method
'	
'	Rem
'		bbdoc: Set the image as the current image font.
'		returns: Nothing.
'	End Rem
'	Method SetState()
'		SetImageFont(m_pfont)
'	End Method
'	
'	Rem
'		bbdoc: Set the image font for the font.
'		returns: Nothing.
'	End Rem
'	Method SetFont(ifont:TImageFont)
'		m_pfont = ifont
'	End Method
'	
'	Rem
'		bbdoc: Get the image font for the font.
'		returns: The font's image font.
'	End Rem
'	Method GetFont:TImageFont()
'		Return m_pfont
'	End Method
'	
''#end region (Field accessors)
'	
''#region String stuff
'	
'	Rem
'		bbdoc: Get the width of a string in this font.
'		returns: The graphical width of @_string in this font.
'	End Rem
'	Method GetStringWidth:Int(_string:String)
'		Local width:Int = 0, n:Int, i:Int
'		
'		For n = 0 Until _string.Length
'			i = m_pfont.CharToGlyph(_string[n])
'			If i < 0
'				Continue
'			End If
'			width:+m_pfont.LoadGlyph(i).Advance()
'		Next
'		Return width
'	End Method
'	
'	Rem
'		bbdoc: Get the width of a string in a font.
'		returns: The graphical width of @_string.
'		about: The default font will be used if @font is Null.
'	End Rem
'	Function GetFontStringWidth:Int(_string:String, font:dui_TFont)
'		If font = Null
'			font = m_default_font
'		End If
'		Return font.GetStringWidth(_string)
'	End Function
'	
'	Rem
'		bbdoc: Get the height of a font.
'		returns: The graphical height of the image font.
'		about: The default font will be used if @font is Null.
'	End Rem
'	Function GetFontHeight:Int(font:dui_TFont)
'		If font = Null
'			font = m_default_font
'		End If
'		
'		Return font.GetSize()
'	End Function
'	
''#end region (String stuff)
'	
''#region Data handlers
'	
'	Rem
'		bbdoc: Load the image font.
'		returns: True if the image font was loaded successfully, False if it was not.
'	End Rem
'	Method Load:Int()
'		Local ifont:TImageFont
'		
'		If m_url <> Null
'			m_pfont = LoadImageFont(m_url, m_size, m_style)
'			If m_pfont <> Null
'				m_pfont = ifont
'				Return True
'			End If
'		End If
'		Return False
'	End Method
'	
''#end region (Data handlers)
'	
'	Rem
'		bbdoc: Get a font by its name.
'		returns: The font with the name given, or Null if the font by the given name was not found.
'	End Rem
'	Function GetByName:dui_TFont(name:String, casesens:Int = False)
'		Local font:dui_TFont, fname:String
'		
'		If name <> Null
'			If casesens = False
'				name = name.ToLower()
'			End If
'			
'			For font = EachIn m_list
'				fname = font.GetName()
'				If casesens = False
'					fname = fname.ToLower()
'				End If
'				If name = fname
'					Return font
'				End If
'			Next
'		End If
'		
'		Return Null
'	End Function
'	
'	Rem
'		bbdoc: Setup the default font.
'		returns: Nothing.
'	End Rem
'	Function SetupDefaultFont()
'		SetDefaultFont(New dui_TFont.Create("Default", Null, 11, SMOOTHFONT))
'	End Function
'	
'	Rem
'		bbdoc: Set the default font.
'		returns: Nothing.
'	End Rem
'	Function SetDefaultFont(font:dui_TFont)
'		If font <> Null
'			If font.m_pfont = Null
'				font.Load()
'			End If
'			If font.m_pfont <> Null
'				m_default_font = font
'			End If
'		End If
'	End Function
'	
'End Type

