﻿#Requires AutoHotkey v1.1.36.0
#NoEnv
#Warn
#KeyHistory, 0
#SingleInstance, Force

#Include Lib\VarFuncs.ahk

#Include Lib\Object.ahk
#Include Lib\ArrayList.ahk
#Include Lib\ClassFunctions.ahk
#Include Lib\CommandsAsFunction.ahk
#Include Lib\Debugger.ahk
#Include Lib\DefaultIterator.ahk
#Include Lib\Enum.ahk
#Include Lib\Exception.ahk
#Include Lib\Exceptions.ahk
#Include Lib\HookHotkey.ahk
#Include Lib\Jxon.ahk
#Include Lib\Null.ahk
#Include Lib\OBM.ahk
#Include Lib\OnErrorListener.ahk
#Include Lib\OnExitListener.ahk
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

#Include Lib\Logger\LogLevel.ahk
#Include Lib\Logger\ErrorLogger.ahk
#Include Lib\Logger\ExitLogger.ahk
#Include Lib\Logger\FileAppender.ahk
#Include Lib\Logger\Logger.ahk
#Include Lib\Logger\LoggerFactory.ahk
#Include Lib\Logger\OutputDebugAppender.ahk


#Include Controller\SettingsController.ahk

#Include View\Gui\SettingsGui.ahk
#Include View\Stronghold\ChangeableHotkey.ahk
#Include View\Stronghold\IHotkeyExecutor.ahk
#Include View\Stronghold\AutoClickerExecutor.ahk
#Include View\Stronghold\GeneralToggleExecutor.ahk
#Include View\Stronghold\MapNavigationHandler.ahk
#Include View\Stronghold\ReplaceKeysExecutor.ahk
#Include View\Stronghold\StateChangeListener.ahk
#Include View\Stronghold\StrongholdHotkeyHandler.ahk
#Include View\Update\UpdatesChecker.ahk

#Include Model\Enums\EAutoClickerKeys.ahk
#Include Model\Enums\ECheckForUpdatesFrequency.ahk
#Include Model\Enums\EReplaceKeys.ahk
#Include Model\Enums\EToggleKeys.ahk
#Include Model\Enums\EWindowGroups.ahk
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


ListLines, % IsDebuggerAttatched() ? "On" : "Off"
SetBatchLines, -1
SetWorkingDir, % A_ScriptDir

Stronghold_Version()
{
    Return "2.0.0"
}

app := new Application()
app.Initialize()
Return

#Include View\Stronghold\MapNavigationHotkeys.ahk