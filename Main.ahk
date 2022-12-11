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
#Include Lib\Jxon.ahk
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
#Include Model\ASettingsModel.ahk
#Include Model\AutoClickerModel.ahk
#Include Model\GeneralModel.ahk
#Include Model\IniSection.ahk
#Include Model\ISettingsModel.ahk
#Include Model\MapNavigation.ahk
#Include Model\ReplaceKeysModel.ahk
#Include Model\SettingsModel.ahk
#Include Stronghold\StrongholdManager.ahk
#Include Stronghold\StrongholdHotkeyHandler.ahk

#Include Localization.ahk
#Include Ressources.ahk
#Include TrayMenu.ahk


SetWorkingDir, % A_ScriptDir
ListLines, % IsDebuggerAttatched() ? "On" : "Off"
SetBatchLines, -1

Stronghold_Version()
{
    Return "2.0.0_alpha"
}

; TODO use the value from SettingsModel or from StrongholdManager and remove from the other
; The window title groups
GroupAdd, Stronghold, Stronghold ahk_class FFwinClass
GroupAdd, Crusader, Crusader ahk_class FFwinClass
GroupAdd, StrongholdAndCrusader, ahk_class FFwinClass

; The path where the settings get stored
global IniPath := "Config.ini"

TrayMenu.Instance.Init()

model := SettingsModel.Default()

controller := new SettingsController(model)

gui := new SettingsGui(controller, model)
gui.Show()

; For testing
F3::
model.AutoClicker.Enable := !model.AutoClicker.Enable
model.AutoClicker.Key := model.AutoClicker.Key == "MButton" ? "XButton1" : "MButton"
model.MapNavigation.WhereToEnable := model.MapNavigation.WhereToEnable == "Stronghold" ? "Crusader" : "Stronghold"
Return

F4::
model.AutoClicker.Enable ^= true
model.AutoClicker.Key := "XButton2"
model.ReplaceKeys.OpenMarket := "x"
Return

F6::
model.ReplaceKeys.Enable ^= true
Return