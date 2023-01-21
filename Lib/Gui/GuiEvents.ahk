GuiBase_OnClose(guiHwnd)
{
    local gui
    If (gui := GuiBase.Static_GetGui(guiHwnd))
    {
        Return gui.OnClose()
    }
}

GuiBase_OnEscape(guiHwnd)
{
    local gui
    If (gui := GuiBase.Static_GetGui(guiHwnd))
    {
        Return gui.OnEscape()
    }
}

GuiBase_OnSize(guiHwnd, eventInfo, width, height)
{
    local gui
    If (gui := GuiBase.Static_GetGui(guiHwnd))
    {
        Return gui.OnSize(eventInfo, width, height)
    }
}

GuiBase_OnContextMenu(guiHwnd, ctrlHwnd, eventInfo, isRightClick, x, y)
{
    local gui
    If (gui := GuiBase.Static_GetGui(guiHwnd))
    {
        Return gui.OnContextMenu(gui.GetControl(ctrlHwnd), eventInfo, isRightClick, x, y)
    }
}