
SuperStrict

Framework brl.blitz
Import brl.standardio
Import duct.json

Local jreader:dJReader = New dJReader.InitWithString("{ ~qmodule~q: { ~qname~q: ~qvalue~q, ~qnumber~q: 1234.567, ~qsuperman~q: [~qohai~q, 100, 1234.12, true, false, null] } }")
Local root:dJObject = jreader.Parse()

PrintObject(root)
Function PrintObject(obj:dJObject, tablevel:String = "")
	Local lastvar:dVariable = dVariable(obj.GetChildren().Last())
	For Local child:dVariable = EachIn obj
		If dJArray(child)
			If child.GetName()
				Print(tablevel + "~q" + child.GetName() + "~q: [")
			Else
				Print(tablevel + "[")
			End If
			PrintObject(dJObject(child), tablevel + "~t")
			Print(tablevel + "]")
		Else If dJObject(child)
			If child.GetName()
				Print(tablevel + "~q" + child.GetName() + "~q: {")
			Else
				Print(tablevel + "{")
			End If
			PrintObject(dJObject(child), tablevel + "~t")
			Print(tablevel + "}")
		Else
			Local v:dValueVariable = dValueVariable(child)
			Local i:dIdentifier = dIdentifier(child)
			If Not dJArray(obj)
				WriteStdout(tablevel + "~q" + child.GetName() + "~q: ")
				If v
					WriteStdout(v.GetValueFormatted(FMT_ALL_DEFAULT))
				End If
			Else
				WriteStdout(tablevel)
				If v
					WriteStdout(v.GetValueFormatted(FMT_ALL_DEFAULT))
				End If
			End If
			If child <> lastvar
				Print(",")
			Else
				Print("")
			End If
		End If
	Next
End Function

