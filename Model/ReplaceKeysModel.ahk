class ReplaceKeysModel extends ASettingsModel
{
    __New(param)
    {
        base.__New()
        this._enable := param.Enable
        this._whereToEnable := param.WhereToEnable
        this._openGranary := param.OpenGranary
        this._openArmoury := param.OpenArmoury
        this._openEngineersGuild := param.OpenEngineersGuild
        this._openKeep := param.OpenKeep
        this._openBarracks := param.OpenBarracks
        this._openTunnlerGuild := param.OpenTunnlerGuild
        this._openMercenaries := param.OpenMercenaries
        this._openMarket := param.OpenMarket
        this._openAdministration := param.OpenAdministration
        this._sendRandomTauntMessage := param.SendRandomTauntMessage
        this._increaseGameSpeed := param.IncreaseGameSpeed
        this._decreaseGameSpeed := param.DecreaseGameSpeed
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

    OpenGranary[]
    {
        Get
        {
            Return this._openGranary
        }

        Set
        {
            ; TODO implement value checking
            this._setValue("_openGranary", value)
        }
    }

    OpenArmoury[]
    {
        Get
        {
            Return this._openArmoury
        }

        Set
        {
            this._setValue("_openArmoury", value)
        }
    }

    OpenEngineersGuild[]
    {
        Get
        {
            Return this._openEngineersGuild
        }

        Set
        {
            this._setValue("_openEngineersGuild", value)
        }
    }

    OpenKeep[]
    {
        Get
        {
            Return this._openKeep
        }

        Set
        {
            this._setValue("_openKeep", value)
        }
    }

    OpenTunnlerGuild[]
    {
        Get
        {
            Return this._openTunnlerGuild
        }

        Set
        {
            this._setValue("_openTunnlerGuild", value)
        }
    }

    OpenBarracks[]
    {
        Get
        {
            Return this._openBarracks
        }

        Set
        {
            this._setValue("_openBarracks", value)
        }
    }

    OpenMercenaries[]
    {
        Get
        {
            Return this._openMercenaries
        }

        Set
        {
            this._setValue("_openMercenaries", value)
        }
    }

    OpenMarket[]
    {
        Get
        {
            Return this._openMarket
        }

        Set
        {
            this._setValue("_openMarket", value)
        }
    }

    OpenAdministration[]
    {
        Get
        {
            Return this._openAdministration
        }

        Set
        {
            this._setValue("_openAdministration", value)
        }
    }

    SendRandomTauntMessage[]
    {
        Get
        {
            Return this._sendRandomTauntMessage
        }

        Set
        {
            this._setValue("_sendRandomTauntMessage", value)
        }
    }

    IncreaseGameSpeed[]
    {
        Get
        {
            Return this._increaseGameSpeed
        }

        Set
        {
            this._setValue("_increaseGameSpeed", value)
        }
    }

    DecreaseGameSpeed[]
    {
        Get
        {
            Return this._decreaseGameSpeed
        }

        Set
        {
            this._setValue("_decreaseGameSpeed", value)
        }
    }

    ; Returns true if the given key is already set in some property
    ContainsAny(key)
    {
        For each, value in this.GetAllReplaceKeyOptions()
        {
            If (key = value)
            {
                Return true
            }
        }
        Return false
    }

    GetAllReplaceKeyOptions()
    {
        result := this._toObject()
        result.Delete("Enable")
        result.Delete("WhereToEnable")
        Return result
    }

    Equals(other)
    {
        If (this == other)
        {
            Return true
        }

        If (ClassName(other) !== "ReplaceKeysModel")
        {
            Return false
        }

        For key, value in this
        {
            ; Check all private fields that are not a method
            If (key.StartsWith("_") && !IsObject(value) && value !== other[key])
            {
                Return false
            }
        }
        Return true
    }

    Default()
    {
        ; TODO ValidWindowGroups make something better
        ; It seems as if AutoHotkey cannot do SettingsModel.ValidWindowGroups[3],
        ; so get the list and later get the desired element
        validGroups := SettingsModel.ValidWindowGroups
        obj := {"Enable": true, "WhereToEnable": validGroups[3], "OpenGranary": "g"
              , "OpenArmoury": "y", "OpenEngineersGuild": "i", "OpenKeep": "h", "OpenTunnlerGuild": "t"
              , "OpenBarracks": "b", "OpenMercenaries": "n", "OpenMarket": "m", "OpenAdministration": ""
              , "SendRandomTauntMessage": "", "IncreaseGameSpeed": "+", "DecreaseGameSpeed": "-"}
        Return new ReplaceKeysModel(obj)
    }

    FromIniString(str)
    {
        ini := _iniSection.Parse(str)
        If (ini.Title != "ReplaceKeys")
        {
            throw Exception("Ini string is not a ReplaceKeys")
        }

        validGroups := SettingsModel.ValidWindowGroups

        If (!ini.Pairs.Enable.In(true, false) || !validGroups.Contains(ini.Pairs.WhereToEnable))
        {
            throw Exception("Ini string is not a ReplaceKeys")
        }

        ; Clone the key value pair list and remove the non-(keyboard-)key pairs
        kvPair := ini.Pairs.Clone()
        kvPair.Delete("Enable")
        kvPair.Delete("WhereToEnable")

        ; Ensure that no (keyboard)-key is set double
        uniqueValues := {}
        For key, value in kvPair
        {
            If (uniqueValues.HasKey(value))
            {
                throw Exception("Ini string is not a ReplaceKeys")
            }
            uniqueValues[value] := 1
        }

        ; Ensure that only valid (keyboard)-key are set
        validKeysList := SettingsModel.ValidReplaceKeys
        For each, key in kvPair
        {
            If (!validKeysList.Contains(key))
            {
                throw Exception("Ini string is not a ReplaceKeys")
            }
        }

        Return new ReplaceKeysModel(ini.Pairs)
    }

    ToIniSection()
    {
        Return new _iniSection("ReplaceKeys", this._toObject())
    }

    ToIniString()
    {
        Return this.ToIniSection().ToString()
    }

    ; Returns an object with 
    _toObject()
    {
        result := {}
        For key, value in this
        {
            ; Check all private fields that are not a method
            If (!IsObject(value) && key.StartsWith("_"))
            {
                ; Replace the "_" at the beginning and make the first char upper case
                result[key.SubStr(2, 1).ToUpper() key.SubStr(3)] := value
            }
        }
        Return result
    }
}