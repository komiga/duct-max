
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
	
	snode.bmx (Contains: TTemplate, )
	
End Rem

Rem
	bbdoc: #TIdentifier template (provides a sort of validation for different formats).
End Rem
Type TTemplate
	
	Rem
		bbdoc: The TTemplate for template identifiers in a script node.
		about: Definition: template "IDENNAME" FLEXIBLE CASESENS INFINITISM VARTYPE_1 VARTYPE_2 VARTYPE_3<br />
		Currently the script definition is limited, INFINITISM does not support multiple values, yet.
	End Rem
	Global m_template:TTemplate = New TTemplate.Create(["template"], [[TV_STRING], [TV_INTEGER], [TV_INTEGER] ], False, True, [TV_INTEGER])
	
	Field m_iden:String[]
	Field m_vars:Int[][]
	
	Field m_flexible:Int
	Field m_casesens:Int
	Field m_infinitism:Int[]
	
	Method New()
	End Method
	
	Rem
		bbdoc: Create a new TTemplate.
		returns: The new TTemplate (itself).
		about: @iden: The name of the Identifier.<br />
		@vars: An array of arrays (see #{SetVars}).<br />
		@casesens: Check identifier name with case sensitivity?<br />
		@flexible: The flexibility of the Identifier (see #{SetFlexible}).<br />
		@infinitism: Use infinitism? (see #{SetInfinitism}).
	End Rem
	Method Create:TTemplate(iden:String[], vars:Int[][], casesens:Int = False, flexible:Int = False, infinitism:Int[] = Null)
		SetIden(iden)
		SetVars(vars)
		SetFlexible(flexible)
		SetCaseSensitive(casesens)
		SetInfinitism(infinitism)
		Return Self
	End Method
	
'#region Field accessors
	
	Rem
		bbdoc: Set infinitism (type of flexibility).
		returns: Nothing.
		about: This will only be used if the template is flexible.<br/>
		If Null the template will not care about the type of variable that is after the defined variables.<br/>
		If set to a TV_ variable (or multiple TV_ variables), the template will require that a certain type of variable(s) be after the defined variables.<br/>
		<br/>
		e.g.<br/>
		template.SetVars([[TV_STRING], [TV_FLOAT]])<br/>
		template.SetFlexible(True)<br/>
		template.SetInfinitism([TV_INTEGER])<br/>
		Now the identifier can only have variables of the INTEGER type after the end of the defined variables (string, then float)<br/>
		someidentifier stringvar floatvar aninteger anotherinteger anotherinteger ... etc.
	End Rem
	Method SetInfinitism(infinitism:Int[])
		m_infinitism = infinitism
	End Method
	Rem
		bbdoc: Get the infinitism (type of flexibility) for the template.
		returns: The infinitism field (False, or a TV_ constant).
	End Rem
	Method GetInfinitism:Int[] ()
		Return m_infinitism
	End Method
	
	Rem
		bbdoc: Set the case sensitivity for checking the identifier name.
		returns: Nothing.
	End Rem
	Method SetCaseSensitive(casesens:Int)
		m_casesens = casesens
	End Method
	Rem
		bbdoc: Get the case sensitivity for checking the identifier name.
		returns: The case sensitivity (True or False).
	End Rem
	Method GetCaseSensitive:Int()
		Return m_casesens
	End Method
	
	Rem
		bbdoc: Set the flexibility for the template.
		returns: Nothing.
		about: If True the template will require the defined set of variables (Infinitism), then allow the rest of the 
		variables at the end of the identifier; if False the template will only allow the defined set of variables.
	End Rem
	Method SetFlexible(flexible:Int)
		m_flexible = flexible
	End Method
	Rem
		bbdoc: Get the flexibility for the template.
		returns: The flexibility field (True or False).
	End Rem
	Method GetFlexible:Int()
		Return m_flexible
	End Method
	
	Rem
		bbdoc: Set the identifier name for the template.
		returns: Nothing.
	End Rem
	Method SetIden(iden:String[])
		m_iden = iden
	End Method
	Rem
		bbdoc: Get the identifier name for the template.
		returns: The identifier name.
	End Rem
	Method GetIden:String[] ()
		Return m_iden
	End Method
	
	Rem
		bbdoc: Set the variable definitions for the template.
		returns: Nothing.
		about: Example: template.SetVars([[TV_INTEGER, TV_STRING], [TV_FLOAT]]). <br />
		That means that the first variable can be either an integer or a string, and the second can only be a float.
	End Rem
	Method SetVars(vars:Int[][])
		m_vars = vars
	End Method
	Rem
		bbdoc: Get the variable definitions for the template.
		returns: The variable definitions.
	End Rem
	Method GetVars:Int[][] ()
		Return m_vars
	End Method
	
'#end region (Field accessors)
	
'#region Data handling
	
	Rem
		bbdoc: Serialize the template into a stream.
		returns: Nothing.
	End Rem
	Method Serialize(stream:TStream)
		Local tmpsize:Int, i:Int
		
		If m_iden <> Null Then tmpsize = m_iden.Length
		stream.WriteInt(tmpsize)
		If tmpsize > 0
			For i = 0 To tmpsize - 1
				WriteNString(stream, m_iden[i])
			Next
		End If
		
		stream.WriteInt(m_flexible)
		stream.WriteInt(m_casesens)
		
		tmpsize = 0
		If m_infinitism <> Null Then tmpsize = m_infinitism.Length
		stream.WriteInt(tmpsize)
		If tmpsize > 0
			For i = 0 To tmpsize - 1
				stream.WriteInt(m_infinitism[i])
			Next
		End If
		
		tmpsize = 0
		If m_vars <> Null Then tmpsize = m_vars.Length
		stream.WriteInt(tmpsize)
		If tmpsize > 0
			For i = 0 To tmpsize - 1
				Local varray:Int[], ix:Int
				
				varray = m_vars[i]
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
			m_iden = New String[tmpsize]
			For i = 0 To tmpsize - 1
				m_iden[i] = ReadNString(stream, 768)
			Next
		End If
		
		m_flexible = stream.ReadInt()
		m_casesens = stream.ReadInt()
		
		tmpsize = 0
		tmpsize = stream.ReadInt()
		If tmpsize > 0
			m_infinitism = New Int[tmpsize]
			For i = 0 To tmpsize - 1
				m_infinitism[i] = stream.ReadInt()
			Next
		End If
		
		tmpsize = 0
		tmpsize = stream.ReadInt()
		If tmpsize > 0
			m_vars = New Int[][tmpsize]
			If m_vars.Length > 40 Then DebugLog("TTemplate.DeSerialize() WARNING: Possible corrupt template stream, template data contains a unusually large number of variables (" + tmpsize + ")")
			For i = 0 To tmpsize - 1
				Local varray:Int[], ix:Int
				
				varray = New Int[stream.ReadInt()]
				For ix = 0 To varray.Length - 1
					varray[ix] = stream.ReadInt()
				Next
				m_vars[i] = varray
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
			If CheckNames(m_iden, identifier.GetName(), m_casesens) = True
				If identifier.GetValueCount() > m_vars.Length And m_flexible = False
					Return False
				Else If identifier.GetValueCount() < m_vars.Length
					Return False
				End If
				
				' Compare defined variables in the identifier
				For Local i:Int = 0 To m_vars.Length - 1
					Local cmpvar:TVariable
					
					cmpvar = TVariable(identifier.GetValues().ValueAtIndex(i))
					If cmpvar <> Null
						Local cmp:Int
						
						cmp = CheckVariable(m_vars[i], cmpvar)
						Select cmp
							Case False
								Return False
							Case True
								' Don't need to do anything here, just assert the case else Default would pick it up
							Default
								DebugLog("TTemplate.ValidateIdentifier() WARNING: vars[" + i + "][" + (- cmp) + "] (=" + m_vars[i][(- cmp)] + ") is not a valid TV_ constant; Returning False..")
								Return False
						End Select
					Else
						DebugLog("TTemplate.ValidateIdentifier() WARNING: cmpvar is Null (at index " + i + ", likely unable to convert object to TVariable)")
					End If
				Next
				
				' Check flexible and infinitism
				If identifier.GetValueCount() > m_vars.Length
					If m_flexible = True
						If m_infinitism <> Null
							For Local i:Int = m_vars.Length To identifier.GetValueCount() - 1
								Local cmp:Int
								
								cmp = CheckVariable(m_infinitism, TVariable(identifier.GetValues().ValueAtIndex(i)))
								Select cmp
									Case False
										Return False
									Case True
										'Don't need to do anything here, just assert the case because Default would pick it up
									Default
										DebugLog("TTemplate.ValidateIdentifier() WARNING: Infinitism contains an invalid TV_ constant (index " + ((- cmp) - 1) + ", " + m_infinitism[(- cmp) - 1] + "); Returning False.. ")
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
							' Error, return negative index (for determining that there was an error and where it occured)
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
	
'#end region (Data handling)
	
End Type

