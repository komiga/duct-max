
Rem
	canvas.bmx (Contains: dui_Canvas, )
End Rem

Rem
	bbdoc: The dui canvas gadget type.
End Rem
Type dui_Canvas Extends dui_Gadget
	
	Field m_background:Int = True
	Field m_events:Int = False
	
	Field m_rendercallback(x:Float, y:Float, canvas:dui_Canvas)
	
	Rem
		bbdoc: Create a canvas.
		returns: The new canvas (itself).
	End Rem
	Method Create:dui_Canvas(name:String, x:Float, y:Float, w:Float, h:Float, parent:dui_Gadget, background:Int = True, events:Int = False)
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
		If IsVisible() = True
			TProtogDrawState.Push()
			dui_SetViewport(m_x + x, m_y + y, m_width, m_height)
			
			If m_background = True
				BindDrawingState()
				TProtogPrimitives.DrawRectangleToSize(m_x + x, m_y + y, m_width, m_height, True)
			End If
			
			If m_rendercallback <> Null
				m_rendercallback(m_x + x, m_y + y, Self)
			End If
			OnRender(m_x + x, m_y + y)
			TProtogDrawState.Pop()
			Super.Render(x, y)
		End If
	End Method
	
	Rem
		bbdoc: Update the MouseOver state.
		returns: Nothing.
	End Rem
	Method UpdateMouseOver(x:Int, y:Int)
		TDUIMain.SetCursor(dui_CURSOR_MOUSEOVER)
		Super.UpdateMouseOver(x, y)
	End Method
	
	Rem
		bbdoc: Update the MouseDown state.
		returns: Nothing.
	End Rem
	Method UpdateMouseDown(x:Int, y:Int)
		TDUIMain.SetCursor(dui_CURSOR_MOUSEDOWN)
		Super.UpdateMouseDown(x, y)
		
		If m_events = True
			New dui_Event.Create(dui_EVENT_GADGETACTION, Self, 0, MouseX() - (m_x + x), MouseY() - (m_y + y), Null)
		End If
	End Method
	
	Rem
		bbdoc: Update the MouseRelease state.
		returns: Nothing.
	End Rem
	Method UpdateMouseRelease(x:Int, y:Int)
		Super.UpdateMouseRelease(x, y)
		
		If m_events = True
			New dui_Event.Create(dui_EVENT_GADGETSELECT, Self, 0, MouseX() - (m_x + x), MouseY() - (m_y + y), Null)
		End If
	End Method
	
'#end region (Render & update methods)
	
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
	Method SetRenderCallback(callback(x:Float, y:Float, canvas:dui_Canvas))
		m_rendercallback = callback
	End Method
	Rem
		bbdoc: Get the render callback.
		returns: The canvas' render callback (might be Null).
	End Rem
	Method GetRenderCallback(x:Float, y:Float, canvas:dui_Canvas) ()
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
	
'#end region (Field accessors)
	
	Rem
		bbdoc: The OnRender callback method.
		returns: Nothing.
		about: Extend this!
	End Rem
	Method OnRender(relx:Float, rely:Float)
	End Method
	
End Type

