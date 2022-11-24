; A simple class for event support
class BaseEvent
{
    __New()
    {
        this._listeners := []
    }

    ; Adds a new listener to the event
    ; callback: A callback with the correct amount of parameter
    ; Throws if the callback is invalid
    AddListener(callback)
    {
        If (!TypeOf(callback, "Func"))
        {
            throw Exception("Callback is not of type Func or BoundFunc")
        }
        If (!this._listeners.Contains(callback))
        {
            this._listeners.Add(callback)
        }
    }

    ; Removes a listener from the event
    ; listener: The callback that was previously used to register the listener
    RemoveListener(callback)
    {
        this._listeners.Remove(callback)
    }

    ; Removes all listeners
    RemoveAll()
    {
        this._listeners.Clear()
    }

    ; Gets a readonly view of all listeners
    ; Returns All listeners
    GetListeners()
    {
        Return this._listeners.Copy()
    }

    ; Determines if the event has any listeners
    ; Returns true if there are any listeners, false if there are none
    HasListeners()
    {
        Return !this._listeners.IsEmpty()
    }

    ; Fires the event.
    ; params: Variadic. Any number of parameter that a func receives
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
}