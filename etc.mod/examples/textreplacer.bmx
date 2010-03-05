
SuperStrict

Framework brl.blitz
Import brl.standardio

Import duct.etc

Const mystring:String = "Testing TTextReplacer, <<word>> <<one>><<two>> <<three>> blah <<four>> <<another>> abcdefg"
Local replacer:TTextReplacer = New TTextReplacer.Create(mystring)

replacer.AutoReplacements("<<", ">>")

replacer.SetReplacementByName("word", "NOT A WORD!")
replacer.SetReplacementByName("one", "te")
replacer.SetReplacementByName("two", "mp")

replacer.SetReplacementByName("three", 100)
replacer.SetReplacementByName("four", "FPS:")
replacer.SetReplacementByName("another", 60)

Print(mystring)
Print(replacer.DoReplacements())

