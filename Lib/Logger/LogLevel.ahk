class _logLevel extends _Enum
{
    static Trace := 1
         , Debug := 2
         , Info  := 3
         , Warn  := 4
         , Error := 5

    ; Returns the name of the enum value
    GetName(level)
    {
        Return level == 1 ? "Trace"
             : level == 2 ? "Debug"
             : level == 3 ? "Info"
             : level == 4 ? "Warn"
             :              "Error"
    }

    ; Returns an object with all valid log levels
    GetLevels()
    {
        Return {"Trace": _logLevel.Trace, "Debug": _logLevel.Debug, "Info": _logLevel.Info, "Warn": _logLevel.Warn, "Error": _logLevel.Error}
    }
}