class ConfigGui
{
    ; Store a static instance to the last gui that was created. Used with the GuiClose event
    static _instances := []

    ; Create a new instance of the config gui
    ; settings: An instance of the SettingsController
    ; iniPath: A path/file name of the config file
    __New(settings, iniPath)
    {
        this._settings := settings
        this._iniPath := iniPath
        this._controls := []

        this._title := StrReplace(GetLanguage().Title, "%1", Stronghold_Version())
        Gui, New, % "+hwndhwnd +labelConfigGui_On", % this._title
        this._hwnd := hwnd + 0
        ConfigGui._instances[hwnd] := this

        this._buildGui()
    }

    ; Destroy and close the window
    Destroy()
    {
        try Gui, % this._hwnd ":Destroy"
        ConfigGui._instances.Delete(this._hwnd)
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
            Return ConfigGui._instances.Length() > 0
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
        lang := GetLanguage()

        width := 300
        height := 300
        w := width - 20

        Gui, % this._hwnd ":Add", Tab3, hwndhwnd w%width% h%height%, % lang.TabTitle
        this._controls.Tab := this._hwnd

            ; AutoClicker

            Gui, % this._hwnd ":Tab", 1

            Gui, % this._hwnd ":Add", Text, hwndhwnd w%w%, % lang.AC_Desc
            Gui, % this._hwnd ":Add", Text, hwndhwnd

            clickerEnable := this._settings.AutoClicker.Enable
            clickerDisable := !clickerEnable
            Gui, % this._hwnd ":Add", CheckBox, hwndhwnd Checked%clickerEnable%, % lang.AC_Enable
            this._controls.AC_CheckBox := hwnd
            GuiControl(hwnd, "+g", ObjBindMethod(this, "_eventAC_Checkbox"))

            Gui, % this._hwnd ":Add", Text, hwndhwnd w%w% Disabled%clickerDisable%, % lang.AC_Text1
            this._controls.AC_Text1 := hwnd

            index := IndexOf(this._settings.Autoclicker.Key, this._settings.AutoClickerKeys)
            Gui, % this._hwnd ":Add", DropDownList, hwndhwnd Disabled%clickerDisable% +AltSubmit Choose%index% w125, % ListToString([lang.AC_MButton, lang.AC_XButton1, lang.AC_XButton2])
            this._controls.AC_DDL := hwnd

            ; Map navigation

            Gui, % this._hwnd ":Tab", 2

            Gui, % this._hwnd ":Add", Link, hwndhwnd Section w%w%, % StrReplace(lang.MN_Desc, "%1", UCPWebsite())
            Gui, % this._hwnd ":Add", Text, hwndhwnd

            mapEnable := this._settings.MapNavigation.Enable
            mapDisable := !mapEnable
            Gui, % this._hwnd ":Add", CheckBox, hwndhwnd Checked%mapEnable%, % lang.MN_Enable
            this._controls.MN_CheckBox := hwnd
            GuiControl(hwnd, "+g", ObjBindMethod(this, "_eventMN_Checkbox"))

            Gui, % this._hwnd ":Add", Text, hwndhwnd Section Disabled%mapDisable%, % lang.MN_Text1
            this._controls.MN_Text1 := hwnd

            index := IndexOf(this._settings.MapNavigation.WhereToEnable, this._settings.GameGroupNames)
            Gui, % this._hwnd ":Add", DropDownList, hwndhwnd +AltSubmit Disabled%mapDisable% Choose%index% x+5 yp-3 w145, % ListToString([lang.MN_Stronghold, lang.MN_Crusader, lang.MN_StrongholdAndCrusader])
            this._controls.MN_DDL1 := hwnd

            Gui, % this._hwnd ":Add", Text, hwndhwnd Disabled%mapDisable% xs y+-1, % lang.MN_Text2
            this._controls.MN_Text2 := hwnd

            Gui, % this._hwnd ":Add", Text, hwndhwnd Disabled%mapDisable%, % lang.MN_ToggleKey
            this._controls.MN_Text3 := hwnd

            index := IndexOf(this._settings.MapNavigation.ToggleKey, this._settings.MapNavToggleKeys)
            Gui, % this._hwnd ":Add", DropDownList, hwndhwnd +AltSubmit Disabled%mapDisable% Choose%index% x+5 yp-3 w80, % ListToString(this._settings.MapNavToggleKeys)
            this._controls.MN_DDL2 := hwnd

        ; Outside of the Tab

        Gui, % this._hwnd ":Tab"

        xPos := width - 80 * 2 - 10
        Gui, % this._hwnd ":Add", Button, hwndhwnd xm+%xPos% w80, % lang.Cancel
        this._controls.BtnCancel := hwnd
        GuiControl(hwnd, "+g", ObjBindMethod(this, "_eventBtnCancel"))

        Gui, % this._hwnd ":Add", Button, hwndhwnd x+10 w80 Default, % lang.Apply
        this._controls.ApplyOk := hwnd
        GuiControl(hwnd, "+g", ObjBindMethod(this, "_eventBtnApply"))
    }

    ; En/Disable every control in the hwnds list
    _batchEnDisable(hwnds, enable)
    {
        command := enable ? "Enable" : "Disable"
        For each, hwnd in hwnds
        {
            GuiControl(hwnd, command)
        }
    }

    ; The gLabel of the autoclicker check box
    _eventAC_Checkbox(hwnd, guiEvent, eventInfo)
    {
        isChecked := GuiControlGet(hwnd)

        txt1 := this._controls.AC_Text1
        ddl := this._controls.AC_DDL

        this._batchEnDisable([txt1, ddl], isChecked)
    }

    ; The gLabel of the Map navigate check box
    _eventMN_Checkbox(hwnd, guiEvent, eventInfo)
    {
        isChecked := GuiControlGet(hwnd)

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

        mouseBtn := GuiControlGet(this._controls.AC_DDL)
        enable := GuiControlGet(this._controls.AC_CheckBox)
        keys := this._settings.AutoClickerKeys
        this._settings.AutoClicker := {"Enable": enable
                                     , "Key": keys[mouseBtn]}

        whereEnable := GuiControlGet(this._controls.MN_DDL1)
        enable := GuiControlGet(this._controls.MN_CheckBox)
        toggleKey := GuiControlGet(this._controls.MN_DDL2)
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
    local gui
    If (gui := ConfigGui._instances[hwnd + 0])
    {
        Return gui.OnClose()
    }
}