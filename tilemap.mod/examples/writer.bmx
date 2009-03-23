
SuperStrict

Framework brl.standardio
Import brl.random

Import brl.stream
Import brl.filesystem

Import brl.glmax2d
Import brl.pngloader
Import brl.bmploader

Import duct.TileMap
Import duct.memcrypt


'SetGraphicsDriver(GLMax2DDriver())
'Graphics 240, 470

Global deftile:TMapTileResource = New TMapTileResource.Create(0, "default", Null)

Local map:TTileMap = New TTileMap.Create("map_test", 144, 144, Null, Null)
Local hmap:TPixmap = LoadPixmap("tiles/heightmap_small.bmp")

'map = HeightMapToTileMap(hmap)

Local crow:Int, ccolumn:Int
For crow = 0 To map.GetHeight() - 1
	
	For ccolumn = 0 To map.GetWidth() - 1
		
		'map.SetTileAtPos(New TDrawnTile.Create(Rand(0, 5), Rand(- 10, 15)), ccolumn, crow)
		map.SetTileAtPos(New TDrawnTile.Create(3, 0), ccolumn, crow)
		
	Next
	
Next

map.AddStaticToPos(New TDrawnStatic.Create(1, 0), 7, 10)
map.AddStaticToPos(New TDrawnStatic.Create(1, 0), 8, 10)
map.AddStaticToPos(New TDrawnStatic.Create(1, 0), 9, 10)

map.AddStaticToPos(New TDrawnStatic.Create(0, 0), 10, 10)
map.AddStaticToPos(New TDrawnStatic.Create(0, 0), 11, 10)

map.AddStaticToPos(New TDrawnStatic.Create(0, 20), 10, 10)
map.AddStaticToPos(New TDrawnStatic.Create(0, 20), 11, 10)

map.AddStaticToPos(New TDrawnStatic.Create(2, 0), 11, 9)
map.AddStaticToPos(New TDrawnStatic.Create(2, 0), 10, 9)
map.AddStaticToPos(New TDrawnStatic.Create(2, 0), 11, 8)
map.AddStaticToPos(New TDrawnStatic.Create(2, 0), 10, 8)
map.AddStaticToPos(New TDrawnStatic.Create(2, 0), 11, 7)
map.AddStaticToPos(New TDrawnStatic.Create(2, 0), 10, 7)
map.AddStaticToPos(New TDrawnStatic.Create(2, 0), 10, 6)

Rem
'Top!
For Local dtile:TDrawnTile = EachIn map.data_rows[0]
	
	dtile.setHeight(20)
	
Next

'Right!
For Local col:TDrawnTile[] = EachIn map.data_rows
	
	col[map.getWidth() - 1].setHeight(20)
	
Next

'Bottom!
For Local dtile:TDrawnTile = EachIn map.data_rows[map.GetHeight() - 1]
	
	dtile.setHeight(20)
	
Next

'Left!
For Local col:TDrawnTile[] = EachIn map.data_rows
	
	col[0].setHeight(20)
	
Next
End Rem

Local stream:TBankStream = CreateBankStream(Null)
	
	map.Serialize(stream)
	
	'CryptStream(stream, "tppwry[srko[,wy[,lhrop30-i956cgughjjfuiohsaf9kq45y-jawethjsfhjtulp6-jk9089rbt")
	stream._bank.Save("map_test.map")
	
stream.Close()


Function HeightMapToTileMap:TTileMap(_hmap:TPixmap)
	Local x:Int, y:Int, pixel:Byte
	Local _map:TTileMap
	
	_map = New TTileMap.Create("map_test", _hmap.width, _hmap.height, Null, Null, 3, 0)
	
	Print(_map.width + ", " + _map.height)
	
	For y = 0 To _hmap.height - 1
		
		For x = 0 To _hmap.width - 1
			
			pixel = _hmap.ReadPixel(x, y)
			
			'_map.data_terrain[y, x].SetResourceID(3)
			_map.data_terrain[y, x].SetZ((Int(pixel) * 100) / 255)
			
		Next
		
	Next
	
	Return _map
	
End Function



























