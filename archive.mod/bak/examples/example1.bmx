
SuperStrict

Framework brl.blitz
Import brl.stream
Import duct.archive

Local archive:TArchive = New TArchive.Create("archive1.arc")
Local stream:TStream, file:TArchivedFile, folder:TArchivedFolder

folder = New TArchivedFolder.Create("waffles")
archive.GetEntries().AddEntry(folder)

file = New TArchivedFile.CreateFromFile("media/text.txt")
folder.AddEntry(file)

stream = WriteStream("media/archive1.arc")
archive.Serialize(stream)
stream.Close()
archive = Null

stream = ReadStream("media/archive1.arc")
archive = New TArchive.Deserialize(stream)
stream.Close()

folder = archive.GetEntries().GetFolderWithName("waffles")
file = folder.GetFileWithName("text.txt")
file.GetData().Save("media/text2.txt")
