
' Soundmap test

SuperStrict

Framework brl.blitz
Import brl.standardio
Import brl.system

'Import BaH.fmod
'Import BaH.fmodaudio
Import brl.freeaudioaudio
Import brl.OGGLoader

Import duct.soundmap

'SetAudioDriver("FMOD")

Local sound_path:String = "int01.ogg", sound:TSound

' This will create our main sound map
' NOTE: The engine will make sure there is a slash at the end of the root path
Global map_sounds:dSoundMap = New dSoundMap.Create("sound/")

If map_sounds.LoadAndInsertSound(sound_path) = Null ' Null=Failure
	Print("Failed to load sound (" + map_sounds.GetRootPath() + sound_path + ")")
	End
End If

' This is the path AFTER the root path (which is 'sound/')
sound = map_sounds.GetSoundByPath(sound_path)
If sound = Null
	Print("Failed to grab sound")
	End
End If

Local chn_Sound:TChannel = CueSound(sound)
ResumeChannel(chn_Sound)
Repeat
	PollSystem()
	Delay(30)
Until chn_Sound.Playing() = False

