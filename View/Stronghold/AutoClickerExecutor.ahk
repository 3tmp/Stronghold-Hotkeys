; The AutoClicker hotkey gets bound to an instance of this class.
class AutoClickerExecutor extends IHotkeyExecutor
{
    static _sleep := 15
         , _logger := LoggerFactory.GetLogger(AutoClickerExecutor)

    ; key: As long as this key is pressed down, this will send left clicks
    __New(key)
    {
        this._key := key
    }

    ; Sends left mouse clicks as long as the given key is pressed down. Is a blocking function
    Execute()
    {
        AutoClickerExecutor._logger.Debug("Executing autoclick")

        While (GetKeyState(this._key, "P"))
        {
            StrongholdManager.ClickAtCurrentMousePos()
            Sleep, % AutoClickerExecutor._sleep
        }
    }
}