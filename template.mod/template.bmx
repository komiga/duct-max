
' Copyright (c) 2009 Tim Howard
' 
' Permission is hereby granted, free of charge, to any person obtaining a copy
' of this software and associated documentation files (the "Software"), to deal
' in the Software without restriction, including without limitation the rights
' to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
' copies of the Software, and to permit persons to whom the Software is
' furnished to do so, subject to the following conditions:
' 
' The above copyright notice and this permission notice shall be included in
' all copies or substantial portions of the Software.
' 
' THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
' IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
' FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
' AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
' LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
' OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
' THE SOFTWARE.
' 

SuperStrict

Rem
bbdoc: Script Template module
End Rem
Module duct.template

ModuleInfo "Version: 0.13"
ModuleInfo "Copyright: Tim Howard"
ModuleInfo "License: MIT"

ModuleInfo "History: Version 0.13"
ModuleInfo "History: Added error checking in TTemplate.DeSerialize() and TTemplate.Serialize()"
ModuleInfo "History: Added error checking for Null template idens (the template name check will pass for any identifier name, if the iden array is Null)"
ModuleInfo "History: Version 0.12"
ModuleInfo "History: Modified: TTemplate now supports multiple identifier names"
ModuleInfo "History: Corrected usage of syntax (in Returns, Cases, News and Selects)"
ModuleInfo "History: Version 0.11"
ModuleInfo "History: Initial release"


'Used modules
Import brl.stream

Import duct.etc
Import duct.variablemap
Import duct.scriptparser


'Included code
Include "inc/types/ttemplate.bmx"

























