; A class that holds a state (true/false) and fires an event once it changes
class StateChangeListener extends _Object
{
    __New(initialState := false)
    {
        this._event := new BaseEvent()
        this._state := initialState
    }

    ; Get/Set the state of the object
    State[]
    {
        Get
        {
            Return this._state
        }

        Set
        {
            If (value !== true && value !== false)
            {
                throw Exception("Wrong state given")
            }
    
            If (this._state == value)
            {
                Return
            }
            this._state := value
            this._event.Fire()
        }
    }

    ; Add/Remove a state change event listener
    OnStateChange(listener, add := true)
    {
        If (add)
        {
            this._event.AddListener(listener)
        }
        Else
        {
            this._event.RemoveEventListener(listener)
        }
    }
}