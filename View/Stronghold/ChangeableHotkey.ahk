; A wrapper around the HookHotkey class. Allows to easily change any properties of the hotkey.
; As hotkeys are have to be recreated as soon as any property changes, this hides away this complexity
class ChangeableHotkey extends _Object
{
    ; key: The keyboard key to trigger the hotkey. May be blank which means that no hotkey is started up
    ; fn: The callback function that gets called when the hotkey combo gets pressed
    ; winGroup: The name of the window group, that was previously created via the GroupAdd command
    ; enable: Immediately enable or disable the hotkey. If the key is blank, this value has no effect
    __New(key, fn, winGroup, enable)
    {
        If (IsObject(key)
         || !TypeOf(fn, "Func")
         || !EWindowGroups.ValidValue(winGroup)
         || enable !== true && enable !== false)
        {
            throw new IllegalArgumentException("Invalid parameter passed to the ctor")
        }
        ; A blank key is the only value that may be empty
        this._key := key
        this._fn := fn
        this._group := winGroup
        this._enable := enable
        this._hotkey := ""

        this._changeHotkey()
    }

    ; key: The new keyboard key to set the hotkey to. If blank, the hotkey gets deactivated
    SetKey(key)
    {
        If (IsObject(key))
        {
            throw new IllegalArgumentException("Key must not be an object")
        }

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
            throw new IllegalArgumentException("Wrong enable value given")
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
        If (!EWindowGroups.ValidValue(group))
        {
            throw new IllegalArgumentException("Wrong window group given")
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
            throw new IllegalArgumentException("Given fn is nor a valid function")
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
        ; Handles the rare case when the key gets set to "" which means that the hotkey should get switched off
        If (this._key == "")
        {
            ; Dispose the hotkey in case it was previously created
            this._hotkey := ""
            Return
        }

        ; Here all values are valid, so any operation on the HookHotkey class should not fail

        ; In case the hotkey was not already set
        If (this._hotkey == "")
        {
            this._hotkey := new HookHotkey(this._key, this._fn, this._group)
        }
        ; In case any property of the hotkey changed
        Else If (this._key !== this._hotkey.Key || this._group !== this._hotkey.WinTitle || this._fn !== this._hotkey.Func)
        {
            this._hotkey := new HookHotkey(this._key, this._fn, this._group)
        }

        this._hotkey.IsActive := this._enable
    }
}