
SuperStrict

Framework brl.blitz
Import brl.standardio

Import duct.variables
Import duct.scriptparser

Const script:String =	"foo foo bar 1234~n" + ..
						"bar abc def 4321~n" + ..
						"foobar true false 5678 abcdef ~qfed cba~q~n"

Local foo_or_bar:dTemplate = New dTemplate.Create(["foo", "bar"], [[TV_STRING], [TV_STRING], [TV_INTEGER]], True, False, Null)
Local foobar:dTemplate = New dTemplate.Create(["foobar"], [[TV_BOOL], [TV_BOOL]], True, True, [TV_INTEGER, TV_STRING])

Local node:dNode = dScriptFormatter.LoadFromString(script, ENC_ASCII)

Test(node, foo_or_bar, ["one", "two", "three"], Null)
Test(node, foobar, ["one", "two", "three"], "infinitism")

Function Test(node:dNode, template:dTemplate, names:String[], infname:String)
	node = node.Copy()
	Local t:Int = MilliSecs()
	Local count:Int = template.ExpandCollection(node, names, infname)
	Print("time: " + (MilliSecs() - t) + "ms")
	Print("Identifiers added: " + count)
	For Local iden:dValueVariable = EachIn node
		Print(dScriptFormatter.FormatValue(iden))
	Next
End Function

