
' 
' tlistreversed.bmx (Contains: TListReversedEnum, TListReversed, )
' 
' 

Type TListReversedEnum Extends TListEnum
	
	Method HasNext:Int()
		
		Return _link._value <> _link
		
	End Method
	
	Method NextObject:Object()
	  Local value:Object = _link._value
		
		Assert value <> _link
		
		_link = _link._pred
		
		Return value
		
	End Method
	
End Type

Rem
	bbdoc: The TListReversed Type
	about: Understood to be Public Domain, thanks to Merx and more specifically (for this bit) Brucey.
	Thread: http://www.blitzbasic.com/Community/posts.php?topic=82916
End Rem
Type TListReversed Extends TList
	
	Field _orighead:TLink
	
		Method Delete()
			
			_head = _orighead
			
		End Method
		
		Rem
			bbdoc: Create a TListReversed
			returns: A TListReversed object (wrapped around @list)
		End Rem
		Method Create:TListReversed(_list:TList)
			
			_orighead = _head
			_head = _list._head._pred
			
			Return Self
			
		End Method
		
		Method ObjectEnumerator:TListEnum()
			Local enum:TListReversedEnum = New TListReversedEnum
			
			enum._link = _head
			
			Return enum
			
		End Method
		
End Type







