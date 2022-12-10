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

        base.__New(title, options)
    }

    BuildGui()
    {
        this._width := 400
        this._height := 400
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

    ; Gui building helper

    ; General
    _buildTab1()
    {
        this.AddText("w" this._width, "This is the General description")
        this.AddText()
        this.AddText(, "This is the Toggle key description")
        this._ctrlG_ToggleKeyDropDown := this.AddDropDownList("Choose1", SettingsModel.ValidToggleKeys).OnSelectionChange(OBM(this, "_onG_ToggleKeyDropDownChange"))

        this._ctrlG_updatesDropDown := this.AddDropDownList("Choose1", SettingsModel.ValidCheckForUpdatesFrequency).OnSelectionChange(OBM(this, "_onG_updatesDropDown"))
        this._ctrlG_updateNowBtn := this.AddButton(, "Check for updates").OnClick(OBM(this, "_onG_UpdateNowBtnClick"))
    }

    ; AutoClicker
    _buildTab2()
    {
        this.AddText("w" this._width, "This is the autoclicker description")
        this.AddText()
        this._ctrlAC_Check := this.AddCheckBox("Checked", "Enable AutoClicker").OnClick(OBM(this, "_onAC_CheckClick"))
        this._ctrlAC_Text := this.AddText(, "Send clicks as long as the following key gets pressed down")
        this._ctrlAC_DropDown := this.AddDropDownList("Choose1", SettingsModel.ValidAutoClickerKeys).OnSelectionChange(OBM(this, "_onAC_DropDownChange"))
    }

    ; Map navigation
    _buildTab3()
    {
        this.AddLink(, "Description and the UCP Website")
        this.AddText()
        this._ctrlMN_EnableCheck := this.AddCheckbox("Checked", "Enable Map Navigation").OnClick(OBM(this, "_onMN_EnableCheck"))
        this._ctrlMN_Text1 := this.AddText(, "Enable only when ")
        this._ctrlMN_WhereDropDown := this.AddDropDownList("x+0 Choose1", SettingsModel.ValidWindowGroupes).OnSelectionChange(OBM(this, "_onMN_WhereDropDown"))
        this._ctrlMN_Text2 := this.AddText("x+0", " is the active game")
    }

    ; Raplacing keys
    _buildTab4()
    {
        this.AddText(, "Description of replace keys")
        this.AddText()

        this._ctrlRK_Text1 := this.AddText("Section", "Enable only when ")
        this._ctrlRK_WhereDropDown := this.AddDropDownList("x+0 Choose1", SettingsModel.ValidWindowGroupes).OnSelectionChange(OBM(this, "_onRK_WhereDropDown"))
        this._ctrlRK_Text2 := this.AddText("x+0", " is the active game")

        noHdrReorder := "-LV0x10"
        lvOptions := "xs w" (this._width - this._margin * 3) " R10 -Multi NoSort NoSortHdr Grid " noHdrReorder
        this._ctrlRK_Lv := this.AddListView(lvOptions, ["Command", "Key"])

        this._refillRKListView()

        Loop, % this._ctrlRK_Lv.ColumnCount
        {
            this._ctrlRK_Lv.ModifyCol(A_Index, "AutoHdr")
        }
        this._ctrlRK_Lv.OnRowFocused(OBM(this, "_onRK_LvRowFocused"))

        this._ctrlRK_Hotkey := this.AddHotkey("Section Disabled").OnHotkeyChange(OBM(this, "_onRK_HotkeyChange"))

        this._ctrlRK_ApplyHotkeyBtn := this.AddButton("x+m Disabled", "Apply Hotkey").OnClick(OBM(this, "_onRK_ApplyHotkeyBtnClick"))

        this._ctrlRK_RemoveHotkeyBtn := this.AddButton("x+m Disabled", "Remove binding").OnClick(OBM(this, "_onRK_RemoveHotkeyBtnClick"))

        this._ctrlRK_HotkeyInUseText := this.AddText("xs Hidden", "Hotkey is already in use")

        this._ctrlRK_ResetToDefaultsBtn := this.AddButton(, "Reset to default").OnClick(OBM(this, "_onRK_ResetToDefaultBtnClick"))
    }

    ; Gets called before the gui gets destroyed
    OnDestroy()
    {
        this._settingsModel.RemovePropertyChangeListener(this._eventSettings)
        this._eventSettings := ""
        this._settingsModel := ""
        this._settingsController := ""
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

    _tempOnEvent(eventArgs)
    {
        ToolTip, % eventArgs.ToString()
        Sleep, 1000
        ToolTip
    }

    _enableHotkeyAndSetValue()
    {
        this._ctrlRK_Hotkey.KeyComboString := this._getFocusedLvRow().At(2).Text
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
        this._hideHotkeyInUseWarning()
    }

    _showHotkeyInUseWarning()
    {
        this._ctrlRK_HotkeyInUseText.Show()
    }

    _hideHotkeyInUseWarning()
    {
        this._ctrlRK_HotkeyInUseText.Hide()
    }

    ; Determines if any ReplaceKey contains the given key combo string
    _isKeyInUse(keyCombo)
    {
        Return keyCombo !== "" && this._settingsModel.ReplaceKeys.ContainsAny(keyCombo)
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

    ; Gui events

    OnClose()
    {
        ; TODO save to file
        this.Destroy()
    }

    ; Gui control events

    _onOkBtnClick(eventArgs)
    {
        ; TODO save to file
        this.Close()
    }

    _onCancelBtnClick(eventArgs)
    {
        this.Close()
    }

    _onG_ToggleKeyDropDownChange(eventArgs)
    {
        this._tempOnEvent(eventArgs)
    }

    _onG_updatesDropDown(eventArgs)
    {
        this._tempOnEvent(eventArgs)
    }

    _onG_UpdateNowBtnClick(eventArgs)
    {
        this._tempOnEvent(eventArgs)
    }

    _onAC_CheckClick(eventArgs)
    {
        this._tempOnEvent(eventArgs)
    }

    _onAC_DropDownChange(eventArgs)
    {
        this._tempOnEvent(eventArgs)
    }

    _onMN_EnableCheck(eventArgs)
    {
        this._tempOnEvent(eventArgs)
    }

    _onMN_WhereDropDown(eventArgs)
    {
        this._tempOnEvent(eventArgs)
    }

    _onRK_WhereDropDown(eventArgs)
    {
        this._tempOnEvent(eventArgs)
    }

    _onRK_LvRowFocused(eventArgs)
    {
        this._enableHotkeyAndSetValue()
    }

    _onRK_ResetToDefaultBtnClick(eventArgs)
    {
        ; Ask for user confirm
        ; TODO localization
        If ("Yes" == MsgBox(4, "Reset", "Reset hotkey mapping?"))
        {
            ; Set ReplaceKeys to the system defaults
            this._settingsModel.ResetReplaceKeys()
        }
    }

    _onRK_HotkeyChange(eventArgs)
    {
        If (this._isKeyInUse(eventArgs.KeyComboString))
        {
            this._showHotkeyInUseWarning()
        }
        Else
        {
            this._hideHotkeyInUseWarning()
        }
    }

    _onRK_ApplyHotkeyBtnClick(eventArgs)
    {
        keyCombo := this._ctrlRK_Hotkey.KeyComboString
        replaceKeys := this._settingsModel.ReplaceKeys
        action := this._getFocusedLvRow().At(1).Text

        If (!this._isKeyInUse(keyCombo) && replaceKeys[action] !== keyCombo)
        {
            replaceKeys[action] := keyCombo
        }
        Else
        {
            ; TODO localization
            Msgbox("Hotkey is already in use, choose a differrent one")
        }
    }

    _onRK_RemoveHotkeyBtnClick(eventArgs)
    {
        clicker := this._settingsModel.AutoClicker
        clicker.Enable ^= true
        this._settingsModel.AutoClicker := clicker
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
            this._ctrlAC_DropDown.IsEnabled := after.Enable
            this._ctrlAC_Text.IsEnabled := after.Enable
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
            this._ctrlMN_WhereDropDown.IsEnabled := after.Enable
            this._ctrlMN_Text1.IsEnabled := after.Enable
            this._ctrlMN_Text2.IsEnabled := after.Enable
        }

        If (before.WhereToEnable != after.WhereToEnable)
        {
            this._chooseCorrectIndexIfChanged(this._ctrlMN_WhereDropDown, SettingsModel.ValidWindowGroupes, after.WhereToEnable)
        }
    }

    ; before, after instance of ReplaceKeyModel
    _handleReplaceKeys(before, after)
    {
        If (before.WhereToEnable != after.WhereToEnable)
        {
            this._chooseCorrectIndexIfChanged(this._ctrlMN_WhereDropDown, SettingsModel.ValidWindowGroupes, after.WhereToEnable)
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
        ; Don't care for LastCheckedForUpdate
    }
}