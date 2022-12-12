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
    }

    _handleAutoClickerHotkeys()
    {
        ac := this._settingsModel.AutoClicker
        validGroups := SettingsModel.ValidWindowGroups

        h := this._getOrCreateHotkey("AutoClicker.Key", ac.Key, "AutoClickAtCurrentMousePos", validGroups[3])
        h.IsActive := ac.Enable
    }

    ; Gets or creates the given hotkey
    _getOrCreateHotkey(ByRef hkName, key, ByRef methodName, ByRef winGroup)
    {
        h := this._hotkeys[hkName]
        this._hotkeys[hkName] := IsObject(h) && key == h.Key && winGroup == h.WinTitle ? h : new Hotkey(key, OBM(StrongholdManager, methodName), winGroup)
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
        ;If (before.Enable !== after.Enable)
        ;{
        ;    this._handleAutoClickerEnable(after.Enable)
        ;}

        ;If (before.Key != after.Key)
        ;{
        ;    this._handleAutoClickerKey(after.Key)
        ;}
    }

    _handleAutoClickerEnable(enable)
    {
        fn := ""
        If (!this._hotkeys.HasKey(this._settingsModel.AutoClicker.Key))
        {

        }
        If (enable)
        {
            this._startHotkey()
        }
    }

    _handleAutoClickerKey(key)
    {

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

        }
        ; Don't care for LastCheckedForUpdate or CheckForUpdatesFrequency
    }
}