class SettingsGui extends GuiBase
{
    static _logger := LoggerFactory.GetLogger(SettingsGui)

    __New(controller, model, title := "", options := "")
    {
        If (!InstanceOf(controller, SettingsController))
        {
            throw Exception("Controller has a wrong type")
        }
        If (!InstanceOf(model, SettingsModel))
        {
            throw Exception("Model has a wrong type")
        }

        this._settingsController := controller
        this._settingsModel := model
        this._eventSettings := new PropertyChangeListener(OBM(this, "_onPropChangeEventSettings"))
        this._settingsModel.AddPropertyChangeListener(this._eventSettings)

        this._isDestroyed := false

        base.__New(title, options)
    }

    BuildGui()
    {
        this._width := 400
        this._height := 440
        this._margin := 10
        this._maxTextWidth := this._width - 3 * this._margin

        this.Margin(this._margin, this._margin)

        l := GetLanguage()

        this._ctrlTab := this.AddTab("w" this._width " h" this._height, l.TabTitle)
        this._buildTab1()
        this._ctrlTab.SetTab(2)
        this._buildTab2()
        this._ctrlTab.SetTab(3)
        this._buildTab3()
        this._ctrlTab.SetTab(4)
        this._buildTab4()

        this.SetTab()

        this._ctrlCancelBtn := this.AddButton("xm" (this._width - 170) " w80", l.Cancel).OnClick(OBM(this, "_onCancelBtnClick"))
        this._ctrlOkBtn := this.AddButton("xp+90 w80 Default", l.Apply).OnClick(OBM(this, "_onOkBtnClick"))
    }

    IsDestroyed[]
    {
        Get
        {
            Return this._isDestroyed
        }
    }

    ; Gui building helper

    ; General
    _buildTab1()
    {
        l := GetLanguage()

        this.AddText("w" this._maxTextWidth, l.G_Desc)
        this.AddText()
        this.AddText(, l.G_ToggleDesc)
        index := EToggleKeys.Values().IndexOf(this._settingsModel.General.ToggleKey)
        this._ctrlG_ToggleKeyDropDown := this.AddDropDownList("Choose" index, EToggleKeys.Values()).OnSelectionChange(OBM(this, "_onG_ToggleKeyDropDownChange"))

        this.AddText()
        this.AddText(, l.G_UpdatesDesc)
        ; Currently only support checking for updates on startup or never
        ddlValues := this._getSupportedUpdatesFrequenciesLocalized()
        this._ctrlG_updatesDropDown := this.AddDropDownList(, ddlValues).OnSelectionChange(OBM(this, "_onG_updatesDropDown"))
        this._setUpdatesFrequencyFromEnum(this._settingsModel.General.CheckForUpdatesFrequency)

        this._ctrlG_updateNowBtn := this.AddButton(, l.G_UpdateNow).OnClick(OBM(this, "_onG_UpdateNowBtnClick"))
    }

    ; AutoClicker
    _buildTab2()
    {
        l := GetLanguage()

        this.AddText("w" this._maxTextWidth, l.AC_Desc)
        this.AddText()
        check := this._settingsModel.AutoClicker.Enable
        disable := !check
        this._ctrlAC_Check := this.AddCheckBox("Checked" check, l.AC_Enable).OnClick(OBM(this, "_onAC_CheckClick"))
        this._ctrlAC_Text := this.AddText("Disabled" disable, l.AC_Text)
        index := EAutoClickerKeys.Values().IndexOf(this._settingsModel.AutoClicker.Key)
        ddlValues := EAutoClickerKeys.Values().Map(OBM(this, "_localizeAutoClickerKey"))
        this._ctrlAC_DropDown := this.AddDropDownList("w130 Choose" index " Disabled" disable, ddlValues).OnSelectionChange(OBM(this, "_onAC_DropDownChange"))
    }

    ; Map navigation
    _buildTab3()
    {
        l := GetLanguage()

        this.AddLink("w" this._maxTextWidth, Stronghold_Version().Format(l.MN_Desc))
        this.AddText()
        check := this._settingsModel.MapNavigation.Enable
        disable := !check
        this._ctrlMN_EnableCheck := this.AddCheckbox("Checked" check, l.MN_Enable).OnClick(OBM(this, "_onMN_EnableCheck"))
        this._ctrlMN_Text1 := this.AddText("Disabled" disable, l.MN_Text1 " ")
        index := EWindowGroups.Values().IndexOf(this._settingsModel.MapNavigation.WhereToEnable)
        ddlValues := EWindowGroups.Values().Map(OBM(this, "_localizeGameGroups"))
        this._ctrlMN_WhereDropDown := this.AddDropDownList("w150 x+0 Choose" index " Disabled" disable, ddlValues).OnSelectionChange(OBM(this, "_onMN_WhereDropDown"))
        this._ctrlMN_Text2 := this.AddText("x+0 Disabled" disable, " " l.MN_Text2)
    }

    ; Raplacing keys
    _buildTab4()
    {
        l := GetLanguage()

        this.AddText(, l.RK_Desc)
        this.AddText()

        check := this._settingsModel.ReplaceKeys.Enable
        disable := !check

        this._ctrlRK_EnableCheck := this.AddCheckbox("Checked" check, l.RK_Enable).OnClick(OBM(this, "_onRK_EnableCheck"))
        this._ctrlRK_Text1 := this.AddText("Section Disabled" disable, l.RK_Text1 " ")
        index := EWindowGroups.Values().IndexOf(this._settingsModel.ReplaceKeys.WhereToEnable)
        ddlValues := EWindowGroups.Values().Map(OBM(this, "_localizeGameGroups"))
        this._ctrlRK_WhereDropDown := this.AddDropDownList("w150 x+0 Choose" index " Disabled" disable, ddlValues).OnSelectionChange(OBM(this, "_onRK_WhereDropDown"))
        this._ctrlRK_Text2 := this.AddText("x+0 Disabled" disable, " " l.RK_Text2)

        noHdrReorder := "-LV0x10"
        lvOptions := "xs w" this._maxTextWidth " R10 -Multi NoSort NoSortHdr Grid " noHdrReorder " Disabled" disable
        this._ctrlRK_Lv := this.AddListView(lvOptions, l.RK_LvHeader)

        this._refillRKListView()

        Loop, % this._ctrlRK_Lv.ColumnCount
        {
            this._ctrlRK_Lv.ModifyCol(A_Index, "AutoHdr")
        }
        this._ctrlRK_Lv.OnRowFocused(OBM(this, "_onRK_LvRowFocused"))
        this._ctrlRK_Lv.OnRowDefocused(OBM(this, "_onRK_LvRowDefocused"))

        this._ctrlRK_Hotkey := this.AddHotkey("Section Disabled").OnHotkeyChange(OBM(this, "_onRK_HotkeyChange"))

        this._ctrlRK_ApplyHotkeyBtn := this.AddButton("x+m Disabled", l.RK_ApplyHk).OnClick(OBM(this, "_onRK_ApplyHotkeyBtnClick"))

        this._ctrlRK_RemoveHotkeyBtn := this.AddButton("x+m Disabled", l.RK_RemBinding).OnClick(OBM(this, "_onRK_RemoveHotkeyBtnClick"))

        this._ctrlRK_HotkeyWarningText := this.AddText("xs Hidden w" this._maxTextWidth)

        this._ctrlRK_ResetToDefaultsBtn := this.AddButton("Disabled" disable, l.RK_ResetHk).OnClick(OBM(this, "_onRK_ResetToDefaultBtnClick"))
    }

    ; Gets called before the gui gets destroyed
    OnDestroy()
    {
        If (this._isDestroyed)
        {
            Return
        }
        this._settingsModel.RemovePropertyChangeListener(this._eventSettings)
        this._eventSettings := ""
        this._settingsModel := ""
        this._settingsController := ""
        this._isDestroyed := true
        SettingsGui._logger.Debug("Gui is now destroyed")
    }

    ; Private helper

    _getSupportedUpdatesFrequencies()
    {
        Return [ECheckForUpdatesFrequency.startup, ECheckForUpdatesFrequency.never]
    }

    _getSupportedUpdatesFrequenciesLocalized()
    {
        Return this._getSupportedUpdatesFrequencies().Map(OBM(this, "_localizeUpdatesFrequency"))
    }

    _selectedUpdatesFrequencyToEnumValue()
    {
        index := this._ctrlG_updatesDropDown.GetSelectedIndex()
        Return this._getSupportedUpdatesFrequencies()[index]
    }

    _setUpdatesFrequencyFromEnum(enumValue)
    {
        suppFreq := this._getSupportedUpdatesFrequencies()
        If (suppFreq.Contains(enumValue))
        {
            ; The updates frequency gets localized
            index := suppFreq.IndexOf(enumValue)
            this._ctrlG_updatesDropDown.Select(index)
        }
    }

    _selectedAutoClickerKeyToEnumValue()
    {
        index := this._ctrlAC_DropDown.GetSelectedIndex()
        Return EAutoClickerKeys.Values()[index]
    }

    _selectedGameGroupToEnumValue(ddl)
    {
        index := ddl.GetSelectedIndex()
        Return EWindowGroups.Values()[index]
    }

    ; Transforms the given ECheckForUpdatesFrequency into a localized string
    _localizeUpdatesFrequency(item)
    {
        index := ECheckForUpdatesFrequency.Values().IndexOf(item)
        Return GetLanguage().G_UpdatesFrequency[index]
    }

    ; Transforms the given EAutoClickerKeys into a localized string
    _localizeAutoClickerKey(item)
    {
        index := EAutoClickerKeys.Values().IndexOf(item)
        Return GetLanguage().AC_Keys[index]
    }

    ; Transforms the given EWindowGroups into a localized string
    _localizeGameGroups(item)
    {
        index := EWindowGroups.Values().IndexOf(item)
        Return GetLanguage().GameGroups[index]
    }

    ; Transforms the given ReplaceKeys option into a localized string
    _localizeReplaceKeys(item)
    {
        Switch item
        {
            Case "GoToSignPost": index := 2
            Case "OpenGranary": index := 6
            Case "OpenEngineersGuild": index := 5
            Case "OpenKeep": index := 7
            Case "OpenTunnlerGuild": index := 10
            Case "OpenBarracks": index := 4
            Case "OpenMercenaries": index := 9
            Case "OpenMarket": index := 8
            Case "RotateScreenClockWise": index := 11
            Case "RotateScreenCounterClockWise": index := 12
            Case "ToggleUI": index := 15
            Case "ToggleZoom": index := 16
            Case "TogglePause": index := 14
            Case "SendRandomTauntMessage": index := 13
            Case "IncreaseGameSpeed": index := 3
            Case "DecreaseGameSpeed": index := 1
            Default:
                Return item
        }

        Return GetLanguage().RK_Options[index]
    }

    _localizeKeyCombo(keyCombo)
    {
        l := GetLanguage()
        result := keyCombo.shift ? l.Key_Shift : ""
        result .= keyCombo.ctrl ? (result ? " + " : "") l.Key_Ctrl : ""
        result .= keyCombo.key ? (result ? " + " : "") keyCombo.key : ""
        Return result
    }

    ; Transforms the given ListView index into a ReplaceKeys option
    _lvRowIndexToReplaceKeys(index)
    {
        Switch index
        {
            Case  2: Return "GoToSignPost"
            Case  6: Return "OpenGranary"
            Case  5: Return "OpenEngineersGuild"
            Case  7: Return "OpenKeep"
            Case 10: Return "OpenTunnlerGuild"
            Case  4: Return "OpenBarracks"
            Case  9: Return "OpenMercenaries"
            Case  8: Return "OpenMarket"
            Case 11: Return "RotateScreenClockWise"
            Case 12: Return "RotateScreenCounterClockWise"
            Case 15: Return "ToggleUI"
            Case 16: Return "ToggleZoom"
            Case 14: Return "TogglePause"
            Case 13: Return "SendRandomTauntMessage"
            Case  3: Return "IncreaseGameSpeed"
            Case  1: Return "DecreaseGameSpeed"
            Default:
                throw Exception("The given lv row index is invalid. index: " index)
        }
    }

    _refillRKListView()
    {
        ; Clear the listview
        this._ctrlRK_Lv.Delete()
        ; Reload all values
        For key, value in this._settingsModel.ReplaceKeys.GetAllReplaceKeyOptions()
        {
            this._ctrlRK_Lv.Add(, this._localizeReplaceKeys(key), value, this._localizeKeyCombo(ReplaceKeysModel.GetOriginalKeyCombo(key)))
        }
    }

    _printToConsole(eventArgs)
    {
        SettingsGui._logger.Trace(eventArgs.ToString())
    }

    _enableHotkeyAndSetValue()
    {
        keyCombo := this._getFocusedLvRow().At(2).Text
        ; As in AutoHotkey v1.1.36.02 there is a bug where it does not allow to set "+", "!", "^" as hotkey, use this workaround
        If (keyCombo == "+" || keyCombo == "!" || keyCombo == "^")
        {
            ; As ControlSend simulates a key press, it will also trigger the event
            ControlSend,, % "{" keyCombo "}", % "ahk_id" this._ctrlRK_Hotkey.Hwnd
        }
        Else
        {
            this._ctrlRK_Hotkey.KeyComboString := keyCombo
        }
        this._ctrlRK_Hotkey.Enable()
        this._ctrlRK_ApplyHotkeyBtn.Enable()
        this._ctrlRK_RemoveHotkeyBtn.Enable()
    }

    _disableHotkeyAndClear()
    {
        this._ctrlRK_Hotkey.KeyComboString := ""
        this._ctrlRK_Hotkey.Disable()
        this._ctrlRK_ApplyHotkeyBtn.Disable()
        this._ctrlRK_RemoveHotkeyBtn.Disable()
        this._hideHotkeyWarning()
    }

    _showHotkeyInUseWarning()
    {
        this._ctrlRK_HotkeyWarningText.Text := GetLanguage().RK_WarnInUse
        this._ctrlRK_HotkeyWarningText.Show()
    }

    _showHotkeyIsReserverdWarning()
    {
        this._ctrlRK_HotkeyWarningText.Text := GetLanguage().RK_WarnReserved
        this._ctrlRK_HotkeyWarningText.Show()
    }

    _showHotkeyInvalidComboWarning()
    {
        this._ctrlRK_HotkeyWarningText.Text := GetLanguage().RK_WarnInvCombo
        this._ctrlRK_HotkeyWarningText.Show()
    }

    _showHotkeyIsEmptyWarning()
    {
        this._ctrlRK_HotkeyWarningText.Text := GetLanguage().RK_WarnEmpty
        this._ctrlRK_HotkeyWarningText.Show()
    }

    _hideHotkeyWarning()
    {
        this._ctrlRK_HotkeyWarningText.Hide()
    }

    ; Determines if any ReplaceKey contains the given key combo string
    _isKeyInUse(keyCombo)
    {
        Return keyCombo !== "" && this._settingsModel.ReplaceKeys.ContainsAny(keyCombo)
    }

    ; Determines if the given key combo string is a valid ReplaceKey key combo string
    _isInvalidKeyCombo(keyCombo)
    {
        Return !EReplaceKeys.ValidValue(keyCombo)
    }

    _getFocusedLvRow()
    {
        Return this._ctrlRK_Lv.GetFocused()[1]
    }

    _getFocusedLvAction()
    {
        Return this._lvRowIndexToReplaceKeys(this._ctrlRK_Lv.GetFocused()[1].RowNumber)
    }

    ; Loops through the list and checks if the index of the compareValue is the same as its value in the ddlControl. If not it gets set
    _chooseCorrectIndexIfChanged(ddlControl, list, compareValue)
    {
        selectedIndex := ddlControl.GetSelectedIndex()
        For each, value in list
        {
            If (value == compareValue)
            {
                ; Check if the indices differ (that means it was set from outside) to prevent firing another event
                If (selectedIndex !== A_Index)
                {
                    ddlControl.Select(A_Index)
                }
                Break
            }
        }
    }

    ; Enables/Disables all controls in the AutoClicker tab
    _setACEnabledState(enable)
    {
        this._ctrlAC_Text.IsEnabled := enable
        this._ctrlAC_DropDown.IsEnabled := enable
    }

    ; Enables/Disables all controls in the MapNavigation tab
    _setMNEnabledState(enable)
    {
        this._ctrlMN_Text1.IsEnabled := enable
        this._ctrlMN_WhereDropDown.IsEnabled := enable
        this._ctrlMN_Text2.IsEnabled := enable
    }

    ; Enables/Disables all controls in the ReplaceKeys tab
    _setRKEnabledState(enable)
    {
        row := this._getFocusedLvRow()
        ; If no row is currently focused, row == ""
        If (row !== "")
        {
            id := row.Focus(enable)
            id := row.Select(enable)
        }

        this._ctrlRK_Text1.IsEnabled := enable
        this._ctrlRK_WhereDropDown.IsEnabled := enable
        this._ctrlRK_Text2.IsEnabled := enable
        this._ctrlRK_Lv.IsEnabled := enable
        this._ctrlRK_ResetToDefaultsBtn.IsEnabled := enable
    }

    ; Gui events

    OnClose()
    {
        this.Destroy()
    }

    ; Gui control events

    _onOkBtnClick(eventArgs)
    {
        ; Save the gui state in the model

        ; General
        value := this._ctrlG_ToggleKeyDropDown.GetSelectedText()
        this._settingsController.SetGeneralToggleKey(value)

        value := this._selectedUpdatesFrequencyToEnumValue()
        this._settingsController.SetGeneralCheckForUpdatesFrequency(value)

        ; AutoClicker
        value := this._ctrlAC_Check.IsChecked
        this._settingsController.SetAutoClickerEnable(value)

        value := this._selectedAutoClickerKeyToEnumValue()
        this._settingsController.SetAutoClickerToggleKey(value)

        ; MapNavigation
        value := this._ctrlMN_EnableCheck.IsChecked
        this._settingsController.SetMapNavigationEnable(value)

        value := this._selectedGameGroupToEnumValue(this._ctrlMN_WhereDropDown)
        this._settingsController.SetMapNavigationWhereToEnable(value)

        ; ReplaceKeys
        value := this._ctrlRK_EnableCheck.IsChecked
        this._settingsController.SetReplaceKeysEnable(value)

        value := this._selectedGameGroupToEnumValue(this._ctrlRK_WhereDropDown)
        this._settingsController.SetReplaceKeysWhereToEnable(value)

        ; Don't apply the Replacekeys here as they get set via the "Apply Hotkey" button

        SettingsGui._logger.Debug("Close the gui and save the settings")

        this._settingsController.SaveToFile()
        this.Close()
    }

    _onCancelBtnClick(eventArgs)
    {
        SettingsGui._logger.Debug("Close the gui without saving the settings")

        this.Close()
    }

    _onG_ToggleKeyDropDownChange(eventArgs)
    {
        this._printToConsole(eventArgs)
    }

    _onG_updatesDropDown(eventArgs)
    {
        this._printToConsole(eventArgs)
    }

    _onG_UpdateNowBtnClick(eventArgs)
    {
        this._settingsController.CheckForUpdates()
    }

    _onAC_CheckClick(eventArgs)
    {
        this._setACEnabledState(eventArgs.IsChecked)
    }

    _onAC_DropDownChange(eventArgs)
    {
        this._printToConsole(eventArgs)
    }

    _onMN_EnableCheck(eventArgs)
    {
        this._setMNEnabledState(eventArgs.IsChecked)
    }

    _onMN_WhereDropDown(eventArgs)
    {
        this._printToConsole(eventArgs)
    }

    _onRK_EnableCheck(eventArgs)
    {
        this._setRKEnabledState(eventArgs.IsChecked)
    }

    _onRK_WhereDropDown(eventArgs)
    {
        this._printToConsole(eventArgs)
    }

    _onRK_LvRowFocused(eventArgs)
    {
        this._enableHotkeyAndSetValue()
    }

    _onRK_LvRowDefocused(eventArgs)
    {
        this._disableHotkeyAndClear()
    }

    _onRK_ResetToDefaultBtnClick(eventArgs)
    {
        l := GetLanguage()
        ; Ask for user confirm
        If ("Yes" == MsgBox(4, l.RK_MbResetTitle, l.RK_MbResetBody))
        {
            SettingsGui._logger.Debug("Set all ReplaceKeys to the default values")

            ; Set ReplaceKeys to the system defaults
            this._settingsController.ResetReplaceKeys()
            ; TODO save to file?
        }
    }

    _onRK_HotkeyChange(eventArgs)
    { 
        If (eventArgs.KeyComboString == "")
        {
            this._showHotkeyIsEmptyWarning()
        }
        ; wasd keys cannot be used in replace key combos as they are reserved for map navigation
        Else If (eventArgs.KeyComboString.In("w", "a", "s", "d"))
        {
            this._showHotkeyIsReserverdWarning()
        }
        Else If (this._isKeyInUse(eventArgs.KeyComboString))
        {
            ; Check if the key is the same key as in the model, if yes, do nothing
            action := this._getFocusedLvAction()
            rk := this._settingsModel.ReplaceKeys
            If (rk[action] != eventArgs.KeyComboString)
            {
                this._showHotkeyInUseWarning()
            }
        }
        Else If (this._isInvalidKeyCombo(eventArgs.KeyComboString))
        {
            this._showHotkeyInvalidComboWarning()
        }
        Else
        {
            this._hideHotkeyWarning()
        }
    }

    _onRK_ApplyHotkeyBtnClick(eventArgs)
    {
        l := GetLanguage()
        keyCombo := this._ctrlRK_Hotkey.KeyComboString
        rk := this._settingsModel.ReplaceKeys
        action := this._getFocusedLvAction()

        If (keyCombo == "")
        {
            Msgbox(l.RK_MbApplyErrTitle, l.RK_MbApplyErrEmpty)
        }
        Else If (keyCombo.In("w", "a", "s", "d"))
        {
            Msgbox(l.RK_MbApplyErrTitle, l.RK_MbApplyErrReserved)
        }
        Else If (rk[action] == keyCombo)
        {
            Msgbox(l.RK_MbApplyErrTitle, l.RK_MbApplyErrSameKey)
        }
        Else If (this._isKeyInUse(keyCombo))
        {
            Msgbox(l.RK_MbApplyErrTitle, l.RK_MbApplyErrInUse)
        }
        Else If (this._isInvalidKeyCombo(keyCombo))
        {
            Msgbox(l.RK_MbApplyErrTitle, l.RK_MbApplyErrInv)
        }
        Else
        {
            SettingsGui._logger.Debug("Set '" action "' to the key '" keyCombo "'")

            this._settingsController.SetReplaceKeysByProperty(action, keyCombo)
        }
    }

    _onRK_RemoveHotkeyBtnClick(eventArgs)
    {
        action := this._getFocusedLvAction()

        SettingsGui._logger.Debug("Remove the keyCombo from '" action "'")

        ; Pass an empty string to indicate the removal of the hotkey binding
        this._settingsController.SetReplaceKeysByProperty(action, "")
    }

    ; SettingsModel events

    _onPropChangeEventSettings(event)
    {
        Switch event.Name
        {
            Case SettingsModel.Events.AutoClicker:
                this._handleAutoClicker(event.OldValue, event.NewValue)
            Case SettingsModel.Events.MapNavigation:
                this._handleMapNavigation(event.OldValue, event.NewValue)
            Case SettingsModel.Events.ReplaceKeys:
                this._handleReplaceKeys(event.OldValue, event.NewValue)
            Case SettingsModel.Events.General:
                this._handleGeneral(event.OldValue, event.NewValue)
        }
    }

    ; before, after instance of AutoClickerModel
    _handleAutoClicker(before, after)
    {
        If (before.Enable !== after.Enable)
        {
            ; Only set the checked state if it was set from outside to prevent firing another event
            If (this._ctrlAC_Check.IsChecked !== after.Enable)
            {
                this._ctrlAC_Check.IsChecked := after.Enable
            }
            ; Enable/Disable the controls
            this._setACEnabledState(after.Enable)
        }

        If (before.Key != after.Key)
        {
            this._chooseCorrectIndexIfChanged(this._ctrlAC_DropDown, EAutoClickerKeys.Values(), after.Key)
        }
    }

    ; before, after instance of MapNavigationModel
    _handleMapNavigation(before, after)
    {
        If (before.Enable !== after.Enable)
        {
            ; Only set the checked state if it was set from outside to prevent firing another event
            If (this._ctrlMN_EnableCheck.IsChecked !== after.Enable)
            {
                this._ctrlMN_EnableCheck.IsChecked := after.Enable
            }
            ; Enable/Disable the controls
            this._setMNEnabledState(after.Enable)
        }

        If (before.WhereToEnable != after.WhereToEnable)
        {
            this._chooseCorrectIndexIfChanged(this._ctrlMN_WhereDropDown, EWindowGroups.Values(), after.WhereToEnable)
        }
    }

    ; before, after instance of ReplaceKeyModel
    _handleReplaceKeys(before, after)
    {
        If (before.Enable !== after.Enable)
        {
            If (after.Enable !== this._ctrlRK_EnableCheck.IsChecked)
            {
                this._ctrlRK_EnableCheck.IsChecked := after.Enable
            }
            this._setRKEnabledState(after.Enable)
        }

        If (before.WhereToEnable != after.WhereToEnable)
        {
            this._chooseCorrectIndexIfChanged(this._ctrlMN_WhereDropDown, EWindowGroups.Values(), after.WhereToEnable)
        }

        ; For any other property:

        ; Reload the listview
        this._refillRKListView()
        ; Reset other parts of the gui
        this._disableHotkeyAndClear()
    }

    ; before, after instance of GeneralModel
    _handleGeneral(before, after)
    {
        If (before.Togglekey != after.ToggleKey)
        {
            ; The keys don't get localized
            this._chooseCorrectIndexIfChanged(this._ctrlG_ToggleKeyDropDown, EToggleKeys.Values(), after.Togglekey)
        }
        If (before.CheckForUpdatesFrequency !== after.CheckForUpdatesFrequency)
        {
            ; As the gui currently only supports startup and never, all other options get ignored
            this._setUpdatesFrequencyFromEnum(after.CheckForUpdatesFrequency)
        }

        ; TODO subscribe to the Updates events in case someone clicks the update button and waits for any feedback

        ; Don't care for LastCheckedForUpdate and LatestVersion
    }
}