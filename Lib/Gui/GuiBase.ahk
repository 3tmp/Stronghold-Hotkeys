class GuiBase
{
    ; List of all GuiBase instances that are currently existing
    static _instances := {}

    ; Creates a new Gui window
    ; title: The title of the window
    ; options: The normal gui options (as string)
    __New(title := "", options := "")
    {
        ; A list of all controls of this instance
        this._controls := {}

        title := title != "" ? title : A_ScriptName

        ; Create a new gui window
        Gui, New, % "+hwndhwnd +labelGuiBase_On " options, % title
        this._hwnd := hwnd

        ; Make sure that the integer format is decimal
        GuiBase._instances[this._hwnd + 0] := this

        ; Build the custom gui
        this.BuildGui()
    }

    __Delete()
    {
        this.Destroy()
    }

    ; Override this method in any deriving class. It gets called when the gui gets initialized
    BuildGui()
    {
        throw Exception("Cannot create an instance of the GuiBase")
    }

    ; Destroy the window and all controls
    Destroy()
    {
        ; Ignore errors if the gui is already destroyed
        try Gui, % this._hwnd ":Destroy"

        ; Break all circular dependencies
        For hwnd, control in this._controls
        {
            control.Destroy()
        }

        this._controls := ""
        GuiBase._instances.Delete(this._hwnd + 0)
    }

    ; Show the window
    Show(options := "", title := "")
    {
        If (title != "")
        {
            Gui, % this._hwnd ":Show", % options, % title
        }
        Gui, % this._hwnd ":Show", % options
    }

    ; Hide the window
    Hide()
    {
        Gui, % this._hwnd ":Hide"
    }

    Enable()
    {
        Gui, % this._hwnd ":-Disabled"
    }

    Disable()
    {
        Gui, % this._hwnd ":+Disabled"
    }

    ; Closes the window (hides the window, but does not destroy it)
    Close()
    {
        this.Hide()
        this.OnClose()
    }

    ; Edit the guis options
    Options(Options)
    {
        Gui, % this._hwnd ":" Options
    }

    ; Returns the control with the specified hwnd
    GetControl(hwnd)
    {
        ; Make sure that the hwnd is in decimal format
        Return this._controls[hwnd + 0]
    }

    ; Make the gui the default gui
    SetDefault()
    {
        If (A_DefaultGui != this._hwnd)
        {
            Gui, % this._hwnd ":Default"
        }
    }

    ; Set the guis default ListView
    SetDefaultListView(listView)
    {
        If (A_DefaultListView != listView.Hwnd)
        {
            Gui, % this._hwnd ":ListView", % listView.Hwnd
        }
    }

    ; Sets the guis default TreeView
    SetDefaultTreeView(treeView)
    {
        If (A_DefaultTreeView != treeView.Hwnd)
        {
            Gui, % this._hwnd ":TreeView", % treeView.Hwnd
        }
    }

    ; Set the guis default Tab control. Call with no param and the next controls will be outside of any tab control
    SetDefaultTab(tab := "")
    {
        Gui, % this._hwnd ":Tab", % tab == "" ? "" : 1, % tab == "" ? "" : tab.TabNumber
    }

    ; Specify on with page the next controls will be added. Call with no param and the next controls will be outside of any tab control
    SetTab(page := "", tabNumber := "")
    {
        Gui, % this._hwnd ":Tab", % page, % tabNumber
    }

    ; Activate the gui and make it the topmost window
    Focus()
    {
        dhw := DetectHiddenWindows("On")
        WinActivate("ahk_id" this._hwnd)
        DetectHiddenWindows(dhw)
    }

    ; Add Controls

    ; Adds a Button control
    AddButton(options := "", text := "")
    {
        Return this._addControl(GuiBase_ButtonControl, options, text)
    }

    ; Adds a Checkbox control
    AddCheckbox(options := "", text := "")
    {
        Return this._addControl(GuiBase_CheckboxControl, options, text)
    }

    ; Adds a DropDownList control
    AddDropDownList(options := "", values := "")
    {
        Return this._addControl(GuiBase_DropDownListControl, options, this._uniformGuiAddParam(values))
    }

    ; Adds a Hotkey control
    AddHotkey(options := "", keyCombo := "")
    {
        Return this._addControl(GuiBase_HotkeyControl, options, keyCombo)
    }

    ; Adds a Link control
    AddLink(options := "", link := "")
    {
        Return this._addControl(GuiBase_LinkControl, options, link)
    }

    ; Adds a ListView Control
    AddListView(options := "", headers := "")
    {
        Return this._addControl(GuiBase_ListViewControl, options, this._uniformGuiAddParam(headers))
    }

    ; Adds a Tab control
    AddTab(options := "", headers := "")
    {
        Return this._addControl(GuiBase_TabControl, Options, this._uniformGuiAddParam(headers))
    }

    ; Adds a Text control
    AddText(options := "", text := "")
    {
        Return this._addControl(GuiBase_TextControl, options, text)
    }

    ; Handles the adding of new control
    _addControl(__controlClass, options, text)
    {
        local
        ctrl := new __controlClass(this, options, text)
        Return this._controls[ctrl.Hwnd + 0] := ctrl
    }

    ; ========== Properties ==========

    ; Get the guis hwnd
    Hwnd[]
    {
        Get
        {
            Return this._hwnd
        }
    }

    ; The position of the window
    Pos[]
    {
        Get
        {
            dhw := DetectHiddenWindows("On")
            pos := WinGetPos("ahk_id" this._hwnd)
            DetectHiddenWindows(dhw)
            Return pos
        }

        Set
        {
            dhw := DetectHiddenWindows("On")
            WinMove("ahk_id" this._hwnd, "", value.x, value.y, value.w, value.h)
            DetectHiddenWindows(dhw)
        }
    }

    ; ========== Gui Events ==========
    ; Override in deriving classes to get access to the gui events

    OnClose()
    {
        this.Close()
    }

    OnEscape()
    {
    }

    OnSize(eventInfo, width, height)
    {
    }

    OnContextMenu(control, eventInfo, isRightClick, x, y)
    {
    }

    ; ========== Static methods ==========

    ; Returns the correct gui instance depending on the passed hwnd
    Static_GetGui(hwnd)
    {
        Return GuiBase._instances[hwnd + 0]
    }

    ; Searches all guis for the hwnd and returns the control object if found
    Static_GetControl(hwnd)
    {
        local
        For each, gui in GuiBase._instances
        {
            If (ctrl := gui.GetControl(hwnd))
            {
                Return ctrl
            }
        }
        Return ""
    }

    ; ========== Private helper ==========

    ; Takes in the Text parameter from the Gui Add command and transforms a list into a pipe delimitered string
    _uniformGuiAddParam(ByRef strOrObj)
    {
        If (IsObject(strOrObj))
        {
            For each, value in strOrObj
            {
                valueText .= (A_Index == 1 ? "" : "|") value
            }
            Return valueText
        }
        Return strOrObj
    }
}