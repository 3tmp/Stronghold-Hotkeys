class ReplaceKeysExecutor extends IHotkeyExecutor
{
    __New(commandName, stateChange)
    {
        If (!InstanceOf(stateChange, StateChangeListener))
        {
            throw Exception("The given stateChange is not an instance of StateChangeListener")
        }

        this._commandName := commandName
        this._stateChange := stateChange
    }

    Execute(params*)
    {
        If (params.Length())
        {
            StrongholdManager[this._commandName](params*)
        }
        Else
        {
            StrongholdManager[this._commandName]()
        }
    }
}