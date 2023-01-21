class GuiBase_ComboBoxBaseControl extends GuiBase_BaseControl
{
    ; Returns the number of items in the control
    Count[]
    {
        Get
        {
            ; 0x146 is CB_GETCOUNT
            SendMessage, 0x146, 0, 0,, % "ahk_id" this._hwnd
            ; LB_ERR is -1 (this errors can occur)
            Return ErrorLevel == "FAIL" || ErrorLevel == -1 ? "" : ErrorLevel
        }
    }

    ; Adds a new item to the control and returns the one-based index of the new item on success, false otherwise
    Add(item)
    {
        ; 0x0143 is CB_ADDSTRING
        SendMessage, 0x0143,, &item,, % "ahk_id" this._hwnd
        ; CB_ERR is -1, CB_ERRSPACE is -2 (these errors can occur)
        Return ErrorLevel == "FAIL" || ErrorLevel < 0 ? false : ErrorLevel + 1
    }

    ; Inserts a new item at the given index and returns the one-based index of the new item on success, false otherwise
    Insert(item, index)
    {
        ; If -1 gets specified, the item gets added to the end
        ; 0x14A is CB_INSERTSTRING
        SendMessage, 0x14A, index == -1 ? -1 : index - 1, &item,, % "ahk_id" this._hwnd
        ; CB_ERR is -1, CB_ERRSPACE is -2 (these errors can occur)
        Return ErrorLevel == "FAIL" || ErrorLevel < 0 ? false : ErrorLevel + 1
    }

    ; Removes all items from the control
    Clear()
    {
        ; 0x14B is CB_RESETCONTENT
        SendMessage, 0x14B, 0, 0,, % "ahk_id" this._hwnd
        Return ErrorLevel == "FAIL" ? false : true
    }

    ; Removes the item at the one-based index and returns the amount of items in the control on success and "" on failure
    Remove(index)
    {
        ; 0x144 is CB_DELETESTRING
        SendMessage, 0x144, index - 1, 0,, % "ahk_id" this._hwnd
        ; CB_ERR is -1
        Return ErrorLevel == "FAIL" || ErrorLevel == -1 ? "" : ErrorLevel + 1
    }

    ; Selectes the item at the given, one-based index
    ; Returns the index of the item on success, 0 on failure
    Select(index)
    {
        ; 0x14E is CB_SETCURSEL
        SendMessage, 0x14E, index - 1, 0,, % "ahk_id" this._hwnd
        ; -1 is CB_ERR
        Return ErrorLevel == "FAIL" || ErrorLevel == -1 ? 0 : ErrorLevel + 1
    }

    ; Returns the one-based index of the selected item in the ListBox part of the control
    ; If no item is selected "" is returned
    GetSelectedIndex()
    {
        ; 0x147 is CB_GETCURSEL
        SendMessage, 0x147, 0, 0,, % "ahk_id" this._hwnd
        ; -1 is CB_ERR (returned if no item is selected)
        Return ErrorLevel == "FAIL" || ErrorLevel == -1 ? "" : ErrorLevel + 1
    }

    ; Returns text of the selected item in the ListBox part of the control
    ; If no item is selected "" is returned
    GetSelectedText()
    {
        index := this.GetSelectedIndex()
        Return index == "" ? "" : this.GetText(index)
    }

    ; Returns the text at the specified index (one based)
    GetText(index)
    {
        ; Unicode and null terminating char
        length := this._getTextLen(index) * 2 + 2
        VarSetCapacity(text, length)

        ; 0x148 is CB_GETTEXT
        SendMessage, 0x148, index - 1, &text,, % "ahk_id" this._hwnd
        ; CB_ERR is -1 (this errors can occur)
        Return ErrorLevel == "FAIL" || ErrorLevel == -1 ? "" : text
    }

    ; Returns true if the ListBox of the ComboBox is visible
    GetDroppedState()
    {
        ; 0x157 is CB_GETDROPPEDSTATE
        SendMessage, 0x157, 0, 0,, % "ahk_id" this._hwnd
        Return ErrorLevel == "FAIL" ? "" : ErrorLevel
    }

    ; Gets fired when the selected item changes
    OnSelectionChange(fn, add := true)
    {
        Return base.OnEvent(fn, add)
    }

    ; Overwrite the default event handler
    _event(hwnd, event, info, errLevel := "")
    {
        this._fireDefaultEvent(new GuiBase_ComboBoxBaseEventArgs(this, event, info, errLevel, this.GetSelectedIndex()))
    }

    ; Returns the length of the text at the given index (index is one based)
    _getTextLen(index)
    {
        ; 0x149 is CB_GETTEXTLEN
        SendMessage, 0x149, index - 1,,, % "ahk_id" this._hwnd
        ; CB_ERR is -1 (this errors can occur)
        Return ErrorLevel == "FAIL" || ErrorLevel == -1 ? "" : ErrorLevel
    }

    _getComboBoxInfo(ByRef CBBI)
    {
        size := 40 + (3 * A_PtrSize)
        VarSetCapacity(CBBI, size, 0)
        NumPut(size, CBBI, 0, "UInt")
        Return DllCall("User32.dll\GetComboBoxInfo", "Ptr", this._hwnd, "Ptr", &CBBI)
    }

    ; Returns a handle to the edit control
    _getEditHwnd()
    {
        this._getComboBoxInfo(CBBInfo)
        Return NumGet(CBBInfo, 40 + A_PtrSize, "Ptr")
    }

    ; Returns a handle to the list box control
    _getLBHwnd()
    {
        this._getComboBoxInfo(CBBInfo)
        Return NumGet(CBBInfo, 40 + (2 * A_PtrSize), "Ptr")
    }
}