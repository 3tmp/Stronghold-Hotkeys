class SettingsGui extends GuiBase
{
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

        this.Margin(this._margin, this._margin)

        this._ctrlTab := this.AddTab("w" this._width " h" this._height, ["General", "AutoClicker", "MapNavigation", "ReplaceKeys"])
        this._buildTab1()
        this._ctrlTab.SetTab(2)
        this._buildTab2()
        this._ctrlTab.SetTab(3)
        this._buildTab3()
        this._ctrlTab.SetTab(4)
        this._buildTab4()

        this.SetTab()

        this._ctrlCancelBtn := this.AddButton("xm" (this._width - 170) " w80", "Cancel").OnClick(OBM(this, "_onCancelBtnClick"))
        this._ctrlOkBtn := this.AddButton("xp+90 w80", "Ok").OnClick(OBM(this, "_onOkBtnClick"))
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
        this.AddText("w" this._width, "This is the General description")
        this.AddText()
        this.AddText(, "This is the Toggle key description")
        index := SettingsModel.ValidToggleKeys.IndexOf(this._settingsModel.General.ToggleKey)
        this._ctrlG_ToggleKeyDropDown := this.AddDropDownList("Choose" index, SettingsModel.ValidToggleKeys).OnSelectionChange(OBM(this, "_onG_ToggleKeyDropDownChange"))

        this.AddText()
        this.AddText(, "When should the app search for updates?")
        index := SettingsModel.ValidCheckForUpdatesFrequency.IndexOf(this._settingsModel.General.CheckForUpdatesFrequency)
        this._ctrlG_updatesDropDown := this.AddDropDownList("Choose" index, SettingsModel.ValidCheckForUpdatesFrequency).OnSelectionChange(OBM(this, "_onG_updatesDropDown"))
        this._ctrlG_updateNowBtn := this.AddButton(, "Check for updates now").OnClick(OBM(this, "_onG_UpdateNowBtnClick"))
    }

    ; AutoClicker
    _buildTab2()
    {
        this.AddText("w" this._width, "This is the autoclicker description")
        this.AddText()
        check := this._settingsModel.AutoClicker.Enable
        disable := !check
        index := SettingsModel.ValidAutoClickerKeys.IndexOf(this._settingsModel.AutoClicker.Key)
        this._ctrlAC_Check := this.AddCheckBox("Checked" check, "Enable AutoClicker").OnClick(OBM(this, "_onAC_CheckClick"))
        this._ctrlAC_Text := this.AddText("Disabled" disable, "Send clicks as long as the following key gets pressed down")
        this._ctrlAC_DropDown := this.AddDropDownList("Choose" index " Disabled" disable, SettingsModel.ValidAutoClickerKeys).OnSelectionChange(OBM(this, "_onAC_DropDownChange"))
    }

    ; Map navigation
    _buildTab3()
    {
        this.AddLink(, "Description and the UCP Website")
        this.AddText()
        check := this._settingsModel.MapNavigation.Enable
        disable := !check
        index := SettingsModel.ValidWindowGroups.IndexOf(this._settingsModel.MapNavigation.WhereToEnable)
        this._ctrlMN_EnableCheck := this.AddCheckbox("Checked" check, "Enable Map Navigation").OnClick(OBM(this, "_onMN_EnableCheck"))
        this._ctrlMN_Text1 := this.AddText("Disabled" disable, "Enable only when ")
        this._ctrlMN_WhereDropDown := this.AddDropDownList("x+0 Choose" index " Disabled" disable, SettingsModel.ValidWindowGroups).OnSelectionChange(OBM(this, "_onMN_WhereDropDown"))
        this._ctrlMN_Text2 := this.AddText("x+0 Disabled" disable, " is the active game")
    }

    ; Raplacing keys
    _buildTab4()
    {
        this.AddText(, "Description of replace keys")
        this.AddText()

        check := this._settingsModel.ReplaceKeys.Enable
        disable := !check
        index := SettingsModel.ValidWindowGroups.IndexOf(this._settingsModel.ReplaceKeys.WhereToEnable)

        this._ctrlRK_EnableCheck := this.AddCheckbox("Checked" check, "Enable Replace Keys").OnClick(OBM(this, "_onRK_EnableCheck"))
        this._ctrlRK_Text1 := this.AddText("Section Disabled" disable, "Enable only when ")
        this._ctrlRK_WhereDropDown := this.AddDropDownList("x+0 Choose" index " Disabled" disable, SettingsModel.ValidWindowGroups).OnSelectionChange(OBM(this, "_onRK_WhereDropDown"))
        this._ctrlRK_Text2 := this.AddText("x+0 Disabled" disable, " is the active game")

        noHdrReorder := "-LV0x10"
        lvOptions := "xs w" (this._width - this._margin * 3) " R10 -Multi NoSort NoSortHdr Grid " noHdrReorder " Disabled" disable
        this._ctrlRK_Lv := this.AddListView(lvOptions, ["Command", "Key"])

        this._refillRKListView()

        Loop, % this._ctrlRK_Lv.ColumnCount
        {
            this._ctrlRK_Lv.ModifyCol(A_Index, "AutoHdr")
        }
        this._ctrlRK_Lv.OnRowFocused(OBM(this, "_onRK_LvRowFocused"))
        this._ctrlRK_Lv.OnRowDefocused(OBM(this, "_onRK_LvRowDefocused"))

        this._ctrlRK_Hotkey := this.AddHotkey("Section Disabled").OnHotkeyChange(OBM(this, "_onRK_HotkeyChange"))

        this._ctrlRK_ApplyHotkeyBtn := this.AddButton("x+m Disabled", "Apply Hotkey").OnClick(OBM(this, "_onRK_ApplyHotkeyBtnClick"))

        this._ctrlRK_RemoveHotkeyBtn := this.AddButton("x+m Disabled", "Remove binding").OnClick(OBM(this, "_onRK_RemoveHotkeyBtnClick"))

        this._ctrlRK_HotkeyWarningText := this.AddText("xs Hidden w" this._width - 3 * this._margin)

        this._ctrlRK_ResetToDefaultsBtn := this.AddButton("Disabled" disable, "Reset to default").OnClick(OBM(this, "_onRK_ResetToDefaultBtnClick"))
    }

    ; Gets called before the gui gets destroyed
    OnDestroy()
    {
        this._settingsModel.RemovePropertyChangeListener(this._eventSettings)
        this._eventSettings := ""
        this._settingsModel := ""
        this._settingsController := ""
        this._isDestroyed := true
    }

    ; Private helper

    _refillRKListView()
    {
        ; Clear the listview
        this._ctrlRK_Lv.Delete()
        ; Reload all values
        For key, value in this._settingsModel.ReplaceKeys.GetAllReplaceKeyOptions()
        {
            this._ctrlRK_Lv.Add(, key, value)
        }
    }

    _printToConsole(eventArgs)
    {
        OutputDebug(eventArgs.ToString())
    }

    _enableHotkeyAndSetValue()
    {
        keyCombo := this._getFocusedLvRow().At(2).Text
        ; As in AutoHotkey v1.1.36.02 there is a bug where it does not allow to set a "+" as hotkey, use this workaround
        If (keyCombo == "+")
        {
            ControlSend,, {+}, % "ahk_id" this._ctrlRK_Hotkey.Hwnd
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
        ; TODO localization
        this._ctrlRK_HotkeyWarningText.Text := "Hotkey is already in use"
        this._ctrlRK_HotkeyWarningText.Show()
    }

    _showHotkeyIsReserverdWarning()
    {
        ; TODO localization
        this._ctrlRK_HotkeyWarningText.Text := "'w', 'a', 's', 'd' are reserved for MapNavigation"
        this._ctrlRK_HotkeyWarningText.Show()
    }

    _showHotkeyInvalidComboWarning()
    {
        ; TODO localization
        this._ctrlRK_HotkeyWarningText.Text := "The typed key combo is invalid"
        this._ctrlRK_HotkeyWarningText.Show()
    }

    _showHotkeyIsEmptyWarning()
    {
        ; TODO localization
        this._ctrlRK_HotkeyWarningText.Text := "The key combo must not be empty"
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
        Return !SettingsModel.ValidReplaceKeys.Contains(keyCombo)
    }

    _getFocusedLvRow()
    {
        Return this._ctrlRK_Lv.GetFocused()[1]
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

        value := this._ctrlG_updatesDropDown.GetSelectedText()
        this._settingsController.SetGeneralCheckForUpdatesFrequency(value)

        ; AutoClicker
        value := this._ctrlAC_Check.IsChecked
        this._settingsController.SetAutoClickerEnable(value)

        value := this._ctrlAC_DropDown.GetSelectedText()
        this._settingsController.SetAutoClickerToggleKey(value)

        ; MapNavigation
        value := this._ctrlMN_EnableCheck.IsChecked
        this._settingsController.SetMapNavigationEnable(value)

        value := this._ctrlMN_WhereDropDown.GetSelectedText()
        this._settingsController.SetMapNavigationWhereToEnable(value)

        ; ReplaceKeys
        value := this._ctrlRK_EnableCheck.IsChecked
        this._settingsController.SetReplaceKeysEnable(value)

        value := this._ctrlRK_WhereDropDown.GetSelectedText()
        this._settingsController.SetReplaceKeysWhereToEnable(value)

        ; Don't apply the Replacekeys here as they get set via the "Apply Hotkey" button

        this._settingsController.SaveToFile()
        this.Close()
    }

    _onCancelBtnClick(eventArgs)
    {
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
        ; Ask for user confirm
        ; TODO localization
        If ("Yes" == MsgBox(4, "Reset", "Reset hotkey mapping?"))
        {
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
            this._showHotkeyInUseWarning()
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
        keyCombo := this._ctrlRK_Hotkey.KeyComboString
        replaceKeys := this._settingsModel.ReplaceKeys
        action := this._getFocusedLvRow().At(1).Text

        If (keyCombo == "")
        {
            ; TODO localization
            Msgbox("You have to enter a key to set a new Hotkey")
        }
        Else If (keyCombo.In("w", "a", "s", "d"))
        {
            ; TODO localization
            Msgbox("'w', 'a', 's', 'd' Hotkeys are reserved for MapNavigation, choose a different one")
        }
        Else If (this._isKeyInUse(keyCombo) || replaceKeys[action] == keyCombo)
        {
            ; TODO localization
            Msgbox("Hotkey is already in use, choose a different one")
        }
        Else If (this._isInvalidKeyCombo(keyCombo))
        {
            ; TODO localization
            Msgbox("This is an invalid Hotkey combo, choose a different one")
        }
        Else
        {
            this._settingsController.SetReplaceKeysByProperty(action, keyCombo)
        }
    }

    _onRK_RemoveHotkeyBtnClick(eventArgs)
    {
        row := this._getFocusedLvRow()
        ; Pass an empty string to indicate the removal of the hotkey binding
        this._settingsController.SetReplaceKeysByProperty(row.At(1).Text, "")
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
            this._chooseCorrectIndexIfChanged(this._ctrlAC_DropDown, SettingsModel.ValidAutoClickerKeys, after.Key)
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
            this._chooseCorrectIndexIfChanged(this._ctrlMN_WhereDropDown, SettingsModel.ValidWindowGroups, after.WhereToEnable)
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
            this._chooseCorrectIndexIfChanged(this._ctrlMN_WhereDropDown, SettingsModel.ValidWindowGroups, after.WhereToEnable)
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
            this._chooseCorrectIndexIfChanged(this._ctrlG_ToggleKeyDropDown, SettingsModel.ValidToggleKeys, after.Togglekey)
        }
        If (before.CheckForUpdatesFrequency != after.CheckForUpdatesFrequency)
        {
            this._chooseCorrectIndexIfChanged(this._ctrlG_updatesDropDown, SettingsModel.ValidToggleKeys, after.Togglekey)
        }

        ; Don't care for LastCheckedForUpdate and LatestVersion
    }
}