
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

' 
' crypt.bmx (Contains: CryptStream(), )
' 
' 

Rem
	bbdoc: Decrypt/Encrypt a stream.
	returns: A bank stream containing the decrypted data, or Null if it failed to create a bank stream around @url.
	about: @url can be a path or a stream.
	You can use this to either encrypt or decrypt a stream.
End Rem
Function CryptStream:TBankStream(url:Object, Key:String)
  Local bstream:TBankStream = TBankStream(url)
	
	If bstream = Null
		
		bstream = TBankStream.Create(TBank.Load(url))
		
	End If
	
	If bstream <> Null
		
		RC4_Bytes(bstream._bank.Lock(), bstream._bank.Capacity(), Key)
		
	End If
	
	Return bstream
	
End Function




















