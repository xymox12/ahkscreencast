;----------------------------------------------------------------
; AutoHotkey Version: 1.x
; Language:       English
; Author:         Lowell Heddings <geek@howtogeek.com>
; Description:    Resize Active Window
;
;----------------------------------------------------------------
;  EXAMPLES
;----------------------------------------------------------------
; Note: all examples using Alt+Win+U as the hotkey
;
;----------------------------------------------------------------
#NoEnv
SetBatchLines, -1

#!u::
    InputBox, width, Resize window, Enter width:, , 170, 130, , , , , 640
    if (width != "")
    {
        InputBox, height, Resize Window, Enter height:, , 170, 130
    }
  WinGetPos,X,Y,W,H,A
  Xmargin := (A_ScreenWidth-width)/2
  YMargin := (A_ScreenHeight-height)/2
  WinMove,A,,%Xmargin%,%Ymargin%,%width%,%height%
  
EXit