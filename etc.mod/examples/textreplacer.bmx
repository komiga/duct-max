
SuperStrict

Framework brl.blitz
Import brl.standardio

Import duct.etc

Const mystring:String = "Testing dTextReplacer, <<word>> <<one>><<two>> <<three>> blah <<four>> <<another>> abcdefg"
Local replacer:dTextReplacer = New dTextReplacer.Create(mystring)

replacer.AutoReplacements("<<", ">>")

replacer.SetReplacementsWithName("word", "NOT A WORD!")
replacer.SetReplacementsWithName("one", "te")
replacer.SetReplacementsWithName("two", "mp")

replacer.SetReplacementsWithName("three", 100)
replacer.SetReplacementsWithName("four", "FPS:")
replacer.SetReplacementsWithName("another", 60)

Print(mystring)
Print(replacer.DoReplacements())

