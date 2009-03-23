

' memcrypt example

SuperStrict

Framework brl.blitz
Import brl.standardio

Import duct.memcrypt


' Saving data
Local outstream:TBankStream = CreateBankStream(Null)
	
	If outstream <> Null
		
		outstream.WriteLine("Hello world!")
		
		CryptStream(outstream, "l*(%&*(73WHSFjdkj6o7iK^*OL4e5k2ohqwteh45&J&*t78$%sz*")
		
		' Save
		outstream._bank.save("test.bin")
		
	End If
	
outstream.Close()

'Reading
Local instream:TBankStream = CryptStream("test.bin", "l*(%&*(73WHSFjdkj6o7iK^*OL4e5k2ohqwteh45&J&*t78$%sz*")
	
	If instream <> Null
		
		Print(instream.ReadLine())
		
	End If
	
instream.Close()

End




