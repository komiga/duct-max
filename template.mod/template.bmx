
Rem
	Copyright (c) 2009 Tim Howard
	
	Permission is hereby granted, free of charge, to any person obtaining a copy
	of this software and associated documentation files (the "Software"), to deal
	in the Software without restriction, including without limitation the rights
	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the Software is
	furnished to do so, subject to the following conditions:
	
	The above copyright notice and this permission notice shall be included in
	all copies or substantial portions of the Software.
	
	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
	THE SOFTWARE.
	-----------------------------------------------------------------------------
	
	template.bmx (Contains: TTemplate, )
	
End Rem

SuperStrict

Rem
bbdoc: Script Template module
End Rem
Module duct.template

ModuleInfo "Version: 0.13"
ModuleInfo "Copyright: Tim Howard"
ModuleInfo "License: MIT"

ModuleInfo "History: Version 0.14"
ModuleInfo "History: Moved TV_* constants to duct.variablemap"
ModuleInfo "History: Version 0.13"
ModuleInfo "History: Added error checking in TTemplate.DeSerialize() and TTemplate.Serialize()"
ModuleInfo "History: Added error checking for Null template idens (the template name check will pass for any identifier name, if the iden array is Null)"
ModuleInfo "History: Version 0.12"
ModuleInfo "History: Modified: TTemplate now supports multiple identifier names"
ModuleInfo "History: Corrected usage of syntax (in Returns, Cases, News and Selects)"
ModuleInfo "History: Version 0.11"
ModuleInfo "History: Initial release"


'Used modules
Import brl.stream

Import duct.etc
Import duct.variables
Import duct.scriptparser


Rem
	bbdoc: The TTemplate type.
	about: Used to validate script identifiers against defined forms (a 'template').
End Rem
Type TTemplate
	
	Rem
		bbdoc: The TTemplate for template identifiers in a script node.
		about: Definition: template "IDENNAME" FLEXIBLE CASESENS INFINITISM VARTYPE_1 VARTYPE_2 VARTYPE_3 ...
		Currently the script definition is limited, INFINITISM does not support multiple values, yet.
	End Rem
	Global Template:TTemplate = New TTemplate.Create(["template"], [[TV_STRING], [TV_INTEGER], [TV_INTEGER] ], False, True, [TV_INTEGER])
	
	Field iden:String[]
	Field vars:Int[][]
	
	Field flexible:Int
	Field casesens:Int
	Field infinitism:Int[]
	
		Method New()
		End Method
		
		Rem
			bbdoc: Create a template.
			returns: The new template.
			about: @_iden: The name of the Identifier.
			@_vars: An array of arrays (see #SetVars).
			@_casesens: Check identifier name with case sensitivity?
			@_flexible: The flexibility of the Identifier (see #SetFlexible).
			@_infinitism: Use infinitism? (see #SetInfinitism).
		End Rem
		Method Create:TTemplate(_iden:String[], _vars:Int[][], _casesens:Int = False, _flexible:Int = False, _infinitism:Int[] = Null)
			
			SetIden(_iden)
			SetVars(_vars)
			
			SetFlexible(_flexible)
			SetCaseSensitive(_casesens)
			
			If _infinitism <> Null Then SetInfinitism(_infinitism)
			
			Return Self
			
		End Method
		
		Rem
			bbdoc: Set infinitism (type of flexibility).
			returns: Nothing.
			about: This will only be used if the template is flexible.
			If Null the template will not care about the type of variable that is after the defined variables.
			If set to a TV_ variable (or multiple TV_ variables), the template will require that a certain type of variable(s) be after the defined variables.
			
			e.g.
			template.SetVars([[TV_STRING], [TV_FLOAT]])
			template.SetFlexible(True)
			template.SetInfinitism([TV_INTEGER])
			Now the identifier can only have variables of the INTEGER type after the end of the defined variables (string, then float)
			someidentifier stringvar floatvar aninteger anotherinteger anotherinteger ... etc.
		End Rem
		Method SetInfinitism(_infinitism:Int[])
			
			infinitism = _infinitism
			
		End Method
		
		Rem
			bbdoc: Get the infinitism (type of flexibility) for the template.
			returns: The infinitism field (False, or a TV_ constant).
		End Rem
		Method GetInfinitism:Int[] ()
			
			Return infinitism
			
		End Method
		
		Rem
			bbdoc: Set the case sensitivity for checking the identifier name.
			returns: Nothing.
		End Rem
		Method SetCaseSensitive(_casesens:Int)
			
			casesens = _casesens
			
		End Method
		
		Rem
			bbdoc: Get the case sensitivity for checking the identifier name.
			returns: The case sensitivity (True or False).
		End Rem
		Method GetCaseSensitive:Int()
			
			Return casesens
			
		End Method
		
		Rem
			bbdoc: Set the flexibility for the template.
			returns: Nothing.
			about: If True the template will require the defined set of variables (Infinitism), then allow the rest of the 
			variables at the end of the identifier; if False the template will only allow the defined set of variables.
		End Rem
		Method SetFlexible(_flexible:Int)
			
			flexible = _flexible
			
		End Method
		
		Rem
			bbdoc: Get the flexibility for the template.
			returns: The flexibility field (True or False).
		End Rem
		Method GetFlexible:Int()
			
			Return flexible
			
		End Method
		
		Rem
			bbdoc: Set the identifier name for the template.
			returns: Nothing.
		End Rem
		Method SetIden(_iden:String[])
			
			iden = _iden
			
		End Method
		
		Rem
			bbdoc: Get the identifier name for the template.
			returns: The identifier name.
		End Rem
		Method GetIden:String[] ()
			
			Return iden
			
		End Method
		
		Rem
			bbdoc: Set the variable definitions for the template.
			returns: Nothing.
			about: Example: template.SetVars([[TV_INTEGER, TV_STRING], [TV_FLOAT]])
			That means that the first variable can be either an integer or a string, and the second can only be a float.
		End Rem
		Method SetVars(_vars:Int[][])
			
			vars = _vars
			
		End Method
		
		Rem
			bbdoc: Get the variable definitions for the template.
			returns: The variable definitions.
		End Rem
		Method GetVars:Int[][] ()
			
			Return vars
			
		End Method
		
		Rem
			bbdoc: Serialize the template into a stream.
			returns: Nothing.
		End Rem
		Method Serialize(stream:TStream)
			Local tmpsize:Int, i:Int
			
			If iden <> Null Then tmpsize = iden.Length
			stream.WriteInt(tmpsize)
			If tmpsize > 0
				
				For i = 0 To tmpsize - 1
					
					WriteNString(stream, iden[i])
					
				Next
				
			End If
			
			stream.WriteInt(flexible)
			stream.WriteInt(casesens)
			
			tmpsize = 0
			If infinitism <> Null Then tmpsize = infinitism.Length
			stream.WriteInt(tmpsize)
			If tmpsize > 0
				
				For i = 0 To tmpsize - 1
					
					stream.WriteInt(infinitism[i])
					
				Next
				
			End If
			
			tmpsize = 0
			If vars <> Null Then tmpsize = vars.Length
			stream.WriteInt(tmpsize)
			If tmpsize > 0
				
				For i = 0 To tmpsize - 1
					Local varray:Int[], ix:Int
					
					varray = vars[i]
					stream.WriteInt(varray.Length)
					
					For ix = 0 To varray.Length - 1
						
						stream.WriteInt(varray[ix])
						
					Next
					
				Next
				
			End If
			
		End Method
		
		Rem
			bbdoc: DeSerialize a template from a stream.
			returns: The DeSerialized template.
		End Rem
		Method DeSerialize:TTemplate(stream:TStream)
			Local tmpsize:Int, i:Int
			
			tmpsize = stream.ReadInt()
			If tmpsize > 0
				
				iden = New String[tmpsize]
				
				For i = 0 To tmpsize - 1
					
					iden[i] = ReadNString(stream, 768)
					
				Next
				
			End If
			
			flexible = stream.ReadInt()
			casesens = stream.ReadInt()
			
			tmpsize = 0
			tmpsize = stream.ReadInt()
			If tmpsize > 0
				
				infinitism = New Int[tmpsize]
				
				For i = 0 To tmpsize - 1
					
					infinitism[i] = stream.ReadInt()
					
				Next
				
			End If
			
			tmpsize = 0
			tmpsize = stream.ReadInt()
			If tmpsize > 0
				
				vars = New Int[][tmpsize]
				If vars.Length > 40 Then DebugLog("TTemplate.DeSerialize() WARNING: Possible corrupt template stream, template data contains a unusually large number of variables (" + vars.Length + ")")
				
				For i = 0 To tmpsize - 1
					Local varray:Int[], ix:Int
					
					varray = New Int[stream.ReadInt()]
					
					For ix = 0 To varray.Length - 1
						
						varray[ix] = stream.ReadInt()
						
					Next
					
					vars[i] = varray
					
				Next
				
			End If
			
			Return Self
			
		End Method
		
		Rem
			bbdoc: Validate an identifier.
			returns: True if the identifier matches the template, False if it does not (or if the Identifier is Null).
		End Rem
		Method ValidateIdentifier:Int(identifier:TIdentifier)
			
			If identifier <> Null
				
				If CheckNames(iden, identifier.GetName(), casesens) = True
					
					If identifier.GetValueCount() > vars.Length And flexible = False Then Return False ElseIf identifier.GetValueCount() < vars.Length Then Return False
					
					' Compare defined variables in the identifier
					For Local i:Int = 0 To vars.Length - 1
						Local cmpvar:TVariable
						
						cmpvar = TVariable(identifier.GetValues().ValueAtIndex(i))
						
						If cmpvar <> Null
							Local cmp:Int
							
							cmp = CheckVariable(vars[i], cmpvar)
							
							Select cmp
								Case False
									Return False
									
								Case True
									' Don't need to do anything here, just assert the case else Default would pick it up
									
								Default
									DebugLog("TTemplate.ValidateIdentifier() WARNING: vars[" + i + "][" + (- cmp) + "] (=" + vars[i][(- cmp)] + ") is not a valid TV_ constant; Returning False..")
									Return False
									
							End Select
							
						Else
							
							DebugLog("TTemplate.ValidateIdentifier() WARNING: cmpvar is Null (at index " + i + ", likely unable to convert object to TVariable)")
							
						End If
						
					Next
					
					' Check flexible and infinitism
					If identifier.GetValueCount() > vars.Length
						If flexible = True
							
							If GetInfinitism() <> Null
								
								For Local i:Int = vars.Length To identifier.GetValueCount() - 1
									Local cmp:Int
									
									cmp = CheckVariable(infinitism, TVariable(identifier.GetValues().ValueAtIndex(i)))
									
									Select cmp
										Case False
											Return False
											
										Case True
											'Don't need to do anything here, just assert the case because Default would pick it up
											
										Default
											DebugLog("TTemplate.ValidateIdentifier() WARNING: Infinitism contains an invalid TV_ constant (index " + ((- cmp) - 1) + ", " + infinitism[(- cmp) - 1] + "); Returning False.. ")
											Return False
											
									End Select
									
								Next
								
							End If
							
						End If
					End If
					
					Return True
					
				Else
					
					'DebugLog("TTemplate.ValidateIdentifier(); Identifier name did not match any in the list")
					
				End If
				
			Else
				
				DebugLog("TTemplate.ValidateIdentifier(); Identifier is Null")
				
			End If
			
			Return False
			
			
			'Sub-functions
				Function CheckVariable:Int(tvarray:Int[], variable:TVariable)
					
					If variable <> Null
						Local i:Int
						
						For i = 0 To tvarray.Length - 1
							
							Select tvarray[i]
								Case TV_INTEGER
									If TIntVariable(variable)
										
										Return True
										
									End If
									
								Case TV_STRING
									If TStringVariable(variable)
										
										Return True
										
									End If
									
								Case TV_FLOAT
									If TFloatVariable(variable)
										
										Return True
										
									End If
									
								Case TV_EVAL
									If TEvalVariable(variable)
										
										Return True
										
									End If
									
								Default
									'Error, return negative index (for determining that there was an error and where it occured)
									Return - (i + 1)
									
							End Select
							
						Next
						
					End If
					
					Return False
					
				End Function
				
				Function CheckNames:Int(names:String[], tocheck:String, casesens:Int)
					Local cv1:String, i:Int
					
					If names <> Null
						
						If casesens = False Then tocheck = tocheck.ToLower()
						
						For i = 0 To names.Length - 1
							cv1 = names[i]
							
							If casesens = False Then cv1 = cv1.ToLower()
							
							'DebugLog("ValidateIdentifier.CheckNames(): ~q" + cv1 + "~q ~q" + tocheck + "~q")
							If cv1 = tocheck Then Return True
							
						Next
						
						Return False
						
					Else
						
						' Null iden name = will pass for any name
						Return True
						
					End If
					
				End Function
				
		End Method
		
End Type

























