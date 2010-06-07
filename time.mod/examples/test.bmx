
SuperStrict

Framework brl.blitz
Import brl.standardio
Import duct.time

Local format:String = "%FT%TZ", convtz:String = "UTC"
If AppArgs.Length > 1 Then format = AppArgs[1]
If AppArgs.Length > 2 Then convtz = AppArgs[2]

Local tc:dTime = New dTime.CreateFromCurrent()
Print(tc.Format(format))
Print(tc.Format(format, "UTC"))

tc.SetFromPath("test.bmx")
Print(tc.Format(format, convtz))

Local str:String = "2009-07-01T11:12:05Z"
Print(tc.SetFromFormatted(str, format, convtz))
Print(str)
Print(tc.Format(format, "UTC"))
Print(tc.Format(format, Null))

tc.SetCurrent()
Print(tc.Format(format, "UTC"))

