
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

SuperStrict

Rem
bbdoc: Application argument handling
End Rem
Module duct.arghandling

ModuleInfo "Version: 0.1"
ModuleInfo "Copyright: Tim Howard"
ModuleInfo "License: MIT"

ModuleInfo "History: Version 0.1"
ModuleInfo "History: Initial release"

Import duct.objectmap
Import duct.variables

Rem
	bbdoc: duct argument handler.
End Rem
Type dArgumentHandler Extends dObjectMap
	
	Rem
		bbdoc: Create a new dArgumentHandler.
		returns: Itself.
	End Rem
	Method Create:dArgumentHandler()
		Return Self
	End Method
	
	Rem
		bbdoc: Add an alias for the given argument implementation.
		returns: Nothing.
	End Rem
	Method AddArgImplAlias(als:String, argimpl:dArgumentImplementation)
		Assert als, "(dArgumentHandler.AddArgImplAlias) als = Null"
		_Insert(als, argimpl)
	End Method
	
	Rem
		bbdoc: Add all of the aliases from the given argument implementation.
		returns: Nothing.
	End Rem
	Method AddArgImpl(argimpl:dArgumentImplementation)
		If argimpl.GetAliases() <> Null
			For Local als:String = Eachin argimpl.GetAliases()
				AddArgImplAlias(als, argimpl)
			Next
		End If
	End Method
	
	Rem
		bbdoc: Get an argument implementation from the given alias.
		returns: The argument implementation with the given alias, or Null (not found).
	End Rem
	Method GetArgImplWithAlias:dArgumentImplementation(als:String)
		Assert als, "(dArgumentHandler.GetArgImplWithAlias) als = Null"
		Return dArgumentImplementation(_ValueByKey(als))
	End Method
	
End Type

Rem
	bbdoc: duct argument call conventions.
End Rem
Type dCallConvention
	Rem
		bbdoc: For arguments as options (e.g. '--help').
	End Rem
	Const OPTION:Int = 1
	Rem
		bbdoc: For arguments as commands (e.g. 'help').
	End Rem
	Const COMMAND:Int = 2
End Type

Rem
	bbdoc: duct argument implementation.
End Rem
Type dArgumentImplementation Abstract
	
	Field m_callconv:Int
	Field m_args:dIdentifier, m_argcount:Int
	Field m_aliases:String[]
	
	Rem
		bbdoc: Initiation method for extending types.
		returns: Nothing.
	End Rem
	Method init(aliases:String[])
		m_aliases = aliases
	End Method
	
'#region Field accessors
	
	Rem
		bbdoc: Get the aliases for this implementation.
		returns: The argument implementation's aliases.
	End Rem
	Method GetAliases:String[]()
		Return m_aliases
	End Method
	
	Rem
		bbdoc: Set the implementation's arguments.
		returns: Nothing.
	End Rem
	Method SetArgs(args:dIdentifier)
		m_args = args
		m_argcount = m_args.GetValueCount()
	End Method
	
	Rem
		bbdoc: Get the argument's argument count (number of arguments passed to the command/option).
		returns: The argument count.
	End Rem
	Method GetArgumentCount:Int()
		Return m_argcount
	End Method
	
	Rem
		bbdoc: Set the call convention.
		returns: Nothing.
		about: Options (e.g. '--help') should be dCallConvention.OPTION, and commands (e.g. 'help') should be dCallConvention.COMMAND.
	End Rem
	Method SetCallConvention(callconv:Int)
		m_callconv = callconv
	End Method
	
	Rem
		bbdoc: Get the current call convention.
		returns: The call convention (dCallConvention.OPTION for options, and dCallConvention.COMMAND for commands).
	End Rem
	Method GetCallConvention:Int()
		Return m_callconv
	End Method
	
'#end region Field accessors
	
	Rem
		bbdoc: Check if the argument implementation has the given alias.
		returns: True if the given alias was found, or False if it was not.
	End Rem
	Method HasAlias:Int(als:String)
		For Local al:String = EachIn m_aliases
			If als = al
				Return True
			End If
		Next
		Return False
	End Method
	
	Rem
		bbdoc: Check the current arguments for errors (according to the specific implementation).
		returns: Nothing.
		about: This method should throw an error if the arguments are invalid.<br>
		This method is abstract.
	End Rem
	Method CheckArgs() Abstract
	
	Rem
		bbdoc: Get a string describing the typical usage of the argument.
		returns: A string describing the typical usage of the argument.
		about: This method is abstract.
	End Rem
	Method GetUsage:String() Abstract
	
	Rem
		bbdoc: Execute the implementation's operation.
		returns: Nothing.
		about: This method is abstract.
	End Rem
	Method Execute() Abstract
	
End Type

