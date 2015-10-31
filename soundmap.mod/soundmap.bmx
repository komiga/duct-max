
Rem
Copyright (c) 2010 Coranna Howard <me@komiga.com>

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
End Rem

SuperStrict

Rem
bbdoc: Soundmap module
End Rem
Module duct.soundmap

ModuleInfo "Version: 0.08"
ModuleInfo "Copyright: Coranna Howard <me@komiga.com>"
ModuleInfo "License: MIT"

ModuleInfo "History: Version 0.08"
ModuleInfo "History: General cleanup"
ModuleInfo "History: Updated for duct.objectmap changes"
ModuleInfo "History: Version 0.07"
ModuleInfo "History: Fixed documentation, license, examples"
ModuleInfo "History: Renamed TSoundMap to dSoundMap"
ModuleInfo "History: Updated for API change"
ModuleInfo "History: Version 0.06"
ModuleInfo "History: General cleanup"
ModuleInfo "History: Version 0.05"
ModuleInfo "History: Changed formatting"
ModuleInfo "History: Version 0.04"
ModuleInfo "History: General code cleanup (removed include setup, changed license header)"
ModuleInfo "History: Version 0.03"
ModuleInfo "History: Modified: TTemplate now supports multiple identifier names"
ModuleInfo "History: Version 0.02"
ModuleInfo "History: Initial release"

Import brl.audio
Import duct.objectmap

Rem
	bbdoc: duct soundmap.
	about: Provides a simple pathing system for sounds.
EndRem
Type dSoundMap Extends dObjectMap
	
	Field m_rootpath:String
	
	Rem
		bbdoc: Create a new sound map.
		returns: Itself.
	End Rem
	Method Create:dSoundMap(rootpath:String)
		SetRootPath(rootpath)
		Return Self
	End Method
	
'#region Field accessors
	
	Rem
		bbdoc: Set the root path for the map.
		returns: Nothing.
	End Rem
	Method SetRootPath(rootpath:String)
		m_rootpath = rootpath
		If Not m_rootpath.EndsWith("/") And Not m_rootpath.EndsWith("\")
			m_rootpath:+ "/"
		End If
	End Method
	
	Rem
		bbdoc: Get the map's root path.
		returns: The root path for the map.
	End Rem
	Method GetRootPath:String()
		Return m_rootpath
	End Method
	
'#end region Field accessors
	
'#region Collections
	
	Rem
		bbdoc: Load a sound and insert it.
		returns: The loaded sound object, or Null if the sound failed to load.
		about: The load path is based on the root path.
	End Rem
	Method LoadAndInsertSound:TSound(path:String, flags:Int = 0)
		path = _fixpath(path)
		Local sound:TSound = LoadSound(m_rootpath + path, flags)
		If InsertSound(path, sound) = True
			Return sound
		End If
		Return Null
	End Method
	
	Rem
		bbdoc: Insert a sound into the map.
		returns: True if the sound was added, or False if it was not (either @path or @sound are Null).
		about: @path should be what comes after the root path.<br>
		i.e. If the root path is "sound/" and the path is "ambient/rain.ogg", then the resulting path (when trying to load) will be "sound/ambient/rain.ogg".
	End Rem
	Method InsertSound:Int(path:String, sound:TSound)
		path = _fixpath(path)
		If sound And path
			InsertSound(path, sound)
			Return True
		End If
		Return False
	End Method
	
	Rem
		bbdoc: Get a sound from the map by its path.
		returns: A sound from the path, or Null if the sound was not found.
		about: @path should be what comes after the root.
		i.e. If root is "sound/" and the path is "ambient/rain.ogg", then the search path will be "sound/ambient/rain.ogg".
	End Rem
	Method GetSoundByPath:TSound(path:String)
		path = _fixpath(path)
		Return TSound(_ObjectWithKey(path))
	End Method
	
'#end region Collections
	
End Type

Private

Function _fixpath:String(path:String)
	If path.StartsWith("/") Or path.StartsWith("\")
		Return path[1..]
	Else
		Return path
	End If
End Function

