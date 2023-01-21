class GuiBase_ListViewControl extends GuiBase_BaseControl
{
    static _type := "ListView"

    __New(gui, options := "", text := "")
    {
        ; Always add the altsubmit option to capture all events
        If (!options.Contains("AltSubmit"))
        {
            options .= " AltSubmit "
        }

        base.__New(gui, options, text)
    }

    ; Returns the number of all rows
    RowCount[]
    {
        Get
        {
            this.SetDefault()
            Return LV_GetCount()
        }
    }

    ; Returns the number of all columns
    ColumnCount[]
    {
        Get
        {
            this.SetDefault()
            Return LV_GetCount("Column")
        }
    }

    ; Returns the number of all selected rows
    SelectedCount[]
    {
        Get
        {
            this.SetDefault()
            Return LV_GetCount("Selected")
        }
    }

    ; Returns the number of all checked rows
    CheckedCount[]
    {
        Get
        {
            this.SetDefault()
            Return LV_GetCount("Checked")
        }
    }

    ; Returns the one-based index of the selected column
    SelectedColumn()
    {
        ; 0x10AE is LVM_GETSELECTEDCOLUMN
        SendMessage, 0x10AE, 0, 0,, % "ahk_id" this._hwnd
        Return ErrorLevel == "FAIL" ? "" : ErrorLevel + 1
    }

    ; A wrapper for LV_Add. Adds new rows
    ; Returns the row number on success, 0 on failure
    Add(options := "", fields*)
    {
        this.SetDefault()
        Return LV_Add(options, fields*)
    }

    ; A wrapper for LV_Insert. Inserts a new row at the given row number
    ; Returns the row number on success, 0 on failure
    Insert(row, options := "", col*)
    {
        this.SetDefault()
        Return LV_Insert(row, options, col*)
    }

    ; A wrapper for LV_Delete. Deletes all values if no param is specified, otherwise deletes the given row
    ; Row must be an integer
    Delete(row := "")
    {
        this.SetDefault()
        If (row != "")
        {
            Return LV_Delete(row)
        }
        Return LV_Delete()
    }

    ; Returns the requested row as a ListViewRow object or "" if invalid row
    GetRow(row)
    {
        If (row < 1 || row > this.RowCount)
        {
            Return ""
        }
        Return new GuiBase_ListViewControl.ListViewRow(this, row, this.ColumnCount)
    }

    ; Returns an array that contains all selected rows as ListViewRows
    GetSelected()
    {
        ; There is no need to call SetDefault, because ColumnCount internally calls it
        ; this.SetDefault()
        result := []
        columns := this.ColumnCount
        ; _getRows returns an array containing all row numers that are selected
        For each, row in this._getRows()
        {
            result.Push(new GuiBase_ListViewControl.ListViewRow(this, row, columns))
        }
        Return result
    }

    ; Returns an array that contains all checked rows as ListViewRows
    GetChecked()
    {
        ; There is no need to call SetDefault, because ColumnCount internally calls it
        ; this.SetDefault()
        result := []
        columns := this.ColumnCount
        ; _getRows returns an array containing all row numers that are checked
        For each, row in this._getRows("Checked")
        {
            result.Push(new GuiBase_ListViewControl.ListViewRow(this, row, columns))
        }
        Return result
    }

    ; Returns an array that contains all focused rows as ListViewRows
    ; (max one row can be focused -> the array has length 1 (one row focued) or 0 (no row focused))
    GetFocused()
    {
        ; There is no need to call SetDefault, because ColumnCount internally calls it
        ; this.SetDefault()
        result := []
        columns := this.ColumnCount
        ; _getRows returns an array containing all row numers that are focused
        For each, row in this._getRows("Focused")
        {
            result.Push(new GuiBase_ListViewControl.ListViewRow(this, row, columns))
        }
        Return result
    }

    ; Returns the number of the next selected row
    GetNextSelected(start := 0)
    {
        this.SetDefault()
        Return this._getNext(start)
    }

    ; Returns the number of the next checked row
    GetNextChecked(start := 0)
    {
        this.SetDefault()
        Return this._getNext(start, "Checked")
    }

    ; Returns the number of the next focused row
    GetNextFocused(start := 0)
    {
        this.SetDefault()
        Return this._getNext(start, "Focused")
    }

    ; A wrapper for LV_GetText. Returns the text of the given row and column
    GetText(row, column := 1)
    {
        this.SetDefault()
        LV_GetText(text, row, column)
        Return text
    }

    ; A wrapper for LV_Modify. Modifies the attributes and/or the text of a row
    Modify(row, options := "", newCol*)
    {
        this.SetDefault()
        Return LV_Modify(row, options, newCol*)
    }

    ; A wrapper for LV_ModifyCol. Make changes to the columns and their headers
    ModifyCol(column := "", options := "", title := "")
    {
        this.SetDefault()
        If (title != "")
        {
            Return LV_ModifyCol(column, options, title)
        }
        Return LV_ModifyCol(column, options)
    }

    ; A wrapper for LV_InsertCol. Inserts a new column at the given index
    InsertCol(column, options := "", title := "")
    {
        this.SetDefault()
        If (title != "")
        {
            Return LV_InsertCol(column, options, title)
        }
        Return LV_InsertCol(column, options)
    }

    ; A wrapper for LV_DeleteCol. Deletes the column at the specified index
    DeleteCol(column)
    {
        this.SetDefault()
        Return LV_DeleteCol(column)
    }

    ; Change the ListViews redraw behaviour
    Redraw(onOff)
    {
        this.SetDefault()
        base.Redraw(onOff)
    }

    ; Make this the scripts default ListView
    SetDefault()
    {
        this._gui.SetDefault()
        this._gui.SetDefaultListView(this)
    }

    ; Selects the row at the given index
    ; Toggle: If true, the row gets selected, false to deselect
    ; Focus: If true the row also gets focused
    SelectRow(row, select := true, focus := false)
    {
        If (focus)
        {
            this.Modify(row, (select ? "+" : "-") "Focus")
        }
        Return this.Modify(row, (select ? "+" : "-") "Select")
    }

    ; Focuses the row at the given index
    FocusRow(row, focus)
    {
        Return this.Modify(row, (focus ? "+" : "-") "Focus")
    }

    ; Checks the row at the given index
    CheckRow(row, check)
    {
        Return this.Modify(row, (check ? "+" : "-") "Check")
    }

    ; For internal use only

    ; A wrapper for LV_GetNext. Returns the next item in the list
    _getNext(start := 0, option := "")
    {
        Return LV_GetNext(start, option)
    }

    ; Returns an array that contains the row numbers of all selected/checked/focused rows
    _getRows(option := "")
    {
        i := 0
        rows := []
        While (i := this._getNext(i, option))
        {
            rows.Push(i)
        }
        Return rows
    }

    ; Events

    ; ListViewEventArgs
    OnDoubleClick(fn, add := true)
    {
        this._registerEvent(fn, "DoubleClick", add)
        Return this
    }

    ; ListViewEventArgs
    OnDoubleRightClick(fn, add := true)
    {
        this._registerEvent(fn, "R", add)
        Return this
    }

    ; ListViewColumnEventArgs
    OnColumnClick(fn, add := true)
    {
        this._registerEvent(fn, "ColClick", add)
        Return this
    }

    ; ListViewEventArgs
    OnDraggingStart(fn, add := true)
    {
        this._registerEvent(fn, "u_D", add)
        Return this
    }

    ; ListViewEventArgs
    OnDraggingRightStart(fn, add := true)
    {
        this._registerEvent(fn, "l_d", add)
        Return this
    }

    ; ListViewEventArgs
    OnEditingEnd(fn, add := true)
    {
        this._registerEvent(fn, "l_e", add)
        Return this
    }

    ; ListViewEventArgs
    OnClick(fn, add := true)
    {
        this._registerEvent(fn, "Normal", add)
        Return this
    }

    ; ListViewEventArgs
    OnRightClick(fn, add := true)
    {
        this._registerEvent(fn, "RightClick", add)
        Return this
    }

    ; ListViewEventArgs
    OnRowActivated(fn, add := true)
    {
        this._registerEvent(fn, "A", add)
        Return this
    }

    ; EventArgs
    OnReleaseMouseCapture(fn, add := true)
    {
        this._registerEvent(fn, "C", add)
        Return this
    }

    ; ListViewEventArgs
    OnEditingStart(fn, add := true)
    {
        this._registerEvent(fn, "u_E", add)
        Return this
    }

    ; ListViewEventArgs
    OnFocus(fn, add := true)
    {
        this._registerEvent(fn, "u_F", add)
        Return this
    }

    ; ListViewEventArgs
    OnFocusLost(fn, add := true)
    {
        this._registerEvent(fn, "l_f", add)
        Return this
    }

    ; KeyReceivedEventArgs
    OnKeyPress(fn, add := true)
    {
        this._registerEvent(fn, "K", add)
        Return this
    }

    ; EventArgs
    OnMarquee(fn, add := true)
    {
        this._registerEvent(fn, "M", add)
        Return this
    }

    ; EventArgs
    OnScrollStart(fn, add := true)
    {
        this._registerEvent(fn, "u_S", add)
        Return this
    }

    ; EventArgs
    OnScrollEnd(fn, add := true)
    {
        this._registerEvent(fn, "l_s", add)
        Return this
    }

    ; ListViewEventArgs
    OnRowSelected(fn, add := true)
    {
        this._registerEvent(fn, "I_u_S", add)
        Return this
    }

    ; ListViewEventArgs
    OnRowDeselected(fn, add := true)
    {
        this._registerEvent(fn, "I_l_s", add)
        Return this
    }

    ; ListViewEventArgs
    OnRowFocused(fn, add := true)
    {
        this._registerEvent(fn, "I_u_F", add)
        Return this
    }

    ; ListViewEventArgs
    OnRowDefocused(fn, add := true)
    {
        this._registerEvent(fn, "I_l_f", add)
        Return this
    }

    ; ListViewEventArgs
    OnRowChecked(fn, add := true)
    {
        this._registerEvent(fn, "I_u_C", add)
        Return this
    }

    ; ListViewEventArgs
    OnRowUnchecked(fn, add := true)
    {
        this._registerEvent(fn, "I_l_c", add)
        Return this
    }

    ; A custom event handler
    _event(hwnd, event, info, errLevel := "")
    {
        ; Turn on critical for the event handling thread. This is recommended in the AutoHotkey docs
        ; See https://www.autohotkey.com/docs/commands/ListView.htm#G-Label_Notifications_Secondary (I option)
        Critical

        lowerEvent := event.ToLower()

        ; Item changed
        If (event == "I")
        {
            ; Any combination of select, focus and check may occur, fire all matching events
            eventArgs := new GuiBase_ListViewEventArgs(this, event, info, errLevel)

            ; (de-) select
            If (errLevel.Contains("S", true))
            {
                this._fireCustomEvent(eventArgs, "I_u_S")
            }
            Else If (errLevel.Contains("s", true))
            {
                this._fireCustomEvent(eventArgs, "I_l_s")
            }
            ; (de-) focus
            If (errLevel.Contains("F", true))
            {
                this._fireCustomEvent(eventArgs, "I_u_F")
            }
            Else If (errLevel.Contains("f", true))
            {
                this._fireCustomEvent(eventArgs, "I_l_f")
            }
            ; (un-) check
            If (errLevel.Contains("C", true))
            {
                this._fireCustomEvent(eventArgs, "I_u_C")
            }
            Else If (errLevel.Contains("c", true))
            {
                this._fireCustomEvent(eventArgs, "I_l_c")
            }
            Return
        }
        ; Scroll
        Else If (lowerEvent == "s")
        {
            eventArgs := new GuiBase_EventArgs(this, event, info, errLevel)
            this._fireCustomEvent(eventArgs, event == "S" ? "u_S" : "l_s")
            Return
        }
        ; Key press
        Else If (event == "K")
        {
            eventArgs := new GuiBase_KeyReceivedEventArgs(this, event, info, errLevel)
            this._fireCustomEvent(eventArgs, event)
            Return
        }
        ; Keyboard focus
        Else If (lowerEvent == "f")
        {
            eventArgs := new GuiBase_EventArgs(this, event, info, errLevel)
            this._fireCustomEvent(eventArgs, event == "F" ? "u_F" : "l_f")
            Return
        }
        ; Marquee
        Else If (event == "M")
        {
            eventArgs := new GuiBase_EventArgs(this, event, info, errLevel)
            this._fireCustomEvent(eventArgs, event)
            Return
        }
        ; Column click
        Else If (event == "ColClick")
        {
            eventArgs := new GuiBase_ListViewColumnEventArgs(this, event, info, errLevel)
            this._fireCustomEvent(eventArgs, event)
            Return
        }
        ; Release mouse capture
        Else If (event == "C")
        {
            eventArgs := new GuiBase_EventArgs(this, event, info, errLevel)
            this._fireCustomEvent(eventArgs, event)
            Return  
        }

        ; From here on the EventArgs are all ListViewEventArgs
        eventArgs := new GuiBase_ListViewEventArgs(this, event, info, errLevel)

        ; Drag
        If (lowerEvent == "d")
        {
            this._fireCustomEvent(eventArgs, event == "D" ? "u_D" : "l_d")
        }
        ; Editing
        Else If (lowerEvent == "e")
        {
            this._fireCustomEvent(eventArgs, event == "E" ? "u_E" : "l_e")
        }
        ; Any other event
        Else
        {
            this._fireCustomEvent(eventArgs, event)
        }
    }

    ; Enumerator

    ; Creates a new Enumerator
    ; The Enumerator allows write access, as long as the ListView doesn't get changed by any other function
    _NewEnum()
    {
        ; There is no need to call SetDefault, because RowCount internally calls it
        ; this.SetDefault()
        list := []
        rows := this.RowCount
        list.SetCapacity(rows)
        columns := this.ColumnCount
        Loop, % rows
        {
            list.Push(new GuiBase_ListViewControl.ListViewRow(this, A_Index, columns))
        }

        Return new DefaultIterator(list)
    }

    ; Represents one row of the ListView
    class ListViewRow extends _Object
    {
        ; lv: a reference to the ListView
        ; index: the row number
        ; columns: The number of columns that this has
        __New(lv, index, columns)
        {
            this._lv := lv
            this._index := index
            this._columns := columns
        }

        ; Get/Set the checked value (as long as checking was enabled in the ListView options)
        Checked[]
        {
            Get
            {
                SendMessage, 0x102C, this._index - 1, 0xF000,, % "ahk_id" this._lv.Hwnd
                Return (ErrorLevel >> 12) - 1
            }

            Set
            {
                this._lv.Modify(this._index, (value ? "+" : "-") "Check")
            }
        }

        ; Returns the amount of columns
        Columns[]
        {
            Get
            {
                Return this._columns
            }
        }

        ; Returns the row number of this row
        RowNumber[]
        {
            Get
            {
                Return this._index
            }
        }

        ; Returns the ListViewItem at the given index (=column)
        At(index)
        {
            Return index <= this._columns && index > 0 ? new GuiBase_ListViewControl.ListViewItem(this, index) : ""
        }

        ; Allows general modification of the row
        Modify(options)
        {
            Return this._lv.Modify(this._index, options)
        }

        ; Returns the text of one item in the row
        GetText(column)
        {
            Return this._lv.GetText(this._index, column)
        }

        ; Changes the text of one item in the row
        SetText(value, column)
        {
            Return this._lv.Modify(this._index, "Col" column, value)
        }

        ; Returns the prev row or "" if we reached the top row
        PrevRow()
        {
            Return this._index != 1 ? new GuiBase_ListViewControl.ListViewRow(this._lv, this._index - 1, this._columns) : ""
        }

        ; Returns the next row or "" if we reached the last row
        NextRow()
        {
            Return this._index < this._lv.RowCount ? new GuiBase_ListViewControl.ListViewRow(this._lv, this._index + 1, this._columns) : ""
        }

        ; (De-) Selects the current row
        Select(toggle := true, focus := false)
        {
            Return this._lv.SelectRow(this._index, toggle, focus)
        }

        ; (Un-) Checks the current row
        Check(toggle := true)
        {
            Return this._lv.CheckRow(this._index, toggle)
        }

        ; (De-) Focuses the current row
        Focus(toggle := true)
        {
            Return this._lv.FocusRow(this._index, toggle)
        }

        ; Deletes this row and invalidates this class.
        ; It also invalidates all other already evaluated ListViewRows
        ; only already existing ones, not new ones
        Delete()
        {
            Return this._lv.Delete(this._index)
        }

        ; Returns all values of this row as a linear array
        ToArray()
        {
            result := []
            Loop, % this._columns
            {
                result.Push(this.GetText(A_Index))
            }
            Return result
        }

        ; Returns an enumerator that returns all values in the correct order
        _NewEnum()
        {
            result := []
            Loop, % this._columns
            {
                result.Push(new GuiBase_ListViewControl.ListViewItem(this, A_Index))
            }
            Return new DefaultIterator(result)
        }
    }

    ; Represents one entry in the ListView
    class ListViewItem extends _Object
    {
        ; row: A reference to a ListViewRow object
        ; column: An integer value representing the column
        __New(row, column)
        {
            this._row := row
            this._column := column
        }

        ; Get/Set the cell text
        Text[]
        {
            Get
            {
                Return this._row.GetText(this._column)
            }

            Set
            {
                this._row.SetText(value, this._column)
            }
        }
    }
}