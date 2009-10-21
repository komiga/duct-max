
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
	
	language.bmx (Contains: TLocale, TLocaleManager, )
	
End Rem

Rem
	bbdoc: Locale (ala language).
End Rem
Type TLocale Extends TObjectMap
	
	Global tpl_name:TTemplate = New TTemplate.Create(["name"], [[TV_STRING] ])
	Global tpl_nativename:TTemplate = New TTemplate.Create(["nativename"], [[TV_STRING] ])
	
	Field m_name:String, m_nativename:String
	
	Method New()
	End Method
	
	Rem
		bbdoc: Create a new TLocale.
		returns: The new TLocale (itself).
	End Rem
	Method Create:TLocale(name:String, nativename:String)
		SetName(name)
		SetNativeName(nativename)
		Return Self
	End Method
	
'#region Field accessors
	
	Rem
		bbdoc: Set the name for the locale (the name of the language for the locale).
		returns: Nothing.
	End Rem
	Method SetName(name:String)
		m_name = name
	End Method
	
	Rem
		bbdoc: Get the name of the locale (the name of the language for the locale).
		returns: The name of the locale.
	End Rem
	Method GetName:String()
		Return m_name
	End Method
	
	Rem
		bbdoc: Set the native name for the locale
		returns: Nothing.
	End Rem
	Method SetNativeName(nativename:String)
		m_nativename = nativename
	End Method
	
	Rem
		bbdoc: Get the native name of the locale.
		returns: The native name for the locale.
	End Rem
	Method GetNativeName:String()
		Return m_nativename
	End Method
	
'#end region (Field accessors)
	
'#region Collections
	
	Rem
		bbdoc: Get a #TLocalizationCategory by the name given.
		returns: The #TLocalizationCategory with the name given, or Null if there is no category with the name given.
	End Rem
	Method Category:TLocalizationCategory(name:String)
		Return TLocalizationCategory(_ValueByKey(name.ToLower()))
	End Method
	
	Rem
		bbdoc: Get a #TLocalizedText with the name given.
		returns: The #TLocalizedText with the name given, or Null if there is no #TLocalizedText with the name given.
		about: See #TextAsString if you just want to get the value of the #TLocalizedText.
	End Rem
	Method TextL:TLocalizedText(name:String)
		Return TLocalizedText(_ValueByKey(name.ToLower()))
	End Method
	
	Rem
		bbdoc: Get the text of a #TLocalizedText with the name given.
		returns: The text for the #TLocalizedText with the name given, or Null if there is no #TLocalizedText with the name given.
	End Rem
	Method Text:String(name:String)
		Local ltext:TLocalizedText
		
		ltext = TextL(name)
		If ltext <> Null
			Return ltext.GetValue()
		End If
		
		Return Null
		
	End Method
	
	Rem
		bbdoc: Get a category from the given structure.
		returns: The category from the given structure, or Null if either no category was found at the end of the structure or the given separator is Null.
		about: @separator is the string inbetween a category (e.g. @{'mycategory.myothercategory'}, where @{'.'} is the separator).
	End Rem
	Method CategoryFromStructure:TLocalizationCategory(structure:String, separator:String = ".")
		Local sloc:Int
		
		If separator <> Null
			sloc = structure.Find(separator)
			If sloc = -1
				Return Category(structure)
			Else
				Local cat:TLocalizationCategory
				
				cat = Category(structure[..sloc])
				If cat <> Null
					Return cat.CategoryFromStructure(structure[sloc + separator.Length..], separator)
				End If
			End If
		End If
		
		Return Null
	End Method
	
	Rem
		bbdoc: Get a #TLocalizedText from the given structure.
		returns: The #TLocalizedText from the given structure, or Null if either no #TLocalizedText was found at the end of the structure or the given separator is Null.
		about: @separator is the string inbetween a category/text (e.g. @{'mycategory.mytext'}, where @{'.'} is the separator).<br/>
		See #TextFromStructureAsString if you just want to get the value of the #TLocalizedText.
	End Rem
	Method TextFromStructureL:TLocalizedText(structure:String, separator:String = ".")
		Local sloc:Int
		
		If separator <> Null
			sloc = structure.Find(separator)
			If sloc = -1
				Return TextL(structure)
			Else
				Local cat:TLocalizationCategory
				
				cat = Category(structure[..sloc])
				If cat <> Null
					Return cat.TextFromStructureL(structure[sloc + separator.Length..], separator)
				End If
			End If
		End If
		
		Return Null
	End Method
	
	Rem
		bbdoc: Get the value of the #TLocalizedText from the given structure.
		returns: The value of the #TLocalizedText from the given structure, or Null if either no #TLocalizedText was found at the end of the structure or the given separator is Null.
		about: @separator is the string inbetween a category/text (e.g. @{'mycategory.mytext'}, where @{'.'} is the separator).
	End Rem
	Method TextFromStructure:String(structure:String, separator:String = ".")
		Local ltext:TLocalizedText
		
		ltext = TextFromStructureL(structure, separator)
		If ltext <> Null
			Return ltext.GetValue()
		End If
		
		Return Null
	End Method
	
	Rem
		bbdoc: Add a text to the locale.
		returns: Nothing.
	End Rem
	Method AddText(text:TLocalizedText)
		Assert text, "(TLocale.AddText()) @text is Null!"
		_Insert(text.CollectionKey(), text)
	End Method
	
	Rem
		bbdoc: Add a category to the locale.
		returns: Nothing.
	End Rem
	Method AddCategory(category:TLocalizationCategory)
		Assert category, "(TLocale.AddCategory()) @category is Null!"
		_Insert(category.CollectionKey(), category)
	End Method
	
	Rem
		bbdoc: Remove a child by the given key.
		returns: True if the child was removed, or False if it was not (meaning the locale does not contain a child with the key given).
		about: See #CollectionKey.
	End Rem
	Method RemoveChildByKey:Int(key:String)
		Return _Remove(key.ToLower())
	End Method
	
	Rem
		bbdoc: Check if the locale contains a text/category with the key given.
		returns: True if there is a text/category with the key given, or False if there is not.
	End Rem
	Method Contains:Int(key:String)
		Return _Contains(key.ToLower())
	End Method
	
	Rem
		bbdoc: Check if the locale contains a category with the key given.
		returns: True if there is a category with the key given, or False if there is not.
	End Rem
	Method ContainsCategory:Int(key:String)
		Return Category(key) <> Null
	End Method
	
	Rem
		bbdoc: Check if the locale contains a text with the key given.
		returns: True if there is a text with the key given, or False if there is not.
	End Rem
	Method ContainsText:Int(key:String)
		Return Text(key) <> Null
	End Method
	
	Rem
		bbdoc: Check if this locale matches another.
		returns: True if the given locale has all the categories and texts as this locale, or False if the given locale does not have all the categories and texts as this locale.
		about: This will only check if the given locale has the categories and texts that this locale has.<br/>
		If the given locale has extra categories or texts, they will not make the match false.<br/>
		If the given locale is missing a category/text that this locale has, the return value will be false.
	End Rem
	Method Matches:Int(locale:TLocale)
		Local child:Object
		Local cat:TLocalizationCategory, text:TLocalizedText
		Local catl:TLocalizationCategory
		
		For child = EachIn ValueEnumerator()
			text = TLocalizedText(child)
			If text <> Null
				If locale.ContainsText(text.CollectionKey()) = False
					Return False
				End If
			Else
				cat = TLocalizationCategory(child)
				catl = locale.Category(cat.CollectionKey())
				If catl <> Null
					If cat.Matches(catl) = False
						Return False
					End If
				Else
					Return False
				End If
			End If
		Next
		
		Return True
	End Method
	
	Rem
		bbdoc: Get the collection key for this locale.
		returns: The collection key for this locale (currently the name of the locale).
	End Rem
	Method CollectionKey:String()
		Assert m_name, "(TLocale.CollectionKey()) m_name is Null!"
		Return m_name.ToLower()
	End Method
	
'#end region (Collections)
	
'#region Data handling
	
	Rem
		bbdoc: Load the locale data from the given script file.
		returns: The loaded locale (itself), or Null if the file does not exist.
	End Rem
	Method FromScriptFile:TLocale(file:String)
		Local node:TSNode
		
		If FileType(file) = FILETYPE_FILE
			node = TSNode.LoadScriptFromObject(file)
			Return FromNode(node)
		End If
		
		Return Null
	End Method
	
	Rem
		bbdoc: Load the locale data from the given node.
		returns: The loaded locale (itself), or Null if the name of the locale was never set.
	End Rem
	Method FromNode:TLocale(node:TSNode)
		Local child:Object, iden:TIdentifier, cnode:TSNode
		
		If node <> Null
			For child = EachIn node.GetChildren()
				iden = TIdentifier(child)
				If iden <> Null
					If tpl_name.ValidateIdentifier(iden) = True
						SetName(TStringVariable(iden.GetValueAtIndex(0)).Get())
					Else If tpl_nativename.ValidateIdentifier(iden) = True
						SetNativeName(TStringVariable(iden.GetValueAtIndex(0)).Get())
					Else
						AddText(New TLocalizedText.FromIdentifier(iden))
					End If
				Else
					cnode = TSNode(child)
					AddCategory(New TLocalizationCategory.FromNode(cnode))
				End If
			Next
		Else
			Return Null
		End If
		
		If m_name = Null
			Return Null
		End If
		
		Return Self
	End Method
	
'#end region (Data handling)
	
End Type

Rem
	bbdoc: #TLocale manager.
End Rem
Type TLocaleManager
	
	Global m_map:TObjectMap = New TObjectMap
	Global m_currentlocale:TLocale
	
	Global m_locale_ext:String = "loc"
	
'#region Setters and getters
	
	Rem
		bbdoc: Set the current locale.
		returns: Nothing.
	End Rem
	Method SetCurrentLocale(locale:TLocale)
		m_currentlocale = locale
	End Method
	
	Rem
		bbdoc: Set the current locale from the name given (English name, not native).
		returns: True if the locale was set, or False if it was not (because it does not exist).
	End Rem
	Function SetCurrentLocaleByName:Int(name:String)
		Local locale:TLocale
		
		locale = GetLocaleByKey(name)
		If locale = Null
			Return False
		End If
		
		m_currentlocale = locale
		Return True
	End Function
	
	Rem
		bbdoc: Get the current locale for the manager.
		returns: The current locale.
	End Rem
	Function GetCurrentLocale:TLocale()
		Return m_currentlocale
	End Function
	
	Rem
		bbdoc: Set the extension for locale scripts.
		returns: Nothing.
		about: The default extension is 'loc'.
	End Rem
	Function SetLocaleExtension(locale_ext:String)
		m_locale_ext = locale_ext.ToLower()
	End Function
	
	Rem
		bbdoc: Get the extension for locale scripts.
		returns: The locale script extension.
		about: The default extension is 'loc'.
	End Rem
	Function GetLocaleExtension:String()
		Return m_locale_ext
	End Function
	
'#end region (Setters and getters)
	
'#region Collections
	
	Rem
		bbdoc: Get a #TLocalizationCategory by the name given.
		returns: The #TLocalizationCategory with the name given, or Null if either there is no category with the name given or there is no current locale..
		about: This function forwards off to the current locale (if there is no current locale, the return value is Null).
	End Rem
	Function Category:TLocalizationCategory(name:String)
		If m_currentlocale <> Null
			Return m_currentlocale.Category(name)
		Else
			Return Null
		End If
	End Function
	
	Rem
		bbdoc: Get a #TLocalizedText with the name given.
		returns: The #TLocalizedText with the name given, or Null if either there is no #TLocalizedText with the name given or there is no current locale..
		about: This function forwards off to the current locale (if there is no current locale, the return value is Null).<br/>
		See #TextAsString if you just want to get the value of the #TLocalizedText.
	End Rem
	Function TextL:TLocalizedText(name:String)
		If m_currentlocale <> Null
			Return m_currentlocale.TextL(name)
		Else
			Return Null
		End If
	End Function
	
	Rem
		bbdoc: Get the text of a #TLocalizedText with the name given.
		returns: The text for the #TLocalizedText with the name given, or Null if either there is no #TLocalizedText with the name given or there is no current locale.
		about: This function forwards off to the current locale (if there is no current locale, the return value is Null).
	End Rem
	Function Text:String(name:String)
		If m_currentlocale <> Null
			Return m_currentlocale.Text(name)
		Else
			Return Null
		End If
	End Function
	
	Rem
		bbdoc: Get a category from the given structure.
		returns: The category from the given structure, or Null if either no category was found at the end of the structure or the given separator is Null.
		about: This function forwards off to the current locale (if there is no current locale, the return value is Null).<br/>
		@separator is the string inbetween a category (e.g. @{'mycategory.myothercategory'}, where @{'.'} is the separator).
	End Rem
	Function CategoryFromStructure:TLocalizationCategory(structure:String, separator:String = ".")
		If m_currentlocale <> Null
			Return m_currentlocale.CategoryFromStructure(structure, separator)
		Else
			Return Null
		End If
	End Function
	
	Rem
		bbdoc: Get the #TLocalizedText from the given structure.
		returns: The #TLocalizedText from the given structure, or Null if either no #TLocalizedText was found at the end of the structure or the given separator is Null.
		about: This function forwards off to the current locale (if there is no current locale, the return value is Null).<br/>
		@separator is the string inbetween a category/text (e.g. @{'mycategory.mytext'}, where @{'.'} is the separator).<br/>
		See #TextFromStructureAsString if you just want to get the value of the #TLocalizedText.
	End Rem
	Function TextFromStructureL:TLocalizedText(structure:String, separator:String = ".")
		If m_currentlocale <> Null
			Return m_currentlocale.TextFromStructureL(structure, separator)
		Else
			Return Null
		End If
	End Function
	
	Rem
		bbdoc: Get the value of the #TLocalizedText from the given structure.
		returns: The value of the #TLocalizedText from the given structure, or Null if either no #TLocalizedText was found at the end of the structure or the given separator is Null.
		about: This function forwards off to the current locale (if there is no current locale, the return value is Null).<br/>
		@separator is the string inbetween a category/text (e.g. @{'mycategory.mytext'}, where @{'.'} is the separator).
	End Rem
	Function TextFromStructure:String(structure:String, separator:String = ".")
		If m_currentlocale <> Null
			Return m_currentlocale.TextFromStructure(structure, separator)
		Else
			Return Null
		End If
	End Function
	
	Rem
		bbdoc: Add a locale to the manager.
		returns: Nothing.
	End Rem
	Function AddLocale(locale:TLocale)
		Assert locale, "(TLocaleManager.AddLocale()) @locale is Null!"
		If locale <> Null
			m_map._Insert(locale.CollectionKey(), locale)
		End If
	End Function
	
	Rem
		bbdoc: Remove a locale with the key given.
		returns: True if the locale was removed, or False if it was not (there is no locale with the key given).
	End Rem
	Function RemoveLocaleByKey:Int(key:String)
		Return m_map._Remove(key.ToLower())
	End Function
	
	Rem
		bbdoc: Get a locale by the key given.
		returns: The locale with the given key, or Null if the given key does not match any locales in the manager.
	End Rem
	Function GetLocaleByKey:TLocale(key:String)
		Return TLocale(m_map._ValueByKey(key.ToLower()))
	End Function
	
	Rem
		bbdoc: Get the locale enumerator.
		returns: The enumerator for all of the currently loaded locales.
	End Rem
	Function LocaleEnumerator:TMapEnumerator()
		Return m_map.ValueEnumerator()
	End Function
	
'#end region (Collections)
	
'#region Parsing
	
	Rem
		bbdoc: Load/parse all of the locales in the given folder.
		returns: Nothing.
	End Rem
	Function ParseLocaleFolder(path:String, recursive:Int = False)
		Local dir:Int, file:String
		
		FixPathEnding(path)
		dir = ReadDir(path)
		Repeat
			file = NextFile(dir)
			
			If file = "" Then Exit
			If file <> "." And file <> ".."
				Select FileType(path + file)
					Case FILETYPE_FILE
						If ExtractExt(file).ToLower() = m_locale_ext
							AddLocale(New TLocale.FromScriptFile(path + file))
						End If
					Case FILETYPE_DIR
						If recursive = True
							ParseLocaleFolder(path + file + "/", recursive)
						End If
				End Select
			End If
		Forever
		CloseDir(dir)
	End Function
	
'#end region (Parsing)
	
End Type




























































