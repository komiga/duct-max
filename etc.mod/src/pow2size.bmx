
Rem
	bbdoc: Get the next power of two to the given value.
	returns: The next power of two to the given value.
End Rem
Function Pow2Size:Float(n:Int)
	Local t:Int = 1
	While t < n
		t:* 2
	End While
	Return Float(t)
End Function

