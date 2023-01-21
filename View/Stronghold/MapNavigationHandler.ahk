; Special case of the hotkeys handler. Cannot encapsulate it into a class as the hotkeys can only be defined like this,
; otherwise they would not trigger continously.

class MapNavigationHandler extends _Object
{
    static _logger := LoggerFactory.GetLogger(MapNavigationHandler)

    __New(stateChangeListener, enable, whereToEnable)
    {
        this._stateChange := stateChangeListener
        this._stateChange.OnStateChange(OBM(this, "_stateChangeEvent"))

        this._stateChangeEvent()
        this.MapNavEnableEvent(enable)
        this.MapNavWhereToEnableEvent(whereToEnable)
    }

    _stateChangeEvent()
    {
        global MapNavIsToggleEnabled

        MapNavigationHandler._logger.Debug("Toggle event received. State is now " (!this._stateChange.State ? "off" : "on"))

        MapNavIsToggleEnabled := this._stateChange.State
    }

    MapNavEnableEvent(enable)
    {
        global MapNavIsEnabled

        MapNavigationHandler._logger.Debug((enable ? "Enable" : "Disable") " MapNavigation")

        MapNavIsEnabled := enable
    }

    MapNavWhereToEnableEvent(whereToEnable)
    {
        global MapNavWhereToEnable

        MapNavigationHandler._logger.Debug("Enable navigation in the '" whereToEnable "' group")

        MapNavWhereToEnable := whereToEnable
    }
}