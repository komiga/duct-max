
' Copyright (c) 2009 Tim Howard
' 
' Permission is hereby granted, free of charge, to any person obtaining a copy
' of this software and associated documentation files (the "Software"), to deal
' in the Software without restriction, including without limitation the rights
' to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
' copies of the Software, and to permit persons to whom the Software is
' furnished to do so, subject to the following conditions:
' 
' The above copyright notice and this permission notice shall be included in
' all copies or substantial portions of the Software.
' 
' THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
' IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
' FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
' AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
' LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
' OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
' THE SOFTWARE.
' 

' 
' tsoundmap.bmx (Contains: TSoundMap, )
' 
'

Rem
	bbdoc: The TSoundMap type.
EndRem
Type TSoundMap Extends TObjectMap
	
	Field pathRoot:String
		
		Rem
			bbdoc: Creates a soundmap.
			returns: The created soundmap.
		End Rem
		Method Create:TSoundMap(_root:String)
			
			SetRootPath(_root)
			
			Return Self
			
		End Method
		
		Rem
			bbdoc: Set the root path.
			returns: Nothing.
			about: Sets the root path for all sounds within the map (used when loading sounds).
		End Rem
		Method SetRootPath(_root:String)
			
			pathRoot = _root
			
			If pathRoot.EndsWith("/") = False And pathRoot.EndsWith("\") = False
				
				pathRoot:+"/"
				
			End If
			
		End Method
		
		Rem
			bbdoc: Get the root path.
			returns: The root path.
			about: Get the root path of the sound map (used with loading sounds).
		End Rem
		Method GetRootPath:String()
			
			Return pathRoot
			
		End Method
		
		Rem
			bbdoc: Load a sound and insert it.
			returns: The loaded sound object, or Null if the sound failed to load.
			about: Loads a sound by the given path (with the root) and inserts it into the map.
		End Rem
		Method LoadAndInsertSound:TSound(path:String, flags:Int = 0)
		  Local sound:TSound
			
			path = _fixpath(path)
			sound = LoadSound(pathRoot + path, flags)
			
			If sound <> Null
				
				InsertSound(path, sound)
				
			End If
			
			Return sound
			
		End Method
		
		Rem
			bbdoc: Inserts a sound into the map.
			returns: Nothing.
			about: @path should be what comes after the root.
			i.e. If root is "sound/" and the path is "ambient/rain.ogg", then the resulting path (when trying to load) will be "sound/ambient/rain.ogg".
		End Rem
		Method InsertSound(path:String, sound:TSound)
			
			path = _fixpath(path)
			
			_Insert(path, sound)
			
		End Method
		
		Rem
			bbdoc: Gets a sound from the map by its path.
			returns: The sound object, or Null if the sound was not found.
			about: @path should be what comes after the root.
			i.e. If root is "sound/" and the path is "ambient/rain.ogg", then the search path will be "sound/ambient/rain.ogg".
		End Rem
		Method GetSoundByPath:TSound(path:String)
			
			path = _fixpath(path)
			
			Return TSound(_ValueByKey(Path))
			
		End Method
		
End Type


Private

Function _fixpath:String(path:String)
	
	If path.StartsWith("/") Or path.StartsWith("\")
		
		Return Path[1..]
		
	Else
		
		Return Path
		
	End If
	
End Function






