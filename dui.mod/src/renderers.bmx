
Rem
Copyright (c) 2010 Coranna Howard <me@komiga.com>

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
	bbdoc: duct ui base theme renderer.
End Rem
Type duiBaseThemeRenderer Extends dObjectMap
	
	Field m_theme:duiTheme, m_basestructure:String
	
	Rem
		bbdoc: Initialize the renderer.
		returns: Nothing.
		about: This will clear any sections held by the renderer.
	End Rem
	Method _Init(theme:duiTheme, basestructure:String)
		Clear()
		SetBaseStructure(basestructure)
		SetTheme(theme)
	End Method
	
'#region Field accessors
	
	Rem
		bbdoc: Set the renderer's theme (requires a cell re-load).
		returns: Nothing.
		about: This method will throw a string as an exception if the given theme is Null.
	End Rem
	Method SetTheme(theme:duiTheme)
		If theme
			m_theme = theme
		Else
			Throw "(duiBaseThemeRenderer.SetTheme()) Theme is null!"
		End If
	End Method
	Rem
		bbdoc: Get the renderer's theme.
		returns: The renderer's theme.
	End Rem
	Method GetTheme:duiTheme()
		Return m_theme
	End Method
	
	Rem
		bbdoc: Set the renderer's base structure.
		returns: Nothing.
	End Rem
	Method SetBaseStructure(basestructure:String)
		 m_basestructure = basestructure
	End Method
	Rem
		bbdoc: Get the renderer's base structure.
		returns: The renderer's base structure.
	End Rem
	Method GetBaseStructure:String()
		Return m_basestructure
	End Method
	
'#end region Field accessors
	
'#region Rendering
	
	Rem
		bbdoc: Render the given quad to the given section's texture coordinates.
		returns: Nothing.
	End Rem
	Method RenderArea(x:Float, y:Float, x2:Float, y2:Float, section:duiThemeSection)
		m_theme.RenderArea(x, y, x2, y2, section.m_uv)
	End Method
	
	Rem
		bbdoc: Find the section with the given structure and render it to the given dimensions.
		returns: Nothing.
		about: If @frombase is True the renderer's base structure will be prepended to the structure (if both are non-Null).
	End Rem
	Method RenderSectionToSize(structure:String, x:Float, y:Float, width:Float, height:Float, frombase:Int = True)
		Local section:duiThemeSection = GetSectionFromStructure(structure, frombase)
		If section
			RenderArea(x, y, x + width, y + height, section)
		End If
	End Method
	
	Rem
		bbdoc: Find the section with the given structure and render it by it's size.
		returns: Nothing.
		about: If @frombase is True the renderer's base structure will be prepended to the structure (if both are non-Null).
	End Rem
	Method RenderSectionToSectionSize(structure:String, x:Float, y:Float, frombase:Int = True)
		Local section:duiThemeSection = GetSectionFromStructure(structure, frombase)
		If section
			RenderArea(x, y, x + section.m_width, y + section.m_height, section)
		End If
	End Method
	
	Rem
		bbdoc: Find the section with the given structure and render it by the gadget's size.
		returns: Nothing.
		about: If @frombase is True the renderer's base structure will be prepended to the structure (if both are non-Null).
	End Rem
	Method RenderSectionToGadgetSize(structure:String, x:Float, y:Float, gadget:duiGadget, frombase:Int = True, wmod:Float = 0.0, hmod:Float = 0.0)
		RenderSectionToSize(structure, x, y, gadget.m_width + wmod, gadget.m_height + hmod, frombase)
	End Method
	
'#end region Rendering
	
'#region Collections
	
	Rem
		bbdoc: Add the given section to the renderer.
		returns: True if the section was added, or False if it was not (it is already in the renderer).
	End Rem
	Method AddSection:Int(section:duiThemeSection)
		If section And Not ContainsSection(section)
			_Insert(section.GetStructure(False), section)
			Return True
		End If
		Return False
	End Method
	
	Rem
		bbdoc: Add the section with the given structure (from the renderer's theme).
		returns: The section that was added, or Null if either the given structure was not determined to be a section, or the section already exists in the renderer.
		about: If @frombase is True the renderer's base structure will be prepended to the structure (if both are non-Null).
	End Rem
	Method AddSectionFromStructure:duiThemeSection(structure:String, frombase:Int = True)
		Local section:duiThemeSection
		
		section = GetSectionFromStructure(structure, frombase)
		If AddSection(section)
			Return section
		Else
			Return Null
		End If
	End Method
	
	Rem
		bbdoc: Add the section with the given structure from the given set.
		returns: The section that was added, or Null if either the given structure was not determined to be a section, the section already exists in the renderer, or the given set was null.
		about: If @frombase is True the renderer's base structure will be prepended to the structure (if both are non-Null).
	End Rem
	Method AddSectionFromSet:duiThemeSection(set:duiThemeSectionSet, structure:String, frombase:Int = False)
		Local section:duiThemeSection = GetSectionFromSet(set, structure, frombase)
		If AddSection(section)
			Return section
		Else
			Return Null
		End If
	End Method
	
	Rem
		bbdoc: Get the cell section from the given structure, from the given set.
		returns: The section for the given structure, or Null if either it could not be found or the given set was Null.
		about: If @frombase is True the renderer's base structure will be prepended to the structure (if both are non-Null).
	End Rem
	Method GetSectionFromSet:duiThemeSection(set:duiThemeSectionSet, structure:String, frombase:Int = False)
		If set
			structure = BuildStructure(structure, frombase)
			Return set.GetSectionFromStructure(structure)
		End If
		Return Null
	End Method
	
	Rem
		bbdoc: Get the section with the given structure.
		returns: The section with the given structure, or Null if the given structure was not determined to be a section.
		about: If @frombase is True the renderer's base structure will be prepended to the structure (if both are non-Null).
	End Rem
	Method GetSectionFromStructure:duiThemeSection(structure:String, frombase:Int = True)
		structure = BuildStructure(structure, frombase)
		Return m_theme.GetSectionFromStructure(structure)
	End Method
	
	Rem
		bbdoc: Get the set with the given structure.
		returns: The set with the given structure, or Null if the given structure was not determined to be a set.
		about: If @frombase is True the renderer's base structure will be prepended to the structure (if both are non-Null).
	End Rem
	Method GetSectionSetFromStructure:duiThemeSectionSet(structure:String, frombase:Int = True)
		structure = BuildStructure(structure, frombase)
		Return m_theme.GetSectionSetFromStructure(structure)
	End Method
	
	Rem
		bbdoc: Check if the renderer contains the given section.
		returns: Nothing.
	End Rem
	Method ContainsSection:Int(section:duiThemeSection)
		If section
			Return _Contains(section.GetStructure(False))
		End If
		Return False
	End Method
	
	Rem
		bbdoc: Check if the renderer contains the given structure.
		returns: True if the section with the given structure is handled by the renderer, or False if the given structure could not be determined to be a section.
		about: If @frombase is True the renderer's base structure will be prepended to the structure (if both are non-Null).
	End Rem
	Method ContainsSectionFromStructure:Int(structure:String, frombase:Int = True)
		structure = BuildStructure(structure, frombase)
		Return _Contains(structure)
	End Method
	
	Rem
		bbdoc: Get the full structure from the given structure.
		returns: Nothing.
		about: If @frombase is True the renderer's base structure will be prepended to the structure (if both are non-Null).
	End Rem
	Method BuildStructure:String(structure:String, frombase:Int = True)
		If frombase And m_basestructure
			If structure
				structure = m_basestructure + "." + structure
			Else
				structure = m_basestructure
			End If
		End If
		Return structure
	End Method
	
'#end region Collections
	
End Type

Rem
	bbdoc: duct ui generic theme renderer.
End Rem
Type duiGenericRenderer Extends duiBaseThemeRenderer
	
	Field m_corner_topleft:duiThemeSection, m_corner_topright:duiThemeSection, m_corner_bottomleft:duiThemeSection, m_corner_bottomright:duiThemeSection
	Field m_side_top:duiThemeSection, m_side_left:duiThemeSection, m_side_right:duiThemeSection, m_side_bottom:duiThemeSection
	Field m_middle:duiThemeSection
	
	Rem
		bbdoc: Create a generic renderer.
		returns: The new generic renderer (itself).
		about: This method will throw a string as an exception if the given theme is Null (see #SetTheme).
	End Rem
	Method Create:duiGenericRenderer(theme:duiTheme, basestructure:String)
		_Init(theme, basestructure)
		LoadCells()
		Return Self
	End Method
	
'#region Cells
	
	Rem
		bbdoc: Load the cells from the renderer's theme.
		returns: Nothing.
	End Rem
	Method LoadCells()
		Local set:duiThemeSectionSet = GetSectionSetFromStructure("corner", True)
		m_corner_topleft = GetSectionFromSet(set, "topleft", False)
		m_corner_topright = GetSectionFromSet(set, "topright", False)
		m_corner_bottomleft = GetSectionFromSet(set, "bottomleft", False)
		m_corner_bottomright = GetSectionFromSet(set, "bottomright", False)
		set = GetSectionSetFromStructure("side", True)
		m_side_top = GetSectionFromSet(set, "top", False)
		m_side_left = GetSectionFromSet(set, "left", False)
		m_side_right = GetSectionFromSet(set, "right", False)
		m_side_bottom = GetSectionFromSet(set, "bottom", False)
		m_middle = GetSectionFromStructure("middle", True)
	End Method
	
'#end region Cells
	
'#region Rendering
	
	Rem
		bbdoc: Render the given cell.
		returns: Nothing.
	End Rem
	Method RenderCell(cell:Int, x:Float, y:Float, gadget:duiGadget, wmod:Float = 0.0, hmod:Float = 0.0)
		Local section:duiThemeSection
		Local x2:Float, y2:Float
		If cell > -1 And cell < 9
			section = GetRenderAreaFromCell(cell, x, y, x2, y2, gadget, wmod, hmod)
			RenderArea(x, y, x2, y2, section)
		End If
	End Method
	
	Rem
		bbdoc: Render the entire cell set.
		returns: Nothing.
	End Rem
	Method RenderCells(x:Float, y:Float, gadget:duiGadget, corners:Int = True, sides:Int = True, middle:Int = True, wmod:Float = 0.0, hmod:Float = 0.0)
		If corners
			RenderCell(0, x, y, gadget, wmod, hmod)
			RenderCell(2, x, y, gadget, wmod, hmod)
			RenderCell(6, x, y, gadget, wmod, hmod)
			RenderCell(8, x, y, gadget, wmod, hmod)
		End If
		If sides
			RenderCell(1, x, y, gadget, wmod, hmod)
			RenderCell(3, x, y, gadget, wmod, hmod)
			RenderCell(5, x, y, gadget, wmod, hmod)
			RenderCell(7, x, y, gadget, wmod, hmod)
		End If
		If middle
			RenderCell(4, x, y, gadget, wmod, hmod)
		End If
	End Method
	
	Rem
		bbdoc: Set the render quad by the given cell.
		returns: The section for the given cell, or Null if the given cell was invalid.
	End Rem
	Method GetRenderAreaFromCell:duiThemeSection(cell:Int, x:Float Var, y:Float Var, x2:Float Var, y2:Float Var, gadget:duiGadget, wmod:Float = 0.0, hmod:Float = 0.0)
		Local section:duiThemeSection
		Local width:Float, height:Float
		Local gwidth:Float = gadget.m_width, gheight:Float = gadget.m_height
		Select cell
			Case 0 ' Top-left corner
				section = m_corner_topleft
				width = section.m_width
				height = section.m_height
			Case 1 ' Top side
				section = m_side_top
				x:+ section.m_width
				width = gwidth - (section.m_width * 2)
				height = section.m_height
			Case 2	' Top-right corner
				section = m_corner_topright
				x:+ gwidth - section.m_width
				width = section.m_width
				height = section.m_height
			Case 3 ' Left side
				section = m_side_left
				y:+ section.m_height
				width = section.m_width
				height = gheight - (section.m_height * 2)
			Case 4 ' Middle
				section = m_middle
				x:+ section.m_width
				y:+ section.m_height
				width = gwidth - (section.m_width * 2)
				height = gheight - (section.m_height * 2)
			Case 5 ' Right side
				section = m_side_right
				x:+ gwidth - section.m_width
				y:+ section.m_height
				width = section.m_width
				height = gheight - (section.m_height * 2)
			Case 6 ' Bottom-left corner
				section = m_corner_bottomleft
				y:+ gheight - section.m_height
				width = section.m_width
				height = section.m_height
			Case 7 ' Bottom side
				section = m_side_bottom
				x:+ section.m_width
				y:+ gheight - section.m_height
				width = gwidth - (section.m_width * 2)
				height = section.m_height
			Case 8 ' Bottom-right corner
				section = m_corner_bottomright
				x:+ gwidth - section.m_width
				y:+ gheight - section.m_height
				width = section.m_width
				height = section.m_height
		End Select
		If section
			width:+ wmod
			height:+ hmod
			x2 = x + width
			y2 = y + height
		End If
		Return section
	End Method
	
'#end region Rendering
	
'#region Collections
	
	Rem
		bbdoc: Clear the renderer's held sections.
		returns: Nothing.
	End Rem
	Method Clear()
		Super.Clear()
		m_corner_topleft = Null
		m_corner_topright = Null
		m_corner_bottomleft = Null
		m_corner_bottomright = Null
		m_side_top = Null
		m_side_left = Null
		m_side_right = Null
		m_side_bottom = Null
		m_middle = Null
	End Method
	
'#end region Collections
	
End Type

Rem
	bbdoc: duct ui gadget section renderer.
End Rem
Type duiSectionRenderer Extends duiBaseThemeRenderer
	
	Rem
		bbdoc: Create a new section renderer.
		returns: The new section renderer (itself).
		about: This will clear any sections held by the renderer.
	End Rem
	Method Create:duiSectionRenderer(theme:duiTheme, basestructure:String)
		_Init(theme, basestructure)
		Return Self
	End Method
	
End Type

Rem
	bbdoc: duct ui cursor renderer.
End Rem
Type duiCursorRenderer Extends duiBaseThemeRenderer
	
	Field m_normal:duiThemeSection, m_over:duiThemeSection, m_down:duiThemeSection, m_textover:duiThemeSection
	
	Rem
		bbdoc: Create a cursor renderer.
		returns: The new cursor renderer (itself).
		about: This method will throw a string as an exception if the given theme is Null (see #SetTheme).
	End Rem
	Method Create:duiCursorRenderer(theme:duiTheme, basestructure:String)
		_Init(theme, basestructure)
		LoadSections()
		Return Self
	End Method
	
'#region Sections
	
	Rem
		bbdoc: Load the mouse sections from the renderer's theme.
		returns: Nothing.
	End Rem
	Method LoadSections()
		Local set:duiThemeSectionSet = GetSectionSetFromStructure("", True)
		m_normal = GetSectionFromSet(set, "normal", False)
		m_over = GetSectionFromSet(set, "over", False)
		m_down = GetSectionFromSet(set, "down", False)
		m_textover = GetSectionFromSet(set, "textover", False)
	End Method
	
'#end region Sections
	
'#region Rendering
	
	Rem
		bbdoc: Render the given cursortype.
		returns: Nothing.
	End Rem
	Method RenderCursor(cursortype:Int, x:Float, y:Float)
		Local section:duiThemeSection
		Local x2:Float, y2:Float
		If cursortype > -1 And cursortype <= dui_CURSOR_TEXTOVER
			section = GetRenderAreaFromCursorType(cursortype, x, y, x2, y2)
			RenderArea(x, y, x2, y2, section)
		End If
	End Method
	
	Rem
		bbdoc: Set the render quad by the given cell.
		returns: The section for the given cell, or Null if the given cell was invalid.
	End Rem
	Method GetRenderAreaFromCursorType:duiThemeSection(cursortype:Int, x:Float Var, y:Float Var, x2:Float Var, y2:Float Var)
		Local section:duiThemeSection
		Select cursortype
			Case dui_CURSOR_NORMAL
				section = m_normal
				'x = x
				'y = y
			Case dui_CURSOR_MOUSEOVER
				section = m_over
				x:- 5.0
				'y = y
			Case dui_CURSOR_MOUSEDOWN
				section = m_down
				x:- 5.0
				'y = y
			Case dui_CURSOR_TEXTOVER
				section = m_textover
				x:- (section.m_width / 2.0)
				y:- (section.m_height / 2.0)
		End Select
		x2 = x + section.m_width
		y2 = y + section.m_height
		Return section
	End Method
	
'#end region Rendering
	
'#region Collections
	
	Rem
		bbdoc: Clear the renderer's held sections.
		returns: Nothing.
	End Rem
	Method Clear()
		Super.Clear()
		m_normal = Null
		m_over = Null
		m_down = Null
		m_textover = Null
	End Method
	
'#end region Collections
	
End Type

Rem
	bbdoc: #duiScrollbar renderer.
End Rem
Type duiScrollbarRenderer Extends duiBaseThemeRenderer
	
	Const sid_background:Int = 1
	Const sid_button_left:Int = 2, sid_button_right:Int = 3, sid_button_up:Int = 4, sid_button_down:Int = 5
	Const sid_grab_vertical_top:Int = 6, sid_grab_vertical_middle:Int = 7, sid_grab_vertical_bottom:Int = 8
	Const sid_grab_horizontal_left:Int = 9, sid_grab_horizontal_middle:Int = 10, sid_grab_horizontal_right:Int = 11
	
	Const sid_button_gfirst:Int = 20, sid_button_gsecond:Int = 21
	
	Field m_background:duiThemeSection
	Field m_button_left:duiThemeSection, m_button_right:duiThemeSection, m_button_up:duiThemeSection, m_button_down:duiThemeSection
	Field m_grab_vertical_top:duiThemeSection, m_grab_vertical_middle:duiThemeSection, m_grab_vertical_bottom:duiThemeSection
	Field m_grab_horizontal_left:duiThemeSection, m_grab_horizontal_middle:duiThemeSection, m_grab_horizontal_right:duiThemeSection
	
	Rem
		bbdoc: Create a scrollbar renderer.
		returns: The new scrollbar renderer (itself).
		about: This method will throw a string as an exception if the given theme is Null (see #SetTheme).
	End Rem
	Method Create:duiScrollbarRenderer(theme:duiTheme, basestructure:String)
		_Init(theme, basestructure)
		LoadSections()
		Return Self
	End Method
	
'#region Sections
	
	Rem
		bbdoc: Load the sections from the renderer's theme.
		returns: Nothing.
	End Rem
	Method LoadSections()
		m_background = GetSectionFromStructure("background", True)
		Local set:duiThemeSectionSet = GetSectionSetFromStructure("button", True)
		m_button_left = GetSectionFromSet(set, "left", False)
		m_button_right = GetSectionFromSet(set, "right", False)
		m_button_up = GetSectionFromSet(set, "up", False)
		m_button_down = GetSectionFromSet(set, "down", False)
		set = GetSectionSetFromStructure("grab.vertical", True)
		m_grab_vertical_top = GetSectionFromSet(set, "top", False)
		m_grab_vertical_middle = GetSectionFromSet(set, "middle", False)
		m_grab_vertical_bottom = GetSectionFromSet(set, "bottom", False)
		set = GetSectionSetFromStructure("grab.horizontal", True)
		m_grab_horizontal_left = GetSectionFromSet(set, "left", False)
		m_grab_horizontal_middle = GetSectionFromSet(set, "middle", False)
		m_grab_horizontal_right = GetSectionFromSet(set, "right", False)
	End Method
	
'#end region Sections
	
'#region Rendering
	
	Rem
		bbdoc: Render the given section id.
		returns: Nothing.
	End Rem
	Method RenderSection(sid:Int, x:Float, y:Float, scrollbar:duiScrollBar)
		Local x2:Float, y2:Float
		If sid > - 1 And sid <= sid_grab_horizontal_right Or sid = sid_button_gfirst Or sid = sid_button_gsecond
			Local section:duiThemeSection = GetRenderAreaFromSectionID(sid, x, y, x2, y2, scrollbar)
			RenderArea(x, y, x2, y2, section)
		End If
	End Method
	
	Rem
		bbdoc: Render all the sections.
		returns: Nothing.
	End Rem
	Method RenderFull(x:Float, y:Float, scrollbar:duiScrollBar, background:Int = True, buttons:Int = True, grabber:Int = True)
		Local relx:Float = x + scrollbar.m_x
		Local rely:Float = y + scrollbar.m_y
		If background
			RenderSection(sid_background, relx, rely, scrollbar)
		End If
		If buttons
			RenderSection(sid_button_gfirst, relx, rely, scrollbar)
			RenderSection(sid_button_gsecond, relx, rely, scrollbar)
		End If
		If grabber
			Select scrollbar.m_align
				Case dui_ALIGN_VERTICAL
					RenderSection(sid_grab_vertical_top, relx, y, scrollbar)
					RenderSection(sid_grab_vertical_middle, relx, y, scrollbar)
					RenderSection(sid_grab_vertical_bottom, relx, y, scrollbar)
				Case dui_ALIGN_HORIZONTAL
					RenderSection(sid_grab_horizontal_left, x, rely, scrollbar)
					RenderSection(sid_grab_horizontal_middle, x, rely, scrollbar)
					RenderSection(sid_grab_horizontal_right, x, rely, scrollbar)
			End Select
		End If
	End Method
	
	Rem
		bbdoc: Set the render quad by the given cell.
		returns: The section for the given cell, or Null if the given cell was invalid.
	End Rem
	Method GetRenderAreaFromSectionID:duiThemeSection(sid:Int, x:Float Var, y:Float Var, x2:Float Var, y2:Float Var, scrollbar:duiScrollBar)
		Local section:duiThemeSection, width:Float, height:Float
		Local gwidth:Float = scrollbar.m_width, gheight:Float = scrollbar.m_height
		Select scrollbar.m_align
			Case dui_ALIGN_VERTICAL
				Select sid
					Case sid_background
						section = m_background
						'x = x
						y:+ m_button_up.m_height
						width = gwidth
						height = gheight - (m_button_up.m_height + m_button_down.m_height)
						
					Case sid_button_up, sid_button_gfirst
						section = m_button_up
						'x = x
						'y = y
						width = section.m_width
						height = section.m_height
					Case sid_button_down, sid_button_gsecond
						section = m_button_down
						'x = x
						y:+ gheight - section.m_height
						width = section.m_width
						height = section.m_height
						
					Case sid_grab_vertical_top
						section = m_grab_vertical_top
						'x = x
						y:+ scrollbar.m_start
						width = section.m_width
						height = section.m_height
					Case sid_grab_vertical_middle
						section = m_grab_vertical_middle
						'x = x
						y:+ scrollbar.m_start + m_grab_vertical_top.m_height
						width = gwidth
						height = scrollbar.m_length - (m_grab_vertical_top.m_height + m_grab_vertical_bottom.m_height)
					Case sid_grab_vertical_bottom
						section = m_grab_vertical_bottom
						'x = x
						y:+ scrollbar.m_start + (scrollbar.m_length - section.m_height)
						width = section.m_width
						height = section.m_height
				End Select
			Case dui_ALIGN_HORIZONTAL
				Select sid
					Case sid_background
						section = m_background
						x:+ m_button_left.m_width
						'y = y
						width = gwidth - (m_button_left.m_width + m_button_right.m_width)
						height = gheight
						
					Case sid_button_left, sid_button_gfirst
						section = m_button_left
						'x = x
						'y = y
						width = section.m_width
						height = section.m_height
					Case sid_button_right, sid_button_gsecond
						section = m_button_right
						x:+ gwidth - section.m_width
						'y = y
						width = section.m_width
						height = section.m_height
						
					Case sid_grab_horizontal_left
						section = m_grab_horizontal_left
						x:+ scrollbar.m_start
						'y = y
						width = section.m_width
						height = section.m_height
					Case sid_grab_horizontal_middle
						section = m_grab_horizontal_middle
						x:+ scrollbar.m_start + (m_grab_horizontal_left.m_width)
						'y = y
						width = scrollbar.m_length - (m_grab_horizontal_left.m_width + m_grab_horizontal_right.m_width)
						height = gheight
					Case sid_grab_horizontal_right
						section = m_grab_horizontal_right
						x:+ scrollbar.m_start + (scrollbar.m_length - section.m_width)
						'y = y
						width = section.m_width
						height = section.m_height
				End Select
		End Select
		x2 = x + width
		y2 = y + height
		Return section
	End Method
	
'#end region (Rendering)
	
'#region Collections
	
	Rem
		bbdoc: Clear the renderer's held sections.
		returns: Nothing.
	End Rem
	Method Clear()
		Super.Clear()
		m_background = Null
		m_button_left = Null
		m_button_right = Null
		m_button_up = Null
		m_button_down = Null
		m_grab_vertical_top = Null
		m_grab_vertical_middle = Null
		m_grab_vertical_bottom = Null
		m_grab_horizontal_left = Null
		m_grab_horizontal_middle = Null
		m_grab_horizontal_right = Null
	End Method
	
'#end region (Collections)
	
End Type

Rem
	bbdoc: #duiSlider renderer.
End Rem
Type duiSliderRenderer Extends duiBaseThemeRenderer
	
	Const sid_background:Int = 1
	Const sid_grab_vertical_top:Int = 2, sid_grab_vertical_middle:Int = 3, sid_grab_vertical_bottom:Int = 4
	Const sid_grab_horizontal_left:Int = 5, sid_grab_horizontal_middle:Int = 6, sid_grab_horizontal_right:Int = 7
	
	Field m_background:duiThemeSection
	Field m_grab_vertical_top:duiThemeSection, m_grab_vertical_middle:duiThemeSection, m_grab_vertical_bottom:duiThemeSection
	Field m_grab_horizontal_left:duiThemeSection, m_grab_horizontal_middle:duiThemeSection, m_grab_horizontal_right:duiThemeSection
	
	Rem
		bbdoc: Create a slider renderer.
		returns: The new slider renderer (itself).
		about: This method will throw a string as an exception if the given theme is Null (see #SetTheme).
	End Rem
	Method Create:duiSliderRenderer(theme:duiTheme, basestructure:String)
		_Init(theme, basestructure)
		LoadSections()
		Return Self
	End Method
	
'#region Sections
	
	Rem
		bbdoc: Load the sections from the renderer's theme.
		returns: Nothing.
	End Rem
	Method LoadSections()
		m_background = GetSectionFromStructure("background", True)
		Local set:duiThemeSectionSet = GetSectionSetFromStructure("grab.vertical", True)
		m_grab_vertical_top = GetSectionFromSet(set, "top", False)
		m_grab_vertical_middle = GetSectionFromSet(set, "middle", False)
		m_grab_vertical_bottom = GetSectionFromSet(set, "bottom", False)
		set = GetSectionSetFromStructure("grab.horizontal", True)
		m_grab_horizontal_left = GetSectionFromSet(set, "left", False)
		m_grab_horizontal_middle = GetSectionFromSet(set, "middle", False)
		m_grab_horizontal_right = GetSectionFromSet(set, "right", False)
	End Method
	
'#end region (Sections)
	
'#region Rendering
	
	Rem
		bbdoc: Render the given section id.
		returns: Nothing.
	End Rem
	Method RenderSection(sid:Int, x:Float, y:Float, slider:duiSlider)
		Local x2:Float, y2:Float
		If sid > -1 And sid <= sid_grab_horizontal_right
			Local section:duiThemeSection = GetRenderAreaFromSectionID(sid, x, y, x2, y2, slider)
			RenderArea(x, y, x2, y2, section)
		End If
	End Method
	
	Rem
		bbdoc: Render all the sections.
		returns: Nothing.
	End Rem
	Method RenderFull(x:Float, y:Float, slider:duiSlider, background:Int = True, grabber:Int = True)
		Local relx:Float = x + slider.m_x
		Local rely:Float = y + slider.m_y
		If background
			RenderSection(sid_background, x, y, slider)
		End If
		If grabber
			Select slider.m_align
				Case dui_ALIGN_VERTICAL
					RenderSection(sid_grab_vertical_top, relx, y, slider)
					RenderSection(sid_grab_vertical_middle, relx, y, slider)
					RenderSection(sid_grab_vertical_bottom, relx, y, slider)
				Case dui_ALIGN_HORIZONTAL
					RenderSection(sid_grab_horizontal_left, x, rely, slider)
					RenderSection(sid_grab_horizontal_middle, x, rely, slider)
					RenderSection(sid_grab_horizontal_right, x, rely, slider)
			End Select
		End If
	End Method
	
	Rem
		bbdoc: Set the render quad by the given cell.
		returns: The section for the given cell, or Null if the given cell was invalid.
	End Rem
	Method GetRenderAreaFromSectionID:duiThemeSection(sid:Int, x:Float Var, y:Float Var, x2:Float Var, y2:Float Var, slider:duiSlider)
		Local section:duiThemeSection, width:Float, height:Float
		Local gwidth:Float = slider.m_width, gheight:Float = slider.m_height
		Select slider.m_align
			Case dui_ALIGN_VERTICAL
				Select sid
					Case sid_background
						section = m_background
						x:+ slider.m_sliderx + 5
						y:+ slider.m_slidery
						width = 5
						height = slider.m_sliderlength
						
					Case sid_grab_vertical_top
						section = m_grab_vertical_top
						'x = x
						y:+ slider.m_start
						width = section.m_width
						height = section.m_height
					Case sid_grab_vertical_middle
						section = m_grab_vertical_middle
						'x = x
						y:+ slider.m_start + m_grab_vertical_top.m_height
						width = gwidth
						height = slider.m_length - (m_grab_vertical_top.m_height + m_grab_vertical_bottom.m_height)
					Case sid_grab_vertical_bottom
						section = m_grab_vertical_bottom
						'x = x
						y:+ slider.m_start + (slider.m_length - section.m_height)
						width = section.m_width
						height = section.m_height
				End Select
			Case dui_ALIGN_HORIZONTAL
				Select sid
					Case sid_background
						section = m_background
						x:+ slider.m_sliderx
						y:+ slider.m_slidery + 5
						width = slider.m_sliderlength
						height = 5
						
					Case sid_grab_horizontal_left
						section = m_grab_horizontal_left
						x:+ slider.m_start
						'y = y
						width = section.m_width
						height = section.m_height
					Case sid_grab_horizontal_middle
						section = m_grab_horizontal_middle
						x:+ slider.m_start + (m_grab_horizontal_left.m_width)
						'y = y
						width = slider.m_length - (m_grab_horizontal_left.m_width + m_grab_horizontal_right.m_width)
						height = gheight
					Case sid_grab_horizontal_right
						section = m_grab_horizontal_right
						x:+ slider.m_start + (slider.m_length - section.m_width)
						'y = y
						width = section.m_width
						height = section.m_height
				End Select
		End Select
		x2 = x + width
		y2 = y + height
		Return section
	End Method
	
'#end region Rendering
	
'#region Collections
	
	Rem
		bbdoc: Clear the renderer's held sections.
		returns: Nothing.
	End Rem
	Method Clear()
		Super.Clear()
		m_background = Null
		m_grab_vertical_top = Null
		m_grab_vertical_middle = Null
		m_grab_vertical_bottom = Null
		m_grab_horizontal_left = Null
		m_grab_horizontal_middle = Null
		m_grab_horizontal_right = Null
	End Method
	
'#end region Collections
	
End Type

