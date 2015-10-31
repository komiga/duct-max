
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
bbdoc: Networking module
End Rem
Module duct.network

ModuleInfo "Version: 0.8"
ModuleInfo "Copyright: Coranna Howard <me@komiga.com>"
ModuleInfo "License: MIT"

ModuleInfo "History: Version 0.8"
ModuleInfo "History: General cleanup"
ModuleInfo "History: Renamed dNetMessageMap.GetMessageByID to GetMessageWithID"
ModuleInfo "History: Renamed inc/ to src/"
ModuleInfo "History: Version 0.7"
ModuleInfo "History: Appified example code"
ModuleInfo "History: dNetMessageMap now uses dIntMap instead of extending dObjectMap"
ModuleInfo "History: dNetMessageMap.InsertMessage now returns True/False as intended"
ModuleInfo "History: dServer now disconnects clients /before/ closing the socket"
ModuleInfo "History: Version 0.6"
ModuleInfo "History: Fixed documentation, licenses, examples"
ModuleInfo "History: Renamed TNetMessageMap to dNetMessageMap"
ModuleInfo "History: Renamed TNetMessage to dNetMessage"
ModuleInfo "History: Renamed TServer to dServer"
ModuleInfo "History: Renamed TClient to dClient"
ModuleInfo "History: Updated for API change"
ModuleInfo "History: Version 0.5"
ModuleInfo "History: Added documentation for the ondisconnect parameter"
ModuleInfo "History: Added ondisconnect to TServer.Close"
ModuleInfo "History: Version 0.4"
ModuleInfo "History: Corrected a few method names, made TNetMessage abstract"
ModuleInfo "History: Version 0.3"
ModuleInfo "History: Corrected field names"
ModuleInfo "History: General cleanup"
ModuleInfo "History: Version 0.2"
ModuleInfo "History: Changed license headers"
ModuleInfo "History: Version 0.1"
ModuleInfo "History: Initial release"

Import brl.linkedlist
Import brl.socket

Import duct.etc
Import duct.intmap

Include "src/client.bmx"
Include "src/server.bmx"
Include "src/message.bmx"

