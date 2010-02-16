
' Script parser test02
' Shows some usage of the script parser

SuperStrict

Framework brl.blitz
Import brl.standardio

Import duct.scriptparser

Try
	Local root:TSNode = TSNode.LoadScriptFromObject("test02.script")
	If root <> Null
		Local output:String, outstream:TStream
		
		output = NodeOutput(root)
		Print(output)
		outstream = WriteStream("compare02.script")
			root.WriteToStream(outstream)
		outstream.Close()
	Else
		Print("Root node is Null")
	End If
Catch e:TSNodeException
	Print("Caught exception: " + e.ToString())
End Try

Function NodeOutput:String(node:TSNode, prepend:String = "")
	Local bld:String, child:Object, n:TSNode, iden:TIdentifier
	
	For child = EachIn node.GetChildren()
		n = TSNode(child)
		iden = TIdentifier(child)
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

