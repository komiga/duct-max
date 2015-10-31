
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
bbdoc: Input handling module
End Rem
Module duct.input

ModuleInfo "Version: 0.5"
ModuleInfo "Copyright: Coranna Howard <me@komiga.com>"
ModuleInfo "License: MIT"

ModuleInfo "History: Version 0.5"
ModuleInfo "History: General cleanup"
ModuleInfo "History: Updated for duct.objectmap changes"
ModuleInfo "History: Corrected variable code for duct.variables update"
ModuleInfo "History: Moved inc/ to src/"
ModuleInfo "History: Version 0.41"
ModuleInfo "History: Fixed documentation, licenses, examples"
ModuleInfo "History: Renamed TBindRecognizeException to dBindRecognizeException"
ModuleInfo "History: Renamed TInputConv to dInputConv"
ModuleInfo "History: Renamed TInputIdentifier to dInputIdentifier"
ModuleInfo "History: Renamed TBindMap to dBindMap"
ModuleInfo "History: Updated for API change"
ModuleInfo "History: Version 0.40"
ModuleInfo "History: General cleanup"
ModuleInfo "History: Version 0.39"
ModuleInfo "History: Another cleanup; fixed documentation, added some standard methods"
ModuleInfo "History: Version 0.38"
ModuleInfo "History: General code cleanup"
ModuleInfo "History: Version 0.37"
ModuleInfo "History: Changes: Updated for Template multi-name support (duct.template v0.12), and removed syntax incorrectedness (in Returns, News, Cases and Selects)"
ModuleInfo "History: Version 0.36"
ModuleInfo "History: Change: TInputConv String to Input Code conversion methods return zero (previously -1) on failure."
ModuleInfo "History: Change: Removed the plus sign requirement in the bind template ('bind ~qw~q +action' would now be 'bind ~qw~q action')."
ModuleInfo "History: Remove and Change: TInputIdentifiers no longer hold the input_scode (string representation of the input code), instead it is now converted when needed (method GetInputCodeString is now GetInputCodeAsString)."
ModuleInfo "History: Added: TInputIdentifier Bind and UnBind methods."
ModuleInfo "History: Version 0.35"
ModuleInfo "History: Initial release."

Import brl.polledinput
Import brl.keycodes

Import duct.etc
Import duct.variables

Include "src/inputconv.bmx"
Include "src/keyhandler.bmx"
Include "src/bindmap.bmx"

