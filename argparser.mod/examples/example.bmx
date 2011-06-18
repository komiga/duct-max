
SuperStrict

Framework brl.blitz
Import brl.standardio
Import duct.argparser

Local root:dIdentifier = dArgParser.ParseArray(AppArgs[1..], False, -1) ' Appname off, unlimited option args
Print(ArgsToString(root))
Print("#################################")
root = dArgParser.ParseArray(AppArgs, True, 1) ' Appname on, limited option args to one
Print(ArgsToString(root))

Function ArgsToString:String(root:dIdentifier)
	Local build:String = "~q" + root.GetName() + "~q: [", count:Int
	For Local variable:dVariable = EachIn root
		If dIdentifier(variable)
			build:+ ArgsToString(dIdentifier(variable)) + ", "
		Else If dValueVariable(variable)
			Local vv:dValueVariable = dValueVariable(variable)
			build:+ vv.ReportType() + ": ~q" + vv.ValueAsString() + "~q, "
		End If
		count:+1
	Next
	If count > 0 Then build = build[..build.Length - 2]
	Return build + "]"
End Function

