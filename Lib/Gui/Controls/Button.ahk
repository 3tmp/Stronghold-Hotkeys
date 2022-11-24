class GuiBase_ButtonControl extends GuiBase_ContentControl
{
    static _type := "Button"

    ; Click event handler
    OnClick(fn, add := true)
    {
        Return this.OnEvent(fn, add)
    }
}