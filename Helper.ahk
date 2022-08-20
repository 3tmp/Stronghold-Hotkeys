; Returns the index of the item in the list on success, 0 on failure
IndexOf(item, list)
{
    For each, value in list
    {
        If (value = item)
        {
            Return A_Index
        }
    }
    Return 0
}

ValueIn(value, values*)
{
    Return !!IndexOf(value, values)
}

; A wrapper of the GuiControl command
GuiControl(hwnd, command := "", options := "")
{
    GuiControl, % command, % hwnd, % options
}

; A wrapper of the GuiControlGet command
GuiControlGet(hwnd, command := "", options := "")
{
    GuiControlGet, value, % command, % hwnd, % options
    Return value
}

; As AutoHotkey guis work with pipe delimitered lists instead of arrays, this converts an array into a string
ListToString(list, delimiter := "|")
{
    result := ""
    For each, item in list
    {
        result .= (A_Index == 1 ? "" : delimiter) item
    }
    Return result
}
