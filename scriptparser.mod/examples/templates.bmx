
SuperStrict

Framework brl.blitz
Import brl.standardio

Import duct.scriptparser

Local tpl_test01:dTemplate = New dTemplate.Create(["test01", "testalt01"], [[TV_INTEGER], [TV_STRING], [TV_FLOAT]])
Local tpl_test02:dTemplate = New dTemplate.Create(["Test02", "TestAlt02"], [[TV_INTEGER, TV_STRING, TV_FLOAT]], True)
Local tpl_test03:dTemplate = New dTemplate.Create(["test03"], [[TV_STRING]], False, True)
Local tpl_test04:dTemplate = New dTemplate.Create(["test04"], [[TV_STRING], [TV_INTEGER]], False, True, [TV_INTEGER])
Local tpl_test05:dTemplate = New dTemplate.Create(["test05"], [[TV_BOOL]], False, True, [TV_INTEGER, TV_STRING, TV_FLOAT])
Local tpl_test06:dTemplate = New dTemplate.Create(["test06"], [[TV_FLOAT]], False, True, [TV_INTEGER, TV_STRING, TV_FLOAT])
Local tpl_test07:dTemplate = New dTemplate.Create(Null, [[TV_INTEGER], [TV_STRING]])

Local tpl_bools:dTemplate = New dTemplate.Create(["bools"], [[TV_BOOL], [TV_BOOL], [TV_BOOL], [TV_BOOL]])

Try
	Local root:dNode = dScriptFormatter.LoadFromFile("templates.script")
	If root
		Local pass:Int
		For Local identifier:dIdentifier = EachIn root
			pass = False
			Select identifier.GetName().ToLower()
				Case "test01", "testalt01"
					pass = tpl_test01.ValidateIdentifier(identifier)
				Case "test02", "testalt02"
					pass = tpl_test02.ValidateIdentifier(identifier)
				Case "test03"
					pass = tpl_test03.ValidateIdentifier(identifier)
				Case "test04"
					pass = tpl_test04.ValidateIdentifier(identifier)
				Case "test05"
					pass = tpl_test05.ValidateIdentifier(identifier)
				Case "test06"
					pass = tpl_test06.ValidateIdentifier(identifier)
				Case "bools"
					pass = tpl_bools.ValidateIdentifier(identifier)
				Default
					pass = tpl_test07.ValidateIdentifier(identifier)
			End Select
			If pass = True
				Print("Identifier: passed {" + dScriptFormatter.FormatIdentifier(identifier) + "}")
			Else If pass = False
				Print("Identifier: failed {" + dScriptFormatter.FormatIdentifier(identifier) + "}")
			End If
		Next
	Else
		DebugLog("Root node is Null")
	End If
Catch e:dScriptException
	DebugLog("Failed to load templates.script: " + e.ToString())
End Try

