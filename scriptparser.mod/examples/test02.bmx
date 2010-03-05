
' Script parser test02
' Shows some usage of the script parser

SuperStrict

Framework brl.blitz
Import brl.standardio

Import duct.scriptparser

Try
	Local root:dSNode = dSNode.LoadScriptFromObject("test02.script")
	If root <> Null
		Local output:String = NodeOutput(root)
		Print(output)
		Local outstream:TStream = WriteStream("compare02.script")
		root.WriteToStream(outstream)
		outstream.Close()
	Else
		Print("Root node is Null")
	End If
Catch e:dSNodeException
	Print("Caught exception: " + e.ToString())
End Try

Function NodeOutput:String(node:dSNode, prepend:String = "")
	Local bld:String
	For Local child:Object = EachIn node.GetChildren()
		Local n:dSNode = dSNode(child)
		Local iden:dIdentifier = dIdentifier(child)
		If n <> Null
			bld:+prepend + "Name: '" + n.GetName() + "'~n"
			bld:+NodeOutput(n, prepend + "~t")
		Else If iden <> Null
			bld:+prepend + iden.ConvToString()
			bld:+prepend + "~n"
		End If
	Next
	Return bld
End Function

