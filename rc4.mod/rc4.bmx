
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
bbdoc: RC4 encryption module
End Rem
Module duct.rc4

ModuleInfo "Version: 1.01"
ModuleInfo "Credit: Noel Cower/RepeatUntil on the forums, see: http://www.blitzbasic.com/codearcs/codearcs.php?code=1711"
ModuleInfo "Copyright: Tim Howard"
ModuleInfo "License: MIT"

ModuleInfo "History: Version 1.01"
ModuleInfo "History: Corrected usage of syntax (in Returns, Cases, News and Selects)"
ModuleInfo "History: Cleaned functions"
ModuleInfo "History: Version 1.00"
ModuleInfo "History: Initial release"

'Used modules
Import BRL.Math


Rem
	bbdoc: Encrypts/Decrypts a string.
	returns: The encryped/decrypted string.
End Rem
Function RC4:String(inp:String, Key:String)
	If inp = Null Or Key = Null Then Return Null
	
    Local S:Int[512 + Ceil(inp.Length * 0.55)]
    Local i:Int, j:Int, t:Int, X:Int
    Local outbuf@@  Ptr = Short Ptr(Varptr s[512])
    
	j = 0
	For i = 0 To 255
		S[i] = i
		
		If j > (Key.Length - 1)
			j = 0
		EndIf
		
		S[256 + i] = Key[j] & $ff
		j:+1
		
	Next
    
    j = 0
    For i = 0 To 255
		
        j = (j + S[i] + S[256 + i]) & $ff
        t = S[i]
		
        S[i] = S[j]
        S[j] = t
		
    Next
    
    i = 0
    j = 0
    For X = 0 To inp.Length - 1
		
        i = (i + 1) & $ff
        j = (j + S[i]) & $ff
        t = S[i]
        S[i] = S[j]
        S[j] = t
        t = (S[i] + S[j]) & $ff
        outbuf[X] = (inp[X] ~ S[t])
		
    Next
    
    Return String.FromShorts(outbuf, inp.Length)
	
End Function

Rem
	bbdoc: Encrypts/Decrypts a block of data.
	returns: Nothing, this function will modify the data directly - no copies are made.
End Rem
Function RC4_Bytes(inp:Byte Ptr, count:Int, key:String) 
  Local S:Int[512 + Ceil(count * 0.55)]
  Local i:Int, j:Int, t:Int, X:Int
  'Local outbuf:Byte Ptr = Byte Ptr(VarPtr s[512] ) 
    
	j = 0
	For i = 0 To 255
		S[i] = i
		
		If j > (Key.Length - 1)
			j = 0
		EndIf
		
		S[256 + i] = Key[j] & $ff
		j:+1
		
	Next
	
	j = 0
	For i = 0 To 255
		
		j = (j + S[i] + S[256 + i]) & $ff
		t = S[i]
		
		S[i] = S[j]
		S[j] = t
		
	Next
	
	i = 0
	j = 0
	For X = 0 To count - 1
		
		i = (i + 1) & $ff
		j = (j + S[i]) & $ff
		t = S[i]
		S[i] = S[j]
		S[j] = t
		t = (S[i] + S[j]) & $ff
		inp[X] = (inp[X] ~ S[t])
		
	Next
 
End Function











