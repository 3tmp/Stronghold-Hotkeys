#NoEnv
#Warn
#KeyHistory, 0
#SingleInstance, Force

#Include Lib\VarFuncs.ahk

#Include Lib\ArrayList.ahk
#Include Lib\ClassFunctions.ahk
#Include Lib\CommandsAsFunction.ahk
#Include Lib\Debugger.ahk
#Include Lib\DefaultIterator.ahk
#Include Lib\Null.ahk
#Include Lib\OBM.ahk
#Include Lib\WinApi.ahk

#Include Lib\Events\BaseEvent.ahk
#Include Lib\Events\PropertyChangeEvent.ahk
#Include Lib\Events\PropertyChangeListener.ahk
#Include Lib\Events\PropertyChangeSupport.ahk

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

#Include Controller\SettingsController.ahk
#Include Gui\SettingsGui.ahk
#Include Model\AutoClickerModel.ahk
#Include Model\GeneralModel.ahk
#Include Model\IniSection.ahk
#Include Model\ISetting.ahk
#Include Model\MapNavigation.ahk
#Include Model\ReplaceKeysModel.ahk
#Include Model\SettingsModel.ahk
#Include Stronghold\StrongholdManager.ahk
#Include Stronghold\StrongholdHotkeyHandler.ahk

#Include Localization.ahk
#Include TrayMenu.ahk


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

TrayMenu.Instance.Init()

model := new SettingsModel()
model.ReplaceKeys := ReplaceKeysModel.Default()
model.AutoClicker := AutoClickerModel.Default()
model.MapNavigation := MapNavigationModel.Default()
model.General := GeneralModel.Default()

controller := new SettingsController()

gui := new SettingsGui(controller, model)
gui.Show()

; For testing
F3::
model.AutoClicker := new AutoClickerModel(!model.AutoClicker.Enable, model.AutoClicker.Key == "MButton" ? "XButton1" : "MButton")
model.MapNavigation := new MapNavigationModel(!model.MapNavigation.Enable, model.MapNavigation.WhereToEnable == "Stronghold" ? "Crusader" : "Stronghold")

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
    ;nav := SettingsModel.MapNavigation
    ;Return MapNavIsToggleEnabled && nav.Enable && WinActive("ahk_group" nav.WhereToEnable)
}

; Toggles the Map navigation on and off (This is not a persistent setting, only for the lifetime of the application)
ToggleMapNavigation()
{
    MapNavIsToggleEnabled := !MapNavIsToggleEnabled
}



; Returns the website of the Unofficial Crusader Patch
UCPWebsite()
{
    Return "https://unofficialcrusaderpatch.github.io"
}