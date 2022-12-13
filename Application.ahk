class Application
{
    static _applicationName := "Stronghold Hotkeys"
         , _iniPath := "Config.ini"

    __New()
    {
        this._settingsModel := ""
        this._settingsController := ""
        this._settingsGui := ""
        this._hotkeyHandler := ""
        this._updateChecker := ""
    }

    Initialize()
    {
        this._registerWindowGroups()

        ; Create the settings model from the config file (if it exists), otherwise create a default one
        If (FileExist(Application._iniPath))
        {
            readConfig := FileRead(Application._iniPath)
            this._settingsModel := SettingsModel.FromIniString(readConfig)
        }
        Else
        {
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

        For each, group in SettingsModel.ValidWindowGroups
        {
            GroupAdd(group, StrongholdManager.WindowTitles[group])
        }
        isRegistered := true
    }

    _getOrCreateSettingsGui()
    {
        If (this._settingsGui == "" || this._settingsGui.IsDestroyed)
        {
            ; TODO show a localized gui title
            this._settingsGui := new SettingsGui(this._settingsController, this._settingsModel, Application._applicationName)
        }
        Return this._settingsGui
    }

}