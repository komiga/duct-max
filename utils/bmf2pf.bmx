
SuperStrict

Framework brl.blitz
Import brl.standardio
Import brl.filesystem
Import brl.textstream

Import brl.pngloader
Import brl.bmploader
Import brl.jpgloader
Import brl.tgaloader

Import bah.regex

Import duct.scriptparser
Import duct.protog2d

Global out_file:String, out_binary:Int = False, out_writetexture:Int = False
Global in_file:String, char_empty:Int = -1

Print("BMFont to Protog font converter")

Local opt:String, optarg:String
While GetOpts("i:o:bte:h", opt, optarg) = True
	Select opt
		Case "h"
			PrintHelp()
			End
		Case "b"
			out_binary = True
		Case "t"
			out_writetexture = True
		Case "i"
			in_file = optarg
		Case "o"
			out_file = optarg
		Case "e"
			char_empty = Int(optarg)
			
		Default
			Print("Unspecified parameter: " + opt)
			End
			
	End Select
Wend

If in_file = Null
	Print("Input file was not specified!")
	End
Else If out_file = Null
	Print("Output file was not specified!")
	End
End If

If FileType(in_file) = FILETYPE_NONE
	Print("Input file was not found!")
	End
End If

Print("Processing...")
Convert()
Print("Done!")

Function Convert()
	Local text:String, output:String, regex:TRegEx
	text = LoadText(in_file)
	regex = TRegEx.Create("\S+\=")
	output = regex.ReplaceAll(text, "")
	SaveText(output, "tmp")
	
	Local root:dSNode, converted:dSNode
	root = dSNode.LoadScriptFromObject("tmp", SNPEncoding_UTF8)
	converted = ConvertToScript(root)
	
	Print("Converting...")
	If out_binary = True
		ConvertToBinary(converted)
	Else
		converted.WriteToFile(out_file)
	End If
	DeleteFile("tmp")
End Function

Function ConvertToScript:dSNode(root:dSNode)
	Local child:dIdentifier, cname:String
	Local ivar:dIntVariable, char:Int
	Local node:dSNode, iden:dIdentifier
	
	node = New dSNode.Create(Null)
	
	For child = EachIn root.GetChildren()
		cname = child.GetName()
		If cname = "info"
			iden = New dIdentifier.CreateByData("name")
			iden.AddValue(child.GetValueAtIndex(0))
			node.AddIdentifier(iden)
			iden = New dIdentifier.CreateByData("height")
			ivar = dIntVariable(child.GetValueAtIndex(1))
			iden.AddValue(New dFloatVariable.Create(Null, Float(ivar.Get())))
			node.AddIdentifier(iden)
		Else If cname = "page"
			iden = New dIdentifier.CreateByData("texture")
			iden.AddValue(child.GetValueAtIndex(1))
			node.AddIdentifier(iden)
		Else If cname = "char"
			iden = New dIdentifier.CreateByData("char")
			ivar = dIntVariable(child.GetValueAtIndex(0)) ' char (id)
			char = ivar.Get()
			iden.AddValue(ivar)
			ivar = dIntVariable(child.GetValueAtIndex(3)) ' width (width)
			iden.AddValue(New dFloatVariable.Create(Null, Float(ivar.Get())))
			ivar = dIntVariable(child.GetValueAtIndex(4)) ' height (height)
			iden.AddValue(New dFloatVariable.Create(Null, Float(ivar.Get())))
			ivar = dIntVariable(child.GetValueAtIndex(1)) ' xpos (x)
			iden.AddValue(New dFloatVariable.Create(Null, Float(ivar.Get())))
			ivar = dIntVariable(child.GetValueAtIndex(2)) ' ypos (y)
			iden.AddValue(New dFloatVariable.Create(Null, Float(ivar.Get())))
			ivar = dIntVariable(child.GetValueAtIndex(6)) ' offsety (offsety)
			iden.AddValue(New dFloatVariable.Create(Null, Float(ivar.Get())))
			node.AddIdentifier(iden)
			If char = char_empty
				iden = iden.Copy()
				dIntVariable(iden.GetValueAtIndex(0)).Set(- 1)
				node.AddIdentifier(iden)
			End If
		End If
	Next
	Return node
End Function

Function ConvertToBinary(root:dSNode)
	Local pfont:dProtogFont
	
	pfont = New dProtogFont.FromNode(root, False)
	
	Local streamout:TStream
	streamout = WriteStream(out_file)
	pfont.Serialize(streamout, out_writetexture)
	streamout.Close()
	
	pfont = Null
	
End Function

Function PrintHelp()
	
	Print("Parameters: ")
	Print("~t'i' is the file to be converted")
	Print("~t'o' is the file to be written to")
	Print("~t'b' tells the converter to output to the binary format (as opposed to the script format)")
	Print("~t't' tells the converter to write the texture to the output file (only applicable if the output format is binary)")
	Print("~t'e' is the character code which will be used as the empty char (the original character is left though, you just get -1 bound to the same location)~n")
	Print("~t'h' displays this information")
	
	Print("~nExample usages:")
	Print("~tbmf2pf -i myfont.fnt -o converted.font -e 191")
	Print("~tbmf2pf -i myfont.fnt -o converted.font -b -t")
	
End Function

Function GetOpts:Int(tokens:String, opt:String Var, optarg:String Var)
	Global av:String[] = Null
	Global isparsed:Int = False
	If (Not isparsed) Then
		av = New String[0] 
		For Local n:Int = 1 Until AppArgs.Length
			If (AppArgs[n][0..1] = "-") Then
				For Local i:Int = 1 Until AppArgs[n].Length
					av = av[..av.Length + 1] 
					av[av.length - 1] = "-" + AppArgs[n][i..i + 1] 
				Next
			Else
				av = av[..av.Length + 1] 
				av[av.length - 1] = AppArgs[n] 
			End If
		Next
		isparsed = True
	End If
	
	opt = "" optarg = ""
	If (av.Length = 0) Then Return False
	opt = av[0]  av = av[1..] 
	
	If(opt[0..1] <> "-") Then Return True
	
	Local idx:Int = tokens.Find(opt[1..]) 
	If (idx = -1) Then
		WriteStderr("Unrecognized option '" + opt + "' specified.~n") 
		End
	End If
	
	If (idx < tokens.length - 1) Then
		If (tokens[idx + 1..idx + 2] = ":") Then
			If (av.length = 0 Or av[0][0..1] = "-") Then
				WriteStderr("Missing value for option '" + opt + "'~n") 
				End
			End If
			optarg = av[0]  av = av[1..] 
		End If
	End If
	
	opt = opt[1..] 
	Return True
	
End Function

