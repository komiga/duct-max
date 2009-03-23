
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

SuperStrict

Rem
bbdoc: dui drawing routines module
End Rem
Module duct.duidraw

ModuleInfo "Version: 1.0"
ModuleInfo "Copyright: Liam McGuigan (FryGUI creator), Tim Howard (dui is a largely modified FryGUI)"
ModuleInfo "License: MIT"

ModuleInfo "History: Version 1.0"
ModuleInfo "History: Initial release"


' Used Modules
Import brl.max2d


Rem
	bbdoc: Draw an unfilled rectangle.
	returns: Nothing.
End Rem
Function dui_DrawLineRect(X:Float, Y:Float, w:Float, h:Float)
	
	DrawLine(X, Y, X + w, Y)
	DrawLine(X + w, Y, X + w, Y + h)
	DrawLine(X + w, Y + h, X, Y + h)
	DrawLine(X, Y + h, X, Y)
	
End Function

Rem
	bbdoc: Draw a circle.
	returns: Nothing.
	about: Use @fill to draw as a filled (True) or unfilled (False) circle
End Rem
Function dui_DrawCircle(x:Float, y:Float, r:Float, fill:Int = True)
	Local d:Float, nx:Float, ny:Float
	
	If fill = True
		
		DrawOval(x - r, y - r, r * 2, r * 2)
		
	Else
		
		Local lx:Float = r * 1.0 ' Cos(0)
		Local ly:Float = r * 0.0 ' Sin(0)
		
		For d = 10 To 360 Step 10
			nx = r * Cos(d)
			ny = r * Sin(d)
			
			DrawLine(X + lx, Y + ly, X + nx, Y + ny)
			lx = nx; ly = ny
			
		Next
		
	End If
	
End Function

Rem
	bbdoc: Set the viewport.
	returns: Nothing.
	about: This will create a viewport inside of the current viewport (dimensions are clamped to the size of the current viewport).
End Rem
Function dui_SetViewport(X:Int, Y:Int, w:Int, h:Int)
	Local ox:Int, oy:Int, ow:Int, oh:Int
	GetViewport(ox, oy, ow, oh)
	
	' Set x and width
	If X < ox Then X = ox
	If X > (ox + ow) Then X = (ox + ow)
	If (X + w) > (ox + ow) Then w = (ox + ow) - X
	
	' Set y and height
	If y < oy Then y = oy
	If Y > (oy + oh) Then Y = (oy + oh)
	If (Y + h) > (oh + oy) Then h = (oy + oh) - Y
	
	SetViewport(X, Y, w, h)
	
End Function

Rem
	bbdoc: The dui_TFont Type.
	about: Contains the font data for a single font.
End Rem
Type dui_TFont
	
	Global _list:TList = New TList
	Global default_font:dui_TFont
	
	Field _link:TLink
	
	Field ifont:TImageFont, url:String, size:Int, style:Int
	Field name:String
		
		Method New()
			
			_link = _list.AddLast(Self)
			
		End Method
		
		Method Delete()
			
			If _link <> Null
				_link.Remove()
				_link = Null
			End If
			
		End Method
		
		Rem
			bbdoc: Create a font.
			returns: The created font.
			about: This does not attempt to load the font, see #Load.
		End Rem
		Method Create:dui_TFont(_name:String, _url:String, _size:Int, _style:Int = SMOOTHFONT)
			
			SetName(_name)
			SetUrl(_url)
			SetSize(_size)
			SetStyle(_style)
			
			Return Self
			
		End Method
		
		Rem
			bbdoc: Set the name of the font.
			returns: Nothing.
		End Rem
		Method SetName(_name:String)
			
			name = _name
			
		End Method
		
		Rem
			bbdoc: Get the name of the font.
			returns: The name of the font.
		End Rem
		Method GetName:String()
			
			Return name
			
		End Method
		
		Rem
			bbdoc: Set the url for the font
			returns: Nothing.
		End Rem
		Method SetUrl(_url:String)
			
			url = _url
			
		End Method
		
		Rem
			bbdoc: Get the url for the font.
			returns: The url for the font.
		End Rem
		Method GetUrl:String()
			
			Return url
			
		End Method
		
		Rem
			bbdoc: Set the size of the font.
			returns: Nothing.
		End Rem
		Method SetSize(_size:Int)
			
			size = _size
			
		End Method
		
		Rem
			bbdoc: Get the size of the font.
			returns: The size of the font.
		End Rem
		Method GetSize:Int()
			
			Return size
			
		End Method
		
		Rem
			bbdoc: Set the font style.
			returns: Nothing.
		End Rem
		Method SetStyle(_style:Int)
			
			style = _style
			
		End Method
		
		Rem
			bbdoc: Get the font style.
			returns: The style for the font.
		End Rem
		Method GetStyle:Int()
			
			Return style
			
		End Method
		
		Rem
			bbdoc: Set the image as the current image font.
			returns: Nothing.
		End Rem
		Method SetState()
			
			SetImageFont(ifont)
			
		End Method
		
		Rem
			bbdoc: Set the image font for the font.
			returns: Nothing.
		End Rem
		Method SetFont(_ifont:TImageFont)
			
			ifont = _ifont
			
		End Method
		
		Rem
			bbdoc: Get the image font for the font.
			returns: The font's image font.
		End Rem
		Method GetFont:TImageFont()
			
			Return ifont
			
		End Method
		
		Rem
			bbdoc: Get the width of a string in this font.
			returns: The graphical width of @_text in this font.
		End Rem
		Method GetStringWidth:Int(_string:String)
			Local width:Int = 0, n:Int, i:Int
			
			For n = 0 Until _string.Length
				i = ifont.CharToGlyph(_string[n])
				
				If i < 0 Continue
				
				width:+ifont.LoadGlyph(i).Advance()
				
			Next
			
			Return width
			
		End Method
		
		Rem
			bbdoc: Load the image font.
			returns: True if the image font was loaded successfully, False if it was not.
		End Rem
		Method Load:Int()
			Local _ifont:TImageFont
			
			If GetUrl() <> Null
				
				_ifont = LoadImageFont(GetUrl(), GetSize(), GetStyle())
				
				If _ifont <> Null
					
					ifont = _ifont
					Return True
					
				End If
				
			End If
			
			Return False
			
		End Method
		
		Rem
			bbdoc: Set @_font as the current drawing font.
			returns: Nothing.
			about: If the font is Null, the default font will be used.
		End Rem
		Function SetDrawingFont(_font:dui_TFont)
			
			If _font <> Null
				_font.SetState()
			Else
				default_font.SetState()
			End If
			
		End Function
		
		Rem
			bbdoc: Get the width of a string in a font.
			returns: The graphical width of @_text.
			about: The default font will be used if @_font is Null.
		End Rem
		Function GetFontStringWidth:Int(_string:String, _font:dui_TFont)
			
			If _font = Null Then _font = default_font
			
			Return _font.GetStringWidth(_string)
			
		End Function
		
		Rem
			bbdoc: Get the height of a font.
			returns: The graphical height of the image font.
			about: The default font will be used if @_font is Null.
		End Rem
		Function GetFontHeight:Int(_font:dui_TFont)
			
			If _font = Null Then _font = default_font
			
			Return _font.GetSize()
			
		End Function
		
		Rem
			bbdoc: Get a font by it's name.
			returns: A dui_TFont object, or Null if the font by the given name was not found.
		End Rem
		Function GetByName:dui_TFont(_name:String, _casesens:Int = False)
			Local _font:dui_TFont, _fname:String
			
			If _name <> Null
				
				If _casesens = False Then _name = _name.ToLower()
				
				For _font = EachIn _list
					
					_fname = _font.GetName()
					If _casesens = False Then _fname = _fname.ToLower()
					
					If _name = _fname Then Return _font
					
				Next
				
			End If
			
			Return Null
			
		End Function
		
		Rem
			bbdoc: Setup the default font.
			returns: Nothing.
		End Rem
		Function SetupDefaultFont()
			
			SetDefaultFont(New dui_TFont.Create("Default", Null, 11, SMOOTHFONT))
			
		End Function
		
		Rem
			bbdoc: Set the default font.
			returns: Nothing.
		End Rem
		Function SetDefaultFont(_font:dui_TFont)
			
			If _font <> Null
				
				default_font = _font
				If default_font.GetFont() = Null
					default_font.Load()
					If default_font.GetFont() = Null Then default_font.SetFont(TMax2DGraphics.default_font)
				End If
				
			End If
			
		End Function
		
		
End Type



















