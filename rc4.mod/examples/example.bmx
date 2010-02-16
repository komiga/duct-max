
' RC4 encryption example

SuperStrict

Framework brl.blitz
Import brl.standardio

Import duct.rc4

Local Key:String = "924690thryJ%&K3wjymtuk,356wjaww4QE%Yw4rj6ey7kmj46*L%&(;l*Y(7t"
Local Message:String = "0 1 1 2 3 5 8 13 21 34 55"

Message = RC4(Message, Key)
Print("Encrypted: ~q" + Message + "~q")
Print("Decrypted: ~q" + RC4(Message, Key) + "~q")

