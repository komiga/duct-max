
' 
' client.bmx
' Tests TCP sockets (locally). Remember to compile in console mode to see messages.
' 

SuperStrict

Framework brl.blitz
Import brl.standardio

Import brl.glmax2d

Import duct.vector
Import duct.network

Include "inc/types/base.bmx"
Include "inc/types/masterclient.bmx"

AppTitle = "Client"

Local Master:TMasterClient = New TMasterClient.Create(TSocket.CreateTCP())
Local ip:String = "localhost"

If Master.Connect(HostIp(ip), 30249) = False
	
	Input("Unable to connect to server! (press enter to continue)")
	End
	
End If

Print("Connected!")

SetGraphicsDriver(GLMax2DDriver())
Graphics(320, 240, 0)

While KeyHit(KEY_ESCAPE) = False And AppTerminate() = False
	
	Cls()
	
	If Master.Connected() = False
		
		EndGraphics()
		Input("Disconnected from server! (press enter to continue)")
		Exit
		
	End If
	
	Master.CheckTransmissions()
	Master.SetPosition(Float(MouseX()), Float(MouseY()))
	
	Master.DrawPlayers()
	
	Flip()
	
Wend
























