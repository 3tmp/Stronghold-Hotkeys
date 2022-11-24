class GuiBase_CheckBoxControl extends GuiBase_BaseControl
{
    static _type := "CheckBox"

    ; Gets/Sets the state of the control
    State[]
    {
        Get
        {
            GuiControlGet, state,, % this._hwnd
            Return state
        }
        Set
        {
            If (value == 1 || value = "check")
            {
                value := 1
            }
            Else If (value == 0 || value = "uncheck")
            {
                value := 0
            }
            Else
            {
                Return
            }
            GuiControl,, % this._hwnd, % value
        }
    }

    ; Returns true if the button is selected, false if not selected/greyed out/3rd state
    IsChecked[]
    {
        Get
        {
            Return this.State == 1
        }

        Set
        {
            If (value)
            {
                this.Check()
            }
            Else
            {
                this.UnCheck()
            }
        }
    }

    ; Get/Set the text of the control
    Text[]
    {
        Get
        {
            GuiControlGet, text,, % this._hwnd, Text
            Return text
        }

        Set
        {
            GuiControl, Text, % this._hwnd, % value
        }
    }

    ; Checks the control
    Check()
    {
        this.State := 1
    }

    ; Unchecks the control
    Uncheck()
    {
        this.State := 0
    }

    ; Click event handler
    OnClick(fn, add := true)
    {
        Return this.OnEvent(fn, add)
    }

    ; Overwrite the default event handler. Use the CheckBoxEventArgs to support the IsChecked property
    _event(hwnd, event, info, errLevel := "")
    {
        this._fireDefaultEvent(new GuiBase_CheckBoxEventArgs(this, event, info, errLevel))
    }
}