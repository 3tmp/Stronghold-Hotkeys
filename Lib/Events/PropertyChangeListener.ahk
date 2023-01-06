; A class that the user must instanciate when one wants to listen out for events
class PropertyChangeListener extends _Object
{
    ; fn: The callback to call when the event gets fired. Receives one param (A _propertyChangeEvent)
    ; eventName: Optional. The name of the event which must occur to call the callback. If this is blank, the callback will always be called
    __New(fn, eventName := "")
    {
        If (!TypeOf(fn, "Func"))
        {
            throw new InvalidCallbackException("Callback is not of type Func or BoundFunc")
        }

        this._fn := fn
        this.Event := eventName
    }

    ; The callback func that gets called when the event gets fired
    Callback[]
    {
        Get
        {
            Return this._fn
        }
    }

    ; Get/Set Blank to subscribe to all events, the name of an event to only receive special events
    ; Returns the name of the event if the user specified an event name, "" otherwise
    Event[]
    {
        Get
        {
            Return this._name
        }

        Set
        {
            If (IsObject(value))
            {
                throw new IllegalArgumentException("Event names must not be objects")
            }
            this._name := value
        }
    }
}
