class _outputDebugAppender
{
                     ; White
    static _colors := {_logLevel.Trace: Chr(27) "[37m"
                     ; Blue
                     , _logLevel.Debug: Chr(27) "[34m"
                     ; Green
                     , _logLevel.Info: Chr(27) "[32m"
                     ; Yellow
                     , _logLevel.Warn: Chr(27) "[33m"
                     ; Red
                     , _logLevel.Error: Chr(27) "[31m"}
           ; Default console settings
           _reset := Chr(27) "[0m"

    ; Appends the list of objects with the keys "msg" and "level" to the stdout stream
    Append(list)
    {
        this._appendBatch(list)
    }

    _append(ByRef message)
    {
        OutputDebug(message)
    }

    _appendBatch(messageList)
    {
        result := ""
        For each, message in messageList
        {
            If (A_Index != 1)
            {
                result .= "`n"
            }
            result .= _outputDebugAppender._colors[message.level] message.msg
        }
        result .= _outputDebugAppender._reset
        this._append(result)
    }
}