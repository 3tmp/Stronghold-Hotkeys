class ReplaceKeysExecutor extends IHotkeyExecutor
{
    __New(commandName)
    {
        this._commandName := commandName
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