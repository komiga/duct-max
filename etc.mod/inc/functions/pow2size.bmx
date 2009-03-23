
' 
' pow2size.bmx (Contains: Pow2Size(), )
' 
' 

' Nabbed from either BRL or klepto.
Rem
	bbdoc: Get the next power of two to the given value.
	returns: The next power of two to the given value.
End Rem
Function Pow2Size:Float(n:Int)
	Local t:Int
	
	t = 1
	
	While(t < n)
		
		t:*2
		
	Wend
	
	Return Float(t)
	
End Function
