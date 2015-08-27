
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

SuperStrict

Rem
bbdoc: Reflective networking module
End Rem
Module duct.reflectivenetwork

ModuleInfo "Version: 0.2"
ModuleInfo "Copyright: plash <plash@komiga.com>"
ModuleInfo "License: MIT"

ModuleInfo "History: Version 0.2"
ModuleInfo "History: General cleanup"
ModuleInfo "History: Updated for duct.objectmap changes"
ModuleInfo "History: dReflNetMessageMap.HandleMessage now clears the argument array after a method call"
ModuleInfo "History: Version 0.1"
ModuleInfo "History: Initial release"

Import brl.reflection

Import duct.network
Import duct.objectmap

Rem
	bbdoc: duct reflective dNetMessage map.
End Rem
Type dReflNetMessageMap Extends dNetMessageMap
	
	Global m_callargs:Object[1]
	
	Field m_handlers:dObjectMap = New dObjectMap
	
	Rem
		bbdoc: Create a reflective message map.
		returns: Itself.
	End Rem
	Method Create:dReflNetMessageMap()
		Return Self
	End Method
	
	Rem
		bbdoc: Initialize the fields and message handlers for the same object.
		returns: Nothing.
	End Rem
	Method Initialize(obj:Object)
		InitializeFields(obj)
		AttachHandlers(TTypeId.ForObject(obj))
	End Method
	
	Rem
		bbdoc: Initialize the fields.
		returns: Nothing.
		about: If 'create' is in the metadata for a field, it will be instantiated. If 'insert' is in the metadata for a field, it will be inserted (if it is derived from #dNetMessage).<br>
		If @class is non-Null, only fields with 'class' in the metadata equal to @class will be initialized.
	End Rem
	Method InitializeFields(obj:Object, class:String = Null)
		If obj
			Local tid:TTypeId = TTypeId.ForObject(obj)
			For Local fld:TField = EachIn tid.EnumFields()
				If fld._meta.Length > 0
					If Not class Or fld.MetaData("class") = class
						If fld.MetaData("create")
							If Not fld.Get(obj)
								fld.Set(obj, fld.TypeId().NewObject())
								?Debug
								Local msg:dNetMessage = dNetMessage(fld.Get(obj))
								If msg
									If msg.GetID() = 0 Then DebugLog("(dReflNetMessageMap.Initialize) Field '" + fld.Name() + "' has no message id! (it should be set in the New method)")
								End If
								?
							Else
								?Debug
								DebugLog("(dReflNetMessageMap.Initialize) Field '" + fld.Name() + "' was already assigned")
								?
							End If
						End If
						If fld.MetaData("insert")
							Local msg:dNetMessage = dNetMessage(fld.Get(obj))
							If msg
								InsertMessage(msg)
							Else
								RuntimeError("(dReflNetMessageMap.Initialize) Field '" + fld.Name() + "' has either not been assigned or is not of the dNetMessage type")
							End If
						End If
					End If
				End If
			Next
		End If
	End Method
	
	Rem
		bbdoc: Attach the message handlers from the given object.
		returns: Nothing.
		about: Message handler methods must have this signature (class is optional): MethodName(MessageType) {class="someclass" handle="MessageType"}<br>
		If @class is non-Null, only methods with 'class' in the metadata equal to @class will be attached (as above).
	End Rem
	Method AttachHandlers(tid:TTypeId, class:String = Null)
		m_handlers.Clear()
		If tid
			For Local meth:TMethod = EachIn tid.EnumMethods()
				If meth._meta.Length > 0
					If Not class Or meth.MetaData("class") = class
						Local handle:String = meth.MetaData("handle")
						If handle
							If TTypeId.ForName(handle)
								If meth._argTypes.Length = 1
									m_handlers._Insert(tid.Name() + "#" + handle, meth)
								Else
									RuntimeError("(dReflNetMessageMap.AttachHandlers) Incorrect signature for method '" + meth.Name() + "' in type '" + tid.Name() + "'")
								End If
							Else
								RuntimeError("(dReflNetMessageMap.AttachHandlers) Type '" + handle + "' does not exist - check method '" + meth.Name() + "' in type '" + tid.Name() + "'")
							End If
						End If
					End If
				End If
			Next
		End If
	End Method
	
	Rem
		bbdoc: Handle the given message (calls an attached handler, if any).
		returns: True if the message was handled, or False if it was not.
	End Rem
	Method HandleMessage:Int(obj:Object, msg:dNetMessage)
		Local objtid:TTypeId = TTypeId.ForObject(obj)
		Local tid:TTypeId = TTypeId.ForObject(msg)
		Local meth:TMethod = TMethod(m_handlers._ObjectWithKey(objtid.Name() + "#" + tid.Name()))
		If meth And obj
			m_callargs[0] = msg
			meth.Invoke(obj, m_callargs)
			m_callargs[0] = Null
			Return True
		End If
		Return False
	End Method
	
	Rem
		bbdoc: Get a report of all the messages and their IDs.
		returns: A string containing a list of the map's messages.
	End Rem
	Method Report:String()
		Local build:String
		For Local msg:dNetMessage = EachIn m_map
			build:+ TTypeId.ForObject(msg).Name() + ": " + msg.m_id + "~n"
		Next
		Return build[..build.Length - 1]
	End Method
	
	Rem
		bbdoc: Get a report of all the messages and their IDs from the given object.
		returns: A string containing a list of the object's messages (from fields).
	End Rem
	Function ReportFields:String(obj:Object)
		Local tid:TTypeId = TTypeId.ForObject(obj)
		If tid
			Local build:String, msg:dNetMessage
			For Local fld:TField = EachIn tid.EnumFields()
				msg = dNetMessage(fld.Get(obj))
				If msg
					Local class:String = fld.MetaData("class")
					If class = Null Then class = "no-class"
					build:+ fld.TypeId().Name() + " (" + class + "): " + msg.m_id + "~n"
				End If
			Next
			Return build[..build.Length - 1]
		End If
		Return Null
	End Function
	
End Type

