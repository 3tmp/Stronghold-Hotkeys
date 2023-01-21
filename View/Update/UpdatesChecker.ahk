class UpdatesChecker extends _Object
{
    static _logger := LoggerFactory.GetLogger(UpdatesChecker)

    __New(controller, model)
    {
        If (!InstanceOf(controller, SettingsController))
        {
            throw new IsInterfaceException("Controller has a wrong type")
        }
        If (!InstanceOf(model, SettingsModel))
        {
            throw new IsInterfaceException("Model has a wrong type")
        }

        this._settingsController := controller
        this._settingsModel := model
        ; Only get the "General" event, don't care for the other events
        this._eventSettings := new PropertyChangeListener(OBM(this, "_onPropChangeEventSettings"), SettingsModel.Events.General)
        this._settingsModel.AddPropertyChangeListener(this._eventSettings)

        this._oneTimeCheckerTimer := ""

        this._initUpdatesCheck()
    }

    __Delete()
    {
        this._settingsModel.RemovePropertyChangeListener(this._eventSettings)
        this._eventSettings := ""
        this._settingsModel := ""
        this._settingsController := ""
    }

    ; Gets only called from the ctor and sets the object up
    _initUpdatesCheck()
    {
        frequency := this._settingsModel.General.CheckForUpdatesFrequency

        If (frequency == ECheckForUpdatesFrequency.never)
        {
            ; Don't do anything
            Return
        }
        If (frequency == ECheckForUpdatesFrequency.startup)
        {
            ; Give the app some time to finish booting before checking for updates once
            this._checkInNewThread()
        }
    }

    ; Starts a timer that triggers in one second and calls the webservice
    _checkInNewThread()
    {
        this._oneTimeCheckerTimer := RecurrenceTimer.StartNew(OBM(this, "_checkForUpdates"), 1000, true)
    }

    ; Makes the controller call the webservice to check for any updates
    _checkForUpdates()
    {
        ; Release the timer
        this._oneTimeCheckerTimer := ""

        UpdatesChecker._logger.Debug("Checking for updates...")
        ; Don't make calls to the webservise if in dev mode
        If (IsDebuggerAttatched())
        {
            UpdatesChecker._logger.Debug("App is in dev mode, do not call out to the webservice.")
        }
        Else
        {
            this._settingsController.CheckForUpdates()
        }
        UpdatesChecker._logger.Debug("Checking for updates done.")
    }

    ; SettingsModel events

    _onPropChangeEventSettings(event)
    {
        ; Can only be the General event as we are only listening out for this event
        this._handleGeneral(event.OldValue, event.NewValue)
    }

    ; before, after instance of GeneralModel
    _handleGeneral(before, after)
    {
        If (before.CheckForUpdatesFrequency !== after.CheckForUpdatesFrequency)
        {
            this._handleCheckUpdatesFrequencyChanged(after.CheckForUpdatesFrequency)
        }
        If (before.LastCheckedForUpdate !== after.LastCheckedForUpdate)
        {
            this._handleLastCheckedForUpdatesChanged(after.LastCheckedForUpdate)
        }
        If (before.LatestVersion !== after.LatestVersion)
        {
            this._handleLatestVersionChanged(after.LatestVersion)
        }

        ; Don't care for ToggleKey
    }

    _handleCheckUpdatesFrequencyChanged(newValue)
    {
        UpdatesChecker._logger.Trace("GeneralModel.CheckForUpdatesFrequency changed. New value: " newValue)

        ; If frequency is "day", "week", "month"
        If (newValue == ECheckForUpdatesFrequency.day || newValue == ECheckForUpdatesFrequency.week || ECheckForUpdatesFrequency.month)
        {
            UpdatesChecker._logger.Warn("Unsupported value: " newValue)
        }
    }

    _handleLastCheckedForUpdatesChanged(newValue)
    {
        UpdatesChecker._logger.Trace("GeneralModel.LastCheckedForUpdate changed. New value: " newValue)

        l := GetLanguage()
        latestVersion := this._settingsModel.General.LatestVersion

        If (latestVersion == "")
        {
            UpdatesChecker._logger.Debug("The updates checking failed.")
            MsgBox(l.UpdateErrorTitle, l.UpdateErrorText)
        }
        Else If (Stronghold_Version() == latestVersion)
        {
            UpdatesChecker._logger.Debug("Latest version is already installed: " Stronghold_Version())
            MsgBox(l.UpdateNoUpdateTitle, Format(l.UpdateNoUpdateText, Stronghold_Version()))
        }
        Else If (VerCompare(Stronghold_Version(), "<" latestVersion))
        {
            UpdatesChecker._logger.Debug("Update is available: " newValue " (currently installed: " Stronghold_Version() ")")
            this._promptDownload(latestVersion)
        }
        Else
        {
            UpdatesChecker._logger.Debug("Latest version is lower than the installed one. Installed: " Stronghold_Version() ", latest: " latestVersion)
            MsgBox(l.UpdateNoUpdateTitle, Format(l.UpdateNoUpdateText, Stronghold_Version()))
        }
    }

    _handleLatestVersionChanged(newValue)
    {
        UpdatesChecker._logger.Trace("GeneralModel.LatestVersion changed. New value: " newValue)
    }

    _promptDownload(newVersion)
    {
        l := GetLanguage()

        OnMessage(0x44, OBM(this, "_onMsgBox"))
        choise := MsgBox(1, l.UpdateAvailableTitle, Format(l.UpdateAvailableText, newVersion, Stronghold_Version()))
        OnMessage(0x44, fn, 0)

        ; User clicked on the "Download" button
        If (choise == "Ok")
        {
            Run(StrongholdHotkeysLatestRelease())
        }
    }

    _onMsgBox()
    {
        dhw := DetectHiddenWindows("On")
        If (WinExist("ahk_class #32770 ahk_pid " WinApi_GetCurrentProcessId()))
        {
            l := GetLanguage()
            ControlSetText("Button1", l.UpdateDownload)
            ControlSetText("Button2", l.UpdateOk)
        }
        DetectHiddenWindows(dhw)
    }
}