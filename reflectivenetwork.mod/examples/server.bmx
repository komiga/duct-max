
' Test TCP sockets (locally). Remember to compile in console mode to see messages.

SuperStrict

Framework brl.blitz
Import brl.standardio
Import brl.glmax2d

Import duct.intmap
Import duct.graphix
Import duct.vector
Import duct.reflectivenetwork

Include "src/base.bmx"
Include "src/masterserver.bmx"

Global mainapp:ServerApp
ServerApp(New ServerApp.Create())
mainapp.Run()

Rem
	bbdoc: Server application.
End Rem
Type ServerApp Extends dGraphicsApp
	
	Field m_msgmap:dReflNetMessageMap = New dReflNetMessageMap.Create()
	Field m_server:TMasterServer
	
	Field m_posmessage:TPositionMessage {create insert}
	
	Rem
		bbdoc: This method is called when the app is initialized.
		returns: Nothing.
	End Rem
	Method OnInit()
		mainapp = Self
		AppTitle = "Server"
		m_server = New TMasterServer.Create(TSocket.CreateTCP(), 30249, 1)
		m_server.Start()
		If m_server.Connected() = False
			Print("Server on port " + m_server.GetPort() + " could not be created")
			Shutdown()
		End If
		Print("Server created on port 30249")
		m_msgmap.InitializeFields(Self)
		m_msgmap.InitializeFields(m_server)
		m_msgmap.AttachHandlers(TTypeId.ForName("TServerPlayer"))
		
		SetGraphicsDriver(GLMax2DDriver())
		Graphics(320, 240, 0)
	End Method
	
	Rem
		bbdoc: This method is called when the app is shutdown.
		returns: Nothing.
	End Rem
	Method OnExit()
		EndGraphics()
		If m_server <> Null
			m_server.Close()
			m_server = Null
		End If
		End
	End Method
	
	Rem
		bbdoc: Run the application.
		returns: Nothing.
	End Rem
	Method Run()
		While KeyHit(KEY_ESCAPE) = False And AppTerminate() = False
			Cls()
			Update()
			Render()
			Flip()
		Wend
		Shutdown()
	End Method
	
	Rem
		bbdoc: Render the players.
		returns: Nothing.
	End Rem
	Method Render()
		m_server.RenderPlayers()
	End Method
	
	Rem
		bbdoc: Update the application.
		returns: Nothing.
	End Rem
	Method Update()
		m_server.HandleNewClients()
		m_server.CheckTransmissions()
		m_server.UpdatePlayers()
	End Method
	
End Type

