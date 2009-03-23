
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
' tinputconv.bmx (Contains: TInputConv, )
' 
' 

Rem
	bbdoc: The TInputConv type.
	about: Interface for converting string identifiers to key/mouse codes.
EndRem
Type TInputConv
	
	Rem
		bbdoc: Convert a string into a mouse code.
		returns: A mousecode, or 0 if the string is not a valid mouse code.
	End Rem
	Function StringToMouseCode:Int(miden:String)
		
		Select miden.ToLower()
			Case "mouse1", "mouser", "mouseright" Return MOUSE_RIGHT
			Case "mouse2", "mousel", "mouseleft" Return MOUSE_LEFT
			Case "mouse3", "mwheel", "mousem", "mousemiddle" Return MOUSE_MIDDLE
		End Select
		
		Return 0
		
	End Function
	
	Rem
		bbdoc: Convert a mouse code to a string.
		returns: A string for the given mouse code, or Null if the mouse code was not recognized.
	End Rem
	Function MouseCodeToString:String(mousecode:Int)
		
		Select mousecode
			Case MOUSE_RIGHT Return "mouseright"
			Case MOUSE_LEFT Return "mouseleft"
			Case MOUSE_MIDDLE Return "mousemiddle"
		End Select
		
		Return Null
		
	End Function
	
	Rem
		bbdoc: Convert a string into a keycode.
		returns: A keycode, or 0 if the string is not a valid key code.
	End Rem
	Function StringToKeyCode:Int(kiden:String)
		
		Select kiden.ToLower()
			
			'Function keys
			Case "f1" Return KEY_F1
			Case "f2" Return KEY_F2
			Case "f3" Return KEY_F3
			Case "f4" Return KEY_F4
			Case "f5" Return KEY_F5
			Case "f6" Return KEY_F6
			Case "f7" Return KEY_F7
			Case "f8" Return KEY_F8
			Case "f9" Return KEY_F9
			Case "f10" Return KEY_F10
			Case "f11" Return KEY_F11
			Case "f12" Return KEY_F12
			
			'Alphabet keys
			Case "q" Return KEY_Q
			Case "w" Return KEY_W
			Case "e" Return KEY_E
			Case "r" Return KEY_R
			Case "t" Return KEY_T
			Case "y" Return KEY_Y
			Case "u" Return KEY_U
			Case "i" Return KEY_I
			Case "o" Return KEY_O
			Case "p" Return KEY_P
			Case "a" Return KEY_A
			Case "s" Return KEY_S
			Case "d" Return KEY_D
			Case "f" Return KEY_F
			Case "g" Return KEY_G
			Case "h" Return KEY_H
			Case "j" Return KEY_J
			Case "k" Return KEY_K
			Case "l" Return KEY_L
			Case "z" Return KEY_Z
			Case "x" Return KEY_X
			Case "c" Return KEY_C
			Case "v" Return KEY_V
			Case "b" Return KEY_B
			Case "n" Return KEY_N
			Case "m" Return KEY_M
			
			'Numbers and non-alphabet keys
			Case "tilde", "~~" Return KEY_TILDE
			Case "one", "1" Return KEY_1
			Case "two", "2" Return KEY_2
			Case "three", "3" Return KEY_3
			Case "four", "4" Return KEY_4
			Case "five", "5" Return KEY_5
			Case "six", "6" Return KEY_6
			Case "seven", "7" Return KEY_7
			Case "eight", "8" Return KEY_8
			Case "nine", "9" Return KEY_9
			Case "zero", "0" Return KEY_0
			Case "minus", "-", "underscore", "_" Return KEY_MINUS
			Case "plus", "+", "equals", "=" Return KEY_EQUALS
			Case "[", "{" Return KEY_OPENBRACKET
			Case "]", "}" Return KEY_CLOSEBRACKET
			Case ";", ":" Return KEY_SEMICOLON
			Case "quotes", "quote", "'", "~q" Return KEY_QUOTES			'Is 'quotes' even logical?
			Case "period", ".", ">" Return KEY_PERIOD
			Case "comma", ",", "<" Return KEY_COMMA
			Case "backslash", "\", "|" Return KEY_BACKSLASH
			Case "forwardslash", "/", "?" Return KEY_SLASH
			Case "space" Return KEY_SPACE
			Case "print", "printscrn" Return KEY_PRINT
			Case "home" Return KEY_HOME
			Case "end" Return KEY_END
			Case "pagedown", "pgdn" Return KEY_PAGEUP
			Case "pageup", "pgup" Return KEY_PAGEDOWN
			Case "insert" Return KEY_INSERT
			Case "delete", "del" Return KEY_DELETE
			Case "pause" Return 19									'KEY_PAUSE (why is this commented out, from brl.keycodes?)
			Case "scrlock", "scrllock", "scrolllock" Return 145	'KEY_SCROLL (sigh..)
			
			'Num keys
			Case "numlock" Return 144								'KEY_NUMLOCK (....)
			Case "num0" Return KEY_NUM0
			Case "num1" Return KEY_NUM1
			Case "num2" Return KEY_NUM2
			Case "num3" Return KEY_NUM3
			Case "num4" Return KEY_NUM4
			Case "num5" Return KEY_NUM5
			Case "num6" Return KEY_NUM6
			Case "num7" Return KEY_NUM7
			Case "num8" Return KEY_NUM8
			Case "num9" Return KEY_NUM9
			Case "num*", "nummultiply", "numasterisk" Return KEY_NUMMULTIPLY
			Case "num/", "numdivide", "numslash" Return KEY_NUMDIVIDE
			Case "num+", "numadd", "numplus" Return KEY_NUMADD
			Case "num-", "numsubtract", "numminus" Return KEY_NUMSUBTRACT
			Case "num.", "numdel", "numdecimal" Return KEY_NUMDECIMAL
			'Case "numreturn" Return key_num
			
			'Arrow keys
			Case "up" Return KEY_UP
			Case "down" Return KEY_DOWN
			Case "left" Return KEY_LEFT
			Case "right" Return KEY_RIGHT
			
			'Modifiers
			Case "backspace" Return KEY_BACKSPACE
			Case "tab" Return KEY_TAB
			Case "capslock", "caps" Return 20 'KEY_CAPSLOCK (again, why is this commented out?)
			Case "control", "ctrl" Return MODIFIER_CONTROL
			Case "lcontrol", "lctrl" Return KEY_LCONTROL
			Case "rcontrol", "rctrl" Return KEY_RCONTROL
			Case "shift" Return MODIFIER_SHIFT
			Case "lshift" Return KEY_LSHIFT
			Case "rshift" Return KEY_RSHIFT
			Case "alt" Return MODIFIER_ALT
			Case "lalt" Return KEY_LALT
			Case "ralt" Return KEY_RALT
			
			'Other
			Case "escape", "esc" Return KEY_ESCAPE
			
		End Select
		
		Return 0
		
	End Function
	
	Rem
		bbdoc: Convert a keycode to a string.
		returns: A string for the given keycode, or Null if the keycode was not recognized.
	EndRem
	Function KeyCodeToString:String(keycode:Int)
		
		Select keycode
			
			'Function keys
			Case KEY_F1 Return "f1"
			Case KEY_F2 Return "f2"
			Case KEY_F3 Return "f3"
			Case KEY_F4 Return "f4"
			Case KEY_F5 Return "f5"
			Case KEY_F6 Return "f6"
			Case KEY_F7 Return "f7"
			Case KEY_F8 Return "f8"
			Case KEY_F9 Return "f9"
			Case KEY_F10 Return "f10"
			Case KEY_F11 Return "f11"
			Case KEY_F12 Return "f12"
			
			'Alphabet keys
			Case KEY_Q Return "q"
			Case KEY_W Return "w"
			Case KEY_E Return "e"
			Case KEY_R Return "r"
			Case KEY_T Return "t"
			Case KEY_Y Return "y"
			Case KEY_U Return "u"
			Case KEY_I Return "i"
			Case KEY_O Return "o"
			Case KEY_P Return "p"
			Case KEY_A Return "a"
			Case KEY_S Return "s"
			Case KEY_D Return "d"
			Case KEY_F Return "f"
			Case KEY_G Return "g"
			Case KEY_H Return "h"
			Case KEY_J Return "j"
			Case KEY_K Return "k"
			Case KEY_L Return "l"
			Case KEY_Z Return "z"
			Case KEY_X Return "x"
			Case KEY_C Return "c"
			Case KEY_V Return "v"
			Case KEY_B Return "b"
			Case KEY_N Return "n"
			Case KEY_M Return "m"
			
			'Numbers and non-alphabet keys
			Case KEY_TILDE Return "tilde"
			Case KEY_1 Return "one"
			Case KEY_2 Return "two"
			Case KEY_3 Return "three"
			Case KEY_4 Return "four"
			Case KEY_5 Return "five"
			Case KEY_6 Return "six"
			Case KEY_7 Return "seven"
			Case KEY_8 Return "eight"
			Case KEY_9 Return "nine"
			Case KEY_0 Return "zero"
			Case KEY_MINUS Return "minus"
			Case KEY_EQUALS Return "equals"
			Case KEY_OPENBRACKET Return "["
			Case KEY_CLOSEBRACKET Return "]"
			Case KEY_SEMICOLON Return ";"
			Case KEY_QUOTES Return "~q"
			Case KEY_PERIOD Return "period"
			Case KEY_COMMA Return "comma"
			Case KEY_BACKSLASH Return "backslash"
			Case KEY_SLASH Return "forwardslash"
			Case KEY_SPACE Return "space"
			Case KEY_PRINT Return "printscrn"
			Case KEY_HOME Return "home"
			Case KEY_END Return "end"
			Case KEY_PAGEUP Return "pgup"
			Case KEY_PAGEDOWN Return "pgdn"
			Case KEY_INSERT Return "insert"
			Case KEY_DELETE Return "delete"
			Case 19 Return "pause"
			Case 145 Return "scrllock"
			
			'Num keys
			Case 144 Return "numlock"
			Case KEY_NUM0 Return "num0"
			Case KEY_NUM1 Return "num1"
			Case KEY_NUM2 Return "num2"
			Case KEY_NUM3 Return "num3"
			Case KEY_NUM4 Return "num4"
			Case KEY_NUM5 Return "num5"
			Case KEY_NUM6 Return "num6"
			Case KEY_NUM7 Return "num7"
			Case KEY_NUM8 Return "num8"
			Case KEY_NUM9 Return "num9"
			Case KEY_NUMMULTIPLY Return "num*"
			Case KEY_NUMDIVIDE Return "num/"
			Case KEY_NUMADD Return "num+"
			Case KEY_NUMSUBTRACT Return "num-"
			Case KEY_NUMDECIMAL Return "num."
			'Case "numreturn" Return key_num
			
			'Arrow keys
			Case KEY_UP Return "up"
			Case KEY_DOWN Return "down"
			Case KEY_LEFT Return "left"
			Case KEY_RIGHT Return "right"
			
			'Modifiers
			Case KEY_BACKSPACE Return "backspace"
			Case KEY_TAB Return "tab"
			Case 20 Return "capslock"
			Case MODIFIER_CONTROL Return "ctrl"
			Case KEY_LCONTROL Return "lctrl"
			Case KEY_RCONTROL Return "rctrl"
			Case MODIFIER_SHIFT Return "shift"
			Case KEY_LSHIFT Return "lshift"
			Case KEY_RSHIFT Return "rshift"
			Case MODIFIER_ALT Return "alt"
			Case KEY_LALT Return "lalt"
			Case KEY_RALT Return "ralt"
			
			'Other
			Case KEY_ESCAPE Return "escape"
			
		End Select
		
		Return Null
		
	End Function
	
End Type

























