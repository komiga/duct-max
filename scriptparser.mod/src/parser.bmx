
Rem
Copyright (c) 2010 Tim Howard

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

Private

' Characters
Const CHAR_EOF:Int = -1				' Special EOF character
Const CHAR_NEWLINE:Int = 10			' \n
Const CHAR_CARRIAGERETURN:Int = 13	' \r

Const CHAR_DECIMALPOINT:Int = 46	' .

Const CHAR_QUOTE:Int = 34			' "
Const CHAR_SINGLEQUOTE:Int = 39		' '

Const CHAR_OPENBRACE:Int = 123		' {
Const CHAR_CLOSEBRACE:Int = 125		' }
Const CHAR_EQUALSIGN:Int = 61		' =

' Token types
Const NoToken:Int = 0

Const StringToken:Int = 1
Const QuotedStringToken:Int = 2
Const NumberToken:Int = 3
Const DigitToken:Int = 4

Const EqualsToken:Int = 5

Const OpenBraceToken:Int = 6
Const CloseBraceToken:Int = 7

Const CommentToken:Int = 8
Const EOFToken:Int = 9
Const EOLToken:Int = 10

Public

Rem
	bbdoc: #dScriptParser token.
End Rem
Type dScriptToken
	Const BUFFERINITIAL_SIZE:Int = 48
	Const BUFFER_MULTIPLIER:Double = 1.75:Double
	
	Field m_type:Int = NoToken
	Field m_beg_line:Int, m_beg_col:Int
	
	Field m_buffer:Short Ptr = Null, m_bufsize:Int = 0, m_buflength:Int = 0
	Field m_bufstring:String = Null
	
	Method Delete() NoDebug
		If m_buffer
			MemFree(m_buffer)
		End If
	End Method
	
	Rem
		bbdoc: Create a dScriptToken.
		returns: Itself.
	End Rem
	Method Create:dScriptToken(toktype:Int)
		m_type = toktype
		Return Self
	End Method
	
	Rem
		bbdoc: Add a character to the token.
		returns: Nothing.
	End Rem
	Method AddChar(char:Int)
		If Not m_buffer
			m_bufsize = BUFFERINITIAL_SIZE
			m_buffer = Short Ptr(MemAlloc(m_bufsize * 2))
			m_buflength = 0
		Else If m_buflength = m_bufsize
			Local newsize:Int = Ceil(m_bufsize * BUFFER_MULTIPLIER)
			If newSize < m_buflength
				newSize = Ceil(m_buflength * BUFFER_MULTIPLIER)
			EndIf
			Local temp:Short Ptr = Short Ptr(MemAlloc(newSize * 2))
			If Not temp
				Throw New dScriptException.Create(dScriptException.ERROR_MEMALLOC, "dScriptToken.AddChar()", "Unable to allocate buffer of size " + (newSize * 2) + " bytes")
			End If
			m_bufsize = newSize
			MemCopy(temp, m_buffer, m_buflength * 2)
			MemFree(m_buffer)
			m_buffer = temp
		End If
		m_buffer[m_buflength] = char
		m_buflength:+ 1
	End Method
	
	Rem
		bbdoc: Convert the token's data to an integer.
		returns: The data of the token as an integer.
	End Rem
	Method AsInt:Int()
		Return AsString().ToInt()
	End Method
	
	Rem
		bbdoc: Convert the token's data to a float.
		returns: The data of the token as a float.
	End Rem
	Method AsFloat:Float()
		Return AsString().ToFloat()
	End Method
	
	Rem
		bbdoc: Convert the token's data to a double.
		returns: The data of the token as a double.
	End Rem
	Method AsDouble:Double()
		Return AsString().ToDouble()
	End Method
	
	Rem
		bbdoc: Convert the token's data to a string.
		returns: The data of the token as a string.
	End Rem
	Method AsString:String()
		If m_bufstring And (Not m_buffer Or m_bufstring.Length = m_buflength)
			Return m_bufstring
		End If
		m_bufstring = String.FromShorts(m_buffer, m_buflength)
		MemFree(m_buffer)
		m_buffer = Null
		Return m_bufstring
	End Method
	
	Rem
		bbdoc: Set the beginning file position (line and char/column) for the token (used for debugging/errors).
		returns: Nothing.
	End Rem
	Method SetBeginningPosition(beginning_line:Int, beginning_col:Int)
		m_beg_line = beginning_line
		m_beg_col = beginning_col
	End Method
	
	Rem
		bbdoc: Converts the beginning line and character positions to a single string (the format is "line: <linenum>, char: <charnum>").
		returns: The line and character positions as a report.
	End Rem
	Method LineRep:String()
		Return "line: " + String(m_beg_line) + ", char: " + String(m_beg_col)
	End Method
	
	Rem
		bbdoc: Convert the integer token type to a string representative.
		returns: The token type as a string.
	End Rem
	Method TypeToString:String()
		Select m_type
			Case NoToken
				Return "NoToken"
			Case StringToken
				Return "StringToken"
			Case QuotedStringToken
				Return "QuotedStringToken"
			Case NumberToken
				Return "NumberToken"
			Case DigitToken
				Return "DigitToken"
			Case EqualsToken
				Return "EqualsToken"
			Case OpenBraceToken
				Return "OpenBraceToken"
			Case CloseBraceToken
				Return "CloseBraceToken"
			Case CommentToken
				Return "CommentToken"
			Case EOFToken
				Return "EOFToken"
			Case EOLToken
				Return "EOLToken"
			Default
				Return "UNKNOWNToken"
		End Select
	End Method
	
End Type

Rem
	bbdoc: duct Quake-style script parser.
End Rem
Type dScriptParser
	
	Global m_whitespaceset:TCharacterSet = New TCharacterSet.InitWithString("~t ")
	Global m_eolset:TCharacterSet = New TCharacterSet.InitWithString("~n")
	Global m_numberset:TCharacterSet = New TCharacterSet.InitWithString("0-9\-+")
	Global m_digitset:TCharacterSet = New TCharacterSet.InitWithString(".0-9\-+")
	
	Field m_stream:TTextStream
	Field m_sourcestream:TStream, m_data:Byte Ptr
	Field m_handler:dScriptParserHandler
	
	Field m_curchar:Int = CHAR_EOF, m_token:dScriptToken
	Field m_line:Int, m_col:Int
	
	Rem
		bbdoc: Initialize the parser with a stream.
		returns: Nothing.
		about: NOTE: The given stream is not closed.
	End Rem
	Method InitWithStream(stream:TStream, encoding:Int = ENC_UTF8)
		Assert stream, "(dScriptParser.InitWithStream) stream is Null"
		m_stream = TTextStream.Create(stream, encoding)
		m_line = 1
		m_col = 0
		m_curchar = CHAR_EOF
		m_token = Null
		NextChar() ' Get the first character in the script
	End Method
	
	Rem
		bbdoc: Initiate the parser with a string containing a script.
		returns: Nothing.
	End Rem
	Method InitWithString(data:String, encoding:Int = ENC_UTF8)
		Assert data, "(dScriptParser.InitWithString) data is Null"
		m_data = data.ToCString()
		m_sourcestream = TRamStream.Create(m_data, data.Length, True, False)
		m_stream = TTextStream.Create(m_sourcestream, encoding)
		m_line = 1
		m_col = 0
		m_curchar = CHAR_EOF
		m_token = Null
		NextChar() ' Get the first character in the script
	End Method
	
	Rem
		bbdoc: Set the parserhandler for this parser.
		returns: Nothing.
	End Rem
	Method SetHandler(handler:dScriptParserHandler)
		m_handler = handler
	End Method
	
	Rem
		bbdoc: Continue parsing the stream.
		returns: True if more data is left to be parsed/handled, or False if there is no more data in the stream.
	End Rem
	Method Parse:Int()
		'NextChar()
		SkipWhitespace()
		NextToken()
		ReadToken()
		If m_curchar = CHAR_EOF
			m_token = New dScriptToken
			m_token.m_type = EOFToken
			m_handler.HandleToken(m_token) ' Just to make sure the EOF gets handled (data might not end with a newline, causing an EOFToken)
			Return False
		Else If m_token.m_type = EOFToken
			Return False
		End If
		Return True
	End Method
	
	Rem
		bbdoc: Get the next char in the stream.
		returns: The next character in the stream, or CHAR_EOF if the stream is at the end.
		about: The character read will be cached in m_curchar.
	End Rem
	Method NextChar:Int()
		If m_curchar = CHAR_NEWLINE
			m_line:+ 1
			m_col = 0
		End If
		If Not m_stream.Eof()
			m_curchar = m_stream.ReadChar()
			m_col:+ 1
		Else
			m_curchar = CHAR_EOF
		End If
		If m_curchar = CHAR_CARRIAGERETURN
			NextChar()
		End If
		Return m_curchar
	End Method
	
	Rem
		bbdoc: Read over any whitespace characters.
		returns: Nothing.
	End Rem
	Method SkipWhitespace() NoDebug
		While m_curchar <> CHAR_EOF And m_whitespaceset.Contains(m_curchar) = True
			NextChar()
		End While
	End Method
	
	Rem
		bbdoc: Read over all data until an EOL character is reached.
		returns: Nothing.
	End Rem
	Method SkipToEOL() NoDebug
		While m_curchar <> CHAR_EOF And m_curchar <> CHAR_NEWLINE 'And m_eolset.Contains(m_curchar) = False
			NextChar()
		End While
	End Method
	
	Rem
		bbdoc: Read/determine the next token from the parser.
		returns: The next token in the script.
		about: The token will be cached in m_token.
	End Rem
	Method NextToken:dScriptToken()
		m_token = New dScriptToken
		Select m_curchar
			Case CHAR_QUOTE
				m_token.m_type = QuotedStringToken
			Case CHAR_SINGLEQUOTE
				m_token.m_type = CommentToken
			Case CHAR_EOF
				m_token.m_type = EOFToken
			Case CHAR_NEWLINE
				m_token.m_type = EOLToken
			Case CHAR_DECIMALPOINT
				m_token.m_type = DigitToken
				m_token.AddChar(m_curchar) ' Add the decimal
			Case CHAR_EQUALSIGN
				m_token.m_type = EqualsToken
			Case CHAR_OPENBRACE
				m_token.m_type = OpenBraceToken
			Case CHAR_CLOSEBRACE
				m_token.m_type = CloseBraceToken
			Default
				If m_numberset.Contains(m_curchar) = True
					m_token.m_type = NumberToken
				Else
					m_token.m_type = StringToken
				End If
		End Select
		m_token.SetBeginningPosition(m_line, m_col)
	End Method
	
	Rem
		bbdoc: Read the current token's data.
		returns: Nothing.
	End Rem
	Method ReadToken()
		'Local tktype:String
		'tktype = m_token.TypeToString()
		Select m_token.m_type
			Case QuotedStringToken
				ReadQuotedStringToken()
				NextChar()
			Case StringToken
				ReadStringToken()
			Case NumberToken
				ReadNumberToken()
			Case DigitToken
				NextChar()
				ReadDigitToken()
			Case EqualsToken
				NextChar()
			Case CommentToken
				SkipToEOL()
				'NextChar() ' Bad to get the next char, as it could be the EOL needed to terminate the current identifier
			Case OpenBraceToken, CloseBraceToken
				NextChar()
			Case EOLToken
				NextChar()
			Case EOFToken
				' Do nothing
			Default
				Throw New dScriptException.Create(dScriptException.ERROR_PARSER, "dScriptParser.ReadToken()", "Unhandled token: " + m_token.m_type)
		End Select
		'If tktype <> m_token.TypeToString()
		'	DebugLog("(dScriptParser.ReadToken()) " + tktype + " -> " + m_token.TypeToString() + " ~q" + m_token.ToString() + "~q")
		'End If
		m_handler.HandleToken(m_token)
	End Method
	
	Rem
		bbdoc: Read the data for the number/digit token.
		returns: Nothing.
	End Rem
	Method ReadNumberToken()
		While m_curchar <> CHAR_EOF
			If m_curchar = CHAR_QUOTE
				Throw New dScriptException.Create(dScriptException.ERROR_PARSER, "dScriptParser.ReadNumberToken()", "Unexpected quote", m_token, Self)
			Else If m_eolset.Contains(m_curchar) = True Or m_whitespaceset.Contains(m_curchar) = True Or m_curchar = CHAR_CLOSEBRACE Or m_curchar = CHAR_SINGLEQUOTE Or m_curchar = CHAR_EQUALSIGN
				Exit
			Else
				If m_numberset.Contains(m_curchar) = True
					m_token.AddChar(m_curchar)
				Else If m_curchar = CHAR_DECIMALPOINT
					m_token.AddChar(m_curchar)
					NextChar()
					m_token.m_type = DigitToken
					ReadDigitToken()
					Return
				Else
					m_token.m_type = StringToken
					ReadStringToken()
					Return
				End If
			End If
			NextChar()
		End While
	End Method
	
	Rem
		bbdoc: Read the data for the digit token.
		returns: Nothing.
	End Rem
	Method ReadDigitToken()
		While m_curchar <> CHAR_EOF
			If m_curchar = CHAR_QUOTE
				Throw New dScriptException.Create(dScriptException.ERROR_PARSER, "dScriptParser.ReadNumberToken()", "Unexpected quote", m_token, Self)
			Else If m_eolset.Contains(m_curchar) = True Or m_whitespaceset.Contains(m_curchar) = True Or m_curchar = CHAR_CLOSEBRACE Or m_curchar = CHAR_SINGLEQUOTE Or m_curchar = CHAR_EQUALSIGN
				Exit
			Else
				If m_numberset.Contains(m_curchar) = True
					m_token.AddChar(m_curchar)
				Else 'If m_curchar = CHAR_DECIMALPOINT
					' The token should've already contained a decimal point, so it must
					' be a string (more than one decimal point fails a string->float conversion).
					m_token.m_type = StringToken
					ReadStringToken()
					Return
				End If
			End If
			NextChar()
		End While
	End Method
	
	Rem
		bbdoc: Read the data for the string token.
		returns: Nothing.
	End Rem
	Method ReadStringToken()
		While m_curchar <> CHAR_EOF
			If m_curchar = CHAR_QUOTE
				Throw New dScriptException.Create(dScriptException.ERROR_PARSER, "dScriptParser.ReadStringToken()", "Unexpected quote", m_token, Self)
			Else If m_eolset.Contains(m_curchar) = True Or m_whitespaceset.Contains(m_curchar) = True Or m_curchar = CHAR_CLOSEBRACE Or m_curchar = CHAR_SINGLEQUOTE Or m_curchar = CHAR_EQUALSIGN
				Exit
			Else
				m_token.AddChar(m_curchar)
			End If
			NextChar()
		End While
	End Method
	
	Rem
		bbdoc: Read the data for the quoted string token.
		returns: Nothing.
	End Rem
	Method ReadQuotedStringToken()
		Local eolreached:Int = False
		' Skip the first character (will be the initial quote)
		NextChar()
		Repeat
			Select m_curchar
				Case CHAR_EOF
					Throw New dScriptException.Create(dScriptException.ERROR_PARSER, "dScriptParser.ReadQuotedStringToken()", "Encountered EOF whilst reading quoted string", m_token, Self)
				Case CHAR_QUOTE
					Exit
				Default
					If eolreached = False
						m_token.AddChar(m_curchar)
					End If
					If m_eolset.Contains(m_curchar) = True
						'Throw New dScriptException.Create(dScriptException.ERROR_PARSER, "dScriptParser.ReadQuotedStringToken()", "Unclosed quote (met EOL character)", m_token, Self)
						eolreached = True
					Else If eolreached = True And m_whitespaceset.Contains(m_curchar) = False
						eolreached = False
						m_token.AddChar(m_curchar)
					End If
			End Select
			NextChar()
		Forever
	End Method
	
	Rem
		bbdoc: Converts the line and character positions to a single string (the format is "line: <line#>, char: <char#>").
		returns: The line and character positions as a report.
	End Rem
	Method LineRep:String()
		Return "line: " + String(m_line) + ", char: " + String(m_col)
	End Method
	
	Rem
		bbdoc: Converts the given line and character positions to a single string (the format is "line: <line#>, char: <char#>").
		returns: The line and character positions as a report.
	End Rem
	Function fLineRep:String(line:Int, char:Int)
		Return "line: " + String(line) + ", char: " + String(char)
	End Function
	
	Rem
		bbdoc: Close the file handles.
		returns: Nothing.
	End Rem
	Method CloseHandles()
		'm_stream.SetStream(Null)
		If m_sourcestream
			m_sourcestream.Close()
		End If
		If m_data
			MemFree(m_data)
		End If
		m_stream.Close()
		m_sourcestream = Null
		m_stream = Null
	End Method
	
End Type

Rem
	bbdoc: duct #dScriptParser handler.
End Rem
Type dScriptParserHandler Abstract
	
	Field m_parser:dScriptParser
	
	Field m_rootnode:dNode, m_currentnode:dNode
	
	Method New()
		m_parser = New dScriptParser
		m_parser.SetHandler(Self)
	End Method
	
	Rem
		bbdoc: Clean the handler.
		returns: Nothing.
	End Rem
	Method Clean()
		m_rootnode = Null
		m_currentnode = Null
	End Method
	
	Rem
		bbdoc: Process the script source via the parser.
		returns: Nothing.
	End Rem
	Method Process()
		m_rootnode = New dNode.Create(Null, Null)
		m_currentnode = m_rootnode
		While m_parser.Parse()
		End While
		Finish()
		If m_currentnode <> m_rootnode
			Throw New dScriptException.Create(dScriptException.ERROR_HIERARCHY, "dScriptParserHandler.Process()", "The current node does not match the root node (current=~q" + m_currentnode.GetName() + "~q)")
		End If
	End Method
	
	Rem
		bbdoc: Handle the given token.
		returns: Nothing.
	End Rem
	Method HandleToken(token:dScriptToken) Abstract
	
	Rem
		bbdoc: Finish the parsing (clean any existing fields, etc.)
		returns: Nothing.
	End Rem
	Method Finish() Abstract
	
	Rem
		bbdoc: Process a script from the given object stream.
		returns: The root node from the parsed script.
		about: NOTE: The given stream is not closed.
	End Rem
	Method ProcessFromStream:dNode(stream:Tstream, encoding:Int = ENC_UTF8)
		Local node:dNode
		m_parser.InitWithStream(stream, encoding)
		Process()
		node = m_rootnode
		Clean()
		m_parser.CloseHandles()
		Return node
	End Method
	
	Rem
		bbdoc: Process a script from the given string (contains the script source, not the path to the file containing the script source).
		returns: The root node from the parsed script.
	End Rem
	Method ProcessFromString:dNode(data:String, encoding:Int = ENC_UTF8)
		Local node:dNode
		m_parser.InitWithString(data, encoding)
		Process()
		node = m_rootnode
		Clean()
		m_parser.CloseHandles()
		Return node
	End Method
	
End Type

Rem
	bbdoc: Default #dScriptParserHandler.
End Rem
Type dScriptDefaultParserHandler Extends dScriptParserHandler
	
	Field m_varname:String, m_equals:Int
	Field m_currentiden:dIdentifier, m_currentvalue:dValueVariable
	
	Rem
		bbdoc: Clean the handler.
		returns: Nothing.
	End Rem
	Method Clean()
		Super.Clean()
		m_varname = Null
		m_equals = False
		m_currentvalue = Null
		m_currentiden = Null
	End Method
	
	Rem
		bbdoc: Handle the given token.
		returns: Nothing.
	End Rem
	Method HandleToken(token:dScriptToken)
		'DebugLog("varname:~q" + m_varname + "~q, equals:" + m_equals + ", iden:" + (m_currentiden <> Null) + ", value:" + (m_currentvalue <> Null) + ", type:" + token.TypeToString() + ", @" + token.LineRep() + ", AsString:~q" + token.AsString() + "~q, curchar:" + m_parser.m_curchar + ", Chr(curchar):~q" + Chr(m_parser.m_curchar) + "~q")
		Select token.m_type
			Case StringToken, QuotedStringToken
				If m_varname And m_equals
					If token.m_type = StringToken
						Local bool:Int = dVariable.ConvertStringToBool(token.AsString())
						If bool > -1
							AddVariableAndReset(m_currentnode, New dBoolVariable.Create(m_varname, bool), False, False)
							Return
						End If
					End If
					AddVariableAndReset(m_currentnode, New dStringVariable.Create(m_varname, token.AsString()), False, False)
				Else If (m_varname Or m_currentiden) And Not m_equals
					MakeIdentifier(token)
					If token.m_type = StringToken
						Local bool:Int = dVariable.ConvertStringToBool(token.AsString())
						If bool > -1
							AddVariableAndReset(m_currentiden, New dBoolVariable.Create(Null, bool), False, False)
							Return
						End If
					End If
					AddVariableAndReset(m_currentiden, New dStringVariable.Create(Null, token.AsString()), False, False)
				Else' If Not m_varname And Not m_equals
					m_varname = token.AsString()
				End If
			Case NumberToken
				If m_varname And m_equals
					m_currentvalue = New dIntVariable.Create(m_varname, token.AsInt())
					AddVariableAndReset(m_currentnode, m_currentvalue, False, False)
				Else If (m_varname Or m_currentiden) And Not m_equals
					MakeIdentifier(token)
					AddVariableAndReset(m_currentiden, New dIntVariable.Create(Null, token.AsInt()), False, False)
				Else
					Throw New dScriptException.Create(dScriptException.ERROR_PARSER, "dScriptDefaultParserHandler.HandleToken()", "A number cannot be an identifier", token, m_parser)
				End If
			Case DigitToken
				If m_varname And m_equals
					m_currentvalue = New dFloatVariable.Create(m_varname, token.AsFloat())
					AddVariableAndReset(m_currentnode, m_currentvalue, False, False)
				Else If (m_varname Or m_currentiden) And Not m_equals
					MakeIdentifier(token)
					AddVariableAndReset(m_currentiden, New dFloatVariable.Create(Null, token.AsFloat()), False, False)
				Else
					Throw New dScriptException.Create(dScriptException.ERROR_PARSER, "dScriptDefaultParserHandler.HandleToken()", "A number cannot be an identifier", token, m_parser)
				End If
			Case EqualsToken
				If m_currentiden
					Throw New dScriptException.Create(dScriptException.ERROR_PARSER, "dScriptDefaultParserHandler.HandleToken()", "Unexpected equality sign after identifier declaration", token, m_parser)
				Else If Not m_varname
					Throw New dScriptException.Create(dScriptException.ERROR_PARSER, "dScriptDefaultParserHandler.HandleToken()", "Expected string, got equality sign", token, m_parser)
				Else If m_equals
					Throw New dScriptException.Create(dScriptException.ERROR_PARSER, "dScriptDefaultParserHandler.HandleToken()", "Expected value, got equality sign", token, m_parser)
				Else
					m_equals = True
				End If
			Case OpenBraceToken
				If m_currentiden
					Throw New dScriptException.Create(dScriptException.ERROR_PARSER, "dScriptDefaultParserHandler.HandleToken()", "Node cannot contain values (possible openbrace typo)", token, m_parser)
				End If
				Local tempnode:dNode = New dNode.Create(m_varname, m_currentnode)
				AddVariableAndReset(m_currentnode, tempnode, False, False)
				m_currentnode = tempnode
			Case CloseBraceToken
				If Not m_currentnode.GetParent()
					Throw New dScriptException.Create(dScriptException.ERROR_PARSER, "dScriptDefaultParserHandler.HandleToken()", "Mismatched node brace", token, m_parser)
				Else If m_equals
					Throw New dScriptException.Create(dScriptException.ERROR_PARSER, "dScriptDefaultParserHandler.HandleToken()", "Expected value, got close-brace", token, m_parser)
				Else
					If m_currentiden
						Reset(True, True)
					End If
					m_currentnode = dNode(m_currentnode.GetParent())
				End If
			Case CommentToken
				' Do nothing
			Case EOLToken, EOFToken
				Finish()
			Default
				'DebugLog("(dScriptDefaultParserHandler.HandleToken()) Unhandled token of type " + token.TypeToString())
		End Select
	End Method
	
	Rem
		bbdoc: Reset the variable state.
		returns: Nothing.
	End Rem
	Method Reset(iden:Int, value:Int)
		m_varname = Null
		m_equals = False
		If value Then m_currentvalue = Null
		If iden Then m_currentiden = Null
	End Method
	
	Rem
		bbdoc: Add a value to the given collection and reset the variable state.
		returns: Nothing.
	End Rem
	Method AddVariableAndReset(collection:dCollectionVariable, variable:dVariable, iden:Int, value:Int)
		collection.AddVariable(variable)
		Reset(iden, value)
	End Method
	
	Rem
		bbdoc: Make an identifier from the current state.
		returns: Nothing.
	End Rem
	Method MakeIdentifier(token:dScriptToken = Null, resetiden:Int = False, resetvalue:Int = False, force:Int = False)
		'If m_currentvalue
		'	Throw New dScriptException.Create(dScriptException.ERROR_PARSER, "dScriptDefaultParserHandler.MakeIdentifier()", "Value already defined on line", token)
		If Not m_currentiden Or force
			Local bool:Int = dVariable.ConvertStringToBool(m_varname)
			If bool > -1
				Throw New dScriptException.Create(dScriptException.ERROR_PARSER, "dScriptDefaultParserHandler.MakeIdentifier()", "Identifier name cannot be boolean value", token, m_parser)
			End If
			m_currentiden = New dIdentifier.Create(m_varname)
			AddVariableAndReset(m_currentnode, m_currentiden, resetiden, resetvalue)
		'Else
			'Throw New dScriptException.Create(dScriptException.ERROR_PARSER, "dScriptDefaultParserHandler.MakeIdentifier()", "Unknown error", token)
		End If
	End Method
	
	Rem
		bbdoc: Finish the parsing (clean any existing fields, etc.)
		returns: Nothing.
	End Rem
	Method Finish()
		If m_parser.m_token And m_parser.m_token.m_type = EOLToken And m_equals
			Throw New dScriptException.Create(dScriptException.ERROR_PARSER, "dScriptDefaultParserHandler.Finish()", "Expected value, got EOL/EOF",, m_parser)
		Else If m_varname ' no-value identifier
			MakeIdentifier(Null, True, True, True)
		Else
			Reset(True, True)
		End If
	End Method
	
End Type

Rem
	bbdoc: The base exception type for #dNode-related issues.
End Rem
Type dScriptException
	
	Const ERROR_PARSER:Int = 1
	Const ERROR_HIERARCHY:Int = 2
	Const ERROR_MEMALLOC:Int = 3
	
	Field m_error:Int, m_reporter:String
	Field m_message:String
	Field m_token:dScriptToken, m_parser:dScriptParser
	
	Rem
		bbdoc: Create a dScriptException.
		returns: Itself.
	End Rem
	Method Create:dScriptException(error:Int, reporter:String, message:String, token:dScriptToken = Null, parser:dScriptParser = Null)
		m_error = error
		m_reporter = reporter
		m_message = message
		m_token = token
		m_parser = parser
		Return Self
	End Method
	
	Rem
		bbdoc: Convert the exception to a string.
		returns: A string containing the exception's report.
	End Rem
	Method ToString:String()
		If m_parser And Not m_token Then m_token = m_parser.m_token
		If m_token And m_parser
			Return "(" + m_reporter + ") [" + ErrorToString(m_error) + "] from " + m_token.LineRep() + " to " + m_parser.LineRep() + ": " + m_message
		End If
		If m_token
			Return "(" + m_reporter + ") [" + ErrorToString(m_error) + "] at " + m_token.LineRep() + ": " + m_message
		Else If m_parser
			Return "(" + m_reporter + ") [" + ErrorToString(m_error) + "] at " + m_parser.LineRep() + ": " + m_message
		Else
			Return "(" + m_reporter + ") [" + ErrorToString(m_error) + "]: " + m_message
		End If
	End Method
	
	Rem
		bbdoc: Convert an error code to its name/description.
		returns: The variable name/description for the given error code.
	End Rem
	Function ErrorToString:String(error:Int)
		Select error
			Case ERROR_PARSER
				Return "ERROR_PARSER"
			Case ERROR_HIERARCHY
				Return "ERROR_HIERARCHY"
			Case ERROR_MEMALLOC
				Return "ERROR_MEMALLOC"
			Default
				Return "UNKNOWN"
		End Select
	End Function
	
End Type

