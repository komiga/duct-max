
SuperStrict

Framework brl.blitz
Import brl.standardio
Import duct.archive

Const key:String = "abcdef"
Local path:String = "media/text.txt"
Local archive:TArchive = New TArchive.Create("archive1")

archive.AddPhysicalFile(path, path)

archive.WriteToFile("media/" + archive.GetName() + ".arc", Null)

archive.SetCompressionLevel(9)
archive.WriteToFile("media/" + archive.GetName() + "c.arc", Null)

archive.SetCompressionLevel(0)
archive.SetEncrypted(True)
archive.WriteToFile("media/" + archive.GetName() + "e.arc", key)

archive.SetCompressionLevel(9)
archive.SetEncrypted(True)
archive.WriteToFile("media/" + archive.GetName() + "ce.arc", key)

Print("Inspecting archives...")

Print(archive.GetName() + ".arc...")
TArchive.InspectArchive("media/" + archive.GetName() + ".arc", Null, Print)

Print("~n" + archive.GetName() + "c.arc...")
TArchive.InspectArchive("media/" + archive.GetName() + "c.arc", Null, Print)

Print("~n" + archive.GetName() + "e.arc...")
TArchive.InspectArchive("media/" + archive.GetName() + "e.arc", "abcdef", Print)

Print("~n" + archive.GetName() + "ce.arc...")
TArchive.InspectArchive("media/" + archive.GetName() + "ce.arc", "abcdef", Print)
