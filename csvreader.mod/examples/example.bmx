
Rem
	example.bmx
	
	Description:
				A simple test for duct.csvreader!
				
	
End Rem

SuperStrict

Framework brl.blitz
Import brl.standardio

Import duct.csvreader

Local file:String = "test.csv", includeblanks:Int = False
Local csvmap:TCSVMap = TCSVMap.ParseFile(file, includeblanks)

If csvmap <> Null
	' First way of enumerating
	Local record:TCSVRecord, variable:TVariable
	
	Print("There are: " + csvmap.GetHeaderCount() + " possible column(s), " + csvmap.GetRowCount() + " row(s), and " + csvmap.Count() + " total record(s)")
	For record = EachIn csvmap.ValueEnumerator()
		
		variable = record.GetVariable()
		Print("(" + record.GetRow() + ", " + record.GetColumn() + ")")
		Print(variable.ReportType() + ": `" + variable.GetName() + "` | `" + variable.ValueAsString() + "`")
		
	Next
	WriteStdout("~n")
	
	' Second way of enumerating
	Local row:Int, column:Int
	Local headers:String[]
	
	headers = csvmap.GetHeaders()
	For column = 0 To csvmap.GetHeaderCount() - 1
		
		WriteStdout("`" + headers[column] + "`")
		If column < csvmap.GetHeaderCount() - 1 Then WriteStdout(", ")
		
	Next
	WriteStdout("~n")
	
	For row = 0 To csvmap.GetRowCount() - 1
		
		WriteStdout("Row " + row + " (" + csvmap.GetRowRecordCount(row) + " records): ")
		
		For column = 0 To csvmap.GetHeaderCount() - 1
			
			record = csvmap.GetRecordByPosition(row, column)
			
			If record <> Null
				
				WriteStdout("[" + column + "]`" + record.GetVariable().ValueAsString() + "`")
				If column < csvmap.GetHeaderCount() - 1 Then WriteStdout(", ")
				
			End If
			
		Next
		
		WriteStdout("~n")
		
	Next
	
Else
	
	Print("Failed to read " + file + "!")
	
End If








































