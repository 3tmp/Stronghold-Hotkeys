; Returns the full command line string that was used to start the script
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

; Returns true if the given window is enabled
; hwnd: A handle to the window
; Returns true if the window is enabled, false otherwise
WinApi_IsWindowEnabled(hwnd)
{
    Return DllCall("User32.dll\IsWindowEnabled", "Ptr", hwnd)
}