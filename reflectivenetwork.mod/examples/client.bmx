
' Test TCP sockets (locally). Remember to compile in console mode to see messages.

SuperStrict

Framework brl.blitz
Import brl.standardio
Import brl.glmax2d

Import duct.graphix
Import duct.vector
Import duct.reflectivenetwork

Include "inc/base.bmx"
Include "inc/masterclient.bmx"

Global mainapp:TClientApp = TClientApp(New TClientApp.Create())
mainapp.Run()

Rem
	bbdoc: Client application.
End Rem
Type TClientApp Extends dGraphicsApp
	
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
		If m_client.Connect(HostIp("localhost"), 30249) = False
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
		If m_client <> Null
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
		m_client.DrawPlayers()
	End Method
	
	Rem
		bbdoc: Update the application.
		returns: Nothing.
	End Rem
	Method Update()
		If m_client.Connected() = False
			Print("Disconnected from server!")
			Shutdown()
		End If
		m_client.CheckTransmissions()
		m_client.SetPosition(Float(MouseX()), Float(MouseY()))
	End Method
	
End Type

