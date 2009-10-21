
Rem
	Copyright (c) 2009 Tim Howard
	
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
	-----------------------------------------------------------------------------
	
	cache.bmx (Contains: TTileMapDrawCache, )
	
End Rem

Rem
	bbdoc: The TileMapDrawCache type.
	about: This type provides a drawing cache (list of in-view items) for the TileMap type.
End Rem
Type TTileMapDrawCache
	
	Field m_cachelist:TListEx
	
	Method New()
		m_cachelist = New TListEx
	End Method
	
	Rem
		bbdoc: Create a new TileMapDrawCache.
		returns: The new TileMapDrawCache (itself).
	End Rem
	Method Create:TTileMapDrawCache()
		Return Self
	End Method
	
	Rem
		bbdoc: Add a chunk to the draw cache.
		returns: Nothing.
	End Rem
	Method AddChunk(chunk:TDrawnTileChunk)
		
	End Method
	
	Rem
		bbdoc: 
		returns: Nothing.
	End Rem
	Method CheckObjectDistances(index:Int, player:TTileMapPlayer)
		Local chunk:TDrawnTileChunk
		Local tile:TDrawnTile
		
		chunk = GetObjectWithoutLoad(index)
		
		If chunk <> Null
			For tile = EachIn chunk.m_objects
				UObject = TUObject(list.Items[I])
				If UObject.Pos.IsInRechteckRange(player.m_pos, player.m_visrange) = False
					UObject.Free()
				End If
			Next
			list.Free()
		End If
		
	End Method
	
End Type








