class GeneralModel extends ISettingsModel
{
    __New(toggleKey, checkForUpdateFrequency, lastCheckedForUpdate)
    {
        this._toggleKey := toggleKey
        this._checkForUpdatesFrequency := checkForUpdateFrequency
        this._lastCheckedForUpdate := lastCheckedForUpdate
    }

    ToggleKey[]
    {
        Get
        {
            Return this._toggleKey
        }

        Set
        {
            If (!SettingsModel.ValidToggleKeys.Contains(value))
            {
                throw Exception(A_ThisFunc " wrong value passed")
            }
            Return this._cloneAndSetValue("_toggleKey", value)
        }
    }

    CheckForUpdatesFrequency[]
    {
        Get
        {
            Return this._checkForUpdatesFrequency
        }

        Set
        {
            If (!SettingsModel.ValidCheckForUpdatesFrequency.Contains(value))
            {
                throw Exception(A_ThisFunc " wrong value passed")
            }
            Return this._cloneAndSetValue("_checkForUpdatesFrequency", value)
        }
    }

    ; The date and time as YYYYMMDDHHMISS string
    LastCheckedForUpdate[]
    {
        Get
        {
            Return this._lastCheckedForUpdate
        }

        Set
        {
            If (!value.Is("Date"))
            {
                throw Exception(A_ThisFunc " wrong value passed")
            }
            Return this._cloneAndSetValue("_lastCheckedForUpdate", value)
        }
    }

    Equals(other)
    {
        Return this == other
            || ClassName(other) == "GeneralModel"
            && this._toggleKey.ToLower() == other._toggleKey.ToLower()
            && this._checkForUpdatesFrequency == other._checkForUpdatesFrequency
            && this._lastCheckedForUpdate == other._lastCheckedForUpdate
    }

    Default()
    {
        Return new GeneralModel("CapsLock", "startup", "19700101000000")
    }

    FromIniString(str)
    {
        ini := _iniSection.Parse(str)
        If (ini.Title != "General")
        {
            throw Exception("Ini string is not a General")
        }

        ; TODO better constructor
        result := GeneralModel.Default()
        try
        {
            result.ToggleKey := ini.Pairs.ToggleKey
            result.CheckForUpdatesFrequency := ini.Pairs.CheckForUpdatesFrequency
            result.LastCheckedForUpdates := ini.Pairs.LastCheckedForUpdates
        }
        catch, e
        {
            throw Exception("Ini string is not a General")
        }

        Return result
    }

    ToIniSection()
    {
        Return new _iniSection("General", {"ToggleKey": this._toggleKey, "CheckForUpdatesFrequency": this._checkForUpdatesFrequency, "LastCheckedForUpdate": this._lastCheckedForUpdate})
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
