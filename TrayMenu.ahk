; Singelton tray menu class
class TrayMenu
{
    static _instance := ""

    _setupComplete := false
    ; Holds a reference to the application
    _app := ""

    Instance[]
    {
        Get
        {
            If (!TrayMenu._instance)
            {
                TrayMenu._instance := new TrayMenu()
            }
            Return TrayMenu._instance
        }
    }

    Init(app)
    {
        If (!InstanceOf(app, Application))
        {
            throw Exception("App has the wrong type")
        }

        If (!this._setupComplete)
        {
            this._buildMenu()
            this._app := app
        }
    }

    _buildMenu()
    {
        lang := GetLanguage()
        Menu, Tray, NoStandard
        Menu, Tray, DeleteAll
        If (IsDebuggerAttatched())
        {
            ; Just for debugging purposes
            fn := OBM(this, "_eventShowDebugWindow", "ListLines")
            Menu, Tray, Add, ListLines, % fn
            fn := OBM(this, "_eventShowDebugWindow", "ListHotkeys")
            Menu, Tray, Add, ListHotkeys, % fn
            Menu, Tray, Add
        }
        fn := OBM(this, "_eventVoid")
        Menu, Tray, Add, % Format(lang.Tray_Title, Stronghold_Version()), % fn
        Menu, Tray, Default, % Format(lang.Tray_Title, Stronghold_Version())
        Menu, Tray, Add
        fn := OBM(this, "_eventOpenSettingsGui")
        Menu, Tray, Add, % lang.Tray_Config, % fn
        fn := OBM(this, "_eventOpenWebsite")
        Menu, Tray, Add, % lang.Tray_Website, % fn
        fn := OBM(this, "_eventAbout")
        Menu, Tray, Add, % lang.Tray_About, % fn
        Menu, Tray, Add
        fn := OBM(this, "_eventExit")
        Menu, Tray, Add, % lang.Tray_Exit, % fn
        Menu, Tray, Tip, % Format(lang.Tray_Tip, Stronghold_Version())

        this._trySetIcon()

        this._setupComplete := true
    }

    _trySetIcon()
    {
        shSteam := StrongholdManager.InstallPaths.StrongholdSteam
        shcSteam := StrongholdManager.InstallPaths.CrusaderSteam
        sheSteam := StrongholdManager.InstallPaths.ExtremeSteam

        If (FileExist(shcSteam))
        {
            try Menu, Tray, Icon, % shcSteam
        }
        Else If (FileExist(shSteam))
        {
            try Menu, Tray, Icon, % shSteam
        }
        Else If (FileExist(sheSteam))
        {
            try, Menu, Tray, Icon, % sheSteam
        }
    }

    _eventShowDebugWindow(whichWindow)
    {
        If (whichWindow == "ListLines")
        {
            ListLines
        }
        Else If (whichWindow == "ListHotkeys")
        {
            ListHotkeys
        }
    }

    _eventAbout()
    {
        copyright := Chr(0x00A9)
        MsgBox(Format(GetLanguage().Tray_About_MsgBoxTitle, Stronghold_Version()), Format(GetLanguage().Tray_About_MsgBoxBody, copyright))
    }

    _eventOpenWebsite()
    {
        Run(StrongholdHotkeysWebsite())
    }

    _eventOpenSettingsGui()
    {
        this._app.SettingsGui.Show()
    }

    _eventVoid()
    {
    }

    _eventExit()
    {
        this._app.ExitApp()
    }
}