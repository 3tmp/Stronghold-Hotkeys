class ReplaceKeysModel extends ISetting
{
    __New(param)
    {
        this._whereToEnable := param.WhereToEnable
        this._openGranary := param.OpenGranary
        this._openArmory := param.OpenArmory
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

    WhereToEnable[]
    {
        Get
        {
            Return this._whereToEnable
        }

        Set
        {
            If (!SettingsModel.ValidWindowGroupes.Contains(value))
            {
                throw Exception(A_ThisFunc " wrong value passed")
            }
            Return this._cloneAndSetValue("_whereToEnable", value)
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
            Return this._cloneAndSetValue("_openGranary", value)
        }
    }

    OpenArmoury[]
    {
        Get
        {
            Return this._openArmory
        }

        Set
        {
            Return this._cloneAndSetValue("_openArmory", value)
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
            Return this._cloneAndSetValue("_openEngineersGuild", value)
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
            Return this._cloneAndSetValue("_openKeep", value)
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
            Return this._cloneAndSetValue("_openTunnlerGuild", value)
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
            Return this._cloneAndSetValue("_openBarracks", value)
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
            Return this._cloneAndSetValue("_openMercenaries", value)
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
            Return this._cloneAndSetValue("_openMarket", value)
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
            Return this._cloneAndSetValue("_openAdministration", value)
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
            Return this._cloneAndSetValue("_sendRandomTauntMessage", value)
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
            Return this._cloneAndSetValue("_increaseGameSpeed", value)
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
            Return this._cloneAndSetValue("_decreaseGameSpeed", value)
        }
    }

    GetAllReplaceKeyOptions()
    {
        result := this._toObject()
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
        ; TODO ValidWindowGroupes make something better
        obj := {"WhereToEnable": SettingsModel.ValidWindowGroupes[3], "OpenGranary": "g", "OpenArmory": "a"
              , "OpenEngineersGuild": "i", "OpenKeep": "h", "OpenTunnlerGuild": "t", "OpenMercenaries": "n"
              , "OpenMarket": "m", "OpenAdministration": "Tab", "SendRandomTauntMessage": ""
              , "IncreaseGameSpeed": "", "DecreaseGameSpeed": ""}
        Return new ReplaceKeysModel(obj)
    }

    FromIniString(str)
    {
        ini := _iniSection.Parse(str)
        If (ini.Title != "ReplaceKeys")
        {
            throw Exception("Ini string is not an ReplaceKeys")
        }

        If (!ini.Pairs.Enable.In(true, false) || !ini.Pairs.Key.In("MButton", "XButton1", "XButton2"))
        {
            throw Exception("Ini string is not an ReplaceKeys")
        }

        Return new ReplaceKeysModel(ini.Pairs.Enable, ini.Pairs.Key)
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
            If (key.StartsWith("_") && !IsObject(value))
            {
                ; Replace the "_" at the beginning and make the first char upper case
                result[key.SubStr(2, 1).ToUpper() key.SubStr(3)] := value
            }
        }
        Return result
    }

    _cloneAndSetValue(property, value)
    {
        If (!SettingsModel.ValidReplaceKeys.Contains(value))
        {
            throw Exception(A_ThisFunc " wrong value passed")
        }

        result := ObjClone(this)
        result._enable := value
        Return result
    }
}