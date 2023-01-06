class _iniSection extends _Object
{
    __New(title, pairs)
    {
        If (!TypeOf(title, "String"))
        {
            throw Exception("The title must be a string")
        }
        If (!IsObject(pairs))
        {
            throw Exception("The pairs must be an object")
        }
        this._title := title
        this._pairs := pairs
    }

    ; A string
    Title[]
    {
        Get
        {
            Return this._title
        }
    }

    ; Key values pairs
    Pairs[]
    {
        Get
        {
            Return this._pairs
        }
    }

    ; Returns this as an ini string
    ToString()
    {
        result := "[" this._title "]`n"
        For key, value in this._pairs
        {
            result .= key "=" value "`n"
        }
        Return result
    }

    ; Static method that returns an _iniSection object
    ; Throws an error if the passes string is invalid
    Parse(str)
    {
        title := ""
        pairs := {}
        failsOccured := false

        lines := str.Split("`n", "`r")
        title := lines[1].StartsWith("[") && lines[1].EndsWith("]") ? lines[1].SubStr(2, lines[1].Length() - 2) : ""

        For each, line in lines
        {
            line := line.Trim()
            If (A_Index == 1 || line == "")
            {
                Continue
            }
            kvPair := line.Split("=")
            If (kvPair.Size() != 2 || kvPair[1] == "")
            {
                failsOccured := true
                Break
            }
            pairs[kvPair[1]] := kvPair[2]
        }

        If (title == "" || failsOccured)
        {
            throw Exception("Failed to parse ini string")
        }

        Return new _iniSection(title, pairs)
    }
}