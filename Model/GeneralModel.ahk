class GeneralModel extends ASettingsModel
{
    __New(toggleKey, checkForUpdateFrequency, lastCheckedForUpdate, latestVersion)
    {
        base.__New()
        this._toggleKey := toggleKey
        this._checkForUpdatesFrequency := checkForUpdateFrequency
        this._lastCheckedForUpdate := lastCheckedForUpdate
        this._latestVersion := latestVersion
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
            this._setValue("_toggleKey", value)
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
            this._setValue("_checkForUpdatesFrequency", value)
        }
    }

    ; The date and time as YYYYMMDDHHMISS string in UTC. Contains the begin of the unix epoch if no checks were performed until now
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
            this._setValue("_lastCheckedForUpdate", value)
        }
    }

    ; The result of the check that was performed on LastCheckedForUpdate. If no checks were performed, blank gets returned
    LatestVersion[]
    {
        Get
        {
            Return this._latestVersion
        }

        Set
        {
            If (IsObject(value))
            {
                throw Exception(A_ThisFunc " wrong value passed")
            }
            this._setValue("_latestVersion", value)
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
        ; Set the time to the begin of the unix epoch and the latest version to blank
        ; to indicate that no checks were performed
        Return new GeneralModel("CapsLock", "startup", "1970", "")
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
            result.LastCheckedForUpdate := ini.Pairs.LastCheckedForUpdate
            result.LatestVersion := ini.Pairs.LatestVersion
        }
        catch, e
        {
            throw Exception("Ini string is not a General")
        }

        Return result
    }

    ToIniSection()
    {
        Return new _iniSection("General", {"ToggleKey": this._toggleKey
                                         , "CheckForUpdatesFrequency": this._checkForUpdatesFrequency
                                         , "LastCheckedForUpdate": this._lastCheckedForUpdate
                                         , "LatestVersion": this._latestVersion})
    }

    ToIniString()
    {
        Return this.ToIniSection().ToString()
    }
}
