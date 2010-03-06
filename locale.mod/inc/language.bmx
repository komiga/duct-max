
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
	bbdoc: duct locale (ala language).
End Rem
Type dLocale Extends dObjectMap
	
	Global tpl_name:dTemplate = New dTemplate.Create(["name"], [[TV_STRING] ])
	Global tpl_nativename:dTemplate = New dTemplate.Create(["nativename"], [[TV_STRING] ])
	
	Field m_name:String, m_nativename:String
	
	Method New()
	End Method
	
	Rem
		bbdoc: Create a new dLocale.
		returns: The new dLocale (itself).
	End Rem
	Method Create:dLocale(name:String, nativename:String)
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
		bbdoc: Get a #dLocalizationCategory by the name given.
		returns: The #dLocalizationCategory with the name given, or Null if there is no category with the name given.
	End Rem
	Method Category:dLocalizationCategory(name:String)
		Return dLocalizationCategory(_ValueByKey(name.ToLower()))
	End Method
	
	Rem
		bbdoc: Get a #dLocalizedText with the name given.
		returns: The #dLocalizedText with the name given, or Null if there is no #dLocalizedText with the name given.
		about: See #TextAsString if you just want to get the value of the #dLocalizedText.
	End Rem
	Method TextL:dLocalizedText(name:String)
		Return dLocalizedText(_ValueByKey(name.ToLower()))
	End Method
	
	Rem
		bbdoc: Get the text of a #dLocalizedText with the name given.
		returns: The text for the #dLocalizedText with the name given, or Null if there is no #dLocalizedText with the name given.
	End Rem
	Method Text:String(name:String)
		Local ltext:dLocalizedText
		
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
	Method CategoryFromStructure:dLocalizationCategory(structure:String, separator:String = ".")
		Local sloc:Int
		
		If separator <> Null
			sloc = structure.Find(separator)
			If sloc = -1
				Return Category(structure)
			Else
				Local cat:dLocalizationCategory
				
				cat = Category(structure[..sloc])
				If cat <> Null
					Return cat.CategoryFromStructure(structure[sloc + separator.Length..], separator)
				End If
			End If
		End If
		Return Null
	End Method
	
	Rem
		bbdoc: Get a #dLocalizedText from the given structure.
		returns: The #dLocalizedText from the given structure, or Null if either no #dLocalizedText was found at the end of the structure or the given separator is Null.
		about: @separator is the string inbetween a category/text (e.g. @{'mycategory.mytext'}, where @{'.'} is the separator).<br/>
		See #TextFromStructureAsString if you just want to get the value of the #dLocalizedText.
	End Rem
	Method TextFromStructureL:dLocalizedText(structure:String, separator:String = ".")
		Local sloc:Int
		
		If separator <> Null
			sloc = structure.Find(separator)
			If sloc = -1
				Return TextL(structure)
			Else
				Local cat:dLocalizationCategory
				
				cat = Category(structure[..sloc])
				If cat <> Null
					Return cat.TextFromStructureL(structure[sloc + separator.Length..], separator)
				End If
			End If
		End If
		Return Null
	End Method
	
	Rem
		bbdoc: Get the value of the #dLocalizedText from the given structure.
		returns: The value of the #dLocalizedText from the given structure, or Null if either no #dLocalizedText was found at the end of the structure or the given separator is Null.
		about: @separator is the string inbetween a category/text (e.g. @{'mycategory.mytext'}, where @{'.'} is the separator).
	End Rem
	Method TextFromStructure:String(structure:String, separator:String = ".")
		Local ltext:dLocalizedText
		
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
	Method AddText(text:dLocalizedText)
		Assert text, "(dLocale.AddText()) @text is Null!"
		_Insert(text.CollectionKey(), text)
	End Method
	
	Rem
		bbdoc: Add a category to the locale.
		returns: Nothing.
	End Rem
	Method AddCategory(category:dLocalizationCategory)
		Assert category, "(dLocale.AddCategory()) @category is Null!"
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
	Method Matches:Int(locale:dLocale)
		Local child:Object
		Local cat:dLocalizationCategory, text:dLocalizedText
		Local catl:dLocalizationCategory
		
		For child = EachIn ValueEnumerator()
			text = dLocalizedText(child)
			If text <> Null
				If locale.ContainsText(text.CollectionKey()) = False
					Return False
				End If
			Else
				cat = dLocalizationCategory(child)
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
		Assert m_name, "(dLocale.CollectionKey()) m_name is Null!"
		Return m_name.ToLower()
	End Method
	
'#end region (Collections)
	
'#region Data handling
	
	Rem
		bbdoc: Load the locale data from the given script file.
		returns: The loaded locale (itself), or Null if the file does not exist.
	End Rem
	Method FromScriptFile:dLocale(file:String)
		Local node:dSNode
		
		If FileType(file) = FILETYPE_FILE
			node = dSNode.LoadScriptFromObject(file)
			Return FromNode(node)
		End If
		Return Null
	End Method
	
	Rem
		bbdoc: Load the locale data from the given node.
		returns: The loaded locale (itself), or Null if the name of the locale was never set.
	End Rem
	Method FromNode:dLocale(node:dSNode)
		Local child:Object, iden:dIdentifier, cnode:dSNode
		
		If node <> Null
			For child = EachIn node.GetChildren()
				iden = dIdentifier(child)
				If iden <> Null
					If tpl_name.ValidateIdentifier(iden) = True
						SetName(dStringVariable(iden.GetValueAtIndex(0)).Get())
					Else If tpl_nativename.ValidateIdentifier(iden) = True
						SetNativeName(dStringVariable(iden.GetValueAtIndex(0)).Get())
					Else
						AddText(New dLocalizedText.FromIdentifier(iden))
					End If
				Else
					cnode = dSNode(child)
					AddCategory(New dLocalizationCategory.FromNode(cnode))
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
	bbdoc: #dLocale manager.
End Rem
Type dLocaleManager
	
	Global m_map:dObjectMap = New dObjectMap
	Global m_currentlocale:dLocale
	Global m_ppfunc:String(text:String)
	
	Global m_locale_ext:String = "loc"
	
'#region Setters and getters
	
	Rem
		bbdoc: Set the current locale.
		returns: Nothing.
	End Rem
	Function SetCurrentLocale(locale:dLocale)
		m_currentlocale = locale
	End Function
	
	Rem
		bbdoc: Set the current locale from the name given (English name, not native).
		returns: True if the locale was set, or False if it was not (because it does not exist).
	End Rem
	Function SetCurrentLocaleByName:Int(name:String)
		Local locale:dLocale
		
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
	Function GetCurrentLocale:dLocale()
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
	
	Rem
		bbdoc: Set the post-process function.
		returns: Nothing.
		about: This function will be called everytime localized text is loaded.<br/>
		You could set a function, for example, that replaces "~q", "~t", and such for the appropriate characters.
	End Rem
	Function SetPostProcessFunc(ppfunc:String(text:String))
		m_ppfunc = ppfunc
	End Function
	
	Rem
		bbdoc: Get the post-process function.
		returns: The post-process function.
	End Rem
	Function GetPostProcessFunc:String(text:String)()
		Return m_ppfunc
	End Function
	
'#end region (Setters and getters)
	
'#region Collections
	
	Rem
		bbdoc: Get a #dLocalizationCategory by the name given.
		returns: The #dLocalizationCategory with the name given, or Null if either there is no category with the name given or there is no current locale..
		about: This function forwards off to the current locale (if there is no current locale, the return value is Null).
	End Rem
	Function Category:dLocalizationCategory(name:String)
		If m_currentlocale <> Null
			Return m_currentlocale.Category(name)
		Else
			Return Null
		End If
	End Function
	
	Rem
		bbdoc: Get a #dLocalizedText with the name given.
		returns: The #dLocalizedText with the name given, or Null if either there is no #dLocalizedText with the name given or there is no current locale..
		about: This function forwards off to the current locale (if there is no current locale, the return value is Null).<br/>
		See #TextAsString if you just want to get the value of the #dLocalizedText.
	End Rem
	Function TextL:dLocalizedText(name:String)
		If m_currentlocale <> Null
			Return m_currentlocale.TextL(name)
		Else
			Return Null
		End If
	End Function
	
	Rem
		bbdoc: Get the text of a #dLocalizedText with the name given.
		returns: The text for the #dLocalizedText with the name given, or Null if either there is no #dLocalizedText with the name given or there is no current locale.
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
	Function CategoryFromStructure:dLocalizationCategory(structure:String, separator:String = ".")
		If m_currentlocale <> Null
			Return m_currentlocale.CategoryFromStructure(structure, separator)
		Else
			Return Null
		End If
	End Function
	
	Rem
		bbdoc: Get the #dLocalizedText from the given structure.
		returns: The #dLocalizedText from the given structure, or Null if either no #dLocalizedText was found at the end of the structure or the given separator is Null.
		about: This function forwards off to the current locale (if there is no current locale, the return value is Null).<br/>
		@separator is the string inbetween a category/text (e.g. @{'mycategory.mytext'}, where @{'.'} is the separator).<br/>
		See #TextFromStructureAsString if you just want to get the value of the #dLocalizedText.
	End Rem
	Function TextFromStructureL:dLocalizedText(structure:String, separator:String = ".")
		If m_currentlocale <> Null
			Return m_currentlocale.TextFromStructureL(structure, separator)
		Else
			Return Null
		End If
	End Function
	
	Rem
		bbdoc: Get the value of the #dLocalizedText from the given structure.
		returns: The value of the #dLocalizedText from the given structure, or Null if either no #dLocalizedText was found at the end of the structure or the given separator is Null.
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
	Function AddLocale(locale:dLocale)
		Assert locale, "(dLocaleManager.AddLocale()) @locale is Null!"
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
	Function GetLocaleByKey:dLocale(key:String)
		Return dLocale(m_map._ValueByKey(key.ToLower()))
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
							AddLocale(New dLocale.FromScriptFile(path + file))
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
	
	Rem
		bbdoc: Use the post-process function (if set) to process the given text.
		returns: The processed text, or the given text if the post-process function has not been set.
		about: See also #SetPostProcessFunc.
	End Rem
	Function PostProcessText:String(text:String)
		If m_ppfunc <> Null
			text = m_ppfunc(text)
		End If
		Return text
	End Function
	
'#end region (Parsing)
	
End Type

