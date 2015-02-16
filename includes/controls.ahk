SettingsGui:
; Controls - Created by EC
Menu, FileMenu, Add, Save &As, FileSaveAs
Menu, MyMenuBar, Add, &File, :FileMenu
; Attach the menu bar to the window:
Gui, 3: Menu, MyMenuBar
Gui, 3: Font, s12, Verdana
Gui, 3: Add, Text,, Capture Controls
Gui, 3: font, s8, Arial
Gui, 3: Add, GroupBox,x20 y40 w200 h170, Capture size
Gui, 3: Add, Radio,vRadioSize  xp+10 yp+30 w170 h30, Desktop
Gui, 3: Add, Radio, xp yp+30 w170 h30, 1280x720
Gui, 3: Add, Radio, xp yp+30 w170  h30 Checked , 720x576
Gui, 3: Add, Button, gShowBox, Display box

Gui, 3: Add, GroupBox, x252 y60 w200 h140 , Position
Gui, 3: Add, Radio,vRadioPos xp+10 yp+30 w170 h30 Checked , Desktop Centre
Gui, 3: Add, Radio, xp yp+30 w170 h30 vRadioPos2, Top Left
Gui, 3: Add, Radio, xp yp+30 w170 h30 vRadioPos3, Bottom Left

Gui, 3: Add, GroupBox, x20 y+40 w200 h160 , Settings
Gui, 3: Add, DropDownList,xp+10 yp+40 vBitrate, 350|700|1200||2500|5000
Gui, 3: Add, DropDownList,xp yp+40 vFramerate, 10||12|25|50
Gui, 3: Add, DropDownList,xp yp+40 vScale, 0.25|0.5|0.75|1||

Gui, 3: Add, Button, x252 y200 w140 gStart, Start
Gui, 3: Add, Button, wp gStop, Stop
Gui, 3: Add, Button, wp gExit, Exit

; Generated using SmartGUI Creator for SciTe

Gui, 3: Show, w479 h379, AHK ScreenCast
return


; Subroutines


Start:
Gui, Submit, NoHide
Gosub, Launch 
return

FileSaveAs:
Gui +OwnDialogs  ; Force the user to dismiss the FileSelectFile dialog before returning to the main window.
FileSelectFile, SelectedFileName, S16,, Save File, MP4 Documents (*.mp4)
if SelectedFileName =  ; No file selected.
    return
CurrentFileName := SelectedFileName
return

ShowBox:
ControlGet sizeA,Checked,,Desktop
ControlGet sizeB,Checked,,1280x720
	Gdip_Shutdown(pToken)
If sizeA = 1 
{
    XMargin := 0, YMargin := 0
}
else if sizeB = 1
{
    VideoX := 1280, VideoY := 720
	XMargin := (A_ScreenWidth-VideoX)/2
	YMargin := (A_ScreenHeight-VideoY)/2
	Gdip_Shutdown(pToken)
	pToken := box(VideoX,VideoY,thickness)
}
else 
{
    VideoX := 640, VideoY := 360
	XMargin := (A_ScreenWidth-VideoX)/2
	YMargin := (A_ScreenHeight-VideoY)/2
	Gdip_Shutdown(pToken)
	pToken := box(VideoX,VideoY,thickness)
}

return

Exit:
Gdip_Shutdown(pToken)
ExitApp

GuiEscape:
Gui, Destroy
Gdip_Shutdown(pToken)
return

GuiClose:
gui, Destroy
Gdip_Shutdown(pToken)
return

Stop:
r := WinHttpRequest("http://127.0.0.1:8080/requests/status.xml?command=pl_stop", InOutData := "", InOutHeaders := "", "Timeout: 1`nNO_AUTO_REDIRECT")
MsgBox, % (r = -1) ? "successful" : (r = 0) ? "Timeout" : "No response"
WinClose, VLC media player ahk_class QWidget
Return


Esc::
; gdi+ may now be shutdown on exiting the program
Gdip_Shutdown(pToken)
ExitApp



