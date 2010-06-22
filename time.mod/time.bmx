
Rem
Copyright (c) 2010 Tim Howard

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
bbdoc: Time module
End Rem
Module duct.time

ModuleInfo "Version: 0.2"
ModuleInfo "Copyright: Tim Howard"
ModuleInfo "License: MIT"

ModuleInfo "History: Version 0.2"
ModuleInfo "History: Added (limited) Win32 support (no timezone conversion (or strptime for that matter), because Microsoft is a homosexual deviant)"
ModuleInfo "History: Removed SetFromFormatted and CreateFromFormatted methods in dTime"
ModuleInfo "History: Version 0.1"
ModuleInfo "History: Initial release"

Import brl.blitz
Import brl.filesystem
Import pub.stdc

Import "dtime.c"

Extern "c"
	'Function gmtime:Byte Ptr(timep:Byte Ptr)
	Function bmx_dtime_totimezone:Int(time:Int, tz:String)
	Function bmx_dtime_format:String(time:Int, fmt:String, tz:String)
End Extern

Rem
	bbdoc: duct time container.
End Rem
Type dTime
	
	Field m_time:Int
	
	Rem
		bbdoc: Create a container with the given time.
		returns: Itself.
	End Rem
	Method Create:dTime(time:Int)
		Set(time)
		Return Self
	End Method
	
	Rem
		bbdoc: Create a container with the current time.
		returns: Itself.
	End Rem
	Method CreateFromCurrent:dTime()
		SetCurrent()
		Return Self
	End Method
	
	Rem
		bbdoc: Create a container with the last modified time of the given file.
		returns: Itself or Null if the given file does not exist.
		about: If @creationtime is True the container will be set to the path's creation time instead of the last modified time.
	End Rem
	Method CreateFromFile:dTime(path:String, creationtime:Int = False)
		If SetFromPath(path, creationtime)
			Return Self
		End If
		Return Null
	End Method
	
'#region Field accessors
	
	Rem
		bbdoc: Set the container's time.
		returns: Nothing.
	End Rem
	Method Set(time:Int)
		m_time = time
	End Method
	
	Rem
		bbdoc: Get the container's time.
		returns: The container's time.
	End Rem
	Method Get:Int()
		Return m_time
	End Method
	
	Rem
		bbdoc: Get the pointer to the time struct.
		returns: The pointer to the time struct.
	End Rem
	Method Pointer:Int Ptr()
		Return Varptr(m_time)
	End Method
	
'#end region Field accessors
	
	Rem
		bbdoc: Set the container's time to the current time.
		returns: The current time as an integer.
	End Rem
	Method SetCurrent:Int()
		time_(Varptr(m_time))
		Return m_time
	End Method
	
	Rem
		bbdoc: Set the container's time from the given file/dir path.
		returns: True if the time was set, or False if it was not (path given does not exist).
		about: If @creationtime is True the container will be set to the path's creation time instead of the last modified time.
	End Rem
	Method SetFromPath:Int(path:String, creationtime:Int = False)
		If path
			FixPath(path)
			If Not(FileType(path) = FILETYPE_NONE)
				Local mode:Int, size:Int, mtime:Int, ctime:Int
				If stat_(path, mode, size, mtime, ctime) = 0
					Set(creationtime = True Or ctime Or mtime)
					Return True
				End If
			End If
		End If
		Return False
	End Method
	
	Rem
		bbdoc: Convert the container's time to the given timezone.
		returns: True if the time was converted, or False if the given timezone was Null.
	End Rem
	Method ConvertToTimeZone:Int(tz:String)
		If tz
			Local time:Int = bmx_dtime_totimezone(m_time, tz)
			If Not(time = -1)
				m_time = time
				Return True
			End If
		End If
		Return False
	End Method
	
	Rem
		bbdoc: Format the container's time with the given format.
		returns: The container's time formatted with the given format.
		about: If @tz is set, the time will be formatted in the timezone @tz.
	End Rem
	Method Format:String(fmt:String, tz:String = Null)
		Rem
		Local buffer:Byte[256], tm:Byte Ptr
		If utc
			tm = gmtime(Varptr(m_time))
		Else
			tm = localtime_(Varptr(m_time))
		End If
		strftime_(buffer, 256, fmt, tm)
		Return String.FromCString(buffer)
		End Rem
		Return bmx_dtime_format(m_time, fmt, tz)
	End Method
	
	Rem
		bbdoc: Create a clone of this container.
		returns: The container's clone.
	End Rem
	Method Clone:dTime()
		Return New dTime.Create(m_time)
	End Method
	
	Rem
		bbdoc: Get the current time in the given format.
		returns: The curren time in the given format.
		about: If @utc is True the time will be in UTC instead of the system time zone.
	End Rem
	Function CurrentFormat:String(fmt:String, utc:Int = False)
		Local tc:dTime = New dTime.CreateFromCurrent()
		Return tc.Format(fmt, utc)
	End Function
	
End Type

