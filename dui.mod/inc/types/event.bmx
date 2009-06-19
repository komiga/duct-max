
Rem
	event.bmx (Contains: dui_TEvent, )
End Rem

' Event constants
Const dui_EVENT_SETSCREEN:Int = 1			' Screen changed 

Const dui_EVENT_GADGETACTION:Int = 11		' Gadget Action (general purpose use for when a gadget has few actions) 
Const dui_EVENT_GADGETSELECT:Int = 12		' Gadget Selected (used in more specific cases, e.g. a button click rather than hold) 
Const dui_EVENT_GADGETOPEN:Int = 13			' Gadget opened (combo box, menu) 
Const dui_EVENT_GADGETCLOSE:Int = 14		' Gadget closed 

Const dui_EVENT_MOUSEOVER:Int = 21			' Mouse over a gadget

Rem
	bbdoc: The dui event type.
End Rem
Type dui_TEvent
	
	Global _queue:TList = New TList
	Global _nullevent:dui_TEvent = New dui_TEvent
	Global _currentevent:dui_TEvent = _nullevent
	
	Field _link:TLink
	
	Field id:Int					' The event id
	Field source:dui_TGadget		' Source of the event
	Field data:Int					' Numerical data
	Field x:Int, y:Int				' Positional data
	
	Field extra:Object				' Extra object
	
		Method Remove()
			
			If _link <> Null
				_link.Remove()
				_link = Null
			End If
			
		End Method
		
		Rem
			bbdoc: Create an event.
			returns: The created event.
			about: NOTE: Calling this method will post the event to the queue.
		End Rem
		Method Create:dui_TEvent(_id:Int, _source:dui_TGadget = Null, _data:Int = 0, _x:Int = 0, _y:Int = 0, _extra:Object = Null)
			
			id = _id
			source = _source
			data = _data
			x = _x
			y = _y
			extra = _extra
			
			Post()
			
			Return Self
			
		End Method
		
		Rem
			bbdoc: Post an event to the queue.
			returns: Nothing.
		End Rem
		Method Post()
			
			If Self <> _nullevent Then _link = _queue.AddLast(Self)
			
		End Method
		
		Rem
			bbdoc: Convert the event to a string.
			returns: A string outlining the event type, the source, and the associated data.
		End Rem
		Method ToString:String()
			
			Local evstr:String, srcstr:String
			
			Select id
				
				Case dui_EVENT_SETSCREEN evstr = "SetScreen"
				Case dui_EVENT_GADGETACTION evstr = "GadgetAction"
				Case dui_EVENT_GADGETSELECT evstr = "GadgetSelect"
				Case dui_EVENT_GADGETOPEN evstr = "GadgetOpen"
				Case dui_EVENT_GADGETCLOSE evstr = "GadgetClose"
				Case dui_EVENT_MOUSEOVER evstr = "MouseOver"
				
				Default evstr = "Unknown Event: " + id
				
			End Select
			
			If source <> Null
				srcstr = source.gName
			Else
				srcstr = "External Source"
			End If
			
			Return "Event: " + evstr + " Data: " + data + " X: " + x + " Y: " + y + " Source: " + srcstr
			
		End Method
		
		Rem
			bbdoc: Get the current event.
			returns: The current event.
		End Rem
		Function GetCurrentEvent:dui_TEvent()
			
			Return _currentevent
			
		End Function
		
		Rem
			bbdoc: Poll the queued events.
			returns: An event id if an event was pulled from the queue, and 0 if there are no more events in the queue.
		End Rem
		Function PollEvent:Int()
			
			If _queue.IsEmpty() = False
				
				' Grab the next event from the queue
				_currentevent = dui_TEvent(_queue.First())
				If _currentevent = Null
					_currentevent = _nullevent
				Else
					_currentevent.Remove()
				End If
				
				Return _currentevent.id
				
			Else
				
				_currentevent = _nullevent
				Return 0
				
			End If
			
		End Function
		
End Type




























