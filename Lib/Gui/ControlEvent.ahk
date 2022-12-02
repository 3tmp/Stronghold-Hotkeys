; Allows to register any number of listeners for gui control events (e.g.) a click event
class GuiBase_ControlEventHandler extends BaseEvent
{
    ; Fires the event and calls each listener
    ; @param eventArgs A GuiBase.EventArgs object
    Fire(eventArgs)
    {
        For each, listener in this._listeners
        {
            %listener%(eventArgs)
        }
    }
}

; The base class for all gui control events
class GuiBase_EventArgs
{
    ; @param sender The sender of the event (= control that fired the event)
    ; @param event The A_GuiEvent AutoHotkey variable
    ; @param eventInfo The A_EventInfo AutoHotkey variable
    ; @param errLevel The ErrorLevel AutoHotkey variable (mostly blank, as only a few events use it)
    __New(sender, event, eventInfo, errLevel)
    {
        this.Event := event
        , this.Sender := sender
        , this.EventInfo := eventInfo
        , this.ErrLevel := errLevel
    }

    ; Public properties

    ; - Sender
    ; - Event
    ; - EventInfo
    ; - ErrLevel

    ToString()
    {
        Return "Sender: " this.Sender.ToString() ", Event: " this.Event ", EventInfo: " this.EventInfo ", ErrLevel: " this.ErrLevel
    }
}

; Used by some controls that derive from GuiBase_ContentControl
class GuiBase_ContentControlEventArgs extends GuiBase_EventArgs
{
    __New(sender, event, eventInfo, errLevel)
    {
        base.__New(sender, event, eventInfo, errLevel)
        ; Use null() as the gui text might be empty
        this._text := null()
    }

    ; Get the text of the gui control
    Text[]
    {
        Get
        {
            If (this._text == null())
            {
                this._text := this.Sender.Text
            }
            Return this._text
        }
    }

    ToString()
    {
        Return base.ToString() ", Text: " this.Text
    }
}

class GuiBase_ChoiseEventArgs extends GuiBase_EventArgs
{
    __New(sender, event, eventInfo, errLevel, index)
    {
        base.__New(sender, event, eventInfo, errLevel)
        this._index := index
        ; Use null() as the gui content might be empty
        this._text := null()
    }

    ; Get the index of the option that is currently selected
    Index[]
    {
        Get
        {
            Return this._index
        }
    }

    ; Get the text of the option that is currently selected
    Text[]
    {
        Get
        {
            If (this._text == null())
            {
                this._text := this.Sender.GetText(this._index)
            }
            Return this._text
        }
    }

    ToString()
    {
        Return base.ToString() ", Index: " this.Index ", Text: " this.Text
    }
}

class GuiBase_ComboBoxBaseEventArgs extends GuiBase_ChoiseEventArgs
{
}

class GuiBase_TabEventArgs extends GuiBase_ChoiseEventArgs
{
}

class GuiBase_CheckBoxEventArgs extends GuiBase_EventArgs
{
    __New(sender, event, eventInfo, errLevel)
    {
        base.__New(sender, event, eventInfo, errLevel)
        ; Use null() as the gui value might be empty
        this._checked := null()
    }

    IsChecked[]
    {
        Get
        {
            If (this._checked == null())
            {
                this._checked := this.Sender.IsChecked
            }
            Return this._checked
        }
    }

    ToString()
    {
        Return base.ToString() ", IsChecked: " this.IsChecked
    }
}

class GuiBase_HotkeyEventArgs extends GuiBase_EventArgs
{
    __New(sender, event, eventInfo, errLevel)
    {
        base.__New(sender, event, eventInfo, errLevel)
        this._comboString := null()
        this._combo := null()
    }

    ; Get an object with the keys "key", "shift", "ctrl", "alt"
    KeyCombo[]
    {
        Get
        {
            If (this._combo == null())
            {
                this._combo := this.Sender.KeyCombo
            }
            Return this._combo
        }
    }

    ; The combo as AutoHotkey hotkey string
    KeyComboString[]
    {
        Get
        {
            If (this._comboString == null())
            {
                this._comboString := this.Sender.KeyComboString
            }
            Return this._comboString
        }
    }

    ToString()
    {
        Return base.ToString() " Key combo: " this.KeyComboString
    }
}

class GuiBase_ListViewEventArgs extends GuiBase_EventArgs
{
    __New(sender, event, eventInfo, errLevel)
    {
        base.__New(sender, event, eventInfo, errLevel)
        this._row := null()
    }

    ; Get the current row as ListViewRow object
    Row[]
    {
        Get
        {
            If (this._row == null())
            {
                this._row := new GuiBase_ListViewControl.ListViewRow(this.Sender, this.EventInfo, this.Sender.ColumnCount)
            }
            Return this._row
        }
    }

    ToString()
    {
        Return base.ToString() ", Row: [" this.Row.RowNumber ", " this.Row.At(1).Text "]"
    }
}

class GuiBase_ListViewColumnEventArgs extends GuiBase_EventArgs
{
    __New(sender, event, eventInfo, errLevel)
    {
        base.__New(sender, event, eventInfo, errLevel)
        this._column := eventInfo
    }

    ; Get the index of the column
    Column[]
    {
        Get
        {
            Return this._column
        }
    }

    ToString()
    {
        Return base.ToString() ", Column: " this.Column
    }
}

class GuiBase_LinkEventArgs extends GuiBase_EventArgs
{
    ; Get the index of the link that was clicked
    LinkIndex[]
    {
        Get
        {
            Return this.EventInfo
        }
    }

    ; Returns the href or the id of the link that was clicked
    HrefOrID[]
    {
        Get
        {
            Return this.ErrLevel
        }
    }

    ToString()
    {
        Return base.ToString() ", LinkIndex: " this.LinkIndex ", HrefOrId: """ this.HrefOrId """"
    }
}

; Used when a key gets pressed while the control has the keyboard focus
class GuiBase_KeyReceivedEventArgs extends GuiBase_EventArgs
{
    ; The key as string that was pressed
    Key[]
    {
        Get
        {
            Return GetKeyName("vk" this.EventInfo.Format("{:x}"))
        }
    }

    ScanCode[]
    {
        Get
        {
            Return this.EventInfo
        }
    }

    ToString()
    {
        Return base.ToString() ", Key: " this.Key ", ScanCode: " this.ScanCode
    }
}