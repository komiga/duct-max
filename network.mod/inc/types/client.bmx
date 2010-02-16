
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
	
	client.bmx (Contains: TClient, )
	
End Rem

Rem
	bbdoc: duct generic client.
End Rem
Type TClient Extends TStream
	
	Field m_link:TLink
	Field m_socket:TSocket, m_sip:Int
	
	Method New()
	End Method
	
	Method _init(socket:TSocket)
		m_socket = socket
		If m_socket <> Null
			m_sip = m_socket.RemoteIp()
		End If
	End Method
	
'#region Data handling
	
	Method Read:Int(buf:Byte Ptr, count:Int)
		Return m_socket.Recv(buf, count)
	End Method
	
	Method Write:Int(buf:Byte Ptr, count:Int)
		Return m_socket.Send(buf, count)
	End Method
	
	Rem
		bbdoc: Get The number of bytes available in the buffer for the Client.
		returns: The number of bytes still in the buffer for this Client.
	End Rem
	Method ReadAvail:Int()
		Return m_socket.ReadAvail()
	End Method
	
	Rem
		bbdoc: Check if the Client has stopped communications.
		returns: True if this Client is no longer connected, or False if it is still connected.
		about: Almost the same as simply calling #Connected, but this will automatically close the m_socket if it is not connected.
	End Rem
	Method Eof:Int()
		If m_socket <> Null
			If m_socket.Connected() = True
				Return False
			End If
		End If
		Close()
		Return True
	End Method
	
'#end region (Data handling)
	
'#region Connection
	
	Rem
		bbdoc: Close the connection to the Client (same as calling #Disconnect).
		returns: Nothing.
	End Rem
	Method Close()
		If m_socket <> Null
			m_socket.Close()
			m_socket = Null
		End If
	End Method
	
	Rem
		bbdoc: Connect the Client to an address and port.
		returns: True if this Client was connected to the given parameters, or False if it failed to connect.
		about: This is for Client applications only.
	End Rem
	Method Connect:Int(remoteip:Int, remoteport:Int)
		Return m_socket.Connect(remoteip, remoteport)
	End Method
	
	Rem
		bbdoc: Check if the Client is connected.
		returns: True if this Client is connected, or False if it is not.
	End Rem
	Method Connected:Int()
		Local conn:Int = False
		
		If m_socket <> Null
			conn = m_socket.Connected()
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
	
'#end region (Connection)
	
	Rem
		bbdoc: Get the IP address of the Client as an integer.
		returns: The IP address of this Client.
	End Rem
	Method GetIPAddressAsInt:Int()
		Return m_sip
	End Method
	
	Rem
		bbdoc: Get the IP address of the Client as a string, separated by @separator.
		returns: The IP address of this Client.
	End Rem
	Method GetIPAddressAsString:String(separator:String = ".")
		Return (m_sip Shr 24) + separator + (m_sip Shr 16 & 255) + separator + (m_sip Shr 8 & 255) + separator + (m_sip & 255)
	End Method
	
	Rem
		bbdoc: Handle a Message sent to the Client.
		returns: Nothing.
		about: Implement this method in an extending type.
	End Rem
	Method HandleMessage(msg_id:Int, message:TNetMessage) Abstract
	
End Type

