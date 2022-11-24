; Determines if the script is currently being debugged
; Returns true if the script is being debugged, false otherwise
IsDebuggerAttatched()
{
    Return !!WinApi_GetCommandLine().ToLower().Contains("/debug", 1)
}