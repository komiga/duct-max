
SuperStrict

Rem
bbdoc: Appendable streams
End Rem
Module duct.appendstream

ModuleInfo "Version: 1.1"
ModuleInfo "Author: Bruce A Henderson"
ModuleInfo "License: Public Domain"
ModuleInfo "Copyright: Bruce A Henderson"

ModuleInfo "History: Version 1.1"
ModuleInfo "History: General cleanup"
ModuleInfo "History: Version 1.0"
ModuleInfo "History: Copied from http://www.blitzbasic.com/Community/posts.php?topic=83691#944177"

Import brl.stream

Type TAppendableCStream Extends TCStream
	
	Function OpenFile:TCStream(path:String, readable:Int, writeable:Int)
		Local mode:String, _mode:Int
		
		If readable And writeable
			mode = "a+b"
			_mode = MODE_READ | MODE_WRITE
		Else If writeable
			mode = "ab"
			_mode = MODE_WRITE
		Else
			mode = "rb"
			_mode = MODE_READ
		EndIf
		path = path.Replace("\", "/")
		Local cstream:Int = fopen_(path, mode)
		?Linux
		If (Not cstream) And (Not writeable)
			path = CasedFileName(path)
			If path cstream = fopen_(path, mode)
		End If
		?
		If cstream <> Null
			Return CreateWithCStream(cstream, _mode)
		End If
	End Function
	
End Type

Type TAppendableCStreamFactory Extends TStreamFactory
	
	Method CreateStream:TStream(url:Object, proto:String, path:String, readable:Int, writeable:Int)
		If proto = "append"
			Return TAppendableCStream.OpenFile(path, readable, writeable)
		End If
	End Method
	
End Type

New TAppendableCStreamFactory

