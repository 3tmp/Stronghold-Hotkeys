class _onErrorLogger
{
    __New()
    {
        this._level := _logLevel.GetName(_logLevel.Error).ToUpper()
        this._onErrorListener := new OnErrorListener(OBM(this, "_logAhkErrors"))
    }

    ; Logs the message
    _logAhkErrors(ex)
    {
        logMessage := this._formatLogMessage(ex)
        LoggerFactory._log(logMessage, _logLevel.Error)
        LoggerFactory._sync()
    }

    ; Formats the log message according to this._format
    ; Supported params are "%date", "%level", "%s"
    ; ex: A builtin ahk exception object or an instance of the Exception class
    ; Returns a string representation of the error
    _formatLogMessage(ex)
    {
        result := LoggerFactory._format

        message := InstanceOf(ex, Exception)
                 ? ex.ToString()
                 : ("Message: " ex.Message.Replace("`n", "\n")
                  . ", What: "  ex.What.Replace("`n", "\n")
                  . ", Extra: " ex.Extra.Replace("`n", "\n")
                  . ", File: "  """" ex.File """"
                  . ", Line: "  ex.Line)

        ; Replace the string options
        result := result.Replace("%date", FormatTime(A_Now, "yyyy-MM-dd HH:mm:ss"))
        result := result.Replace("%clsOrFn", "")
        ; A double space will occur in this special case, remove it
        result := result.Replace("  ", " ")
        result := result.Replace("%level", this._level)
        result := result.Replace("%s", "Unhandled error (App version: " Stronghold_Version() "): " message)
        Return result
    }
}