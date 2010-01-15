
SuperStrict

Framework brl.blitz
Import brl.standardio
Import duct.archive

Const key:String = "waffles"
Local archive:TArchive = New TArchive.CreateFromFolder("archive2", "media/testo/", True)

archive.SetEncrypted(True)
archive.SetCompressionLevel(1)
archive.WriteToFile("media/" + archive.GetName() + ".arc", key)

Print("Inspecting archive: media/" + archive.GetName() + ".arc...")
TArchive.InspectArchive("media/" + archive.GetName() + ".arc", key, Print)

Local file:TArchivedFile

archive = New TArchive.LoadFromFile("media/archive2.arc")
file = archive.GetFileWithName("waffles/are/here/data.txt", key)
If file <> Null
	If file.GetData() <> Null
		file.GetData().Save("media/datatest.txt")
	End If
End If

archive.ExportFiles("media/export/", key)
