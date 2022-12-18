class LoggerFactory
{
    static _minLogLevel := _logLevel.Debug
         , _format := "%date %level %clsOrFn %s"

         , _appenders := [new _outputDebugAppender(), new _fileAppender("log.txt")]
         , _maxBufferSize := 10
         ; A list of objects with the keys "msg" and "level"
         , _buffer := []
         ; Add listeners for errors and exits to write to sync in those cases
         , _onErrorListener := new OnErrorListener(OBM(LoggerFactory, "_sync"))
         , _onExitListener := new OnExitListener(OBM(LoggerFactory, "_sync"))

    ; Creates a new logger that should be cached for the whole class
    GetLogger(clsOrFn)
    {
        clsOrFn := IsObject(clsOrFn) ? ClassName(clsOrFn) : clsOrFn
        Return new _defaultLogger(clsOrFn)
    }

    ; Creates a new logger that logs all uncaught errors in the script
    GetErrorLogger()
    {
        Return new _onErrorLogger()
    }

    ; Creates a new logger that logs all script exits
    GetExitLogger()
    {
        Return new _onExitLogger()
    }

    SetMinLogLevel(logLevel)
    {
        found := false
        For each, level in _logLevel.GetLevels()
        {
            If (level == logLevel)
            {
                found := true
                Break
            }
        }
        If (!found)
        {
            throw Exception("The given log level is invalid")
        }

        LoggerFactory._minLogLevel := logLevel
    }

    SetBufferSize(size)
    {
        ; Digit means only 0-9 allowed, so no sign
        If (!size.Is("Digit"))
        {
            throw Exception("The given parameter has the wrong type.")
        }
        LoggerFactory._maxBufferSize := size
    }

    _log(logMessage, level)
    {
        If (IsObject(logMessage))
        {
            throw Exception("The given parameter has the wrong type.")
        }
        LoggerFactory._buffer.Add({"msg": logMessage, "level": level})
        LoggerFactory._syncIfBufferFull()
    }

    ; Determines if the buffer is full and should be synced
    _isBufferFull()
    {
        Return LoggerFactory._buffer.Size() >= LoggerFactory._maxBufferSize
    }

    ; Checks if the buffer is ready to be synced and synces if needed
    _syncIfBufferFull()
    {
        If (!LoggerFactory._isBufferFull())
        {
            Return
        }

        LoggerFactory._sync()
    }

    ; Immediately syncs all changes
    _sync()
    {
        If (LoggerFactory._buffer.IsEmpty())
        {
            Return
        }

        For each, appender in LoggerFactory._appenders
        {
            appender.Append(LoggerFactory._buffer)
        }

        LoggerFactory._buffer.Clear()
    }
}