
Rem
Copyright (c) 2010 Tim Howard

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
End Rem

Rem
	bbdoc: #dIdentifier template (provides a sort of validation for different formats).
End Rem
Type dTemplate
	
	Field m_iden:String[]
	Field m_vars:Int[][]
	
	Field m_flexible:Int
	Field m_casesens:Int
	Field m_infinitism:Int[]
	
	Rem
		bbdoc: Create a template.
		returns: Itself.
		about: Parameters:<br>
		@iden: The identity array (variable names the template will match against).<br>
		@vars: An array of arrays (see #{SetVars}).<br>
		@casesens: Name-matching case sensitivity.<br>
		@flexible: The flexibility of the template (see #{SetFlexible}).<br>
		@infinitism: Infinitism array (see #{SetInfinitism}).
	End Rem
	Method Create:dTemplate(iden:String[], vars:Int[][], casesens:Int = False, flexible:Int = False, infinitism:Int[] = Null)
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
		about: This will only be used if the template is flexible.<br>
		If Null the template will not care about the type of variable that is after the defined variables.<br>
		If set to a TV_ variable (or multiple TV_ variables), the template will require that a certain type of variable(s) be after the defined variables.<br>
		<br>
		e.g.<br>
		template.SetVars([[TV_STRING], [TV_FLOAT]])<br>
		template.SetFlexible(True)<br>
		template.SetInfinitism([TV_INTEGER])<br>
		Now the identifier can only have variables of the INTEGER type after the end of the defined variables (string, then float)<br>
		someidentifier stringvar floatvar aninteger anotherinteger anotherinteger ... etc.
	End Rem
	Method SetInfinitism(infinitism:Int[])
		m_infinitism = infinitism
	End Method
	Rem
		bbdoc: Get the infinitism (type of flexible variables) for the template.
		returns: The template's infinitism array.
	End Rem
	Method GetInfinitism:Int[]()
		Return m_infinitism
	End Method
	
	Rem
		bbdoc: Set the template's name-matching case sensitivity.
		returns: Nothing.
	End Rem
	Method SetCaseSensitive(casesens:Int)
		m_casesens = casesens
	End Method
	Rem
		bbdoc: Get the template's name-matching case sensitivity.
		returns: True if the template is case-sensitive, or False if it is not.
	End Rem
	Method GetCaseSensitive:Int()
		Return m_casesens
	End Method
	
	Rem
		bbdoc: Set the flexibility for the template.
		returns: Nothing.
		about: If true, the template will use the infinitism array for extra variable matching.
	End Rem
	Method SetFlexible(flexible:Int)
		m_flexible = flexible
	End Method
	Rem
		bbdoc: Get the flexibility for the template.
		returns: True if the template is flexible, or False if it is not.
	End Rem
	Method GetFlexible:Int()
		Return m_flexible
	End Method
	
	Rem
		bbdoc: Set the identity array for the template (the names that the template allows).
		returns: Nothing.
	End Rem
	Method SetIden(iden:String[])
		m_iden = iden
	End Method
	Rem
		bbdoc: Get the identity array for the template.
		returns: The template's identity array.
	End Rem
	Method GetIden:String[]()
		Return m_iden
	End Method
	
	Rem
		bbdoc: Set the variable definitions for the template.
		returns: Nothing.
		about: Example: template.SetVars([[TV_INTEGER, TV_STRING], [TV_FLOAT]]).<br>
		That means that the first variable can be either an integer or a string, and the second can only be a float.
	End Rem
	Method SetVars(vars:Int[][])
		m_vars = vars
	End Method
	Rem
		bbdoc: Get the variable definitions for the template.
		returns: The variable definitions.
	End Rem
	Method GetVars:Int[][]()
		Return m_vars
	End Method
	
'#end region Field accessors
	
'#region Data handling
	
	Rem
		bbdoc: Serialize the template into a stream.
		returns: Nothing.
	End Rem
	Method Serialize(stream:TStream)
		Local tmpsize:Int, i:Int
		If m_iden Then tmpsize = m_iden.Length
		stream.WriteInt(tmpsize)
		If tmpsize > 0
			For i = 0 Until tmpsize
				dStreamIO.WriteLString(stream, m_iden[i])
			Next
		End If
		stream.WriteByte(m_flexible)
		stream.WriteByte(m_casesens)
		tmpsize = 0
		If m_infinitism Then tmpsize = m_infinitism.Length
		stream.WriteInt(tmpsize)
		If tmpsize > 0
			For i = 0 Until tmpsize
				stream.WriteInt(m_infinitism[i])
			Next
		End If
		tmpsize = 0
		If m_vars Then tmpsize = m_vars.Length
		stream.WriteInt(tmpsize)
		If tmpsize > 0
			For i = 0 Until tmpsize
				Local varray:Int[] = m_vars[i]
				stream.WriteInt(varray.Length)
				For Local j:Int = 0 Until varray.Length
					stream.WriteInt(varray[j])
				Next
			Next
		End If
	End Method
	
	Rem
		bbdoc: Deserialize a template from a stream.
		returns: Itself.
	End Rem
	Method Deserialize:dTemplate(stream:TStream)
		Local i:Int
		Local tmpsize:Int = stream.ReadInt()
		If tmpsize > 0
			m_iden = New String[tmpsize]
			For i = 0 Until tmpsize
				m_iden[i] = dStreamIO.ReadLString(stream)
			Next
		End If
		m_flexible = stream.ReadByte()
		m_casesens = stream.ReadByte()
		tmpsize = stream.ReadInt()
		If tmpsize > 0
			m_infinitism = New Int[tmpsize]
			For i = 0 Until tmpsize
				m_infinitism[i] = stream.ReadInt()
			Next
		End If
		tmpsize = stream.ReadInt()
		If tmpsize > 0
			m_vars = New Int[][tmpsize]
			For i = 0 Until tmpsize
				Local varray:Int[] = New Int[stream.ReadInt()]
				For Local j:Int = 0 Until varray.Length
					varray[j] = stream.ReadInt()
				Next
				m_vars[i] = varray
			Next
		End If
		Return Self
	End Method
	
'#end region Data handling
	
	Rem
		bbdoc: Validate the given identifier.
		returns: True if the identifier matches the template, False if it does not (or if the identifier is Null).
	End Rem
	Method ValidateIdentifier:Int(identifier:dIdentifier)
		If identifier
			If Not(identifier.GetChildCount() > m_vars.Length And Not m_flexible) And Not(identifier.GetChildCount() < m_vars.Length) And _CheckIden(m_iden, identifier.m_name, m_casesens)
				' Compare defined variables in the identifier
				For Local i:Int = 0 Until m_vars.Length
					Local cmpvar:dVariable = dVariable(identifier.m_children.ValueAtIndex(i))
					If cmpvar
						Local cmp:Int = _CheckVariable(m_vars[i], cmpvar)
						Select cmp
							Case True
								' Don't need to do anything here, just assert the case else Default would pick it up
							Case False
								Return False
							Default
								DebugLog("(dTemplate.ValidateIdentifier) WARNING: vars[" + i + "][" + (- cmp) + "] (=" + m_vars[i][(- cmp)] + ") is not a valid TV_ constant; Returning False")
								Return False
						End Select
					Else
						DebugLog("(dTemplate.ValidateIdentifier) WARNING: cmpvar is Null (at index " + i + ", likely unable to convert object to dVariable)")
					End If
				Next
				' Check flexible and infinitism
				If identifier.GetChildCount() > m_vars.Length And m_flexible And m_infinitism
					For Local i:Int = m_vars.Length Until identifier.GetChildCount()
						Local cmp:Int = _CheckVariable(m_infinitism, dVariable(identifier.m_children.ValueAtIndex(i)))
						Select cmp
							Case False
								Return False
							Case True
								'Don't need to do anything here, just assert the case because Default would pick it up
							Default
								DebugLog("(dTemplate.ValidateIdentifier) WARNING: Infinitism contains an invalid TV_ constant (index " + ((-cmp) - 1) + ", " + m_infinitism[(-cmp) - 1] + "); Returning False.. ")
								Return False
						End Select
					Next
				End If
				Return True
			End If
		Else
			DebugLog("(dTemplate.ValidateIdentifier) Identifier is Null")
		End If
		Return False
	End Method
	
	Rem
		bbdoc: Validate the given value variable.
		returns: True if the value was validated, or False if either the given value was Null or it did not match the template.
	End Rem
	Method ValidateValue:Int(value:dValueVariable)
		If value
			If _CheckIden(m_iden, value.m_name, m_casesens)
				Local cmp:Int
				If m_vars And m_vars.Length > 0
					cmp = _CheckVariable(m_vars[0], value)
					Select cmp
						Case True
							Return True ' Value matches
						Case False
							Return False
						Default
							DebugLog("(dTemplate.ValidateValue) WARNING: vars[0][" + (- cmp) + "] (=" + m_vars[0][(- cmp)] + ") is not a valid TV_ constant; Returning False")
							Return False
					End Select
				End If
				' No canon types, check infinitism
				If m_flexible And m_infinitism
					For Local i:Int = 0 Until m_infinitism.Length
						cmp = _CheckVariable(m_infinitism, value)
						Select cmp
							Case True
								Return True ' Value matches
							Case False
								Return False
							Default
								DebugLog("(dTemplate.ValidateValue) WARNING: vars[" + i + "][" + (- cmp) + "] (=" + m_vars[i][(- cmp)] + ") is not a valid TV_ constant; Returning False")
								Return False
						End Select
					Next
				End If
			End If
		End If
		Return False
	End Method
	
	Rem
		bbdoc: Compact a sequence of value variables matching the template into a single identifier.
		returns: The number of identifiers created and added.
		about: Parameters:<br>
		@name: The name to give new identifiers.<br>
		@sequential: True: sequential value sequence required (non-value variable will break sequence); False: sequential, but ignoring non-value variables.
	End Rem
	Method CompactCollection:Int(collection:dCollectionVariable, name:String, sequential:Int = True)
		Local addcount:Int
		If collection.GetChildCount() > 0
			Local values:TListEx = New TListEx, matched:Int', namematched:Int, varmatched:Int
			Local mc:Int = 0, mmax:Int = Max(m_iden And m_iden.Length Or 0, m_vars And m_vars.Length Or 0)
			'DebugLog("(dTemplate.CompactCollection) mmax:" + mmax)
			Local enum:TListEnum = collection.ObjectEnumerator(), value:dValueVariable, repeatmatch:Int = False
			While enum.HasNext()
				'DebugLog("(dTemplate.CompactCollection) [" + mc + "] repeatmatch:" + repeatmatch)
				If repeatmatch Then repeatmatch = False Else value = dValueVariable(enum.NextObject())
				If value
					'namematched = __matchname(mc, mmax, m_iden, value.m_name, m_casesens, m_flexible)
					'varmatched = __matchvariable(mc, m_flexible, m_vars, m_infinitism, value)
					matched = __matchname(mc, mmax, m_iden, value.m_name, m_casesens, m_flexible) And __matchvariable(mc, m_flexible, m_vars, m_infinitism, value)
					'DebugLog("(dTemplate.CompactCollection) [" + mc + "] type:" + value.ReportType() + ", name:" + value.m_name + ", namematched:" + namematched + ", varmatched:" + varmatched + ", (mc < mmax):" + String(mc < mmax) + ", (m_vars And mc < m_vars.Length):" + String(m_vars And mc < m_vars.Length))
					If matched
						'DebugLog("(dTemplate.CompactCollection) match at mc=" + mc)
						values.AddLast(New _dLinkVariablePair.Create(enum._link._pred, value)) ' TListEnum is always set to the next link, so get the predecessor
						mc:+ 1
					Else If mc > 0 And mc <> mmax
						'DebugLog("(dTemplate.CompactCollection) unmatched before total; mc=" + mc)
						If mmax = 0 Or mc > mmax
							'DebugLog("(dTemplate.CompactCollection) creating from left over")
							__add(collection, values, name, addcount)
						End If
						__reset(mc, repeatmatch, True, values)
					End If
					If mmax > 0 And (mc = mmax And Not m_flexible) Or (mc > 0 And Not enum.HasNext())
						'DebugLog("(dTemplate.CompactCollection) unmatched total mc=" + mc + ", creating identifier")
						__add(collection, values, name, addcount)
						__reset(mc, repeatmatch, matched~1, values)
					End If
				Else If mc > 0 And sequential
					'DebugLog("(dTemplate.CompactCollection) non-value inbetween match series mc=" + mc)
					If mmax = 0 Or mc > mmax
						'DebugLog("(dTemplate.CompactCollection) creating from left over")
						__add(collection, values, name, addcount)
					End If
					__reset(mc, repeatmatch, False, values)
				End If
			End While
		End If
		Return addcount
	End Method
	
	Rem
		bbdoc: Expand the matching identifiers in the given collection.
		returns: The number of identifiers expanded.
		about: The @names will be used to rename variables in an identifier. The array can be smaller than the template's variable array size (in which case @infname is used).<br>
		@infname will be used to rename infinitism-matching variables (and names not covered by the @names array). If @names is Null and @infname is Null, no renaming is done.
	End Rem
	Method ExpandCollection:Int(collection:dCollectionVariable, names:String[], infname:String = Null)
		Local expandcount:Int
		If collection.GetChildCount() > 0
			Local link:TLink, firstvariable:Int, value:dValueVariable
			Local ni:Int, nimax:Int = names And names.Length Or 0
			Local enum:TListEnum = collection.ObjectEnumerator(), iden:dIdentifier
			While enum.HasNext()
				iden = dIdentifier(enum.NextObject())
				If iden And ValidateIdentifier(iden)
					link = enum._link._pred
					firstvariable = True
					ni = 0
					For value = EachIn iden
						If firstvariable
							link._value = value
							value.SetParent(collection)
							firstvariable = False
						Else
							link = collection.InsertVariableAfterLink(value, link, True)
							Assert link, "(dTemplate.ExpandCollection) link = Null"
						End If
						If nimax > 0 And ni < nimax
							value.SetName(names[ni])
							ni:+ 1
						Else If infname
							value.SetName(infname)
						End If
					Next
					iden.SetParent(Null)
					expandcount:+ 1
				End If
			End While
		End If
		Return expandcount
	End Method
	
	Rem
		bbdoc: Rename any matching identifiers or values in the given collection.
		returns: The number of variables renamed.
	End Rem
	Method RenameVariables:Int(collection:dCollectionVariable, name:String)
		Return RenameIdentifiers(collection, name) + RenameValues(collection, name)
	End Method
	
	Rem
		bbdoc: Rename any matching identifiers the given collection.
		returns: The number of identifiers renamed.
	End Rem
	Method RenameIdentifiers:Int(collection:dCollectionVariable, name:String)
		Local renamecount:Int
		If collection.GetChildCount()
			For Local iden:dIdentifier = EachIn collection
				If ValidateIdentifier(iden)
					iden.SetName(name)
					renamecount:+ 1
				End If
			Next
		End If
		Return renamecount
	End Method
	
	Rem
		bbdoc: Rename any matching value variables in the given collection.
		returns: The number of value variables renamed.
	End Rem
	Method RenameValues:Int(collection:dCollectionVariable, name:String)
		Local renamecount:Int
		If collection.GetChildCount() > 0
			For Local value:dValueVariable = EachIn collection
				If ValidateValue(value)
					value.SetName(name)
					renamecount:+ 1
				End If
			Next
		End If
		Return renamecount
	End Method
	
'#region Helper functions
	
	Function __matchname:Int(mc:Int Var, mmax:Int Var, iden:String[] Var, name:String Var, casesens:Int Var, flexible:Int Var)
		'Local in:String
		'If mc < iden.Length Then in = iden[mc]
		'DebugLog("(__matchname) [" + mc + "] iden.Length:" + iden.Length + ", iden[" + mc + "]:" + in + ", casesens:" + casesens + ", flexible:" + flexible)
		If iden.Length = 0
			Return True
		Else If mc < iden.Length
			Return _CompareNames(iden[mc], name, casesens)
		Else If mc >= iden.Length And flexible
			Return True
		Else
			Return False
		End If
	End Function
	
	Function __matchvariable:Int(mc:Int, flexible:Int, vars:Int[][] Var, infinitism:Int[] Var, variable:dVariable)
		If vars And (mc < vars.Length)
			Return _CheckVariable(vars[mc], variable) = True
		Else If flexible
			Return _CheckVariable(infinitism, variable) = True
		End If
		Return False
	End Function
	
	Function __add(collection:dCollectionVariable, values:TListEx, name:String Var, addcount:Int Var)
		If values.Count() > 0
			Local enum:TListEnum = values.ObjectEnumerator(), pair:_dLinkVariablePair, firstlink:Int = True
			Local iden:dIdentifier = New dIdentifier.Create(name)
			While enum.HasNext()
				pair = _dLinkVariablePair(enum.NextObject())
				If firstlink
					pair.m_link._value = iden
					firstlink = False
				Else
					pair.RemoveLink(collection.m_children)
				End If
				iden.AddVariable(pair.m_variable)
			End While
			addcount:+ 1
		End If
	End Function
	
	Function __reset(mc:Int Var, repeatmatch:Int Var, rep:Int, values:TListEx)
		mc = 0
		repeatmatch = rep
		values.Clear()
	End Function
	
	Function _CheckVariable:Int(tvarray:Int[] Var, variable:dVariable)
		'DebugLog("(dTemplate._CheckVariable) (tvarray):" + String(tvarray <> Null) + " length=" + String(tvarray And tvarray.Length Or 0) + ", (variable):" + String(variable <> Null))
		If variable And tvarray
			For Local i:Int = 0 Until tvarray.Length
				'DebugLog("(dTemplate._CheckVariable) tvarray[" + i + "] = " + tvarray[i])
				Select tvarray[i]
					Case TV_INTEGER
						If dIntVariable(variable)
							'DebugLog("(dTemplate._CheckVariable) int")
							Return True
						End If
					Case TV_STRING
						If dStringVariable(variable)
							'DebugLog("(dTemplate._CheckVariable) string")
							Return True
						End If
					Case TV_FLOAT
						If dFloatVariable(variable)
							Return True
						End If
					Case TV_BOOL
						If dBoolVariable(variable)
							Return True
						End If
					Default
						'DebugLog("(dTemplate._CheckVariable) error, index: " + i)
						' Error, return negative index (for determining that there was an error and where it occured)
						Return -(i + 1)
				End Select
			Next
		End If
		'DebugLog("(dTemplate._CheckVariable) none")
		Return False
	End Function
	
	Function _CheckIden:Int(iden:String[] Var, a:String, casesens:Int, i:Int = 0)
		If iden
			If Not casesens Then a = a.ToLower()
			Local b:String
			For i = i Until iden.Length
				b = iden[i]
				If Not casesens Then b = b.ToLower()
				If a = b Then Return True
			Next
			Return False
		Else
			Return True
		End If
	End Function
	
	Function _CompareNames:Int(a:String, b:String, casesens:Int)
		If a And b
			If casesens Then Return a = b Else Return a.ToLower() = b.ToLower()
		Else If Not a And Not b
			Return True
		Else
			Return False
		End If
	End Function
	
'#end region Helper functions
	
End Type

Private

Type _dLinkVariablePair
	
	Field m_link:TLink, m_variable:dVariable
	
	Method Create:_dLinkVariablePair(link:TLink, variable:dVariable)
		m_link = link
		m_variable = variable
		Return Self
	End Method
	
	Method RemoveLink(list:TListEx)
		list.RemoveLink(m_link)
		If m_variable Then m_variable.SetParent(Null)
	End Method
	
End Type

Public

