
Rem
	texture.bmx (Contains: duiTexture, )
End Rem

Rem
	bbdoc: duct ui texture gadget.
End Rem
Type duiTexture Extends duiGadget
	
	Field m_texture:dProtogTexture
	
	Rem
		bbdoc: Create a texture gadget.
		returns: Itself.
		about: @url can be either a string or a dProtogTexture.
	End Rem
	Method Create:duiTexture(name:String, url:Object, x:Float, y:Float, w:Float, h:Float, parent:duiGadget)
		_Init(name, x, y, w, h, parent, False)
		LoadTexture(url)
		Return Self
	End Method
	
'#region Render & update methods
	
	Rem
		bbdoc: Render the texture gadget.
		returns: Nothing.
	End Rem
	Method Render(x:Float, y:Float)
		If IsVisible() = True
			If m_texture <> Null
				BindDrawingState()
				m_texture.Bind()
				m_texture.Render(New dVec4.Create(m_x, m_y, m_width, m_height))
				m_texture.UnBind()
			End If
			Super.Render(x, y)
		End If
	End Method
	
'#end region (Render & update methods)
	
'#region Field accessors
	
	Rem
		bbdoc: Set the texture gadget's dimensions.
		returns: Nothing.
		about: If a (width or height) dimension is -1.0 it will use the dimension of the texture (if the texture has not been set it will default to (128.0, 128.0)).
	End Rem
	Method SetSize(width:Float, height:Float, dorefresh:Int = True)
		If width = -1.0
			If m_texture <> Null
				width = m_texture.m_width
			Else
				width = 128.0
			End If
		End If
		
		If height = -1.0
			If m_texture <> Null
				height = m_texture.m_height
			Else
				height = 128.0
			End If
		End If
		
		m_width = width
		m_height = height
	End Method
	
	Rem
		bbdoc: Set the gadget's texture.
		returns: Nothing.
	End Rem
	Method SetTexture(texture:dProtogTexture)
		If texture <> Null
			m_texture = texture
			SetSize(m_texture.m_width, m_texture.m_height)
		End If
	End Method
	
	Rem
		bbdoc: Get the texture for the gadget.
		returns: The gadget's texture (can be Null).
	End Rem
	Method GetTexture:dProtogTexture()
		Return m_texture
	End Method
	
	Rem
		bbdoc: Load the gadget's texture.
		returns: Nothing.
		about: If @url is %not a #dProtogTexture, it will be passed off to #LoadPixmap (from which the texture will be set).
	End Rem
	Method LoadTexture(url:Object, textureflags:Int = 0)
		Local texture:dProtogTexture
		
		texture = dProtogTexture(url)
		If texture = Null
			texture = New dProtogTexture.Create(LoadPixmap(url), textureflags)
		End If
		SetTexture(texture)
	End Method
	
'#end region (Field accessors)
	
End Type

