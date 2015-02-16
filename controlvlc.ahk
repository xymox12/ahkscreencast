#SingleInstance, Force
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
;SetBatchLines, -1

;Global Variables
VideoX := 640, VideoY := 360, thickness := 20
ImageFolder := A_ScriptDir . "\assets\images"
MousePointerImg := ImageFolder . "\pointer.png" 
;Margins of centered box
Xmargin := (A_ScreenWidth-VideoX)/2
YMargin := (A_ScreenHeight-VideoY)/2
;Default filename
FormatTime, TimeString, ,yyyyMMddHHmmss
CurrentFileName := "capture-" . TimeString  . ".mp4"
; Default video
Framerate := 10
VideoSize :=
Bitrate := 1200
Scale := 1

gosub, SettingsGui

return
; End of Main


; Launch VLC
Launch:
;Minimize settings gui
;Gui, 3: Hide

;Set variables
If RadioSize = 1 
{
    XMargin := 0, YMargin := 0
	Gdip_Shutdown(pToken)
}
else if RadioSize = 2
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

; Create Overlay Box


Run, vlc208\VLCPortable.exe screen:// --http-host localhost --http-port 8080  :screen-fps=%Framerate% :live-caching=0 :screen-follow-mouse :screen-mouse-image=%MousePointerImg% :sout="#transcode{vcodec=h264`,vb=%Bitrate%`,fps=%Framerate%`,scale=%Scale%`,acodec=mpga`,ab=128`,vfilter=croppadd{cropright=%XMargin%`,croptop=%YMargin%`,cropbottom=%YMargin%`,cropleft=%XMargin%}}:file{mux=mp4`,dst=%CurrentFileName%}"
Return
; End of Launch

; Includes
#include %A_ScriptDir%\includes\httpQuery.ahk
#include %A_ScriptDir%\includes\Gdip.ahk
#include %A_ScriptDir%\includes\Gdip_box.ahk
#Include %A_ScriptDir%\includes\controls.ahk