
' Test the duct.graphix module.

SuperStrict

Framework brl.blitz
Import brl.standardio

Import duct.app
Import duct.graphix
Import duct.Input

Global mainapp:TTestApp = New TTestApp.Create()
mainapp.Run()

Type TTestApp Extends TDApp
	
	Field m_graphics:TDGraphics
	
	Method Create:TTestApp()
		Super.Create()
		Return Self
	End Method
	
	Method OnInit()
		m_graphics = New TDGraphics.Create(DGFX_DRIVER_OGL, 800, 600)
		m_graphics.StartGraphics()
	End Method
	
	Method Run()
		SetBlend(ALPHABLEND)
		While AppTerminate() = False And KeyHit(KEY_ESCAPE) = False
			'm_graphics.Cls()
			Blur(0.01)
			DrawRect(MouseX() - 16, MouseY() - 16, 32.0, 32.0)
			m_graphics.Flip()
			Delay(20)
		Wend
	End Method
	
	Method Blur(alpha:Float)
		Local lalpha:Float, lc_red:Int, lc_green:Int, lc_blue:Int
		
		lalpha = GetAlpha()
		GetColor(lc_red, lc_green, lc_blue)
		
		SetAlpha(alpha)
		SetColor(0, 0, 0)
		DrawRect(0, 0, m_graphics.m_width, m_graphics.m_height)
		SetColor(lc_red, lc_green, lc_blue)
		SetAlpha(lalpha)
	End Method
	
End Type

