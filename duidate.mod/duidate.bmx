
' Copyright (c) 2009 Tim Howard
' 
' Permission is hereby granted, free of charge, to any person obtaining a copy
' of this software and associated documentation files (the "Software"), to deal
' in the Software without restriction, including without limitation the rights
' to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
' copies of the Software, and to permit persons to whom the Software is
' furnished to do so, subject to the following conditions:
' 
' The above copyright notice and this permission notice shall be included in
' all copies or substantial portions of the Software.
' 
' THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
' IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
' FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
' AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
' LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
' OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
' THE SOFTWARE.
' 

SuperStrict

Rem
bbdoc: dui date module
about: This module uses the Modified Julian Date (MJD) format.
End Rem
Module duct.duidate

ModuleInfo "Version: 1.0"
ModuleInfo "Copyright: Liam McGuigan (FryGUI creator), Tim Howard (dui is a largely modified FryGUI)"
ModuleInfo "License: MIT"

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
Function dui_WeekdayAsString:String(_day:Int, _month:Int, _year:Int, _size:Int = 0)
	
	Local _str:String = __weekdays[dui_WeekdayAsInt(_day, _month, _year)]
	
	If _size = 0 Then _size = _str.Length
	
	Return _str[.._size]
	
End Function

Rem
	bbdoc: Get the weekday as an integer.
	returns: An integer containing the day of the week, index (zero) based.
	about: Uses Zeller's Congruence.
End Rem
Function dui_WeekdayAsInt:Int(_day:Int, _month:Int, _year:Int)
	Local J:Int, K:Int, h:Int
	
	' Update year and month if in January or February
	If _month < 3
		_month:+12
		_year:-1
	End If
	
	' Get century (J) and year of the century (K)
	J = _year / 100
	K = _year Mod 100
	
	' Calculate the day of the week
	h = (_day + (((_month + 1) * 26) / 10) + K + (K / 4) + (J / 4) + (5 * J) + 6) Mod 7
	
	Return h
	
End Function

Rem
	bbdoc: Get the type of a weekday.
	returns: 1 if the weekday is in the week, or 0 if it is at the end (Sunday or Saturday).
	about @_day is index (zero) based.
End Rem
Function dui_WeekdayType:Int(_day:Int)
	
	If _day = 0 Or _day = 6
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
Function dui_JulianWeekdayAsString:String(_julian:Int, _size:Int = 0)
	
	Local _str:String = __weekdays[dui_JulianWeekdayAsInt(_julian)]
	
	If _size = 0 Then _size = _str.length
	
	Return _str[.._size]
	
End Function

Rem
	bbdoc: Get the weekday from a Julian day as an integer.
	returns: The index (zero based) for that day in the week.
End Rem
Function dui_JulianWeekdayAsInt:Int(_julian:Int)
	
	Return (_julian + 1) Mod 7
	
End Function

Rem
	bbdoc: Get the Julian day for a given date.
	returns: An integer containing the Julian day of the given date.
	about: Zero Day is January 1st, 1900.
End Rem
Function dui_JulianDayAsInt:Int(_day:Int, _month:Int, _year:Int)
	Local a:Int, y:Int, m:Int, j:Int
	
	a = (14 - _month) / 12
	y = (_year + 4800) - a
	m = (_month + (12 * a)) - 3
	
	j = _day + (((153 * m) + 2) / 5) + (365 * y) + (y / 4) - (y / 100) + (y / 400) - 2447066
	
	Return j
	
End Function

Rem
	bbdoc: Get the Julian day from a date string.
	returns: an integer containing the Julian day of any given date
	about: Zero Day is January 1st, 1900. Date format is DD/MM/YYYY.
End Rem
Function dui_JulianDayFromString:Int(_date:String)
	Local dmy:String[], d:Int, m:Int, y:Int
	
	dmy = dui_SplitString(_date, "/")
	d = Int(dmy[0])
	m = Int(dmy[1])
	y = Int(dmy[2])
	
	Return(dui_JulianDayAsInt(d, m, Y))
	
End Function

Rem
	bbdoc: Get the date from a Julian date.
	returns: Nothing (arguments @_day, @_month and @_year will contain the date).
End Rem
Function dui_JulianDate(_julian:Int, _day:Int Var, _month:Int Var, _year:Int Var)
	Local a:Int, b:Int, c:Int, d:Int, e:Int, m:Int
	
	a = _julian + 2447065
	b = ((4 * a) + 3) / 146097
	c = a - ((b * 146097) / 4)
	d = ((4 * c) + 3) / 1461
	e = c - ((1461 * d) / 4)
	m = ((5 * e) + 2) / 153
	
	_day = e - (((153 * m) + 2) / 5) + 1
	_month = m + 3 - (12 * (m / 10))
	_year = (b * 100) + d - 4800 + (m / 10)
	
End Function

Rem
	bbdoc: Increment or decrement a date by days.
	returns: Nothing (arguments @_day, @_month and @_year will contain the date).
End Rem
Function dui_MoveDate(_day:Int Var, _month:Int Var, _year:Int Var, inc:Int = 1)
	
	Local j:Int = dui_JulianDayAsInt(_day, _month, _year)
	
	j:+inc
	
	dui_JulianDate(j, _day, _month, _year)
	
End Function

Rem
	bbdoc: Get the string representation for a month.
	returns: A string for the given month (zero based) index, or Null if the month index was not within the range of a month index.
	about: Use @_full to get either the first three letters (False) or the whole month string (True).
End Rem
Function dui_MonthAsString:String(_month:Int, _full:Int = True)
	
	If _month < 1 Or _month > 12 Then Return Null
	
	If _full = True
		Return(__months[_month - 1])
	Else
		Return(__months[_month - 1][..3])
	End If
	
End Function

Rem
	bbdoc: Get the number of days of a month in a given year.
	returns: An integer containing the number of days of a month in a given year.
End Rem
Function dui_MonthDays:Int(_month:Int, _year:Int)
	Local date:Int, day:Int
	
	' First, get date of following month, subtract one
	dui_IncMonthYear(_month, _year)
	date = dui_JulianDayAsInt(1, _month, _year) - 1
	
	' Get new day from julian date
	dui_JulianDate(date, day, _month, _year)
	
	Return day
	
End Function

Rem
	bbdoc: Get a calendar as an array of integers (indexes).
	returns: A [7][6] array of integers in the form [day][week], containing the calendar for the given month.
	about: Use the @_extend parameter to include days of previous and next months (True).
End Rem
Function dui_Calendar:Int[][] (_month:Int, _year:Int, _extend:Int = False)
	Local cal:Int[][], index:Int, wkday:Int, week:Int, weekday:Int, days:Int
	
	cal = New Int[][7]
	For index = 0 To 6
		cal[index] = New Int[6]
	Next
	
	' Get weekday of first day
	weekday = dui_WeekdayAsInt(1, _month, _year)
	
	' Get number of days in month
	days = dui_MonthDays(_month, _year)
	
	' Populate the calendar (index = day)
	For index = 0 To days - 1
		wkday = (weekday + index) Mod 7
		week = (weekday + index) / 7
		
		cal[wkday][week] = index + 1
		
	Next
	
	Return cal
	
End Function

Rem
	bbdoc: Get the occurences of a particular weekday in a time period.
	returns: An integer array, each element containing the MJD date of that weekday.
	about: @_days is the count of days to check (the check includes the @_start).
End Rem
Function dui_WeekdayOccurences:Int[] (_start:Int, _days:Int, _weekday:Int)
	Local startday:Int, results:Int[], first:Int, index:Int, remain:Int
	
	' Exclude first day from days
	_days:-1
	
	' Get weekday of start date
	startday = dui_JulianWeekdayAsInt(_start)
	
	' Get date of first occurance (if any)
	first = (_weekday + (7 * (_weekday < startday))) - startday
	
	' Add it to the array if the criteria is met
	If first <= _days
		results = results[..1]
		results[0] = _start + first
		
		' Find out how many remain
		remain = _days - first
		
		' Expand array
		results = results[..(1 + (remain / 7))]
		
		' Fill in values
		For index = 1 To (remain / 7)
			results[index] = _start + first + (index * 7)
		Next
		
	End If
	
	Return results
	
End Function

Rem
	bbdoc: Get a formatted string for the given date.
	returns: The date formatted as a string, or null if the format was not recognized.
	about @_format can be either dui_FULL_DATE, dui_SHORT_DATE or dui_NUMERICAL_DATE.
End Rem
Function dui_FormatDate:String(_day:Int, _month:Int, _year:Int, _format:Int = dui_SHORT_DATE, _weekday:Int = False)
	
	Local result:String, ds:String, ms:String, ys:String
	
	If _weekday
		If _format = dui_FULL_DATE
			If _weekday Then Result = dui_WeekdayAsString(_day, _month, _year, 0) + " "
		Else If _format = dui_SHORT_DATE Or _format = dui_NUMERICAL_DATE
			If _weekday Then result = dui_WeekdayAsString(_day, _month, _year, 2) + " "
		End If
	End If
	
	Select _format
		Case dui_FULL_DATE
			result:+_day + " " + dui_MonthAsString(_month) + " " + _year
			
		Case dui_SHORT_DATE
			ys = String(_year + 1000)
			result:+_day + " " + dui_MonthAsString(_month, False) + " " + ys[ys.Length - 2..ys.Length]
			
		Case dui_NUMERICAL_DATE
			ds = String(_day)
			ms = String(_month)
			ys = String(_year + 1000)
			ys = ys[ys.Length - 2..ys.Length]
			
			If _day < 10 Then ds = "0" + ds
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
Function dui_JulianDateAsString:String(_date:Int, _format:Int = dui_SHORT_DATE, _weekday:Int = False)
	Local d:Int, m:Int, y:Int
	
	dui_JulianDate(_date, d, m, y)
	
	Return dui_FormatDate(d, m, y, _format, _weekday)
	
End Function
	
Rem
	bbdoc: Get the time in hours and minutes.
	returns: Nothing (@_hours and @_minutes will contain the time).
	about: Set @_daily to False to have more than 24 hours.
End Rem
Function dui_ClockTimeAsInts(_mins:Int, _hours:Int Var, _minutes:Int Var, _daily:Int = True)
	
	_hours = _mins / 60
	_minutes = _mins Mod 60
	
	If _daily = True Then _hours = _hours Mod 24
	
End Function

Rem
	bbdoc: Get the time in string format.
	returns: A string containing the time in 24 hour format.
	about: Use @_lead to add a leading zero to the hours, if necessary. Set @_daily to False to have more than 24 hours.
End Rem
Function dui_ClockTimeAsString:String(_mins:Int, _lead:Int = False, _daily:Int = True)
	
	Local hours:Int, minutes:Int, h:String, m:String
	dui_ClockTimeAsInts(_mins, hours, minutes, _daily)
	
	h = String(hours)
	m = String(minutes)
	
	If minutes < 10 Then m = "0" + m
	If hours < 10 And _lead = True Then h = "0" + h
	
	Return h + ":" + m
	
End Function

Rem
	bbdoc: Get the number of minutes from hour(s) and minute(s).
	returns: The number of minutes within the given time.
End Rem
Function dui_ClockTimeMinutes:Int(_hours:Int, _minutes:Int)
	
	Return _minutes + (_hours * 60)
	
End Function

Rem
	bbdoc: Get the number of minutes from a time string.
	returns: The number of minutes within the time, or 0 if @_clock is in the wrong format.
	about: @_clock format is 'HR:MIN'.
End Rem
Function dui_ClockTimeMinutesFromString:Int(clock:String)
	Local colon:Int, hours:Int, minutes:Int
	
	colon = clock.Find(":")
	If colon = -1 Then Return 0
	
	hours = Int(clock[..colon])
	minutes = Int(clock[colon + 1..])
	
	Return dui_ClockTimeMinutes(hours, minutes)
	
End Function

Rem
	bbdoc: Increment the given minutes.
	returns: Nothing (@_mins will be modified).
	about: This function overlaps automatically to maintain 24 hour time.
End Rem
Function dui_IncMinutes(_mins:Int Var, _increment:Int = 1)
	
	_mins:+_increment
	_mins = _mins Mod 1440
	
End Function

Rem
	bbdoc: Increment the given milliseconds.
	returns: Nothing (@_millis will be modified).
	about: This function overlaps automatically to maintain 24 hour time.
End Rem
Function dui_IncMillisecs(_millis:Int Var, _increment:Int = 1)
	
	_millis:+_increment
	_millis = _millis Mod 86400000
	
End Function

Rem
	bbdoc: Increment time and date in milliseconds.
	returns: Nothing (@_millis and @_date will be modified)
	about: @_date will be incremented by the change in @_millis. This function overlaps to maintain 24 hour time, and updates the date.
End Rem
Function dui_IncMSTime(_millis:Int Var, _date:Int Var, _increment:Int = 1)
	
	_millis:+_increment
	_date:+(_millis / 86400000)
	_millis = _millis Mod 86400000
	
End Function

Rem
	bbdoc: Increment the minutes and date.
	returns: Nothing (@_mins and @_date will be modified).
	about: @_date will be incremented by the change in @_mins. This function overlaps automatically, and also updates the date.
End Rem
Function dui_IncTime(_mins:Int Var, _date:Int Var, _increment:Int = 1)
	
	_mins:+_increment
	_date:+(_mins / 1440)
	_mins = _mins Mod 1440
	
End Function

Rem
	bbdoc: Get minutes from milliseconds.
	returns: The given milliseconds in minutes.
End Rem
Function dui_MSToMin:Int(_millis:Int)
	
	Return _millis / 60000
	
End Function

Rem
	bbdoc: Get milliseconds from minutes.
	returns: The given minutes in milliseconds.
End Rem
Function dui_MinToMS:Int(_mins:Int)
	
	Return _mins * 60000
	
End Function

Rem
	bbdoc: Increment the number of months.
	returns: The incremented month.
	about: If @_month is incremented above 12, it will be wrapped around to 1.
End Rem
Function dui_IncMonths:Int(_month:Int, _inc:Int = 1)
	
	Return (_month Mod 12) + _inc
	
End Function

Rem
	bbdoc: Increment the months and years.
	returns: Nothing (@_month and _@year will be modified).
End Rem
Function dui_IncMonthYear(_month:Int Var, _year:Int Var, _inc:Int = 1)
	
	_year:+(_inc / 12)
	If _month + (_inc Mod 12) > 12 Then _year:+1
	
	_month = dui_IncMonths(_month, _inc)
	
End Function

Rem
	bbdoc: Increment the date by a number of years.
	returns: The incremented date.
End Rem
Function dui_IncDateYear:Int(_date:Int, _inc:Int)
	Local d:Int, m:Int, y:Int
	
	dui_JulianDate(_date, d, m, y)
	
	y:+_inc
	
	Return dui_JulianDayAsInt(d, m, y)
	
End Function

Rem
	bbdoc: The age of a person.
	returns: The age of the person.
	about: @_dob is the date of birthday for the person.
End Rem
Function dui_JulianAge:Int(_date:Int, _dob:Int)
	Local age:Int
	Local dd:Int, dm:Int, dy:Int
	Local bd:Int, bm:Int, by:Int
	
	If _dob > _date Then Return 0
	
	dui_JulianDate(_date, dd, dm, dy)
	dui_JulianDate(_dob, bd, bm, by)
	
	age = dy - by
	
	' Not yet reached a whole year
	If bm > dm Then age:-1
	If bm = dm And bd > dd Then age:-1
	
	Return age
	
End Function

























	
	