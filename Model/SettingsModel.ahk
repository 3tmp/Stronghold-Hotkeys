class SettingsModel extends ISettingsModel
{
    class Events
    {
        static AutoClicker := "AutoClicker"
             , MapNavigation := "MapNavigation"
             , ReplaceKeys := "ReplaceKeys"
             , General := "General"
    }

    ; Private ctor
    __New()
    {
        this._autoClicker := ""
        this._mapNavigation := ""
        this._replaceKeys := ""
        this._general := ""

        this._autoClickerPropChange := ""
        this._mapNavigationPropChange := ""
        this._replaceKeysPropChange := ""
        this._generalPropChange := ""

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

    ; Get the AutoClicker model
    AutoClicker[]
    {
        Get
        {
            Return this._autoClicker
        }
    }

    ; Get the MapNavigation model
    MapNavigation[]
    {
        Get
        {
            Return this._mapNavigation
        }
    }

    ; Get the ReplaceKeys model
    ReplaceKeys[]
    {
        Get
        {
            Return this._replaceKeys
        }
    }

    ; Get the Generl model
    General[]
    {
        Get
        {
            Return this._general
        }
    }

    ; Resets the AutoClicker model to the default values
    ResetAutoClicker()
    {
        this._resetModel("_autoClicker", AutoClickerModel.Default(), this._autoClickerPropChange, SettingsModel.Events.AutoClicker)
    }
    
    ; Resets the MapNavigation model to the default values
    ResetMapNavigation()
    {
        this._resetModel("_mapNavigation", MapNavigationModel.Default(), this._mapNavigationPropChange, SettingsModel.Events.MapNavigation)
    }

    ; Resets the ReplaceKeys model to the default values
    ResetReplaceKeys()
    {
        this._resetModel("_replaceKeys", ReplaceKeysModel.Default(), this._replaceKeysPropChange, SettingsModel.Events.ReplaceKeys)
    }

    ; Resets the General model to the default values
    ResetGeneral()
    {
        this._resetModel("_general", GeneralModel.Default(), this._generalPropChange, SettingsModel.Events.General)
    }

    ; Valid options. Static properties

    ; Returns a list of all WindowGroups that are supported
    ValidWindowGroups[]
    {
        Get
        {
            Return EWindowGroups.Values()
        }
    }

    ; Get a list of all key names that are valid auto clicker keys
    ValidAutoClickerKeys[]
    {
        Get
        {
            Return EAutoClickerKeys.Values()
        }
    }

    ; Get a list of all key names that are valid map navigation toggle keys
    ValidToggleKeys[]
    {
        Get
        {
            Return EToggleKeys.Values()
        }
    }

    ; Get a list of all keys that may be used for replacing
    ValidReplaceKeys[]
    {
        Get
        {
            Return EReplaceKeys.Values()
        }
    }

    ; Get a list of all valid update freuquencies
    ValidCheckForUpdatesFrequency[]
    {
        Get
        {
            Return ECheckForUpdatesFrequency.Values()
        }
    }

    ; Resets an inner model and replaces it with the default
    _resetModel(propertyName, default, fn, eventName)
    {
        before := this[propertyName]
        this[propertyName] := default
        this[propertyName]._addEventListener(fn)
        after := this[propertyName]
        this._firePropertyChange(eventName, before, after)
    }

    ; Gets called by the property change events from the AutoClicker, MapNavigation, ReplaceKeys, General models
    ; and redirects the received values to the property change event of this class
    _valueInSubModelChange(eventName, event)
    {
        this._firePropertyChange(eventName, event.OldValue, event.NewValue)
    }

    ; fires the property change event
    _firePropertyChange(eventName, before, after)
    {
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
        result._autoClicker := AutoClickerModel.Default()
        result._mapNavigation := MapNavigationModel.Default()
        result._replaceKeys := ReplaceKeysModel.Default()
        result._general := GeneralModel.Default()
        SettingsModel._setUpListeners(result)

        Return result
    }

    FromIniString(str)
    {
        sections := []
        section := {title: "", body: ""}
        For each, line in str.Split("`n", "`r")
        {
            l := line.Trim()
            If (l == "")
            {
                Continue
            }
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
        SettingsModel._setUpListeners(result)

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
        Return result
    }

    ; Add listeners to all inner models for the given SettingsModel object
    _setUpListeners(obj)
    {
        obj._autoClickerPropChange := new PropertyChangeListener(OBM(obj, "_valueInSubModelChange", SettingsModel.Events.AutoClicker))
        obj._autoClicker._addEventListener(obj._autoClickerPropChange)

        obj._mapNavigationPropChange := new PropertyChangeListener(OBM(obj, "_valueInSubModelChange", SettingsModel.Events.MapNavigation))
        obj._mapNavigation._addEventListener(obj._mapNavigationPropChange)

        obj._replaceKeysPropChange := new PropertyChangeListener(OBM(obj, "_valueInSubModelChange", SettingsModel.Events.ReplaceKeys))
        obj._replaceKeys._addEventListener(obj._replaceKeysPropChange)

        obj._generalPropChange := new PropertyChangeListener(OBM(obj, "_valueInSubModelChange", SettingsModel.Events.General))
        obj._general._addEventListener(obj._generalPropChange)
    }
}