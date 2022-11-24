#NoEnv
#Warn
#KeyHistory, 0
#SingleInstance, Force

#Include Lib\VarFuncs.ahk

#Include Lib\ArrayList.ahk
#Include Lib\BaseEvent.ahk
#Include Lib\BaseEvent.ahk
#Include Lib\ClassFunctions.ahk
#Include Lib\CommandsAsFunction.ahk
#Include Lib\Debugger.ahk
#Include Lib\DefaultIterator.ahk
#Include Lib\Null.ahk
#Include Lib\OBM.ahk
#Include Lib\WinApi.ahk

#Include Lib\Gui\ControlEvent.ahk
#Include Lib\Gui\GuiBase.ahk
#Include Lib\Gui\GuiEvents.ahk
#Include Lib\Gui\Controls\Button.ahk
#Include Lib\Gui\Controls\Checkbox.ahk
#Include Lib\Gui\Controls\ComboBoxBase.ahk
#Include Lib\Gui\Controls\ContentControl.ahk
#Include Lib\Gui\Controls\Control.ahk
#Include Lib\Gui\Controls\DropDownList.ahk
#Include Lib\Gui\Controls\Hotkey.ahk
#Include Lib\Gui\Controls\Link.ahk
#Include Lib\Gui\Controls\ListView.ahk
#Include Lib\Gui\Controls\Tab.ahk
#Include Lib\Gui\Controls\Text.ahk

#Include Settings.ahk
#Include SettingsGui.ahk
#Include Events.ahk
#Include Helper.ahk
#Include Localization.ahk


SetWorkingDir, % A_ScriptDir
ListLines, % IsDebuggerAttatched() ? "On" : "Off"
SetBatchLines, -1

Stronghold_Version()
{
    Return "2.0.0_alpha"
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

If (!FileExist(IniPath) || IsDebuggerAttatched())
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
    Menu, Tray, Add, % Format(lang.Tray_Title, Stronghold_Version()), Tray_Void
    Menu, Tray, Default, % Format(lang.Tray_Title, Stronghold_Version())
    Menu, Tray, Add
    Menu, Tray, Add, % lang.Tray_Config, Tray_Config
    Menu, Tray, Add, % lang.Tray_Website, Tray_OpenWebsite
    Menu, Tray, Add, % lang.Tray_About, Tray_About
    Menu, Tray, Add
    Menu, Tray, Add, % lang.Tray_Exit, Tray_Exit
    Menu, Tray, Tip, % Format(lang.Tray_Tip, Stronghold_Version())

    TrySetTrayIcon()
}

TrySetTrayIcon()
{
    EnvGet, progFiles86, % "ProgramFiles(x86)"

    shSteam := progFiles86 "\Steam\steamapps\common\Stronghold\Stronghold.exe"
    shcSteam := progFiles86 "\Steam\steamapps\common\Stronghold Crusader Extreme\Stronghold Crusader.exe"

    If (FileExist(shcSteam))
    {
        try Menu, Tray, Icon, % shcSteam
    }
    Else If (FileExist(shSteam))
    {
        try Menu, Tray, Icon, % shSteam
    }
}

; Returns the website of the Unofficial Crusader Patch
UCPWebsite()
{
    Return "https://unofficialcrusaderpatch.github.io"
}

; Tray Menu labels

Tray_ListLines:
    ListLines
Return

Tray_About:
    MsgBox,, % Format(GetLanguage().Tray_About_MsgBoxTitle, Stronghold_Version()), % Format(GetLanguage().Tray_About_MsgBoxBody, Chr(0x00A9))
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
