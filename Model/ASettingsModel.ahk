; An abstract SettingsModel that gets inherited by all settings models (e.g. AutoClickerModel)
; except the SettingsModel
class ASettingsModel extends ISettingsModel
{
    ; Any deriving class has to call the base ctor
    __New()
    {
        this.__changes := new PropertyChangeSupport()
    }

    ; Add the given listener
    _addEventListener(listener)
    {
        this.__changes.AddPropertyChangeListener(listener)
    }

    ; Remove the given listener
    _removeEventListener(listener)
    {
        this.__changes.RemovePropertyChangeListener(listener)
    }

    ; Sets the value in the property name. If the current value is different to the new, it fires a PropertyChangeEvent
    _setValue(propertyName, newValue)
    {
        ; If the values are the same, do nothing
        If (this[propertyName] == newValue)
        {
            Return
        }

        before := ObjClone(this)
        this[propertyName] := newValue
        after := this

        this.__changes.FirePropertyChange(ClassName(this), before, after)
    }
}