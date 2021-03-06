
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
bbdoc: Miscellaneous module
End Rem
Module duct.etc

ModuleInfo "Version: 0.26"
ModuleInfo "Copyright: Coranna Howard <me@komiga.com>"
ModuleInfo "License: MIT"

ModuleInfo "History: Version 0.26"
ModuleInfo "History: General cleanup"
ModuleInfo "History: Version 0.25"
ModuleInfo "History: Added dCloseGuardStreamWrapper"
ModuleInfo "History: Version 0.24"
ModuleInfo "History: General cleanup"
ModuleInfo "History: Added RemoveLink to TListEx"
ModuleInfo "History: Renamed TStringBuilder to dStringBuilder"
ModuleInfo "History: Renamed dTextReplacer.GetReplacementFromName to dTextReplacer.GetReplacementWithName"
ModuleInfo "History: Renamed dTextReplacer.SetReplacementByName to dTextReplacer.SetReplacementsWithName"
ModuleInfo "History: Renamed TTextReplacer to dTextReplacer and TTextReplacement to dTextReplacement"
ModuleInfo "History: Moved string reading/writing functions into dStreamIO"
ModuleInfo "History: Renamed WriteNString to WriteCString and ReadNString to ReadCString"
ModuleInfo "History: Removed WriteNLString and ReadNLString"
ModuleInfo "History: Renamed src/nstring.bmx to src/streamio.bmx"
ModuleInfo "History: Renamed TMSTimer to dMSTimer"
ModuleInfo "History: Added text encoding constants"
ModuleInfo "History: Version 0.23"
ModuleInfo "History: Several doc and code fixes, added ReadNLString and WriteNLString"
ModuleInfo "History: Renamed inc/ to src/"
ModuleInfo "History: Version 0.22"
ModuleInfo "History: Removed TimeInFormat and FileTimeWithFormat (adapted to duct.time)"
ModuleInfo "History: Version 0.21"
ModuleInfo "History: Added TStringBuilder"
ModuleInfo "History: Corrected documentation"
ModuleInfo "History: Version 0.20"
ModuleInfo "History: Added OnTick to TMSTimer"
ModuleInfo "History: Version 0.19"
ModuleInfo "History: General cleanup"
ModuleInfo "History: Version 0.18"
ModuleInfo "History: More formatting.."
ModuleInfo "History: CreateFileExplicitly now returns True/False on success/failure"
ModuleInfo "History: Version 0.17"
ModuleInfo "History: Wooops, forgot to return in ReadLString()"
ModuleInfo "History: A bit of formatting"
ModuleInfo "History: Version 0.16"
ModuleInfo "History: Added IsDivisible()"
ModuleInfo "History: Version 0.15"
ModuleInfo "History: Added TListEx"
ModuleInfo "History: Added TTextReplacer example"
ModuleInfo "History: Added TTextReplacer and TTextReplacement"
ModuleInfo "History: Version 0.14"
ModuleInfo "History: Added FixPathEnding()"
ModuleInfo "History: Version 0.13"
ModuleInfo "History: Fixed a few things in some file-operation functions"
ModuleInfo "History: Version 0.12"
ModuleInfo "History: General code cleanup"
ModuleInfo "History: Version 0.11"
ModuleInfo "History: Added TimeInFormat, FileTimeWithFormat and explicit file functions"
ModuleInfo "History: Version 0.1"
ModuleInfo "History: Added ReadLString and WriteLString"
ModuleInfo "History: Version 0.097"
ModuleInfo "History: Added TMSTimer (millisecond timer)"
ModuleInfo "History: Fixed TListReversed (it was clearing the list it was wrapped around)"
ModuleInfo "History: Version 0.094"
ModuleInfo "History: Added TFPSCounter"
ModuleInfo "History: Added TListReversed, Brucey's code (http://www.blitzbasic.com/Community/posts.php?topic=82916)"
ModuleInfo "History: Corrected usage of syntax (in Returns, Cases, News and Selects)"
ModuleInfo "History: Version 0.09"
ModuleInfo "History: Added newline-terminated string reading and writing functions"
ModuleInfo "History: Version 0.08"
ModuleInfo "History: Initial release"

Import brl.math
Import brl.stream
Import brl.linkedlist
Import brl.filesystem

Include "src/pow2size.bmx"
Include "src/streamio.bmx"
Include "src/minmax.bmx"
Include "src/other.bmx"
Include "src/constants.bmx"

Include "src/listreversed.bmx"
Include "src/fpscounter.bmx"
Include "src/mstimer.bmx"
Include "src/replacer.bmx"
Include "src/listex.bmx"
Include "src/stringbuilder.bmx"
Include "src/closeguardstream.bmx"

