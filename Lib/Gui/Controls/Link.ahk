class GuiBase_LinkControl extends GuiBase_BaseControl
{
    static _type := "Link"

    ; Click event handler. Gets called when the user clicks on a link.
    ; Caution: If the link contains a href attribute with a valid link or run command, the event does not get fired
    OnClick(fn, add := true)
    {
        this._registerEvent(fn, "Normal", add)
        Return this
    }

    ; A custom event handler
    _event(hwnd, event, info, errLevel := "")
    {
        eventArgs := new GuiBase_LinkEventArgs(this, event, info, errLevel)
        this._fireCustomEvent(eventArgs, event)
    }
}