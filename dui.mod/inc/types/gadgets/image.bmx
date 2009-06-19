
Rem
	image.bmx (Contains: dui_TImage, )
End Rem

Rem
	bbdoc: The dui image gadget type.
End Rem
Type dui_TImage Extends dui_TGadget
	
	Field gImage:TImage
		
		Rem
			bbdoc: Create a image gadget.
			returns: Nothing.
			about: @_url can be either a string or a TImage.
		End Rem
		Method Create:dui_TImage(_name:String, _url:Object, _x:Float, _y:Float, _w:Float, _h:Float, _parent:dui_TGadget)
			
			PopulateGadget(_name, _x, _y, _w, _h, _parent)
			
			LoadImage(_url)
			
			Return Self
			
		End Method
		
		Rem
			bbdoc: Render the image gadget.
			returns: Nothing.
		End Rem
		Method Render(_x:Float, _y:Float)
			'Local rX:Float, rY:Float
			
			If IsVisible() = True
				
				'rX = gX + _x
				'rY = gY + _y
				
				If GetImage() <> Null
					SetDrawingState()
					DrawImageRect(GetImage(), gX + _x, gY + _y, gW, gH)
				End If
				
				Super.Render(_x, _y)
				
			End If
			
		End Method
		
		Rem
			bbdoc: Set the image gadget's dimensions.
			returns: Nothing.
			about: If a (width or height) dimension is 0.0 it will use the dimension of the image (if the image has not been set it will default to 256.0, 256.0).
		End Rem
		Method SetDimensions(_w:Float, _h:Float, _dorefresh:Int = True)
			
			If _w = 0.0
				If GetImage() <> Null
					_w = GetImage().width
				Else
					_w = 256.0
				End If
			End If
			
			If _h = 0.0
				If GetImage() <> Null
					_h = GetImage().height
				Else
					_h = 256.0
				End If
			End If
			
			gW = _w
			gH = _h
			
		End Method
		
		Rem
			bbdoc: Set the gadget's image.
			returns: Nothing.
		End Rem
		Method SetImage(_image:TImage)
			
			If _image <> Null
				gImage = _image
				SetDimensions(0.0, 0.0)
			End If
			
		End Method
		
		Rem
			bbdoc: Get the image for the gadget.
			returns: The gadget's image (might be Null if it has not yet been set).
		End Rem
		Method GetImage:TImage()
			
			Return gImage
			
		End Method
		
		Rem
			bbdoc: Load the gadget's image.
			returns: Nothing.
			about: This will set the gadget's image to TImage( @_url ) or set it by loading @_url as an image (if it is a string).
		End Rem
		Method LoadImage(_url:Object)
			Local _image:TImage
			
			_image = TImage(_url)
			If _image = Null And String(_url)
				_image = brl.max2d.LoadImage(String(_url))
			End If
			
			SetImage(_image)
			
		End Method
		
End Type


























