
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
bbdoc: duct ui module
End Rem
Module duct.dui

ModuleInfo "Version: 0.49"
ModuleInfo "Copyright: Liam McGuigan (FryGUI creator)"
ModuleInfo "Copyright: plash <plash@komiga.com> (dui is a heavily modified FryGUI)"
ModuleInfo "License: MIT"

ModuleInfo "History: Version 0.49"
ModuleInfo "History: Corrected duplicate-key input and delete key with text fields"
ModuleInfo "History: Version 0.48"
ModuleInfo "History: General cleanup"
ModuleInfo "History: Updated for duct.objectmap changes"
ModuleInfo "History: Renamed *ByName and *FromName methods/functions to *WithName"
ModuleInfo "History: Added safe draw state changing for cursor rendering"
ModuleInfo "History: duiMain default-state methods are now functions (oops)"
ModuleInfo "History: Renamed 'Draw' methods to 'Render'"
ModuleInfo "History: Corrected variable code for duct.variables update"
ModuleInfo "History: Version 0.47"
ModuleInfo "History: Fixed documentation, licences"
ModuleInfo "History: Renamed all dui_* types to dui*"
ModuleInfo "History: Renamed TDUIMain to duiMain"
ModuleInfo "History: Updated for API change"
ModuleInfo "History: Version 0.46"
ModuleInfo "History: General cleanup"
ModuleInfo "History: Renamed all 'duiT*' types to 'dui_*'"
ModuleInfo "History: Added single-surface themes and theme rendering interface"
ModuleInfo "History: Ported to use Protog2D"
ModuleInfo "History: Massive cleanup (renamed all 'g*' fields to 'm_*' (lowercased) and all non-conflicting parameters from '_*' to '*')"
ModuleInfo "History: Version 0.44"
ModuleInfo "History: Changed some formatting here and there"
ModuleInfo "History: Fixed MouseZ scrolling flowing through to other gadgets"
ModuleInfo "History: Fixed duiTable rendering"
ModuleInfo "History: Version 0.43"
ModuleInfo "History: Cleanup of headers (full cleanup may come later..)"
ModuleInfo "History: Version 0.4"
ModuleInfo "History: Changed event and mouse handling"
ModuleInfo "History: bbdoc'd everything"
ModuleInfo "History: Removed procedural interfaces"
ModuleInfo "History: Converted from FryGUI (permission given by Liam)"
ModuleInfo "History: Initial release"

ModuleInfo "TODO: Implement a better event system (thinking wxmax-style/connector functions) and change the way special-function gadgets work (scrollbox, datepanel, combobox, etc)"
ModuleInfo "TODO: Implement a registry system for extra gadget types (something like RegisterGadgetType(duiMyGadgetType) - which will contain pointers for skin refreshing and whatnot)"
ModuleInfo "TODO: Find a good way to handle scripted ui <-> code and incapsulated event-handling"
ModuleInfo "ISSUE: The event EVENT_KEYCHAR is not repeated whilst a character key is held down under Linux [see temporary fix in duiMain.__keyinputhook(...)]"

Import duct.etc
Import duct.objectmap
Import duct.vector
Import duct.scriptparser
Import duct.protog2d
Import duct.duimisc
Import duct.duidate
Import duct.duidraw

Include "src/event.bmx"
Include "src/theme.bmx"
Include "src/renderers.bmx"
Include "src/gadgets/gadgets.bmx"

Include "src/other/extra.bmx"

Const dui_SELECTED_ITEM:Int = -2

Const dui_CURSOR_NORMAL:Int = 0
Const dui_CURSOR_MOUSEOVER:Int = 1
Const dui_CURSOR_MOUSEDOWN:Int = 2
Const dui_CURSOR_TEXTOVER:Int = 3

Const dui_ALIGN_VERTICAL:Int = 0
Const dui_ALIGN_HORIZONTAL:Int = 1
Const dui_ALIGN_LEFT:Int = 2
Const dui_ALIGN_RIGHT:Int = 3

Rem
	bbdoc: duct ui controller/interface.
End Rem
Type duiMain
	
	Global m_currentscreen:duiScreen
	Global m_focusedpanel:duiPanel, m_focusedgadget:duiGadget
	Global m_activegadget:duiGadget
	
	Global m_theme:duiTheme
	
	Global m_screens:TListEx = New TListEx
	Global m_extras:TListEx = New TListEx
	
	Global m_width:Int = 1024, m_height:Int = 768
	
	Global m_cursorrenderer:duiCursorRenderer = New duiCursorRenderer
	Global m_currentcursor:Int, m_cursortype:Int
	
'#region Miscellaneous
	
	Rem
		bbdoc: Setup initial values for the ui.
		returns: Nothing.
	End Rem
	Function InitiateUI()
		'about: This needs to be called AFTER you open your graphics context.
		'duiFont.SetupDefaultFont()
		AddHook(EmitEventHook, __keyinputhook, Null, 0)
	End Function
	
	Rem
		bbdoc: Set the current screen
		returns: Nothing.
	End Rem
	Function SetCurrentScreen(screen:duiScreen, doevent:Int = False)
		If screen
			m_currentscreen = screen
			If doevent
				New duiEvent.Create(dui_EVENT_SETSCREEN, Null, 0, 0, 0, screen)
			End If
		End If
	End Function
	
	Rem
		bbdoc: Send a key to the active gadget (if there is an active gadget).
		returns: Nothing.
	End Rem
	Function SendKeyToActiveGadget(key:Int, _type:Int = 0)
		If m_activegadget
			m_activegadget.SendKey(key, _type)
		Else
			If m_focusedgadget
				If Not duiTextField(m_focusedgadget)
					'DebugLog("SKTAG; Focused")
					m_focusedgadget.SendKey(key, _type)
				End If
			End If
		End If
	End Function
	
'#end region Miscellaneous
	
'#region System dimensions
	
	Rem
		bbdoc: Set the ui dimensions.
		returns: Nothing.
	End Rem
	Function SetDimensions(width:Int, height:Int)
		m_width = width
		m_height = height
	End Function
	
	Rem
		bbdoc: Get the screen width of the ui system.
		returns: The ui area's width.
	End Rem
	Function GetScreenWidth:Int()
		Return m_width
	End Function
	
	Rem
		bbdoc: Get the screen height of the ui system.
		returns: The ui area's height.
	End Rem
	Function GetScreenHeight:Int()
		Return m_height
	End Function
	
'#end region System dimensions
	
'#region Update/Refresh & Render
	
	Rem
		bbdoc: Render the extra gadgets.
		returns: Nothing.
	End Rem
	Function RenderExtra()
		For Local extra:duiGadget = EachIn m_extras
			extra.Render(0.0, 0.0)
		Next
	End Function
	
	Rem
		bbdoc: Update the extra gadgets.
		returns: Nothing.
	End Rem
	Function UpdateExtra()
		Local extra:duiGadget
		For extra = EachIn New TListReversed.Create(m_extras)
			extra.Update(0.0, 0.0)
		Next
	End Function
	
	Rem
		bbdoc: Refresh the GUI.
		returns: Nothing.
		about: This will render, and update the current screen (and extras).
	End Rem
	Function Refresh()
		' Push the current graphics state on to the stack
		dProtogDrawState.Push()
		
		' Clear the focused gadget and panel
		m_focusedgadget = Null
		m_focusedpanel = Null
		
		' Reset the cursor
		m_currentcursor = dui_CURSOR_NORMAL
		m_currentscreen.Render()
		RenderExtra()
		
		UpdateExtra()
		m_currentscreen.Update()
		' Render the cursor
		RenderCursor()
		
		' Re-instate the pushed graphics state
		dProtogDrawState.Pop()
		'dProtog2DDriver.UnbindTextureTarget(GL_TEXTURE_2D)
		'dProtog2DDriver.UnbindTextureTarget(GL_TEXTURE_RECTANGLE_EXT)
		
		' Temporary fix
		duiGadget.m_oz = MouseZ()
	End Function
	
'#end region Update/Refresh & Render
	
'#region Theme
	
	Rem
		bbdoc: Set the system's theme and update all gadget renderers.
		returns: Nothing.
	End Rem
	Function SetTheme(theme:duiTheme)
		m_theme = theme
		duiPanel.RefreshSkin(m_theme)
		duiButton.RefreshSkin(m_theme)
		duiComboBox.RefreshSkin(m_theme)
		duiMenu.RefreshSkin(m_theme)
		duiProgressBar.RefreshSkin(m_theme)
		duiCheckBox.RefreshSkin(m_theme)
		duiScrollBar.RefreshSkin(m_theme)
		duiTextField.RefreshSkin(m_theme)
		duiDate.RefreshSkin(m_theme)
		duiDatePanel.RefreshSkin(m_theme)
		duiSearchBox.RefreshSkin(m_theme)
		duiSearchPanel.RefreshSkin(m_theme)
		duiSlider.RefreshSkin(m_theme)
		SetupCursorRenderer(m_theme)
	End Function
	
	Rem
		bbdoc: Setup the cursor renderer.
		returns: Nothing.
	End Rem
	Function SetupCursorRenderer(theme:duiTheme)
		m_cursorrenderer.Create(theme, "cursor")
	End Function
	
'#end region Theme
	
'#region Collections
	
	Rem
		bbdoc: Add an extra gadget to the system.
		returns: Nothing.
	End Rem
	Function AddExtra(extra:duiGadget)
		If extra
			m_extras.AddLast(extra)
		End If
	End Function
	
	Rem
		bbdoc: Add a screen to the system.
		returns: Nothing.
	End Rem
	Function AddScreen(screen:duiScreen)
		If screen
			m_screens.AddLast(screen)
		End If
	End Function
	
	Rem
		bbdoc: Get a screen with the given name.
		returns: The screen with the given name, or Null if there is no screen with the name given.
	End Rem
	Function GetScreenWithName:duiScreen(name:String)
		If name
			name = name.ToLower()
			For Local screen:duiScreen = EachIn m_screens
				If screen.GetName().ToLower() = name
					Return screen
				End If
			Next
		End If
		Return Null
	End Function
	
	Rem
		bbdoc: Get a panel with the given name.
		returns: The panel with the given name, or Null if there is no panel with the name given.
		about: If @fromscreen is not Null it will be searched, if it is Null all screens will be searched.
	End Rem
	Function GetPanelWithName:duiPanel(fromscreen:duiScreen, name:String)
		Local panel:duiPanel
		If name
			If fromscreen
				panel = fromscreen.GetPanelWithName(name)
			Else
				'_name = name.ToLower()
				For Local screen:duiScreen = EachIn m_screens
					panel = screen.GetPanelWithName(name)
					If panel
						Return panel
					End If
				Next
			End If
		End If
		Return panel
	End Function
	
'#end region Collections
	
'#region Active and focus
	
	Rem
		bbdoc: Check if the active gadget is @gadget or if the active gadget is Null.
		returns: True if the active gadget is Null or @gadget, or False if it was neither (some other gadget).
	End Rem
	Function IsGadgetActive:Int(gadget:duiGadget)
		If Not m_activegadget Or m_activegadget = gadget
			Return True
		End If
		Return False
	End Function
	
	Rem
		bbdoc: Clear the active gadget.
		returns: Nothing.
	End Rem
	Function ClearActiveGadget()
		m_activegadget = Null
	End Function
	
	Rem
		bbdoc: Get the active gadget.
		returns: The active gadget.
	End Rem
	Function GetActiveGadget:duiGadget()
		Return m_activegadget
	End Function
	
	Rem
		bbdoc: Set the active gadget.
		returns: Nothing.
	End Rem
	Function SetActiveGadget(gadget:duiGadget)
		m_activegadget = gadget
	End Function
	
	Rem
		bbdoc: Set the focused gadget.
		returns: Nothing.
		about: If a gadget already has focus this will do nothing. This creates an event (dui_EVENT_MOUSEOVER) with the given gadget.
	End Rem
	Function SetFocusedGadget(gadget:duiGadget, x:Int, y:Int)
		' Only make the change if no gadget has focus already (should be removed? - look at SetFocusedPanel \/)
		If Not m_focusedgadget
			m_focusedgadget = gadget
			New duiEvent.Create(dui_EVENT_MOUSEOVER, gadget, 0, x, y, Null)
		End If
	End Function
	
	Rem
		bbdoc: Get the focused gadget.
		returns: The gadget with mouse focus.
	End Rem
	Function GetFocusedGadget:duiGadget()
		Return m_focusedgadget
	End Function
	
	Rem
		bbdoc: Set the focused panel.
		returns: Nothing.
	End Rem
	Function SetFocusedPanel(panel:duiPanel)
		m_focusedpanel = panel
	End Function
	
	Rem
		bbdoc: Check if the focused panel is Null or @panel.
		returns: True if the focused panel is Null or if it is @panel, or False if it was neither (some other panel).
	End Rem
	Function IsPanelFocused:Int(panel:duiPanel)
		If Not m_focusedpanel Or m_focusedpanel = panel Or m_focusedpanel = panel.m_parent
			Return True
		Else
			Return False
		End If
	End Function
	
'#end region Active and focus
	
'#region Cursor
	
	Rem
		bbdoc: Set the current cursor.
		returns: Nothing.
	End Rem
	Function SetCursor(cursor:Int)
		m_currentcursor = cursor
	End Function
	Rem
		bbdoc: Get the current cursor.
		returns: The current cursor.
	End Rem
	Function GetCursor:Int()
		Return m_currentcursor
	End Function
	
	Rem
		bbdoc: Set the cursor type.
		returns: Nothing.
		about: @cursortype can be:<br>
		0 - Normal cursor (the skin's cursors)<br>
		1 - System cursor<br>
	End Rem
	Function SetCursorType(cursortype:Int)
		m_cursortype = cursortype
	End Function
	Rem
		bbdoc: Get the cursor type.
		returns: The current cursor type.
	End Rem
	Function GetCursorType:Int()
		Return m_cursortype
	End Function
	
	Rem
		bbdoc: Render the cursor (if it is enabled).
		returns: Nothing.
	End Rem
	Function RenderCursor()
		If m_cursortype = 0
			dProtogDrawState.Push(True, True, True, False, False, False)
			dProtog2DDriver.SetBlend(BLEND_ALPHA)
			dProtog2DDriver.SetAlpha(1.0)
			dProtog2DDriver.BindColorParams(1.0, 1.0, 1.0)
			m_cursorrenderer.RenderCursor(m_currentcursor, Float(MouseX()), Float(MouseY()))
			dProtogDrawState.Pop(True, True, True, False, False, False)
		Else If m_cursortype = 1
			'?win32
			'Select m_currentcursor
			'	Case dui_CURSOR_NORMAL
			'		pub.win32.SetCursor(1)
			'	Case dui_CURSOR_MOUSEOVER
			'		pub.win32.SetCursor(2)
			'	Case dui_CURSOR_MOUSEDOWN
			'		pub.win32.SetCursor(2)
			'End Select
			'?
		End If
	End Function
	
'#end region Cursor
	
'#region Default color & alpha
	
	Rem
		bbdoc: Set the default gadget color.
		returns: Nothing.
	End Rem
	Function SetDefaultColor(color:dProtogColor, alpha:Int = True, index:Int = 0)
		If index > -1 And index < duiGadget.m_defaultcolor.Length
			duiGadget.m_defaultcolor[index].SetFromColor(color, alpha)
		End If
	End Function
	
	Rem
		bbdoc: Set the defautl gadget color to the parameters given.
		returns: Nothing.
	End Rem
	Function SetDefaultColorParams(red:Float, green:Float, blue:Float, index:Int = 0)
		If index > -1 And index < duiGadget.m_defaultcolor.Length
			duiGadget.m_defaultcolor[index].SetColor(red, green, blue)
		End If
	End Function
	
	Rem
		bbdoc: Get the default gadget color.
		returns: The default gadget color at the given index, or Null if the given index was invalid.
	End Rem
	Function GetDefaultColor:dProtogColor(index:Int = 0)
		If index > -1 And index < duiGadget.m_defaultcolor.Length
			Return duiGadget.m_defaultcolor[index]
		End If
		Return Null
	End Function
	
	Rem
		bbdoc: Set the default gadget text color.
		returns: Nothing.
	End Rem
	Function SetDefaultTextColor(color:dProtogColor, alpha:Int = True, index:Int = 0)
		If index > -1 And index < duiGadget.m_defaulttextcolor.Length
			duiGadget.m_defaulttextcolor[index].SetFromColor(color, alpha)
		End If
	End Function
	
	Rem
		bbdoc: Set the default gadget text color by the parameters given.
		returns: Nothing.
	End Rem
	Function SetDefaultTextColorParams(red:Float, green:Float, blue:Float, index:Int = 0)
		If index > -1 And index < duiGadget.m_defaulttextcolor.Length
			duiGadget.m_defaulttextcolor[index].SetColor(red, green, blue)
		End If
	End Function
	
	Rem
		bbdoc: Get the default gadget text color.
		returns: The default gadget text color at the given index, or Null if the given index was invalid.
	End Rem
	Function GetDefaultTextColor:dProtogColor(index:Int = 0)
		If index > -1 And index < duiGadget.m_defaulttextcolor.Length
			Return duiGadget.m_defaulttextcolor[index]
		End If
		Return Null
	End Function
	
	Rem
		bbdoc: Set the default gadget alpha.
		returns: Nothing.
	End Rem
	Function SetDefaultAlpha(alpha:Float, index:Int = 0)
		If index > -1 And index < duiGadget.m_defaultcolor.Length
			duiGadget.m_defaultcolor[index].SetAlpha(alpha)
		End If
	End Function
	
	Rem
		bbdoc: Get the default gadget alpha.
		returns: The default gadget alpha at the given index, or 1.0 if the given index was invalid.
	End Rem
	Function GetDefaultAlpha:Float(index:Int = 0)
		If index > -1 And index < duiGadget.m_defaultcolor.Length
			Return duiGadget.m_defaultcolor[index].GetAlpha()
		End If
		Return 1.0
	End Function
	
	Rem
		bbdoc: Set the default gadget text alpha.
		returns: Nothing.
	End Rem
	Function SetDefaultTextAlpha(alpha:Float, index:Int = 0)
		If index > -1 And index < duiGadget.m_defaulttextcolor.Length
			duiGadget.m_defaulttextcolor[index].SetAlpha(alpha)
		End If
	End Function
	
	Rem
		bbdoc: Get the default gadget text alpha.
		returns: The default gadget text alpha at the given index, or 1.0 if the given index was invalid.
	End Rem
	Function GetDefaultTextAlpha:Float(index:Int = 0)
		If index > -1 And index < duiGadget.m_defaulttextcolor.Length
			Return duiGadget.m_defaulttextcolor[index].GetAlpha()
		End If
		Return 1.0
	End Function
	
'#end region Default color & alpha
	
'#region Key hook
	
	Function __keyinputhook:Object(id:Int, data:Object, context:Object)
		Local event:TEvent = TEvent(data)
		If event
			Select event.id
				Case EVENT_KEYDOWN
					'DebugLog("duiMain.__keyinputhook(); EVENT_KEYDOWN (ed: " + event.data + ")")
					SendKeyToActiveGadget(event.data, 0)
					Return Null
				Case EVENT_KEYREPEAT
					'DebugLog("duiMain.__keyinputhook(); EVENT_KEYREPEAT (ed: " + event.data + ")")
					' Temporary fix for EVENT_KEYCHAR not repeating (sadly the event's data is always upper-case, so this isn't completely viable)
					' Doesn't seem to need this anymore, yay!
					'?Linux
					'	If event.data > 31
					'		SendKeyToActiveGadget(event.data, 1)
					'	Else
					'		SendKeyToActiveGadget(event.data, 0)
					'	End If
					'?Not Linux
						SendKeyToActiveGadget(event.data, 0)
					'?
					Return Null
				Case EVENT_KEYCHAR
					'DebugLog("duiMain.__keyinputhook(); EVENT_KEYCHAR (ed: " + event.data + ")")
					SendKeyToActiveGadget(event.data, 1)
					Return Null
			End Select
		End If
		Return data
	End Function
	
'#end region Key hook
	
End Type

