
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

SuperStrict

Rem
bbdoc: In-memory encryption module
End Rem
Module duct.memcrypt

ModuleInfo "Version: 0.2"
ModuleInfo "Copyright: Tim Howard"
ModuleInfo "License: MIT"

ModuleInfo "History: Version 0.2"
ModuleInfo "History: General cleanup"
ModuleInfo "History: Version 0.1"
ModuleInfo "History: General cleanup"
ModuleInfo "History: Version 0.03"
ModuleInfo "History: Moved all code to the main source"
ModuleInfo "History: General code cleanup"
ModuleInfo "History: Version 0.02"
ModuleInfo "History: Corrected usage of syntax (in Returns, Cases, News and Selects)"
ModuleInfo "History: Version 0.01"
ModuleInfo "History: Initial release"

Import brl.stream
Import brl.bank
Import brl.bankstream
Import duct.rc4

Rem
	bbdoc: Decrypt/encrypt a stream.
	returns: A bank stream containing the decrypted data, or Null if it failed to create a bank stream on @url.
	about: @url can be a path or a Stream.<br>
	You can use this to either encrypt or decrypt a stream.
End Rem
Function CryptStream:TBankStream(url:Object, key:String)
	Local bstream:TBankStream = TBankStream(url)
	If Not bstream
		bstream = TBankStream.Create(TBank.Load(url))
	End If
	If bstream
		RC4_Bytes(bstream._bank.Lock(), bstream._bank.Capacity(), key)
	End If
	Return bstream
End Function

