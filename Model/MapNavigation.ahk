class MapNavigationModel extends ASettingsModel
{
    __New(enable, whereToEnable)
    {
        base.__New()
        this._enable := !!enable
        this._whereToEnable := whereToEnable
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
            this._setValue("_enable", value)
        }
    }

    WhereToEnable[]
    {
        Get
        {
            Return this._whereToEnable
        }

        Set
        {
            If (!SettingsModel.ValidWindowGroups.Contains(value))
            {
                throw Exception(A_ThisFunc " wrong value passed")
            }
            this._setValue("_whereToEnable", value)
        }
    }

    Equals(other)
    {
        Return this == other
            || ClassName(other) == "MapNavigationModel"
            && this._enable == other._enable
            && this._whereToEnable.ToLower() == other._whereToEnable.ToLower()
    }

    Default()
    {
        Return new MapNavigationModel(true, "Stronghold")
    }

    FromIniString(str)
    {
        ini := _iniSection.Parse(str)
        If (ini.Title != "MapNavigation")
        {
            throw Exception("Ini string is not a MapNavigation")
        }

        If (!ini.Pairs.Enable.In(true, false) || !SettingsModel.ValidWindowGroups.Contains(ini.Pairs.WhereToEnable))
        {
            throw Exception("Ini string is not a MapNavigation")
        }

        Return new MapNavigationModel(ini.Pairs.Enable, ini.Pairs.WhereToEnable)
    }

    ToIniSection()
    {
        Return new _iniSection("MapNavigation", {"Enable": this._enable, "WhereToEnable": this._whereToEnable})
    }

    ToIniString()
    {
        Return this.ToIniSection().ToString()
    }
}