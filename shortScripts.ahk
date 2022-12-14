#NoEnv
SendMode, Input
SetBatchLines, -1
SetWorkingDir, %A_ScriptDir%

; Throwaway scripts for one off usage - be careful here as typically these
; have now window checks or safety. Typical usage is
; "I need to do lots of stuffs and I dont want to develop a whole new fluid as I'll only do this once or twice."

^!NumPad1::
    ;; Attach a specific output and printer to the different sales channels on a component - go thorugh later and use the media copy for print labels
    ;; this one sets the sales channel, print defer, media template, printer and media type - that is really annoying to add manually.
    intSalesChannels := 3
    Loop, %intSalesChannels% {
        ; MsgBox, , loop, %A_Index%,
        Send {Down %A_Index%}
        Send {Tab 1}
        Send {down 1}
        Send {Tab 1}
        Send {PgDn 1}
        Send {Tab 2} , {Down 2}
        Send {Tab 1}
        SendInput 1
        Send {Tab 12}
        Send {Enter 1}
        Send {Down}
        Send {Right}
        Send {Down 4}
        Send {Right} {Down 1} ; 1 = Multi 2 = single
        Send {Enter 3}

        Sleep 500

    }

Return

^!NumPad2::
    ;  Update AXXEss fussy stuffs
    Send {Tab 1}
    Send {Down 2}
    Send {Tab 1}
    Send {Down 1}
    Send {Tab 1}
    Send {Down 10}
    Send {Tab 2}
    intOnes := 6
    Loop, %intOnes%{
        SendInput 1
        Send {Tab 1}
    }
; final resting place check it

Return