class SettingsModel
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
}