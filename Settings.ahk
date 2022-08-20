; Holds all settings of the program
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

    ; Create a new instance of the SettingsController. Always use this method to create a new instance
    ; filePath: If the filePath does not exist, it gets created with the default settings
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

    ; Saves the current settings to the given file path. If the file already exists, it gets replaced
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

    ; The event that gets fired before map navigation settings get changed
    ; Used to unregister any toggle hotkey
    OnBeforeMapNavigationChange(callback)
    {
        this._mapNavBeforeEvent.AddListener(callback)
    }

    ; The event that gets fired after map navigation settings got changed
    OnAfterMapNavigationChange(callback)
    {
        this._mapNavAfterEvent.AddListener(callback)
    }

    ; The event that gets fired before auto clicker settings get changed
    ; Used to unregister any hotkey
    OnBeforeAutoClickerChange(callback)
    {
        this._autoClickerBeforeEvent.AddListener(callback)
    }
    
    ; The event that gets fired after auto clicker settings got changed
    OnAfterAutoClickerChange(callback)
    {
        this._autoClickerAfterEvent.AddListener(callback)
    }

    ; Get/Set an object that represents the current general settings (currently there are none)
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

    ; Get/Set an object that represents the current map navigation settings (Enable, WhereToEnable, ToggleKey)
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

    ; Get/Set an object that represents the current auto clicker settings (Enable, Key)
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

    ; Get a list of names of the groups that represent the games
    GameGroupNames[]
    {
        Get
        {
            Return ["Stronghold", "Crusader", "StrongholdAndCrusader"]
        }
    }

    ; Get a list of all key names that are valid auto clicker keys
    AutoClickerKeys[]
    {
        Get
        {
            Return ["MButton", "XButton1", "XButton2"]
        }
    }

    ; Get a list of all key names that are valid map navigation toggle keys
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

    ; For internal use only

    ; Sets and applies new settings
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

    ; Ensures that the given config object is valid
    _verifyConfig(config)
    {
        If (config.HasKey("General"))
        {

        }
        If (config.HasKey("MapNavigation"))
        {
            nav := config.MapNavigation

            If (nav.HasKey("Enable") && !ValueIn(nav.Enable, "0", "1"))
            {
                Return false
            }
            If (nav.HasKey("WhereToEnable") && !ValueIn(nav.WhereToEnable, this.GameGroupNames*))
            {
                Return false
            }
            If (nav.HasKey("ToggleKey") && !ValueIn(nav.ToggleKey, this.MapNavToggleKeys*))
            {
                Return false
            }
        }
        If (config.HasKey("AutoClicker"))
        {
            clicker := config.AutoClicker

            If (clicker.HasKey("Enable") && !ValueIn(clicker.Enable, "0", "1"))
            {
                Return false
            }
            If (clicker.HasKey("Key") && !ValueIn(clicker.Key, this.AutoClickerKeys*))
            {
                Return false
            }
        }

        Return true
    }

    ; Returns a deep clone of the SettingsController._defaultConfig
    _deepClone()
    {
        result := {}
        For key, value in SettingsController._defaultConfig
        {
            result[key] := SettingsController._defaultConfig[key].Clone()
        }
        Return result
    }
}