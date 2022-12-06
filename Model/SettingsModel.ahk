class SettingsModel extends ISettingsModel
{
    class Events
    {
        static AutoClicker := "AutoClicker"
             , MapNavigation := "MapNavigation"
             , ReplaceKeys := "ReplaceKeys"
             , General := "General"
    }

    __New()
    {
        this._autoClicker := ""
        this._mapNavigation := ""
        this._replaceKeys := ""
        this._general := ""

        this._changes := new PropertyChangeSupport()
    }

    ; Adds a new eventlistener
    AddPropertyChangeListener(listener)
    {
        this._changes.AddPropertyChangeListener(listener)
    }

    ; Removes an eventlistener
    RemovePropertyChangeListener(listener)
    {
        this._changes.RemovePropertyChangeListener(listener)
    }

    AutoClicker[]
    {
        Get
        {
            Return this._autoClicker
        }

        Set
        {
            If (!InstanceOf(value, AutoClickerModel))
            {
                throw Exception("Invalid AutoClicker setting given")
            }

            this._setValue(SettingsModel.Events.AutoClicker, "_autoClicker", value)
        }
    }

    MapNavigation[]
    {
        Get
        {
            Return this._mapNavigation
        }

        Set
        {
            If (!InstanceOf(value, MapNavigationModel))
            {
                throw Exception("Invalid MapNavigation setting given")
            }

            this._setValue(SettingsModel.Events.MapNavigation, "_mapNavigation", value)
        }
    }

    ReplaceKeys[]
    {
        Get
        {
            Return this._replaceKeys
        }

        Set
        {
            If (!InstanceOf(value, ReplaceKeysModel))
            {
                throw Exception("Invalid ReplaceKeys setting given")
            }

            this._setValue(SettingsModel.Events.ReplaceKeys, "_replaceKeys", value)
        }
    }

    General[]
    {
        Get
        {
            Return this._general
        }

        Set
        {
            If (!InstanceOf(value, GeneralModel))
            {
                throw Exception("Invalid General setting given")
            }

            this._setValue(SettingsModel.Events.General, "_general", value)
        }
    }

    ; Valid options. Static properties

    ; Returns a list of all WindowGroups that are supported
    ValidWindowGroupes[]
    {
        Get
        {
            Return ["Stronghold", "Crusader", "StrongholdAndCrusader"]
        }
    }

    ; Get a list of all key names that are valid auto clicker keys
    ValidAutoClickerKeys[]
    {
        Get
        {
            Return ["MButton", "XButton1", "XButton2"]
        }
    }

    ; Get a list of all key names that are valid map navigation toggle keys
    ValidToggleKeys[]
    {
        Get
        {
            result := ["CapsLock", "Tab"]
            Loop, 12
            {
                result.Push("F" A_Index)
            }
            Loop, 10
            {
                result.Push("Numpad" (A_Index - 1))
            }
            result.Push("NumpadEnter", "NumpadMult", "NumpadDiv", "NumpadDot")
            Return result
        }
    }

    ; Get a list of all keys that may be used for replacing
    ValidReplaceKeys[]
    {
        Get
        {
            result := []
            ; All letters, except w, a, s, d as they may only be used for navigating the map
            Loop, 26
            {
                chr := Chr(A_Index + 96)
                If (chr !== "w" && chr !== "a" && chr !== "s" && chr !== "d")
                {
                    result.Add(chr)
                }
            }
            ; Numbers 0 to 9
            Loop, 10
            {
                result.Add(A_Index - 1)
            }
            ; Numpad numbers 0 to 9
            Loop, 10
            {
                result.Add("Numpad" A_Index - 1)
            }
            ; Some other characters
            For each, key in [".", ",", "+", "-"]
            {
                result.Add(key)
            }
            Return result
        }
    }

    ; Get a list of all valid update freuquencies
    ValidCheckForUpdatesFrequency[]
    {
        Get
        {
            Return ["startup", "day", "week", "month", "never"]
        }
    }

    ; Sets the value in the property name. If the current value is different to the new, it fires a PropertyChangeEvent
    _setValue(eventName, propertyName, newValue)
    {
        If (this[propertyName].Equals(newValue))
        {
            Return
        }

        before := this[propertyName]
        this[propertyName] := newValue
        after := this[propertyName]

        this._changes.FirePropertyChange(eventName, before, after)
    }

    Equals(other)
    {
        If (this == other)
        {
            Return true
        }

        If (ClassName(other) !== "SettingsModel")
        {
            Return false
        }

        Return this._autoClicker.Equals(other._autoClicker)
            && this._mapNavigation.Equals(other._mapNavigation)
            && this._replaceKeys.Equals(other._replaceKeys)
            && this._general.Equals(other._general)
    }

    Default()
    {
        result := new SettingsModel()
        result._autoClicker := AutoCLickerModel.Default()
        result._mapNavigation := MapNavigationModel.Default()
        result._replaceKeys := ReplaceKeysModel.Default()
        result._general := GeneralModel.Default()
        Return result
    }

    FromIniString(str)
    {
        sections := []
        section := {title: "", body: ""}
        For each, line in str.Split("`n", "`r")
        {
            l := line.Trim()
            If (l.StartsWith("[") && l.EndsWith("]"))
            {
                sections.Add(section)
                section := {title: l, body: ""}
            }
            Else
            {
                section.body .= l "`n"
            }
        }
        sections.Add(section)

        result := new SettingsModel()
        For each, section in sections
        {
            try
            {
                Switch section.title
                {
                    Case "[AutoClicker]":
                        parsed := AutoClickerModel.FromIniString(section.title "`n" section.body)
                        result._autoClicker := parsed
                    Case "[MapNavigation]":
                        parsed := MapNavigationModel.FromIniString(section.title "`n" section.body)
                        result._mapNavigation := parsed
                    Case "[ReplaceKeys]":
                        parsed := ReplaceKeysModel.FromIniString(section.title "`n" section.body)
                        result._replaceKeys := parsed
                    Case "[General]":
                        parsed := GeneralModel.FromIniString(section.title "`n" section.body)
                        result._general := parsed
                }
            }
        }

        result._autoClicker := IsObject(result._autoClicker) ? result._autoClicker : AutoClickerModel.Default()
        result._mapNavigation := IsObject(result._mapNavigation) ? result._mapNavigation : MapNavigationModel.Default()
        result._replaceKeys := IsObject(result._replaceKeys) ? result._replaceKeys : ReplaceKeysModel.Default()
        result._general := IsObject(result._general) ? result._general : GeneralModel.Default()

        Return result
    }

    ToIniString()
    {
        result := ""
        result .= this._autoClicker.ToIniString()
        result .= "`n"
        result .= this._mapNavigation.ToIniString()
        result .= "`n"
        result .= this._replaceKeys.ToIniString()
        result .= "`n"
        result .= this._general.ToIniString()
        result .= "`n"
        Return result
    }
}