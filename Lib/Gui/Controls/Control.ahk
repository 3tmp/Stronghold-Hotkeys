class GuiBase_BaseControl
{
    ; Returns the type of the control (Button, Text, Edit, etc.)
    Type[]
    {
        Get
        {
            Return this._type
        }
    }

    __New(gui, options := "", text := "")
    {
        this._gui := gui

        Gui, % this._gui.Hwnd ":Add", % this.Type, % "hwndhwnd " options, % text
        this._hwnd := hwnd

        ; Stores all event handler, any deriving control may add custom handlers, "default" is reserved
        this._eventHandler := {}
        ; Gets called by any gLabel notification
        this._handlerFunc := OBM(this, "_event")
        ; Set to true as soon as any callbacks get registered for the gLabel
        this._hasGLabel := false
    }

    ; Override this method if a control has some cleanup to do
    ; So that the destructor can be called properly
    ; The deriving method must always call base.Destroy() internally
    Destroy()
    {
        this._gui := ""
        this._handlerFunc := ""
        ; Release all event handlers
        For each, handler in this._eventHandler
        {
            handler.RemoveAll()
        }
        this._eventHandler := ""
    }

    ; Returns the parent gui window
    Gui[]
    {
        Get
        {
            Return this._gui
        }
    }

    ; Get the hwnd of the control
    Hwnd[]
    {
        Get
        {
            Return this._hwnd
        }
    }

    ; The position of the control relative to the upper left corner of the window
    Pos[]
    {
        Get
        {
            GuiControlGet, pos, Pos, % this._hwnd
            Return {"x": posX, "y": posY, "w": posW, "h": posH}
        }

        Set
        {
            pos := (value.x != "" ? "x" value.x : "") (value.y != "" ? " y" value.y : "")
                 . (value.h != "" ? " h" value.h : "") (value.w != "" ? " w" value.w : "")
            GuiControl, MoveDraw, % this._hwnd, % pos
        }
    }

    ; Edit the controls options
    Options(options)
    {
        GuiControl, % options, % this._hwnd
    }

    ; Set Properties of the control that are set by the "GuiControl" command
    GuiControl(command := "", options := "")
    {
        GuiControl, % command, % this._hwnd, % options
    }

    ; Get Properties of the control that are retrieved by the "GuiControlGet" command
    GuiControlGet(command := "", options := "")
    {
        GuiControlGet, value, % command, this._hwnd, % options
        Return value
    }

    Enable()
    {
        GuiControl, Enable, % this._hwnd
    }

    Disable()
    {
        GuiControl, Disable, % this._hwnd
    }

    Show()
    {
        GuiControl, Show, % this._hwnd
    }

    Hide()
    {
        GuiControl, Hide, % this._hwnd
    }

    ToString()
    {
        Return this._getClassNN()
    }

    ; Edit the "gLabel" of the control
    ; fn: The callback function to call
    ; add: Optional. Set to true to add this listener, false to remove it
    OnEvent(fn, add := true)
    {
        this._registerEvent(fn, "default", add)
        Return this
    }

    ; Registers or unregisters a callback func.
    ; Adding: If it is the first handler, a gLabel gets added to the control
    ; Removing: If it is the last handler, the gLabel gets removed from the control
    ; fn: The callback to (un-)register
    ; handlerName: The name of the handler to operate on (the default handler is "default")
    ; add: true to add the handler, false to remove it
    _registerEvent(fn, handlerName, add)
    {
        ; Get the event handler for the given name
        handler := this._eventHandler[handlerName]
        If (!handler)
        {
            this._eventHandler[handlerName] := new GuiBase_ControlEventHandler()
            handler := this._eventHandler[handlerName]
        }

        ; Add/remove the listener
        If (add)
        {
            handler.AddListener(fn)

            ; Check if a gLabel should be registered
            If (!this._hasGLabel)
            {
                this.GuiControl("+g", this._handlerFunc)
                this._hasGLabel := true
            }
        }
        Else
        {
            handler.RemoveListener(fn)
            ; Check if this handler can be removed
            If (!handler.HasListeners())
            {
                ; Remove the eventhandler
                this._eventHandler.Delete(handlerName)
                handler := ""
            }

            ; Check if the gLabel can be unregistered
            canUnregister := true
            For each, handler in this._eventHandler
            {
                If (IsObject(handler))
                {
                    canUnregister := false
                    Break
                }
            }
            If (canUnregister)
            {
                this._hasGLabel := false
                this.GuiControl("-g")
            }
        }
    }

    ; This gets called when the g label of a control gets launched
    ; May be overwritten by deriving controls to set up custom event handlers
    _event(hwnd, event, info, errLevel := "")
    {
        this._fireDefaultEvent(new GuiBase_EventArgs(this, event, info, errLevel))
    }

    ; A shorthand for fireing the default event
    _fireDefaultEvent(eventArgs)
    {
        this._eventHandler.default.Fire(eventArgs)
    }

    ; A shorthand for fireing any named event
    _fireCustomEvent(eventArgs, handlerName)
    {
        this._eventHandler[handlerName].Fire(eventArgs)
    }

    ; Returns the classNN of the control
    _getClassNN()
    {
        hwnds := WinGetControlListHwnd("ahk_id" this._gui.Hwnd)
        names := WinGetControlList("ahk_id" this._gui.Hwnd)

        For each, hwnd in hwnds
        {
            If (hwnd == this._hwnd)
            {
                Return names[A_Index]
            }
        }
    }

    _getNN()
    {
        Return this._getClassNN().Replace(WinGetClass("ahk_id" this._hwnd))
    }
}