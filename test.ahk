; #NoEnv
; #SingleInstance, Force
; SendMode, Input
; SetBatchLines, -1
; SetWorkingDir, %A_ScriptDir%

;; add stuff here
InputBox, strInput, Yo - put stuff here, , , , , , , , ,
MsgBox, , Testing, %strInput%,