SuperStrict
Framework brl.blitz
Import brl.standardio
Import duct.json

Local jreader:dJReader = New dJReader.InitWithString("{ ~qmodule~q: { ~qname~q: ~qvalue~q, ~qnumber~q: 1234.567, ~qsuperman~q: [~qohai~q, 100, 1234.12, true, false, null] } }")
Local root:dJObject = jreader.Parse()

PrintObject(root)
Function PrintObject(obj:dJObject, tablevel:String = "")
	Local lastvar:TVariable = TVariable(obj.GetValues().Last())
	For Local variable:TVariable = EachIn obj.GetValues()
		If dJArray(variable)
			If variable.GetName() <> Null
				Print(tablevel + "~q" + variable.GetName() + "~q: [")
			Else
				Print(tablevel + "[")
			End If
			PrintObject(dJObject(variable), tablevel + "~t")
			Print(tablevel + "]")
		Else If dJObject(variable)
			If variable.GetName() <> Null
				Print(tablevel + "~q" + variable.GetName() + "~q: {")
			Else
				Print(tablevel + "{")
			End If
			PrintObject(dJObject(variable), tablevel + "~t")
			Print(tablevel + "}")
		Else
			If Not dJArray(obj)
				WriteStdout(tablevel + "~q" + variable.GetName() + "~q: " + variable.ConvToString())
			Else
				WriteStdout(tablevel + "" + variable.ConvToString())
			End If
			If variable <> lastvar
				Print(",")
			Else
				Print("")
			End If
		End If
	Next
End Function