
SuperStrict

Framework brl.blitz
Import brl.standardio

Import duct.csv

Local file:String = "test.csv"
Local csvmap:dCSVMap = New dCSVMap.DeserializeFromFile(file, ",", True)

If csvmap
	Local variable:dVariable
	Print("There are: " + csvmap.GetHeaderCount() + " possible column(s), " + csvmap.GetRowCount() + " row(s), and " + csvmap.GetRecordCount() + " record(s)")
	For Local row:dCSVRow = EachIn csvmap
		For Local record:dCSVRecord = EachIn row
			WriteStdOut("(" + row.GetIndex() + ", " + record.GetIndex() + ")~t")
			variable = record.GetVariable()
			If variable
				Print(variable.ReportType() + ": `" + variable.ValueAsString() + "`")
			Else
				Print("null: ``")
			End If
		Next
	Next
	WriteStdout("~n")
	csvmap.SerializeToFile("testout.csv", ",", True)
Else
	Print("Failed to read " + file + "!")
End If

