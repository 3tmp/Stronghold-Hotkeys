class AutoClickerModel extends ASettingsModel
{
    ; Private ctor
    __New(enable, key)
    {
        base.__New()
        this._enable := !!enable
        this._key := key
    }

    Enable[]
    {
        Get
        {
            Return this._enable
        }

        Set
        {
            If (!value.In(true, false))
            {
                throw new IllegalArgumentException(A_ThisFunc " wrong value passed")
            }
            If (value == this._enable)
            {
                Return
            }
            this._setValue("_enable", value)
        }
    }

    Key[]
    {
        Get
        {
            Return this._key
        }

        Set
        {
            If (!EAutoClickerKeys.ValidValue(value))
            {
                throw new IllegalArgumentException(A_ThisFunc " wrong value passed")
            }
            this._setValue("_key", value)
        }
    }

    Equals(other)
    {
        Return this == other
            || ClassName(other) == "AutoClickerModel"
            && this._enable == other._enable
            && this._key.ToLower() == other._key.ToLower()
    }

    Default()
    {
        Return new AutoClickerModel(true, EAutoClickerKeys.MButton)
    }

    FromIniString(str)
    {
        ini := _iniSection.Parse(str)
        If (ini.Title != "AutoClicker")
        {
            throw new IllegalArgumentException("Ini string is not an AutoClicker")
        }

        If (!ini.Pairs.Enable.In(true, false) || !EAutoClickerKeys.ValidValue(ini.Pairs.Key))
        {
            throw new IllegalArgumentException("Ini string is not an AutoClicker")
        }

        Return new AutoClickerModel(ini.Pairs.Enable, ini.Pairs.Key)
    }

    ToIniSection()
    {
        Return new _iniSection("AutoClicker", {"Enable": this._enable, "Key": this._key})
    }

    ToIniString()
    {
        Return this.ToIniSection().ToString()
    }
}