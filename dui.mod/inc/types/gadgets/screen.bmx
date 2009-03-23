
' 
' screen.bmx (Contains: dui_TScreen, )
' 
' 

Rem
	bbdoc: The dui screen Type.
End Rem
Type dui_TScreen
	
	Field name:String, family:String
	Field children:TList = New TList
		
		Rem
			bbdoc: Create a screen.
			returns: The created screen (itself).
		End Rem
		Method Create:dui_TScreen(_name:String, _family:String = "")
			
			SetName(_name)
			SetFamily(_family)
			
			TDUIMain.AddScreen(Self)
			
			Return Self
			
		End Method
		
		Rem
			bbdoc: Render the screen.
			returns: Nothing.
		End Rem
		Method Render()
			Local _gadget:dui_TGadget
			
			For _gadget = EachIn children
				
				_gadget.Render(0.0, 0.0)
				
			Next
			
		End Method
		
		Rem
			bbdoc: Update the screen and it's children.
			returns: Nothing.
		End Rem
		Method Update()
			Local _gadget:dui_TGadget
			
			For _gadget = EachIn New TListReversed.Create(children)
				
				_gadget.Update(0, 0)
				
			Next
			
		End Method
		
		Rem
			bbdoc: Add a gadget to the screen.
			returns: Nothing.
		End Rem
		Method AddGadget(_gadget:dui_TGadget)
			
			If _gadget <> Null
				children.AddLast(_gadget)
			End If
			
		End Method
		
		Rem
			bbdoc: Get a panel from the screen by it's name.
			returns: A panel by the name given, or Null if there is not a panel by that name.
		End Rem
		Method GetPanelByName:dui_TPanel(_name:String)
			
			Return dui_TPanel(GetGadgetByName(_name))
			
		End Method
		
		Rem
			bbdoc: Get a gadget from the screen by it's name.
			returns: A gadget by the name given, or Null if there is not a gadget by that name.
		End Rem
		Method GetGadgetByName:dui_TGadget(_name:String)
			Local gadget:dui_TGadget
			
			If name <> Null
				
				_name = _name.ToLower()
				
				For gadget = EachIn children
					
					If gadget.GetName().ToLower() = _name
						Return gadget
					End If
					
				Next
				
			End If
			
			Return Null
			
		End Method
		
		Rem
			bbdoc: Set the name of the screen
			returns: Nothing.
		End Rem
		Method SetName(_name:String)
			
			name = _name
			
		End Method
		
		Rem
			bbdoc: Get the name of the screen.
			returns: The screen's name.
		End Rem
		Method GetName:String()
			
			Return name
			
		End Method
		
		Rem
			bbdoc: Set the family of the screen.
			returns: Nothing.
		End Rem
		Method SetFamily(_family:String)
			
			family = _family
			
		End Method
		
		Rem
			bbdoc: Get the family of the screen.
			returns: The screen's family.
		End Rem
		Method GetFamily:String()
			
			Return family
			
		End Method
		
End Type



























	