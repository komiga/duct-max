
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
	
	drawstate.bmx (Contains: TDrawState, )
	
End Rem

SuperStrict

Rem
bbdoc: Drawstate (Push, Pop stack) module.
End Rem
Module duct.drawstate

ModuleInfo "Version: 0.39"
ModuleInfo "Copyright: Tim Howard"
ModuleInfo "License: MIT"

ModuleInfo "History: Version 0.39"
ModuleInfo "History: Another cleanup"
ModuleInfo "History: Version 0.38"
ModuleInfo "History: General code cleanup"
ModuleInfo "History: Version 0.37"
ModuleInfo "History: Changed layout, all states now have Store and Set methods"
ModuleInfo "History: TDrawState changed to be a stack"
ModuleInfo "History: TDrawState updated to store the viewport, font and linewidth"
ModuleInfo "History: Corrected usage of syntax (in Returns, Cases, News and Selects)"
ModuleInfo "History: Version 0.36"
ModuleInfo "History: Initial release."

' Used modules
Import brl.max2d


Rem
	bbdoc: Drawstate holder.
End Rem
Type TDrawState
	
	Rem
		bbdoc: The default draw state.
		about: This needs be initiated after the graphics window is setup (TDrawState.InitiateDefaultState()).
	End Rem
	Global m_defaultstate:TDrawState
	
	'Global laststate:TDrawState
	Global m_stack:TList = New TList
	
	Field m_link:TLink
	
	Field ds_blend:Int
	Field ds_alpha:Float
	
	Field ds_color_red:Int, ds_color_green:Int, ds_color_blue:Int
	Field ds_clscolor_red:Int, ds_clscolor_green:Int, ds_clscolor_blue:Int
	Field ds_maskcolor_red:Int, ds_maskcolor_green:Int, ds_maskcolor_blue:Int
	
	Field ds_handle_x:Float, ds_handle_y:Float, ds_origin_x:Float, ds_origin_y:Float
	Field ds_rotation:Float, ds_scale_x:Float, ds_scale_y:Float
	
	Field ds_linewidth:Float
	
	Field ds_font:TImageFont
	
	Field ds_vp_x:Int, ds_xp_y:Int, ds_vp_w:Int, ds_vp_h:Int
	
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
	Method Create:TDrawState(addstack:Int = True)
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
	Method StoreStates(_colors:Int = True, _transform:Int = True, _font:Int = True, _alpha:Int = True, _blend:Int = True, _viewport:Int = False, _offsets:Int = False, _line_width:Int = False)
		If _colors = True Then StoreAllColorsState()
		If _transform = True Then StoreTransformState()
		
		If _font = True Then StoreFontState()
		
		If _alpha = True Then StoreAlphaState()
		If _blend = True Then StoreBlendState()
		
		If _viewport = True Then StoreViewPortState()
		
		If _offsets = True Then StoreOffsetsState()
		If _line_width = True Then StoreLineWidthState()
	End Method
	
	Rem
		bbdoc: Store the whole current drawing state.
		returns: Nothing.
		about: This will save the whole drawing state into the object.
	End Rem
	Method StoreFullState()
		StoreStates(True, True, True, True, True, True, True, True)
	End Method
	
	Rem
		bbdoc: Store the viewport state.
		returns: Nothing.
	End Rem
	Method StoreViewportState()
		GetViewport(ds_vp_x, ds_xp_y, ds_vp_w, ds_vp_h)
	End Method
	
	Rem
		bbdoc: Store the color state.
		returns: Nothing.
	End Rem
	Method StoreColorState()
		GetColor(ds_color_red, ds_color_green, ds_color_blue)
	End Method
	
	Rem
		bbdoc: Store the clearscreen color state.
		returns: Nothing.
	End Rem
	Method StoreClsColorState()
		GetClsColor(ds_clscolor_red, ds_clscolor_green, ds_clscolor_blue)
	End Method
	
	Rem
		bbdoc: Store the mask color state.
		returns: Nothing.
	End Rem
	Method StoreMaskcolorState()
		GetMaskColor(ds_maskcolor_red, ds_maskcolor_green, ds_maskcolor_blue)
	End Method
	
	Rem
		bbdoc: Store all color (standard, cls and mask) states.
		returns: Nothing.
	End Rem
	Method StoreAllColorsState()
		StoreColorState()
		StoreClsColorState()
		StoreMaskColorState()
	End Method
	
	Rem
		bbdoc: Store the text color state.
		returns: Nothing.
	End Rem
	Method StoreBlendState()
		ds_blend = GetBlend()
	End Method
	
	Rem
		bbdoc: Store the alpha state.
		returns: Nothing.
	End Rem
	Method StoreAlphaState()
		ds_alpha = GetAlpha()
	End Method
	
	Rem
		bbdoc: Store the origin state.
		returns: Nothing.
	End Rem
	Method StoreOriginState()
		GetOrigin(ds_origin_x, ds_origin_y)
	End Method
	
	Rem
		bbdoc: Store the handle state.
		returns: Nothing.
	End Rem
	Method StoreHandleState()
		GetHandle(ds_handle_x, ds_handle_y)
	End Method
	
	Rem
		bbdoc: Store the offset (origin and handle) states.
		returns: Nothing.
	End Rem
	Method StoreOffsetsState()
		StoreOriginState()
		StoreHandleState()
	End Method
	
	Rem
		bbdoc: Store the rotation state.
		returns: Nothing.
	End Rem
	Method StoreRotationState()
		ds_rotation = GetRotation()
	End Method
	
	Rem
		bbdoc: Store the scale state.
		returns: Nothing.
	End Rem
	Method StoreScaleState()
		GetScale(ds_scale_x, ds_scale_y)
	End Method
	
	Rem
		bbdoc: Store the transform (rotation and scale) states.
		returns: Nothing.
	End Rem
	Method StoreTransformState()
		StoreRotationState()
		StoreScaleState()
	End Method
	
	Rem
		bbdoc: Store the font state.
		returns: Nothing.
	End Rem
	Method StoreFontState()
		ds_font = GetImageFont()
	End Method
	
	Rem
		bbdoc: Store the line width state.
		returns: Nothing.
	End Rem
	Method StoreLineWidthState()
		ds_linewidth = GetLineWidth()
	End Method
	
'#end region (Store/Push states)
	
'#region Set/Pop states
	
	Rem
		bbdoc: Set the draw state.
		returns: Nothing.
		about: This will set (or 'reinstate'/'pop') the current draw state.
	End Rem
	Method SetStates(_colors:Int = True, _transform:Int = True, _font:Int = True, _alpha:Int = True, _blend:Int = True, _viewport:Int = False, _offsets:Int = False, _line_width:Int = False)
		If _colors = True Then SetAllColorsState()
		If _transform = True Then SetTransformState()
		
		If _font = True Then SetFontState()
		
		If _alpha = True Then SetAlphaState()
		If _blend = True Then SetBlendState()
		
		If _viewport = True Then SetViewPortState()
		
		If _offsets = True Then SetOffsetsState()
		If _line_width = True Then SetLineWidthState()
	End Method
	
	Rem
		bbdoc: Set the draw state.
		returns: Nothing.
		about: This will set (or 'reinstate'/'pop') the current draw state.
	End Rem
	Method SetFullState()
		SetStates(True, True, True, True, True, True, True, True)
	End Method
	
	Rem
		bbdoc: Set ('pop') the viewport state.
		returns: Nothing.
	End Rem
	Method SetViewportState()
		SetViewport(ds_vp_x, ds_xp_y, ds_vp_w, ds_vp_h)
	End Method
	
	Rem
		bbdoc: Set ('pop') the color state.
		returns: Nothing.
	End Rem
	Method SetColorState()
		SetColor(ds_color_red, ds_color_green, ds_color_blue)
	End Method
	
	Rem
		bbdoc: Set ('pop') the clearscreen color state.
		returns: Nothing.
	End Rem
	Method SetClsColorState()
		SetClsColor(ds_clscolor_red, ds_clscolor_green, ds_clscolor_blue)
	End Method
	
	Rem
		bbdoc: Set ('pop') the mask color state.
		returns: Nothing.
	End Rem
	Method SetMaskColorState()
		SetMaskColor(ds_maskcolor_red, ds_maskcolor_green, ds_maskcolor_blue)
	End Method
	
	Rem
		bbdoc: Set ('pop') all the color (standard, cls and mask) states.
		returns: Nothing.
	End Rem
	Method SetAllColorsState()
		SetColorState()
		SetClsColorState()
		SetMaskColorState()
	End Method
	
	Rem
		bbdoc: Set ('pop') the blend state.
		returns: Nothing.
	End Rem
	Method SetBlendState()
		SetBlend(ds_blend)
	End Method
	
	Rem
		bbdoc: Set ('pop') the alpha state.
		returns: Nothing.
	End Rem
	Method SetAlphaState()
		SetAlpha(ds_alpha)
	End Method
	
	Rem
		bbdoc: Set ('pop') the origin state.
		returns: Nothing.
	End Rem
	Method SetOriginState()
		SetOrigin(ds_origin_x, ds_origin_y)
	End Method
	
	Rem
		bbdoc: Set ('pop') the handle state.
		returns: Nothing.
	End Rem
	Method SetHandleState()
		SetHandle(ds_handle_x, ds_handle_y)
	End Method
	
	Rem
		bbdoc: Set ('pop') the offset (origin and handle) states.
		returns: Nothing.
	End Rem
	Method SetOffsetsState()
		SetOriginState()
		SetHandleState()
	End Method
	
	Rem
		bbdoc: Set ('pop') the rotation state.
		returns: Nothing.
	End Rem
	Method SetRotationState()
		SetRotation(ds_rotation)
	End Method
	
	Rem
		bbdoc: Set ('pop') the scale state.
		returns: Nothing.
	End Rem
	Method SetScaleState()
		SetScale(ds_scale_x, ds_scale_y)
	End Method
	
	Rem
		bbdoc: Set ('pop') the transform (rotation and scale) states.
		returns: Nothing.
	End Rem
	Method SetTransformState()
		SetTransform(ds_rotation, ds_scale_x, ds_scale_y)
	End Method
	
	Rem
		bbdoc: Set ('pop') the font state.
		returns: Nothing.
	End Rem
	Method SetFontState()
		SetImageFont(ds_font)
	End Method
	
	Rem
		bbdoc: Set ('pop') the line width state.
		returns: Nothing.
	End Rem
	Method SetLineWidthState()
		SetLineWidth(ds_linewidth)
	End Method
	
'#end region (Set/Pop states)
	
	Rem
		bbdoc: Push the current graphics state on to the stack.
		returns: The pushed state (for consistency).
	End Rem
	Function Push:TDrawState(_colors:Int = True, _transform:Int = True, _font:Int = True, _alpha:Int = True, _blend:Int = True, _viewport:Int = True, _offsets:Int = True, _line_width:Int = True)
		Local dstate:TDrawState
		
		dstate = New TDrawState.Create(True)
		dstate.StoreStates(_colors, _transform, _font, _alpha, _blend, _viewport, _offsets, _line_width)
		Return dstate
	End Function
	
	Rem
		bbdoc: Pop the last graphics state from the stack.
		returns: Nothing.
	End Rem
	Function Pop(_colors:Int = True, _transform:Int = True, _font:Int = True, _alpha:Int = True, _blend:Int = True, _viewport:Int = True, _offsets:Int = True, _line_width:Int = True)
		Local dstate:TDrawState
		
		dstate = GetLastState()
		If dstate <> Null
			dstate.SetStates(_colors, _transform, _font, _alpha, _blend, _viewport, _offsets, _line_width)
			dstate.Remove()
		End If
	End Function
	
	Rem
		bbdoc: Initiate the default drawing state.
		returns: Nothing.
		about: This should be called after setting your default drawing states (typically this should be called right after you create a graphics context).
	End Rem
	Function InitiateDefaultState()
		m_defaultstate = New TDrawState.Create(False)
		m_defaultstate.StoreFullState()
	End Function
		
	Rem
		bbdoc: Get the last state.
		returns: The last drawstate.
		about: This will get the last state that was set.
	End Rem
	Function GetLastState:TDrawState()
		If m_stack.IsEmpty() = False
			Return TDrawState(m_stack.Last())
		End If
		Return Null
	End Function
	
End Type








