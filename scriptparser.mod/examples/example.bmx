
SuperStrict

Framework brl.blitz
Import brl.standardio

Import duct.scriptparser

Try
	Local root:dNode = dScriptFormatter.LoadFromFile("in.script")
	If root
		Local output:String = NodeOutput(root)
		Print(output)
		dScriptFormatter.WriteToFile(root, "out.script")
	Else
		Print("Root node is Null")
	End If
Catch e:dScriptException
	Print("Caught exception: " + e.ToString())
End Try

Function NodeOutput:String(node:dNode, prepend:String = "")
	Local bld:String, n:dNode, i:dIdentifier, v:dValueVariable
	For Local child:dVariable = EachIn node.GetChildren()
		n = dNode(child)
		i = dIdentifier(child)
		v = dValueVariable(child)
		If n
			bld:+ prepend + "Name: '" + n.GetName() + "'~n"
			bld:+ NodeOutput(n, prepend + "~t")
		Else If i
			bld:+ prepend + dScriptFormatter.FormatIdentifier(i)
			bld:+ prepend + "~n"
		Else If v
			bld:+ prepend + dScriptFormatter.FormatValue(v)
			bld:+ prepend + "~n"
		End If
	Next
	Return bld
End Function

