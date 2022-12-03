class AutoClickerModel extends ISetting
{
    __New(enable, key)
    {
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
                throw Exception(A_ThisFunc " wrong value passed")
            }
            Return this._cloneAndSetValue("_enable", value)
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
            If (!value.In("MButton", "XButton1", "XButton2"))
            {
                throw Exception(A_ThisFunc " wrong value passed")
            }
            Return this._cloneAndSetValue("_key", value)
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
        Return new AutoClickerModel(true, "MButton")
    }

    FromIniString(str)
    {
        ini := _iniSection.Parse(str)
        If (ini.Title != "AutoClicker")
        {
            throw Exception("Ini string is not an AutoClicker")
        }

        If (!ini.Pairs.Enable.In(true, false) || !SettingsModel.ValidAutoClickerKeys.Contains(ini.Pairs.Key))
        {
            throw Exception("Ini string is not an AutoClicker")
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

    _cloneAndSetValue(property, value)
    {
        result := ObjClone(this)
        result._enable := value
        Return result
    }
}