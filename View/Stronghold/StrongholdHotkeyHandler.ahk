class StrongholdHotkeyHandler
{
    static _logger := LoggerFactory.GetLogger(StrongholdHotkeyHandler)

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

    ; Gets called at the start of the class. Creates and initializes all Hotkeys and stores them in this._hotkeys
    _initialHotkeyStart()
    {
        ac := this._settingsModel.AutoClicker
        g := this._settingsModel.General
        validGroups := SettingsModel.ValidWindowGroups

        ; Enable the AutoClicker in both games
        fn := OBM(new AutoClickerExecutor(ac.Key), "Execute")
        this._hotkeys["AutoClicker.Key"] := new ChangeableHotkey(ac.Key, fn, validGroups[3], ac.Enable)

        ; Enable the toggle key in both game
        ; TODO move to own executor object
        fn := OBM(this, "_void")
        this._hotkeys["General.ToggleKey"] := new ChangeableHotkey(g.ToggleKey, fn, validGroups[3], true)
    }

    _handleAutoClickerHotkeys()
    {
        ac := this._settingsModel.AutoClicker
        h := this._hotkeys["AutoClicker.Key"]
        ; Apply all new settings
        h.SetKey(ac.Key)
        h.SetCallback(OBM(new AutoClickerExecutor(ac.Key), "Execute"))
        h.SetEnable(ac.Enable)
    }

    _handleGeneralHotkeys()
    {
        g := this._settingsModel.General
        h := this._hotkeys["General.ToggleKey"]
        ; Apply all new settings
        h.SetKey(g.ToggleKey)
    }

    _void()
    {
        StrongholdHotkeyHandler._logger.Debug("Execute Hotkey " A_ThisHotkey)
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