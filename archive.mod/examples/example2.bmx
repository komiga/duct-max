
SuperStrict

Framework brl.blitz
Import brl.standardio
Import duct.archive

Const key:String = "waffles"
Local archive:dArchive = New dArchive.CreateFromFolder("archive2", "media/testo/", True)

archive.SetEncrypted(True)
archive.SetCompressionLevel(1)
archive.WriteToFile("media/" + archive.GetName() + ".arc", key)

Print("Inspecting archive: media/" + archive.GetName() + ".arc...")
dArchive.InspectArchive("media/" + archive.GetName() + ".arc", key, Print)

Local file:dArchivedFile

archive = New dArchive.LoadFromFile("media/archive2.arc")
file = archive.GetFileWithName("waffles/are/here/data.txt", key)
If file <> Null
	If file.GetData() <> Null
		file.GetData().Save("media/datatest.txt")
	End If
End If

archive.ExportFiles("media/export/", key)
