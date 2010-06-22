
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
bbdoc: CSV (comma-separated value) reading/writing
End Rem
Module duct.csv

ModuleInfo "Version: 0.6"
ModuleInfo "Copyright: Tim Howard"
ModuleInfo "License: MIT"

ModuleInfo "History: Version 0.6"
ModuleInfo "History: Added RemoveRow and RemoveRecord to dCSVMap, added RemoveRecord to dCSVRow"
ModuleInfo "History: Use dStringVariable.Create(, Null) instead of dVariable.RawToVariable(Null) in dCSVRow.InsertRecordsFromString"
ModuleInfo "History: Version 0.5"
ModuleInfo "History: dCSVMap rewritten, added serialization"
ModuleInfo "History: Added dCSVRow"
ModuleInfo "History: Renaming dCSVMap.GetRecordByPosition to dCSVMap.GetRecordFromPosition"
ModuleInfo "History: Renamed dCSVMap.InsertRecord to dCSVMap.AddRecord"
ModuleInfo "History: Corrected some documentation"
ModuleInfo "History: Renamed dCSVMap.CheckRecordAtPosition to dCSVMap.HasRecord"
ModuleInfo "History: Renamed module from csvreader to csv"
ModuleInfo "History: Version 0.4"
ModuleInfo "History: Fixed documentation, license, examples"
ModuleInfo "History: Renamed TCSVMap to dCSVMap"
ModuleInfo "History: Updated for API change"
ModuleInfo "History: Version 0.3"
ModuleInfo "History: General cleanup"
ModuleInfo "History: Version 0.2"
ModuleInfo "History: Moved all code into the main source"
ModuleInfo "History: Version 0.1"
ModuleInfo "History: Initial release"

Import brl.stream
Import duct.etc
Import duct.variables
Import duct.intmap

Rem
	bbdoc: duct CSV (comma-separated value) map for reading CSV files.
End Rem
Type dCSVMap
	
	Field m_rows:dIntMap = New dIntMap
	
	Rem
		bbdoc: Create a new map.
		returns: Itself.
	End Rem
	Method Create:dCSVMap()
		Return Self
	End Method
	
'#region Record handling
	
	Rem
		bbdoc: Get the number of rows in the map
		returns: The number of rows in the map.
	End Rem
	Method GetRowCount:Int()
		Return m_rows.Count()
	End Method
	
	Rem
		bbdoc: Get the number of columns in the header (row -1).
		returns: The number of columns in the header.
	End Rem
	Method GetHeaderCount:Int()
		Local header:dCSVRow = GetRow(-1, False)
		If header
			Return header.GetCount()
		End If
		Return 0
	End Method
	
	Rem
		bbdoc: Get the number of records in the given row.
		returns: The number of records in the given row.
	End Rem
	Method GetRowRecordCount:Int(index:Int)
		Local row:dCSVRow = GetRow(index, False)
		If row
			Return row.GetCount()
		End If
		Return 0
	End Method
	
	Rem
		bbdoc: Get the number of records in the map.
		returns: Nothing.
	End Rem
	Method GetRecordCount:Int()
		Local count:Int
		For Local row:dCSVRow = EachIn m_rows
			count:+ row.GetCount()
		Next
		Return count
	End Method
	
	Rem
		bbdoc: Insert a row.
		returns: True if the row was inserted, or False if it was not (Null row).
	End Rem
	Method InsertRow:Int(row:dCSVRow)
		If row
			m_rows.Insert(row.GetIndex(), row)
			Return True
		End If
		Return False
	End Method
	
	Rem
		bbdoc: Insert a record.
		returns: True if the record was inserted, or False if it was not.
	End Rem
	Method InsertRecord:Int(record:dCSVRecord, row:Int)
		If record
			GetRow(row, True).InsertRecord(record)
			Return True
		End If
		Return False 
	End Method
	
	Rem
		bbdoc: Remove the row at the given index.
		returns: True if the row was removed, or False if there is no row at the given index.
	End Rem
	Method RemoveRow:Int(index:Int)
		Return m_rows.Remove(index)
	End Method
	
	Rem
		bbdoc: Remove the record at the given position.
		returns: True if the record was removed, or False if there is no record at the given position.
	End Rem
	Method RemoveRecord:Int(row:Int, column:Int)
		Local trow:dCSVRow = GetRow(row, False)
		If trow
			Return trow.RemoveRecord(column)
		End If
		Return False
	End Method
	
	Rem
		bbdoc: Get the row at the given index.
		returns: The row at the given index, or Null if the given row could not be found (barring the option below).
		about: If @docreate is True, the row will be created if it was not found (and returned).
	End Rem
	Method GetRow:dCSVRow(index:Int, docreate:Int = False)
		Local row:dCSVRow = dCSVRow(m_rows.ForKey(index))
		If Not row And docreate
			row = New dCSVRow.Create(index)
			InsertRow(row)
		End If
		Return row
	End Method
	
	Rem
		bbdoc: Get the record at the given position.
		returns: The record at the given position, or Null if the position does not contain a record.
	End Rem
	Method GetRecord:dCSVRecord(row:Int, column:Int)
		Local trow:dCSVRow = GetRow(row)
		If trow
			Return trow.GetRecord(column)
		End If
		Return Null
	End Method
	
	Rem
		bbdoc: Check if there is a row at the given index.
		returns: True if there is a row at the given index, or False if there is not.
	End Rem
	Method HasRow:Int(index:Int)
		Return m_rows.Contains(index)
	End Method
	
	Rem
		bbdoc: Check if there is a record at the given position.
		returns: True if there is a record at the given position, or False if there is not.
	End Rem
	Method HasRecord:Int(row:Int, column:Int)
		Local trow:dCSVRow = GetRow(row)
		If trow
			Return trow.HasRecord(column)
		End If
		Return False
	End Method
	
	Rem
		bbdoc: Clear the map.
		returns: Nothing.
	End Rem
	Method Clear()
		m_rows.Clear()
	End Method
	
'#end region Record handling
	
	Rem
		bbdoc: Get the object enumerator (row enumerator) for the map.
		returns: The map's enumerator.
	End Rem
	Method ObjectEnumerator:dIntMapStandardEnum()
		Return m_rows.ObjectEnumerator()
	End Method
	
	Rem
		bbdoc: Get the reversed object enumerator (row enumerator) for the map.
		returns: The map's reverse enumerator.
	End Rem
	Method ReverseEnumerator:dIntMapReverseEnum()
		Return m_rows.ReverseEnumerator()
	End Method
	
	Rem
		bbdoc: Deserialize a CSV map from the given file.
		returns: Itself, or Null if either the stream or separator is Null.
		about: @separator is the separator for columns.<br>
		If @setheader is True, the first column encountered will be the header.
	End Rem
	Method DeserializeFromFile:dCSVMap(url:String, separator:String = ",", setheader:Int = True)
		If separator
			Local stream:TStream = ReadStream(url)
			If stream
				Deserialize(stream, separator, setheader)
				stream.Close()
				Return Self
			End If
		End If
		Return Null
	End Method
	
	Rem
		bbdoc: Deserialize a CSV map from the given stream.
		returns: Itself.
		about: The map will be cleared when this method is called.<br>
		@separator is the separator for columns.<br>
		If @setheader is True, the first column encountered will be the header (retrievable by row index -1).
	End Rem
	Method Deserialize:dCSVMap(stream:TStream, separator:String = ",", setheader:Int = True)
		Clear()
		Local row:Int = setheader And -1 Or 0
		While Not stream.Eof()
			GetRow(row, True).Deserialize(stream, separator)
			row:+1
		End While
		Return Self
	End Method
	
	Rem
		bbdoc: Serialize the CSV map to the given file.
		returns: True if the map was serialized, or False if it was not (bad url or Null separator).
	End Rem
	Method SerializeToFile:Int(url:String, separator:String, forcequoting:Int = False)
		If separator
			Local stream:TStream = WriteStream(url)
			If stream
				Serialize(stream, separator, forcequoting)
				stream.Close()
				Return True
			End If
		End If
		Return False
	End Method
	
	Rem
		bbdoc: Serialize the CSV map to the given stream.
		returns: Nothing.
		about: @separator is the separator for columns.<br>
		If @forcequoting is True, all columns will have quotes around them
	End Rem
	Method Serialize(stream:TStream, separator:String = ",", forcequoting:Int = False)
		For Local row:dCSVRow = EachIn m_rows
			row.Serialize(stream, separator, forcequoting)
			stream.WriteString("~n")
		Next
	End Method
	
End Type

Rem
	bbdoc: duct CSVRow.
End Rem
Type dCSVRow
	
	Field m_records:dIntMap = New dIntMap
	Field m_index:Int
	
	Rem
		bbdoc: Create a CSV row.
		returns: Itself.
	End Rem
	Method Create:dCSVRow(index:Int)
		SetIndex(index)
		Return Self
	End Method
	
'#region Field accessors
	
	Rem
		bbdoc: Set the row's index.
		returns: Nothing.
	End Rem
	Method SetIndex(index:Int)
		m_index = index
	End Method
	
	Rem
		bbdoc: Get the index.
		returns: The row's index.
	End Rem
	Method GetIndex:Int()
		Return m_index
	End Method
	
'#end region Field accessors
	
'#region Record handling
	
	Rem
		bbdoc: Insert the given record.
		returns: Nothing.
	End Rem
	Method InsertRecord:Int(record:dCSVRecord)
		If record
			m_records.Insert(record.GetIndex(), record)
			Return True
		End If
		Return False
	End Method
	
	Rem
		bbdoc: Parse and insert the records from the given string, using the given separator.
		returns: The number of records inserted, or -1 if the given string or separator are Null.
		about: If a newline character (ASCII 10) is encountered the parsing will terminate.
	End Rem
	Method InsertRecordsFromString:Int(line:String, separator:String = ",")
		If line And separator
			Local char:Int, quote:Int, index:Int, issep:Int, buf:dTempBuf = New dTempBuf
			For Local n:Int = 0 Until line.Length
				char = line[n]
				If char = 34
					quote:~1
				End If
				issep = line[n..n + separator.Length] = separator And Not quote
				If Not issep And char <> 34 Then buf.AddChar(char)
				If issep Or n = line.Length - 1 Or char = 10
					Local value:String = buf.AsString().Trim(); buf.Clear()
					'If value
						InsertRecord(New dCSVRecord.Create(index, dVariable.RawToVariable(value)))
					'End If
					'n:+ separator.Length
					index:+ 1
					If issep And n = line.Length - 1
						InsertRecord(New dCSVRecord.Create(index, New dStringVariable.Create(, Null)))
						index:+ 1
					End If
					If char = 10 Then Exit
				End If
			Next
			Return index
		End If
		Return -1
	End Method
	
	Rem
		bbdoc: Remove the record at the given index.
		returns: True if the record was removed, or False if there is no record at the given index.
	End Rem
	Method RemoveRecord:Int(index:Int)
		Return m_records.Remove(index)
	End Method
	
	Rem
		bbdoc: Get the record at the given index (column).
		returns: The record at the given index, or Null if there is no record at the given index.
	End Rem
	Method GetRecord:dCSVRecord(index:Int)
		Return dCSVRecord(m_records.ForKey(index))
	End Method
	
	Rem
		bbdoc: Check if the row has the given record.
		returns: Nothing.
	End Rem
	Method HasRecord:Int(index:Int)
		Return m_records.Contains(index)
	End Method
	
	Rem
		bbdoc: Get the number of records in the row.
		returns: The number of records in the row.
		about: NOTE: This will count blank records (goes by the last column).
	End Rem
	Method GetCount:Int()
		Local success:Int
		Return m_records.GetLastKey(success) + 1
	End Method
	
'#end region Record handling
	
	Rem
		bbdoc: Get the object enumerator (record enumerator) for the map.
		returns: The row's enumerator.
	End Rem
	Method ObjectEnumerator:dIntMapStandardEnum()
		Return m_records.ObjectEnumerator()
	End Method
	
	Rem
		bbdoc: Get the object enumerator (record enumerator) for the map.
		returns: The row's enumerator.
	End Rem
	Method ReverseEnumerator:dIntMapReverseEnum()
		Return m_records.ReverseEnumerator()
	End Method
	
	Rem
		bbdoc: Deserialize a CSV row from the given stream.
		returns: Itself.
	End Rem
	Method Deserialize:dCSVRow(stream:TStream, separator:String = ",")
			InsertRecordsFromString(stream.ReadLine(), separator)
	End Method
	
	Rem
		bbdoc: Serialize the row to the given stream.
		returns: Nothing.
	End Rem
	Method Serialize(stream:TStream, separator:String = ",", forcequoting:Int = False)
		Local lastindex:Int
		For Local record:dCSVRecord = EachIn m_records
			'DebugLog("i, li, sub: " + record.m_index + ", " + lastindex + ", " + (record.m_index - lastindex))
			For Local i:Int = 0 Until record.m_index - lastindex
				stream.WriteString(separator)
			Next
			record.Serialize(stream, separator, forcequoting)
			lastindex = record.m_index
		Next
	End Method
	
	Rem
		bbdoc: Get the row as a string.
		returns: A string containing all the records in the row, separated by the given separator.
	End Rem
	Method Report:String(separator:String = ",", forcequoting:Int = False)
		Local build:String, lastindex:Int, str:String
		For Local record:dCSVRecord = EachIn m_records
			For Local i:Int = 0 Until record.m_index - lastindex
				build:+ separator
			Next
			str = record.ToString()
			If str
				If str.Contains(" ") Or str.Contains("~t") Or str.Contains(separator) Or forcequoting
					build:+ "~q" + str + "~q"
				Else
					build:+ str
				End If
			Else If forcequoting
				build:+ "~q~q"
			End If
			lastindex = record.m_index
		Next
		Return build
	End Method
	
End Type

Rem
	bbdoc: duct CSVRecord.
End Rem
Type dCSVRecord
	
	Field m_index:Int
	Field m_variable:dVariable
	
	Method New()
	End Method
	
	Rem
		bbdoc: Create a new record.
		returns: Itself.
	End Rem
	Method Create:dCSVRecord(index:Int, variable:dVariable)
		SetIndex(index)
		SetVariable(variable)
		Return Self
	End Method
	
'#region Field accessors
	
	Rem
		bbdoc: Set the index for the record.
		returns: Nothing.
	End Rem
	Method SetIndex(index:Int)
		m_index = index
	End Method
	
	Rem
		bbdoc: Get the record's index.
		returns: The index for the record.
	End Rem
	Method GetIndex:Int()
		Return m_index
	End Method
	
	Rem
		bbdoc: Set the variable for the record.
		returns: Nothing.
	End Rem
	Method SetVariable(variable:dVariable)
		m_variable = variable
	End Method
	
	Rem
		bbdoc: Get the record's variable.
		returns: The variable for the record.
	End Rem
	Method GetVariable:dVariable()
		Return m_variable
	End Method
	
	Rem
		bbdoc: Get the record's header.
		returns: The header for the record, or Null if the record's variable is Null.
	End Rem
	Method GetHeader:String()
		If m_variable
			Return m_variable.GetName()
		End If
		Return Null
	End Method
	
'#end region Field accessors
	
	Rem
		bbdoc: Deserialize a record from the given stream.
		returns: Itself.
	End Rem
	Method Deserialize:dCSVRecord()
	End Method
	
	Rem
		bbdoc: Serialize the record to the given stream.
		returns: Nothing.
	End Rem
	Method Serialize(stream:TStream, separator:String = ",", forcequoting:Int = False)
		Local str:String = ToString()
		If str
			If str.Contains(" ") Or str.Contains("~t") Or str.Contains(separator) Or forcequoting
				stream.WriteString("~q" + str + "~q")
			Else
				stream.WriteString(str)
			End If
		Else If forcequoting
			stream.WriteString("~q~q")
		End If
	End Method
	
	Rem
		bbdoc: Get the record's value.
		returns: The record's value.
	End Rem
	Method ToString:String()
		If m_variable Then Return m_variable.ValueAsString() Else Return Null
	End Method
	
End Type

Type dTempBuf

	Const BUFFERINITIAL_SIZE:Int = 128
	Const BUFFER_MULTIPLIER:Double = 1.75:Double

	Field m_buffer:Short Ptr = Null, m_bufSize:Int = 0, m_bufLen:Int = 0
	Field m_bufS:String = Null

	Method New()
	End Method

	Method Delete() NoDebug
		If m_buffer <> Null
			MemFree(m_buffer)
			m_buffer = Null
		End If
	End Method

	Method Clear()
		m_bufS = Null
		m_bufLen = 0
	End Method

	Method AddChar(char:Int)
		If m_buffer = Null
			m_bufSize = BUFFERINITIAL_SIZE
			m_buffer = Short Ptr(MemAlloc(m_bufSize * 2))
			m_bufLen = 0
		Else If m_bufLen = m_bufSize
			Local newsize:Int = Ceil(m_bufSize * BUFFER_MULTIPLIER)
			If newSize < m_bufLen
				newSize = Ceil(m_bufLen * BUFFER_MULTIPLIER)
			End If
			Local temp:Short Ptr = Short Ptr(MemAlloc(newSize * 2))
			If temp = Null
				Throw("(dTempBuf.AddChar()) Unable To allocate buffer of size " + (newSize * 2) + " bytes")
			End If
			m_bufSize = newSize
			MemCopy(temp, m_buffer, m_bufLen * 2)
			MemFree(m_buffer)
			m_buffer = temp
		End If
		m_buffer[m_bufLen] = char
		m_bufLen:+1
	End Method

	Method AsString:String()
		If m_bufS <> Null And (m_buffer = Null Or m_bufS.Length = m_bufLen)
			Return m_bufS
		End If
		m_bufS = String.FromShorts(m_buffer, m_bufLen)
		Return m_bufS
	End Method

End Type

