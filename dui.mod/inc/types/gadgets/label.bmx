
Rem
	label.bmx (Contains: dui_TLabel, )
End Rem

Rem
	bbdoc: The dui label gadget type.
End Rem
Type dui_TLabel Extends dui_TGadget
	
	Field gText:String
	Field gXAlign:Int, gYAlign:Int		' Alignment
	Field gOrigX:Int, gOrigY:Int		' Original position
	
	Rem
		bbdoc: Create a label gadget.
		returns: The created label gadget (itself).
	End Rem
	Method Create:dui_TLabel(_name:String, _text:String, _x:Float, _y:Float, _w:Float, _h:Float, _xalign:Int, _yalign:Int, _parent:dui_TGadget)
		PopulateGadget(_name, _x, _y, _w, _h, _parent)
		SetXAlign(_xalign, False)
		SetYAlign(_yalign, False)
		SetText(_text, False)
		Refresh()
		Return Self
	End Method
	
	Rem
		bbdoc: Populate the label's base values.
		returns: Nothing.
	End Rem
	Method SetPosition(_x:Float, _y:Float)
		Super.SetPosition(_x, _y)
		gOrigX = _x
		gOrigY = _y
	End Method
	
	Rem
		bbdoc: Render the label.
		returns: Nothing.
	End Rem
	Method Render(_x:Float, _y:Float)
		'Local rX:Float, rY:Float
		If IsVisible() = True
			'rX = gX + _x
			'rY = gY + _y
			SetTextDrawingState(True)
			DrawText(gText, gX + _x, gY + _y)
			Super.Render(_x, _y)
		End If
	End Method
	
	Rem
		bbdoc: Set the label's text.
		returns: Nothing.
	End Rem
	Method SetText(_text:String, _dorefresh:Int = True)
		gText = _text
		If _dorefresh = True Then Refresh()
	End Method
	
	Rem
		bbdoc: Get the label's text.
		returns: The label's text.
	End Rem
	Method GetText:String()
		Return gText
	End Method
		
	Rem
		bbdoc: Set the x alignment.
		returns: Nothing.
		about: @_align can be:<br/>
		0 - Left<br/>
		1 - Central<br/>
		2 - Right<br/>
	End Rem
	Method SetXAlign(_align:Int, _dorefresh:Int = True)
		gXAlign = _align
		If _dorefresh = True Then Refresh()
	End Method
	
	Rem
		bbdoc: Set the y alignment.
		returns: Nothing.
		about: @_align can be:<br/>
		0 - Top<br/>
		1 - Central<br/>
		2 - Bottom<br/>
	End Rem
	Method SetYAlign(_align:Int, _dorefresh:Int = True)
		gYAlign = _align
		If _dorefresh = True Then Refresh()
	End Method
	
	Rem
		bbdoc: Refresh the label.
		returns: Nothing.
	End Rem
	Method Refresh()
		' Use original locations to determine further details
		' X location
		Select gXAlign
			Case 0		' Left
				gX = gOrigX
			Case 1		' Central
				gX = gOrigX - (dui_TFont.GetFontStringWidth(GetText(), gFont) / 2)
			Case 2		' Right
				gX = gOrigX - dui_TFont.GetFontStringWidth(GetText(), gFont)
		End Select
		
		' Y location
		Select gYAlign
			Case 0		' Top
				gY = gOrigY
			Case 1		' Central
				gY = gOrigY - (dui_TFont.GetFontHeight(gFont) / 2)
			Case 2		' Bottom
				gY = gOrigY - dui_TFont.GetFontHeight(gFont)
		End Select
		
		gW = dui_TFont.GetFontStringWidth(GetText(), gFont)
		gH = dui_TFont.GetFontHeight(gFont)
	End Method
	
End Type






























