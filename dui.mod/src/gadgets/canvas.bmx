
Rem
Copyright (c) 2010 plash <plash@komiga.com>

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
	bbdoc: duct ui canvas gadget.
End Rem
Type duiCanvas Extends duiGadget
	
	Field m_background:Int = True
	Field m_events:Int = False
	
	Field m_rendercallback(x:Float, y:Float, canvas:duiCanvas)
	
	Rem
		bbdoc: Create a canvas.
		returns: Itself.
	End Rem
	Method Create:duiCanvas(name:String, x:Float, y:Float, w:Float, h:Float, parent:duiGadget, background:Int = True, events:Int = False)
		_Init(name, x, y, w, h, parent, False)
		SetBackground(background)
		SetEvents(events)
		Return Self
	End Method
	
'#region Render & update methods
	
	Rem
		bbdoc: Render the canvas.
		returns: Nothing.
		about: This will call the render callback if it has been set and the #OnRender method.
	End Rem
	Method Render(x:Float, y:Float)
		If IsVisible()
			Local relx:Float = m_x + x
			Local rely:Float = m_y + y
			dProtogDrawState.Push()
			dui_SetViewport(relx, rely, m_width, m_height)
			If m_background
				BindRenderingState()
				dProtogPrimitives.RenderRectangleToSize(relx, rely, m_width, m_height, True)
			End If
			If m_rendercallback
				m_rendercallback(relx, rely, Self)
			End If
			OnRender(relx, rely)
			dProtogDrawState.Pop()
			Super.Render(x, y)
		End If
	End Method
	
	Rem
		bbdoc: Update the MouseOver state.
		returns: Nothing.
	End Rem
	Method UpdateMouseOver(x:Int, y:Int)
		duiMain.SetCursor(dui_CURSOR_MOUSEOVER)
		Super.UpdateMouseOver(x, y)
	End Method
	
	Rem
		bbdoc: Update the MouseDown state.
		returns: Nothing.
	End Rem
	Method UpdateMouseDown(x:Int, y:Int)
		duiMain.SetCursor(dui_CURSOR_MOUSEDOWN)
		Super.UpdateMouseDown(x, y)
		If m_events
			New duiEvent.Create(dui_EVENT_GADGETACTION, Self, 0, MouseX() - (m_x + x), MouseY() - (m_y + y), Null)
		End If
	End Method
	
	Rem
		bbdoc: Update the MouseRelease state.
		returns: Nothing.
	End Rem
	Method UpdateMouseRelease(x:Int, y:Int)
		Super.UpdateMouseRelease(x, y)
		If m_events
			New duiEvent.Create(dui_EVENT_GADGETSELECT, Self, 0, MouseX() - (m_x + x), MouseY() - (m_y + y), Null)
		End If
	End Method
	
'#end region Render & update methods
	
'#region Field accessors
	
	Rem
		bbdoc: Set background on or off.
		returns: Nothing.
	End Rem
	Method SetBackground(background:Int)
		m_background = background
	End Method
	Rem
		bbdoc: Get the background rendering state (on/off).
		returns: True if the background rendering is on, or False if it is off.
	End Rem
	Method GetBackground:Int()
		Return m_background
	End Method
	
	Rem
		bbdoc: Set the render callback function.
		returns: Nothing.
		about: You can set the callback or extend this type and the #OnRender method to get access to the canvas rendering.
	End Rem
	Method SetRenderCallback(callback(x:Float, y:Float, canvas:duiCanvas))
		m_rendercallback = callback
	End Method
	Rem
		bbdoc: Get the render callback.
		returns: The canvas' render callback (might be Null).
	End Rem
	Method GetRenderCallback(x:Float, y:Float, canvas:duiCanvas) ()
		Return m_rendercallback
	End Method
	
	Rem
		bbdoc: Set event generation on or off.
		returns: Nothing.
		about: If set to True, events will be created and queued.
	End Rem
	Method SetEvents(events:Int)
		m_events = events
	End Method
	Rem
		bbdoc: Get the events on/off state.
		returns: True if events are on, or False if they are off.
	End Rem
	Method GetEvents:Int()
		Return m_events
	End Method
	
'#end region Field accessors
	
	Rem
		bbdoc: The OnRender method.
		returns: Nothing.
		about: NOTE: This method gets called (as does the callback - see #SetRenderCallback) when the canvas is rendered.
	End Rem
	Method OnRender(relx:Float, rely:Float)
	End Method
	
End Type

