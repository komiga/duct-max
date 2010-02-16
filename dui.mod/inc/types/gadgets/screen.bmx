
Rem
	screen.bmx (Contains: dui_Screen, )
End Rem

Rem
	bbdoc: The dui screen type.
End Rem
Type dui_Screen
	
	Field m_name:String, m_family:String
	Field m_children:TListEx = New TListEx
	
	Rem
		bbdoc: Create a screen.
		returns: The created screen (itself).
	End Rem
	Method Create:dui_Screen(name:String, family:String = "")
		SetName(name)
		SetFamily(family)
		
		TDUIMain.AddScreen(Self)
		
		Return Self
	End Method
	
'#region Render & update
	
	Rem
		bbdoc: Render the screen.
		returns: Nothing.
	End Rem
	Method Render()
		Local gadget:dui_Gadget
		
		For gadget = EachIn m_children
			gadget.Render(0.0, 0.0)
		Next
	End Method
	
	Rem
		bbdoc: Update the screen and it's children.
		returns: Nothing.
	End Rem
	Method Update()
		Local gadget:dui_Gadget
		
		For gadget = EachIn New TListReversed.Create(m_children)
			gadget.Update(0, 0)
		Next
	End Method
	
'#end region (Render & update)
	
'#region Field accessors
	
	Rem
		bbdoc: Set the name of the screen
		returns: Nothing.
	End Rem
	Method SetName(name:String)
		m_name = name
	End Method
	
	Rem
		bbdoc: Get the name of the screen.
		returns: The screen's name.
	End Rem
	Method GetName:String()
		Return m_name
	End Method
	
	Rem
		bbdoc: Set the family of the screen.
		returns: Nothing.
	End Rem
	Method SetFamily(family:String)
		m_family = family
	End Method
	
	Rem
		bbdoc: Get the family of the screen.
		returns: The screen's family.
	End Rem
	Method GetFamily:String()
		Return m_family
	End Method
	
'#end region (Field accessors)
	
'#region Collections
	
	Rem
		bbdoc: Add a gadget to the screen.
		returns: Nothing.
	End Rem
	Method AddGadget(gadget:dui_Gadget)
		If gadget <> Null
			m_children.AddLast(gadget)
		End If
	End Method
	
	Rem
		bbdoc: Get a panel from the screen by it's name.
		returns: A panel by the name given, or Null if there is not a panel by that name.
	End Rem
	Method GetPanelByName:dui_Panel(name:String)
		Return dui_Panel(GetGadgetByName(name))
	End Method
	
	Rem
		bbdoc: Get a gadget from the screen by it's name.
		returns: A gadget by the name given, or Null if there is not a gadget by that name.
	End Rem
	Method GetGadgetByName:dui_Gadget(name:String)
		Local gadget:dui_Gadget
		
		If name <> Null
			name = name.ToLower()
			For gadget = EachIn m_children
				If gadget.GetName().ToLower() = name
					Return gadget
				End If
			Next
		End If
		Return Null
	End Method
	
'#end region (Collections)
	
End Type

