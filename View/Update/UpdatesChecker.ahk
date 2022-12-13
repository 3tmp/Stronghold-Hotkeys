class UpdatesChecker
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

        this._checkerTimer := ""

        this._initUpdatesCheck()
    }

    __Delete()
    {
        this._settingsModel.RemovePropertyChangeListener(this._eventSettings)
        this._eventSettings := ""
        this._settingsModel := ""
        this._settingsController := ""
        ; Dispose the timer
        this._checkerTimer := ""
    }

    _initUpdatesCheck()
    {
        frequency := this._settingsModel.General.CheckForUpdatesFrequency
        validFrequencies := SettingsModel.ValidCheckForUpdatesFrequency

        ; startup
        If (frequency == validFrequencies[1])
        {
            ; Give the app some time to finish booting before checking for updates once
            this._checkerTimer := RecurrenceTimer.StartNew(OBM(this, "_checkForUpdates"), 1000, true)
        }
        ; never
        Else If (frequency == validFrequencies[5])
        {
            ; Don't do anything
        }
        ; day, week or month
        Else
        {
            ; TODO Get the last checked time and compare with now (before setting the timer). Then start the timer
            this._checkerTimer := RecurrenceTimer.StartNew(OBM(this, "_periodicCheck"), 1000 * 60 * 60)
        }
    }

    _checkForUpdates()
    {
        OutputDebug(A_Now " Checking for updates...")
        ; If option is "startup" don't always make calls to the webservise if in dev mode
        If (!IsDebuggerAttatched())
        {
            this._settingsController.CheckForUpdates()
        }
    }

    _periodicCheck()
    {

    }

    ; SettingsModel events

    _onPropChangeEventSettings(event)
    {
        Switch event.Name
        {
            Case SettingsModel.Events.General:
                this._handleGeneral(event.OldValue, event.NewValue)
        }
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
        OutputDebug("GeneralModel.CheckForUpdatesFrequency changed. New value: " newValue)
    }

    _handleLastCheckedForUpdatesChanged(newValue)
    {
        OutputDebug("GeneralModel.LastCheckedForUpdate changed. New value: " newValue)
    }

    _handleLatestVersionChanged(newValue)
    {
        OutputDebug("GeneralModel.LatestVersion changed. New value: " newValue)

        If (Stronghold_Version() == newValue)
        {
            MsgBox("No updates", "You are using the latest version: " Stronghold_Version())
        }
        Else
        {
            MsgBox("Update available", "There is an update available for version " newValue "`nYou have " Stronghold_Version())
        }
    }
}