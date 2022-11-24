class GuiBase_HotkeyControl extends GuiBase_BaseControl
{
    static _type := "Hotkey"

    __New(gui, options := "", text := "")
    {
        ; In case the keyCombo is an object like the KeyCombo property
        If (IsObject(text))
        {
            text := (text.shift ? "+" : "") (text.ctrl ? "^" : "") (text.alt ? "!" : "") text.key
        }

        base.__New(gui, options, text)
    }

    ; An object with the keys "key", "shift", "ctrl", "alt"
    KeyCombo[]
    {
        Get
        {
            static HKM_GETHOTKEY := 0x402
                 , HOTKEYF_ALT := 4
                 , HOTKEYF_CONTROL := 2
                 , HOTKEYF_SHIFT := 1

            SendMessage, HKM_GETHOTKEY, 0, 0,, % "ahk_id" this._hwnd
            If (ErrorLevel == "FAIL")
            {
                Return ""
            }

            keyCode := WinApi_LOWORD(WinApi_LOBYTE(ErrorLevel))
            modifiers := WinApi_LOWORD(WinApi_HIBYTE(ErrorLevel))
            key := GetKeyName("vk" keyCode.Format("{:x}"))
            Return {"key": key, "shift": !!(modifiers & HOTKEYF_SHIFT), "ctrl": !!(modifiers & HOTKEYF_CONTROL), "alt": !!(modifiers & HOTKEYF_ALT)}
        }

        Set
        {
            this.KeyComboString := (value.shift ? "+" : "") (value.ctrl ? "^" : "") (value.alt ? "!" : "") value.key
        }
    }

    ; The combo as AutoHotkey hotkey string
    KeyComboString[]
    {
        Get
        {
            GuiControlGet, combo,, % this._hwnd
            Return combo
        }

        Set
        {
            GuiControl,, % this._hwnd, % value
        }
    }

    ; The control receives a new hotkey
    OnHotkeyChange(fn, add := true)
    {
        this._registerEvent(fn, "Normal", add)
        Return this
    }

    ; A custom event handler
    _event(hwnd, event, info, errLevel := "")
    {
        eventArgs := new GuiBase_HotkeyEventArgs(this, event, info, errLevel)
        this._fireCustomEvent(eventArgs, event)
    }
}