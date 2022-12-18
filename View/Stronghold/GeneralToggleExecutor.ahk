; Toggle the state of the StateChangeListener every time it gets called
class GeneralToggleExecutor extends IHotkeyExecutor
{
    __New(stateChange)
    {
        If (!InstanceOf(stateChange, StateChangeListener))
        {
            throw Exception("The given stateChange is not an instance of StateChangeListener")
        }

        this._stateChange := stateChange
    }

    Execute()
    {
        ; Toggle the statechange value
        this._stateChange.State ^= true
    }
}