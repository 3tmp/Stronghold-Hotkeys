; Wrapper functions for some AutoHotkey commands

ControlSetText(ByRef Control := "", ByRef NewText := "", ByRef WinTitle := "", ByRef WinText := "", ByRef ExcludeTitle := "", ByRef ExcludeText := "")
{
    ControlSetText, %Control%, %NewText%, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
    Return ErrorLevel
}

DetectHiddenWindows(ByRef OnOff)
{
    prev := A_DetectHiddenWindows
    DetectHiddenWindows, %OnOff%
    Return prev
}

EnvGet(ByRef EnvVarName)
{
    EnvGet, OutputVar, %EnvVarName%
    Return OutputVar
}

FileAppend(ByRef Text := "", ByRef FileName := "", ByRef Encoding := "UTF-8")
{
    FileAppend, %Text%, %FileName%, %Encoding%
    Return ErrorLevel
}

FileCreateDir(ByRef DirName)
{
    FileCreateDir, %DirName%
    Return ErrorLevel
}

FileDelete(ByRef FilePattern)
{
    FileDelete, %FilePattern%
    Return ErrorLevel
}

FileEncoding(ByRef Encoding)
{
    prev := A_FileEncoding
    FileEncoding, %Encoding%
    Return prev
}

FileRead(ByRef Filename, ByRef Encoding := "UTF-8")
{
    prev := FileEncoding(Encoding)
    FileRead, OutputVar, %Filename%
    FileEncoding(prev)
    Return OutputVar
}

FormatTime(ByRef YYYYMMDDHH24MISS := "", ByRef Format := "")
{
    FormatTime, OutputVar, %YYYYMMDDHH24MISS%, %Format%
    Return OutputVar
}

GroupAdd(ByRef GroupName, ByRef WinTitle := "", ByRef WinText := "", ByRef Label := "", ByRef ExcludeTitle := "", ByRef ExcludeText := "")
{
    GroupAdd, %GroupName%, %WinTitle%, %WinText%, %Label%, %ExcludeTitle%, %ExcludeText%
    Return ErrorLevel
}

MsgBox(p*)
{
    ; If a title or body parameter is an object, it gets converted to a string
    ; Title + body
    If (p.Length() == 2 && !p[1].Is("Integer"))
    {
        MsgBox,, % _cmdsAsFuncsToString(p[1]), % _cmdsAsFuncsToString(p[2])
    }
    ; Options, title, body, timeout
    Else If (p.Length() > 1)
    {
        MsgBox, % p[1], % _cmdsAsFuncsToString(p[2]), % _cmdsAsFuncsToString(p[3]), % p[4]
    }
    ; Body
    Else
    {
        MsgBox, % _cmdsAsFuncsToString(p[1])
    }
    For each, value in ["Yes", "No", "Ok", "Cancel", "Abort", "Ignore", "Retry", "Continue", "TryAgain", "Timeout"]
    {
        IfMsgBox, %value%
        {
            Return value
        }
    }
}

OutputDebug(ByRef Text)
{
    ; If the parameter is an object, it gets converted to a string
    OutputDebug, % _cmdsAsFuncsToString(Text)
}

_cmdsAsFuncsToString(ByRef objOrVal)
{
    If (IsObject(objOrVal))
    {
        Return _objectToString(objOrVal)
    }
    Else
    {
        Return objOrVal
    }
}

_objectToString(obj)
{
    If (!IsObject(obj))
    {
        Return obj
    }

    If (InstanceOf(obj, _Object))
    {
        Return obj.ToString()
    }

    result := ""
    For key, value in obj
    {
        result .= (A_Index == 1 ? "" : ", ") "{" (IsObject(key) ? _objectToString(key) : """" key """") ": " (IsObject(value) ? _objectToString(value) : """" value """")  "}"
    }

    Return result
}


Run(ByRef Target, ByRef WorkingDir := "", ByRef Options := "")
{
    Run, %Target%, %WorkingDir%, %Options%, PID
    Return PID
}

SetTimer(ByRef Label := "", ByRef PeriodOnOffDelete := "", ByRef Priority := "")
{
    SetTimer, %Label%, %PeriodOnOffDelete%, %Priority%
}

StringCaseSense(ByRef OnOffLocale)
{
    prev := A_StringCaseSense
    StringCaseSense, %OnOffLocale%
    Return prev
}

WinActivate(ByRef WinTitle := "", ByRef WinText := "", ByRef ExcludeTitle := "", ByRef ExcludeText := "")
{
    WinActivate, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
}

WinGetClass(ByRef WinTitle := "", ByRef WinText := "", ByRef ExcludeTitle := "", ByRef ExcludeText := "")
{
    WinGetClass, OutputVar, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
    Return OutputVar
}

WinGetControlList(ByRef WinTitle := "", ByRef WinText := "", ByRef ExcludeTitle := "", ByRef ExcludeText := "")
{
    WinGet, OutputVar, ControlList, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
    Return OutputVar.Split("`n")
}

WinGetControlListHwnd(ByRef WinTitle := "", ByRef WinText := "", ByRef ExcludeTitle := "", ByRef ExcludeText := "")
{
    WinGet, OutputVar, ControlListHwnd, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
    Return OutputVar.Split("`n")
}

WinGetPos(ByRef WinTitle := "", ByRef WinText := "", ByRef ExcludeTitle := "", ByRef ExcludeText := "")
{
    WinGetPos, X, Y, Width, Height, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
    Return {X: X, Y: Y, W: Width, H: Height}
}

WinMove(ByRef WinTitleOrX, ByRef WinTextOrY, ByRef X := "", ByRef Y := "", ByRef Width := "", ByRef Height := "", ByRef ExcludeTitle := "", ByRef ExcludeText := "")
{
    If (X == "" && Y == "")
    {
        WinMove, %WinTitleOrX%, %WinTextOrY%
    }
    Else
    {
        WinMove, %WinTitleOrX%, %WinTextOrY%, %X%, %Y%, %Width%, %Height%, %ExcludeTitle%, %ExcludeText%
    }
}