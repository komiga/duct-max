
' 
' server.bmx
' Tests TCP sockets (locally). Remember to compile in console mode to see messages.
' 

SuperStrict

Framework brl.blitz
Import brl.standardio

Import brl.glmax2d

Import duct.vector
Import duct.network

Include "inc/types/base.bmx"
Include "inc/types/masterserver.bmx"

AppTitle = "Server"

Local Server:TMasterServer = New TMasterServer.Create(TSocket.CreateTCP(), 30249, 1)

Server.Start()
If Server.Connected() = False
	Print("Server on port " + Server.GetPort() + " could not be created")
	End
End If

Print("Server created on port 30249")

SetGraphicsDriver(GLMax2DDriver())
Graphics(320, 240, 0)

While KeyHit(KEY_ESCAPE) = False And AppTerminate() = False
	
	Cls()
	
	Server.HandleNewClients()
	Server.CheckTransmissions()
	
	Server.UpdatePlayers()
	Server.DrawPlayers()
	
	Flip()
	
Wend

Server.Close()
















