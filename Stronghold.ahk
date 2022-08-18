#NoEnv
#KeyHistory, 0
#SingleInstance, Force

#Include Settings.ahk
#Include Gui.ahk
#Include Events.ahk

SetWorkingDir, %A_ScriptDir%
ListLines, % IsDebuggerAttatched() ? "On" : "Off"
SetBatchLines, -1

Stronghold_Version()
{
    Return "1.0.0"
}

; The window title groups
GroupAdd, Stronghold, Stronghold ahk_class FFwinClass
GroupAdd, Crusader, Crusader ahk_class FFwinClass
GroupAdd, StrongholdAndCrusader, ahk_class FFwinClass

; The path where the settings get stored
global IniPath := "Config.ini"

; The settings manager object
global Settings := SettingsController.Static_Parse(IniPath)
; Subscribe to events from the settings object
Settings.OnBeforeMapNavigationChange(Func("BeforeMapNavChange"))
Settings.OnAfterMapNavigationChange(Func("AfterMapNavChange"))
Settings.OnBeforeAutoClickerChange(Func("BeforeAutoClickerChange"))
Settings.OnAfterAutoClickerChange(Func("AfterAutoClickerChange"))

; Initialize the tray menu
BuildTrayMenu()

; Init the autoclicker
If (Settings.AutoClicker.Enable)
{
    _setAutoClickerHotkey(true)
}

; Init the map navigation
If (Settings.MapNavigation.Enable)
{
    _setMapNavHotkey(true)
}

; A toggle that stores the temp state of the map navigation
global MapNavIsToggleEnabled := Settings.MapNavigation.Enable

If (!FileExist(IniPath))
{
    Settings.Save(IniPath)
    If (!ConfigGui.IsRunning)
    {
        gui := new ConfigGui(Settings, IniPath)
    }

    gui.Show()
}

Return


; Map navigation
; The map navigation hotkeys have to be defined like this, because otherwise the
; auto fire does not work correct
#If ShouldNavMap()

a::Left
s::Down
d::Right
w::Up

#If


; Determines if the Map should be navigated with the wasd keys
ShouldNavMap()
{
    nav := Settings.MapNavigation
    Return MapNavIsToggleEnabled && nav.Enable && WinActive("ahk_group" nav.WhereToEnable)
}

; Toggles the Map navigation on and off
ToggleMapNavigation()
{
    MapNavIsToggleEnabled := !MapNavIsToggleEnabled
}

MouseClicks()
{
    While (GetKeyState(Settings.AutoClicker.Key, "P"))
    {
        PerformLeftClick()
        Sleep, 15
    }
}

; Event handlers

BeforeMapNavChange()
{
    _setMapNavHotkey(false)
}

AfterMapNavChange()
{
    If (Settings.MapNavigation.Enable)
    {
        _setMapNavHotkey(true)
        MapNavIsToggleEnabled := true
    }
    Else
    {
        MapNavIsToggleEnabled := false
    }
}

BeforeAutoClickerChange()
{
    _setAutoClickerHotkey(false)
}

AfterAutoClickerChange()
{
    If (Settings.AutoClicker.Enable)
    {
        _setAutoClickerHotkey(true)
    }
}

; Hotkey modifications

_setMapNavHotkey(enable)
{
    _modifyHotkey(Settings.MapNavigation.ToggleKey, Settings.MapNavigation.WhereToEnable, "ToggleMapNavigation", enable)
}

_setAutoClickerHotkey(enable)
{
    _modifyHotkey(Settings.AutoClicker.Key, "StrongholdAndCrusader", "MouseClicks", enable)
}

_modifyHotkey(key, group, funcName, enable)
{
    onOff := enable ? "On" : "Off"
    Hotkey, IfWinActive, ahk_group %group%
    Hotkey, %key%, %funcName%, %onOff%
}

; Helper methods

BuildTrayMenu()
{
    Menu, Tray, NoStandard
    Menu, Tray, DeleteAll
    Menu, Tray, Add, ListLines, Tray_ListLines
    Menu, Tray, Add, Stronghold Hotkeys, Tray_Void
    Menu, Tray, Default, Stronghold Hotkeys
    Menu, Tray, Add
    Menu, Tray, Add, Configure Program, Tray_Config
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

; Only used for debugging purposes
IsDebuggerAttatched()
{
    Return !!InStr(DllCall("Kernel32.dll\GetCommandLine", "Str"), "/debug")
}

; Tray Menu labels

Tray_ListLines:
    ListLines
Return

Tray_About:
    MsgBox,, % "Stronghold - About v" Stronghold_Version(), % "A small helper program for Stronghold.`n`n"
             . "Press and hold the configured mouse button for an auto clicker.`n"
             . "If enabled, the 'w' 'a' 's' 'd' keys can be used to navigate the map`n`n"
             . Chr(0x00A9) " 2022 3tmp`n`n"
             . "Project website: https://github.com/3tmp/Stronghold-Hotkeys"
Return

Tray_OpenWebsite:
    Run, https://github.com/3tmp/Stronghold-Hotkeys
Return

Tray_Config:
    If (!ConfigGui.IsRunning)
    {
        gui := new ConfigGui(Settings, IniPath)
    }

    gui.Show()
Return

Tray_Void:
Return

Tray_Reload:
    Reload
Return

Tray_Exit:
ExitApp
