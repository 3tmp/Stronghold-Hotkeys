; A wrapper around the Hotkey command. Always uses the Hook option to prevent self triggering.
; Only supports single character hotkeys
class HookHotkey extends _Object
{
    ; key: The full name of the key combo
    ; fn: The function that should get executed
    ; winGroup: The "#IfWinActive ahk_group" context
    __New(key, fn, winGroup)
    {
        If (key == "" || !TypeOf(fn, "Func"))
        {
            throw new UnsupportedTypeException(A_ThisFunc " Invalid parameter.")
        }
        ; Always use the "Hook" option to prevent the script from self triggering of Hotkeys
        this._key := "$" key
        this._fn := fn
        this._winGroup := winGroup
        this._isActive := false
    }

    __Delete()
    {
        this.Disable()
    }

    ; The hotkeys (as string) without the Hook ("$") option
    Key[]
    {
        Get
        {
            Return this._key.SubStr(2)
        }
    }

    ; Returns the window title
    WinTitle[]
    {
        Get
        {
            Return this._winGroup
        }
    }

    ; The callback function that gets executed when the hotkey gets pressed
    Func[]
    {
        Get
        {
            Return this._fn
        }
    }

    ; Get/Set the active state of the hotkey
    IsActive[]
    {
        Get
        {
            Return this._isActive
        }

        Set
        {
            If (value)
            {
                this.Enable()
            }
            Else
            {
                this.Disable()
            }
        }
    }

    ; Turn the Hotkey on.
    Enable()
    {
        If (!this._isActive)
        {
            this._apply(this._key, "On", this._fn, this._winGroup)
            this._isActive := true
        }
    }

    ; Turn the Hotkey off.
    Disable()
    {
        If (this._isActive)
        {
            this._apply(this._key, "Off", this._fn, this._winGroup)
            this._isActive := false
        }
    }

    ; Static internal methods

    _apply(key, options, fn, winGroup)
    {
        ; Not sure if the Hotkey command throws if "UseErrorLevel" option is used. Just make sure to cover this case
        try
        {
            Hotkey, IfWinActive, % "ahk_group " winGroup
            HotKey, % key, % fn, % options " UseErrorLevel"
            error := ErrorLevel
        }
        catch, e
        {
            error := ErrorLevel
        }
        finally
        {
            Hotkey, If
        }

        Switch error
        {
            ; Everything worked fine
            Case 0:
                Return
            ; Unsupported key name
            Case 2:
                throw new HotkeyException("The key '" key "' cannot be used as hotkey", error)
            ; The command attempted to modify a nonexistent hotkey.
            Case 5:
                throw new HotkeyException("No hotkey with the combo '" key "' exists.", error)
            ; The command attempted to modify a nonexistent variant of an existing hotkey.
            Case 6:
                throw new HotkeyException("Cannot modify a non existent hotkey variant of '" key "'", error)
            ; Any other failures:
            Default:
                throw new HotkeyException("The following error occured when trying to set a hotkey: " error, error)
        }
    }
}