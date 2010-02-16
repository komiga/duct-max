
Rem
	Copyright (c) 2009 Tim Howard
	
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
	-----------------------------------------------------------------------------
	
	server.bmx (Contains: TServer, )
	
End Rem

Rem
	bbdoc: duct generic server type.
End Rem
Type TServer
	
	Field m_socket:TSocket
	Field m_port:Int, m_accept_timeout:Int
	
	Field m_msgmap:TNetMessageMap
	Field m_clients:TListEx
	
	Method New()
		m_clients = New TListEx
	End Method
	
	Method _init(msgmap:TNetMessageMap, socket:TSocket, port:Int, accept_timeout:Int)
		SeTNetMessageMap(msgmap)
		SetSocket(socket)
		SetPort(port)
		SetAcceptTimeout(accept_timeout)
	End Method
	
'#region Field accessors
	
	Rem
		bbdoc: Set the timeout when the Server attempts to accept a Client.
		returns: Nothing.
	End Rem
	Method SetAcceptTimeout(accept_timeout:Int)
		m_accept_timeout = accept_timeout
	End Method
	
	Rem
		bbdoc: Get the timout (ms) used when the Server attempts to accept a Client.
		returns: The accept timeout for this Server.
	End Rem
	Method GetAcceptTimeout:Int()
		Return m_accept_timeout
	End Method
	
	Rem
		bbdoc: Set the Server's port.
		returns: Nothing.
	End Rem
	Method SetPort(port:Int)
		m_port = port
	End Method
	
	Rem
		bbdoc: Get the Server's port.
		returns: The port for this Server.
	End Rem
	Method GetPort:Int()
		Return m_port
	End Method
	
	Rem
		bbdoc: Set the m_socket for the Server.
		returns: Nothing.
		about: This will close all existing client connections.
	End Rem
	Method SetSocket(socket:TSocket)
		Close()
		m_socket = socket
	End Method
	
	Rem
		bbdoc: Get the Socker for the Server.
		returns: The m_socket for this Server.
	End Rem
	Method GetSocket:TSocket()
		Return m_socket
	End Method
	
	Rem
		bbdoc: Set the MessageMap for the Server.
		returns: Nothing.
	End Rem
	Method SeTNetMessageMap(msgmap:TNetMessageMap)
		m_msgmap = msgmap
	End Method
	
	Rem
		bbdoc: Get the MessageMap for the Server.
		returns: The MessageMap for this server.
	End Rem
	Method GeTNetMessageMap:TNetMessageMap()
		Return m_msgmap
	End Method
	
'#end region (Field accessors)
	
'#region Connection
	
	Rem
		bbdoc: Start the server connection.
		returns: True if the m_socket was able to open on the Server's port, or False if it was unable.
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
		bbdoc: Close the Server and clear the Client list.
		returns: Nothing.
	End Rem
	Method Close()
		If m_socket <> Null
			m_socket.Close()
		End If
		For Local client:TClient = EachIn m_clients
			DisconnectClient(client)
		Next
	End Method
	
	Rem
		bbdoc: Check if the Server is open to Clients.
		returns: True if this Server is open to connections, or False if it is not.
	End Rem
	Method Connected:Int()
		Return m_socket.Connected()
	End Method
	
'#end region (Connection)
	
	Rem
		bbdoc: Add a Client to the Server.
		returns: True if the Client was added to the Server, or False if it was not.
	End Rem
	Method AddClient:Int(client:TClient)
		If client <> Null
			If client.Connected() = True
				client.m_link = m_clients.AddLast(client)
				OnClientAdd(client)
				Return True
			End If
		End If
		Return False
	End Method
	
	Rem
		bbdoc: Disconnect a Client from the Server.
		returns: Nothing.
	End Rem
	Method DisconnectClient(client:TClient, ondisconnect:Int = True)
		If ondisconnect = True
			OnClientDisconnect(client)
		End If
		
		client.Disconnect()
		client.m_link.Remove()
	End Method
	
	Rem
		bbdoc: Handle a new Client (if there are any attempting to connect).
		returns: Nothing.
	End Rem
	Method HandleNewClients:Int()
		Local acceptsocket:TSocket, client:TClient
		
		acceptsocket = m_socket.Accept(m_accept_timeout)
		If acceptsocket <> Null
			client = OnSocketAccept(acceptsocket)
			Return AddClient(client)
		End If
		Return False
	End Method
	
	Rem
		bbdoc: Check for and handle incoming data from the Clients.
		returns: Nothing.
		about: This calls HandleIncomingData if there is data to be read from a Client.
	End Rem
	Method CheckTransmissions()
		For Local client:TClient = EachIn m_clients
			If client.Eof() = False
				If client.ReadAvail() > 0
					HandleIncomingData(client)
				End If
			Else
				DisconnectClient(client)
			End If
		Next
	End Method
	
	Rem
		bbdoc: Handle incoming data from a Client.
		returns: Nothing.
	End Rem
	Method HandleIncomingData(client:TClient)
		Local msgid:Int, message:TNetMessage
		
		While client.ReadAvail() > 0
			msgid = Int(client.ReadByte())
			message = m_msgmap.GetMessageByID(msgid)
			client.HandleMessage(msgid, message)
		Wend
	End Method
	
	Rem
		bbdoc: Called when a Client is added to the Server (implement in extending types).
		returns: Nothing.
	End Rem
	Method OnClientAdd(client:TClient) Abstract
	
	Rem
		bbdoc: Called when a Client is disconnected from the Server (implement in extending types).
		returns: Nothing.
	End Rem
	Method OnClientDisconnect(client:TClient) Abstract
	
	Rem
		bbdoc: Called when a m_socket is accepted to the Server (implement in extending types).
		returns: A Client, or Null if the m_socket was further unaccepted.
	End Rem
	Method OnSocketAccept:TClient(m_socket:TSocket) Abstract
	
End Type

