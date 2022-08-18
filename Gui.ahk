class ConfigGui
{
    ; Store a static instance to the last gui that was created. Used with the GuiClose event
    static _instance := ""

    ; Create a new instance of the config gui
    ; settings: An instance of the SettingsController
    ; iniPath: A path/file name of the config file
    __New(settings, iniPath)
    {
        ConfigGui._instance := this

        this._settings := settings

        this._iniPath := iniPath

        this._controls := []

        this._title := "Stronghold - Config v" Stronghold_Version()
        Gui, New, % "+hwndhwnd +labelConfigGui_On", % this._title
        this._hwnd := hwnd

        this._buildGui()
    }

    ; Destroy and close the window
    Destroy()
    {
        try Gui, % this._hwnd ":Destroy"
        ConfigGui._instance := ""
    }

    ; Show the window
    Show()
    {
        Gui, % this._hwnd ":Show"
    }

    ; Hide the window
    Hide()
    {
        Gui, % this._hwnd ":Hide"
    }

    ; Static property. Determines if any instance is running
    IsRunning[]
    {
        Get
        {
            Return ConfigGui._instance != ""
        }
    }

    ; The GuiClose event
    OnClose()
    {
        this.Destroy()
    }

    ; Create the gui
    _buildGui()
    {
        width := 300
        height := 300

        Gui, % this._hwnd ":Add", Tab3, hwndhwnd w%width% h%height%, Autoclicker|Map navigation
        this._controls.Tab := this._hwnd

            ; AutoClicker

            Gui, % this._hwnd ":Tab", 1

            text := "This option enables to press and hold down the selected mouse button to send numerous left mouse clicks to the game.`n"
                  . "This option takes effect in Stronghold and Crusader"
            w := width - 20
            Gui, % this._hwnd ":Add", Text, hwndhwnd w%w%, % text
            Gui, % this._hwnd ":Add", Text, hwndhwnd

            clickerEnable := this._settings.AutoClicker.Enable
            clickerDisable := !clickerEnable
            Gui, % this._hwnd ":Add", CheckBox, hwndhwnd Checked%clickerEnable%, Enable Autoclicker
            this._controls.AC_CheckBox := hwnd
            this._guiControl(hwnd, "+g", ObjBindMethod(this, "_eventAC_Checkbox"))

            Gui, % this._hwnd ":Add", Text, hwndhwnd Disabled%clickerDisable%, Perform left clicks while the following button is pressed
            this._controls.AC_Text1 := hwnd

            Gui, % this._hwnd ":Add", DropDownList, hwndhwnd Disabled%clickerDisable% +AltSubmit Choose1 w125, Middle mouse button|Side mouse button 1|Side mouse button 2
            this._controls.AC_DDL := hwnd

            ; Map navigation

            Gui, % this._hwnd ":Tab", 2

            text := "This option enables to navigate the map with the 'w' 'a' 's' 'd' keys.`n"
                  . "This option is also included in the UCP. It is recommended to use the UCP option over this.`n"
                  . "This option intercepts the key presses and simulates the arrow keys, therefore it also disables "
                  . "the keys when typing any text (e.g. when saving the game). Use the toggle key to fast enable/disable "
                  . "this option."
            w := width - 20
            Gui, % this._hwnd ":Add", Text, hwndhwnd Section w%w%, % text
            Gui, % this._hwnd ":Add", Text, hwndhwnd

            mapEnable := this._settings.MapNavigation.Enable
            mapDisable := !mapEnable
            Gui, % this._hwnd ":Add", CheckBox, hwndhwnd Checked%mapEnable%, Enable Map navigation
            this._controls.MN_CheckBox := hwnd
            this._guiControl(hwnd, "+g", ObjBindMethod(this, "_eventMN_Checkbox"))

            Gui, % this._hwnd ":Add", Text, hwndhwnd Section Disabled%mapDisable%, Enable map navigation when
            this._controls.MN_Text1 := hwnd

            Gui, % this._hwnd ":Add", DropDownList, hwndhwnd +AltSubmit Disabled%mapDisable% Choose1 x+5 yp-3 w135, Stronghold|Crusader|Stronghold or Crusader
            this._controls.MN_DDL1 := hwnd

            Gui, % this._hwnd ":Add", Text, hwndhwnd Disabled%mapDisable% xs y+-1, is the active game
            this._controls.MN_Text2 := hwnd

            Gui, % this._hwnd ":Add", Text, hwndhwnd Disabled%mapDisable%, Toggle key
            this._controls.MN_Text3 := hwnd

            keyString := this._listToString(this._settings.MapNavToggleKeys)
            Gui, % this._hwnd ":Add", DropDownList, hwndhwnd +AltSubmit Disabled%mapDisable% Choose1 x+5 yp-3 w80, %keyString%
            this._controls.MN_DDL2 := hwnd

        ; Outside of the Tab

        Gui, % this._hwnd ":Tab"

        xPos := width - 80 * 2 - 10
        Gui, % this._hwnd ":Add", Button, hwndhwnd xm+%xPos% w80, Cancel
        this._controls.BtnCancel := hwnd
        this._guiControl(hwnd, "+g", ObjBindMethod(this, "_eventBtnCancel"))

        Gui, % this._hwnd ":Add", Button, hwndhwnd x+10 w80 Default, Apply
        this._controls.ApplyOk := hwnd
        this._guiControl(hwnd, "+g", ObjBindMethod(this, "_eventBtnApply"))
    }

    ; A wrapper of the GuiControl command
    _guiControl(hwnd, command := "", options := "")
    {
        GuiControl, % command, % hwnd, % options
    }

    ; A wrapper of the GuiControlGet command
    _guiControlGet(hwnd, command := "", options := "")
    {
        GuiControlGet, value, % command, % hwnd, % options
        Return value
    }

    ; En/Disable every control in the hwnds list
    _batchEnDisable(hwnds, enable)
    {
        command := enable ? "Enable": "Disable"
        For each, hwnd in hwnds
        {
            this._guiControl(hwnd, command)
        }
    }

    ; As AutoHotkey guis work with pipe delimitered lists instead of arrays, this converts an array into a string
    _listToString(list)
    {
        result := ""
        For each, item in list
        {
            result .= item "|"
        }
        Return result
    }

    ; The gLabel of the autoclicker check box
    _eventAC_Checkbox(hwnd, guiEvent, eventInfo)
    {
        isChecked := this._guiControlGet(hwnd)

        txt1 := this._controls.AC_Text1
        ddl := this._controls.AC_DDL

        this._batchEnDisable([txt1, ddl], isChecked)
    }

    ; The gLabel of the Map navigate check box
    _eventMN_Checkbox(hwnd, guiEvent, eventInfo)
    {
        isChecked := this._guiControlGet(hwnd)

        txt1 := this._controls.MN_Text1
        ddl1 := this._controls.MN_DDL1
        txt2 := this._controls.MN_Text2
        ddl2 := this._controls.MN_DDL2
        txt3 := this._controls.MN_Text3

        this._batchEnDisable([txt1, ddl1, txt2, ddl2, txt3], isChecked)
    }

    ; The gLabel of the cancel button
    _eventBtnCancel(hwnd, guiEvent, eventInfo)
    {
        this.Destroy()
    }

    ; The gLabel of the apply button
    _eventBtnApply(hwnd, guiEvent, eventInfo)
    {
        this.Hide()

        mouseBtn := this._guiControlGet(this._controls.AC_DDL)
        enable := this._guiControlGet(this._controls.AC_CheckBox)
        keys := this._settings.AutoClickerKeys
        this._settings.AutoClicker := {"Enable": enable
                                     , "Key": keys[mouseBtn]}

        whereEnable := this._guiControlGet(this._controls.MN_DDL1)
        enable := this._guiControlGet(this._controls.MN_CheckBox)
        toggleKey := this._guiControlGet(this._controls.MN_DDL2)
        gameGroupNames := this._settings.GameGroupNames
        mapNavToggleKeys := this._settings.MapNavToggleKeys
        this._settings.MapNavigation := {"Enable": enable
                                       , "WhereToEnable": gameGroupNames[whereEnable]
                                       , "ToggleKey": mapNavToggleKeys[toggleKey]}

        this._settings.Save(this._iniPath)

        this.Destroy()
    }
}

; The GuiClose event
ConfigGui_OnClose(hwnd)
{
    If (ConfigGui.IsRunning)
    {
        Return ConfigGui._instance.OnClose()
    }
}