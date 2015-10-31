
Rem
Copyright (c) 2010 Coranna Howard <me@komiga.com>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
End Rem

Rem
	bbdoc: duct generic server.
End Rem
Type dServer
	
	Field m_socket:TSocket
	Field m_port:Int, m_accept_timeout:Int
	
	Field m_msgmap:dNetMessageMap
	Field m_clients:TListEx
	
	Method New()
		m_clients = New TListEx
	End Method
	
	Rem
		bbdoc: Initiate the server.
		returns: Nothing.
	End Rem
	Method _init(msgmap:dNetMessageMap, socket:TSocket, port:Int, accept_timeout:Int)
		SetMessageMap(msgmap)
		SetSocket(socket)
		SetPort(port)
		SetAcceptTimeout(accept_timeout)
	End Method
	
'#region Field accessors
	
	Rem
		bbdoc: Set the timeout when the server attempts to accept a client.
		returns: Nothing.
	End Rem
	Method SetAcceptTimeout(accept_timeout:Int)
		m_accept_timeout = accept_timeout
	End Method
	
	Rem
		bbdoc: Get the timout (ms) used when the server attempts to accept a client.
		returns: The accept timeout for this server.
	End Rem
	Method GetAcceptTimeout:Int()
		Return m_accept_timeout
	End Method
	
	Rem
		bbdoc: Set the server's port.
		returns: Nothing.
	End Rem
	Method SetPort(port:Int)
		m_port = port
	End Method
	
	Rem
		bbdoc: Get the server's port.
		returns: The port for this server.
	End Rem
	Method GetPort:Int()
		Return m_port
	End Method
	
	Rem
		bbdoc: Set the socket for the server.
		returns: Nothing.
		about: This will close all existing client connections.
	End Rem
	Method SetSocket(socket:TSocket)
		Close()
		m_socket = socket
	End Method
	
	Rem
		bbdoc: Get the Socket for the server.
		returns: The socket for this server.
	End Rem
	Method GetSocket:TSocket()
		Return m_socket
	End Method
	
	Rem
		bbdoc: Set the message map for the server.
		returns: Nothing.
	End Rem
	Method SetMessageMap(msgmap:dNetMessageMap)
		m_msgmap = msgmap
	End Method
	
	Rem
		bbdoc: Get the message map for the server.
		returns: The message map for the server.
	End Rem
	Method GetMessageMap:dNetMessageMap()
		Return m_msgmap
	End Method
	
'#end region Field accessors
	
'#region Connection
	
	Rem
		bbdoc: Start the server connection.
		returns: True if the socket was able to open on the server's port, or False if it was unable.
	End Rem
	Method Start:Int()
		If m_socket <> Null
			If m_socket.Bind(m_port) = True
				m_socket.Listen(0)
				Return True
			End If
		End If
		Return False
	End Method
	
	Rem
		bbdoc: Close the server and clear the client list.
		returns: Nothing.
		about: If @ondisconnect is True, OnClientDisconnect will be called for each client that is dropped.
	End Rem
	Method Close(ondisconnect:Int = True)
		For Local client:dClient = EachIn m_clients
			DisconnectClient(client, ondisconnect)
		Next
		If m_socket
			m_socket.Close()
		End If
	End Method
	
	Rem
		bbdoc: Check if the server is open to Clients.
		returns: True if this server is open to connections, or False if it is not.
	End Rem
	Method Connected:Int()
		Return m_socket.Connected()
	End Method
	
'#end region (Connection)
	
	Rem
		bbdoc: Add a client to the server.
		returns: True if the client was added to the server, or False if it was not.
	End Rem
	Method AddClient:Int(client:dClient)
		If client
			If client.Connected()
				client.m_link = m_clients.AddLast(client)
				OnClientAdd(client)
				Return True
			End If
		End If
		Return False
	End Method
	
	Rem
		bbdoc: Disconnect a client from the server.
		returns: Nothing.
		about: If @ondisconnect is True, OnClientDisconnect will be called for each client that is dropped.
	End Rem
	Method DisconnectClient(client:dClient, ondisconnect:Int = True)
		If ondisconnect
			OnClientDisconnect(client)
		End If
		client.Disconnect()
		client.m_link.Remove()
	End Method
	
	Rem
		bbdoc: Handle a new client (if there are any attempting to connect).
		returns: Nothing.
	End Rem
	Method HandleNewClients:Int()
		Local acceptsocket:TSocket = m_socket.Accept(m_accept_timeout)
		If acceptsocket
			Local client:dClient = OnSocketAccept(acceptsocket)
			Return AddClient(client)
		End If
		Return False
	End Method
	
	Rem
		bbdoc: Check for and handle incoming data from the Clients.
		returns: Nothing.
		about: This calls HandleIncomingData if there is data to be read from a client.
	End Rem
	Method CheckTransmissions()
		For Local client:dClient = EachIn m_clients
			If Not client.Eof()
				If client.ReadAvail() > 0
					HandleIncomingData(client)
				End If
			Else
				DisconnectClient(client)
			End If
		Next
	End Method
	
	Rem
		bbdoc: Handle incoming data from a client.
		returns: Nothing.
	End Rem
	Method HandleIncomingData(client:dClient)
		Local msgid:Int, message:dNetMessage
		While client.ReadAvail() > 0
			msgid = Int(client.ReadByte())
			message = m_msgmap.GetMessageWithID(msgid)
			client.HandleMessage(msgid, message)
		Wend
	End Method
	
	Rem
		bbdoc: Called when a client is added to the server (implement in extending types).
		returns: Nothing.
	End Rem
	Method OnClientAdd(client:dClient) Abstract
	
	Rem
		bbdoc: Called when a client is disconnected from the server (implement in extending types).
		returns: Nothing.
	End Rem
	Method OnClientDisconnect(client:dClient) Abstract
	
	Rem
		bbdoc: Called when a socket is accepted to the server (implement in extending types).
		returns: A client, or Null if the socket was further unaccepted.
	End Rem
	Method OnSocketAccept:dClient(socket:TSocket) Abstract
	
End Type

