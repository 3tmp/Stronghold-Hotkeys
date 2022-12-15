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

; Returns a string in the format "en-US"
; lcid: The language identifier to convert
; Returns the name of the lcid as string
WinApi_LCIDToLocaleName(lcid)
{
    static LOCALE_NAME_MAX_LENGTH := 85

    VarSetCapacity(lang, LOCALE_NAME_MAX_LENGTH * 2)
    ; A_Language returns only the hex code without the leading "0x", make sure to cover this case
    If (!DllCall("Kernel32.dll\LCIDToLocaleName", "UInt", InStr(lcid, "0x") ? lcid : "0x" lcid, "Str", lang, "UInt", LOCALE_NAME_MAX_LENGTH, "UInt", 0))
    {
        throw Exception("LCID value was not correct")
    }
    Return lang
}