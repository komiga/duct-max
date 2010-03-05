
' Script parser test01
' Shows some usage of the script parser

SuperStrict

Framework brl.blitz
Import brl.standardio
Import duct.scriptparser

Try
	Local root:dSNode
	root = dSNode.LoadScriptFromObject("test.script")
	If root <> Null
		Local output:String, outstream:TStream
		output = NodeTypeOutput(root)
		Print(output)
		outstream = WriteStream("compare.script")
			root.WriteToStream(outstream)
		outstream.Close()
	Else
		Print("Root node is Null")
	End If
Catch e:dSNodeException
	Print("Caught exception: " + e.ToString())
End Try

Function NodeTypeOutput:String(node:dSNode, prepend:String = "")
	Local bld:String, child:Object, n:dSNode, iden:dIdentifier
	
	For child = EachIn node.GetChildren()
		n = dSNode(child)
		iden = dIdentifier(child)
		If n <> Null
			bld:+prepend + "'" + n.GetName() + "' {~n"
			bld:+NodeTypeOutput(n, prepend + "~t")
			bld:+prepend + "}~n"
		Else If iden <> Null
			' iden.ReportType() will always be "identifier".. but why not?! :)
			bld:+prepend + iden.ReportType() + " "
			For Local variable:dVariable = EachIn iden.GetValues()
				' Use magic.
				bld:+variable.ReportType() + " "
				
				' Deal with variables by-type
				'If dStringVariable(variable)
				'	bld:+"string "
				'Else If dIntVariable(variable)
				'	bld:+"int "
				'Else If dFloatVariable(variable)
				'	bld:+"float "
				'End If
			Next
			bld:+"~n"
		End If
	Next
	Return bld
End Function

