class PropertyChangeSupport
{
    __New()
    {
        this._listeners := []
    }

    ; Adds listeners to the calling list
    ; listener: Must be of type PropertyChangeListener
    AddPropertyChangeListener(listener)
    {
        If (!InstanceOf(listener, PropertyChangeListener))
        {
            throw Exception("The listener is of the wrong type")
        }
        this._listeners.Add(listener)
    }

    ; Removes listners from the calling list
    ; listener: Must be of type PropertyChangeListener
    RemovePropertyChangeListener(listener)
    {
        this._listeners.Remove(listener)
    }

    ; Determines if the listener is contained in this
    ; listenerOrName: The listener to check. Can be of type PropertyChangeListener or string
    ; Returns true if a listener exists that matches, false otherwise
    HasPropertyChangeListener(listenerOrName)
    {
        If (InstanceOf(listenerOrName, PropertyChangeListener))
        {
            Return this._listeners.Contains(listenerOrName)
        }
        Return !this._listeners.Filter(OBM(this, "_filterListenersByNameCallback", listenerOrName)).IsEmpty()
    }

    ; Returns an array of all listeners inside of this
    ; propertyName: Optional. If passed, returns only the properties that match the name
    ; Returns a list of all listeners that matched
    GetPropertyChangeListeners(propertyName := "")
    {
        If (propertyName == "")
        {
            Return this._listeners.Copy()
        }
        Return this._listeners.Filter(OBM(this, "_filterListenersByNameCallback", propertyName))
    }

    ; To fire an event call this function with the appropriate values
    ; eventOrName: The name of the event as string
    ; oldValue: The old value or object
    ; newValue: The new value or object
    FirePropertyChange(eventName, oldValue, newValue)
    {
        If (IsObject(eventName) || eventName == "")
        {
            throw Exception("The event name must be a string")
        }

        event := new _propertyChangeEvent(eventName, oldValue, newValue)

        ; Call all listeners
        For each, listener in this._listeners
        {
            If ((fn := listener.Callback) && (listener.Event == "" || listener.Event == eventName))
            {
                %fn%(event)
            }
        }
    }

    _filterListenersByNameCallback(name, listener)
    {
        Return listener.Event == name
    }
}