
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
	
	language.bmx (Contains: TLocalizationCategory, TLocalizedText, )
	
End Rem

Rem
	bbdoc: Localization category (stores more categories and #TLocalizedText instances).
End Rem
Type TLocalizationCategory Extends TObjectMap
	
	Field m_name:String
	
	Rem
		bbdoc: Create a new TLocalizationCategory.
		returns: The new TLocalizationCategory (itself).
	End Rem
	Method Create:TLocalizationCategory(name:String)
		SetName(name)
		Return Self
	End Method
	
'#region Field accessors
	
	Rem
		bbdoc: Set the category's name
		returns: Nothing.
	End Rem
	Method SetName(name:String)
		m_name = name
	End Method
	
	Rem
		bbdoc: Get the category's name.
		returns: The name of the category.
	End Rem
	Method GetName:String()
		Return m_name
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
		bbdoc: Get the #TLocalizedText from the given structure.
		returns: The #TLocalizedText from the given structure, or Null if either no #TLocalizedText was found at the end of the structure or if the given separator is Null.
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
		about: @separator is the string inbetween a category/text (e.g. @{'mycategory.mytext'}, where @{'.'} is the separator).<br/>
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
		bbdoc: Add a category to the category.
		returns: Nothing.
	End Rem
	Method AddCategory(category:TLocalizationCategory)
		Assert category, "(TLocalizationCategory.AddCategory()) @category is Null!"
		If category <> Null
			_Insert(category.CollectionKey(), category)
		End If
	End Method
	
	Rem
		bbdoc: Add a LocalizedText to the category.
		returns: Nothing.
	End Rem
	Method AddText(text:TLocalizedText)
		Assert text, "(TLocalizationCategory.AddText()) @text is Null!"
		If text <> Null
			_Insert(text.CollectionKey(), text)
		End If
	End Method
	
	Rem
		bbdoc: Remove a child by the given key.
		returns: True if the child was removed, or False if it was not (meaning the category does not contain a child with the key given).
		about: See #CollectionKey.
	End Rem
	Method RemoveChildByKey:Int(key:String)
		Return _Remove(key)
	End Method
	
	Rem
		bbdoc: Check if the category contains a text/category with the key given.
		returns: True if there is a text/category with the key given, or False if there is not.
	End Rem
	Method Contains:Int(key:String)
		Return _Contains(key.ToLower())
	End Method
	
	Rem
		bbdoc: Check if the category contains a category with the key given.
		returns: True if there is a category with the key given, or False if there is not.
	End Rem
	Method ContainsCategory:Int(key:String)
		Return Category(key.ToLower()) <> Null
	End Method
	
	Rem
		bbdoc: Check if the category contains a text with the key given.
		returns: True if there is a text with the key given, or False if there is not.
	End Rem
	Method ContainsText:Int(key:String)
		Return Text(key.ToLower()) <> Null
	End Method
	
	Rem
		bbdoc: Check if this category matches another.
		returns: True if the given category has all the categories and texts as this category, or False if the given category does not have all the categories and texts as this category.
		about: This will only check if the given category has the categories and texts that this category has.<br/>
		If the given category has extra categories or texts, they will not make the match false.<br/>
		If the given category is missing a category/text that this category has, the return value will be false.
	End Rem
	Method Matches:Int(category:TLocalizationCategory)
		Local child:Object
		Local cat:TLocalizationCategory, text:TLocalizedText
		Local catl:TLocalizationCategory
		
		For child = EachIn ValueEnumerator()
			text = TLocalizedText(child)
			If text <> Null
				If category.ContainsText(text.CollectionKey()) = False
					Return False
				End If
			Else
				cat = TLocalizationCategory(child)
				catl = category.Category(cat.CollectionKey())
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
		bbdoc: Get the collection key for this category.
		returns: The collection key for this category (currently the name of the category).
	End Rem
	Method CollectionKey:String()
		Assert m_name, "(TLocalizationCategory.CollectionKey()) m_name is Null!"
		Return m_name.ToLower()
	End Method
	
'#end region (Collections)
	
	Rem
		bbdoc: Load the locale data from the given node.
		returns: The loaded locale (itself).
	End Rem
	Method FromNode:TLocalizationCategory(node:TSNode)
		Local child:Object, iden:TIdentifier, cnode:TSNode
		
		SetName(node.GetName())
		For child = EachIn node.GetChildren()
			iden = TIdentifier(child)
			If iden <> Null
				AddText(New TLocalizedText.FromIdentifier(iden))
			Else
				cnode = TSNode(child)
				AddCategory(New TLocalizationCategory.FromNode(cnode))
			End If
		Next
		Return Self
	End Method
	
End Type

Rem
	bbdoc: Localized text (contains a string localized to some language).
End Rem
Type TLocalizedText
	
	Rem
		bbdoc: The template for all TLocalizedText identifiers.
		about: Format: @{<i>text_name</i> "<i>text</i>"}
	End Rem
	Global m_template:TTemplate = New TTemplate.Create(Null, [[TV_STRING] ])
	
	Field m_name:String
	Field m_text:String
	
	Method New()
	End Method
	
	Rem
		bbdoc: Create a new TLocalizedText.
		returns: The new TLocalizedText (itself).
	End Rem
	Method Create:TLocalizedText(name:String)
		SetName(name)
		Return Self
	End Method
	
'#region Field accessors
	
	Rem
		bbdoc: Set the name for the localized text.
		returns: Nothing.
	End Rem
	Method SetName(name:String)
		m_name = name
	End Method
	
	Rem
		bbdoc: Get the text's name.
		returns: The name of the localized text.
	End Rem
	Method GetName:String()
		Return m_name
	End Method
	
	Rem
		bbdoc: Set the string value for the localized text.
		returns: Nothing.
	End Rem
	Method SetValue(text:String)
		m_text = text
	End Method
	
	Rem
		bbdoc: Get the string value for the localized text.
		returns: The string value (text) for the localized text.
	End Rem
	Method GetValue:String()
		Return m_text
	End Method
	
'#end region (Field accessors)
	
'#region Collections
	
	Rem
		bbdoc: Get the collection key for the localized text.
		returns: The collection key for the localized text (currently the name of the localized text).
	End Rem
	Method CollectionKey:String()
		Assert m_name, "(TLocalizedText.CollectionKey()) m_name is Null!"
		Return m_name.ToLower()
	End Method
	
'#end region (Collections)
	
	Rem
		bbdoc: Load a localized text from the given identifier.
		returns: The loaded localized text (itself), or Null if the given identifier is not of the correct template (see #m_template).
	End Rem
	Method FromIdentifier:TLocalizedText(iden:TIdentifier)
		If m_template.ValidateIdentifier(iden) = True
			SetName(iden.GetName())
			SetValue(TStringVariable(iden.GetValueAtIndex(0)).Get())
			Return Self
		Else
			Return Null
		End If
	End Method
	
End Type

