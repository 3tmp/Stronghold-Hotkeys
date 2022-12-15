class _onExitLogger
{
    __New()
    {
        this._logLevel := _logLevel.Info
        this._onErrorListener := new OnExitListener(OBM(this, "_logAhkExits"))
    }

    ; Logs the message
    _logAhkExits(exitReason, exitCode)
    {
        If (this._logLevel < LoggerFactory._minLogLevel)
        {
            Return
        }

        logMessage := this._formatLogMessage(exitReason, exitCode)
        LoggerFactory._log(logMessage)
        LoggerFactory._sync()
    }

    ; Formats the log message according to this._format
    ; Supported params are "%date", "%level", "%s"
    ; exitReason: The reason as string
    ; exitCode: The code as integer
    ; Returns a string representation of the exit
    _formatLogMessage(ByRef exitReason, exitCode)
    {
        result := LoggerFactory._format

        message := "Reason: " exitReason ", Code: " exitCode

        ; Replace the string options
        result := result.Replace("%date", FormatTime(A_Now, "yyyy-MM-dd HH:mm:ss"))
        result := result.Replace("%clsOrFn", "")
        ; A double space will occur in this special case, remove it
        result := result.Replace("  ", " ")
        result := result.Replace("%level", _logLevel.GetName(this._logLevel).ToUpper())
        result := result.Replace("%s", "Script is shutting down. " message)
        Return result
    }
}