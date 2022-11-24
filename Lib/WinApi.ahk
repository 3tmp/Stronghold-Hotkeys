; Returns the full command line that was used to start the script
WinApi_GetCommandLine()
{
    Return DllCall("Kernel32.dll\GetCommandLine", "Str")
}

WinApi_LOWORD(l)
{
    Return l & 0xFFFF
}

WinApi_LOBYTE(w)
{
    Return w & 0xFF
}

WinApi_HIBYTE(w)
{
    Return (w >> 8) & 0xFF
}

; Enables or disables a window based on the state of "enable"
; @param hwnd A handle to the window
; @param enable Set to true to enable, false to disable
; @returns Nonzero on success, 0 on failure
WinApi_EnableWindow(hwnd, enable)
{
    Return DllCall("User32.dll\EnableWindow", "Ptr", hwnd, "Int", enable)
}

; Retrieves a handle to the top-level window whose class name and window name match the specified strings
; Does not search child windows
; @param className The name of the window class to find
; @param windowName Optional. The window title of the window to find
; @returns The hwnd of the found window, 0 if nothing found
WinApi_FindWindow(className, windowName := "")
{
    If (windowName == "")
    {
        Return DllCall("User32.dll\FindWindow", "Str", className, "Int", 0, "Ptr")
    }
    Else
    {
        Return DllCall("User32.dll\FindWindow", "Str", className, "Str", windowName, "Ptr")
    }
}

; Get the control that currently has the keyboard focus
; @returns The hwnd of the control that currently has the keybaord focus
WinApi_GetFocus()
{
    Return DllCall("User32.dll\GetFocus", "Ptr")
}

; Retrieves information about the specified window. Use this function to work with 64 and 32 bit applications
; @param hwnd A handle to the window
; @param nIndex The value to retrieve
;               see https://docs.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-getwindowlonga
; @returns The result of the specified value
WinApi_GetWindowLongPtr(hwnd, nIndex)
{
    ; On 64 bit call the GetWindowLongPtr function, on 32 bit call GetWindowLong
    If (A_PtrSize == 8)
    {
        Return DllCall("User32.dll\GetWindowLongPtr", "Ptr", hwnd, "Int", nIndex, "Ptr")
    }
    Else
    {
        Return DllCall("User32.dll\GetWindowLong", "Ptr", hwnd, "Int", nIndex)
    }
}

; Returns true if the given window is enabled
; @param hwnd A handle to the window
; @returns true if the window is enabled, false otherwise
WinApi_IsWindowEnabled(hwnd)
{
    Return DllCall("User32.dll\IsWindowEnabled", "Ptr", hwnd)
}

; Sets the keyboard focus to the given control
; @param hwnd A handle to the control
; @returns A handle to the previous focused window on success, 0 otherwise
WinApi_SetFocus(hwnd)
{
    Return DllCall("User32.dll\SetFocus", "Ptr", hwnd, "Ptr")
}