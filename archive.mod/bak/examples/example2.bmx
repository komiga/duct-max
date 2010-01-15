
SuperStrict

Framework brl.blitz
Import brl.standardio

Import duct.archive

Local archive:TArchive = New TArchive.CreateFromFolder("archive2.arc", "media/testo")

Print(archive.GetStructure())

Local stream:TStream = WriteStream("media/" + archive.GetName())
archive.Serialize(stream)
stream.Close()
