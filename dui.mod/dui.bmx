
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
End Rem

SuperStrict

Rem
bbdoc: The duct GUI module
End Rem
Module duct.dui

ModuleInfo "Version: 0.44"
ModuleInfo "Copyright: Liam McGuigan (FryGUI creator)"
ModuleInfo "Copyright: Tim Howard (dui is a heavily modified FryGUI)"
ModuleInfo "License: MIT"

ModuleInfo "History: Version 0.44"
ModuleInfo "History: Changed some formatting here and there"
ModuleInfo "History: Fixed MouseZ scrolling flowing through to other gadgets"
ModuleInfo "History: Fixed dui_TTable rendering"
ModuleInfo "History: Version 0.43"
ModuleInfo "History: Cleanup of headers (full cleanup may come later..)"
ModuleInfo "History: Version 0.4"
ModuleInfo "History: Changed event and mouse handling"
ModuleInfo "History: bbdoc'd everything"
ModuleInfo "History: Removed procedural interfaces"
ModuleInfo "History: Converted from FryGUI (permission given by Liam)"
ModuleInfo "History: Initial release"

ModuleInfo "TODO: Implement a better event system (thinking wxmax-style/connector functions) and change the way special-function gadgets work (scrollbox, datepanel, combobox, etc)"
ModuleInfo "TODO: Implement a registry system for extra gadget types (something like RegisterGadgetType(dui_TMyGadgetType) - which will contain pointers for skin refreshing and whatnot)"
ModuleInfo "TODO: Find a good way to handle scripted ui <-> code and incapsulated event-handling"
ModuleInfo "ISSUE: The event EVENT_KEYCHAR is not repeated whilst a character key is held down under Linux [see temporary fix in TDUIMain.__keyinputhook(...)]"

' Used modules
Import brl.linkedlist
Import brl.max2d
Import brl.retro

Import brl.glmax2d
Import brl.d3d7max2d

Import brl.pngloader

Import duct.etc
Import duct.drawstate

Import duct.duimisc
Import duct.duidate
Import duct.duidraw

'Import koriolis.bufferedstream
'Import koriolis.zipstream
'Import pub.zipengine

' Included source code
Include "inc/types/gadgets/gadgets.bmx"
Include "inc/types/event.bmx"
Include "inc/other/extra.bmx"


' Selected item constant
Const dui_SELECTED_ITEM:Int = -2

Const dui_CURSOR_NORMAL:Int = 0
Const dui_CURSOR_MOUSEOVER:Int = 1
Const dui_CURSOR_MOUSEDOWN:Int = 2
Const dui_CURSOR_TEXTOVER:Int = 3

Rem
	bbdoc: The dui controller/interface type.
End Rem
Type TDUIMain
	
	Global SkinUrl:String
	
	Global gCurrentScreen:dui_TScreen
	Global gFocusedPanel:dui_TPanel, gFocusedGadget:dui_TGadget
	Global gActiveGadget:dui_TGadget
	
	Global gScreens:TListEx = New TListEx
	Global gExtras:TListEx = New TListEx
	
	Global gWidth:Int = 1024, gHeight:Int = 768
	
	Global gCursorImages:TImage[4], gCursor:Int, gCursorType:Int
	
	Rem
		bbdoc: Add an extra gadget to the system.
		returns: Nothing.
	End Rem
	Function AddExtra(extra:dui_TGadget)
		If extra <> Null Then gExtras.AddLast(extra)
	End Function
	
	Rem
		bbdoc: Render the extra gadgets.
		returns: Nothing.
	End Rem
	Function RenderExtra()
		For Local extra:dui_TGadget = EachIn gExtras
			extra.Render(0.0, 0.0)
		Next
	End Function
	
	Rem
		bbdoc: Update the extra gadgets.
		returns: Nothing.
	End Rem
	Function UpdateExtra()
		Local extra:dui_TGadget
		For extra = EachIn New TListReversed.Create(gExtras)
			extra.Update(0.0, 0.0)
		Next
	End Function
	
	Rem
		bbdoc: Refresh the GUI.
		returns: Nothing.
		about: This will render, and update the current screen (and Extras).
	End Rem
	Function Refresh()
		' Push the current graphics state on to the stack
		TDrawState.Push()
		
		' Clear the focused gadget and panel
		gFocusedGadget = Null
		gFocusedPanel = Null
		
		' Reset the cursor
		gCursor = dui_CURSOR_NORMAL
		gCurrentScreen.Render()
		RenderExtra()
		
		UpdateExtra()
		gCurrentScreen.Update()
		' Draw the cursor
		DrawCursor()
		
		' Re-instate the pushed graphics state
		TDrawState.Pop()
		
		' Temporary fix
		dui_TGadget.m_oz = MouseZ()
	End Function
	
	Rem
		bbdoc: Draw the cursor (if it is enabled).
		returns: Nothing.
	End Rem
	Function DrawCursor()
		Local x:Int, y:Int
		
		If GetCursorType() = 0
			SetBlend(ALPHABLEND)
			SetAlpha(1.0)
			SetColor(255, 255, 255)
			Select GetCursor()
				Case dui_CURSOR_NORMAL
					x = MouseX()
					y = MouseY()
				Case dui_CURSOR_MOUSEOVER
					x = MouseX() - 5
					y = MouseY()
				Case dui_CURSOR_MOUSEDOWN
					x = MouseX() - 5
					y = MouseY()
				Case dui_CURSOR_TEXTOVER
					x = MouseX() - (gCursorImages[dui_CURSOR_TEXTOVER].width / 2)
					y = MouseY() - (gCursorImages[dui_CURSOR_TEXTOVER].height / 2)
				Default
					' Invalid cursor type - get me out of here!
					Return
					
			End Select
			DrawImage(gCursorImages[GetCursor()], x, y)
			
		Else If GetCursorType() = 1
			'?win32
			'Select GetCursor()
			'	Case dui_CURSOR_NORMAL
			'		pub.win32.SetCursor(1)
			'		
			'	Case dui_CURSOR_MOUSEOVER
			'		pub.win32.SetCursor(2)
			'		
			'	Case dui_CURSOR_MOUSEDOWN
			'		pub.win32.SetCursor(2)
			'		
			'End Select
			'?
		End If
	End Function
	
	Rem
		bbdoc: Load a skin.
		returns: Nothing.
	End Rem
	Function LoadSkin(url:String)
		SkinUrl = url
		dui_TPanel.RefreshSkin()
		dui_TButton.RefreshSkin()
		dui_TComboBox.RefreshSkin()
		dui_TMenu.RefreshSkin()
		dui_TProgressBar.RefreshSkin()
		dui_TCheckBox.RefreshSkin()
		dui_TScrollBar.RefreshSkin()
		dui_TTextField.RefreshSkin()
		dui_TDate.RefreshSkin()
		dui_TDatePanel.RefreshSkin()
		dui_TSearchBox.RefreshSkin()
		dui_TSearchPanel.RefreshSkin()
		dui_TSlider.RefreshSkin()
		
		LoadCursors()
	End Function
	
	Rem
		bbdoc: Load the cursor images.
		returns: Nothing.
	End Rem
	Function LoadCursors()
		' Get normal cursor
		gCursorImages[dui_CURSOR_NORMAL] = LoadImage(SkinUrl + "/graphics/cursors/normal.png")
		' Get mouseover cursor
		gCursorImages[dui_CURSOR_MOUSEOVER] = LoadImage(SkinUrl + "/graphics/cursors/mouseover.png")
		' Get mousedown cursor
		gCursorImages[dui_CURSOR_MOUSEDOWN] = LoadImage(SkinUrl + "/graphics/cursors/mousedown.png")
		' Get mousedown cursor
		gCursorImages[dui_CURSOR_TEXTOVER] = LoadImage(SkinUrl + "/graphics/cursors/textover.png")
	End Function
	
	Rem
		bbdoc: Setup initial values for the ui.
		returns: Nothing.
		about: This needs to be called AFTER you open your graphics context.
	End Rem
	Function InitiateUI()
		dui_TFont.SetupDefaultFont()
		AddHook(EmitEventHook, __keyinputhook, Null, 0)
	End Function
	
	Rem
		bbdoc: Set the ui dimensions.
		returns: Nothing.
	End Rem
	Function SetDimensions(_width:Int, _height:Int)
		gWidth = _width
		gHeight = _height
	End Function
	
	Rem
		bbdoc: Get the screen width of the ui system.
		returns: The ui area's width.
	End Rem
	Function GetScreenWidth:Int()
		Return gWidth
	End Function
	
	Rem
		bbdoc: Get the screen height of the ui system.
		returns: The ui area's height.
	End Rem
	Function GetScreenHeight:Int()
		Return gHeight
	End Function
	
	Rem
		bbdoc: Set the current screen
		returns: Nothing.
	End Rem
	Function SetCurrentScreen(_screen:dui_TScreen, _doevent:Int = False)
		If _screen <> Null
			gCurrentScreen = _screen
			If _doevent = True
				New dui_TEvent.Create(dui_EVENT_SETSCREEN, Null, 0, 0, 0, _screen)
			End If
		End If
	End Function
	
	Rem
		bbdoc: Get a screen by it's name.
		returns: A dui_TScreen, or Null if the screen by the name given was not found
	End Rem
	Function GetScreenByName:dui_TScreen(_name:String)
		Local screen:dui_TScreen
		If _name <> Null
			_name = _name.ToLower()
			For screen = EachIn gScreens
				If screen.GetName().ToLower() = _name
					Return screen
				End If
			Next
		End If
		Return Null
	End Function
	
	Rem
		bbdoc: Add a screen to the system.
		returns: Nothing.
	End Rem
	Function AddScreen(_screen:dui_TScreen)
		If _screen <> Null
			gScreens.AddLast(_screen)
		End If
	End Function
	
	Rem
		bbdoc: Get a panel by its name.
		returns: Nothing.
	End Rem
	Function GetPanelByName:dui_TPanel(_name:String)
		Local screen:dui_TScreen, panel:dui_TPanel
		
		If _name <> Null
			'_name = _name.ToLower()
			For screen = EachIn gScreens
				panel = screen.GetPanelByName(_name)
				If panel <> Null
					Return panel
				End If
			Next
		End If
		Return Null
	End Function
	
	Rem
		bbdoc: Check if the active gadget is @_gadget or if the active gadget is Null.
		returns: True if the active gadget is Null or @_gadget, or False if it was neither (some other gadget).
	End Rem
	Function IsGadgetActive:Int(_gadget:dui_TGadget)
		If GetActiveGadget() = Null Or GetActiveGadget() = _gadget
			Return True
		End If
		Return False
	End Function
	
	Rem
		bbdoc: Clear the active gadget.
		returns: Nothing.
	End Rem
	Function ClearActiveGadget()
		SetActiveGadget(Null)
	End Function
	
	Rem
		bbdoc: Get the active gadget.
		returns: The active gadget.
	End Rem
	Function GetActiveGadget:dui_TGadget()
		Return gActiveGadget
	End Function
	
	Rem
		bbdoc: Set the active gadget.
		returns: Nothing.
	End Rem
	Function SetActiveGadget(gadget:dui_TGadget)
		gActiveGadget = gadget
	End Function
	
	Rem
		bbdoc: Set the focused gadget.
		returns: Nothing.
		about: If a gadget already has focus this will do nothing. This creates an event (dui_EVENT_MOUSEOVER) with the given gadget.
	End Rem
	Function SetFocusedGadget(_gadget:dui_TGadget, _x:Int, _y:Int)
		' Only make the change if no gadget has focus already (should be removed? - look at SetFocusedPanel \/)
		If gFocusedGadget = Null
			gFocusedGadget = _gadget
			New dui_TEvent.Create(dui_EVENT_MOUSEOVER, _gadget, 0, _x, _y, Null)
		End If
	End Function
	
	Rem
		bbdoc: Get the focused gadget.
		returns: The gadget with mouse focus.
	End Rem
	Function GetFocusedGadget:dui_TGadget()
		Return gFocusedGadget
	End Function
	
	Rem
		bbdoc: Set the focused panel.
		returns: Nothing.
	End Rem
	Function SetFocusedPanel(_panel:dui_TPanel)
		gFocusedPanel = _panel
	End Function
	
	Rem
		bbdoc: Check if the focused panel is Null or @_panel.
		returns: True if the focused panel is Null or if it is @_panel, or False if it was neither (some other panel).
	End Rem
	Function IsPanelFocused:Int(_panel:dui_TPanel)
		If gFocusedPanel = Null Or gFocusedPanel = _panel Or gFocusedPanel = _panel.gParent
			Return True
		Else
			Return False
		End If
	End Function
	
	Rem
		bbdoc: Set the current cursor.
		returns: Nothing.
	End Rem
	Function SetCursor(_cursor:Int)
		gCursor = _cursor
	End Function
	
	Rem
		bbdoc: Get the current cursor.
		returns: The current cursor.
	End Rem
	Function GetCursor:Int()
		Return gCursor
	End Function
	
	Rem
		bbdoc: Set the cursor type.
		returns: Nothing.
		about: @_cursortype can be:<br>
		0 - Normal cursor (the skin's cursors)<br>
		1 - System cursor
	End Rem
	Function SetCursorType(_cursortype:Int)
		gCursorType = _cursortype
	End Function
	
	Rem
		bbdoc: Get the cursor type.
		returns: The current cursor type.
	End Rem
	Function GetCursorType:Int()
		Return gCursorType
	End Function
	
	Rem
		bbdoc: Send a key to the active gadget (if there is an active gadget).
		returns: Nothing.
	End Rem
	Function SendKeyToActiveGadget(_key:Int, _type:Int = 0)
		If GetActiveGadget() <> Null
			GetActiveGadget().SendKey(_key, _type)
		Else
			If GetFocusedGadget() <> Null
				If dui_TTextField(GetFocusedGadget()) = Null
					DebugLog("SKTAG; Focused")
					GetFocusedGadget().SendKey(_key, _type)
				End If
			End If
		End If
	End Function
	
	Rem
		bbdoc: Set the default colour for a created gadget.
		returns: Nothing.
		about: The index is relevant to the gadget type (see the SetColour method).
	End Rem
	Function SetDefaultColour(_r:Int, _g:Int, _b:Int, _index:Int = 0)
		If _index > - 1 And _index < 3
			dui_TGadget.DefaultColour[_index] = [_r, _g, _b]
		End If
	End Function
	
	Rem
		bbdoc: Set the default text colour for a created gadget.
		returns: Nothing.
		about: The index is relevant to the gadget type (see the SetTextColour method).
	End Rem
	Function SetDefaultTextColour(_r:Int, _g:Int, _b:Int, _index:Int = 0)
		If _index > - 1 And _index < 3
			dui_TGadget.DefaultTextColour[_index] = [_r, _g, _b]
		End If
	End Function
	
	Rem
		bbdoc: Set the default alpha for a created gagdet.
		returns: Nothing.
		about: The index is relevant to the gadget type (see the SetAlpha method).
	End Rem
	Function SetDefaultAlpha(_a:Float, _index:Int = 0)
		If _index > - 1 And _index < 3
			dui_TGadget.DefaultAlpha[_index] = _a
		End If
	End Function
	
	Rem
		bbdoc: Set the default text alpha for a created gagdet.
		returns: Nothing.
		about: The index is relevant to the gadget type (see the SetTextAlpha method).
	End Rem
	Function SetDefaultTextAlpha(_a:Float, _index:Int = 0)
		If _index > - 1 And _index < 3
			dui_TGadget.DefaultTextAlpha[_index] = _a
		End If
	End Function
	
	Rem
		bbdoc: Get the default colour for a created gadget.
		returns: Nothing. @_r, @_g and @_b will be set to the default colour (if the index is valid).
		about: The index is relevant to the gadget type (see the SetColour method).
	End Rem
	Function GetDefaultColour(_r:Int Var, _g:Int Var, _b:Int Var, _index:Int = 0)
		If _index > - 1 And _index < 3
			_r = dui_TGadget.DefaultColour[_index][0]
			_g = dui_TGadget.DefaultColour[_index][1]
			_b = dui_TGadget.DefaultColour[_index][2]
		End If
	End Function
	
	Rem
		bbdoc: Get the default text colour for a created gadget.
		returns: Nothing. @_r, @_g and @_b will be set to the default text colour (if the index is valid).
		about: The index is relevant to the gadget type (see the SetTextColour method).
	End Rem
	Function GetDefaultTextColour(_r:Int Var, _g:Int Var, _b:Int Var, _index:Int = 0)
		If _index > - 1 And _index < 3
			_r = dui_TGadget.DefaultTextColour[_index][0]
			_g = dui_TGadget.DefaultTextColour[_index][1]
			_b = dui_TGadget.DefaultTextColour[_index][2]
		End If
	End Function
	
	Rem
		bbdoc: Get the default alpha for a created gagdet.
		returns: The default alpha, or 1.0 if the index was invalid.
		about: The index is relevant to the gadget type (see the GetAlpha method).
	End Rem
	Function GetDefaultAlpha:Float(_index:Int = 0)
		If _index > - 1 And _index < 3
			Return dui_TGadget.DefaultAlpha[_index]
		End If
		Return 1.0
	End Function
	
	Rem
		bbdoc: Get the default text alpha for a created gagdet.
		returns: The default text alpha, or 1.0 if the index was invalid.
		about: The index is relevant to the gadget type (see the GetTextAlpha method).
	End Rem
	Function GetDefaultTextAlpha:Float(_index:Int = 0)
		If _index > - 1 And _index < 3
			Return dui_TGadget.DefaultTextAlpha[_index]
		End If
		Return 1.0
	End Function
	
	' For some reason EVENT_KEYCHAR is only repeated in windows (not getting the event, over and over, when a key is held down on Ubuntu 8.04)
	Function __keyinputhook:Object(id:Int, data:Object, context:Object)
		Local event:TEvent
		
		event = TEvent(data)
		If event <> Null
			Select event.id
				Case EVENT_KEYDOWN
					'DebugLog("TDUIMain.__keyinputhook(); EVENT_KEYDOWN (ed: " + event.data + ") caught")
					SendKeyToActiveGadget(event.data, 0)
				Case EVENT_KEYREPEAT
					'DebugLog("TDUIMain.__keyinputhook(); EVENT_KEYREPEAT (ed: " + event.data + ") caught")
					
					' Temporary fix for EVENT_KEYCHAR not repeating (sadly the event's data is always upper-case, so this isn't completely viable)
					?Linux
						If event.data > 31
							SendKeyToActiveGadget(event.data, 1)
						Else
							SendKeyToActiveGadget(event.data, 0)
						End If
					?Not Linux
						SendKeyToActiveGadget(event.data, 0)
					?
				Case EVENT_KEYCHAR
					'DebugLog("TDUIMain.__keyinputhook(); EVENT_KEYCHAR (ed: " + event.data + ") caught")
					SendKeyToActiveGadget(event.data, 1)
			End Select
		End If
		Return data
	End Function
	
End Type

















