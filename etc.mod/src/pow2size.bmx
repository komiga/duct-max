
Rem
	bbdoc: Get the next power of two to the given value.
	returns: The next power of two to the given value.
End Rem
Function Pow2Size:Float(n:Int)
	local t:Int = 1
	While t < n
		t:* 2
	Wend
	Return Float(t)
End Function

