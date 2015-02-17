#Include, Gdip.ahk
PenColor := 0xffff0000   ; red
PenWidth := 2            ; 2 pixels
Radius   := 10           ; 10 pixels

ExcludedClasses := ",TaskListThumbnailWnd,Shell_TrayWnd,DV2ControlHost"

If !(pToken := Gdip_Startup())
{
   MsgBox, 48, Gdip Error!, Gdip failed to start.`nPlease ensure you have Gdip on your system.
   ExitApp
}
OnExit, Exit
Gui, +AlwaysOnTop -Caption +Owner +E0x80000 +HwndhWnd
Gui, Show, NA
hbm := CreateDIBSection(A_ScreenWidth, A_ScreenHeight)
hdc := CreateCompatibleDC()
obm := SelectObject(hdc, hbm)
G := Gdip_GraphicsFromHDC(hdc)
pPen := Gdip_CreatePen(PenColor, PenWidth)
SetTimer, Check, 10
Check:
WinGetClass, Class, A
if Class in %ExcludedClasses%   ; If the window class is not a normal class ...
   Return                       ; Don't do anything
WinGetPos, xx, yy, ww, hh, A
if (x != xx) or (y != yy) or (w != ww) or (h != hh)
{
   x := xx, y := yy, w := ww, h := hh
   Gdip_GraphicsClear(G)
   WinGetPos, , , TrayWidth, TrayHeight, ahk_class Shell_TrayWnd
   if ((TrayWidth = A_ScreenWidth AND (ww < A_ScreenWidth OR hh < A_ScreenHeight-TrayHeight))
   OR (TrayHeight = A_ScreenHeight AND (ww < A_ScreenWidth-TrayWidth OR hh < A_ScreenHeight)))
      Gdip_DrawRoundedRectangle(G, pPen, xx, yy, ww, hh, Radius)
   UpdateLayeredWindow(hWnd, hdc, 0, 0, A_ScreenWidth, A_ScreenHeight)
}
Return

Esc::   ; Press Esc to exit
Exit:
SelectObject(hdc, obm)
DeleteObject(hbm)
DeleteDC(hdc)
Gdip_DeletePen(pPen)
Gdip_DeleteGraphics(G)
Gdip_Shutdown(pToken)
ExitApp