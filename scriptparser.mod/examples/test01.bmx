
' Script parser test01
' Shows some usage of the script parser

SuperStrict

Framework brl.blitz
Import brl.standardio

Import duct.scriptparser


Try
	
	Local node:TSNode
	
	node = TSNode.LoadScriptFromFile("test.script")
	
	If node <> Null
	  Local output:String
		
		output = NodeOutput(node)
		Print(output)
		
		Local outstream:TStream = WriteStream("compare.script")
			node.WriteToStream(outstream)
		outstream.Close()
		
	Else
		
		Print("Node is Null")
		
	End If
	
Catch e:String
	
	Print("Caught exception: " + e)
	
End Try


Function NodeOutput:String(node:TSNode)
  Local bld:String, child:Object, n:TSNode, iden:TIdentifier
	
	For child = EachIn node.GetChildren()
		n = TSNode(child); iden = TIdentifier(child)
		
		If n <> Null
			bld:+"Name: '" + n.GetName() + "'~n"
			bld:+NodeOutput(n)
			
		Else If iden <> Null
			bld:+iden.GetName() + " "
			
			For Local v:TVariable = EachIn iden.GetValues()
				
				If TStringVariable(v)
					
					bld:+"~q" + TStringVariable(v).Get() + "~q "
					
				Else If TIntVariable(v)
					
					bld:+TIntVariable(v).Get() + " "
					
				Else If TFloatVariable(v)
					
					bld:+TFloatVariable(v).Get() + " "
					
				Else If TEvalVariable(v)
					
					bld:+TEvalVariable(v).Get() + " "
					
				End If
				
			Next
			
			bld:+"~n"
			
		End If
		
	Next
	
	Return bld
	
End Function
















