; A wrapper around the HookHotkey class. Allows to easily change any properties of the hotkey.
; As hotkeys are have to be recreated as soon as any property changes, this hides away this complexity
class ChangeableHotkey
{
    __New(key, fn, winGroup, enable)
    {
        this._key := key
        this._fn := fn
        this._group := winGroup
        this._enable := enable

        this._hotkey := new HookHotkey(this._key, this._fn, this._group)
        this._hotkey.IsActive := this._enable
    }

    SetKey(key)
    {
        If (this._key == key)
        {
            Return
        }
        this._key := key
        this._changeHotkey()
    }

    SetEnable(enable)
    {
        If (enable !== true && enable !== false)
        {
            throw Exception("Wrong enable value given")
        }

        If (enable == this._enable)
        {
            Return
        }
        this._enable := enable
        this._changeHotkey()
    }

    SetWinGroup(group)
    {
        If (!SettingsModel.ValidWindowGroups.Contains(group))
        {
            throw Exception("Wrong window group given")
        }

        If (this._group == group)
        {
            Return
        }
        this._group := group
        this._changeHotkey()
    }

    SetCallback(fn)
    {
        If (!TypeOf(fn, "Func"))
        {
            throw Exception("Given fn is nor a valid function")
        }

        If (this._fn == fn)
        {
            Return
        }
        this._fn := fn
        this._changeHotkey()
    }

    _changeHotkey()
    {
        If (this._key !== this._hotkey.Key || this._group !== this._hotkey.WinTitle || this._fn !== this._hotkey.Func)
        {
            this._hotkey := new HookHotkey(this._key, this._fn, this._group)
        }

        this._hotkey.IsActive := this._enable
    }
}