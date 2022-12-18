class _fileAppender
{
    __New(name)
    {
        this._fileName := name
    }

    ; Appends the list of objects with the keys "msg" and "level" to the file
    Append(list)
    {
        this._appendBatch(list)
    }

    ; Appends the message to the file
    _append(ByRef message)
    {
        FileAppend(message "`n", this._fileName)
    }

    ; Concatenates any number of messages into a single string for faster processing
    _appendBatch(list)
    {
        result := ""
        For each, message in list
        {
            If (A_Index != 1)
            {
                result .= "`n"
            }
            result .= message.msg
        }
        this._append(result)
    }
}