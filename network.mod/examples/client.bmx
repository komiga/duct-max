
' Test TCP sockets (locally). Remember to compile in console mode to see messages.

SuperStrict

Framework brl.blitz
Import brl.standardio
Import brl.glmax2d

Import duct.vector
Import duct.network

Include "inc/types/base.bmx"
Include "inc/types/masterclient.bmx"

AppTitle = "Client"

Local master:TMasterClient = New TMasterClient.Create(TSocket.CreateTCP())
Local ip:String = "localhost"

If master.Connect(HostIp(ip), 30249) = False
	Input("Unable to connect to server! (press enter to continue)")
	End
End If

Print("Connected!")
SetGraphicsDriver(GLMax2DDriver())
Graphics(320, 240, 0)

While KeyHit(KEY_ESCAPE) = False And AppTerminate() = False
	Cls()
	If master.Connected() = False
		EndGraphics()
		Input("Disconnected from server! (press enter to continue)")
		Exit
	End If
	master.CheckTransmissions()
	master.SetPosition(Float(MouseX()), Float(MouseY()))
	master.DrawPlayers()
	Flip()
Wend

