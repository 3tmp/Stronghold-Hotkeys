; Adds support for "method" syntax for non object variables
; This has to be included at the very top of the script to support the method syntax everywhere!
VarFuncs_ScriptInit()
{
    ; Trigger this func by calling itself before the auto execute section
    static init := VarFuncs_ScriptInit()
    ; Prevent rerunning the function
    If (IsSet(init))
    {
        Return
    }

    ; Define methods
    "".base.At := Func("VarFuncs_At")
    "".base.Contains := Func("InStr")
    "".base.EndsWith := Func("VarFuncs_EndsWith")
    "".base.Equals := Func("VarFuncs_Equals")
    "".base.EqualsIgnoreCase := Func("VarFuncs_EqualsIgnoreCase")
    "".base.Format := Func("VarFuncs_Format")
    "".base.In := Func("VarFuncs_In")
    "".base.Is := Func("VarFuncs_Is")
    "".base.Length := Func("StrLen")
    "".base.LTrim := Func("LTrim")
    "".base.Match := Func("RegExMatch")
    "".base.RegExReplace := Func("RegExReplace")
    "".base.Replace := Func("StrReplace")
    "".base.RTrim := Func("RTrim")
    "".base.Split := Func("VarFuncs_StrSplit")
    "".base.StartsWith := Func("VarFuncs_StartsWith")
    "".base.SubStr := Func("SubStr")
    "".base.ToLower := Func("Format").Bind("{:L}")
    "".base.ToString := Func("VarFuncs_ToString")
    "".base.ToUpper := Func("Format").Bind("{:U}")
    "".base.Trim := Func("VarFuncs_Trim")

    ; This should be defined last, because otherwise the above lines also call the
    ; VarFuncs__Get function when they get initialized
    "".base.__Get := Func("VarFuncs__Get")

    Return 1
}


VarFuncs__Get(ByRef var, params*)
{
    throw Exception("Tried to get a non existent property on a var",, params[1])
}

; Returns the character at the given position
VarFuncs_At(ByRef var, ByRef at)
{
    Return SubStr(var, at, 1)
}

; Returns true if the string ends with the given string
; string: Checks if the var ends with this string
VarFuncs_EndsWith(ByRef var, ByRef string, caseSensitive := true)
{
    If (1 > start := StrLen(var) - StrLen(string) + 1)
    {
        Return false
    }

    Return caseSensitive ? SubStr(var, start) == string : SubStr(var, start) = string
}

; Returns true if the two given variables are the same
VarFuncs_Equals(ByRef var, ByRef compareVar)
{
    Return var == compareVar
}

; Retuns true if two given variables are the same when compared case insensitive
; compareMode: Can be "Off", "On" or "Locale"
VarFuncs_EqualsIgnoreCase(ByRef var, ByRef compareVar, ByRef compareMode := "Locale")
{
    scs := StringCaseSense(compareMode)
    , result := var = compareVar
    , StringCaseSense(scs)
    Return result
}

; Formats the value with the builtin Format function
; format: The formatting option for this one string. Only one value supported. See the ahk Format() function options
; Returns the formatted string
VarFuncs_Format(ByRef var, ByRef format)
{
    Return Format(format, var)
}

; Returns true if the value equals one of the given values. This func is case insensitive, it uses the "Locale" mode
; values: Variadic. Any number of variables to compare the var to
VarFuncs_In(ByRef var, values*)
{
    scs := StringCaseSense("Locale")
    , result := false
    For each, value in values
    {
        If (value = var)
        {
            result := true
            break
        }
    }
    StringCaseSense(scs)
    Return result
}

; A wrapper for the if var is command
; type: The type of data type to check. Allowed values:
;       "Integer", "Float", "Number", "Digit", "XDigit", "Alpha", "Upper", "Lower", "Alnum", "Space", "Time", "Date"
; Returns true if the var has the given data type, false otherwise
VarFuncs_Is(ByRef var, ByRef type)
{
    If var is %type%
    {
        Return true
    }
    Return false
}

; Returns true if the string starts with the given string
; string: Checks if the var starts with this string
VarFuncs_StartsWith(ByRef var, ByRef string, caseSensitive := true)
{
    Return caseSensitive ? SubStr(var, 1, StrLen(string)) == string : SubStr(var, 1, StrLen(string)) = string
}

; Splits the string and returns an array
; delimiter: Optional. If this gets omitted, the string gets split into each character
;                      Can be a single string or an array of strings that are used to split the var
; omitChars: Optional. If present, each char in the given string will be omitted in the result
; maxParts: Optional. Specifies the maximum number of substrings, -1 means "no limit"
VarFuncs_StrSplit(ByRef var, ByRef delimiters := "", ByRef omitChars := "", ByRef maxParts := -1)
{
    ; StrSplit does not use the Array() method to generate a new one,
    ; therefore the base has to be set manually
    result := StrSplit(var, delimiters, omitChars, maxParts)
    , result.base := ArrayList
    Return result
}

; Returns a string representation of the value
VarFuncs_ToString(ByRef var)
{
    Return "" var
}

; Trims the given string
; omitChars: Optional. A case sensitive list of characters to trim. If omitted, it defaults to Spaces and Tabs
; Returns the trimmed string
VarFuncs_Trim(ByRef var, ByRef omitChars := "")
{
    Return Trim(var, omitChars == "" ? A_Space A_Tab : omitChars)
}