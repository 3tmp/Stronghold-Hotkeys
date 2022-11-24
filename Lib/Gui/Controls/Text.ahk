class GuiBase_TextControl extends GuiBase_ContentControl
{
    static _type := "Text"

    ; Click event handler
    OnClick(fn, add := true)
    {
        this._registerEvent(fn, "Normal", add)
        Return this
    }

    ; Double click event handler
    OnDoubleClick(fn, add := true)
    {
        this._registerEvent(fn, "DoubleClick", add)
        Return this
    }

    ; A custom event handler
    _event(hwnd, event, info, errLevel := "")
    {
        eventArgs := new GuiBase_ContentControlEventArgs(this, event, info, errLevel)
        this._fireCustomEvent(eventArgs, event)
    }
}