
' 
' client.bmx (Contains: TClient, )
' 
' 

Type TClient Extends TStream
	
	Field _link:TLink
	Field socket:TSocket, sip:Int
	
		Method New()
		End Method
		
		Method _init(_socket:TSocket)
			
			socket = _socket
			If socket <> Null
				
				sip = socket.RemoteIp()
				
			End If
			
		End Method
		
		Method Read:Int(buf:Byte Ptr, count:Int)
			
			Return socket.Recv(buf, count)
			
		End Method
		
		Method Write:Int(buf:Byte Ptr, count:Int)
			
			Return socket.Send(buf, count)
			
		End Method
		
		Rem
			bbdoc: Get The number of bytes available in the buffer for the Client.
			returns: The number of bytes still in the buffer for this Client.
		End Rem
		Method ReadAvail:Int()
			
			Return socket.ReadAvail()
			
		End Method
		
		Rem
			bbdoc: Check if the Client has stopped communications.
			returns: True if this Client is no longer connected, or False if it is still connected.
			about: Almost the same as simply calling #Connected, but this will automatically close the socket if it is not connected.
		End Rem
		Method Eof:Int()
			
			If socket <> Null
				
				If socket.Connected() = True
					
					Return False
					
				End If
				
			End If
			
			Close()
			Return True
			
		End Method
		
		Rem
			bbdoc: Close the connection to the Client (same as calling #Disconnect).
			returns: Nothing.
		End Rem
		Method Close()
			
			If socket <> Null
				
				socket.Close()
				socket = Null
				
			End If
			
		End Method
		
		Rem
			bbdoc: Connect the Client to an address and port.
			returns: True if this Client was connected to the given parameters, or False if it failed to connect.
			about: This is for Client applications only.
		End Rem
		Method Connect:Int(_remoteip:Int, _remoteport:Int)
			
			Return socket.Connect(_remoteip, _remoteport)
			
		End Method
		
		Rem
			bbdoc: Check if the Client is connected.
			returns: True if this Client is connected, or False if it is not.
		End Rem
		Method Connected:Int()
			Local conn:Int = False
			
			If socket <> Null
				
				conn = socket.Connected()
				
			End If
			
			Return conn
			
		End Method
		
		Rem
			bbdoc: Disconnect the Client.
			returns: Nothing.
		End Rem
		Method Disconnect()
			
			Close()
			
		End Method
		
		Rem
			bbdoc: Get the IP address of the Client as an integer.
			returns: The IP address of this Client.
		End Rem
		Method GetIPAddressAsInt:Int()
			
			Return sip
			
		End Method
		
		Rem
			bbdoc: Get the IP address of the Client as a string, separated by @_separator.
			returns: The IP address of this Client.
		End Rem
		Method GetIPAddressAsString:String(_separator:String = ".")
			Local ip:Int
			
			ip = GetIPAddressAsInt()
			
			Return (ip Shr 24) + _separator + (ip Shr 16 & 255) + _separator + (ip Shr 8 & 255) + _separator + (ip & 255)
			
		End Method
		
		Rem
			bbdoc: Handle a Message sent to the Client.
			returns: Nothing.
			about: Implement this method in an extending type.
		End Rem
		Method HandleMessage(msg_id:Byte, message:TMessage) Abstract
		
End Type






























