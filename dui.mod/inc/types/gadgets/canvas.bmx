
' 
' canvas.bmx (Contains: dui_TCanvas, )
' 
' 

Rem
	bbdoc: The dui canvas gadget Type.
End Rem
Type dui_TCanvas Extends dui_TGadget
	
	Rem
		bbdoc: The function to be called when the canvas is rendered.
		about: Remember to set drawing states in your function.
	End Rem
	Field fdraw()
	
	Field gBackground:Int = True
	Field gEvents:Int = False
		
		Rem
			bbdoc: Create a canvas.
			returns: The created canvas (itself).
		End Rem
		Method Create:dui_TCanvas(_name:String, _x:Float, _y:Float, _w:Float, _h:Float, _fdraw(), _parent:dui_TGadget, _background:Int = True, _events:Int = False)
			
			PopulateGadget(_name, _x, _y, _w, _h, _parent)
			
			SetDraw(_fdraw)
			SetBackground(_background)
			SetEvents(_events)
			
			Return Self
			
		End Method
		
		Rem
			bbdoc: Render the canvas.
			returns: Nothing.
			about: This will call fdraw() if it has been set.
		End Rem
		Method Render(_x:Float, _y:Float)
			
			If IsVisible() = True And fDraw <> Null
				
				' Store the current graphics state in the stack
				TDrawState.Push()
				
				' Set the viewport and origin
				dui_SetViewport(gX + _x, gY + _y, gW, gH)
				SetOrigin(gX + _x, gY + _y)
				
				' Clear
				If gBackground = True
					SetDrawingState()
					DrawRect(0.0, 0.0, gW, gH)
				End If
				
				' Call the draw function
				fdraw()
				
				' Restore the previous graphics state
				TDrawState.Pop()
				
				Super.Render(_x, _y)
				
			End If
			
		End Method
		
		Rem
			bbdoc: Update the MouseOver state.
			returns: Nothing.
		End Rem
		Method UpdateMouseOver(_x:Int, _y:Int)
			
			TDUIMain.SetCursor(dui_CURSOR_MOUSEOVER)
			
			Super.UpdateMouseOver(_x, _y)
			
		End Method
		
		Rem
			bbdoc: Update the MouseDown state.
			returns: Nothing.
		End Rem
		Method UpdateMouseDown(_x:Int, _y:Int)
			
			TDUIMain.SetCursor(dui_CURSOR_MOUSEDOWN)
			Super.UpdateMouseDown(_x, _y)
			
			If gEvents = True Then New dui_TEvent.Create(dui_EVENT_GADGETACTION, Self, 0, MouseX() - (gX + _x), MouseY() - (gY + _y), Null)
			
		End Method
		
		Rem
			bbdoc: Update the MouseRelease state.
			returns: Nothing.
		End Rem
		Method UpdateMouseRelease(_x:Int, _y:Int)
			
			Super.UpdateMouseRelease(_x, _y)
			
			If gEvents = True Then New dui_TEvent.Create(dui_EVENT_GADGETSELECT, Self, 0, MouseX() - (gX + _x), MouseY() - (gY + _y), Null)
			
		End Method
		
		Rem
			bbdoc: Set background on or off.
			returns: Nothing.
		End Rem
		Method SetBackground(_background:Int)
			
			gBackground = _background
			
		End Method
		
		Rem
			bbdoc: Set the draw function.
			returns: Nothing.
			about: @_fdraw will be called when the canvas is rendered.
		End Rem
		Method SetDraw(_fdraw())
			
			fdraw = _fdraw
			
		End Method
		
		Rem
			bbdoc: Set event generation on or off.
			returns: Nothing.
			about: If set to True, events will be created and queued.
		End Rem
		Method SetEvents(_events:Int)
			
			gEvents = _events
			
		End Method
		
End Type















	