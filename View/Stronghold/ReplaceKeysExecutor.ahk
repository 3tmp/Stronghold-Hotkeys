class ReplaceKeysExecutor extends IHotkeyExecutor
{
    static _logger := LoggerFactory.GetLogger(ReplaceKeysExecutor)

    __New(commandName)
    {
        this._commandName := commandName
    }

    Execute(params*)
    {
        ReplaceKeysExecutor._logger.Debug("Executing " this._commandName)

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