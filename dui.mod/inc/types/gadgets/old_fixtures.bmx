
Rem
	fixtures.bmx (Contains: dui_FixtureList, dui_Fixture)
End Rem

Rem
	bbdoc: Fixture List Gadget
	about: A fixture list containing fixture information for a single day 
End Rem
Type dui_FixtureList Extends dui_Gadget

	'column width
	Field m_columnwidths:Int[] = [40, 0, 30, 30, 0, 60]	
	Field m_itemheight:Int						'item height
	
	Field gFixtures:TList = New TList		'	the list of fixtures / results
	
	Field gInfoColor:Int[] = [0, 0, 0]				'color of info bars (kick off times, scorelines, attendances)
	Field gInfoTextColor:Int[] = [255, 255, 255]	'color of info text
	Field gInfoAlpha:Float = 1.0				'alpha of info bars
	Field gInfoTextAlpha:Float = 1.0			'alpha of info text
			
	Field m_highlight:Int = -1					'mouse over item
	
	Field m_background:Int = True				'background
			
	Rem
		Render the table to the back buffer
	End Rem
	Method Render(x:Int, y:Int)
			
		If IsVisible() = True
			
			SetImageFont(m_font)
	
			'set up rendering locations
			Local relx:Int = m_x + x
			Local rely:Int = m_y + y
	
			'set up the table x location
			Local tX:Int
			
			'Add the data
			Local fixcount:Int = -1
			For Local fix:dui_Fixture = EachIn gFixtures
	
				'update fixture count
				fixcount:+ 1
				
				'backgrounds
				If m_background Then
									
					
					tX = 0
					
					For Local count:Int = 0 To 5
						Select count
							Case 0, 2, 3, 5
								.SetColor(gInfoColor[0], gInfoColor[1], gInfoColor[2])
								.SetAlpha(gInfoAlpha)
							Case 1, 4
								.SetColor(m_color[0], m_color[1], m_color[2])
								.SetAlpha(m_alpha)
						End Select					
					
						TProtogPrimitives.DrawRectangleToSize relx + tX, rely + (fixcount * (m_itemheight + 2)), m_columnwidths[count], m_itemheight
						tX = tX + 3 + m_columnwidths[count]
					Next
					
				End If
			
				'text						
				tX = 3
				For Local count:Int = 0 To 5
					Local text:String = ""
					
					Select count
						Case 0 text = fix.gKickOff
						Case 1 text = fix.m_home
						Case 2 If fix.m_hscore > -1 Then 							text = String(fix.m_hscore)
						Case 3 If fix.gAScore > -1 Then text = String(fix.gAScore)
						Case 4 text = fix.gAway
						Case 5 If fix.gAttendance > -1 Then text = String(fix.gAttendance)
					End Select
					
					If count = 1 Or count = 4 Then
						.SetColor(m_textcolor[0], m_textcolor[1], m_textcolor[2])
						.SetAlpha(m_textalpha)
					Else
						.SetColor(gInfoTextColor[0], gInfoTextColor[1], gInfoTextColor[2])
						.SetAlpha(gInfoTextAlpha)
					End If
								
					DrawText text, relx+tX, rely+3 + (fixcount * (m_itemheight + 2))
					tX = tX + 3 + m_columnwidths[count]
				Next
			Next


			Super.Render(x, y)
			
		End If

	End Method
	
	Rem
		Update when the mouse is over
	End Rem
	Method UpdateMouseOver(x:Int, y:Int)
	
		Local relx:Int = m_x + x
		Local iY:Int = m_y + y + 2
	
		super.UpdateMouseOver(x, y)
		
		'if inside the highlight area
		If dui_MouseIn(relx, iY, m_width, (m_height - (m_itemheight + 2))) Then
					
			'calculate the highlighted item from the MouseY position
			m_highlight = (MouseY() - iY) / (m_itemheight + 2)
			
		Else
			
			m_highlight = -1
			
		End If

	End Method
		
	Rem
		Update when the mouse is released
	End Rem
	Method UpdateMouseRelease(x:Int, y:Int)
	
		Local relx:Int = m_x + x
		Local iY:Int = m_y + y + 2
		
		super.UpdateMouseRelease(x, y)
		
		'if inside the highlight area, select an item
		If dui_MouseIn(relx, iY, m_width, (m_height - (m_itemheight + 2))) Then dui_CreateEvent(dui_EVENT_GADGETSELECT, Self, m_highlight, Null)

	End Method
			
	Rem
		bbdoc: Add a fixture to the list
		about: Adds a fixture or result to the fixture list, including related data
	End Rem
	Method AddFixture(kickoff:String, home:String, away:String, hscore:Int = -1, ascore:Int = -1, attendance:Int = -1)
	
		'create the team and add to the gadget
		Local fix:dui_Fixture = dui_Fixture.Create(kickoff, home, away, hscore, ascore, attendance)
		
		ListAddLast gFixtures, fix
		
		Refresh()
									
	End Method
	
	Rem
		bbdoc: Clear all fixtures from the list
	End Rem
	Method ClearFixtures()
		
		gFixtures.Clear()
		Refresh()
		
	End Method
	
	Rem
		bbdoc: Set the color of the gadget's information bars
		about: Sets the color of the gadget's info bar to the @RGB values specified.
	End Rem
	Method SetInfoColor(r:Int, g:Int, b:Int)
		
		gInfoColor = [r, g, b]
	
	End Method
	
	Rem
		bbdoc: Set the color of the gadget's info bar, using hexadecimal, e.g. @FFFF00
		about: The method will parse the string to determine the RGB values, and set the color.
	End Rem
	Method HexInfoColor(col:String)
	
		Local r:Int, g:Int, b:Int
		dui_HexColor(col, r, g, b)
		SetInfoColor(r, g, b)
		
	End Method
	
	Rem
		bbdoc: Set the info bar's text color
		about: Sets the color of the info bar's text, similar to setting the gadget color.
	End Rem
	Method SetInfoTextColor(r:Int, g:Int, b:Int)
		
		gInfoTextColor = [r, g, b]
	
	End Method
	
	Rem
		bbdoc: Set the info bar's text color using hexadecimal
		about: Uses hexadecimal to set the info text color. The method will parse the string and set the color.
	End Rem
	Method HexInfoTextColor(col:String)
	
		Local r:Int, g:Int, b:Int
		dui_HexColor(col, r, g, b)
		SetInfoTextColor(r, g, b)
	
	End Method
	
	Rem
		bbdoc: Set the alpha value of gadget's info bar
		about: Sets the alpha value of the gadget's info bar, allowing for transparency
	End Rem
	Method SetInfoAlpha(a:Float)
		
		gInfoAlpha = a
	
	End Method
	
	Rem
		bbdoc: Set the alpha value of gadget's info text
		about: Sets the alpha value of the gadget's info text, allowing for transparency
	End Rem
	Method SetInfoTextAlpha(a:Float)
		
		gInfoTextAlpha = a
	
	End Method
		
	Rem
		bbdoc: Set main background
		about: The main background is the box in which general items sit
	End Rem
	Method SetBackground(background:Int)
		
		m_background = background
		
	End Method

	Rem
		Refresh the column widths
	End Rem
	Method RefreshColumns()
	
		'set team name columns' widths
		'first, get the available space
		Local space:Int = (m_width - 160) - (15)
		
		m_columnwidths[1] = space / 2
		m_columnwidths[4] = space / 2
			
	End Method
	
	Rem
		Refresh the gadget's positional data
	End Rem
	Method Refresh()
	
		'get height data			
		m_height = ((gFixtures.Count() + 1) * (m_itemheight + 2)) - 2
	
	End Method
	
	Rem
		Create a Table gadget
	End Rem
	Function Create:dui_FixtureList(name:String, x:Int, y:Int, w:Int, ih:Int, parent:dui_Gadget)
	
		Local this:dui_FixtureList = New dui_FixtureList
				
		this._Init(name, x, y, w, 0, parent)
		
		this.RefreshColumns()
						
		this.m_itemheight = ih
		If ih = 0 Then this.m_itemheight = 20
		
		Return this
		
	End Function
	
	
End Type

Rem
	bbdoc: Create a table
	returns: a #dui_Table gadget
	about: Creates a table gadget with the specified @name, @heading and dimensions. The @parent will usually be a panel, but can be another
	gadget.
End Rem
Function dui_CreateFixtureList:dui_FixtureList(name:String, x:Int, y:Int, w:Int, ih:Int, parent:dui_Gadget = Null)

	If name = "" Then Return Null
	
	Local fix:dui_FixtureList = dui_FixtureList.Create(name, x, y, w, ih, parent)
	
	Return fix
	
End Function


Rem
	bbdoc: League team item
	about: A league team item contains the league data for each team
End Rem
Type dui_Fixture

	Field gKickOff:String			'Kick off time, 24 hour clock
	Field m_home:String				'Home team
	Field gAway:String				'Away team
	Field m_hscore:Int = -1			'Home score
	Field gAScore:Int = -1			'Away score
	Field gAttendance:Int = -1		'Attendance
		
	Rem
		Create the table item
	End Rem
	Function Create:dui_Fixture(kickoff:String, home:String, away:String, hscore:Int = -1, ascore:Int = -1, attendance:Int = -1)
		
		Local this:dui_Fixture = New dui_Fixture
		
		this.gKickOff = kickoff
		this.m_home = home
		this.gAway = away
		this.m_hscore = hscore
		this.gAScore = ascore
		this.gAttendance = attendance
				
		Return this
	
	End Function
	
End Type

	
