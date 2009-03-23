
' 
' server.bmx (Contains: TServer, )
' 
' 

Type TServer
	
	Field socket:TSocket
	Field port:Int, accept_timeout:Int
	
	Field msgmap:TMessageMap
	Field clients:TList
	
		Method New()
			
			clients = New TList
			
		End Method
		
		Method _init(_msgmap:TMessageMap, _socket:TSocket, _port:Int, _accept_timeout:Int)
			
			SetMessageMap(_msgmap)
			SetSocket(_socket)
			
			SetPort(_port)
			SetAcceptTimeout(_accept_timeout)
			
		End Method
		
		Rem
			bbdoc: Set the timeout when the Server attempts to accept a Client.
			returns: Nothing.
		End Rem
		Method SetAcceptTimeout(_accept_timeout:Int)
			
			accept_timeout = _accept_timeout
			
		End Method
		
		Rem
			bbdoc: Get the timout (ms) used when the Server attempts to accept a Client.
			returns: The accept timeout for this Server.
		End Rem
		Method GetAcceptTimeout:Int()
			
			Return accept_timeout
			
		End Method
		
		Rem
			bbdoc: Set the Server's port.
			returns: Nothing.
		End Rem
		Method SetPort(_port:Int)
			
			port = _port
			
		End Method
		
		Rem
			bbdoc: Get the Server's port.
			returns: The port for this Server.
		End Rem
		Method GetPort:Int()
			
			Return port
			
		End Method
		
		Rem
			bbdoc: Set the Socket for the Server.
			returns: Nothing.
			about: This will close all existing client connections.
		End Rem
		Method SetSocket(_socket:TSocket)
			
			Close()
			
			socket = _socket
			
		End Method
		
		Rem
			bbdoc: Get the Socker for the Server.
			returns: The Socket for this Server.
		End Rem
		Method GetSocket:TSocket()
			
			Return socket
			
		End Method
		
		Rem
			bbdoc: Set the MessageMap for the Server.
			returns: Nothing.
		End Rem
		Method SetMessageMap(_msgmap:TMessageMap)
			
			msgmap = _msgmap
			
		End Method
		
		Rem
			bbdoc: Get the MessageMap for the Server.
			returns: The MessageMap for this server.
		End Rem
		Method GetMessageMap:TMessageMap()
			
			Return msgmap
			
		End Method
		
		Rem
			bbdoc: Start the server connection.
			returns: True if the socket was able to open on the Server's port, or False if it was unable.
		End Rem
		Method Start:Int()
			
			If socket <> Null
				
				If socket.Bind(port) = True
					
					socket.Listen(0)
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
			Local client:TClient
			
			If socket <> Null
				
				socket.Close()
				
			End If
			
			For client = EachIn clients
				
				DisconnectClient(client)
				
			Next
			
		End Method
		
		Rem
			bbdoc: Check if the Server is open to Clients.
			returns: True if this Server is open to connections, or False if it is not.
		End Rem
		Method Connected:Int()
			
			Return socket.Connected()
			
		End Method
		
		Rem
			bbdoc: Add a Client to the Server.
			returns: True if the Client was added to the Server, or False if it was not.
		End Rem
		Method AddClient:Int(client:TClient)
			
			If client <> Null
				
				If client.Connected() = True
					
					client._link = clients.AddLast(client)
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
		Method DisconnectClient(client:TClient)
			
			OnClientDisconnect(client)
			
			client.Disconnect()
			client._link.Remove()
			
		End Method
		
		Rem
			bbdoc: Handle a new Client (if there are any attempting to connect).
			returns: Nothing.
		End Rem
		Method HandleNewClients:Int()
			Local accept_socket:TSocket, client:TClient, added:Int = False
			
			accept_socket = Socket.Accept(accept_timeout)
			
			If accept_socket <> Null
				
				client = OnSocketAccept(accept_socket)
				added = AddClient(client)
				
			End If
			
			Return added
			
		End Method
		
		Rem
			bbdoc: Check for and handle incoming data from the Clients.
			returns: Nothing.
			about: This calls HandleIncomingData if there is data to be read from a Client.
		End Rem
		Method CheckTransmissions()
			Local client:TClient
			
			For client = EachIn clients
				
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
			Local msg_id:Byte, message:TMessage
			
			While client.ReadAvail() > 0
				msg_id = client.ReadByte()
				
				message = msgmap.GetMessageByID(msg_id)
				
				client.HandleMessage(msg_id, message)
				
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
			bbdoc: Called when a Socket is accepted to the Server (implement in extending types).
			returns: A Client, or Null if the Socket was further unaccepted.
		End Rem
		Method OnSocketAccept:TClient(socket:TSocket) Abstract
		
End Type
































