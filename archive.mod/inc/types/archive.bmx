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

Private
Const sig_arch_header:String = "arc"
Const sig_file_header:Int = $deaddead
Const sig_info_sector:Int = $baadf00d
Const sig_file_info:Int = $fee1dead
Const sig_info_sector_pos:Int = $deadbeef
Const sig_secretstring:String = "9a0f6405c0f5ac94a2e62f575bd113be"

Rem
Type _TSeekPos
	Field m_seekpos:Int
	Field m_file:TArchivedFile
	Method Create:_TSeekPos(seekpos:Int, file:TArchivedFile)
		m_seekpos = seekpos
		m_file = file
		Return Self
	End Method
End Type
End Rem

Type _TArchive
	Field m_name:String, m_compressionlevel:Int, m_encrypted:Int, m_filecount:Int
	Field m_secretstring:String, m_secretstring2:String
	Field m_infosectorpos:Int, m_infosectorpos2:Int
	Field m_list:TListEx = New TListEx.Create()
	Method Read:_TArchive(stream:TStream, key:String, _print(message:String) = DebugLog)
		' arch_header chunk
		If stream.ReadString(sig_arch_header.Length) = sig_arch_header
			m_name = stream.ReadString(stream.ReadShort())
			m_filecount = stream.ReadInt()
			m_compressionlevel = Int(stream.ReadByte())
			m_encrypted = Int(stream.ReadByte())
			If m_encrypted = True
				m_secretstring = stream.ReadString(sig_secretstring.Length)
				If key <> Null
					m_secretstring2 = RC4(m_secretstring, key)
				Else
					m_secretstring2 = m_secretstring
					_print("(TArchive.InspectArchive) Archive is encrypted, but there no key was given to test encryption!")
				End If
			End If
			
			' file_header chunks
			Local file:_TFile
			For Local i:Int = 0 Until m_filecount
				file = New _TFile.ReadHeader(stream)
				If file <> Null
					m_list.AddLast(file)
				Else
					Return Null
				End If
			Next
			
			' info_sector chunk
			m_infosectorpos = stream.Pos()
			If stream.ReadInt() <> sig_info_sector
				_print("(TArchive.InspectArchive) Bad info_sector signature! (at" + String(stream.Pos() - 4) + ")")
				Return Null
			End If
			
			' file_info chunks
			For file = EachIn m_list
				If file.ReadInfo(stream) = Null
					Return Null
				End If
			Next
			
			' info_sector_pos chunk
			If stream.ReadInt() <> sig_info_sector_pos
				 _print("(TArchive.InspectArchive) Bad info_sector_pos signature! (at" + String(stream.Pos() - 4) + ")")
				 Return Null
			End If
			m_infosectorpos2 = stream.ReadInt()
			
			Return Self
		Else
			_print("(TArchive.InspectArchive) Bad arch_header signature! (at" + String(stream.Pos() - 4) + ")")
			Return Null
		End If
	End Method
	Method Report:String(_print(message:String))
		_print("Archive: name=" + m_name + ", compressionlevel=" + m_compressionlevel + ", encrypted=" + m_encrypted)
		_print("~tfilecount=" + m_filecount + ", secretstring=" + m_secretstring + ", secretstring2=" + m_secretstring2)
		If m_secretstring <> m_secretstring2
			_print("~tsig_secretstring=" + sig_secretstring + "; == " + String(m_secretstring2 = sig_secretstring))
		End If
		_print("~tinfosectorpos=" + m_infosectorpos + ", m_infosectorpos2=" + m_infosectorpos + "; == " + String(m_infosectorpos = m_infosectorpos2))
		
		_print("Files (" + m_filecount + ")...")
		For Local file:_TFile = EachIn m_list
			_print(file.Report())
		Next
	End Method
End Type

Type _TFile
	Field m_name:String, m_flags:Int
	Field m_datasize:Int, m_data:TBank
	Field m_compressedsize:Int, m_uncompressedsize:Int
	Field m_seekpos:Int, m_seekpos2:Int
	Method ReadHeader:_TFile(stream:TStream, _print(message:String) = DebugLog)
		m_seekpos2 = stream.Pos()
		If stream.ReadInt() = sig_file_header
			m_datasize = stream.ReadInt()
			If m_datasize > 0
				stream.Seek(stream.Pos() + m_datasize)
			End If
			Return Self
		Else
			_print("(TArchive.InspectArchive) Bad file_header signature! (at" + String(stream.Pos() - 4) + ")")
			Return Null
		End If
	End Method
	Method ReadInfo:_TFile(stream:TStream, _print(message:String) = DebugLog)
		If stream.ReadInt() = sig_file_info
			m_name = stream.ReadString(stream.ReadShort())
			m_flags = stream.ReadInt()
			m_compressedsize = stream.ReadInt()
			m_uncompressedsize = stream.ReadInt()
			m_seekpos = stream.ReadInt()
			Return Self
		Else
			_print("(TArchive.InspectArchive) Bad file_info signature! (at" + String(stream.Pos() - 4) + ")")
			Return Null
		End If
	End Method
	Method Report:String()
		Local rp:String
		
		rp = "File: name=" + m_name + ", flags=" + m_flags + "~n~t"
		rp:+"seekpos=" + m_seekpos + ", seekpos2=" + m_seekpos2 + "; == " + String(m_seekpos = m_seekpos2) + "~n~t"
		rp:+"datasize=" + m_datasize + ", compressedsize=" + m_compressedsize + ", uncompressedsize=" + m_uncompressedsize
		Return rp
	End Method
End Type

Public

Rem
	bbdoc: The Archive type (stores files and folder structures, with encryption).
End Rem
Type TArchive
	
	Field m_name:String, m_compressionlevel:Int, m_encrypted:Int
	Field m_secretstring:String, m_infosectorpos:Int, m_filecount:Int
	Field m_children:TObjectMap
	
	Field m_activefile:String
	
	Method New()
		m_children = New TObjectMap
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
		AddPhysicalFolder(path, recursive)
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
		bbdoc: Set the archive's compression level.
		returns: Nothing.
		about: If you set the compression level to zero, no compression will be performed.
	End Rem
	Method SetCompressionLevel(compressionlevel:Int)
		m_compressionlevel = compressionlevel
	End Method
	
	Rem
		bbdoc: Get the archive's compression level.
		returns: The archive's compression level.
	End Rem
	Method GetCompressionLevel:Int()
		Return m_compressionlevel
	End Method
	
	Rem
		bbdoc: Set encryption on or off for the archive.
		returns: Nothing.
		about: If set to True, you will be required to give an encryption key when you attempt to save the archive.
	End Rem
	Method SetEncrypted(encrypted:Int)
		m_encrypted = encrypted
	End Method
	
	Rem
		bbdoc: Get the encryption state.
		returns: Nothing.
	End Rem
	Method GetEncrypted:Int()
		Return m_encrypted
	End Method
	
	Rem
		bbdoc: Set the active file (path for writing/reading the archive).
		returns: Nothing.
	End Rem
	Method SetActiveFile(activefile:String)
		m_activefile = activefile
	End Method
	
	Rem
		bbdoc: Get the active write/read path for the archive.
		returns: The active file for the archive.
	End Rem
	Method GetActiveFile:String()
		Return m_activefile
	End Method
	
'#end region (Field accessors)
	
'#region Collections
	
	Rem
		bbdoc: Get the number of files in the archive.
		returns: The number of files in the archive.
	End Rem
	Method GetFileCount:Int()
		Return m_children.Count()
	End Method
	
	Rem
		bbdoc: Check if the archive contains a file with the given name.
		returns: True if there is a file with the given name, or False if there is no file with the given name.
	End Rem
	Method ContainsFileWithName:Int(name:String)
		If name <> Null
			Return m_children._Contains(name)
		End If
		Return False
	End Method
	
	Rem
		bbdoc: Check if the archive contains the given file.
		returns: True if the file is in the archive, or False if either the file is not in the archive or the given file is Null.
	End Rem
	Method ContainsFile:Int(file:TArchivedFile)
		If file <> Null
			Return m_children._Contains(file.GetName())
		End If
		Return False
	End Method
	
	Rem
		bbdoc: Get the file with the given name.
		returns: The file with the given name, or Null if either the name was not found or the name is Null.
		about: The file's data will automatically be read from the active file (if it has not yet been read).
		If the archive is encrypted, you must supply the @key.
		An exception will be thrown if you do not supply the key when encryption is on.
	End Rem
	Method GetFileWithName:TArchivedFile(name:String, key:String = Null)
		Local file:TArchivedFile = TArchivedFile(m_children._ValueByKey(name))
		
		_ReadUnreadFileData(file, key)
		Return file
	End Method
	
	Rem
		bbdoc: Add the given file to the archive.
		returns: True if the file was added, or False if it was not (either the file's name conflicts with another file name or the file is Null).
	End Rem
	Method AddFile:Int(file:TArchivedFile)
		If ContainsFile(file) = False
			m_children._Insert(file.GetName(), file)
			file._SetParent(Self)
			Return True
		End If
		Return False
	End Method
	
	Rem
		bbdoc: Add the given on-disk file to the archive.
		returns: The loaded file, or Null if the file was not added (either the file's name conflicts with another file name or the given name/path is Null).
	End Rem
	Method AddPhysicalFile:TArchivedFile(name:String, path:String)
		Local file:TArchivedFile
		
		If ContainsFileWithName(name) = False
			file = New TArchivedFile.CreateFromFile(name, path)
			If AddFile(file) = True
				Return file
			End If
		End If
		Return Null
	End Method
	
	Rem
		bbdoc: Add the files(s) from the given folder to the archive.
		returns: True if the files were added, or False if the path could not be read.
	End Rem
	Method AddPhysicalFolder:Int(path:String, recursive:Int = True)
		Return _AddPath(path, Null, recursive)
	End Method
	
	Method _AddPath(origin:String, path:String, recursive:Int = True)
		Local dirhandle:Int, file:String, currdir:String
		
		origin = FixPathEnding(origin, False)
		currdir = origin + path
		FixPath(currdir)
		currdir = FixPathEnding(currdir, True)
		'DebugLog("currdir: " + currdir + ", " + FileType(currdir) + "; path: " + path)
		If FileType(currdir) = FILETYPE_DIR
			dirhandle = ReadDir(currdir)
			Repeat
				file = NextFile(dirhandle)
				If file = "" Then Exit
				If file <> "." And file <> ".."
					Select FileType(currdir + "/" + file)
						Case FILETYPE_FILE
							AddPhysicalFile(path + file, currdir + "/" + file)
						Case FILETYPE_DIR
							If recursive = True
								_AddPath(origin, path + file + "/", True)
							End If
					End Select
				End If
			Forever
			CloseDir(dirhandle)
		End If
	End Method
	
	Rem
		bbdoc: Remove the file with the given name.
		returns: True if the file was removed, or False if it was not (either the given name is Null or it was not found in the archive).
	End Rem
	Method RemoveFileWithName:Int(name:String)
		If ContainsFileWithName(name) = True
			m_children._Remove(name)
			Return True
		End If
		Return False
	End Method
	
	Rem
		bbdoc: Remove the given file.
		returns: True if the file was removed, or False if it was not (either the given file is Null or it was not found in the archive).
	End Rem
	Method RemoveFile:Int(file:TArchivedFile)
		If ContainsFile(file) = True
			m_children._Remove(file.GetName())
			Return True
		End If
		Return False
	End Method
	
'#end region (Collections)
	
'#region Data handling
	
	Rem
		bbdoc: Write the archive to the hdd.
		returns: True if the archive was written, or False if the path could not be written to.
		about: If @path is Null the active file will be used for serialization (see #SetActiveFile), if it is not Null, the active file will be set to @path.
		@key is only needed if encryption is turned on for the archive.
		An exception will be thrown if you do not supply the key when encryption is on.
	End Rem
	Method WriteToFile:Int(path:String = Null, key:String = Null)
		Local stream:TStream', seekpositions:TListEx
		
		If m_encrypted = True And key = Null
			Throw("(TArchive.WriteToFile) Missing encryption key!")
		End If
		
		If path <> Null Then SetActiveFile(path)
		
		_ReadAllUnreadFileData(key)
		stream = WriteStream(m_activefile)
		If stream <> Null
			' arch_header
			stream.WriteString(sig_arch_header)
			stream.WriteShort(Short(m_name.Length))
			stream.WriteString(m_name)
			stream.WriteInt(m_children.Count())
			stream.WriteByte(Byte(m_compressionlevel))
			stream.WriteByte(Byte(m_encrypted))
			If m_encrypted = True
				stream.WriteString(RC4(sig_secretstring, key))
			End If
			
			' file_header chunks
			'seekpositions = New TListEx.Create()
			For Local file:TArchivedFile = EachIn m_children.ValueEnumerator()
				 'seekpositions.AddLast(New _TSeekPos.Create(stream.Pos(), file))
				 file.SerializeData(stream, key, m_compressionlevel)
			Next
			
			' info_sector chunk, followed by file_info chunks
			m_infosectorpos = stream.Pos()
			stream.WriteInt(sig_info_sector)
			'For Local seekpos:_TSeekPos = EachIn seekpositions
			'	seekpos.m_file.SerializeInfo(stream, seekpos.m_seekpos)
			'Next
			For Local file:TArchivedFile = EachIn m_children.ValueEnumerator()
				file.SerializeInfo(stream)
			Next
			
			' info_sector_pos chunk
			stream.WriteInt(sig_info_sector_pos)
			stream.WriteInt(m_infosectorpos)
			stream.Close()
			
			Return True
		End If
		Return False
	End Method
	
	Rem
		bbdoc: Load an archive from the given file.
		returns: The loaded archive (itself), or Null if the file could not be read.
		about: If @path is Null the active file will be used (see #SetActiveFile), if it is not Null, the active file will be set to @path.
		An exception will be thrown if the data is corrupt.
	End Rem
	Method LoadFromFile:TArchive(path:String = Null)
		Local stream:TStream
		
		If path <> Null Then SetActiveFile(path)
		stream = ReadStream(m_activefile)
		If stream <> Null
			Deserialize(stream)
			Return Self
		End If
		Return Null
	End Method
	
	Rem
		bbdoc: Export all the archive's files to the given path.
		returns: True if the path could be written to, or False if it could not be written to.
		about: An exception will be thrown if you do not supply the key when encryption is on.
	End Rem
	Method ExportFiles:Int(path:String, key:String = Null)
		Local file:TArchivedFile
		
		path = FixPathEnding(path, False)
		If CreateDir(path, True) = True
			_ReadAllUnreadFileData(key)
			For file = EachIn m_children.ValueEnumerator()
				file.Export(path + file.GetName())
			Next
			Return True
		End If
		Return False
	End Method
	
	Rem
		bbdoc: Deserialize the Archive from the given stream.
		returns: The deserialized archive (itself).
		about: An exception will be thrown if the data is corrupt.
	End Rem
	Method Deserialize:TArchive(stream:TStream)
		' arch_header chunk
		If stream.ReadString(sig_arch_header.Length) = sig_arch_header
			SetName(stream.ReadString(stream.ReadShort()))
			m_filecount = stream.ReadInt()
			SetCompressionLevel(Int(stream.ReadByte()))
			SetEncrypted(Int(stream.ReadByte()))
			If m_encrypted = True
				m_secretstring = stream.ReadString(sig_secretstring.Length)
			End If
			
			' info_sector_pos chunk (seeks to the end of the stream, skipping the file_header blocks)
			stream.Seek(stream.Size() - 8)
			If stream.ReadInt() <> sig_info_sector_pos
				 Throw("(TArchive.Deserialize) Bad info_sector_pos signature!")
			End If
			m_infosectorpos = stream.ReadInt()
			
			' info_sector chunk, followed by file_info chunks
			stream.Seek(m_infosectorpos)
			If stream.ReadInt() <> sig_info_sector
				Throw("(TArchive.Deserialize) Bad info_sector signature!")
			End If
			
			For Local i:Int = 0 To m_filecount - 1
				AddFile(New TArchivedFile.DeserializeInfo(stream))
			Next
			Return Self
		Else
			Throw("(TArchive.Deserialize) Bad arch_header signature!")
		End If
	End Method
	
	Rem
		bbdoc: Inspect the given archive.
		returns: True if the file was verified, or False if either the file could not be read or the data was corrupt.
	End Rem
	Function InspectArchive:Int(path:String, key:String = Null, _print(message:String) = DebugLog)
		Local stream:TStream, archive:_TArchive
		
		stream = ReadStream(path)
		If stream <> Null
			archive = New _TArchive.Read(stream, key, _print)
			stream.Close()
			If archive <> Null
				archive.Report(_print)
				Return True
			Else
				_print("(TArchive.InspectArchive) Failed to inspect archive ~q" + path + "~q")
				Return False
			End If
		Else
			Return False
		End If
	End Function
	
'#end region (Data handling)
	
'#region Misc
	
	Rem
		bbdoc: Test the given decryption key on the archive.
		returns: True if the decryption key is correct for the archive.
	End Rem
	Method TestDecryption:Int(key:String)
		Local st:String
		
		If m_encrypted = True And m_secretstring <> Null
			st = RC4(m_secretstring, key)
			If st = sig_secretstring
				 Return True
			End If
		End If
		Return False
	End Method
	
	Rem
		bbdoc: Read all the unread file data from the archive (used when writing the archive back to the hdd).
		returns: Nothing.
		about: This should not be used outside of TArchive.
		An exception will be thrown if you do not supply the key when encryption is on.
	End Rem
	Method _ReadAllUnreadFileData(key:String)
		Local stream:TStream, file:TArchivedFile
		
		stream = ReadStream(m_activefile)
		If stream <> Null
			For file = EachIn m_children.ValueEnumerator()
				_ReadUnreadFileData(file, key)
			Next
			stream.Close()
		End If
	End Method
	
	Rem
		bbdoc: Read the unread file data from the archive.
		returns: Nothing.
		about: This should not be used outside of TArchive.
		An exception will be thrown if you do not supply the key when encryption is on.
		An exception will be thrown if decryption fails.
	End Rem
	Method _ReadUnreadFileData(file:TArchivedFile, key:String)
		Local stream:TStream
		
		If file <> Null
			If file.m_data = Null
				If m_encrypted = True
					If key <> Null
						If TestDecryption(key) = False
							Throw("(TArchive._ReadUnreadFileData) Decryption failed!")
						End If
					Else
						Throw("(TArchive._ReadUnreadFileData) Missing encryption key!")
					End If
				End If
				stream = ReadStream(m_activefile)
				If stream <> Null
					file.DeserializeData(stream, key, True)
					stream.Close()
				Else
					DebugLog("(TArchive._ReadUnreadFileData) Failed to open active file (~q" + m_activefile + "~q)")
				End If
			End If
		End If
	End Method
	
'#end region (Misc)
	
End Type

Rem
	bbdoc: The TArchivedFile type.
End Rem
Type TArchivedFile
	
	Field m_name:String, m_flags:Int
	Field m_datasize:Int, m_data:TBank
	Field m_compressedsize:Int, m_uncompressedsize:Int
	Field m_seekpos:Int
	
	Field m_parent:TArchive
	
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
	Method CreateFromFile:TArchivedFile(name:String, path:String)
		If path <> Null
			SetName(name)
			If SetDataFromFile(path) = True
				Return Self
			End If
		End If
		Return Null
	End Method
	
'#region Field accessors
	
	Rem
		bbdoc: Set the file's name.
		returns: Nothing.
		about: An assert will be thrown if the given name is Null.
	End Rem
	Method SetName(name:String)
		FixPath(name, False)
		If name[0] = 47 Or name[0] = 92 Then name = name[1..]
		Assert name <> Null, "(TArchivedFile.SetName) Name cannot be Null!"
		m_name = name
	End Method
	
	Rem
		bbdoc: Get the file's name.
		returns: The file's name.
	End Rem
	Method GetName:String()
		Return m_name
	End Method
	
	Rem
		bbdoc: Set the file's flags.
		returns: Nothing.
	End Rem
	Method SetFlags(flags:Int)
		m_flags = flags
	End Method
	
	Rem
		bbdoc: Get the file's flags.
		returns: The file's flags.
	End Rem
	Method GetFlags:Int()
		Return m_flags
	End Method
	
	Rem
		bbdoc: Set the file's data.
		returns: Nothing.
		about: Warning: Previous data will be lost!
	End Rem
	Method SetData(data:TBank)
		m_data = data
		If m_data <> Null
			m_datasize = m_data.Size()
		End If
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
		
		stream = ReadFile(path)
		If stream <> Null
			result = SetDataFromStream(stream)
			stream.Close()
		End If
		Return result
	End Method
	
	Rem
		bbdoc: Set the file's data from the given stream (will read in all of the stream's data).
		returns: True if the data was set from the stream, or False if the stream is Null.
		about: NOTE: This will seek the stream to 0.
	End Rem
	Method SetDataFromStream:Int(stream:TStream)
		If stream <> Null
			stream.Seek(0)
			m_datasize = stream.Size()
			m_data = TBank.Create(m_datasize)
			m_data.Read(stream, 0, m_datasize)
			Return True
		End If
		Return False
	End Method
	
	Rem
		bbdoc: Set the file's parent archive.
		returns: Nothing.
		about: This should not be used outside of TArchive.
	End Rem
	Method _SetParent(parent:TArchive)
		If m_parent <> Null And m_parent <> parent
			m_parent.RemoveFile(Self)
		End If
		m_parent = parent
	End Method
	
	Rem
		bbdoc: Get the file's parent archive.
		returns: The file's parent.
	End Rem
	Method GetParent:TArchive()
		Return m_parent
	End Method
	
'#end region (Field accessors)
	
'#region Data handling
	
	Rem
		bbdoc: Export the archived file to the given path.
		returns: True if successful, or False if either @file is Null or the path could not be written to.
	End Rem
	Method Export:Int(path:String)
		Local stream:TStream
		
		If CreateFileExplicitly(path) = True
			If m_datasize > 0 And m_data <> Null
				m_data.Save(path)
			End If
			Return True
		End If
		Return False
	End Method
	
	Rem
		bbdoc: Serialize the file data into the given stream.
		returns: Nothing.
		about: This should not be used outside of TArchive.
	End Rem
	Method SerializeData(stream:TStream, key:String, compressionlevel:Int)
		Local destbank:TBank, destlen:Int
		
		If m_parent.GetEncrypted() = True And key = Null
			Throw("(TArchivedFile.SerializeData) Missing encryption key!")
		End If
		
		m_seekpos = stream.Pos()
		m_uncompressedsize = m_datasize
		
		' file_header chunk
		stream.WriteInt(sig_file_header)
		If m_data <> Null And m_datasize > 0
			destlen = m_datasize
			If compressionlevel > 0 And m_datasize > 368
				'destlen = Ceil(m_datasize * 1.001) + 12
				destlen:*1.001 + 13
				destbank = TBank.Create(destlen)
				
				LzmaCompress2(destbank.Buf(), destlen, m_data.Buf(), m_datasize, compressionlevel)
				DebugLog("(TArchivedFile.SerializeData) datasize=" + m_datasize + ", destlen=" + destlen)
				destbank.Resize(destlen)
				m_compressedsize = destlen
			Else
				destbank = TBank.Create(destlen)
				CopyBank(m_data, 0, destbank, 0, destlen)
				m_compressedsize = m_uncompressedsize
			End If
			If m_parent.GetEncrypted() = True And key = Null
				RC4_Bytes(destbank.Buf(), destlen, key)
			End If
			stream.WriteInt(destlen)
			destbank.Write(stream, 0, destlen)
		Else
			m_compressedsize = m_uncompressedsize
			stream.WriteInt(0)
		End If
	End Method
	
	Rem
		bbdoc: Serialize the file info into the given stream.
		returns: Nothing.
		about: This should not be used outside of TArchive.
	End Rem
	Method SerializeInfo(stream:TStream)
		' file_info chunk
		stream.WriteInt(sig_file_info)
		stream.WriteShort(Short(m_name.Length))
		stream.WriteString(m_name)
		stream.WriteInt(m_flags)
		stream.WriteInt(m_compressedsize)
		stream.WriteInt(m_uncompressedsize)
		stream.WriteInt(m_seekpos)
	End Method
	
	Rem
		bbdoc: Deserialize the file data from the given stream.
		returns: Nothing.
		about: If archive encryption is on and no key has been supplied, an exception will be thrown.
	End Rem
	Method DeserializeData(stream:TStream, key:String, seek:Int = True)
		Local destbank:TBank, tempbank:TBank
		
		If m_parent.GetEncrypted() = True And key = Null
			Throw("(TArchivedFile.DeserializeData) Missing encryption key!")
		End If
		
		' file_header chunk
		If seek = True Then stream.seek(m_seekpos)
		If stream.ReadInt() = sig_file_header
			m_datasize = stream.ReadInt()
			If m_datasize > 0
				tempbank = TBank.Create(m_datasize)
				tempbank.Read(stream, 0, m_datasize)
				If m_parent.GetEncrypted() = True And key = Null
					RC4_Bytes(tempbank.Buf(), m_datasize, key)
				End If
				If m_compressedsize = m_uncompressedsize
					SetData(tempbank)
				Else
					Local uncompressedsize:Int = m_uncompressedsize
					
					destbank = TBank.Create(uncompressedsize)
					LzmaUncompress(destbank.Buf(), uncompressedsize, tempbank.Buf(), m_compressedsize)
					If uncompressedsize = m_uncompressedsize
						SetData(destbank)
					Else
						DebugLog("(TArchivedFile.DeserializeData) Failed to verify data! name=" + m_name)
						DebugLog("(TArchivedFile.DeserializeData) uncompressedsize=" + uncompressedsize + ", m_uncompressedsize=" + m_uncompressedsize + ", m_compressedsize=" + m_compressedsize)
					End If
				End If
			Else
				SetData(TBank.Create(0))
			End If
		Else
			Throw("(TArchivedFile.DeserializeData) Bad file_header signature!")
		End If
	End Method
	
	Rem
		bbdoc: Deserialize the file info from the given stream.
		returns: The deserialized file (itself).
		about: An exception will be thrown if the chunk is corrupt.
	End Rem
	Method DeserializeInfo:TArchivedFile(stream:TStream)
		' file_info chunk
		If stream.ReadInt() = sig_file_info
			SetName(stream.ReadString(stream.ReadShort()))
			SetFlags(stream.ReadInt())
			m_compressedsize = stream.ReadInt()
			m_uncompressedsize = stream.ReadInt()
			m_seekpos = stream.ReadInt()
			Return Self
		Else
			Throw("(TArchivedFile.DeserializeInfo) Bad file_info signature!")
		End If
	End Method
	
'#end region (Data handling)
	
End Type
