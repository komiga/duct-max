
SuperStrict

Framework brl.blitz
Import brl.standardio

Import duct.intmap
Import duct.variables
Import duct.scriptparser

Local bar_single:dTemplate = New dTemplate.Create(["bar"], [[TV_STRING, TV_INTEGER]], True, False, Null)
Local foo_bar:dTemplate = New dTemplate.Create(["foo", "bar"], [[TV_STRING, TV_INTEGER]], True, True, [TV_INTEGER, TV_STRING, TV_BOOL])
Local noname:dTemplate = New dTemplate.Create(Null, [[TV_STRING], [TV_INTEGER]], True, False, Null)
Local noname_onlyflexible:dTemplate = New dTemplate.Create(Null, Null, True, True, [TV_BOOL, TV_STRING])

Local node:dNode = New dNode.Create()
'node.AddVariable(New dStringVariable.Create("foo", "abbadabba"))
node.AddVariable(New dStringVariable.Create("bork", "xy"))
node.AddVariable(New dIntVariable.Create("bar", 1234))
node.AddVariable(New dBoolVariable.Create("bool", True))
node.AddVariable(New dStringVariable.Create("foo", "uv"))
node.AddVariable(New dIntVariable.Create("bar", 4321))
node.AddVariable(New dBoolVariable.Create("bool", True))
node.AddVariable(New dNode.Create("fault"))
node.AddVariable(New dFloatVariable.Create("float", 3.04))
node.AddVariable(New dStringVariable.Create("bar", "oof"))
node.AddVariable(New dStringVariable.Create("bar", "rab"))
node.AddVariable(New dBoolVariable.Create("bool", True))

Test(node, bar_single, "bar_single")
Test(node, foo_bar, "foo_bar")
Test(node, noname, "noname")
Test(node, noname_onlyflexible, "noname_onlyflexible")

Function Test(node:dNode, template:dTemplate, name:String)
	node = node.Copy()
	Local t:Int = MilliSecs()
	Local count:Int = template.CompactCollection(node, name, True)
	Print("time: " + (MilliSecs() - t) + "ms")
	Print("Identifiers added: " + count)
	For Local iden:dIdentifier = EachIn node
		Print(dScriptFormatter.FormatIdentifier(iden))
	Next
End Function
