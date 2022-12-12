; A wrapper around the Hotkey command. Always uses the Hook option to prevent self triggering.
; Only supports single character hotkeys
class Hotkey
{
    ; key: The full name of the key combo
    ; fn: The function that should get executed
    ; winGroup: The "#IfWinActive ahk_group" context
    __New(key, fn, winGroup)
    {
        If (key == "" || !TypeOf(fn, "Func"))
        {
            throw new Exception(A_ThisFunc " Invalid parameter.")
        }
        ; Always use the "Hook" option to prevent the script from self triggering of Hotkeys
        this._key := "$" key
        this._fn := fn
        this._winGroup := winGroup
    }

    __Delete()
    {
        If (this._isActive)
        {
            this.Disable()
        }
    }

    ; The hotkeys (as string) without the Hook ("$") option
    Key[]
    {
        Get
        {
            Return this._key.SubStr(2)
        }
    }

    IsActive[]
    {
        Get
        {
            Return this._isActive
        }
    }

    ; Turn the Hotkey on.
    Enable()
    {
        this._apply(this._key, "On", this._fn, this._winGroup)
        this._isActive := true
    }

    ; Turn the Hotkey off.
    Disable()
    {
        this._apply(this._key, "Off", this._fn, this._winGroup)
        this._isActive := false
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
                throw Exception("The key '" key "' cannot be used as hotkey")
            ; The command attempted to modify a nonexistent hotkey.
            Case 5:
                throw Exception("No hotkey with the combo '" key "' exists.")
            ; The command attempted to modify a nonexistent variant of an existing hotkey.
            Case 6:
                throw Exception("Cannot modify a non existent hotkey variant of '" key "'")
            ; Any other failures:
            Default:
                throw Exception("The following error occured when trying to set a hotkey: " error)
        }
    }
}