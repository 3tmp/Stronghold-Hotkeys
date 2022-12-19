; Toggle the state of the StateChangeListener every time it gets called
class GeneralToggleExecutor extends IHotkeyExecutor
{
    static _logger := LoggerFactory.GetLogger(GeneralToggleExecutor)

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
        GeneralToggleExecutor._logger.Debug("Executing toggle key (set state to " (!this._stateChange.State ? "on" : "off") ")")

        ; Toggle the statechange value
        this._stateChange.State ^= true
    }
}