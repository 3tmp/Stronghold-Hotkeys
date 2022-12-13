class StrongholdHotkeyHandler
{
    __New(controller, model)
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

        ; A map that contains all hotkeys. Key is category "." Commandname (e.g. "ReplaceKeys.OpenMarket"), value is the hotkey object
        this._hotkeys := {}

        this._initialHotkeyStart()
    }

    __Delete()
    {
        ; TODO move into Destroy method as the destructor will never be executed as long as this._eventSetting is not blank
        this._settingsModel.RemovePropertyChangeListener(this._eventSettings)
        this._eventSettings := ""
        this._settingsModel := ""
        this._settingsController := ""
        ; Calls the destructor of each hotkey which internally disables the hotkey
        this._hotkeys := ""
    }

    ; Gets called at the start of the class. Initializes all Hotkeys and stores the bound methods in this._hotkeys
    _initialHotkeyStart()
    {
        ; Enable the AutoClicker in both games
        this._handleAutoClickerHotkeys()
        ; Enable the toggle key in both game
        this._handleGeneralHotkeys()
    }

    _handleAutoClickerHotkeys()
    {
        ac := this._settingsModel.AutoClicker
        validGroups := SettingsModel.ValidWindowGroups

        ; TODO move to own executor object
        h := this._getOrCreateHotkey("AutoClicker.Key", ac.Key, OBM(StrongholdManager, "AutoClickAtCurrentMousePos"), validGroups[3])
        h.IsActive := ac.Enable
    }

    _handleGeneralHotkeys()
    {
        g := this._settingsModel.General
        validGroups := SettingsModel.ValidWindowGroups

        ; TODO this is just a dummy function
        h := this._getOrCreateHotkey("General.ToggleKey", g.ToggleKey, OBM(this, "_void"), validGroups[3])
        h.IsActive := true
    }

    _void()
    {
        OutputDebug(A_Now " Execute Hotkey " A_ThisHotkey)
    }

    ; Gets or creates the given hotkey
    _getOrCreateHotkey(ByRef hkName, key, callback, ByRef winGroup)
    {
        h := this._hotkeys[hkName]
        this._hotkeys[hkName] := IsObject(h) && key == h.Key && winGroup == h.WinTitle ? h : new Hotkey(key, callback, winGroup)
        Return this._hotkeys[hkName]
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
        this._handleAutoClickerHotkeys()
    }

    ; before, after instance of MapNavigationModel
    _handleMapNavigation(before, after)
    {
        If (before.Enable !== after.Enable)
        {

        }

        If (before.WhereToEnable != after.WhereToEnable)
        {

        }
    }

    ; before, after instance of ReplaceKeyModel
    _handleReplaceKeys(before, after)
    {

    }

    ; before, after instance of GeneralModel
    _handleGeneral(before, after)
    {
        If (before.Togglekey != after.ToggleKey)
        {
            this._handleGeneralHotkeys()
        }
        ; Don't care for any other properties
    }
}