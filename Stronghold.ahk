﻿#NoEnv
#KeyHistory, 0
#SingleInstance, Force

#Include Settings.ahk
#Include Gui.ahk
#Include Events.ahk
#Include Helper.ahk
#Include Localization.ahk

SetWorkingDir, % A_ScriptDir
ListLines, % IsDebuggerAttatched() ? "On" : "Off"
SetBatchLines, -1

Stronghold_Version()
{
    Return "1.1.2"
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

; Toggles the Map navigation on and off (This is not a persistent setting, only for the lifetime of the application)
ToggleMapNavigation()
{
    MapNavIsToggleEnabled := !MapNavIsToggleEnabled
}

; Performs left mouse clicks as long as the trigger key is pressed down
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
    lang := GetLanguage()
    Menu, Tray, NoStandard
    Menu, Tray, DeleteAll
    If (IsDebuggerAttatched())
    {
        ; Just for debugging purposes
        Menu, Tray, Add, ListLines, Tray_ListLines
    }
    Menu, Tray, Add, % StrReplace(lang.Tray_Title, "%1", Stronghold_Version()), Tray_Void
    Menu, Tray, Default, % StrReplace(lang.Tray_Title, "%1", Stronghold_Version())
    Menu, Tray, Add
    Menu, Tray, Add, % lang.Tray_Config, Tray_Config
    Menu, Tray, Add, % lang.Tray_Website, Tray_OpenWebsite
    Menu, Tray, Add, % lang.Tray_About, Tray_About
    Menu, Tray, Add
    Menu, Tray, Add, % lang.Tray_Exit, Tray_Exit
    Menu, Tray, Tip, % StrReplace(lang.Tray_Tip, "%1", Stronghold_Version())
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
    ; lo-order word: x coordinate of the cursor
    ; hi-order word: y coordinate of the cursor
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
    MsgBox,, % StrReplace(GetLanguage().Tray_About_MsgBoxTitle, "%1", Stronghold_Version()), % StrReplace(GetLanguage().Tray_About_MsgBoxBody, "%1", Chr(0x00A9))
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

Tray_Exit:
ExitApp
