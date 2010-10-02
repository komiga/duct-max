
SuperStrict

Framework brl.blitz
Import brl.standardio

Import duct.csv

Local file:String = "in.csv"
Local csvmap:dCSVMap = New dCSVMap.DeserializeFromFile(file, ",", True)

If csvmap
	Local variable:dValueVariable
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
	csvmap.SerializeToFile("out.csv", ",", FMT_ALL_DEFAULT ~ FMT_STRING_QUOTE_EMPTY) ' Custom format (all defaults, except for quote empty string)
Else
	Print("Failed to read " + file)
End If

