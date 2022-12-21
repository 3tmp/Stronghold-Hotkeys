class Application
{
    static _applicationName := "Stronghold Hotkeys"
         , _iniPath := "Config.ini"
         , _logger := LoggerFactory.GetLogger(Application)

    __New()
    {
        this._settingsModel := ""
        this._settingsController := ""
        this._settingsGui := ""
        this._hotkeyHandler := ""
        this._updateChecker := ""

        this._errorLogger := ""
        this._exitLogger := ""
    }

    Initialize()
    {
        ; Set up the logger
        If (IsDebuggerAttatched())
        {
            LoggerFactory.SetMinLogLevel(_logLevel.Trace)
            LoggerFactory.SetBufferSize(1)
        }
        Else
        {
            LoggerFactory.SetMinLogLevel(_logLevel.Warn)
            LoggerFactory.SetBufferSize(1)
        }
        this._errorLogger := LoggerFactory.GetErrorLogger()
        this._exitLogger := LoggerFactory.GetExitLogger()

        Application._logger.Info("App is starting up...")

        If (IsDebuggerAttatched())
        {
            Application._logger.Info("App is running in dev mode.")
        }

        this._registerWindowGroups()

        ; Create the settings model from the config file (if it exists), otherwise create a default one
        If (FileExist(Application._iniPath))
        {
            Application._logger.Trace("Applying the saved settings.")
            readConfig := FileRead(Application._iniPath)
            this._settingsModel := SettingsModel.FromIniString(readConfig)
        }
        Else
        {
            Application._logger.Trace("No saved settings. Use the default settings.")
            this._settingsModel := SettingsModel.Default()
        }

        this._settingsController := new SettingsController(this._settingsModel, Application._iniPath)

        this._hotkeyHandler := new StrongholdHotkeyHandler(this._settingsController, this._settingsModel)
        this._updateChecker := new UpdatesChecker(this._settingsController, this._settingsModel)

        ; Set up the tray menu (has to be done before the gui to ensure the Stronghold icon in the window title bar)
        TrayMenu.Instance.Init(this)

        ; Only show the gui when no config file exists (usually the first load), or if the app is in dev mode
        If (!FileExist(Application._iniPath) || IsDebuggerAttatched())
        {
            this._settingsController.SaveToFile()
            this._getOrCreateSettingsGui().Show()
        }

        Application._logger.Info("App startup finished.")
    }

    ; Get a reference to a settings gui instance
    SettingsGui[]
    {
        Get
        {
            Return this._getOrCreateSettingsGui()
        }
    }

    ; The central application exit point
    ExitApp()
    {
        Application._logger.Info("App is shutting down...")
        ExitApp
    }

    ; Register the Stronghold window groups via the GroupAdd command
    _registerWindowGroups()
    {
        static isRegistered := false
        If (isRegistered)
        {
            Return
        }

        For each, group in EWindowGroups
        {
            GroupAdd(group, StrongholdManager.WindowTitles[group])
        }
        isRegistered := true
    }

    _getOrCreateSettingsGui()
    {
        If (this._settingsGui == "" || this._settingsGui.IsDestroyed)
        {
            title := Stronghold_Version().Format(GetLanguage().Title)
            this._settingsGui := new SettingsGui(this._settingsController, this._settingsModel, title)
        }
        Return this._settingsGui
    }
}