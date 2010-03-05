
SuperStrict

Framework brl.blitz
Import brl.standardio

Import duct.locale

' Set the locale extension file (default is 'loc')
dLocaleManager.SetLocaleExtension("loc")

' Parse the 'locales' directory, with no recursing.
dLocaleManager.ParseLocaleFolder("locales/", False)

Local locale:dLocale
For locale = EachIn dLocaleManager.LocaleEnumerator()
	Print("Locale: " + locale.GetName() + "; Native: " + locale.GetNativeName())
	TestLanguage(locale.GetName())
	Print("")
Next

Function TestLanguage(langname:String)
	
	If dLocaleManager.SetCurrentLocaleByName(langname) = False
		Print("Failed to set the current locale to '" + langname + "'!")
		Return
	End If
	
	' Do some stuff with text!
	
	Print(dLocaleManager.Text("appname"))	' Standard: Name
	Print(_t("appname"))					' Wrapper: Name
	Print(_s("appname")) 					' Wrapper: Structure
	
	Print(dLocaleManager.TextFromStructure("blargh.hello_world"))	' Standard: Structure
	Print(_s("blargh.hello_world"))									' Wrapper: Structure
	Print(_cat("blargh").Text("greetings"))							' Wrapper: Name -> Name
	
	Print(dLocaleManager.Category("blargh").Text("goodbye")) ' Standard: Name -> Name
	
	Print(dLocaleManager.Category("blargh").Category("more").Text("rubbish"))	' Standard: Name -> Name -> Name
	Print(_cat("blargh").Category("more").Text("rubbish"))						' Wrapper: Name -> Name -> Name
	Print(_cats("blargh.more").Text("rubbish"))									' Wrapper: Structure -> Name
	Print(_s("blargh.more.rubbish"))											' Wrapper: Structure
	
	Print(_cat("blargh").TextFromStructure("more.rubbish")) ' Wrapper: Name -> Structure
	
End Function

' Wrapper functions
Function _s:String(structure:String, separator:String = ".")
	Return dLocaleManager.TextFromStructure(structure, separator)
End Function

Function _t:String(name:String)
	Return dLocaleManager.Text(name)
End Function

Function _cats:dLocalizationCategory(structure:String, separator:String = ".")
	Return dLocaleManager.CategoryFromStructure(structure, separator)
End Function

Function _cat:dLocalizationCategory(name:String)
	Return dLocaleManager.Category(name)
End Function

