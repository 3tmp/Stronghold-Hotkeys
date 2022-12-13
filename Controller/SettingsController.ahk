class SettingsController
{
    __New(model, iniPath)
    {
        If (!InstanceOf(model, SettingsModel))
        {
            throw Exception("Model has a wrong type")
        }

        this._settingsModel := model
        this._iniPath := iniPath
    }

    CheckForUpdates()
    {
        currentVersion := Stronghold_Version()
        url := StrongholdHotkeyLatestReleaseApiUrl()

        requestFail := false

        try
        {
            ; Check for the last Version (synchronous call)
            whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
            whr.Open("GET", url, true)
            whr.Send()
            whr.WaitForResponse()
        }
        catch, e
        {
            requestFail := true
        }

        If (!requestFail)
        {
            webResult := Jxon_Load(whr.ResponseText)

            latestVersion := webResult.tag_name.StartsWith("v") ? webResult.tag_name.SubStr(2) : webResult.tag_name

            this._settingsModel.General.LastCheckedForUpdate := A_NowUTC
            this._settingsModel.General.LatestVersion := latestVersion
        }
        Else
        {
            ; TODO better error state
            this._settingsModel.General.LastCheckedForUpdate := "1970"
            this._settingsModel.General.LatestVersion := ""
        }
        this.SaveToFile()
    }

    SaveToFile()
    {
        iniStr := this._settingsModel.ToIniString()
        If (FileExist(this._iniPath))
        {
            FileDelete(this._iniPath)
        }
        FileAppend(iniStr, this._iniPath)
    }

    ResetAutoClicker()
    {
        this._settingsModel.ResetAutoClicker()
    }

    ResetMapNavigation()
    {
        this._settingsModel.ResetMapNavigation()
    }

    ResetReplaceKeys()
    {
        this._settingsModel.ResetReplaceKeys()
    }

    ResetGeneral()
    {
        this._settingsModel.ResetGeneral()
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

    SetReplaceKeysByProperty(propertyName, key)
    {
        Switch propertyName
        {
            Case "Enable":
                this.SetReplaceKeysEnable(key)
            Case "WhereToEnable":
                this.SetReplaceKeysWhereToEnable(key)
            Case "OpenGranary":
                this.SetReplaceKeysOpenGranary(key)
            Case "OpenArmoury":
                this.SetReplaceKeysOpenArmoury(key)
            Case "OpenEngineersGuild":
                this.SetReplaceKeysOpenEngineersGuild(key)
            Case "OpenKeep":
                this.SetReplaceKeysOpenKeep(key)
            Case "OpenTunnlerGuild":
                this.SetReplaceKeysOpenTunnlerGuild(key)
            Case "OpenBarracks":
                this.SetReplaceKeysOpenBarracks(key)
            Case "OpenMercenaries":
                this.SetReplaceKeysOpenMercenaries(key)
            Case "OpenMarket":
                this.SetReplaceKeysOpenMarket(key)
            Case "OpenAdministration":
                this.SetReplaceKeysOpenAdministration(key)
            Case "SendRandomTauntMessage":
                this.SetReplaceKeysSendRandomTauntMessage(key)
            Case "IncreaseGameSpeed":
                this.SetReplaceKeysIncreaseGameSpeed(key)
            Case "DecreaseGameSpeed":
                this.SetReplaceKeysDecreaseGameSpeed(key)
            Default:
                ; TODO log
                throw Exception("The property '" propertyName "' is not supported")
        }
    }

    SetReplaceKeysEnable(enable)
    {
        try this._settingsModel.ReplaceKeys.Enable := enable
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