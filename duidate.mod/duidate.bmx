
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
bbdoc: dui date module
about: This module uses the Modified Julian Date (MJD) format.
End Rem
Module duct.duidate

ModuleInfo "Version: 1.01"
ModuleInfo "Copyright: Liam McGuigan (FryGUI creator)"
ModuleInfo "Copyright: Tim Howard (dui is a heavily modified FryGUI)"
ModuleInfo "License: MIT"

ModuleInfo "History: Version 1.01"
ModuleInfo "History: Cleanup"
ModuleInfo "History: Version 1.0"
ModuleInfo "History: "

' Used modules
Import duct.duimisc

Private
Global __weekdays:String[] = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
Global __months:String[] = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]

Public
Const dui_FULL_DATE:Int = 0
Const dui_SHORT_DATE:Int = 1
Const dui_NUMERICAL_DATE:Int = 2

Rem
	bbdoc: Get the weekday as a string.
	returns: A string containing the day of the week.
	about: Use @_size to indicate the number of characters to return, 0 for full string.
End Rem
Function dui_WeekdayAsString:String(day:Int, _month:Int, year:Int, size:Int = 0)
	Local str:String = __weekdays[dui_WeekdayAsInt(day, _month, year)]
	If size = 0
		size = str.Length
	End If
	
	Return str[..size]
End Function

Rem
	bbdoc: Get the weekday as an integer.
	returns: An integer containing the day of the week, index (zero) based.
	about: Uses Zeller's Congruence.
End Rem
Function dui_WeekdayAsInt:Int(day:Int, _month:Int, year:Int)
	Local j:Int, k:Int, h:Int
	
	' Update year and month if in January or February
	If _month < 3
		_month:+12
		year:-1
	End If
	
	' Get century (j) and year of the century (k)
	j = year / 100
	k = year Mod 100
	
	' Calculate the day of the week
	h = (day + (((_month + 1) * 26) / 10) + k + (k / 4) + (j / 4) + (5 * j) + 6) Mod 7
	
	Return h
	
End Function

Rem
	bbdoc: Get the type of a weekday.
	returns: 1 if the weekday is in the week, or 0 if it is at the end (Sunday or Saturday).
	about @_day is index (zero) based.
End Rem
Function dui_WeekdayType:Int(day:Int)
	If day = 0 Or day = 6
		Return 0
	Else
		Return 1
	End If
End Function

Rem
	bbdoc: Get weekday from a Julian day.
	returns: A string containing the day of the week.
	about: Use @_size to indicate the number of characters to return, 0 for full string.
End Rem
Function dui_JulianWeekdayAsString:String(julian:Int, size:Int = 0)
	Local str:String = __weekdays[dui_JulianWeekdayAsInt(julian)]
	
	If size = 0
		size = str.length
	End If
	
	Return str[..size]
End Function

Rem
	bbdoc: Get the weekday from a Julian day as an integer.
	returns: The index (zero based) for that day in the week.
End Rem
Function dui_JulianWeekdayAsInt:Int(julian:Int)
	Return (julian + 1) Mod 7
End Function

Rem
	bbdoc: Get the Julian day for a given date.
	returns: An integer containing the Julian day of the given date.
	about: Zero Day is January 1st, 1900.
End Rem
Function dui_JulianDayAsInt:Int(day:Int, _month:Int, year:Int)
	Local a:Int, y:Int, m:Int, j:Int
	
	a = (14 - _month) / 12
	y = (year + 4800) - a
	m = (_month + (12 * a)) - 3
	
	j = day + (((153 * m) + 2) / 5) + (365 * y) + (y / 4) - (y / 100) + (y / 400) - 2447066
	
	Return j
End Function

Rem
	bbdoc: Get the Julian day from a date string.
	returns: an integer containing the Julian day of any given date
	about: Zero Day is January 1st, 1900. Date format is DD/MM/YYYY.
End Rem
Function dui_JulianDayFromString:Int(date:String)
	Local dmy:String[], d:Int, m:Int, y:Int
	
	dmy = dui_SplitString(date, "/")
	d = Int(dmy[0])
	m = Int(dmy[1])
	y = Int(dmy[2])
	
	Return(dui_JulianDayAsInt(d, m, y))
End Function

Rem
	bbdoc: Get the date from a Julian date.
	returns: Nothing (arguments @_day, @_month and @_year will contain the date).
End Rem
Function dui_JulianDate(julian:Int, day:Int Var, _month:Int Var, year:Int Var)
	Local a:Int, b:Int, c:Int, d:Int, e:Int, m:Int
	
	a = julian + 2447065
	b = ((4 * a) + 3) / 146097
	c = a - ((b * 146097) / 4)
	d = ((4 * c) + 3) / 1461
	e = c - ((1461 * d) / 4)
	m = ((5 * e) + 2) / 153
	
	day = e - (((153 * m) + 2) / 5) + 1
	_month = m + 3 - (12 * (m / 10))
	year = (b * 100) + d - 4800 + (m / 10)
End Function

Rem
	bbdoc: Increment or decrement a date by days.
	returns: Nothing (arguments @_day, @_month and @_year will contain the date).
End Rem
Function dui_MoveDate(day:Int Var, _month:Int Var, year:Int Var, inc:Int = 1)
	Local j:Int = dui_JulianDayAsInt(day, _month, year)
	
	j:+inc
	dui_JulianDate(j, day, _month, year)
End Function

Rem
	bbdoc: Get the string representation for a month.
	returns: A string for the given month (zero based) index, or Null if the month index was not within the range of a month index.
	about: Use @_full to get either the first three letters (False) or the whole month string (True).
End Rem
Function dui_MonthAsString:String(_month:Int, full:Int = True)
	If _month < 1 Or _month > 12
		Return Null
	End If
	
	If full = True
		Return(__months[_month - 1])
	Else
		Return(__months[_month - 1][..3])
	End If
End Function

Rem
	bbdoc: Get the number of days of a month in a given year.
	returns: An integer containing the number of days of a month in a given year.
End Rem
Function dui_MonthDays:Int(_month:Int, year:Int)
	Local date:Int, day:Int
	
	' First, get date of following month, subtract one
	dui_IncMonthYear(_month, year)
	date = dui_JulianDayAsInt(1, _month, year) - 1
	
	' Get new day from julian date
	dui_JulianDate(date, day, _month, year)
	
	Return day
End Function

Rem
	bbdoc: Get a calendar as an array of integers (indexes).
	returns: A [7][6] array of integers in the form [day][week], containing the calendar for the given month.
	about: Use the @_extend parameter to include days of previous and next months (True).
End Rem
Function dui_Calendar:Int[][] (_month:Int, year:Int, extend:Int = False)
	Local cal:Int[][], index:Int, wkday:Int, week:Int, _weekday:Int, days:Int
	
	cal = New Int[][7]
	For index = 0 To 6
		cal[index] = New Int[6]
	Next
	
	' Get weekday of first day
	_weekday = dui_WeekdayAsInt(1, _month, year)
	
	' Get number of days in month
	days = dui_MonthDays(_month, year)
	
	' Populate the calendar (index = day)
	For index = 0 To days - 1
		wkday = (_weekday + index) Mod 7
		week = (_weekday + index) / 7
		
		cal[wkday][week] = index + 1
	Next
	
	Return cal
End Function

Rem
	bbdoc: Get the occurences of a particular weekday in a time period.
	returns: An integer array, each element containing the MJD date of that weekday.
	about: @_days is the count of days to check (the check includes the @_start).
End Rem
Function dui_WeekdayOccurences:Int[] (start:Int, days:Int, _weekday:Int)
	Local startday:Int, results:Int[], _first:Int, index:Int, remain:Int
	
	' Exclude first day from days
	days:-1
	
	' Get weekday of start date
	startday = dui_JulianWeekdayAsInt(start)
	
	' Get date of first occurance (if any)
	_first = (_weekday + (7 * (_weekday < startday))) - startday
	
	' Add it to the array if the criteria is met
	If _first <= days
		results = results[..1]
		results[0] = start + _first
		
		' Find out how many remain
		remain = days - _first
		
		' Expand array
		results = results[..(1 + (remain / 7))]
		
		' Fill in values
		For index = 1 To (remain / 7)
			results[index] = start + _first + (index * 7)
		Next
	End If
	
	Return results
End Function

Rem
	bbdoc: Get a formatted string for the given date.
	returns: The date formatted as a string, or null if the format was not recognized.
	about @_format can be either dui_FULL_DATE, dui_SHORT_DATE or dui_NUMERICAL_DATE.
End Rem
Function dui_FormatDate:String(day:Int, _month:Int, year:Int, format:Int = dui_SHORT_DATE, _weekday:Int = False)
	Local result:String, ds:String, ms:String, ys:String
	
	If _weekday
		If format = dui_FULL_DATE
			If _weekday
				result = dui_WeekdayAsString(day, _month, year, 0) + " "
			End If
		Else If format = dui_SHORT_DATE Or format = dui_NUMERICAL_DATE
			If _weekday
				result = dui_WeekdayAsString(day, _month, year, 2) + " "
			End If
		End If
	End If
	
	Select format
		Case dui_FULL_DATE
			result:+day + " " + dui_MonthAsString(_month) + " " + year
		Case dui_SHORT_DATE
			ys = String(year + 1000)
			result:+day + " " + dui_MonthAsString(_month, False) + " " + ys[ys.Length - 2..ys.Length]
		Case dui_NUMERICAL_DATE
			ds = String(day)
			ms = String(_month)
			ys = String(year + 1000)
			ys = ys[ys.Length - 2..ys.Length]
			
			If day < 10 Then ds = "0" + ds
			If _month < 10 Then ms = "0" + ms
			
			result:+ds + "-" + ms + "-" + ys
			
		Default
			result = Null
	End Select
	
	Return result
End Function

Rem
	bbdoc: Get the Julian date as a formatted string.
	returns: The date formatted into a string.
End Rem
Function dui_JulianDateAsString:String(date:Int, format:Int = dui_SHORT_DATE, _weekday:Int = False)
	Local d:Int, m:Int, y:Int
	
	dui_JulianDate(date, d, m, y)
	Return dui_FormatDate(d, m, y, format, _weekday)
End Function
	
Rem
	bbdoc: Get the time in hours and minutes.
	returns: Nothing (@_hours and @_minutes will contain the time).
	about: Set @_daily to False to have more than 24 hours.
End Rem
Function dui_ClockTimeAsInts(mins:Int, hours:Int Var, minutes:Int Var, daily:Int = True)
	hours = mins / 60
	minutes = mins Mod 60
	
	If daily = True
		hours = hours Mod 24
	End If
End Function

Rem
	bbdoc: Get the time in string format.
	returns: A string containing the time in 24 hour format.
	about: Use @_lead to add a leading zero to the hours, if necessary. Set @_daily to False to have more than 24 hours.
End Rem
Function dui_ClockTimeAsString:String(mins:Int, lead:Int = False, daily:Int = True)
	Local hours:Int, minutes:Int, h:String, m:String
	
	dui_ClockTimeAsInts(mins, hours, minutes, daily)
	h = String(hours)
	m = String(minutes)
	
	If minutes < 10
		m = "0" + m
	End If
	If hours < 10 And lead = True
		h = "0" + h
	End If
	
	Return h + ":" + m
End Function

Rem
	bbdoc: Get the number of minutes from hour(s) and minute(s).
	returns: The number of minutes within the given time.
End Rem
Function dui_ClockTimeMinutes:Int(hours:Int, minutes:Int)
	Return minutes + (hours * 60)
End Function

Rem
	bbdoc: Get the number of minutes from a time string.
	returns: The number of minutes within the time, or 0 if @_clock is in the wrong format.
	about: @_clock format is 'HR:MIN'.
End Rem
Function dui_ClockTimeMinutesFromString:Int(clock:String)
	Local colon:Int, hours:Int, minutes:Int
	
	colon = clock.Find(":")
	If colon = -1
		Return 0
	End If
	
	hours = Int(clock[..colon])
	minutes = Int(clock[colon + 1..])
	
	Return dui_ClockTimeMinutes(hours, minutes)
End Function

Rem
	bbdoc: Increment the given minutes.
	returns: Nothing (@_mins will be modified).
	about: This function overlaps automatically to maintain 24 hour time.
End Rem
Function dui_IncMinutes(mins:Int Var, increment:Int = 1)
	mins:+increment
	mins = mins Mod 1440
End Function

Rem
	bbdoc: Increment the given milliseconds.
	returns: Nothing (@_millis will be modified).
	about: This function overlaps automatically to maintain 24 hour time.
End Rem
Function dui_IncMillisecs(millis:Int Var, increment:Int = 1)
	millis:+increment
	millis = millis Mod 86400000
End Function

Rem
	bbdoc: Increment time and date in milliseconds.
	returns: Nothing (@_millis and @_date will be modified)
	about: @_date will be incremented by the change in @_millis. This function overlaps to maintain 24 hour time, and updates the date.
End Rem
Function dui_IncMSTime(millis:Int Var, date:Int Var, increment:Int = 1)
	millis:+increment
	date:+(millis / 86400000)
	millis = millis Mod 86400000
End Function

Rem
	bbdoc: Increment the minutes and date.
	returns: Nothing (@_mins and @_date will be modified).
	about: @_date will be incremented by the change in @_mins. This function overlaps automatically, and also updates the date.
End Rem
Function dui_IncTime(mins:Int Var, date:Int Var, increment:Int = 1)
	mins:+increment
	date:+(mins / 1440)
	mins = mins Mod 1440
End Function

Rem
	bbdoc: Get minutes from milliseconds.
	returns: The given milliseconds in minutes.
End Rem
Function dui_MSToMin:Int(millis:Int)
	Return millis / 60000
End Function

Rem
	bbdoc: Get milliseconds from minutes.
	returns: The given minutes in milliseconds.
End Rem
Function dui_MinToMS:Int(mins:Int)
	Return mins * 60000
End Function

Rem
	bbdoc: Increment the number of months.
	returns: The incremented month.
	about: If @_month is incremented above 12, it will be wrapped around to 1.
End Rem
Function dui_IncMonths:Int(_month:Int, inc:Int = 1)
	Return (_month Mod 12) + inc
End Function

Rem
	bbdoc: Increment the months and years.
	returns: Nothing (@_month and _@year will be modified).
End Rem
Function dui_IncMonthYear(_month:Int Var, year:Int Var, inc:Int = 1)
	year:+(inc / 12)
	If _month + (inc Mod 12) > 12
		year:+1
	End If
	
	_month = dui_IncMonths(_month, inc)
End Function

Rem
	bbdoc: Increment the date by a number of years.
	returns: The incremented date.
End Rem
Function dui_IncDateYear:Int(date:Int, inc:Int)
	Local d:Int, m:Int, y:Int
	
	dui_JulianDate(date, d, m, y)
	y:+inc
	Return dui_JulianDayAsInt(d, m, y)
End Function

Rem
	bbdoc: The age of a person.
	returns: The age of the person.
	about: @_dob is the date of birthday for the person.
End Rem
Function dui_JulianAge:Int(date:Int, dob:Int)
	Local age:Int
	Local dd:Int, dm:Int, dy:Int
	Local bd:Int, bm:Int, by:Int
	
	If dob > date
		Return 0
	End If
	
	dui_JulianDate(date, dd, dm, dy)
	dui_JulianDate(dob, bd, bm, by)
	
	age = dy - by
	
	' Not yet reached a whole year
	If bm > dm Then age:-1
	If bm = dm And bd > dd Then age:-1
	
	Return age
End Function











	
	