#NoEnv

Menu, Tray, NoStandard
Menu, Tray, DeleteAll
Menu, Tray, Add, Stronghold Hotkeys, Tray_Void
Menu, Tray, Default, Stronghold Hotkeys
Menu, Tray, Add
Menu, Tray, Add, Open website, Tray_OpenWebsite
Menu, Tray, Add, About, Tray_About
Menu, Tray, Add
Menu, Tray, Add, Exit, Tray_Exit
Menu, Tray, Tip, Stronghold
Return

Tray_About:
    MsgBox,, % "Stronghold Hotkeys - About", % "A small helper program for Stronghold.`n`n"
           . "Press and hold the middle mouse button for an auto clicker.`n`n"
           . Chr(0x00A9) " 2022 3tmp"
Return

Tray_OpenWebsite:
    Run, https://github.com/3tmp/Stronghold-Hotkeys
Return

Tray_Void:
Return

Tray_Exit:
ExitApp


; Only Stronghold
#IfWinActive Stronghold ahk_class FFwinClass
; Map navigation begin
a::Left
s::Down
d::Right
w::Up
; Map navigation end


; Only Crusader and Extreme
#IfWinActive Crusader ahk_class FFwinClass


; All (Crusader and Stronghold)
#IfWinActive ahk_class FFwinClass

MButton::
    While (GetKeyState("MButton", "P"))
    {
        PerformLeftClick()
        Sleep, 15
    }
Return

#If


; Helper methods

; Perform a mouse click
PerformLeftClick()
{
    static WM_LBUTTONDOWN := 0x201
         , WM_LBUTTONUP := 0x202

    MouseGetPos, x, y, hwnd
    lParam := (y << 16) | x

    PostMessage, WM_LBUTTONDOWN, 1, lParam,, % "ahk_id" hwnd
    Sleep, 10
    PostMessage, WM_LBUTTONUP, 0, lParam,, % "ahk_id" hwnd
    Sleep, 10
}