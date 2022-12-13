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
#Include Lib\Hotkey.ahk
#Include Lib\Jxon.ahk
#Include Lib\Null.ahk
#Include Lib\OBM.ahk
#Include Lib\RecurrenceTimer.ahk
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
#Include View\Gui\SettingsGui.ahk
#Include View\Stronghold\StrongholdHotkeyHandler.ahk
#Include View\Update\UpdatesChecker.ahk
#Include Model\ASettingsModel.ahk
#Include Model\AutoClickerModel.ahk
#Include Model\GeneralModel.ahk
#Include Model\IniSection.ahk
#Include Model\ISettingsModel.ahk
#Include Model\MapNavigation.ahk
#Include Model\ReplaceKeysModel.ahk
#Include Model\SettingsModel.ahk
#Include Stronghold\StrongholdManager.ahk

#Include Application.ahk
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

app := new Application()
app.Initialize()
Return


; For testing
F3::
app._settingsmodel.AutoClicker.Enable := !app._settingsmodel.AutoClicker.Enable
app._settingsmodel.AutoClicker.Key := app._settingsmodel.AutoClicker.Key == "MButton" ? "XButton1" : "MButton"
app._settingsmodel.MapNavigation.WhereToEnable := app._settingsmodel.MapNavigation.WhereToEnable == "Stronghold" ? "Crusader" : "Stronghold"
Return

F4::
app._settingsmodel.AutoClicker.Enable ^= true
app._settingsmodel.AutoClicker.Key := "XButton2"
app._settingsmodel.ReplaceKeys.OpenMarket := "x"
Return

F6::
app._settingsmodel.ReplaceKeys.Enable ^= true
Return