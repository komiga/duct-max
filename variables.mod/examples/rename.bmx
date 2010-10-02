
SuperStrict

Framework brl.blitz
Import brl.standardio

Import duct.variables
Import duct.scriptparser

Const script:String =	"foo foo bar 1234~n" + ..
						"bar abc def 4321~n" + ..
						"foobar true false 5678 abcdef ~qfed cba~q~n" + ..
						"blargh = 100~n" + ..
						"blargh = 123~n" + ..
						"fuubar = ~qmatch~q~n" + ..
						"fUUBar = match2~n" + ..
						"FUUBAR = false"

Local foo_or_bar:dTemplate = New dTemplate.Create(["foo", "bar"], [[TV_STRING], [TV_STRING], [TV_INTEGER]], True, False, Null)
Local foobar:dTemplate = New dTemplate.Create(["foobar"], [[TV_BOOL], [TV_BOOL]], True, True, [TV_INTEGER, TV_STRING])

Local blargh:dTemplate = New dTemplate.Create(Null, [[TV_INTEGER]], False, False, Null)
Local fuubar:dTemplate = New dTemplate.Create(["fuubar"], Null, False, True, [TV_STRING])

Local node:dNode = dScriptFormatter.LoadFromString(script, ENC_ASCII)

foo_or_bar.RenameVariables(node, "_foo_or_bar")
foobar.RenameVariables(node, "_foobar")
blargh.RenameVariables(node, "_blargh")
fuubar.RenameVariables(node, "_fuubar")

Local i:dIdentifier, v:dValueVariable
For Local child:dVariable = EachIn node
	i = dIdentifier(child)
	v = dValueVariable(child)
	If i
		Print(dScriptFormatter.FormatIdentifier(i))
	Else If v
		Print(dScriptFormatter.FormatValue(v))
	End If
Next

