
Rem
	Description: A simple test for duct.locale.
End Rem

SuperStrict

Framework brl.blitz
Import brl.standardio

Import duct.locale

' Set the locale extension file (default is 'loc')
TLocaleManager.SetLocaleExtension("loc")

' Parse the 'locales' directory, with no recursing.
TLocaleManager.ParseLocaleFolder("locales/", False)

Local locale:TLocale
For locale = EachIn TLocaleManager.LocaleEnumerator()
	Print("Locale: " + locale.GetName() + "; Native: " + locale.GetNativeName())
	TestLanguage(locale.GetName())
	Print("")
Next

Function TestLanguage(langname:String)
	
	If TLocaleManager.SetCurrentLocaleByName(langname) = False
		Print("Failed to set the current locale to '" + langname + "'!")
		Return
	End If
	
	' Do some stuff with text!
	
	Print(TLocaleManager.Text("appname"))	' Standard: Name
	Print(_t("appname"))					' Wrapper: Name
	Print(_s("appname")) 					' Wrapper: Structure
	
	Print(TLocaleManager.TextFromStructure("blargh.hello_world"))	' Standard: Structure
	Print(_s("blargh.hello_world"))									' Wrapper: Structure
	Print(_cat("blargh").Text("greetings"))							' Wrapper: Name -> Name
	
	Print(TLocaleManager.Category("blargh").Text("goodbye")) ' Standard: Name -> Name
	
	Print(TLocaleManager.Category("blargh").Category("more").Text("rubbish"))	' Standard: Name -> Name -> Name
	Print(_cat("blargh").Category("more").Text("rubbish"))						' Wrapper: Name -> Name -> Name
	Print(_cats("blargh.more").Text("rubbish"))									' Wrapper: Structure -> Name
	Print(_s("blargh.more.rubbish"))											' Wrapper: Structure
	
	Print(_cat("blargh").TextFromStructure("more.rubbish")) ' Wrapper: Name -> Structure
	
End Function

' Wrapper functions
Function _s:String(structure:String, separator:String = ".")
	Return TLocaleManager.TextFromStructure(structure, separator)
End Function

Function _t:String(name:String)
	Return TLocaleManager.Text(name)
End Function

Function _cats:TLocalizationCategory(structure:String, separator:String = ".")
	Return TLocaleManager.CategoryFromStructure(structure, separator)
End Function

Function _cat:TLocalizationCategory(name:String)
	Return TLocaleManager.Category(name)
End Function
























