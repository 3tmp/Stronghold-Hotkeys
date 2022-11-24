class GuiBase_TabControl extends GuiBase_BaseControl
{
    static _type := "Tab3"

    ; Returns the number of this Tab control (= the instance number)
    TabNumber[]
    {
        Get
        {
            Return this._getNN()
        }
    }

    ; Returns the number of items
    Count[]
    {
        Get
        {
            Return this._getItemCount()
        }
    }

    ; Selectes the tab at the given, one-based index
    ; Returns the index of the previously selected item on success, 0 on failure
    Select(index)
    {
        ; 0x130C is TCM_SETCURSEL
        SendMessage, 0x130C, index - 1, 0,, % "ahk_id" this._hwnd
        Return ErrorLevel == "FAIL" || ErrorLevel == -1 ? 0 : ErrorLevel + 1
    }

    ; Returns the one based index of the selected item, -1 if no item is selected
    GetSelectedIndex()
    {
        ; 0x130B is TCM_GETCURSEL
        SendMessage, 0x130B, 0, 0,, % "ahk_id" this._hwnd
        ; -1 if no tab selected
        Return ErrorLevel == "FAIL" ? "" : ErrorLevel == -1 ? -1 : ErrorLevel + 1
    }

    ; Returns the text of the selected tab
    GetSelectedText()
    {
        Return this.GetText(this.GetSelectedIndex())
    }

    ; Returns the text at the given index (one based)
    GetText(index)
    {
        static maxLen := 256
             ; 0x133C is TCM_GETITEMW, 0x1305 is TCM_GETITEMA
             , TCM_GETITEM := A_IsUnicode ? 0x133C : 0x1305
             , OffTxP := (3 * 4) + (A_PtrSize - 4)
             , OffTxL := (3 * 4) + (A_PtrSize - 4) + A_PtrSize

        VarSetCapacity(ItemText, maxLen * (A_IsUnicode ? 2 : 1), 0)
        TCITEM := ""
        this._createTCITEM(TCITEM)
        ; 0x1 is TCIF_TEXT
        NumPut(0x1, TCITEM, 0, "UInt")
        NumPut(&ItemText, TCITEM, OffTxP, "Ptr")
        NumPut(maxLen, TCITEM, OffTxL, "Int")

        SendMessage, TCM_GETITEM, index - 1, &TCITEM,, % "ahk_id" this._hwnd
        If (ErrorLevel == "FAIL" || !ErrorLevel)
        {
            Return ""
        }
        txtPtr := NumGet(TCITEM, OffTxP, "UPtr")
        Return txtPtr == 0 ? "" : StrGet(txtPtr, maxLen)
    }

    ; Future controls will be added to this Tab control
    SetDefault()
    {
        this._gui.SetDefaultTab(this)
    }

    ; Specify on with page of the Tab control the next controls will be added
    SetTab(number := "")
    {
        this._gui.SetTab(number, this.TabNumber)
    }

    ; Fires when the user switches the tab
    OnTabSwitch(fn, add := true)
    {
        Return this.OnEvent(fn, add)
    }

    ; Overwrite the default event handler
    _event(hwnd, event, info, errLevel := "")
    {
        this._fireDefaultEvent(new GuiBase_TabEventArgs(this, event, info, errLevel, this.GetSelectedIndex()))
    }

    ; Returns the amount of tabs
    _getItemCount()
    {
        ; 0x1304 is TCM_GETITEMCOUNT
        SendMessage, 0x1304, 0, 0,, % "ahk_id" this._hwnd
        ; 0 if an error occured
        Return ErrorLevel == "FAIL" || ErrorLevel == 0 ? "" : ErrorLevel
    }

    ; Makes sure that the passed variable has the correct size to hold a TCITEM struct
    _createTCITEM(ByRef TCITEM)
    {
        static Size := (5 * 4) + (2 * A_PtrSize) + (A_PtrSize - 4)
        VarSetCapacity(TCITEM, size, 0)
    }
}