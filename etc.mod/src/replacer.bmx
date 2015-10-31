
Rem
Copyright (c) 2010 Coranna Howard <me@komiga.com>

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
Type dTextReplacer
	
	Field m_list:TListEx
	
	Method New()
		m_list = New TListEx
	End Method
	
	Rem
		bbdoc: Create a text replacer.
		returns: Itself.
	End Rem
	Method Create:dTextReplacer(str:String)
		SetString(str)
		Return Self
	End Method
	
	Rem
		bbdoc: Set the value of all replacements with the given name.
		returns: True if a replacement value was set, or False if none were was not (could not find the given name).
	End Rem
	Method SetReplacementsWithName:Int(name:String, value:String, casesens:Int = False)
		Local changed:Int = False
		If Not casesens Then name = name.ToLower()
		For Local replacement:dTextReplacement = EachIn m_list
			If (Not casesens And replacement.m_name.ToLower() = name) Or replacement.m_name = name
				replacement.SetReplacement(value)
				changed = True
			End If
		Next
		Return changed
	End Method
	
	Rem
		bbdoc: Get a replacement with the name given.
		returns: The replacement with the name given, or Null if the given name was not found.
		about: This will obviously only give you the first instance of @name, to set all replacements with the given name, use #SetReplacementsWithName.
	End Rem
	Method GetReplacementWithName:dTextReplacement(name:String, casesens:Int = False)
		If Not casesens Then name = name.ToLower()
		For Local replacement:dTextReplacement = EachIn m_list
			If (Not casesens And replacement.m_name.ToLower() = name) Or replacement.m_name = name
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
				i:+ 1
			Next
			Return "".Join(strings)
		End If
		Return Null
	End Method
	
	Rem
		bbdoc: Automatically create text replacements around all strings.
		returns: Nothing.
		about: The @beginiden and @endiden parameters are used to find replacements in the string.<br>
		For example, all the points (with the default idens) surrounded by brackets in "Foo {bar} boo {far}" will become text replacements.
	End Rem
	Method AutoReplacements(beginiden:String = "{", endiden:String = "}")
		Assert beginiden, "(dTextReplacement.AutoReplacements) Cannot use Null @beginiden"
		Assert endiden, "(dTextReplacement.AutoReplacements) Cannot use Null @endiden"
		If m_list.Count() > 0
			Local bi:Int, ei:Int, lastei:Int
			Local tmpstr:String
			Local tmplist:TListEx = New TListEx
			For Local str:String = EachIn m_list
				bi = 0
				ei = 0
				lastei = 0
				Repeat
					bi = str.Find(beginiden, lastei)
					If bi > -1
						ei = str.Find(endiden, bi)
						If ei > -1
							Local val:Int = lastei + ((lastei > 0) And endiden.Length Or 0)
							'DebugLog("(dTextReplacer.AutoReplacements) val = " + lastei + "  ((" + lastei + " > 0) And " + endiden.Length + " Or 0)")
							'DebugLog("(dTextReplacer.AutoReplacements) val = " + val)
							tmpstr = str[val..bi]
							If tmpstr Then tmplist.AddLast(tmpstr)
							tmpstr = str[bi + beginiden.Length..ei]
							tmplist.AddLast(New dTextReplacement.Create(tmpstr, Null))
							lastei = ei
						Else
							?Debug
							DebugLog("(dTextReplacement.AutoReplacements) Mismatched iden at " + bi + " in " + str)
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
		about: @beginiden and @endiden will be placed at the beginning and end of each text replacement name, respectively.
	End Rem
	Method GetOriginal:String(beginiden:String = "{", endiden:String = "}")
		If m_list.Count() > 0
			Local strings:String[] = New String[m_list.Count()]
			Local i:Int
			For Local block:Object = EachIn m_list
				If String(block)
					strings[i] = String(block)
				Else
					strings[i] = beginiden + dTextReplacement(block).m_name + endiden
				End If
				i:+ 1
			Next
			Return "".Join(strings)
		End If
		Return Null
	End Method
	
'#end region Field accessors
	
'#region Data handling
	
	Rem
		bbdoc: Get a copy of the replacer.
		returns: A clone of the replacer.
	End Rem
	Method Copy:dTextReplacer()
		Local clone:dTextReplacer = New dTextReplacer
		clone.m_list = m_list.Copy()
		Return clone
	End Method
	
'#region Data handling
	
End Type

Rem
	bbdoc: Text replacement.
End Rem
Type dTextReplacement
	
	Field m_name:String
	Field m_replacement:String
	
	Rem
		bbdoc: Create a dTextReplacement.
		returns: Itself.
	End Rem
	Method Create:dTextReplacement(name:String, replacement:String = Null)
		SetName(name)
		SetReplacement(replacement)
		Return Self
	End Method
	
	Rem
		bbdoc: Get the dTextReplacement as a string.
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
	
'#end region Field accessors
	
'#region Data handlers
	
	Rem
		bbdoc: Serialize the dTextReplacement to the given stream.
		returns: Nothing.
	End Rem
	Method Serialize(stream:TStream)
		dStreamIO.WriteLString(stream, m_name)
		dStreamIO.WriteLString(stream, m_replacement)
	End Method
	
	Rem
		bbdoc: Deserialize the dTextReplacement from the given stream.
		returns: The deserialized dTextReplacement (itself).
	End Rem
	Method Deserialize:dTextReplacement(stream:TStream)
		m_name = dStreamIO.ReadLString(stream)
		m_replacement = dStreamIO.ReadLString(stream)
		Return Self
	End Method
	
	Rem
		bbdoc: Create a copy of the dTextReplacement.
		returns: A clone of the dTextReplacement.
	End Rem
	Method Copy:dTextReplacement()
		Local clone:dTextReplacement
		clone.m_name = m_name
		clone.m_replacement = m_replacement
		Return clone
	End Method
	
'#end region Data handling
	
End Type

