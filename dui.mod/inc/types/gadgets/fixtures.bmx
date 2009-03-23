

Rem
	bbdoc: Fixture List Gadget
	about: A fixture list containing fixture information for a single day 
End Rem
Type dui_TFixtureList Extends dui_TGadget

	'column width
	Field gWidth:Int[] = [40, 0, 30, 30, 0, 60]	
	Field gIH:Int						'item height
	
	Field gFixtures:TList = New TList		'	the list of fixtures / results
	
	Field gInfoColour:Int[] = [0, 0, 0]				'colour of info bars (kick off times, scorelines, attendances)
	Field gInfoTextColour:Int[] = [255, 255, 255]	'colour of info text
	Field gInfoAlpha:Float = 1.0				'alpha of info bars
	Field gInfoTextAlpha:Float = 1.0			'alpha of info text
			
	Field gHighlight:Int = -1					'mouse over item
	
	Field gBackground:Int = True				'background
			
	Rem
		Render the table to the back buffer
	End Rem
	Method Render(x:Int, y:Int)
			
		If Not gHidden
			
			SetImageFont gFont
	
			'set up rendering locations
			Local rX:Int = gX + x
			Local rY:Int = gY + y
	
			'set up the table x location
			Local tX:Int
			
			'Add the data
			Local fixcount:Int = -1
			For Local fix:dui_TFixture = EachIn gFixtures
	
				'update fixture count
				fixcount:+ 1
				
				'backgrounds
				If gBackground Then
									
					
					tX = 0
					
					For Local count:Int = 0 To 5
						Select count
							Case 0, 2, 3, 5
								.SetColor(gInfoColour[0], gInfoColour[1], gInfoColour[2])
								.SetAlpha(gInfoAlpha)
							Case 1, 4
								.SetColor(gColour[0], gColour[1], gColour[2])
								.SetAlpha(gAlpha)
						End Select					
					
						DrawRect rX + tX, rY + (fixcount * (gIH + 2)), gWidth[count], gIH
						tX = tX + 3 + gWidth[count]
					Next
					
				End If
			
				'text						
				tX = 3
				For Local count:Int = 0 To 5
					Local text:String = ""
					
					Select count
						Case 0 text = fix.gKickOff
						Case 1 text = fix.gHome
						Case 2 If fix.gHScore > -1 Then 							text = String(fix.gHScore)
						Case 3 If fix.gAScore > -1 Then text = String(fix.gAScore)
						Case 4 text = fix.gAway
						Case 5 If fix.gAttendance > -1 Then text = String(fix.gAttendance)
					End Select
					
					If count = 1 Or count = 4 Then
						.SetColor(gTextColour[0], gTextColour[1], gTextColour[2])
						.SetAlpha(gTextAlpha)
					Else
						.SetColor(gInfoTextColour[0], gInfoTextColour[1], gInfoTextColour[2])
						.SetAlpha(gInfoTextAlpha)
					End If
								
					DrawText text, rX+tX, rY+3 + (fixcount * (gIH + 2))
					tX = tX + 3 + gWidth[count]
				Next
			Next


			Super.Render(x, y)
			
		End If

	End Method
	
	Rem
		Update when the mouse is over
	End Rem
	Method UpdateMouseOver(x:Int, y:Int)
	
		Local rX:Int = gX + x
		Local iY:Int = gY + y + 2
	
		super.UpdateMouseOver(x, y)
		
		'if inside the highlight area
		If dui_MouseIn(rX, iY, gW, (gH - (gIH + 2))) Then
					
			'calculate the highlighted item from the MouseY position
			gHighlight = (MouseY() - iY) / (gIH + 2)
			
		Else
			
			gHighlight = -1
			
		End If

	End Method
		
	Rem
		Update when the mouse is released
	End Rem
	Method UpdateMouseRelease(x:Int, y:Int)
	
		Local rX:Int = gX + x
		Local iY:Int = gY + y + 2
		
		super.UpdateMouseRelease(x, y)
		
		'if inside the highlight area, select an item
		If dui_MouseIn(rX, iY, gW, (gH - (gIH + 2))) Then dui_CreateEvent(dui_EVENT_GADGETSELECT, Self, gHighlight, Null)

	End Method
			
	Rem
		bbdoc: Add a fixture to the list
		about: Adds a fixture or result to the fixture list, including related data
	End Rem
	Method AddFixture(kickoff:String, home:String, away:String, hscore:Int = -1, ascore:Int = -1, attendance:Int = -1)
	
		'create the team and add to the gadget
		Local fix:dui_TFixture = dui_TFixture.Create(kickoff, home, away, hscore, ascore, attendance)
		
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
		bbdoc: Set the colour of the gadget's information bars
		about: Sets the colour of the gadget's info bar to the @RGB values specified.
	End Rem
	Method SetInfoColour(r:Int, g:Int, b:Int)
		
		gInfoColour = [r, g, b]
	
	End Method
	
	Rem
		bbdoc: Set the colour of the gadget's info bar, using hexadecimal, e.g. @FFFF00
		about: The method will parse the string to determine the RGB values, and set the colour.
	End Rem
	Method HexInfoColour(col:String)
	
		Local r:Int, g:Int, b:Int
		dui_HexColour(col, r, g, b)
		SetInfoColour(r, g, b)
		
	End Method
	
	Rem
		bbdoc: Set the info bar's text colour
		about: Sets the colour of the info bar's text, similar to setting the gadget colour.
	End Rem
	Method SetInfoTextColour(r:Int, g:Int, b:Int)
		
		gInfoTextColour = [r, g, b]
	
	End Method
	
	Rem
		bbdoc: Set the info bar's text colour using hexadecimal
		about: Uses hexadecimal to set the info text colour. The method will parse the string and set the colour.
	End Rem
	Method HexInfoTextColour(col:String)
	
		Local r:Int, g:Int, b:Int
		dui_HexColour(col, r, g, b)
		SetInfoTextColour(r, g, b)
	
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
		
		gBackground = background
		
	End Method

	Rem
		Refresh the column widths
	End Rem
	Method RefreshColumns()
	
		'set team name columns' widths
		'first, get the available space
		Local space:Int = (gW - 160) - (15)
		
		gWidth[1] = space / 2
		gWidth[4] = space / 2
			
	End Method
	
	Rem
		Refresh the gadget's positional data
	End Rem
	Method Refresh()
	
		'get height data			
		gH = ((gFixtures.Count() + 1) * (gIH + 2)) - 2
	
	End Method
	
	Rem
		Create a Table gadget
	End Rem
	Function Create:dui_TFixtureList(name:String, x:Int, y:Int, w:Int, ih:Int, parent:dui_TGadget)
	
		Local this:dui_TFixtureList = New dui_TFixtureList
				
		this.PopulateGadget(name, x, y, w, 0, parent)
		
		this.RefreshColumns()
						
		this.gIH = ih
		If ih = 0 Then this.gIH = 20
		
		Return this
		
	End Function
	
	
End Type

Rem
	bbdoc: Create a table
	returns: a #dui_TTable gadget
	about: Creates a table gadget with the specified @name, @heading and dimensions. The @parent will usually be a panel, but can be another
	gadget.
End Rem
Function dui_CreateFixtureList:dui_TFixtureList(name:String, x:Int, y:Int, w:Int, ih:Int, parent:dui_TGadget = Null)

	If name = "" Then Return Null
	
	Local fix:dui_TFixtureList = dui_TFixtureList.Create(name, x, y, w, ih, parent)
	
	Return fix
	
End Function


Rem
	bbdoc: League team item
	about: A league team item contains the league data for each team
End Rem
Type dui_TFixture

	Field gKickOff:String			'Kick off time, 24 hour clock
	Field gHome:String				'Home team
	Field gAway:String				'Away team
	Field gHScore:Int = -1			'Home score
	Field gAScore:Int = -1			'Away score
	Field gAttendance:Int = -1		'Attendance
		
	Rem
		Create the table item
	End Rem
	Function Create:dui_TFixture(kickoff:String, home:String, away:String, hscore:Int = -1, ascore:Int = -1, attendance:Int = -1)
		
		Local this:dui_TFixture = New dui_TFixture
		
		this.gKickOff = kickoff
		this.gHome = home
		this.gAway = away
		this.gHScore = hscore
		this.gAScore = ascore
		this.gAttendance = attendance
				
		Return this
	
	End Function
	
End Type

	
