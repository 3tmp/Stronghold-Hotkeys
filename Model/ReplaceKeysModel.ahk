class ReplaceKeysModel extends ASettingsModel
{
    ; Private ctor
    __New(param)
    {
        base.__New()
        this._enable := param.Enable
        this._whereToEnable := param.WhereToEnable
        this._goToSignPost := param.GoToSignPost
        this._openGranary := param.OpenGranary
        this._openEngineersGuild := param.OpenEngineersGuild
        this._openKeep := param.OpenKeep
        this._openBarracks := param.OpenBarracks
        this._openTunnlerGuild := param.OpenTunnlerGuild
        this._openMercenaries := param.OpenMercenaries
        this._openMarket := param.OpenMarket
        this._rotateScreenClockWise := param.RotateScreenClockWise
        this._rotateScreenCounterClockWise := param.RotateScreenCounterClockWise
        this._toggleUI := param.ToggleUI
        this._toggleZoom := param.ToggleZoom
        this._togglePause := param.TogglePause
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

    GoToSignPost[]
    {
        Get
        {
            Return this._goToSignPost
        }

        Set
        {
            this._verifyKey("GoToSignPost", value)
            this._setValue("_goToSignPost", value)
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
            this._verifyKey("OpenGranary", value)
            this._setValue("_openGranary", value)
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
            this._verifyKey("OpenEngineersGuild", value)
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
            this._verifyKey("OpenKeep", value)
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
            this._verifyKey("OpenTunnlerGuild", value)
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
            this._verifyKey("OpenBarracks", value)
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
            this._verifyKey("OpenMercenaries", value)
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
            this._verifyKey("OpenMarket", value)
            this._setValue("_openMarket", value)
        }
    }

    RotateScreenClockWise[]
    {
        Get
        {
            Return this._rotateScreenClockWise
        }

        Set
        {
            this._verifyKey("RotateScreenClockWise", value)
            this._setValue("_rotateScreenClockWise", value)
        }
    }

    RotateScreenCounterClockWise[]
    {
        Get
        {
            Return this._rotateScreenCounterClockWise
        }

        Set
        {
            this._verifyKey("RotateScreenCounterClockWise", value)
            this._setValue("_rotateScreenCounterClockWise", value)
        }
    }

    ToggleUI[]
    {
        Get
        {
            Return this._toggleUI
        }

        Set
        {
            this._verifyKey("ToggleUI", value)
            this._setValue("_toggleUI", value)
        }
    }

    ToggleZoom[]
    {
        Get
        {
            Return this._toggleZoom
        }

        Set
        {
            this._verifyKey("ToggleZoom", value)
            this._setValue("_toggleZoom", value)
        }
    }

    TogglePause[]
    {
        Get
        {
            Return this._togglePause
        }

        Set
        {
            this._verifyKey("TogglePause", value)
            this._setValue("_togglePause", value)
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
            this._verifyKey("SendRandomTauntMessage", value)
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
            this._verifyKey("IncreaseGameSpeed", value)
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
            this._verifyKey("DecreaseGameSpeed", value)
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
        obj := {"Enable": true, "WhereToEnable": EWindowGroups.StrongholdAndCrusader, "GoToSignPost": "", "OpenGranary": EReplaceKeys.g
              , "OpenEngineersGuild": EReplaceKeys.i, "OpenKeep": EReplaceKeys.h, "OpenTunnlerGuild": EReplaceKeys.t
              , "OpenBarracks": EReplaceKeys.b, "OpenMercenaries": EReplaceKeys.n, "OpenMarket": EReplaceKeys.m, "ToggleUI": "", "ToggleZoom": ""
              , "TogglePause": "", "RotateScreenClockWise": "", "RotateScreenCounterClockWise": ""
              , "SendRandomTauntMessage": "", "IncreaseGameSpeed": EReplaceKeys.Plus, "DecreaseGameSpeed": EReplaceKeys.Minus}
        Return new ReplaceKeysModel(obj)
    }

    FromIniString(str)
    {
        ini := _iniSection.Parse(str)
        If (ini.Title != "ReplaceKeys")
        {
            throw Exception("Ini string is not a ReplaceKeys")
        }

        If (!ini.Pairs.Enable.In(true, false) || !EWindowGroups.ValidValue(ini.Pairs.WhereToEnable))
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
            If (value == "")
            {
                Continue
            }
            If (uniqueValues.HasKey(value))
            {
                throw Exception("Ini string is not a ReplaceKeys")
            }
            uniqueValues[value] := 1
        }

        ; Ensure that only valid (keyboard)-key are set
        For each, key in kvPair
        {
            If (key == "")
            {
                Continue
            }
            If (!EReplaceKeys.ValidValue(key))
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

    ; Returns an object with all properties from here set to string values
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

    ; Ensures that the given key is valid
    ; property: The name of the public property that called this func
    ; key: The (keyboard-)key to check
    _verifyKey(property, key)
    {
        ; In case of removing the hotkey, the key will be blank, which is always valid
        If (key == "")
        {
            Return
        }

        If (IsObject(key))
        {
            throw Exception("The given key must not be an object")
        }
        If (key.In("w", "a", "s", "d"))
        {
            throw Exception("The given key is reserved for map navigation")
        }
        allCurrentKeys := this.GetAllReplaceKeyOptions()
        ; In case the same key as the current gets passed, do nothing
        allCurrentKeys.Delete(property)
        For each, value in allCurrentKeys
        {
            If (value == key)
            {
                throw Exception("The given key is already in use")
            }
        }
    }
}