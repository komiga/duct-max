
' Templates test

SuperStrict

Framework brl.blitz
Import brl.standardio

Import duct.scriptparser

Local tpl_test01:TTemplate = New TTemplate.Create(["test01", "testalt01"], [[TV_INTEGER], [TV_STRING], [TV_FLOAT], [TV_EVAL] ])
Local tpl_test02:TTemplate = New TTemplate.Create(["Test02", "TestAlt02"], [[TV_INTEGER, TV_STRING, TV_FLOAT, TV_EVAL] ], True)
Local tpl_test03:TTemplate = New TTemplate.Create(["test03"], [[TV_STRING] ], False, True)
Local tpl_test04:TTemplate = New TTemplate.Create(["test04"], [[TV_EVAL] ], False, True, [TV_INTEGER])
Local tpl_test05:TTemplate = New TTemplate.Create(["test05"], [[TV_EVAL] ], False, True, [TV_INTEGER, TV_STRING, TV_FLOAT])
Local tpl_test06:TTemplate = New TTemplate.Create(["test06"], [[TV_FLOAT] ], False, True, [TV_INTEGER, TV_STRING, TV_FLOAT])

Local tpl_test07:TTemplate = New TTemplate.Create(Null, [[TV_INTEGER], [TV_STRING] ])
Local root:TSNode

Try
	root = TSNode.LoadScriptFromObject("templates.scc")
	If root <> Null
		Local pass:Int, identifier:TIdentifier
		For identifier = EachIn root.GetChildren()
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
				Default
					pass = tpl_test07.ValidateIdentifier(identifier)
			End Select
			If pass = True
				Print("Identifier: PASSED {" + identifier.ConvToString() + "}")
			Else If pass = False
				Print("Identifier: FAILED {" + identifier.ConvToString() + "}")
			End If
		Next
	Else
		DebugLog("root node is Null, unknown reason")
	End If
	
Catch e:String
	DebugLog("Failed to load script 'testscript.scc': " + e)
End Try

