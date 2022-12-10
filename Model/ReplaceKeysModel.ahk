﻿class ReplaceKeysModel extends ASettingsModel
{
    __New(param)
    {
        base.__New()
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
            Return this._openArmory
        }

        Set
        {
            this._setValue("_openArmory", value)
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
        For each, value in this._toObject()
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
            If (!IsObject(value) && key.StartsWith("_"))
            {
                ; Replace the "_" at the beginning and make the first char upper case
                result[key.SubStr(2, 1).ToUpper() key.SubStr(3)] := value
            }
        }
        Return result
    }
}