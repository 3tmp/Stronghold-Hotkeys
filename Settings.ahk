class SettingsController
{
    static _defaultConfig := {"General": {}
                            , "MapNavigation": {"Enable": 1
                                              , "WhereToEnable": "Stronghold"
                                              , "ToggleKey": "CapsLock"}
                            , "AutoClicker": {"Enable": 1
                                            , "Key": "MButton"}}

    ; Private ctor
    __New(config)
    {
        this._config := config
        this._mapNavBeforeEvent := new SettingsChangeEvent()
        this._mapNavAfterEvent := new SettingsChangeEvent()
        this._autoClickerBeforeEvent := new SettingsChangeEvent()
        this._autoClickerAfterEvent := new SettingsChangeEvent()
    }

    Static_Parse(filePath)
    {
        encoding := A_FileEncoding
        FileEncoding, UTF-8

        config := {}
        For section, obj in SettingsController._defaultConfig
        {
            If (!config[section])
            {
                config[section] := {}
            }
            For key, default in obj
            {
                IniRead, out, %filePath%, %section%, %key%, %default%
                config[section][key] := out
            }
        }

        FileEncoding, %encoding%

        If (!SettingsController._verifyConfig(config))
        {
            config := SettingsController._deepClone()
        }
        Return new SettingsController(config)
    }

    Save(filePath)
    {
        If (FileExist(filePath))
        {
            FileDelete, %filePath%
        }

        encoding := A_FileEncoding
        FileEncoding, UTF-8

        For section, obj in this._config
        {
            For key, value in obj
            {
                IniWrite, %value%, %filePath%, %section%, %key%
            }
        }

        FileEncoding, %encoding%
    }

    OnBeforeMapNavigationChange(callback)
    {
        this._mapNavBeforeEvent.AddListener(callback)
    }

    OnAfterMapNavigationChange(callback)
    {
        this._mapNavAfterEvent.AddListener(callback)
    }

    OnBeforeAutoClickerChange(callback)
    {
        this._autoClickerBeforeEvent.AddListener(callback)
    }

    OnAfterAutoClickerChange(callback)
    {
        this._autoClickerAfterEvent.AddListener(callback)
    }

    General[]
    {
        Get
        {
            Return this._config.General.Clone()
        }

        Set
        {
            this._set({"General": value})
        }
    }

    MapNavigation[]
    {
        Get
        {
            Return this._config.MapNavigation.Clone()
        }

        Set
        {
            this._set({"MapNavigation": value})
        }
    }

    AutoClicker[]
    {
        Get
        {
            Return this._config.AutoClicker.Clone()
        }

        Set
        {
            this._set({"AutoClicker": value})
        }
    }

    GameGroupNames[]
    {
        Get
        {
            Return ["Stronghold", "Crusader", "StrongholdAndCrusader"]
        }
    }

    AutoClickerKeys[]
    {
        Get
        {
            Return ["MButton", "XButton1", "XButton2"]
        }
    }

    MapNavToggleKeys[]
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
            result.Push("NumpadEnter", "NumpadAdd", "NumpadSub", "NumpadMult", "NumpadDiv", "NumpadDot")
            Return result
        }
    }

    _set(config)
    {
        If (!this._verifyConfig(config))
        {
            Return
        }

        If (config.HasKey("General"))
        {

        }
        If (config.HasKey("MapNavigation"))
        {
            this._mapNavBeforeEvent.Fire()

            thisNav := this._config.MapNavigation
            nav := config.MapNavigation

            thisNav.Enable := nav.HasKey("Enable") ? nav.Enable : thisNav.Enable
            thisNav.WhereToEnable := nav.HasKey("WhereToEnable") ? nav.WhereToEnable : thisNav.WhereToEnable
            thisNav.ToggleKey := nav.HasKey("ToggleKey") ? nav.ToggleKey : thisNav.ToggleKey

            this._mapNavAfterEvent.Fire()
        }
        If (config.HasKey("AutoClicker"))
        {
            this._autoClickerBeforeEvent.Fire()

            thisClicker := this._config.AutoClicker
            clicker := config.AutoClicker

            thisClicker.Enable := clicker.HasKey("Enable") ? clicker.Enable : thisClicker.Enable
            thisClicker.Key := clicker.HasKey("Key") ? clicker.Key : thisClicker.Key

            this._autoClickerAfterEvent.Fire()
        }

        this._apply()
    }

    _apply()
    {

    }

    _verifyConfig(config)
    {
        If (config.HasKey("General"))
        {

        }
        If (config.HasKey("MapNavigation"))
        {
            nav := config.MapNavigation

            If (nav.HasKey("Enable") && !this._valueIn(nav.Enable, "0", "1"))
            {
                Return false
            }
            If (nav.HasKey("WhereToEnable") && !this._valueIn(nav.WhereToEnable, this.GameGroupNames*))
            {
                Return false
            }
            If (nav.HasKey("ToggleKey") && !this._valueIn(nav.ToggleKey, this.MapNavToggleKeys*))
            {
                Return false
            }
        }
        If (config.HasKey("AutoClicker"))
        {
            clicker := config.AutoClicker

            If (clicker.HasKey("Enable") && !this._valueIn(clicker.Enable, "0", "1"))
            {
                Return false
            }
            If (clicker.HasKey("Key") && !this._valueIn(clicker.Key, this.AutoClickerKeys*))
            {
                Return false
            }
        }

        Return true
    }

    _deepClone()
    {
        result := {}
        For key, value in SettingsController._defaultConfig
        {
            result[key] := SettingsController._defaultConfig[key].Clone()
        }
        Return result
    }

    _valueIn(value, values*)
    {
        scs := A_StringCaseSense
        StringCaseSense, Off
        For each, val in values
        {
            If (value = val)
            {
                Return true
            }
        }
        StringCaseSense, %scs%
        Return false
    }
}