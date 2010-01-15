Rem
	Copyright (c) 2009 Tim Howard
	
	Permission is hereby granted, free of charge, to any person obtaining a copy
	of this software and associated documentation files (the "Software"), to deal
	in the Software without restriction, including without limitation the rights
	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the Software is
	furnished to do so, subject to the following conditions:
	
	The above copyright notice and this permission notice shall be included in
	all copies or substantial portions of the Software.
	
	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
	THE SOFTWARE.
	-----------------------------------------------------------------------------
	
	archive.bmx (Contains: TArchive, )
	
	TODO:
		
End Rem

Rem
	bbdoc: The Archive type (stores files and folder structures, with encryption).
End Rem
Type TArchive
	
	Field m_name:String
	Field m_entries:TArchivedFolder
	
	Method New()
		m_entries = New TArchivedFolder.Create("root")
	End Method
	
	Rem
		bbdoc: Create a new Archive.
		returns: The new Archive (itself).
	End Rem
	Method Create:TArchive(name:String)
		SetName(name)
		Return Self
	End Method
	
	Rem
		bbdoc: Create a new Archive from the given path.
		returns: The new Archive (itself).
	End Rem
	Method CreateFromFolder:TArchive(name:String, path:String, recursive:Int = True)
		SetName(name)
		m_entries.AddPhysicalFolder(path, recursive)
		Return Self
	End Method
	
'#region Field accessors
	
	Rem
		bbdoc: Set the archive's name.
		returns: Nothing.
		about: An assert will be thrown if the given name is Null.
	End Rem
	Method SetName:String(name:String)
		Assert name <> Null, "(TArchive.SetName) Name cannot be Null!"
		m_name = name
	End Method
	
	Rem
		bbdoc: Get the archive's name.
		returns: The archive's name.
	End Rem
	Method GetName:String()
		Return m_name
	End Method
	
	Rem
		bbdoc: Get the archive's entries (root folder).
		returns: The archive's root.
	End Rem
	Method GetEntries:TArchivedFolder()
		Return m_entries
	End Method
	
'#end region (Field accessors)
	
'#region Data handling
	
	Rem
		bbdoc: Serialize the archive into the given stream.
		returns: Nothing.
	End Rem
	Method Serialize(stream:TStream)
		WriteLString(stream, m_name)
		m_entries.Serialize(stream)
	End Method
	
	Rem
		bbdoc: Deserialize the Archive from the given stream.
		returns: The deserialized archive (itself).
	End Rem
	Method Deserialize:TArchive(stream:TStream)
		SetName(ReadLString(stream))
		m_entries.Deserialize(stream)
		Return Self
	End Method
	
'#end region (Data handling)
	
'#region Misc
	
	Rem
		bbdoc: Get the file structure of the archive as a string.
		returns: The structure of the archive.
	End Rem
	Method GetStructure:String()
		Return m_entries.GetStructure()
	End Method
	
'#end region Misc
	
End Type

Rem
	bbdoc: The ArchivedEntry type.
End Rem
Type TArchivedEntry Abstract
	
	Field m_name:String
	Field m_parent:TArchivedFolder
	
'#region Field accessors
	
	Rem
		bbdoc: Set the entry's name.
		returns: Nothing.
		about: An assert will be thrown if the given name is Null.
	End Rem
	Method SetName(name:String)
		Assert name <> Null, "(TArchivedEntry.SetName) Name cannot be Null!"
		m_name = name
	End Method
	
	Rem
		bbdoc: Get the entry's name.
		returns: The entry's name.
	End Rem
	Method GetName:String()
		Return m_name
	End Method
	
	Rem
		bbdoc: Get the entry's parent.
		returns: The entry's parent (might be Null - in which case the entry is likely an Archive's root).
	End Rem
	Method GetParent:TArchivedFolder()
		Return m_parent
	End Method
	
'#end region (Field accessors)
	
'#region Data handling
	
	Rem
		bbdoc: Serialize the entry into the given stream.
		returns: Nothing.
	End Rem
	Method Serialize(stream:TStream)
		WriteLString(stream, m_name)
	End Method
	
	Rem
		bbdoc: Deserialize the entry from the given stream.
		returns: The deserialized entry (itself).
	End Rem
	Method Deserialize:TArchivedEntry(stream:TStream)
		SetName(ReadLString(stream))
		Return Self
	End Method
	
'#end region (Data handling)
	
'#region Misc
	
	Rem
		bbdoc: Get the entry's structure.
		returns: The structure of the entry.
		about: This method needs to be implemented in extending types.
	End Rem
	Method GetStructure:String(tabs:String = Null) Abstract
	
	Rem
		bbdoc: Clear the current parent and aset a new one.
		returns: Nothing.
	End Rem
	Method _ClearParent(newparent:TArchivedFolder)
		If m_parent <> Null
			m_parent.RemoveEntry(Self)
		End If
		m_parent = newparent
	End Method
	
	Rem
		bbdoc: Set the folder's parent.
		returns: Nothing.
		about: You should not use this method. See the #RemoveEntry method in #TArchivedFolder.
	End Rem
	Method _SetParent(parent:TArchivedFolder)
		m_parent = parent
	End Method
	
'#end region (Misc)
	
End Type

Rem
	bbdoc: The ArchivedFolder type.
End Rem
Type TArchivedFolder Extends TArchivedEntry
	
	Field m_children:TObjectMap
	Field m_foldercount:Int, m_filecount:Int
	
	Method New()
		m_children = New TObjectMap
	End Method
	
	Rem
		bbdoc: Create a new ArchivedFolder.
		returns: The new ArchivedFolder (itself).
	End Rem
	Method Create:TArchivedFolder(name:String)
		SetName(name)
		Return Self
	End Method
	
	Rem
		bbdoc: Create a new ArchivedFolder from the given path.
		returns: The new ArchivedFolder (itself), or Null if the given path could not be read.
	End Rem
	Method CreateFromFolder:TArchivedFolder(path:String, recursive:Int = True)
		Local dirhandle:Int, file:String
		
		If path <> Null
			FixPath(path)
			path = FixPathEnding(path, True)
			If FileType(path) = FILETYPE_DIR
				SetName(StripDir(path))
				dirhandle = ReadDir(path)
				Repeat
					file = NextFile(dirhandle)
					If file = "" Then Exit
					If file <> "." And file <> ".."
						Select FileType(path + file)
							Case FILETYPE_FILE
								AddPhysicalFile(path + file)
							Case FILETYPE_DIR
								If recursive = True
									AddPhysicalFolder(path + file + "/", True)
								End If
						End Select
					End If
				Forever
				CloseDir(dirhandle)
				Return Self
			End If
		End If
		Return Null
	End Method
	
'#region Field accessors
	
	Rem
		bbdoc: Get the number of folders in the folder.
		returns: The number of folders in the folder.
	End Rem
	Method GetFolderCount:Int()
		Return m_foldercount
	End Method
	
	Rem
		bbdoc: Get the number of files in the folder.
		returns: The number of files in the folder..
	End Rem
	Method GetFileCount:Int()
		Return m_filecount
	End Method
	
'#end region (Field accessors)
	
'#region Collections
	
	Rem
		bbdoc: Get the number of entries (files and folders) in the folder.
		returns: Nothing.
	End Rem
	Method GetEntryCount:Int()
		Return m_children.Count()
	End Method
	
	Rem
		bbdoc: Check if the folder contains an entry with the given name.
		returns: True if there is an entry with the given name, or False if there is no entry with the given name.
	End Rem
	Method ContainsEntryWithName:Int(name:String)
		If name <> Null
			Return m_children._Contains(name)
		End If
		Return False
	End Method
	
	Rem
		bbdoc: Check if the folder contains a folder with the given name.
		returns: True if there is a folder with the given name, or False if there is no folder with the given name.
	End Rem
	Method ContainsFolderWithName:Int(name:String)
		If name <> Null
			Return TArchivedFolder(m_children._ValueByKey(name)) <> Null
		End If
		Return False
	End Method
	
	Rem
		bbdoc: Check if the file contains a folder with the given name.
		returns: True if there is a file with the given name, or False if there is no file with the given name.
	End Rem
	Method ContainsFileWithName:Int(name:String)
		If name <> Null
			Return TArchivedFile(m_children._ValueByKey(name)) <> Null
		End If
		Return False
	End Method
	
	Rem
		bbdoc: Check if the folder contains the given entry.
		returns: True if the given entry is in the folder, or False if it is not.
	End Rem
	Method ContainsEntry:Int(entry:TArchivedEntry)
		If entry <> Null
			Return m_children._Contains(entry.GetName())
		End If
		Return False
	End Method
	
	Rem
		bbdoc: Check if the folder contains the given folder.
		returns: True if the given folder is in the folder, or False if it is not.
	End Rem
	Method ContainsFolder:Int(folder:TArchivedFolder)
		If folder <> Null
			Return TArchivedFolder(m_children._ValueByKey(folder.GetName())) <> Null
		End If
		Return False
	End Method
	
	Rem
		bbdoc: Check if the folder contains the given file.
		returns: True if the given file is in the folder, or False if it is not.
	End Rem
	Method ContainsFile:Int(file:TArchivedFile)
		If file <> Null
			Return TArchivedFile(m_children._ValueByKey(file.GetName())) <> Null
		End If
		Return False
	End Method
	
	Rem
		bbdoc: Get the entry (folder or file) with the given name.
		returns: The entry with the given name, or Null if the given name was not found.
	End Rem
	Method GetEntryWithName:TArchivedEntry(name:String)
		Return TArchivedEntry(m_children._ValueByKey(name))
	End Method
	
	Rem
		bbdoc: Get the folder with the given name.
		returns: The folder with the given name, or Null if the given name was not found.
	End Rem
	Method GetFolderWithName:TArchivedFolder(name:String)
		Return TArchivedFolder(m_children._ValueByKey(name))
	End Method
	
	Rem
		bbdoc: Get the file with the given name.
		returns: The file with the given name, or Null if the given name was not found.
	End Rem
	Method GetFileWithName:TArchivedFile(name:String)
		Return TArchivedFile(m_children._ValueByKey(name))
	End Method
	
	Rem
		bbdoc: Add the given entry to the folder.
		returns: True if the entry was added, or False if it was not (either the entry's name conflicts with another file/folder name or the entry given is Null).
	End Rem
	Method AddEntry:Int(entry:TArchivedEntry)
		If TArchivedFolder(entry) <> Null
			Return AddFolder(TArchivedFolder(entry))
		Else If TArchivedFile(entry) <> Null
			Return AddFile(TArchivedFile(entry))
		End If
	End Method
	
	Rem
		bbdoc: Add the given folder to the folder.
		returns: True if the folder was added, or False if it was not (either the folder's name conflicts with another file/folder name or the given folder is Null).
	End Rem
	Method AddFolder:Int(folder:TArchivedFolder)
		If folder <> Null
			If ContainsFolder(folder) = False
				m_foldercount:+1
				folder._ClearParent(Self)
				m_children._Insert(folder.GetName(), folder)
			End If
		End If
		Return False
	End Method
	
	Rem
		bbdoc: Add the given on-disk folder to the folder.
		returns: True if the folder was added, or False if it was not (either the folder's name conflicts with another file/folder name or the given path is Null).
	End Rem
	Method AddPhysicalFolder:Int(path:String, recursive:Int = True)
		Return AddFolder(New TArchivedFolder.CreateFromFolder(path, recursive))
	End Method
	
	Rem
		bbdoc: Add the given file to the folder.
		returns: True if the file was added, or False if it was not (either the file's name conflicts with another file/folder name or the given file is Null).
	End Rem
	Method AddFile:Int(file:TArchivedFile)
		If file <> Null
			If ContainsFile(file) = False
				m_filecount:+1
				file._ClearParent(Self)
				m_children._Insert(file.GetName(), file)
			End If
		End If
		Return False
	End Method
	
	Rem
		bbdoc: Add the given on-disk file to the folder.
		returns: True if the file was added, or False if it was not (either the file's name conflicts with another file/folder name or the given path is Null).
	End Rem
	Method AddPhysicalFile:Int(path:String)
		Return AddFile(New TArchivedFile.CreateFromFile(path))
	End Method
	
	Rem
		bbdoc: Remove an entry with the given name.
		returns: True if the entry was removed, or False if it was not (either the given name is Null or it was not found in the folder).
	End Rem
	Method RemoveEntryWithName:Int(name:String)
		Return RemoveEntry(GetEntryWithName(name))
	End Method
	
	Rem
		bbdoc: Remove a folder with the given name.
		returns: True if the folder was removed, or False if it was not (either the given name is Null or it was not found in the folder).
	End Rem
	Method RemoveFolderWithName:Int(name:String)
		Return RemoveFolder(GetFolderWithName(name))
	End Method
	
	Rem
		bbdoc: Remove a file with the given name.
		returns: True if the file was removed, or False if it was not (either the given name is Null or it was not found in the folder).
	End Rem
	Method RemoveFileWithName:Int(name:String)
		Return RemoveFile(GetFileWithName(name))
	End Method
	
	Rem
		bbdoc: Remove the given entry.
		returns: True if the entry was removed, or False if it was not (either the given entry is Null or it was not found in the folder).
	End Rem
	Method RemoveEntry:Int(entry:TArchivedEntry)
		If TArchivedFolder(entry) <> Null
			Return RemoveFolder(TArchivedFolder(entry))
		Else If TArchivedFile(entry) <> Null
			Return RemoveFile(TArchivedFile(entry))
		End If
	End Method
	
	Rem
		bbdoc: Remove the given folder.
		returns: True if the folder was removed, or False if it was not (either the given folder is Null or it was not found in the folder).
	End Rem
	Method RemoveFolder:Int(folder:TArchivedFolder)
		If ContainsFolder(folder) = True
			m_foldercount:-1
			folder._SetParent(Null)
			Return m_children._Remove(folder.GetName())
		End If
		Return False
	End Method
	
	Rem
		bbdoc: Remove the given file.
		returns: True if the file was removed, or False if it was not (either the given file is Null or it was not found in the folder).
	End Rem
	Method RemoveFile:Int(file:TArchivedFile)
		If ContainsFile(file) = True
			m_filecount:-1
			file._SetParent(Null)
			Return m_children._Remove(file.GetName())
		End If
		Return False
	End Method
	
'#end region (Collections)
	
'#region Data handling
	
	Rem
		bbdoc: Serialize the folder into the given stream.
		returns: Nothing.
	End Rem
	Method Serialize(stream:TStream)
		Super.Serialize(stream)
		stream.WriteInt(m_foldercount)
		For Local entry:TArchivedFolder = EachIn m_children.ValueEnumerator()
			entry.Serialize(stream)
		Next
		stream.WriteInt(m_filecount)
		For Local entry:TArchivedFile = EachIn m_children.ValueEnumerator()
			entry.Serialize(stream)
		Next
	End Method
	
	Rem
		bbdoc: Deserialize the folder from the given stream.
		returns: The deserialized folder (itself).
	End Rem
	Method Deserialize:TArchivedFolder(stream:TStream)
		Local count:Int, i:Int
		
		Super.Deserialize(stream)
		count = stream.ReadInt()
		If count > 0
			For i = 1 To count
				AddEntry(New TArchivedFolder.Deserialize(stream))
			Next
		End If
		count = stream.ReadInt()
		If count > 0
			For i = 1 To count
				AddEntry(New TArchivedFile.Deserialize(stream))
			Next
		End If
		Return Self
	End Method
	
'#end region (Data handling)

'#region Misc
	
	Rem
		bbdoc: Get the folder's file structure.
		returns: The folder's structure.
	End Rem
	Method GetStructure:String(tabs:String = Null)
		Local report:String
		
		tabs:+"~t"
		report:+"." + m_name + "/~n"
		For Local file:TArchivedFile = EachIn m_children.ValueEnumerator()
			report:+tabs + file.GetStructure(tabs)
		Next
		For Local folder:TArchivedFolder = EachIn m_children.ValueEnumerator()
			report:+tabs + folder.GetStructure(tabs) + "~n"
		Next
		Return report
	End Method
	
'#end region (Misc)
	
End Type

Rem
	bbdoc: The ArchivedFile type.
End Rem
Type TArchivedFile Extends TArchivedEntry
	
	Field m_data:TBank
	
	Method New()
	End Method
	
	Rem
		bbdoc: Create a new ArchivedFile.
		returns: The new ArchivedFile (itself).
	End Rem
	Method Create:TArchivedFile(name:String, data:TBank)
		SetName(name)
		SetData(data)
		Return Self
	End Method
	
	Rem
		bbdoc: Create a new ArchivedFile from the given file.
		returns: The new ArchivedFile (itself), or Null if the given path could not be read.
	End Rem
	Method CreateFromFile:TArchivedFile(path:String)
		If path <> Null
			SetName(StripDir(path))
			If SetDataFromFile(path) = True
				Return Self
			End If
		End If
		Return Null
	End Method
	
'#region Field accessors
	
	Rem
		bbdoc: Set the file's data.
		returns: Nothing.
		about: Warning: Previous data will be lost!
	End Rem
	Method SetData(data:TBank)
		m_data = data
	End Method
	
	Rem
		bbdoc: Get the file's data.
		returns: The file's data bank (might be Null).
	End Rem
	Method GetData:TBank()
		Return m_data
	End Method
	
	Rem
		bbdoc: Set the file's data from the given file.
		returns: True if the data was set from the file, or False if the file could not be read.
	End Rem
	Method SetDataFromFile:Int(path:String)
		Local stream:TStream, result:Int = False
		
		stream = ReadStream(path)
		If stream <> Null
			result = SetDataFromStream(stream)
			stream.Close()
		End If
		Return result
	End Method
	
	Rem
		bbdoc: Set the file's data from the given stream (will read in all of the stream's data).
		returns: True if the data was set from the stream, or False if the stream is Null.
	End Rem
	Method SetDataFromStream:Int(stream:TStream)
		If stream <> Null
			stream.Seek(0)
			m_data = TBank.Create(stream.Size())
			m_data.Read(stream, 0, stream.size())
			Return True
		End If
		Return False
	End Method
	
'#end region (Field accessors)
	
'#region Data handling
	
	Rem
		bbdoc: Serialize the file into the given stream.
		returns: Nothing.
	End Rem
	Method Serialize(stream:TStream)
		Super.Serialize(stream)
		stream.WriteInt(m_data.Size())
		m_data.Write(stream, 0, m_data.Size())
	End Method
	
	Rem
		bbdoc: Deserialize the file from the given stream.
		returns: The deserialized file (itself).
	End Rem
	Method Deserialize:TArchivedFile(stream:TStream)
		Local size:Int
		
		Super.Deserialize(stream)
		size = stream.ReadInt()
		If size > 0
			m_data = TBank.Create(size)
			m_data.Read(stream, 0, size)
		End If
		Return Self
	End Method
	
'#end region (Data handling)
	
'#region Misc
	
	Rem
		bbdoc: Get the file's structure.
		returns: The file's structure.
	End Rem
	Method GetStructure:String(tabs:String = Null)
		Return m_name + "~n"
	End Method
	
'#end region (Misc)
	
End Type
