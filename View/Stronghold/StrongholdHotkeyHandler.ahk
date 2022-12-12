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

        ; Cannot use the model class for storing the hotkeys as the bound methods have to be stored to modify hotkeys
        ;this._hotkeys := {}
        ;this._hotkeys.AutoClicker := OBM(this, "_execAutoClicker")
        ;this._hotkeys.GeneralToggleEnable := OBM(this, "_execGeneral")
        ;this._hotkeys.MapNavigationUp := ""
        ;this._hotkeys.MapNavigationDown := ""
        ;this._hotkeys.MapNavigationLeft := ""
        ;this._hotkeys.MapNavigationRight := ""
        ;this._hotkeys.OpenGranary := OBM(this, "_execReplaceKeys", "OpenGranary")
        ;this._hotkeys.OpenArmoury := OBM(this, "_execReplaceKeys", "OpenArmoury")
        ;this._hotkeys.OpenEngineersGuild := OBM(this, "_execReplaceKeys", "OpenEngineersGuild")
        ;this._hotkeys.OpenKeep := OBM(this, "_execReplaceKeys", "OpenKeep")
        ;this._hotkeys.OpenTunnlerGuild := OBM(this, "_execReplaceKeys", "OpenTunnlerGuild")
        ;this._hotkeys.OpenBarracks := OBM(this, "_execReplaceKeys", "OpenBarracks")
        ;this._hotkeys.OpenMercenaries := OBM(this, "_execReplaceKeys", "OpenMercenaries")
        ;this._hotkeys.OpenMarket := OBM(this, "_execReplaceKeys", "OpenMarket")
        ;this._hotkeys.OpenAdministration := OBM(this, "_execReplaceKeys", "OpenAdministration")
        ;this._hotkeys.SendTauntMessage := OBM(this, "_execReplaceKeys", "SendTauntMessage")
        ;this._hotkeys.IncreaseGameSpeed := OBM(this, "_execReplaceKeys", "IncreaseGameSpeed")
        ;this._hotkeys.DecreaseGameSpeed := OBM(this, "_execReplaceKeys", "DecreaseGameSpeed")
        ;this._hotkeys.TogglePause := OBM(this, "_execReplaceKeys", "TogglePause")

        ;this._initialHotkeyStart()
    }

    __Delete()
    {
        this._settingsModel.RemovePropertyChangeListener(this._eventSettings)
        this._eventSettings := ""
        this._settingsModel := ""
        this._settingsController := ""
        this._hotkeys := ""
    }

    ; Gets called at the start of the class. Initializes all Hotkeys and stores the bound methods in this._hotkeys
    _initialHotkeyStart()
    {
        ac := this._settingsModel.AutoClicker
        g := this._settingsModel.General
        mn := this._settingsModel.MapNavigation
        rk := this._settingsModel.ReplaceKeys

        ; TODO better handling of the window groups
        this._startHotkey(ac.Key, this._hotkeys.AutoClicker, SettingsModel.ValidWindowGroups[3])


    }

    ; Executes the autoclicker command
    _execAutoClicker()
    {
        StrongholdManager.ClickAtCurrentMousePos()
    }

    _execGeneral()
    {
        ; TODO toggle the map nav and the replace keys on and off
    }

    ; Executes the ReplaceKeys command
    _execReplaceKeys(methodName, params*)
    {
        fn := StrongholdManager[methodName]
        If (!IsFunc(fn))
        {
            Return
        }

        If (params.Length())
        {
            %fn%(params*)
        }
        Else
        {
            %fn%()
        }
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
            this._handleAutoClickerEnable(after.Enable)
        }

        If (before.Key != after.Key)
        {
            this._handleAutoClickerKey(after.Key)
        }
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