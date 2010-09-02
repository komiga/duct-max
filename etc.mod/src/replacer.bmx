
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
	bbdoc: Text replacement manager.
End Rem
Type TTextReplacer
	
	Field m_list:TListEx
	
	Method New()
		m_list = New TListEx
	End Method
	
	Rem
		bbdoc: Create a TTextReplacer.
		returns: Itself.
	End Rem
	Method Create:TTextReplacer(str:String)
		SetString(str)
		Return Self
	End Method
	
	Rem
		bbdoc: Set a replacement string by the name of the TTextReplacement (e.g. "FOO" for the '{FOO}' part of the text).
		returns: True if the TTextReplacement value was set, or False if it was not (could not find the given name).
	End Rem
	Method SetReplacementByName:Int(name:String, value:String, casesens:Int = False)
		Local changed:Int = False
		If casesens = True
			name = name.ToLower()
		End If
		For Local replacement:TTextReplacement = EachIn m_list
			If (casesens = True And replacement.m_name.ToLower() = name) Or replacement.m_name = name
				replacement.SetReplacement(value)
				changed = True
			End If
		Next
		Return changed
	End Method
	
	Rem
		bbdoc: Get a TTextReplacement by the name given.
		returns: The TTextReplacement with the name given, or Null if the given name was not found.
		about: This will obviously only give you the first instance of @name, to set all replacements with the given name, use #SetReplacementByName.
	End Rem
	Method GetReplacementFromName:TTextReplacement(name:String, casesens:Int = False)
		If casesens = True
			name = name.ToLower()
		End If
		For Local replacement:TTextReplacement = EachIn m_list
			If (casesens = True And replacement.m_name.ToLower() = name) Or replacement.m_name = name
				Return replacement
			End If
		Next
		Return Null
	End Method
	
	Rem
		bbdoc: Do all replacements and return the resulting string.
		returns: The string containing all the replaced values.
	End Rem
	Method DoReplacements:String()
		If m_list.Count() > 0
			Local strings:String[] = New String[m_list.Count()]
			Local i:Int
			For Local block:Object = EachIn m_list
				strings[i] = block.ToString()
				i:+1
			Next
			Return "".Join(strings)
		End If
		Return Null
	End Method
	
	Rem
		bbdoc: Automatically create TTextReplacements around all strings.
		returns: Nothing.
		about: The @beginiden and @endiden parameters are used to find replacements in the string.<br/>
		For example, all the points (with the default idens) surrounded by brackets in "The greatest {string} of testingleness {is} not so {awesome}" will become TTextReplacements.
	End Rem
	Method AutoReplacements(beginiden:String = "{", endiden:String = "}")
		Local str:String, tmplist:TListEx
		Local bi:Int, ei:Int, lastei:Int
		Local tmpstr:String
		
		Assert beginiden, "(TTextReplacement.AutoReplacements) Cannot use Null @beginiden"
		Assert endiden, "(TTextReplacement.AutoReplacements) Cannot use Null @endiden"
		
		If m_list.Count() > 0
			tmplist = New TListEx
			For str = EachIn m_list
				bi = 0
				ei = 0
				lastei = 0
				Repeat
					bi = str.Find(beginiden, lastei)
					If bi > - 1
						ei = str.Find(endiden, bi)
						If ei > - 1
							Local val:Int = lastei + ((lastei > 0) And endiden.Length Or 0)
							'DebugLog("(TTextReplacer.AutoReplacements) val = " + lastei + "  ((" + lastei + " > 0) And " + endiden.Length + " Or 0)")
							'DebugLog("(TTextReplacer.AutoReplacements) val = " + val)
							tmpstr = str[val..bi]
							If tmpstr <> Null
								tmplist.AddLast(tmpstr)
							End If
							
							tmpstr = str[bi + beginiden.Length..ei]
							tmplist.AddLast(New TTextReplacement.Create(tmpstr, Null))
							lastei = ei
						Else
							?Debug
							DebugLog("(TTextReplacement.AutoReplacements) Mismatched iden at " + bi + " in " + str)
							?
						End If
					End If
				Until bi = -1
				If bi = -1 And lastei = 0
					tmplist.AddLast(str)
				Else If ei < str.Length
					tmplist.AddLast(str[ei + endiden.Length..])
				End If
			Next
			m_list = tmplist
		End If
	End Method
	
	Rem
		bbdoc: Clear the data in the replacer 
		returns: Nothing.
	End Rem
	Method Clear()
		If m_list.m_count > 0
			m_list = New TListEx
		End If
	End Method
	
	Rem
		bbdoc: Get the replacer's list.
		returns: The list containing the strings and replacements.
	End Rem
	Method GetList:TListEx()
		Return m_list
	End Method
	
'#region Field accessors
	
	Rem
		bbdoc: Set the replacer's string.
		returns: Nothing.
		about: This will clear all replacements for the string.
	End Rem
	Method SetString(str:String)
		Clear()
		m_list.AddLast(str)
	End Method
	
	Rem
		bbdoc: Get the original string for the replacer.
		returns: The original string for the replacer (if Null, the string was never set, or was set to Null).
		about: @beginiden and @endiden will be placed at the beginning and end of each TTextReplacement name, respectively.
	End Rem
	Method GetOriginal:String(beginiden:String = "{", endiden:String = "}")
		If m_list.Count() > 0
			Local strings:String[] = New String[m_list.Count()]
			Local i:Int
			For Local block:Object = EachIn m_list
				If String(block)
					strings[i] = String(block)
				Else
					strings[i] = beginiden + TTextReplacement(block).m_name + endiden
				End If
				i:+1
			Next
			Return "".Join(strings)
		End If
		Return Null
	End Method
	
'#end region (Field accessors)
	
'#region Data handlers
	
	Rem
		bbdoc: Create a copy of the replacer.
		returns: A clone of the replacer.
	End Rem
	Method Copy:TTextReplacer()
		Local clone:TTextReplacer = New TTextReplacer
		clone.m_list = m_list.Copy()
		Return clone
	End Method
	
'#region (Data handlers)
	
End Type

Rem
	bbdoc: Text replacement.
End Rem
Type TTextReplacement
	
	Field m_name:String
	Field m_replacement:String
	
	Method New()
	End Method
	
	Rem
		bbdoc: Create a new TTextReplacement.
		returns: Itself.
	End Rem
	Method Create:TTextReplacement(name:String, replacement:String = Null)
		SetName(name)
		SetReplacement(replacement)
		Return Self
	End Method
	
	Rem
		bbdoc: Get the TTextReplacement as a string.
		returns: The replacement field.
	End Rem
	Method ToString:String()
		Return m_replacement
	End Method
	
'#region Field accessors
	
	Rem
		bbdoc: Set the string that will be replaced.
		returns: Nothing.
	End Rem
	Method SetName(name:String)
		m_name = name
	End Method
	
	Rem
		bbdoc: Get the string that will be replaced.
		returns: The string that will be replaced.
	End Rem
	Method GetName:String()
		Return m_name
	End Method
	
	Rem
		bbdoc: Set the replacement string.
		returns: Nothing.
	End Rem
	Method SetReplacement(replacement:String)
		m_replacement = replacement
	End Method
	
	Rem
		bbdoc: Get the replacement string.
		returns: The replacement string.
	End Rem
	Method GetReplacement:String()
		Return m_replacement
	End Method
	
'#end region (Field accessors)
	
'#region Data handlers
	
	Rem
		bbdoc: Serialize the TTextReplacement to the given stream.
		returns: Nothing.
	End Rem
	Method Serialize(stream:TStream)
		WriteLString(stream, m_name)
		WriteLString(stream, m_replacement)
	End Method
	
	Rem
		bbdoc: Deserialize the TTextReplacement from the given stream.
		returns: The deserialized TTextReplacement (itself).
	End Rem
	Method Deserialize:TTextReplacement(stream:TStream)
		m_name = ReadLString(stream)
		m_replacement = ReadLString(stream)
		Return Self
	End Method
	
	Rem
		bbdoc: Create a copy of the TTextReplacement.
		returns: A clone of the TTextReplacement.
	End Rem
	Method Copy:TTextReplacement()
		Local clone:TTextReplacement
		clone.m_name = m_name
		clone.m_replacement = m_replacement
		Return clone
	End Method
	
'#end region (Data handlers)
	
End Type

