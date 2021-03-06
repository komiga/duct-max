
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

SuperStrict

Rem
bbdoc: Localization
End Rem
Module duct.locale

ModuleInfo "Version: 0.7"
ModuleInfo "Copyright: Coranna Howard <me@komiga.com>"
ModuleInfo "License: MIT"

ModuleInfo "History: Version 0.7"
ModuleInfo "History: General cleanup"
ModuleInfo "History: Updated for duct.objectmap changes"
ModuleInfo "History: Corrected variable code for duct.variables update"
ModuleInfo "History: Moved inc/ to src/"
ModuleInfo "History: Version 0.6"
ModuleInfo "History: Added post-processing feature for dLocalizedText"
ModuleInfo "History: Version 0.5"
ModuleInfo "History: Changed dLocaleManager.SetCurrentLocale from a Method to a Function (oops)"
ModuleInfo "History: Version 0.4"
ModuleInfo "History: Fixed documentation, licenses, examples"
ModuleInfo "History: Renamed TLocalizationCategory to dLocalizationCategory"
ModuleInfo "History: Renamed TLocalizedText to dLocalizedText"
ModuleInfo "History: Renamed TLocaleManager to dLocaleManager"
ModuleInfo "History: Renamed TLocale to dLocale"
ModuleInfo "History: Updated for API change"
ModuleInfo "History: Version 0.3"
ModuleInfo "History: General cleanup"
ModuleInfo "History: Version 0.2"
ModuleInfo "History: General cleanup"
ModuleInfo "History: Version 0.1"
ModuleInfo "History: Initial release"

Import duct.etc
Import duct.objectmap
Import duct.scriptparser

Include "src/language.bmx"
Include "src/localization.bmx"

