class UpdatesChecker extends _Object
{
    static _logger := LoggerFactory.GetLogger(UpdatesChecker)
         ; Check every hour
         , _periodicCheckerTime := 1000 * 60 * 60

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

        this._oneTimeCheckerTimer := ""
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

    ; Gets only called from the ctor and sets the object up
    _initUpdatesCheck()
    {
        frequency := this._settingsModel.General.CheckForUpdatesFrequency

        ; startup
        If (frequency == ECheckForUpdatesFrequency.startup)
        {
            ; Give the app some time to finish booting before checking for updates once
            this._checkInNewThread()
        }
        ; never
        Else If (frequency == ECheckForUpdatesFrequency.never)
        {
            ; Don't do anything
        }
        ; day, week or month
        Else
        {
            ; Start continously checking for updates
            this._startPeriodicChecker()
        }
    }

    ; Sets up the periodic checker
    _startPeriodicChecker()
    {
        ; Get the last checked time and compare with now (before setting the timer).
        If (this._shouldCheckForUpdates())
        {
            this._checkInNewThread()
        }
        ; Now start the timer and check again later
        this._checkerTimer := RecurrenceTimer.StartNew(OBM(this, "_periodicCheck"), UpdatesChecker._periodicCheckerTime)
    }

    ; Starts a timer that triggers in one second and calls the webservice
    _checkInNewThread()
    {
        this._oneTimeCheckerTimer := RecurrenceTimer.StartNew(OBM(this, "_checkForUpdates"), 1000, true)
    }

    ; Makes the controller call the webservice to check for any updates
    _checkForUpdates()
    {
        UpdatesChecker._logger.Debug("Checking for updates...")
        ; Don't make calls to the webservise if in dev mode
        If (!IsDebuggerAttatched())
        {
            this._settingsController.CheckForUpdates()
        }
        UpdatesChecker._logger.Debug("Checking for updates done.")
    }

    ; Gets called by the timer (if checker frequency is "day", "week" "month")
    ; If the time is bigger than the update frequency, check for updates
    _periodicCheck()
    {
        UpdatesChecker._logger.Trace("Periodic checking for updates...")

        If (this._shouldCheckForUpdates())
        {
            this._checkForUpdates()
        }
    }

    ; Determines if this should check for updates
    _shouldCheckForUpdates()
    {
        static secondsPerDay := 60 * 60 * 24
             , secondsPerWeek := 60 * 60 * 24 * 7
             , secondsPerMonth := 60 * 60 * 24 * 31

        frequency := this._settingsModel.General.CheckForUpdatesFrequency
        lastChecked := this._settingsModel.General.LastCheckedForUpdate

        toAdd := frequency == ECheckForUpdatesFrequency.day ? secondsPerDay
               : frequency == ECheckForUpdatesFrequency.week ? secondsPerWeek
               : frequency == ECheckForUpdatesFrequency.month ? secondsPerMonth
               : -1

        Return toAdd == -1 ? false : this._isAfter(this._addSeconds(lastChecked, toAdd), A_Now)
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
        UpdatesChecker._logger.Trace("GeneralModel.CheckForUpdatesFrequency changed. New value: " newValue)

        ; Stop any timer (in case one exists)
        this._checkerTimer := ""

        ; If frequency is "day", "week", "month", start the periodic timer
        If (newValue == ECheckForUpdatesFrequency.day || newValue == ECheckForUpdatesFrequency.week || ECheckForUpdatesFrequency.month)
        {
            this._startPeriodicChecker()
        }
    }

    _handleLastCheckedForUpdatesChanged(newValue)
    {
        UpdatesChecker._logger.Trace("GeneralModel.LastCheckedForUpdate changed. New value: " newValue)
    }

    _handleLatestVersionChanged(newValue)
    {
        UpdatesChecker._logger.Trace("GeneralModel.LatestVersion changed. New value: " newValue)

        ; TODO localization
        If (newValue == "")
        {
            UpdatesChecker._logger.Debug("The updates checking failed.")
            MsgBox("Error", "Could not connect to the web server, please try again later")
        }
        Else If (Stronghold_Version() == newValue)
        {
            UpdatesChecker._logger.Debug("Latest version is already installed: " Stronghold_Version())
            MsgBox("No updates", "You are using the latest version: " Stronghold_Version())
        }
        Else
        {
            UpdatesChecker._logger.Debug("Update is available: " newValue " (currently installed: " Stronghold_Version() ")")
            MsgBox("Update available", "There is an update available for version " newValue "`nYou have " Stronghold_Version())
        }
    }

    ; Returns a positive integer if the first one is later, 0 if same and a negative integer if the second one is later
    _compareTimeStamps(ts1, ts2)
    {
        Return ts1 > ts2 ? 1 : ts1 < ts2 ? -1 : 0
    }

    ; Returns true if the second one is after the first one, false otherwise
    _isAfter(ts1, ts2)
    {
        Return 0 > this._compareTimeStamps(ts1, ts2)
    }

    ; Adds the given amount of seconds to the timeString and returns the new timeString
    _addSeconds(ts, sec)
    {
        ts += sec, Seconds
        Return ts
    }
}