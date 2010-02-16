
' Script parser test01
' Shows some usage of the script parser

SuperStrict

Framework brl.blitz
Import brl.standardio
Import duct.scriptparser

Try
	Local root:TSNode
	root = TSNode.LoadScriptFromObject("test.script")
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
Catch e:TSNodeException
	Print("Caught exception: " + e.ToString())
End Try

Function NodeTypeOutput:String(node:TSNode, prepend:String = "")
	Local bld:String, child:Object, n:TSNode, iden:TIdentifier
	
	For child = EachIn node.GetChildren()
		n = TSNode(child)
		iden = TIdentifier(child)
		
		If n <> Null
			bld:+prepend + "'" + n.GetName() + "' {~n"
			bld:+NodeTypeOutput(n, prepend + "~t")
			bld:+prepend + "}~n"
		Else If iden <> Null
			Local variable:TVariable
			
			' iden.ReportType() will always be "identifier".. but why not?! :)
			bld:+prepend + iden.ReportType() + " "
			
			For variable = EachIn iden.GetValues()
				' Use magic.
				bld:+variable.ReportType() + " "
				
				' Deal with variables by-type
				'If TStringVariable(variable)
				'	bld:+"string "
				'Else If TIntVariable(variable)
				'	bld:+"int "
				'Else If TFloatVariable(variable)
				'	bld:+"float "
				'End If
			Next
			bld:+"~n"
		End If
	Next
	Return bld
End Function

