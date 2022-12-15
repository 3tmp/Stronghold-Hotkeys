class _fileAppender
{
    __New(name)
    {
        this._fileName := name
    }

    ; Appends the given string or list of strings to the file
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

    ; Appends the message to the file
    _append(ByRef message)
    {
        FileAppend(message "`n", this._fileName)
    }

    ; Concatenates any number of messages into a single string for faster processing
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