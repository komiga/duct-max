
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
bbdoc: CSV (comma-separated value) file reader module
End Rem
Module duct.csvreader

ModuleInfo "Version: 0.2"
ModuleInfo "Copyright: Tim Howard"
ModuleInfo "License: MIT"

ModuleInfo "History: Version 0.2"
ModuleInfo "History: Moved all code into the main source"
ModuleInfo "History: Version 0.1"
ModuleInfo "History: Initial release"

' Used modules
Import brl.stream

Import duct.objectmap
Import duct.variables


Rem
	bbdoc: The CSVMap type.
	about: This type is for reading CSV (comma-separated value) files.
End Rem
Type TCSVMap Extends TObjectMap
	
	Field m_headers:String[]
	Field m_rows:Int
	
		Rem
			bbdoc: Create a new CSVMap.
			returns: The new CSVMap (itself).
		End Rem
		Method Create:TCSVMap()
			
			Return Self
			
		End Method
		
		'#region Field accessors
		
		Rem
			bbdoc: Set the headers array for the CSVMap.
			returns: Nothing.
		End Rem
		Method SetHeaders(headers:String[])
			
			m_headers = headers
			
		End Method
		
		Rem
			bbdoc: Get the CSVMap's headers array.
			returns: The headers array for the CSVMap.
		End Rem
		Method GetHeaders:String[] ()
			
			Return m_headers
			
		End Method
		
		Rem
			bbdoc: Get the number of headers (maximum possible number of records in a row) within the CSVMap.
			returns: The number of headers in the map, or 0 if the headers array is Null.
		End Rem
		Method GetHeaderCount:Int()
			
			If m_headers <> Null
				
				Return m_headers.Length
				
			End If
			
			Return 0
			
		End Method
		
		Rem
			bbdoc: Get the number of rows inthe CSVMap
			returns: The number of rows in the map.
		End Rem
		Method GetRowCount:Int()
			
			Return m_rows
			
		End Method
		
		'#end region
		
		'#region Record handlers
		
		Rem
			bbdoc: Get the number of records in the given row.
			returns: The number of records in the given row.
		End Rem
		Method GetRowRecordCount:Int(row:Int)
			Local column:Int, count:Int
			
			For column = 0 To m_headers.length - 1
				
				If CheckRecordAtPosition(row, column) = True
					
					count:+1
					
				End If
				
			Next
			
			Return count
			
		End Method
		
		Rem
			bbdoc: Insert a CSVRecord into the map.
			returns: True if the record was inserted into the map, or False if it was not (the record, or the record's variable, is Null).
		End Rem
		Method InsertRecord:Int(record:TCSVRecord)
			
			If record <> Null
				
				If record.m_variable <> Null
					
					_Insert(BuildKey(record.m_row, record.m_column), record)
					
					If record.m_row + 1 > m_rows
						m_rows:+1
					End If
					
					Return True
					
				End If
				
			End If
			
			Return False
			
		End Method
		
		Rem
			bbdoc: Get a CSVRecord at the given position.
			returns: The record at the given position, or Null if the position does not contain a record.
		End Rem
		Method GetRecordByPosition:TCSVRecord(row:Int, column:Int)
			
			Return TCSVRecord(_ValueByKey(BuildKey(row, column)))
			
		End Method
		
		Rem
			bbdoc: Check if there is a record at the given position.
			returns: True if there is a record at the given position, or False if not.
		End Rem
		Method CheckRecordAtPosition:Int(row:Int, column:Int)
			
			Return _Contains(BuildKey(row, column))
			
		End Method
		
		Rem
			bbdoc: Clear the CSVMap.
			returns: Nothing.
		End Rem
		Method Clear()
			
			Super.Clear()
			
			m_headers = Null
			m_rows = 0
			
		End Method
		
		'#end region
		
		Rem
			bbdoc: Parse a file containing CSV data.
			returns: A CSVMap containing the values in the file, or Null if the file could not be read.
			about: This simply opens a stream to the given url, passes it off to #ParseStream, closes the stream, then returns the value from #ParseStream.<br />
			@incblanks tells the parser to include blank values or not.
		End Rem
		Function ParseFile:TCSVMap(url:String, incblanks:Int = False)
			Local stream:TStream, csvmap:TCSVMap
			
			stream = ReadStream(url)
			csvmap = ParseStream(stream, incblanks)
			stream.Close()
			
			Return csvmap
			
		End Function
		
		Rem
			bbdoc: Parse a stream containing CSV data.
			returns: A CSVMap containing the values in the stream, or Null if the stream is Null.
			about: This function will not close the given stream (remember to do so!)<br />
			@incblanks tells the parser to include blank values or not.
		End Rem
		Function ParseStream:TCSVMap(stream:TStream, incblanks:Int = False)
			Local csvmap:TCSVMap, row:Int
			Local line:String, headers:String[], tmparray:String[]
			Local n:Int, value:String, tmpvar:TVariable
			
			If stream <> Null
				
				csvmap = New TCSVMap.Create()
				
				While stream.Eof() = False
					
					line = stream.ReadLine()
					tmparray = line.Split(",")
					'DebugLog("tmparray.length = " + tmparray.Length)
					CleanArray(tmparray)
					'DebugLog("(second) tmparray.length = " + tmparray.Length)
					
					If row = 0
						
						headers = tmparray
						csvmap.SetHeaders(headers)
						'DebugLog("Set headers array")
						
					Else
						
						If tmparray.Length <= headers.Length
							
							For n = 0 To tmparray.Length - 1
								
								value = tmparray[n].Trim()
								
								If (value = Null And incblanks = True) Or (value <> Null)
									
									tmpvar = TVariable.RawToVariable(value,, headers[n])
									If csvmap.InsertRecord(New TCSVRecord.Create(row - 1, n, tmpvar)) = False
										
										DebugLog("(TCSVMap.ParseStream) Failed to insert record")
										
									End If
									
								End If
								
							Next
							
						Else
							
							DebugLog("(TCSVReader.ParseStream) Line contains too many columns! [" + line + "]")
							
						End If
						
					End If
					
					row:+1
					
				Wend
				
			End If
			
			Return csvmap
			
			Function CleanArray(array:String[] Var)
				Local value:String, n:Int
				
				For n = 0 To array.Length - 1
					
					value = array[n].Trim()
					
					If value.Length > 1
						If value[0] = 34 ' 34 = ~q
							value = value[1..]
						End If
						
						If value[value.Length - 1] = 34 ' 34 = ~q
							value = value[0..value.Length - 1]
						End If
					End If
					
					array[n] = value.Replace("~q~q", "~q")
					
				Next
				
			End Function
			
		End Function
		
		Function BuildKey:String(row:Int, column:Int)
			
			Return String(row) + "_" + String(column)
			
		End Function
		
End Type

Rem
	bbdoc: The TCSVRecord type.
	about: This type holds  type.
End Rem
Type TCSVRecord
	
	Field m_row:Int, m_column:Int
	Field m_variable:TVariable
	
		Method New()
		End Method
		
		Rem
			bbdoc: Create a new CSVRecord.
			returns: The new CSVRecord (itself).
		End Rem
		Method Create:TCSVRecord(row:Int, column:Int, variable:TVariable)
			
			m_row = row
			m_column = column
			
			m_variable = variable
			
			Return Self
			
		End Method
		
		'#region Field accessors
		
		Rem
			bbdoc: Set the row for the CSVRecord.
			returns: Nothing.
		End Rem
		Method SetRow(row:Int)
			
			m_row = row
			
		End Method
		
		Rem
			bbdoc: Get the CSVRecord's row.
			returns: Get the row for the CSVRecord.
		End Rem
		Method GetRow:Int()
			
			Return m_row
			
		End Method
		
		Rem
			bbdoc: Set the column for the CSVRecord.
			returns: Nothing.
		End Rem
		Method SetColumn(column:Int)
			
			m_column = column
			
		End Method
		
		Rem
			bbdoc: Get the CSVRecord's column.
			returns: Get the column for the CSVRecord.
		End Rem
		Method GetColumn:Int()
			
			Return m_column
			
		End Method
		
		Rem
			bbdoc: Set the variable for the CSVRecord.
			returns: Nothing.
		End Rem
		Method SetVariable(variable:TVariable)
			
			m_variable = variable
			
		End Method
		
		Rem
			bbdoc: Get the CSVRecord's variable.
			returns: Get the variable for the CSVRecord.
		End Rem
		Method GetVariable:TVariable()
			
			Return m_variable
			
		End Method
		
		Rem
			bbdoc: Get the CSVRecord's header.
			returns: Get the header for the CSVRecord, or Null if the record's variable is Null.
			about: This will return m_variable.GetName().
		End Rem
		Method GetHeader:String()
			
			If m_variable <> Null
				
				Return m_variable.GetName()
				
			End If
			
			Return Null
			
		End Method
		
		'#end region
		
End Type












































