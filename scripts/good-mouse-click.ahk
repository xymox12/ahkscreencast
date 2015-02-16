; released under Terms of EUPL 1.0
; (w) by derRaphael Dec 01, 2008

CoordMode, Mouse, Screen
SetBatchLines,-1
#Include Gdip.ahk
If !(pToken := Gdip_Startup()) {
   MsgBox, 48, gdiplus error!, Gdiplus failed to start. Please ensure you have gdiplus on your system
   ExitApp
}

SysGet, MonitorPrimary, MonitorPrimary
SysGet, WA, MonitorWorkArea, %MonitorPrimary%
WAWidth := WARight-WALeft
WAHeight := WABottom-WATop

Gui, 1: -Caption +E0x80000 +LastFound +AlwaysOnTop +ToolWindow +OwnDialogs
Gui, 1: Show, NA
mhWnd := WinExist()

mWidth := mHeight := 80
mhbm := CreateDIBSection(mWidth, mHeight), mhdc := CreateCompatibleDC()
mobm := SelectObject(mhdc, mhbm), mG := Gdip_GraphicsFromHDC(mhdc)

Gdip_SetSmoothingMode(mG, 4)

mFadeMax    := 0xff
mDiaMax     := 60
mDiaMin     := 6
mDiaSteps   := 2
mDiameter   := mDiaMin

mAlphaSteps := mFadeMax//((mDiaMax-mDiaMin)/mDiaSteps)
mAlpha      := mFadeMax

return

*~lButton::
   mBaseColor  := 0xff0000
   Gosub, TriggerMouseRing
Return

*~rButton::
   mBaseColor  := 0x00a000
   Gosub, TriggerMouseRing
Return

TriggerMouseRing:
   SetTimer,mouseRing,OFF
   MouseGetPos,MX,MY
   mDiameter := mDiaMin
   mAlpha   := mFadeMax
   SetTimer,mouseRing,7
return

mouseRing:
   mDiameter += mDiaSteps         ; update Diameter
   GoSub, MouseRingErase          ; delete previous drawn ring
   mPen:=Gdip_CreatePen(((mAlpha-=mAlphaSteps)<<24)+mBaseColor, 2)
   Gdip_DrawEllipse(mG, mPen,0,0,mDiameter-1,mDiameter-1)
   Gdip_DeletePen(mPen)
   UpdateLayeredWindow(mhWnd, mhdc, MX-mDiameter//2, MY-mDiameter//2, mDiameter+5, mDiameter+5)
   if (mDiameter>=mDiaMax) {
      GoSub, MouseRingDestroy
   }
return

mouseRingDestroy:
   SetTimer,mouseRing,Off
   GoSub, MouseRingErase
   mDiameter := mDiaMin, mAlpha := mFadeMax
   UpdateLayeredWindow(mhWnd, mhdc, MX-mDiameter//2, MY-mDiameter//2, mDiameter+5, mDiameter+5)
return

mouseRingErase:
   Gdip_SetCompositingMode(mG, 1)              ; set overdraw
   mBrush := Gdip_BrushCreateSolid(0x00000000) ; fully transparent brush 'eraser'
   Gdip_FillRectangle(mG, mBrush, 0, 0, mDiameter+10, mDiameter+10)
   Gdip_DeleteBrush(mBrush)
   Gdip_SetCompositingMode(mG, 0)              ; switch off overdraw
return

esc::exitapp
^r::reload

; uncomment if gdip is not in ur standard library
