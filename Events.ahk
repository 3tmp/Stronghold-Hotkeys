; An event emitter that gets fired when a setting changes
class SettingsChangeEvent
{
    __New()
    {
        this._listeners := []
    }

    ; Adds a new listener to the event
    AddListener(callback)
    {
        If (!this._contains(callback))
        {
            this._listeners.Push(callback)
        }
    }

    ; Fires the event and passes the given parameters to the listeners
    Fire(params*)
    {
        If (params.Length())
        {
            For each, listener in this._listeners
            {
                %listener%(params*)
            }
        }
        Else
        {
            For each, listener in this._listeners
            {
                %listener%()
            }
        }
    }

    _contains(value)
    {
        For each, listener in this._listeners
        {
            If (listener == value)
            {
                Return true
            }
        }
        Return false
    }
}