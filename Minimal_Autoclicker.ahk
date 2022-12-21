#NoEnv
#KeyHistory, 0
#SingleInstance, Force
SetBatchLines, -1
ListLines, Off
SetMouseDelay, 15

Menu, Tray, NoStandard
Menu, Tray, DeleteAll
Menu, Tray, Add, Open Website, Tray_OpenWebsite
Menu, Tray, Add, About, Tray_About
Menu, Tray, Add
Menu, Tray, Add, Exit, Tray_Exit
Menu, Tray, Tip, Stronghold Autoclicker
Return

#IfWinActive ahk_class FFwinClass
MButton::
    While (GetKeyState(A_ThisHotkey, "P"))
    {
        Click
    }
Return
#If

Tray_About:
    MsgBox,, % "Stronghold Autoclicker", % "Press and hold the middle mouse button while Stronghold, Crusader or Extreme is active and it will send left mouse clicks to the game."
Return

Tray_OpenWebsite:
    Run, https://github.com/3tmp/Stronghold-Hotkeys
Return

Tray_Exit:
ExitApp