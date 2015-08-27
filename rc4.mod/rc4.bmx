
Rem
Copyright (c) 2010 plash <plash@komiga.com>

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
bbdoc: RC4 encryption module
End Rem
Module duct.rc4

ModuleInfo "Version: 1.2"
ModuleInfo "Credit: Noel Cower/RepeatUntil on the forums, see: http://www.blitzbasic.com/codearcs/codearcs.php?code=1711"
ModuleInfo "Copyright: plash <plash@komiga.com>"
ModuleInfo "License: MIT"

ModuleInfo "History: Version 1.2"
ModuleInfo "History: General Cleanup"
ModuleInfo "History: Version 1.1"
ModuleInfo "History: General cleanup"
ModuleInfo "History: Version 1.02"
ModuleInfo "History: General code cleanup"
ModuleInfo "History: Version 1.01"
ModuleInfo "History: Corrected usage of syntax (in Returns, Cases, News and Selects)"
ModuleInfo "History: Cleaned functions"
ModuleInfo "History: Version 1.00"
ModuleInfo "History: Initial release"

Import brl.math

Rem
	bbdoc: Encrypt/decrypt the given string.
	returns: The encryped/decrypted string, or Null if either the given data or key was Null.
End Rem
Function RC4:String(inp:String, key:String)
	If Not inp Or Not key Then Return Null
    Local s:Int[512 + Ceil(inp.Length * 0.55)]
    Local i:Int, j:Int, t:Int
    Local outbuf:Short Ptr = Short Ptr(Varptr s[512])
	j = 0
	For i = 0 To 255
		s[i] = i
		If j > (key.Length - 1)
			j = 0
		End If
		s[256 + i] = key[j] & $ff
		j:+1
	Next
    
    j = 0
    For i = 0 To 255
        j = (j + s[i] + s[256 + i]) & $ff
        t = s[i]
        s[i] = s[j]
        s[j] = t
    Next
    
    i = 0
    j = 0
    For Local x:Int = 0 Until inp.Length
        i = (i + 1) & $ff
        j = (j + s[i]) & $ff
        t = s[i]
        s[i] = s[j]
        s[j] = t
        t = (s[i] + s[j]) & $ff
        outbuf[x] = (inp[x] ~ s[t])
    Next
    Return String.FromShorts(outbuf, inp.Length)
End Function

Rem
	bbdoc: Encrypt/decrypt the given block of data.
	returns: Nothing, this function will modify the data directly - no copies are made.
End Rem
Function RC4_Bytes(inp:Byte Ptr, count:Int, key:String) 
	Local s:Int[512 + Ceil(count * 0.55)]
	Local i:Int, j:Int, t:Int
	'Local outbuf:Byte Ptr = Byte Ptr(VarPtr s[512]) 
	j = 0
	For i = 0 To 255
		s[i] = i
		If j > (key.Length - 1)
			j = 0
		End If
		s[256 + i] = key[j] & $ff
		j:+1
	Next
	
	j = 0
	For i = 0 To 255
		j = (j + s[i] + s[256 + i]) & $ff
		t = s[i]
		s[i] = s[j]
		s[j] = t
	Next
	
	i = 0
	j = 0
	For Local x:Int = 0 Until count
		i = (i + 1) & $ff
		j = (j + S[i]) & $ff
		t = s[i]
		s[i] = s[j]
		s[j] = t
		t = (s[i] + s[j]) & $ff
		inp[x] = (inp[x] ~ s[t])
	Next
End Function

