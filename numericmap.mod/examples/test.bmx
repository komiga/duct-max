
SuperStrict

Framework brl.blitz
Import brl.standardio

Import duct.numericmap

Local map:dNumericMap = New dNumericMap

map.Insert(1, 1000)
Print(map.ForKey(1))
Print(map.Count())

map.Clear()
Print(map.Count())
Print(map.Contains(1))

map.Insert(1, 2345)
map.Insert(2, 35767)
map.Insert(3, -47894687)
map.Insert(4, -5435)
map.Insert(5, 52457247)

Local enum:dIntEnumerator = map.ValueEnumerator()
While enum.HasNext()
	Print(enum.NextInt())
End While

Print("Reversed:")
enum = map.ReverseEnumerator()
While enum.HasNext()
	Print(enum.NextInt())
End While
