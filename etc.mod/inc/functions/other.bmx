
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
	
	other.bmx (Contains: WriteFileExplicitly, CreateFileExplicitly, CopyFileExplicitly, TimeByFormat, )
	
End Rem

Rem
	bbdoc: Open a stream with write permissions to the given path.
	returns: A stream for the given path, or Null if the stream could not be created.
	about: This function will create the path to the file if it does not exist.
End Rem
Function WriteFileExplicitly:TStream(url:String)
	Local stream:TStream, dir:String
	
	dir = ExtractDir(url)
	If FileType(dir) = FILETYPE_NONE
		CreateDir(dir, True)
	End If
	
	stream = WriteFile(url)
	
	Return stream
	
End Function

Rem
	bbdoc: Create the file at the given path.
	returns: Nothing.
End Rem
Function CreateFileExplicitly(url:String)
	Local dir:String
	
	dir = ExtractDir(url)
	If FileType(dir) = FILETYPE_NONE
		CreateDir(dir, True)
	End If
	
	CreateFile(url)
	
End Function

Rem
	bbdoc: Copy a file to the full destination path.
	returns: True if the file was copied, or False if it was not (because either @from, or @_to - after copying - do not exist).
End Rem
Function CopyFileExplicitly:Int(from:String, _to:String)
	Local dir:String
	
	' CopyFile does not call FixPath for some reason (but pretty much all other file functions do..)
	FixPath(from)
	FixPath(_to)
	
	dir = ExtractDir(_to)
	If FileType(dir) = FILETYPE_NONE
		CreateDir(dir, True)
	End If
	
	CopyFile(from, _to)
	
	If FileType(_to) = FILETYPE_FILE
		
		Return True
		
	End If
	
	Return False
	
End Function

Rem
	bbdoc: Get the time with the given format.
	returns: The time with the given format.
End Rem
Function TimeInFormat:String(format:String)
	Local time:Int[256], buff:Byte[256]
	
	time_(time)
	strftime_(buff, 256, format, localtime_(time))
	
	Return String.FromCString(buff)
	
End Function

Rem
	bbdoc: Get the FileTime of the given file in the given format.
	returns: The formatted filetime, or Null if the given file does not exist (this may be a mistake if you also accidently passed @format as Null).
End Rem
Function FileTimeWithFormat:String(path:String, format:String)
	Local time:Int Ptr, buff:Byte[256], ftime:Int
	
	If format <> Null And path <> Null And FileType(path) = FILETYPE_FILE
		
		ftime = FileTime(path)
		time = Varptr(ftime)
		strftime_(buff, 256, format, localtime_(time))
		
		Return String.FromCString(buff)
		
	End If
	
	Return Null
	
End Function

Rem
	bbdoc: Fix the endings for the path given.
	returns: Nothing.
	about: This will change "\" to "/" (at the end of the path), and will add "/" if no slash is at the end of the path given.<br />
	If @remove_slash is True then any slash at the end of the path will be removed.
End Rem
Function FixPathEnding:String(path:String, remove_slash:Int = False)
	Local lastchar:Int = path.Length - 1
	
	Repeat
		If path[lastchar] = 92 Or path[lastchar] = 47
			
			path = path[..lastchar]
			
			lastchar = path.Length - 1
			
		Else
			
			Exit
				
		End If
		
	Forever
	
	If remove_slash = False
		
		' "\" = 92; "/" = 47
		If path[lastchar] = 92
			
			Return path[..lastchar] + "/"
			
		Else If path[lastchar] <> 47
			
			Return path + "/"
			
		End If
		
	End If
	
	Return path
	
End Function






































