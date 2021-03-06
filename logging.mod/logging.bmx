
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

SuperStrict

Rem
bbdoc: Logging module
End Rem
Module duct.logging

ModuleInfo "Version: 0.6"
ModuleInfo "Copyright: Coranna Howard <me@komiga.com>"
ModuleInfo "License: MIT"

ModuleInfo "History: Version 0.6"
ModuleInfo "History: General cleanup"
ModuleInfo "History: Adapted to duct.etc changes"
ModuleInfo "History: Version 0.5"
ModuleInfo "History: Adapted for time module"
ModuleInfo "History: Version 0.4"
ModuleInfo "History: Fixed documentation, license, examples"
ModuleInfo "History: Renamed TLogger to dLogger"
ModuleInfo "History: Version 0.3"
ModuleInfo "History: Added CloseLogStream method to TLogger"
ModuleInfo "History: Version 0.2"
ModuleInfo "History: General cleanup"
ModuleInfo "History: Version 0.1"
ModuleInfo "History: Initial release"

Import brl.standardio
Import brl.stream

Import duct.appendstream
Import duct.etc
Import duct.time

Rem
	bbdoc: duct stream/debug/stdio based logger.
End Rem
Type dLogger
	
	Const LOGTYPE_NONE:Int = 1, LOGTYPE_WARNING:Int = 2, LOGTYPE_ERROR:Int = 3
	
	Field m_timeformat:String
	Field m_formatter:dTextReplacer, m_rep_time:dTextReplacement, m_rep_type:dTextReplacement, m_rep_msg:dTextReplacement
	
	Field m_logfile:String, m_logstream:TStream
	Field m_usestream:Int = True, m_useprint:Int = False, m_usedebuglog:Int = False
	
	Method New()
		m_formatter = New dTextReplacer
	End Method
	
	Rem
		bbdoc: Create a logger.
		returns: Itself.
	End Rem
	Method Create:dLogger(timeformat:String = "%H:%M:%S", format:String = "[{time} {type}] {msg}", logfile:String, _usestream:Int = True, _useprint:Int = False, _usedebuglog:Int = False)
		SetTimeFormat(timeformat)
		SetFormat(format)
		SetLogFile(logfile)
		UseStream(_usestream)
		UsePrint(_useprint)
		UseDebugLog(_usedebuglog)
		Return Self
	End Method
	
'#region Field accessors
	
	Rem
		bbdoc: Set the time format.
		returns: Nothing.
	End Rem
	Method SetTimeFormat(timeformat:String)
		m_timeformat = timeformat
	End Method
	Rem
		bbdoc: Get the time format.
		returns: The time format for logged information.
	End Rem
	Method GetTimeFormat:String()
		Return m_timeformat
	End Method
	
	Rem
		bbdoc: Set the format.
		returns: Nothing.
	End Rem
	Method SetFormat(format:String, beginiden:String = "{", endiden:String = "}")
		m_formatter.SetString(format)
		m_formatter.AutoReplacements(beginiden, endiden)
		m_rep_time = m_formatter.GetReplacementWithName("time")
		m_rep_type = m_formatter.GetReplacementWithName("type")
		m_rep_msg = m_formatter.GetReplacementWithName("msg")
	End Method
	Rem
		bbdoc: Get the format.
		returns: The format for logged information.
	End Rem
	Method GetFormat:String(beginiden:String = "{", endiden:String = "}")
		Return m_formatter.GetOriginal(beginiden, endiden)
	End Method
	
	Rem
		bbdoc: Set the log file.
		returns: Nothing.
	End Rem
	Method SetLogFile(logfile:String)
		m_logfile = logfile
	End Method
	Rem
		bbdoc: Get the log file.
		returns: The file for the logged information.
	End Rem
	Method GetLogFile:String()
		Return m_logfile
	End Method
	
	Rem
		bbdoc: Set the log stream.
		returns: Nothing.
	End Rem
	Method SetLogStream(logstream:TStream)
		m_logstream = logstream
	End Method
	Rem
		bbdoc: Get the log stream.
		returns: The log stream (may be Null).
	End Rem
	Method GetLogStream:TStream()
		Return m_logstream
	End Method
	Rem
		bbdoc: Open the log stream to the set log file.
		returns: True if the stream was opened, or False if it was not.
		about: This will open the log file stream.
	End Rem
	Method OpenLogStream:Int(append:Int = True)
		Local file:String
		If append
			file = "append::" + m_logfile
		Else
			file = m_logfile
		End If
		m_logstream = WriteStream(file)
		Return m_logstream <> Null
	End Method
	
	Rem
		bbdoc: Close the log stream.
		returns: True if the stream was closed, or False if it was not (stream has not been opened/set).
	End Rem
	Method CloseLogStream:Int()
		If m_logstream
			m_logstream.Close()
			Return True
		End If
		Return False
	End Method
	
	Rem
		bbdoc: Set stream usage state (True - on - or False - off).
		returns: Nothing.
	End Rem
	Method UseStream(_usestream:Int)
		m_usestream = _usestream
	End Method
	Rem
		bbdoc: Get the stream-usage state.
		returns: True (on) or False (off).
	End Rem
	Method UsingStream:Int()
		Return m_usestream
	End Method
	
	Rem
		bbdoc: Set Print usage state (True - on - or False - off).
		returns: Nothing.
	End Rem
	Method UsePrint(_useprint:Int)
		m_useprint = _useprint
	End Method
	Rem
		bbdoc: Get the Print-usage state.
		returns: True (on) or False (off).
	End Rem
	Method UsingPrint:Int()
		Return m_useprint
	End Method
	
	Rem
		bbdoc: Set DebugLog usage state (True - on - or False - off).
		returns: Nothing.
	End Rem
	Method UseDebugLog(_usedebuglog:Int)
		m_usedebuglog = _usedebuglog
	End Method
	Rem
		bbdoc: Get the DebugLog-usage state.
		returns: True (on) or False (off).
	End Rem
	Method UsingDebugLog:Int()
		Return m_usedebuglog
	End Method
	
'#end region Field accessors
	
'#region Formatting
	
	Rem
		bbdoc: Get the current time in the logger's time format.
		returns: The current time in the logger's time format, or Null if the format is Null.
	End Rem
	Method GetFormattedTime:String()
		If m_timeformat
			Return dTime.CurrentFormat(m_timeformat)
		Else
			Return Null
		End If
	End Method
	
	Rem
		bbdoc: Get the given message formatted in the given log type.
		returns: Nothing.
	End Rem
	Method GetFormattedMessage:String(message:String, logtype:Int = LOGTYPE_NONE)
		If m_rep_time And m_timeformat
			m_rep_time.SetReplacement(GetFormattedTime())
		End If
		If m_rep_type
			Select logtype
				Case LOGTYPE_NONE
					m_rep_type.SetReplacement("")
				Case LOGTYPE_WARNING
					m_rep_type.SetReplacement("WARNING")
				Case LOGTYPE_ERROR
					m_rep_type.SetReplacement("ERROR")
			End Select
		End If
		If m_rep_msg
			m_rep_msg.SetReplacement(message)
		End If
		Return m_formatter.DoReplacements()
	End Method
	
'#end region Formatting
	
'#region Logging
	
	Rem
		bbdoc: Log a string in the given log type.
		returns: Nothing.
	End Rem
	Method LogString(message:String, formatted:Int = True, logtype:Int = LOGTYPE_NONE)
		Local formattedmessage:String
		If formatted
			formattedmessage = GetFormattedMessage(message, logtype)
		Else
			formattedmessage = message
		End If
		If m_usestream And m_logstream
			m_logstream.WriteLine(formattedmessage)
		End If
		If m_useprint
			Print(formattedmessage)
		End If
		If m_usedebuglog
			DebugLog(formattedmessage)
		End If
	End Method
	
	Rem
		bbdoc: Log a generic message.
		returns: Nothing.
	End Rem
	Method LogMessage(message:String, formatted:Int = True)
		LogString(message, formatted, LOGTYPE_NONE)
	End Method
	
	Rem
		bbdoc: Log a warning message.
		returns: Nothing.
	End Rem
	Method LogWarning(message:String, formatted:Int = True)
		LogString(message, formatted, LOGTYPE_WARNING)
	End Method
	
	Rem
		bbdoc: Log an error message.
		returns: Nothing.
	End Rem
	Method LogError(message:String, formatted:Int = True)
		LogString(message, formatted, LOGTYPE_ERROR)
	End Method
	
'#end region Logging
	
End Type

