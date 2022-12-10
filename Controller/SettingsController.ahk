class SettingsController
{
    __New(model)
    {
        If (!InstanceOf(model, SettingsModel))
        {
            throw Exception("Model has a wrong type")
        }

        this._settingsModel := model
    }

    CheckForUpdates()
    {

    }

    SetAutoClickerEnable(enable)
    {
        try this._settingsModel.AutoClicker.Enable := enable
        catch, e
        {
            ; TODO log error
        }
    }

    SetAutoClickerToggleKey(key)
    {
        try this._settingsModel.AutoClicker.Key := key
        catch, e
        {
            ; TODO log error
        }
    }

    SetGeneralToggleKey(key)
    {
        try this._settingsModel.General.ToggleKey := key
        catch, e
        {
            ; TODO log error
        }
    }

    SetGeneralCheckForUpdatesFrequency(frequency)
    {
        try this._settingsModel.General.CheckForUpdatesFrequency := frequency
        catch, e
        {
            ; TODO log error
        }
    }

    SetGeneralLastCheckedForUpdate(dateString)
    {
        try this._settingsModel.General.LastCheckedForUpdate := dateString
        catch, e
        {
            ; TODO log error
        }
    }

    SetMapNavigationEnable(enable)
    {
        try this._settingsModel.MapNavigation.Enable := enable
        catch, e
        {
            ; TODO log error
        }
    }

    SetMapNavigationWhereToEnable(whereToEnable)
    {
        try this._settingsModel.MapNavigation.WhereToEnable := whereToEnable
        catch, e
        {
            ; TODO log error
        }
    }

    SetReplaceKeysWhereToEnable(whereToEnable)
    {
        try this._settingsModel.ReplaceKeys.WhereToEnable := whereToEnable
        catch, e
        {
            ; TODO log error
        }
    }

    SetReplaceKeysOpenGranary(key)
    {
        try this._settingsModel.ReplaceKeys.OpenGranary := key
        catch, e
        {
            ; TODO log error
        }
    }

    SetReplaceKeysOpenArmoury(key)
    {
        try this._settingsModel.ReplaceKeys.OpenArmoury := key
        catch, e
        {
            ; TODO log error
        }
    }

    SetReplaceKeysOpenEngineersGuild(key)
    {
        try this._settingsModel.ReplaceKeys.OpenEngineersGuild := key
        catch, e
        {
            ; TODO log error
        }
    }

    SetReplaceKeysOpenKeep(key)
    {
        try this._settingsModel.ReplaceKeys.OpenKeep := key
        catch, e
        {
            ; TODO log error
        }
    }

    SetReplaceKeysOpenTunnlerGuild(key)
    {
        try this._settingsModel.ReplaceKeys.OpenTunnlerGuild := key
        catch, e
        {
            ; TODO log error
        }
    }

    SetReplaceKeysOpenBarracks(key)
    {
        try this._settingsModel.ReplaceKeys.OpenBarracks := key
        catch, e
        {
            ; TODO log error
        }
    }

    SetReplaceKeysOpenMercenaries(key)
    {
        try this._settingsModel.ReplaceKeys.OpenMercenaries := key
        catch, e
        {
            ; TODO log error
        }
    }

    SetReplaceKeysOpenMarket(key)
    {
        try this._settingsModel.ReplaceKeys.OpenMarket := key
        catch, e
        {
            ; TODO log error
        }
    }

    SetReplaceKeysOpenAdministration(key)
    {
        try this._settingsModel.ReplaceKeys.OpenAdministration := key
        catch, e
        {
            ; TODO log error
        }
    }

    SetReplaceKeysSendRandomTauntMessage(key)
    {
        try this._settingsModel.ReplaceKeys.SendRandomTauntMessage := key
        catch, e
        {
            ; TODO log error
        }
    }

    SetReplaceKeysIncreaseGameSpeed(key)
    {
        try this._settingsModel.ReplaceKeys.IncreaseGameSpeed := key
        catch, e
        {
            ; TODO log error
        }
    }

    SetReplaceKeysDecreaseGameSpeed(key)
    {
        try this._settingsModel.ReplaceKeys.DecreaseGameSpeed := key
        catch, e
        {
            ; TODO log error
        }
    }
}