#NoEnv
#KeyHistory, 0
#SingleInstance, Force
SetWorkingDir, %A_ScriptDir%
ListLines, Off
SetBatchLines, -1

; The window title groups
GroupAdd, Stronghold, Stronghold ahk_class FFwinClass
GroupAdd, Crusader, Crusader ahk_class FFwinClass
GroupAdd, StrongholdAndCrusader, ahk_class FFwinClass

; If you want Map navigation with the wasd keys enabled, set this to true, otherwise set it to false
; Off by default, as the Unofficial Crusader Patch adds this ability
global EnableMapNav := false

; Creates a hotkey that toggles the Map navigation on and off. Is only available in the group that GroupMapNav points to
; To disable this option, make it blank (A good option can be "CapsLock")
global HotkeyToggleMapNav := ""

; In which games should the Map navigation be enabled?
; Options are
; - "Stronghold"            (Stronghold)
; - "Crusader"              (Crusader and Extreme)
; - "StrongholdAndCrusader" (Stronghold, Crusader and Extreme)
global GroupMapNav := "Stronghold"

; If the user wants a Map navigation toggle, this creates the Hotkey
If (HotkeyToggleMapNav && GetKeyName(HotkeyToggleMapNav))
{
    Hotkey, IfWinActive, ahk_group %GroupMapNav%
    Hotkey, %HotkeyToggleMapNav%, ToggleMapNavigation
}

; Initialize the tray menu
BuildTrayMenu()

Return


; Stronghold, Crusader and Extreme
#IfWinActive ahk_group StrongholdAndCrusader

; The middle mouse button
MButton::
    While (GetKeyState("MButton", "P"))
    {
        PerformLeftClick()
        Sleep, 15
    }
Return


; Map navigation
#If ShouldNavMap()

a::Left
s::Down
d::Right
w::Up

#If


; Determines if the Map should be navigated with the 
ShouldNavMap()
{
    Return EnableMapNav && WinActive("ahk_group" GroupMapNav)
}

; Toggles the Map navigation on and off
ToggleMapNavigation()
{
    EnableMapNav := !EnableMapNav
}

; Helper methods

BuildTrayMenu()
{
    Menu, Tray, NoStandard
    Menu, Tray, DeleteAll
    Menu, Tray, Add, Stronghold Hotkeys, Tray_Void
    Menu, Tray, Default, Stronghold Hotkeys
    Menu, Tray, Add
    Menu, Tray, Add, Open website, Tray_OpenWebsite
    Menu, Tray, Add, About, Tray_About
    Menu, Tray, Add
    Menu, Tray, Add, Reload this script, Tray_Reload
    Menu, Tray, Add, Exit, Tray_Exit
    Menu, Tray, Tip, Stronghold
}

; Perform a mouse click with the left mouse button
PerformLeftClick()
{
    static WM_LBUTTONDOWN := 0x201
         , WM_LBUTTONUP := 0x202
         , MK_LBUTTON := 0x0001
         , MK_NONE := 0x0000

    _performClick(WM_LBUTTONDOWN, WM_LBUTTONUP, MK_LBUTTON, MK_NONE)
}

; Performs a click. Posts a window message with the given number to the target window
_performClick(msgDown, msgUp, keysUp, keysDown)
{
    MouseGetPos, x, y, hwnd
    lParam := (y << 16) | x

    PostMessage, msgDown, keysUp, lParam,, % "ahk_id" hwnd
    Sleep, 10
    PostMessage, msgUp, keysDown, lParam,, % "ahk_id" hwnd
    Sleep, 10
}

; Tray Menu labels

Tray_About:
    MsgBox,, % "Stronghold Hotkeys - About", % "A small helper program for Stronghold.`n`n"
           . "Press and hold the middle mouse button for an auto clicker.`n"
           . "If enabled, the 'w' 'a' 's' 'd' keys can be used to navigate the map`n`n"
           . Chr(0x00A9) " 2022 3tmp`n`n"
           . "Project website: https://github.com/3tmp/Stronghold-Hotkeys"
Return

Tray_OpenWebsite:
    Run, https://github.com/3tmp/Stronghold-Hotkeys
Return

Tray_Void:
Return

Tray_Reload:
    Reload
Return

Tray_Exit:
ExitApp
