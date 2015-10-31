
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

Rem
	bbdoc: duct ui base gadget.
End Rem
Type duiGadget
	
	Const STATE_IDLE:Int = 0			' Gadget is idle
	Const STATE_MOUSEOVER:Int = 1		' Mouse is over the gadget
	Const STATE_MOUSEDOWN:Int = 2		' Mouse button is down
	Const STATE_MOUSERELEASE:Int = 3	' Mouse button is released
	
	Const BOUNDARY:Int = 2
	Const DOUBLEBOUNDARY:Int = 4
	
	Global m_defaultcolor:dProtogColor[] = [New dProtogColor.Create(1.0, 1.0, 1.0, 1.0),  ..
		New dProtogColor.Create(0.0, 0.0, 0.0, 1.0),  ..
		New dProtogColor.Create(1.0, 1.0, 1.0, 1.0)]
	
	Global m_defaulttextcolor:dProtogColor[] = [New dProtogColor.Create(0.0, 0.0, 0.0, 1.0),  ..
		New dProtogColor.Create(1.0, 1.0, 1.0, 1.0),  ..
		New dProtogColor.Create(0.0, 0.0, 0.0, 1.0)]
	
	Global m_oz:Int 			' Old MouseZ position
	
	Field m_name:String
	Field m_x:Float, m_y:Float, m_width:Float, m_height:Float
	
	Field m_parent:duiGadget
	Field m_children:TListEx = New TListEx
	
	Field m_color:dProtogColor[], m_textcolor:dProtogColor[]
	Field m_font:dProtogFont
	
	Field m_visible:Int = True
	Field m_state:Int = STATE_IDLE
	
	Rem
		bbdoc: Initiate the gadget.
		returns: Nothing.
	End Rem
	Method _Init(name:String, x:Float, y:Float, w:Float, h:Float, parent:duiGadget, dorefresh:Int)
		m_color = [m_defaultcolor[0].Copy(), m_defaultcolor[1].Copy(), m_defaultcolor[2].Copy()]
		m_textcolor = [m_defaulttextcolor[0].Copy(), m_defaulttextcolor[1].Copy(), m_defaulttextcolor[2].Copy()]
		SetName(name)
		SetPosition(x, y)
		SetSize(w, h, dorefresh)
		SetFont(Null, dorefresh)
		SetParent(parent)
	End Method
	
'#region Render & update methods
	
	Rem
		bbdoc: Render the gadget.
		returns: Nothing.
	End Rem
	Method Render(x:Float, y:Float)
		If m_children.Count() > 0
			Local relx:Float = m_x + x
			Local rely:Float = m_y + y
			dProtogDrawState.Push(False, False, False, True, False, False)
			dui_SetViewport(relx + BOUNDARY, rely + BOUNDARY, m_width - DOUBLEBOUNDARY, m_height - DOUBLEBOUNDARY)
			For Local child:duiGadget = EachIn m_children
				child.Render(relx, rely)
			Next
			dProtogDrawState.Pop(False, False, False, True, False, False)
		End If
	End Method
	
	Rem
		bbdoc: Update the gadget.
		returns: Nothing.
	End Rem
	Method Update(x:Int, y:Int)
		If m_state = STATE_MOUSEDOWN
			If MouseDown(1)
				UpdateMouseDown(x, y)
				Return
			End If
			If Not MouseDown(1)
				UpdateMouseRelease(x, y)
				Return
			End If
		End If
		If IsVisible()
			Local relx:Float = m_x + x
			Local rely:Float = m_y + y
			For Local child:duiGadget = EachIn New TListReversed.Create(m_children)
				child.Update(relx, rely)
			Next
			m_state = STATE_IDLE
			If duiMain.IsGadgetActive(Self)
				If dui_MouseIn(relx, rely, m_width, m_height)
					UpdateMouseOver(x, y)
					If MouseDown(1)
						UpdateMouseDown(x, y)
					End If
				End If
			End If
		End If
	End Method
	
	Rem
		bbdoc: Update the MouseOver state.
		returns: Nothing.
	End Rem
	Method UpdateMouseOver(x:Int, y:Int)
		m_state = STATE_MOUSEOVER
		'duiMain.SetFocusedGadget(Self, MouseX() - (m_x + x), MouseY() - (m_y + y))
		duiMain.SetFocusedGadget(Self, x - GetAbsoluteX(), y - GetAbsoluteY())
	End Method
	
	Rem
		bbdoc: Update the MouseDown state.
		returns: Nothing.
	End Rem
	Method UpdateMouseDown(x:Int, y:Int)
		duiMain.SetActiveGadget(Self)
		m_state = STATE_MOUSEDOWN
	End Method
	
	Rem
		bbdoc: Update the MouseRelease state.
		returns: Nothing.
	End Rem
	Method UpdateMouseRelease(x:Int, y:Int)
		duiMain.ClearActiveGadget()
		m_state = STATE_MOUSERELEASE
	End Method
	
	Rem
		bbdoc: Refresh the gadget.
		returns: Nothing.
	End Rem
	Method Refresh()
	End Method
	
'#end region Render & update methods
	
'#region Field accessors
	
	Rem
		bbdoc: Set the name of the gadget.
		returns: Nothing.
	End Rem
	Method SetName(name:String)
		m_name = name
	End Method
	
	Rem
		bbdoc: Get the name of the gadget.
		returns: The gadget's name.
	End Rem
	Method GetName:String()
		Return m_name
	End Method
	
	Rem
		bbdoc: Get the absolute position of the gadget.
		returns: The absolute position of the gadget.
	End Rem
	Method GetAbsolutePosition:dVec2()
		Return New dVec2.Create(GetAbsoluteX(), GetAbsoluteY())
	End Method
	
	Rem
		bbdoc: Get the absolute x position of the gadget.
		returns: The absolute x position of the gadget.
	End Rem
	Method GetAbsoluteX:Float()
		If m_parent
			Return m_x + m_parent.GetAbsoluteX()
		Else
			Return m_x
		End If
	End Method
	
	Rem
		bbdoc: Get the absolute y position of the gadget.
		returns: The absolute y position of the gadget.
	End Rem
	Method GetAbsoluteY:Float()
		If m_parent
			Return m_y + m_parent.GetAbsoluteY()
		Else
			Return m_y
		End If
	End Method
	
	Rem
		bbdoc: Set the position of the gadget.
		returns: Nothing.
		about: The position is relative to the parent of the gadget.
	End Rem
	Method SetPosition(x:Float, y:Float)
		m_x = x
		m_y = y
	End Method
	
	Rem
		bbdoc: Get the gadget's x position.
		returns: The gadget's x position.
	End Rem
	Method GetX:Float()
		Return m_x
	End Method
	
	Rem
		bbdoc: Get the gadget's y position.
		returns: The gadget's y position.
	End Rem
	Method GetY:Float()
		Return m_y
	End Method
	
	Rem
		bbdoc: Set the size of the gadget.
		returns: Nothing.
		about: If @dorefresh is True, the gadget will be refreshed (updates positions, text, etc).
	End Rem
	Method SetSize(width:Float, height:Float, dorefresh:Int = True)
		m_width = width
		m_height = height
		If dorefresh
			Refresh()
		End If
	End Method
	
	Rem
		bbdoc: Get the gadget's width.
		returns: The gadget's width.
	End Rem
	Method GetWidth:Float()
		Return m_width
	End Method
	
	Rem
		bbdoc: Get the gadget's height.
		returns: The gadget's height.
	End Rem
	Method GetHeight:Float()
		Return m_height
	End Method
	
	Rem
		bbdoc: Set the gadget's font.
		returns: Nothing.
		about: If @dorefresh is True, the gadget will be refreshed (updates positions, text, etc).
	End Rem
	Method SetFont(font:dProtogFont, dorefresh:Int = True)
		m_font = font
		If dorefresh
			Refresh()
		End If
	End Method
	
	Rem
		bbdoc: Get the gadget's font.
		returns: The gadget's font.
	End Rem
	Method GetFont:dProtogFont()
		'If Not m_font
		'	Return dui_Font.default_font
		'Else
			Return m_font
		'End If
	End Method
	
	Rem
		bbdoc: Set the gadget's parent.
		returns: Nothing.
	End Rem
	Method SetParent(parent:duiGadget)
		If parent
			' AddChild sets the parent for this gadget
			parent.AddChild(Self)
		End If
	End Method
	Rem
		bbdoc: Get the gadget's parent.
		returns: The gadget's parent.
	End Rem
	Method GetParent:duiGadget()
		Return m_parent
	End Method
	
'#end region Field accessors
	
'#region Color setters/getters
	
	Rem
		bbdoc: Set the color of the gadget.
		returns: Nothing.
	End Rem
	Method SetColor(color:dProtogColor, alpha:Int = True, index:Int = 0, recursive:Int = False)
		If index > -1 And index < m_color.Length
			m_color[index].SetFromColor(color, alpha)
			If recursive
				For Local gadget:duiGadget = EachIn m_children
					gadget.SetColor(color, alpha, index, True)
				Next
			End If
		End If
	End Method
	
	Rem
		bbdoc: Set the color of the gadget by the parameters given.
		returns: Nothing.
	End Rem
	Method SetColorParams(red:Float, green:Float, blue:Float, index:Int = 0, recursive:Int = False)
		If index > -1 And index < m_color.Length
			m_color[index].SetColor(red, green, blue)
			If recursive
				For Local gadget:duiGadget = EachIn m_children
					gadget.SetColorParams(red, green, blue, index, True)
				Next
			End If
		End If
	End Method
	
	Rem
		bbdoc: Get the color of the gadget.
		returns: The color for the gadget at the given index, or Null if the given index was invalid.
	End Rem
	Method GetColor:dProtogColor(index:Int = 0)
		If index > -1 And index < m_color.Length
			Return m_color[index]
		End If
		Return Null
	End Method
	
	Rem
		bbdoc: Set the text color of the gadget.
		returns: Nothing.
	End Rem
	Method SetTextColor(color:dProtogColor, alpha:Int = True, index:Int = 0, recursive:Int = False)
		If index > -1 And index < m_textcolor.Length
			m_textcolor[index].SetFromColor(color, alpha)
			If recursive
				For Local gadget:duiGadget = EachIn m_children
					gadget.SetTextColor(color, alpha, index, True)
				Next
			End If
		End If
	End Method
	
	Rem
		bbdoc: Set the text color of the gadget by the parameters given.
		returns: Nothing.
	End Rem
	Method SetTextColorParams(red:Float, green:Float, blue:Float, index:Int = 0, recursive:Int = False)
		If index > -1 And index < m_textcolor.Length
			m_textcolor[index].SetColor(red, green, blue)
			If recursive
				For Local gadget:duiGadget = EachIn m_children
					gadget.SetTextColorParams(red, green, blue, index, True)
				Next
			End If
		End If
	End Method
	
	Rem
		bbdoc: Get the text color of the gadget.
		returns: The text color for the gadget at the given index, or Null if the given index was invalid.
	End Rem
	Method GetTextColor:dProtogColor(index:Int = 0)
		If index > -1 And index < m_textcolor.Length
			Return m_textcolor[index]
		End If
		Return Null
	End Method
	
	Rem
		bbdoc: Set the alpha of the gadget.
		returns: Nothing.
	End Rem
	Method SetAlpha(alpha:Float, index:Int = 0, recursive:Int = False)
		If index > -1 And index < m_color.Length
			m_color[index].SetAlpha(alpha)
			If recursive
				For Local gadget:duiGadget = EachIn m_children
					gadget.SetAlpha(alpha, index, True)
				Next
			End If
		End If
	End Method
	
	Rem
		bbdoc: Get the alpha value of the gadget at the given index.
		returns: The alpha value at the given index, or 1.0 if the given index was invalid.
	End Rem
	Method GetAlpha:Float(index:Int = 0)
		If index > -1 And index < m_color.Length
			Return m_color[index].GetAlpha()
		End If
		Return 1.0
	End Method
	
	Rem
		bbdoc: Set the text alpha of the gadget.
		returns: Nothing.
	End Rem
	Method SetTextAlpha(alpha:Float = 0, index:Int = 0, recursive:Int = False)
		If index > -1 And index < m_textcolor.Length
			m_textcolor[index].SetAlpha(alpha)
			If recursive
				For Local gadget:duiGadget = EachIn m_children
					gadget.SetTextAlpha(alpha, index, True)
				Next
			End If
		End If
	End Method
	
	Rem
		bbdoc: Get the text alpha value of the gadget at the given index.
		returns: The alpha value at the given index, or 1.0 if the given index was invalid.
	End Rem
	Method GetTextAlpha:Float(index:Int = 0)
		If index > -1 And index < m_textcolor.Length
			Return m_textcolor[index].GetAlpha()
		End If
		Return 1.0
	End Method
	
'#end region Color setters/getters
	
'#region Gadget function
	
	Rem
		bbdoc: Bind the gadget's standard rendering state.
		returns: Nothing.
		about: This will set the rendering color and alpha to the gadget's color and alpha (if @alpha is True). See also #BindTextRenderingState.
	End Rem
	Method BindRenderingState(index:Int = 0, alpha:Int = True)
		If index > -1 And index < m_color.Length
			dProtog2DDriver.BindPColor(m_color[index], alpha)
		End If
	End Method
	
	Rem
		bbdoc: Bind the gadget's text rendering state.
		returns: Nothing.
		about: This will set the rendering color and alpha to the gadget's text color and alpha (if @alpha is True). See also #BindRenderingState.
	End Rem
	Method BindTextRenderingState(index:Int = 0, alpha:Int = True)
		If index > -1 And index < m_textcolor.Length
			dProtog2DDriver.BindPColor(m_textcolor[index], alpha)
		End If
	End Method
	
	Rem
		bbdoc: Move the gadget by the given vector (position adds to it).
		returns: Nothing.
		about: Moves the gadget to a new position relative to its current position.<br/>
		If the given vector is Null, the position will not be changed.
	End Rem
	Method MoveGadgetVec(vec:dVec2)
		If vec
			MoveGadget(vec.m_x, vec.m_y)
		End If
	End Method
	
	Rem
		bbdoc: Move the gadget by the parameters given.
		returns: Nothing.
		about: Moves the gadget to a new position relative to its current position.
	End Rem
	Method MoveGadget(xoff:Float, yoff:Float)
		m_x:+ xoff
		m_y:+ yoff
	End Method
	
	Rem
		bbdoc: Set the gadget visibility.
		returns: Nothing.
		about: @visible can be True (shown) or False (hidden).
	End Rem
	Method SetVisible(visible:Int)
		m_visible = visible
	End Method
	
	Rem
		bbdoc: Toggle gadget visibilty.
		returns: Nothing.
	End Rem
	Method ToggleVisibility()
		SetVisible(m_visible~1)
	End Method
	
	Rem
		bbdoc: Hide the gadget.
		returns: Nothing.
		about: Neither this gadget nor its children will be drawn.
	End Rem
	Method Hide()
		SetVisible(False)
	End Method
	
	Rem
		bbdoc: Show the gadget and children.
		returns: Nothing.
		about: This gadget and its children will be drawn.
	End Rem
	Method Show()
		SetVisible(True)
	End Method
	
	Rem
		bbdoc: Check if the gadget is visible.
		returns: True if the gadget is visible, or False if it is not visible.
	End Rem
	Method IsVisible:Int()
		Return m_visible
	End Method
	
	Rem
		bbdoc: Send a key code for interpretation to the gadget (experimental).
		returns: Nothing.
	End Rem
	Method SendKey(key:Int, _type:Int = 0)
		' Base gadget does nothing for the key
	End Method
	
'#end region Gadget function
	
'#region Collections
	
	Rem
		bbdoc: Add a child to the gadget.
		returns: Nothing.
	End Rem
	Method AddChild(gadget:duiGadget)
		If gadget
			m_children.AddLast(gadget)
			gadget.m_parent = Self
		End If
	End Method
	
	Rem
		bbdoc: Get a child gadget with the given name.
		returns: A gadget with the given name, or Null if the gadget has no child with the name given.
	End Rem
	Method GetChildWithName:duiGadget(name:String)
		If name
			name = name.ToLower()
			For Local gadget:duiGadget = EachIn m_children
				If gadget.m_name.ToLower() = name
					Return gadget
				End If
			Next
		End If
		Return Null
	End Method
	
'#end region Collections
	
End Type

