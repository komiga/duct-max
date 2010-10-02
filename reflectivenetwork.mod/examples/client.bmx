
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
Include "src/masterclient.bmx"

Global mainapp:ClientApp = ClientApp(New ClientApp.Create())
mainapp.Run()

Rem
	bbdoc: Client application.
End Rem
Type ClientApp Extends dGraphicsApp
	
	Field m_msgmap:dReflNetMessageMap = New dReflNetMessageMap.Create()
	Field m_client:TMasterClient
	
	Rem
		bbdoc: This method is called when the app is initialized.
		returns: Nothing.
	End Rem
	Method OnInit()
		AppTitle = "Client"
		m_client = New TMasterClient.Create(TSocket.CreateTCP())
		m_msgmap.Initialize(m_client)
		If Not m_client.Connect(HostIp("localhost"), 30249)
			Print("Unable to connect to server!")
			Shutdown()
		End If
		Print("Connected!")
		SetGraphicsDriver(GLMax2DDriver())
		Graphics(320, 240, 0)
	End Method
	
	Rem
		bbdoc: This method is called when the app is shutdown.
		returns: Nothing.
	End Rem
	Method OnExit()
		EndGraphics()
		If m_client
			m_client.Close()
			m_client = Null
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
		m_client.RenderPlayers()
	End Method
	
	Rem
		bbdoc: Update the application.
		returns: Nothing.
	End Rem
	Method Update()
		If Not m_client.Connected()
			Print("Disconnected from server!")
			Shutdown()
		End If
		m_client.CheckTransmissions()
		m_client.SetPosition(Float(MouseX()), Float(MouseY()))
	End Method
	
End Type

