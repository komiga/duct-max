
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
	
	drawstate.bmx (Contains: TProtogDrawState, )
	
	TODO:
		
	
End Rem

Rem
	bbdoc: Protog2D drawstate.
End Rem
Type TProtogDrawState
	
	Rem
		bbdoc: The default draw state.
		about: This needs be initiated after the graphics window is setup (#InitiateDefaultState).
	End Rem
	Global m_defaultstate:TProtogDrawState
	Global m_stack:TList = New TList
	
	Field m_link:TLink
	
	Field m_blend:Int, m_alpha:Float
	Field m_color:TProtogColor, m_clscolor:TProtogColor
	Field m_viewportpos:TVec2, m_viewportsize:TVec2
	Field m_linewidth:Float
	Field m_texture:TGLTexture
	
	Method New()
	End Method
	
	Method Delete()
		Remove()
	End Method
	
	Rem
		bbdoc: Add the state to the stack.
		returns: Nothing.
	End Rem
	Method AddToStack()
		If m_link = Null
			m_link = m_stack.AddLast(Self)
		End If
	End Method
	
	Rem
		bbdoc: Remove the DrawState from the stack.
		returns: Nothing.
	End Rem
	Method Remove()
		If m_link <> Null
			m_link.Remove()
			m_link = Null
		End If
	End Method
	
	Rem
		bbdoc: Create a new DrawState.
		returns: The new DrawState (itself).
		about: If @addstack is False, the DrawState will not be added to the stack.
	End Rem
	Method Create:TProtogDrawState(addstack:Int = True)
		If addstack = True
			AddToStack()
		End If
		Return Self
	End Method
	
'#region Store/Push states
	
	Rem
		bbdoc: Store the drawing states.
		returns: Nothing.
		about: This will save the drawing states into the object.
	End Rem
	Method StoreStates(colors:Int = True, alpha:Int = True, blend:Int = True, viewport:Int = False, linewidth:Int = False, texture:Int = False)
		If colors = True Then StoreAllColorsState()
		If alpha = True Then StoreAlphaState()
		If blend = True Then StoreBlendState()
		If viewport = True Then StoreViewPortState()
		If linewidth = True Then StoreLineWidthState()
		If texture = True Then StoreTextureState()
	End Method
	
	Rem
		bbdoc: Store the whole current drawing state.
		returns: Nothing.
		about: This will save the whole drawing state into the object.
	End Rem
	Method StoreFullState()
		StoreStates(True, True, True, True, True, True)
	End Method
	
	Rem
		bbdoc: Store the viewport state.
		returns: Nothing.
	End Rem
	Method StoreViewportState()
		m_viewportpos = TProtog2DDriver.GetViewportPosition().Copy()
		m_viewportsize = TProtog2DDriver.GetViewportSize().Copy()
	End Method
	
	Rem
		bbdoc: Store the color state.
		returns: Nothing.
	End Rem
	Method StoreColorState()
		m_color = TProtog2DDriver.GetBoundColor().Copy()
	End Method
	
	Rem
		bbdoc: Store the clearscreen color state.
		returns: Nothing.
	End Rem
	Method StoreClsColorState()
		m_clscolor = TProtog2DDriver.GetClsColor().Copy()
	End Method
	
	Rem
		bbdoc: Store all color (standard, cls) states.
		returns: Nothing.
	End Rem
	Method StoreAllColorsState()
		StoreColorState()
		StoreClsColorState()
	End Method
	
	Rem
		bbdoc: Store the text color state.
		returns: Nothing.
	End Rem
	Method StoreBlendState()
		m_blend = TProtog2DDriver.GetBlend()
	End Method
	
	Rem
		bbdoc: Store the alpha state.
		returns: Nothing.
	End Rem
	Method StoreAlphaState()
		m_alpha = TProtog2DDriver.GetAlpha()
	End Method
	
	Rem
		bbdoc: Store the line width state.
		returns: Nothing.
	End Rem
	Method StoreLineWidthState()
		m_linewidth = TProtog2DDriver.GetLineWidth()
	End Method
	
	Rem
		bbdoc: Store the active (bound) texture.
		returns: Nothing.
	End Rem
	Method StoreTextureState()
		m_texture = TProtog2DDriver.GetActiveTexture()
	End Method
	
'#end region (Store/Push states)
	
'#region Set/Pop states
	
	Rem
		bbdoc: Set the draw state.
		returns: Nothing.
		about: This will set (or 'reinstate'/'pop') the current draw state.
	End Rem
	Method SetStates(colors:Int = True, alpha:Int = True, blend:Int = True, viewport:Int = False, linewidth:Int = False, texture:Int = False)
		If colors = True Then SetAllColorsState()
		If alpha = True Then SetAlphaState()
		If blend = True Then SetBlendState()
		If viewport = True Then SetViewPortState()
		If linewidth = True Then SetLineWidthState()
		If texture = True Then SetTextureState()
	End Method
	
	Rem
		bbdoc: Set the draw state.
		returns: Nothing.
		about: This will set (or 'reinstate'/'pop') the current draw state.
	End Rem
	Method SetFullState()
		SetStates(True, True, True, True, True, True)
	End Method
	
	Rem
		bbdoc: Set ('pop') the viewport state.
		returns: Nothing.
	End Rem
	Method SetViewportState()
		TProtog2DDriver.SetViewportParams(m_viewportpos.m_x, m_viewportpos.m_y, m_viewportsize.m_x, m_viewportsize.m_y)
	End Method
	
	Rem
		bbdoc: Set ('pop') the color state.
		returns: Nothing.
	End Rem
	Method SetColorState()
		If m_color <> Null
			TProtog2DDriver.BindPColor(m_color)
		End If
	End Method
	
	Rem
		bbdoc: Set ('pop') the clearscreen color state.
		returns: Nothing.
	End Rem
	Method SetClsColorState()
		If m_clscolor <> Null
			TProtog2DDriver.SetClsColor(m_clscolor)
		End If
	End Method
	
	Rem
		bbdoc: Set ('pop') all the color (standard, cls) states.
		returns: Nothing.
	End Rem
	Method SetAllColorsState()
		SetColorState()
		SetClsColorState()
	End Method
	
	Rem
		bbdoc: Set ('pop') the blend state.
		returns: Nothing.
	End Rem
	Method SetBlendState()
		TProtog2DDriver.SetBlend(m_blend)
	End Method
	
	Rem
		bbdoc: Set ('pop') the alpha state.
		returns: Nothing.
	End Rem
	Method SetAlphaState()
		TProtog2DDriver.SetAlpha(m_alpha)
	End Method
	
	Rem
		bbdoc: Set ('pop') the line width state.
		returns: Nothing.
	End Rem
	Method SetLineWidthState()
		TProtog2DDriver.SetLineWidth(m_linewidth)
	End Method
	
	Rem
		bbdoc: Set ('pop') the line width state.
		returns: Nothing.
	End Rem
	Method SetTextureState()
		If m_texture <> Null
			TProtog2DDriver.UnbindActiveTexture()
			TProtog2DDriver.BindTexture(m_texture)
		End If
	End Method
	
'#end region (Set/Pop states)
	
	Rem
		bbdoc: Push the current graphics state on to the stack.
		returns: The pushed state (for consistency).
	End Rem
	Function Push:TProtogDrawState(colors:Int = True, alpha:Int = True, blend:Int = True, viewport:Int = True, linewidth:Int = True, texture:Int = True)
		Local dstate:TProtogDrawState
		
		dstate = New TProtogDrawState.Create(True)
		dstate.StoreStates(colors, alpha, blend, viewport, linewidth, texture)
		Return dstate
	End Function
	
	Rem
		bbdoc: Pop the last graphics state from the stack.
		returns: Nothing.
	End Rem
	Function Pop(colors:Int = True, alpha:Int = True, blend:Int = True, viewport:Int = True, linewidth:Int = True, texture:Int = True)
		Local dstate:TProtogDrawState
		
		dstate = GetLastState()
		If dstate <> Null
			dstate.SetStates(colors, alpha, blend, viewport, linewidth, texture)
			dstate.Remove()
		End If
	End Function
	
	Rem
		bbdoc: Get the last state.
		returns: The last drawstate.
		about: This will get the last state that was set.
	End Rem
	Function GetLastState:TProtogDrawState()
		If m_stack.IsEmpty() = False
			Return TProtogDrawState(m_stack.Last())
		End If
		Return Null
	End Function
	
	Rem
		bbdoc: Initiate the default drawing state.
		returns: Nothing.
		about: This should be called after setting your default drawing states (typically this should be called right after you create a graphics context).
	End Rem
	Function InitiateDefaultState()
		m_defaultstate = New TProtogDrawState.Create(False)
		m_defaultstate.StoreFullState()
	End Function
	
End Type

