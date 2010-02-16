
Rem
	event.bmx (Contains: dui_Event, )
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
Type dui_Event
	
	Global m_queue:TListEx = New TListEx
	Global m_nullevent:dui_Event = New dui_Event
	Global m_currentevent:dui_Event = m_nullevent
	
	Field m_link:TLink
	
	Field m_id:Int					' The event id
	Field m_source:dui_Gadget		' Source of the event
	Field m_data:Int				' Numerical data
	Field m_x:Int, m_y:Int			' Positional data
	
	Field m_extra:Object			' Extra object
	
	Method Remove()
		If m_link <> Null
			m_link.Remove()
			m_link = Null
		End If
	End Method
	
	Rem
		bbdoc: Create an event.
		returns: The created event.
		about: NOTE: Calling this method will post the event to the queue.
	End Rem
	Method Create:dui_Event(id:Int, source:dui_Gadget = Null, data:Int = 0, x:Int = 0, y:Int = 0, extra:Object = Null)
		m_id = id
		m_source = source
		m_data = data
		m_x = x
		m_y = y
		m_extra = extra
		Post()
		Return Self
	End Method
	
	Rem
		bbdoc: Post an event to the queue.
		returns: Nothing.
	End Rem
	Method Post()
		If Self <> m_nullevent
			m_link = m_queue.AddLast(Self)
		End If
	End Method
	
	Rem
		bbdoc: Convert the event to a string.
		returns: A string outlining the event type, the source, and the associated data.
	End Rem
	Method ToString:String()
		Local evstr:String, srcstr:String
		
		Select m_id
			Case dui_EVENT_SETSCREEN evstr = "SetScreen"
			Case dui_EVENT_GADGETACTION evstr = "GadgetAction"
			Case dui_EVENT_GADGETSELECT evstr = "GadgetSelect"
			Case dui_EVENT_GADGETOPEN evstr = "GadgetOpen"
			Case dui_EVENT_GADGETCLOSE evstr = "GadgetClose"
			Case dui_EVENT_MOUSEOVER evstr = "MouseOver"
			Default evstr = "Unknown Event: " + m_id
		End Select
		
		If m_source <> Null
			srcstr = m_source.m_name
		Else
			srcstr = "External Source"
		End If
		Return "Event: " + evstr + " Data: " + m_data + " X: " + m_x + " Y: " + m_y + " Source: " + srcstr
	End Method
	
	Rem
		bbdoc: Get the current event.
		returns: The current event.
	End Rem
	Function GetCurrentEvent:dui_Event()
		Return m_currentevent
	End Function
	
	Rem
		bbdoc: Poll the queued events.
		returns: An event id if an event was pulled from the queue, and 0 if there are no more events in the queue.
	End Rem
	Function PollEvent:Int()
		If m_queue.IsEmpty() = False
			' Grab the next event from the queue
			m_currentevent = dui_Event(m_queue.First())
			If m_currentevent = Null
				m_currentevent = m_nullevent
			Else
				m_currentevent.Remove()
			End If
			
			Return m_currentevent.m_id
		Else
			m_currentevent = m_nullevent
			Return 0
		End If
	End Function
	
End Type

