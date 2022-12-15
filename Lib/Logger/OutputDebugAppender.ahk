class _outputDebugAppender
{
    ; Appends the given string or list of strings to the stdout stream
    Append(ByRef msgOrMsgList)
    {
        If (IsObject(msgOrMsgList))
        {
            this._appendBatch(msgOrMsgList)
        }
        Else
        {
            this._append(msgOrMsgList)
        }
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
            result .= message
        }
        this._append(result)
    }
}