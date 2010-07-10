
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

'Extern "C"
'	Function bbStringFromChar:String(char:Int)
'End Extern

' Characters
Const CHAR_EOF:Int = -1
Const CHAR_NEWLINE:Int = 10			' "~n"
Const CHAR_DECIMALPOINT:Int = 46	' "."

Const CHAR_QUOTE:Int = 34			' "~q"
Const CHAR_SINGLEQUOTE:Int = 39		' "'"

Const CHAR_OPENBRACE:Int = 123		' "{"
Const CHAR_CLOSEBRACE:Int = 125		' "}"

Const CHAR_CARRIAGERETURN:Int = 13

' Token types
Const NoToken:Int = 0

Const StringToken:Int = 1
Const QuotedStringToken:Int = 2

Const NumberToken:Int = 3
Const DigitToken:Int = 4

Const CommentToken:Int = 5
Const EOFToken:Int = 6
Const EOLToken:Int = 7

Const OpenBraceToken:Int = 8
Const CloseBraceToken:Int = 9

Public

Const SNPEncoding_Latin1:Int = 1
Const SNPEncoding_UTF8:Int = 2
Const SNPEncoding_UTF16BE:Int = 3
Const SNPEncoding_UTF16LE:Int = 4

Rem
	bbdoc: #dSNodeParser script token.
End Rem
Type dSNodeToken
	Const BUFFERINITIAL_SIZE:Int = 48
	Const BUFFER_MULTIPLIER:Double = 1.75:Double
	
	Field m_type:Int = NoToken
	Field m_beg_line:Int, m_beg_col:Int
	
	Field m_buffer:Short Ptr = Null, m_bufSize:Int = 0, m_bufLen:Int = 0
	Field m_bufS:String = Null
	
	Method New()
	End Method
	
	Method Delete() NoDebug
		If m_buffer <> Null
			MemFree(m_buffer)
		End If
	End Method
	
	Rem
		bbdoc: Initiate the dSNodeToken.
		returns: Nothing.
	End Rem
	Method Init(toktype:Int)
		m_type = toktype
	End Method
	
	Rem
		bbdoc: Create a new dSNodeToken.
		returns: The new dSNodeToken (itself).
	End Rem
	Method Create:dSNodeToken(toktype:Int)
		Init(toktype)
		Return Self
	End Method
	
	Rem
		bbdoc: Add a character to the token.
		returns: Nothing.
	End Rem
	Method AddChar(char:Int)
		If m_buffer = Null
			m_bufSize = BUFFERINITIAL_SIZE
			m_buffer = Short Ptr(MemAlloc(m_bufSize * 2))
			m_bufLen = 0
		Else If m_bufLen = m_bufSize
			Local newsize:Int = Ceil(m_bufSize * BUFFER_MULTIPLIER)
			If newSize < m_bufLen
				newSize = Ceil(m_bufLen * BUFFER_MULTIPLIER)
			EndIf
			
			Local temp:Short Ptr = Short Ptr(MemAlloc(newSize * 2))
			If temp = Null
				Throw(New dSNodeException.Create(dSNodeException.MemoryAllocationError, "dSNodeParser.AddChar()", "Unable to allocate buffer of size " + (newSize * 2) + " bytes"))
			EndIf
			
			m_bufSize = newSize
			MemCopy(temp, m_buffer, m_bufLen * 2)
			MemFree(m_buffer)
			m_buffer = temp
		End If
		m_buffer[m_bufLen] = char
		m_bufLen:+1
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
		If m_bufS <> Null And (m_buffer = Null Or m_bufS.Length = m_bufLen)
			Return m_bufS
		End If
		m_bufS = String.FromShorts(m_buffer, m_bufLen)
		MemFree(m_buffer)
		m_buffer = Null
		Return m_bufS
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
			Case CommentToken
				Return "CommentToken"
			Case EOFToken
				Return "EOFToken"
			Case EOLToken
				Return "EOLToken"
			Case OpenBraceToken
				Return "OpenBraceToken"
			Case CloseBraceToken
				Return "CloseBraceToken"
			Default
				Return "UNKNOWNToken"
		End Select
	End Method
	
End Type

Rem
	bbdoc: duct script node parser (see #dSNode).
End Rem
Type dSNodeParser
	
	Global m_whitespaceset:TCharacterSet = New TCharacterSet.InitWithString("~t ") 'TCharacterSet.ForWhitespace()
	'Global m_delimiterset:TCharacterSet = New TCharacterSet.InitWithString(" ~t~n}")
	Global m_eolset:TCharacterSet = New TCharacterSet.InitWithString("~n")
	Global m_numberset:TCharacterSet = New TCharacterSet.InitWithString("0-9\-+")
	Global m_digitset:TCharacterSet = New TCharacterSet.InitWithString(".0-9\-+")
	
	Field m_stream:TTextStream
	Field m_handler:dSNodeParserHandler
	
	Field m_curchar:Int = CHAR_EOF, m_token:dSNodeToken
	Field m_line:Int, m_col:Int
	
	Method New()
	End Method
	
	Rem
		bbdoc: Init the parser with a stream (you are expected to close the stream).
		returns: Nothing.
		about: @data can be either a TStream or String (in which case it must be the location of a file).
	End Rem
	Method InitWithStream(url:Object, encoding:Int = SNPEncoding_UTF8)
		Local ustream:TStream
		
		ustream = TStream(url)
		If ustream = Null
			ustream = ReadStream(url)
		End If
		Assert ustream, "(duct.scriptparser.dSNodeParser) Failed to open stream"
		m_stream = TTextStream.Create(ustream, encoding)
		m_line = 1
		m_col = 0
		m_curchar = CHAR_EOF
		m_token = Null
		NextChar() ' Get the first character in the script
	End Method
	
	Rem
		bbdoc: Initiate the parser with a string containing the script.
		returns: Nothing.
	End Rem
	Method InitWithString(data:String, encoding:Int = SNPEncoding_UTF8)
		Local ramstream:TRamStream
		
		Assert data, "(duct.scriptparser.dSNodeParser) @data is Null!"
		ramstream = TRamStream.Create(data, data.Length, True, False)
		m_stream = TTextStream.Create(ramstream, encoding)
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
	Method SetHandler(handler:dSNodeParserHandler)
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
		
		If m_curchar = CHAR_EOF Or m_token.m_type = EOFToken
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
			m_line:+1
			m_col = 0
		End If
		If m_stream.Eof() = False
			m_curchar = m_stream.ReadChar()
			m_col:+1
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
		Wend
	End Method
	
	Rem
		bbdoc: Read over all data until an EOL character is reached.
		returns: Nothing.
	End Rem
	Method SkipToEOL() NoDebug
		' Changed to just check for ~n, as eolset now contains ~r
		While m_curchar <> CHAR_EOF And m_curchar <> CHAR_NEWLINE 'And m_eolset.Contains(m_curchar) = False
			NextChar()
		Wend
	End Method
	
	Rem
		bbdoc: Read/determine the next token from the parser.
		returns: The next token in the script.
		about: The token will be cached in m_token.
	End Rem
	Method NextToken:dSNodeToken()
		m_token = New dSNodeToken
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
		
		'DebugLog("(dSNodeParser.ReadToken())")
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
				Throw(New dSNodeException.Create(dSNodeException.ParserError, "dSNodeParser.ReadToken()", "Unhandled token: " + m_token.m_type))
		End Select
		'If tktype <> m_token.TypeToString()
		'	DebugLog("(dSNodeParser.ReadToken()) " + tktype + " -> " + m_token.TypeToString() + " ~q" + m_token.ToString() + "~q")
		'End If
		m_handler.HandleToken(m_token)
	End Method
	
	Rem
		bbdoc: Read the data for the number/digit token.
		returns: Nothing.
	End Rem
	Method ReadNumberToken()
		'm_token.AddChar(m_curchar)
		'NextChar()
		'DebugLog("(dSNodeParser.ReadNumberToken())")
		While m_curchar <> CHAR_EOF
			If m_curchar = CHAR_QUOTE
				Throw(New dSNodeException.Create(dSNodeException.ParserError, "dSNodeParser.ReadNumberToken()", "Unexpected quote", m_token, Self))
			Else If m_eolset.Contains(m_curchar) = True Or m_whitespaceset.Contains(m_curchar) = True Or m_curchar = CHAR_CLOSEBRACE Or m_curchar = CHAR_SINGLEQUOTE
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
					'DebugLog("(dSNodeParser.ReadNumberToken()) char: " + Chr(m_curchar))
					m_token.m_type = StringToken
					ReadStringToken()
					Return
				End If
			End If
			NextChar()
		Wend
	End Method
	
	Rem
		bbdoc: Read the data for the digit token.
		returns: Nothing.
	End Rem
	Method ReadDigitToken()
		'm_token.AddChar(m_curchar)
		'NextChar()
		'DebugLog("(dSNodeParser.ReadDigitToken())")
		While m_curchar <> CHAR_EOF
			If m_curchar = CHAR_QUOTE
				Throw(New dSNodeException.Create(dSNodeException.ParserError, "dSNodeParser.ReadNumberToken()", "Unexpected quote", m_token, Self))
			Else If m_eolset.Contains(m_curchar) = True Or m_whitespaceset.Contains(m_curchar) = True Or m_curchar = CHAR_CLOSEBRACE Or m_curchar = CHAR_SINGLEQUOTE
				Exit
			Else
				If m_numberset.Contains(m_curchar) = True
					m_token.AddChar(m_curchar)
				Else 'If m_curchar = CHAR_DECIMALPOINT
					'DebugLog("(dSNodeParser.ReadDigitToken()) char: " + Chr(m_curchar))
					' The token should've already contained a decimal point, so it must
					' be a string (more than one decimal point fails a string->float conversion).
					m_token.m_type = StringToken
					ReadStringToken()
					Return
				End If
			End If
			NextChar()
		Wend
	End Method
	
	Rem
		bbdoc: Read the data for the string token.
		returns: Nothing.
	End Rem
	Method ReadStringToken()
		'm_token.AddChar(m_curchar)
		'NextChar()
		'DebugLog("(dSNodeParser.ReadStringToken())")
		While m_curchar <> CHAR_EOF
			If m_curchar = CHAR_QUOTE
				Throw(New dSNodeException.Create(dSNodeException.ParserError, "dSNodeParser.ReadStringToken()", "Unexpected quote", m_token, Self))
			Else If m_eolset.Contains(m_curchar) = True Or m_whitespaceset.Contains(m_curchar) = True Or m_curchar = CHAR_CLOSEBRACE Or m_curchar = CHAR_SINGLEQUOTE
				Exit
			Else
				m_token.AddChar(m_curchar)
			End If
			NextChar()
		Wend
	End Method
	
	Rem
		bbdoc: Read the data for the quoted string token.
		returns: Nothing.
	End Rem
	Method ReadQuotedStringToken()
		Local eolreached:Int = False
		'DebugLog("(dSNodeParser.ReadQuotedStringToken())")
		
		' Skip the first character (will be the initial quote)
		NextChar()
		Repeat
			Select m_curchar
				Case CHAR_EOF
					Throw(New dSNodeException.Create(dSNodeException.ParserError, "dSNodeParser.ReadQuotedStringToken()", "Encountered EOF whilst reading quoted string", m_token, Self))
				Case CHAR_QUOTE
					Exit
				Default
					If eolreached = False
						m_token.AddChar(m_curchar)
					End If
					If m_eolset.Contains(m_curchar) = True
						'Throw(New dSNodeException.Create(dSNodeException.ParserError, "dSNodeParser.ReadQuotedStringToken()", "Unclosed quote (met EOL character)", m_token, Self))
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
		m_stream.Close()
	End Method
	
End Type

Rem
	bbdoc: duct script node parser handler.
End Rem
Type dSNodeParserHandler Abstract
	
	Field m_parser:dSNodeParser
	
	Field m_rootnode:dSNode, m_currentnode:dSNode
	Field m_currentiden:dIdentifier
	
	Method New()
		m_parser = New dSNodeParser
		m_parser.SetHandler(Self)
	End Method
	
	Rem
		bbdoc: Clean the handler.
		returns: Nothing.
	End Rem
	Method Clean()
		m_rootnode = Null
		m_currentnode = Null
		m_currentiden = Null
	End Method
	
	Rem
		bbdoc: Process the script source via the parser.
		returns: Nothing.
	End Rem
	Method Process()
		m_rootnode = New dSNode.Create(Null, Null)
		m_currentnode = m_rootnode
		While m_parser.Parse() = True
			'DebugLog("(dSNodeParserHandler.Process())")
			'HandleToken(m_parser.m_token)
		Wend
		If m_currentnode <> m_rootnode
			Throw(New dSNodeException.Create(dSNodeException.HierarchyError, "dSNodeParserHandler.Process()", "The current node does not match the root node (current=~q" + m_currentnode.GetName() + "~q)"))
		End If
	End Method
	
	Rem
		bbdoc: Handle the given token.
		returns: Nothing.
	End Rem
	Method HandleToken(token:dSNodeToken) Abstract
	
	Rem
		bbdoc: Process a script from the given object (file path/stream).
		returns: The root node from the parsed script.
		about: The @obj parameter is expected to either be a path to a file or a TStream.
	End Rem
	Method ProcessFromObject:dSNode(obj:Object, encoding:Int = SNPEncoding_UTF8)
		m_parser.InitWithStream(obj, encoding)
		Clean()
		Process()
		m_parser.CloseHandles()
		Return m_rootnode
	End Method
	
	Rem
		bbdoc: Process a script from the given String (contains the script source, not the path to the file containing the script source).
		returns: The root node from the parsed script.
	End Rem
	Method ProcessFromString:dSNode(data:String, encoding:Int = SNPEncoding_UTF8)
		m_parser.InitWithString(data, encoding)
		Clean()
		Process()
		m_parser.CloseHandles()
		Return m_rootnode
	End Method
	
End Type

Rem
	bbdoc: Default #dSNode parser handler.
End Rem
Type dSNodeDefaultParserHandler Extends dSNodeParserHandler
	
	Rem
		bbdoc: Handle the given token.
		returns: Nothing.
	End Rem
	Method HandleToken(token:dSNodeToken)
		'DebugLog("(dSNodeDefaultParserHandler.HandleToken())")
		'DebugLog(token.TypeToString() + " " + token.LineRep() + ": ~q" + token.AsString() + "~q curchar: ~q" + Chr(m_parser.m_curchar) + "~q")
		
		Select token.m_type
			Case StringToken, QuotedStringToken
				If m_currentiden = Null
					m_currentiden = New dIdentifier.CreateByData(token.AsString())
				Else
					Local value:String = token.AsString()
					If token.m_type = StringToken
						Local lvalue:String = value.ToLower()
						If lvalue = "true" Or lvalue = "false"
							m_currentiden.AddValue(New dBoolVariable.Create(Null, (lvalue = "true") And True Or False))
							Return
						End If
					End If
					If value.StartsWith("/e:")
						m_currentiden.AddValue(New dEvalVariable.Create(Null, value[2..]))
					Else
						m_currentiden.AddValue(New dStringVariable.Create(Null, value))
					End If
				End If
			Case NumberToken
				If m_currentiden <> Null
					m_currentiden.AddValue(New dIntVariable.Create(Null, token.AsInt()))
				Else
					Throw(New dSNodeException.Create(dSNodeException.ParserError, "dSNodeDefaultParserHandler.Process()", "A number cannot be an identifier", token))
				End If
			Case DigitToken
				If m_currentiden <> Null
					m_currentiden.AddValue(New dFloatVariable.Create(Null, token.AsFloat()))
				Else
					Throw(New dSNodeException.Create(dSNodeException.ParserError, "dSNodeDefaultParserHandler.Process()", "A number cannot be an identifier", token))
				End If
			Case OpenBraceToken
				Local name:String, tempnode:dSNode
				If m_currentiden <> Null
					If m_currentiden.GetValueCount() > 0
						Throw(New dSNodeException.Create(dSNodeException.ParserError, "dSNodeDefaultParserHandler.Process()", "Node cannot contain values (possible openbrace typo)", token))
					End If
					name = m_currentiden.GetName()
					m_currentiden = Null
				End If
				tempnode = New dSNode.Create(name, m_currentnode)
				m_currentnode.AddNode(tempnode)
				m_currentnode = tempnode
			Case CloseBraceToken
				If m_currentnode.GetParent() = Null
					Throw(New dSNodeException.Create(dSNodeException.ParserError, "dSNodeDefaultParserHandler.Process()", "Mismatched node brace", token))
				Else
					If m_currentiden <> Null
						m_currentnode.AddIdentifier(m_currentiden)
						m_currentiden = Null
					End If
					m_currentnode = m_currentnode.GetParent()
				End If
			Case CommentToken
				'Do nothing..
			Case EOLToken, EOFToken
				If m_currentiden <> Null
					m_currentnode.AddIdentifier(m_currentiden)
					m_currentiden = Null
				End If
			Default
				'DebugLog("(dSNodeDefaultParserHandler.HandleToken()) Unhandled token of type " + token.TypeToString())
		End Select
	End Method
End Type

Rem
	bbdoc: The base exception type for #dSNode-related issues.
End Rem
Type dSNodeException
	
	Const ParserError:Int = 1
	Const HierarchyError:Int = 2
	Const MemoryAllocationError:Int = 3
	
	Field m_error:Int, m_reporter:String
	Field m_message:String
	Field m_token:dSNodeToken, m_parser:dSNodeParser
	
	Method New()
	End Method
	
	Rem
		bbdoc: Create a new dSNodeException.
		returns: The new dSNodeException (itself).
	End Rem
	Method Create:dSNodeException(error:Int, reporter:String, message:String, token:dSNodeToken = Null, parser:dSNodeParser = Null)
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
		If m_token <> Null And m_parser <> Null
			Return "(" + m_reporter + ") [" + ErrorToString(m_error) + "] from " + m_token.LineRep() + " to " + m_parser.LineRep() + ": " + m_message
		End If
		If m_token <> Null
			Return "(" + m_reporter + ") [" + ErrorToString(m_error) + "] at " + m_token.LineRep() + ": " + m_message
		Else If m_parser <> Null
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
			Case ParserError
				Return "ParserError"
			Case HierarchyError
				Return "HierarchyError"
			Default
				Return "UNKNOWN"
		End Select
	End Function
	
End Type

