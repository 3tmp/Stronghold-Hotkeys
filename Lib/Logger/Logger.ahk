class _defaultLogger
{
    ; clsOrFn: The class or the function as string that owns the logger
    __New(clsOrFn)
    {
        this._clsOrFn := clsOrFn
    }

    ; Immediately writes the buffer to the appenders to directly print it
    Sync()
    {
        this.LoggerFactory._sync()
    }

    Trace(message, vars*)
    {
        this._log(_logLevel.Trace, message, vars)
    }

    Debug(message, vars*)
    {
        this._log(_logLevel.Debug, message, vars)
    }

    Info(message, vars*)
    {
        this._log(_logLevel.Info, message, vars)
    }

    Warn(message, vars*)
    {
        this._log(_logLevel.Warn, message, vars)
    }

    Error(message, vars*)
    {
        this._log(_logLevel.Error, message, vars)
    }

    ; Logs the message
    _log(level, ByRef message, vars)
    {
        ; Only log messages bigger or equal to the min log level
        If (level < LoggerFactory._minLogLevel)
        {
            Return
        }

        logMessage := this._formatLogMessage(level, message, vars)

        LoggerFactory._log(logMessage, level)
    }

    ; Formats the log message according to LoggerFactory._format
    ; Supported params are "%date", "%level", "%clsOrFn", "%s"
    ; Any number of "{}" may be specified in the message. They will be replaced by with the vars
    ; level: The log level of the message
    ; message: The message to log. May contain "{}"
    ; vars: Variadic. Any data type. Values get directly inserted, generic objects get serialized and inserted.
    ;                 These get inserted into the message where a "{}" is
    _formatLogMessage(level, ByRef message, vars)
    {
        result := LoggerFactory._format

        ; Any vars/objects can be inserted if the message contains "{}"
        varsAsStrings := []
        ; Insert the vars (variadic param arrays do not have the ArrayList base)
        If (vars.MaxIndex() > 0)
        {
            For each, var in vars
            {
                If (IsObject(var))
                {
                    If (TypeOf(var["ToString"], "Func"))
                    {
                        varsAsStrings.Add(var.ToString())
                    }
                    Else
                    {
                        varsAsStrings.Add(_objectToString(var))
                    }
                }
                Else
                {
                    varsAsStrings.Add(var)
                }
            }

            message := Format(message, varsAsStrings*)
        }

        ; Replace the string options
        result := result.Replace("%date", FormatTime(A_Now, "yyyy-MM-dd HH:mm:ss"))
        result := result.Replace("%level", _logLevel.GetName(level).ToUpper())
        result := result.Replace("%clsOrFn", "In: """ this._clsOrFn """")
        result := result.Replace("%s", message)
        Return result
    }
}