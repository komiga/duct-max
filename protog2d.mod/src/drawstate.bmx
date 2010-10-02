
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
	bbdoc: Protog2D drawstate.
End Rem
Type dProtogDrawState
	
	Rem
		bbdoc: The default draw state.
		about: This needs be initialized after the graphics window is setup (see #InitDefaultState).
	End Rem
	Global m_defaultstate:dProtogDrawState
	Global m_stack:TListEx = New TListEx
	
	Field m_link:TLink
	
	Field m_blend:Int, m_alpha:Float
	Field m_color:dProtogColor, m_clscolor:dProtogColor
	Field m_viewportpos:dVec2, m_viewportsize:dVec2
	Field m_linewidth:Float
	Field m_texture:dGLTexture
	
	Method Delete()
		Remove()
	End Method
	
	Rem
		bbdoc: Add the state to the stack.
		returns: Nothing.
	End Rem
	Method AddToStack()
		If Not m_link
			m_link = m_stack.AddLast(Self)
		End If
	End Method
	
	Rem
		bbdoc: Remove the draw state from the stack.
		returns: Nothing.
	End Rem
	Method Remove()
		If m_link
			m_link.Remove()
			m_link = Null
		End If
	End Method
	
	Rem
		bbdoc: Create a draw state.
		returns: Itself.
		about: If @addstack is False, the draw state will not be added to the stack.
	End Rem
	Method Create:dProtogDrawState(addstack:Int = True)
		If addstack
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
		If colors Then StoreAllColorStates()
		If alpha Then StoreAlphaState()
		If blend Then StoreBlendState()
		If viewport Then StoreViewPortState()
		If linewidth Then StoreLineWidthState()
		If texture Then StoreTextureState()
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
		m_viewportpos = dProtog2DDriver.GetViewportPosition().Copy()
		m_viewportsize = dProtog2DDriver.GetViewportSize().Copy()
	End Method
	
	Rem
		bbdoc: Store the color state.
		returns: Nothing.
	End Rem
	Method StoreColorState()
		m_color = dProtog2DDriver.GetBoundColor().Copy()
	End Method
	
	Rem
		bbdoc: Store the clearscreen color state.
		returns: Nothing.
	End Rem
	Method StoreClsColorState()
		m_clscolor = dProtog2DDriver.GetClsColor().Copy()
	End Method
	
	Rem
		bbdoc: Store all color (standard, cls) states.
		returns: Nothing.
	End Rem
	Method StoreAllColorStates()
		StoreColorState()
		StoreClsColorState()
	End Method
	
	Rem
		bbdoc: Store the text color state.
		returns: Nothing.
	End Rem
	Method StoreBlendState()
		m_blend = dProtog2DDriver.GetBlend()
	End Method
	
	Rem
		bbdoc: Store the alpha state.
		returns: Nothing.
	End Rem
	Method StoreAlphaState()
		m_alpha = dProtog2DDriver.GetAlpha()
	End Method
	
	Rem
		bbdoc: Store the line width state.
		returns: Nothing.
	End Rem
	Method StoreLineWidthState()
		m_linewidth = dProtog2DDriver.GetLineWidth()
	End Method
	
	Rem
		bbdoc: Store the active (bound) texture.
		returns: Nothing.
	End Rem
	Method StoreTextureState()
		m_texture = dProtog2DDriver.GetActiveTexture()
	End Method
	
'#end region Store/Push states
	
'#region Set/Pop states
	
	Rem
		bbdoc: Set the active draw state (set the driver's states; to store the draw state, see #StoreStates).
		returns: Nothing.
		about: This will set (or 'reinstate'/'pop') the current draw state.
	End Rem
	Method SetStates(colors:Int = True, alpha:Int = True, blend:Int = True, viewport:Int = False, linewidth:Int = False, texture:Int = False)
		If colors Then SetAllColorStates()
		If alpha Then SetAlphaState()
		If blend Then SetBlendState()
		If viewport Then SetViewPortState()
		If linewidth Then SetLineWidthState()
		If texture Then SetTextureState()
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
		dProtog2DDriver.SetViewportParams(m_viewportpos.m_x, m_viewportpos.m_y, m_viewportsize.m_x, m_viewportsize.m_y)
	End Method
	
	Rem
		bbdoc: Set ('pop') the color state.
		returns: Nothing.
	End Rem
	Method SetColorState()
		If m_color
			dProtog2DDriver.BindPColor(m_color)
		End If
	End Method
	
	Rem
		bbdoc: Set ('pop') the clearscreen color state.
		returns: Nothing.
	End Rem
	Method SetClsColorState()
		If m_clscolor
			dProtog2DDriver.SetClsColor(m_clscolor)
		End If
	End Method
	
	Rem
		bbdoc: Set ('pop') all the color (standard, cls) states.
		returns: Nothing.
	End Rem
	Method SetAllColorStates()
		SetColorState()
		SetClsColorState()
	End Method
	
	Rem
		bbdoc: Set ('pop') the blend state.
		returns: Nothing.
	End Rem
	Method SetBlendState()
		dProtog2DDriver.SetBlend(m_blend)
	End Method
	
	Rem
		bbdoc: Set ('pop') the alpha state.
		returns: Nothing.
	End Rem
	Method SetAlphaState()
		dProtog2DDriver.SetAlpha(m_alpha)
	End Method
	
	Rem
		bbdoc: Set ('pop') the line width state.
		returns: Nothing.
	End Rem
	Method SetLineWidthState()
		dProtog2DDriver.SetLineWidth(m_linewidth)
	End Method
	
	Rem
		bbdoc: Set ('pop') the line width state.
		returns: Nothing.
	End Rem
	Method SetTextureState()
		If m_texture
			dProtog2DDriver.UnbindActiveTexture()
			dProtog2DDriver.BindTexture(m_texture)
		End If
	End Method
	
'#end region Set/Pop states
	
	Rem
		bbdoc: Push the current graphics state onto the stack.
		returns: The pushed state (for consistency).
	End Rem
	Function Push:dProtogDrawState(colors:Int = True, alpha:Int = True, blend:Int = True, viewport:Int = True, linewidth:Int = True, texture:Int = True)
		Local dstate:dProtogDrawState = New dProtogDrawState.Create(True)
		dstate.StoreStates(colors, alpha, blend, viewport, linewidth, texture)
		Return dstate
	End Function
	
	Rem
		bbdoc: Pop the last graphics state from the stack.
		returns: Nothing.
	End Rem
	Function Pop(colors:Int = True, alpha:Int = True, blend:Int = True, viewport:Int = True, linewidth:Int = True, texture:Int = True)
		Local dstate:dProtogDrawState = GetLastState()
		If dstate
			dstate.SetStates(colors, alpha, blend, viewport, linewidth, texture)
			dstate.Remove()
		End If
	End Function
	
	Rem
		bbdoc: Get the last state.
		returns: The last drawstate.
		about: This will get the last state that was set.
	End Rem
	Function GetLastState:dProtogDrawState()
		If Not m_stack.IsEmpty()
			Return dProtogDrawState(m_stack.Last())
		End If
		Return Null
	End Function
	
	Rem
		bbdoc: Initialize the default draw state.
		returns: Nothing.
		about: This should be called after setting your default drawing states (typically this should be called right after you create a graphics context).
	End Rem
	Function InitDefaultState()
		m_defaultstate = New dProtogDrawState.Create(False)
		m_defaultstate.StoreFullState()
	End Function
	
	Rem
		bbdoc: Get the default draw state.
		returns: The default draw state (which is probably Null if you haven't called #InitiateDefaultState).
	End Rem
	Function GetDefaultState:dProtogDrawState()
		Return m_defaultstate
	End Function
	
	Rem
		bbdoc: Set the default draw state as the active draw state.
		returns: Nothing.
		about: NOTE: An assertion will fail if the default state has not been initialized.
	End Rem
	Function SetDefaultStates(colors:Int = True, alpha:Int = True, blend:Int = True, viewport:Int = False, linewidth:Int = False, texture:Int = False)
		Assert m_defaultstate, "(dProtogDrawState.SetDefaultState) Default draw state is not initialized"
		m_defaultstate.SetStates(colors, alpha, blend, viewport, linewidth, texture)
	End Function
	
	Rem
		bbdoc: Store the active draw state as the default draw state.
		returns: Nothing.
		about: NOTE: An assertion will fail if the default state has not been initialized.
	End Rem
	Function StoreDefaultStates(colors:Int = True, alpha:Int = True, blend:Int = True, viewport:Int = False, linewidth:Int = False, texture:Int = False)
		Assert m_defaultstate, "(dProtogDrawState.StoreDefaultState) Default draw state is not initialized"
		m_defaultstate.StoreStates(colors, alpha, blend, viewport, linewidth, texture)
	End Function
	
End Type

