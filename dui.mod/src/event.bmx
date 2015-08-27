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

' Event constants
Const dui_EVENT_SETSCREEN:Int = 1			' Screen changed 

Const dui_EVENT_GADGETACTION:Int = 11		' Gadget Action (general purpose use for when a gadget has few actions) 
Const dui_EVENT_GADGETSELECT:Int = 12		' Gadget Selected (used in more specific cases, e.g. a button click rather than hold) 
Const dui_EVENT_GADGETOPEN:Int = 13			' Gadget opened (combo box, menu) 
Const dui_EVENT_GADGETCLOSE:Int = 14		' Gadget closed 

Const dui_EVENT_MOUSEOVER:Int = 21			' Mouse over a gadget

Rem
	bbdoc: duct ui event.
End Rem
Type duiEvent
	
	Global m_queue:TListEx = New TListEx
	Global m_nullevent:duiEvent = New duiEvent
	Global m_currentevent:duiEvent = m_nullevent
	
	Field m_link:TLink
	
	Field m_id:Int					' The event id
	Field m_source:duiGadget		' Source of the event
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
		returns: Itself.
		about: NOTE: Calling this method will post the event to the queue.
	End Rem
	Method Create:duiEvent(id:Int, source:duiGadget = Null, data:Int = 0, x:Int = 0, y:Int = 0, extra:Object = Null)
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
		If m_source
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
	Function GetCurrentEvent:duiEvent()
		Return m_currentevent
	End Function
	
	Rem
		bbdoc: Poll the queued events.
		returns: An event id if an event was pulled from the queue, and 0 if there are no more events in the queue.
	End Rem
	Function PollEvent:Int()
		If Not m_queue.IsEmpty()
			' Grab the next event from the queue
			m_currentevent = duiEvent(m_queue.First())
			If Not m_currentevent
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

