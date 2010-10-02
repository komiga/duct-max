
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

Rem
	bbdoc: duct ui screen.
End Rem
Type duiScreen
	
	Field m_name:String, m_family:String
	Field m_children:TListEx = New TListEx
	
	Rem
		bbdoc: Create a screen.
		returns: Itself.
	End Rem
	Method Create:duiScreen(name:String, family:String = "")
		SetName(name)
		SetFamily(family)
		duiMain.AddScreen(Self)
		Return Self
	End Method
	
'#region Render & update
	
	Rem
		bbdoc: Render the screen.
		returns: Nothing.
	End Rem
	Method Render()
		For Local gadget:duiGadget = EachIn m_children
			gadget.Render(0.0, 0.0)
		Next
	End Method
	
	Rem
		bbdoc: Update the screen and it's children.
		returns: Nothing.
	End Rem
	Method Update()
		For Local gadget:duiGadget = EachIn New TListReversed.Create(m_children)
			gadget.Update(0, 0)
		Next
	End Method
	
'#end region Render & update
	
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
	
'#end region Field accessors
	
'#region Collections
	
	Rem
		bbdoc: Add a gadget to the screen.
		returns: Nothing.
	End Rem
	Method AddGadget(gadget:duiGadget)
		If gadget
			m_children.AddLast(gadget)
		End If
	End Method
	
	Rem
		bbdoc: Get a panel with the given name.
		returns: A panel with the given name, or Null if the screen does not have a panel with the name given.
	End Rem
	Method GetPanelWithName:duiPanel(name:String)
		Return duiPanel(GetGadgetWithName(name))
	End Method
	
	Rem
		bbdoc: Get a gadget with the given name.
		returns: A gadget with the given name, or Null if the screen does not have a panel with the name given.
	End Rem
	Method GetGadgetWithName:duiGadget(name:String)
		If name
			name = name.ToLower()
			For Local gadget:duiGadget = EachIn m_children
				If gadget.GetName().ToLower() = name
					Return gadget
				End If
			Next
		End If
		Return Null
	End Method
	
'#end region Collections
	
End Type

