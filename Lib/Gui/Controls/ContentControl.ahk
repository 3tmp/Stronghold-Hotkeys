class GuiBase_ContentControl extends GuiBase_BaseControl
{
    ; Get/Set the text of the control
    Text[]
    {
        Get
        {
            GuiControlGet, text,, % this._hwnd
            Return text
        }

        Set
        {
            GuiControl,, % this._hwnd, % value
        }
    }
}