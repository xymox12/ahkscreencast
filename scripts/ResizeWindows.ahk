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
; #!u::ResizeWin(800,600)
;    - Resize a window to 800 width by 600 height
;
; #!u::ResizeWin(640)
;    - Resize a window to 640 width, leaving the height the same
;
; #!u::ResizeWin(0,600)
;    - Resize a window to 600 height, leaving width the same
;
;----------------------------------------------------------------
#NoEnv
SetBatchLines, -1

ResizeWin(Width = 0,Height = 0)
{
  WinGetPos,X,Y,W,H,A
  If %Width% = 0
    Width := W

  If %Height% = 0
    Height := H

  WinMove,A,,%X%,%Y%,%Width%,%Height%
}

#!u::ResizeWin(1280,720)