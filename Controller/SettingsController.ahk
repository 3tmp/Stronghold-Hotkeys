class SettingsController extends _Object
{
    static _logger := LoggerFactory.GetLogger(SettingsController)

    __New(model, iniPath)
    {
        If (!InstanceOf(model, SettingsModel))
        {
            throw new UnsupportedTypeException("Model has a wrong type")
        }

        this._settingsModel := model
        this._iniPath := iniPath
    }

    CheckForUpdates()
    {
        currentVersion := Stronghold_Version()
        url := StrongholdHotkeyLatestReleaseApiUrl()

        requestFail := false

        SettingsController._logger.Debug("Checking for updates...")
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
            SettingsController._logger.Debug("Checking for updates successful.")

            webResult := Jxon_Load(whr.ResponseText)

            latestVersion := webResult.tag_name.StartsWith("v") ? webResult.tag_name.SubStr(2) : webResult.tag_name

            this._settingsModel.General.LastCheckedForUpdate := A_NowUTC
            this._settingsModel.General.LatestVersion := latestVersion
        }
        Else
        {
            SettingsController._logger.Debug("Checking for updates failed.")

            ; TODO better error state
            this._settingsModel.General.LastCheckedForUpdate := "1970"
            this._settingsModel.General.LatestVersion := ""
        }
        this.SaveToFile()
    }

    SaveToFile()
    {
        SettingsController._logger.Debug("Saving the model to file.")

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
            SettingsController._logger.Warn("Setting AutoClicker.Enable failed. Error: {}", e)
        }
    }

    SetAutoClickerToggleKey(key)
    {
        try this._settingsModel.AutoClicker.Key := key
        catch, e
        {
            SettingsController._logger.Warn("Setting AutoClicker.Key failed. Error: {}", e)
        }
    }

    SetGeneralToggleKey(key)
    {
        try this._settingsModel.General.ToggleKey := key
        catch, e
        {
            SettingsController._logger.Warn("Setting General.ToggleKey failed. Error: {}", e)
        }
    }

    SetGeneralCheckForUpdatesFrequency(frequency)
    {
        try this._settingsModel.General.CheckForUpdatesFrequency := frequency
        catch, e
        {
            SettingsController._logger.Warn("General.CheckForUpdatesFrequency failed. Error: {}", e)
        }
    }

    SetGeneralLastCheckedForUpdate(dateString)
    {
        try this._settingsModel.General.LastCheckedForUpdate := dateString
        catch, e
        {
            SettingsController._logger.Warn("Setting General.LastCheckedForUpdate failed. Error: {}", e)
        }
    }

    SetMapNavigationEnable(enable)
    {
        try this._settingsModel.MapNavigation.Enable := enable
        catch, e
        {
            SettingsController._logger.Warn("Setting MapNavigation.Enable failed. Error: {}", e)
        }
    }

    SetMapNavigationWhereToEnable(whereToEnable)
    {
        try this._settingsModel.MapNavigation.WhereToEnable := whereToEnable
        catch, e
        {
            SettingsController._logger.Warn("Setting MapNavigation.WhereToEnable failed. Error: {}", e)
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
            Case "GoToSignPost":
                this.SetReplaceKeysGoToSignPost(key)
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
            Case "RotateScreenClockWise":
                this.SetReplaceKeysRotateScreenClockWise(key)
            Case "RotateScreenCounterClockWise":
                this.SetReplaceKeysRotateScreenCounterClockWise(key)
            Case "ToggleUI":
                this.SetReplaceKeysToggleUI(key)
            Case "ToggleZoom":
                this.SetReplaceKeysToggleZoom(key)
            Case "TogglePause":
                this.SetReplaceKeysTogglePause(key)
            Case "SendRandomTauntMessage":
                this.SetReplaceKeysSendRandomTauntMessage(key)
            Case "IncreaseGameSpeed":
                this.SetReplaceKeysIncreaseGameSpeed(key)
            Case "DecreaseGameSpeed":
                this.SetReplaceKeysDecreaseGameSpeed(key)
            Default:
                SettingsController._logger.Warn("Passed an invalid propertyName. Name: '" propertyName "'")
                throw new IllegalArgumentException("The property '" propertyName "' is not supported")
        }
    }

    SetReplaceKeysEnable(enable)
    {
        try this._settingsModel.ReplaceKeys.Enable := enable
        catch, e
        {
            SettingsController._logger.Warn("Setting ReplaceKeys.Enable failed. Error: {}", e)
        }
    }

    SetReplaceKeysWhereToEnable(whereToEnable)
    {
        try this._settingsModel.ReplaceKeys.WhereToEnable := whereToEnable
        catch, e
        {
            SettingsController._logger.Warn("Setting ReplaceKeys.WhereToEnable failed. Error: {}", e)
        }
    }

    SetReplaceKeysOpenGranary(key)
    {
        try this._settingsModel.ReplaceKeys.OpenGranary := key
        catch, e
        {
            SettingsController._logger.Warn("Setting ReplaceKeys.OpenGranary failed. Error: {}", e)
        }
    }

    SetReplaceKeysGoToSignPost(key)
    {
        try this._settingsModel.ReplaceKeys.GoToSignPost := key
        catch, e
        {
            SettingsController._logger.Warn("Setting ReplaceKeys.GoToSignPost failed. Error: {}", e)
        }
    }

    SetReplaceKeysOpenEngineersGuild(key)
    {
        try this._settingsModel.ReplaceKeys.OpenEngineersGuild := key
        catch, e
        {
            SettingsController._logger.Warn("Setting ReplaceKeys.OpenEngineersGuild failed. Error: {}", e)
        }
    }

    SetReplaceKeysOpenKeep(key)
    {
        try this._settingsModel.ReplaceKeys.OpenKeep := key
        catch, e
        {
            SettingsController._logger.Warn("Setting ReplaceKeys.OpenKeep failed. Error: {}", e)
        }
    }

    SetReplaceKeysOpenTunnlerGuild(key)
    {
        try this._settingsModel.ReplaceKeys.OpenTunnlerGuild := key
        catch, e
        {
            SettingsController._logger.Warn("Setting ReplaceKeys.OpenTunnlerGuild failed. Error: {}", e)
        }
    }

    SetReplaceKeysOpenBarracks(key)
    {
        try this._settingsModel.ReplaceKeys.OpenBarracks := key
        catch, e
        {
            SettingsController._logger.Warn("Setting ReplaceKeys.OpenBarracks failed. Error: {}", e)
        }
    }

    SetReplaceKeysOpenMercenaries(key)
    {
        try this._settingsModel.ReplaceKeys.OpenMercenaries := key
        catch, e
        {
            SettingsController._logger.Warn("Setting ReplaceKeys.OpenMercenaries failed. Error: {}", e)
        }
    }

    SetReplaceKeysOpenMarket(key)
    {
        try this._settingsModel.ReplaceKeys.OpenMarket := key
        catch, e
        {
            SettingsController._logger.Warn("Setting ReplaceKeys.OpenMarket failed. Error: {}", e)
        }
    }

    SetReplaceKeysRotateScreenClockWise(key)
    {
        try this._settingsModel.ReplaceKeys.RotateScreenClockWise := key
        catch, e
        {
            SettingsController._logger.Warn("Setting ReplaceKeys.RotateScreenClockWise failed. Error: {}", e)
        }
    }

    SetReplaceKeysRotateScreenCounterClockWise(key)
    {
        try this._settingsModel.ReplaceKeys.RotateScreenCounterClockWise := key
        catch, e
        {
            SettingsController._logger.Warn("Setting ReplaceKeys.RotateScreenCounterClockWise failed. Error: {}", e)
        }
    }

    SetReplaceKeysToggleUI(key)
    {
        try this._settingsModel.ReplaceKeys.ToggleUI := key
        catch, e
        {
            SettingsController._logger.Warn("Setting ReplaceKeys.ToggleUI failed. Error: {}", e)
        }
    }

    SetReplaceKeysToggleZoom(key)
    {
        try this._settingsModel.ReplaceKeys.ToggleZoom := key
        catch, e
        {
            SettingsController._logger.Warn("Setting ReplaceKeys.ToggleZoom failed. Error: {}", e)
        }
    }

    SetReplaceKeysTogglePause(key)
    {
        try this._settingsModel.ReplaceKeys.TogglePause := key
        catch, e
        {
            SettingsController._logger.Warn("Setting ReplaceKeys.TogglePause failed. Error: {}", e)
        }
    }

    SetReplaceKeysSendRandomTauntMessage(key)
    {
        try this._settingsModel.ReplaceKeys.SendRandomTauntMessage := key
        catch, e
        {
            SettingsController._logger.Warn("Setting ReplaceKeys.SendRandomTauntMessage failed. Error: {}", e)
        }
    }

    SetReplaceKeysIncreaseGameSpeed(key)
    {
        try this._settingsModel.ReplaceKeys.IncreaseGameSpeed := key
        catch, e
        {
            SettingsController._logger.Warn("Setting ReplaceKeys.IncreaseGameSpeed failed. Error: {}", e)
        }
    }

    SetReplaceKeysDecreaseGameSpeed(key)
    {
        try this._settingsModel.ReplaceKeys.DecreaseGameSpeed := key
        catch, e
        {
            SettingsController._logger.Warn("Setting ReplaceKeys.DecreaseGameSpeed failed. Error: {}", e)
        }
    }
}