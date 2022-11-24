; The event that gets fired. This gets automatically created when an event gets fired
; Must not be instanciated manually
class _propertyChangeEvent extends _Object
{
    ; name: The name of the event as string
    ; oldValue: The old value or object
    ; newValue: The new value or object
    __New(name, oldValue, newValue)
    {
        this._name := name
        this._old := oldValue
        this._new := newValue
    }

    ; The name of the event as string
    Name[]
    {
        Get
        {
            Return this._name
        }
    }

    ; The previous value
    OldValue[]
    {
        Get
        {
            Return this._old
        }
    }

    ; The new value
    NewValue[]
    {
        Get
        {
            Return this._new
        }
    }
}
