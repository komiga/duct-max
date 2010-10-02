
SuperStrict

Framework brl.blitz
Import brl.standardio

Import duct.ini

Local root:dNode = dIniFormatter.LoadFromFile("in.ini", ENC_UTF8)
If root
	If dIniFormatter.WriteToFile(root, "out.ini")
		Print("Wrote out.ini")
	Else
		Print("Failed to write out.ini")
	End If
Else
	Print("Failed to read in.ini")
End If

