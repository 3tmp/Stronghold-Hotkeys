; Wrapper functions for some AutoHotkey commands

Click(ByRef Options := "")
{
    Click, %Options%
    Return ErrorLevel
}

ControlGet(ByRef Cmd, ByRef Value := "", ByRef Control := "", ByRef WinTitle := "", ByRef WinText := "", ByRef ExcludeTitle := "", ByRef ExcludeText := "")
{
    ControlGet, OutputVar, %Cmd%, %Value%, %Control%, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
    Return OutputVar
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
FileCreateShortcut(ByRef Target, ByRef LinkFile, ByRef WorkingDir := "", ByRef Args := "", ByRef Description := "", ByRef IconFile := "", ByRef ShortcutKey := "", ByRef IconNumber := "", ByRef RunState := "")
{
    FileCreateShortcut, %Target%, %LinkFile%, %WorkingDir%, %Args%, %Description%, %IconFile%, %ShortcutKey%, %IconNumber%, %RunState%
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

Hotkey(ByRef KeyNameOrIf, ByRef LabelOrExpressionOrWinTitle := "", ByRef OptionsOrWinText := "")
{
    Hotkey, %KeyNameOfIf%, %LabelOrExpressionOrWinTitle%, %OptionsOrWinText%
    Return ErrorLevel
}

IfIs(ByRef var, ByRef type)
{
    If var is %type%
    {
        Return true
    }
    Return false
}

IniDelete(ByRef Filename, ByRef Section, ByRef Key := "")
{
    IniDelete, %Filename%, %Section%, %Key%
    Return ErrorLevel
}
IniRead(ByRef Filename, ByRef Section, ByRef Key, ByRef Default := "")
{
    IniRead, OutputVar, %Filename%, %Section%, %Key%, %Default%
    Return OutputVar
}
IniWrite(ByRef Value, ByRef Filename, ByRef Section, ByRef Key)
{
    IniWrite, %Value%, %Filename%, %Section%, %Key%
    Return ErrorLevel
}

ListLines(ByRef OnOff := "")
{
    If (OnOff == "")
    {
        ListLines
        Return
    }
    prev := A_ListLines
    ListLines, %OnOff%
    Return prev
}

MouseGetPos(ByRef Mode := "")
{
    MouseGetPos, OutputVarX, OutputVarY, OutputVarWin, OutputVarControl, %Mode%
    Return {X: OutputVarX, Y: OutputVarY, Win: OutputVarWin, Control: OutputVarControl}
}
MsgBox(p*)
{
    ; If a title or body parameter is an object, it gets converted to a string
    ; Title + body
    If (p.Length() == 2 && !IfIs(p[1], "Integer"))
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
        ; TODO implement
    }
    Else
    {
        Return objOrVal
    }
}

PostMessage(ByRef Msg, ByRef wParam := "", ByRef lParam := "", ByRef Control := "", ByRef WinTitle := "", ByRef WinText := "", ByRef ExcludeTitle := "", ByRef ExcludeText := "")
{
    PostMessage, Msg, %wParam%, %lParam%, %Control%, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
    Return ErrorLevel
}

Random(ByRef Min := "", ByRef Max := "")
{
    Random, OutputVar, %Min%, %Max%
    Return OutputVar
}

Run(ByRef Target, ByRef WorkingDir := "", ByRef Options := "")
{
    Run, %Target%, %WorkingDir%, %Options%, PID
    Return PID
}
RunWait(ByRef Target, ByRef WorkingDir := "", ByRef Options := "")
{
    RunWait, %Target%, %WorkingDir%, %Options%, PID
    Return PID
}
Send(ByRef Keys)
{
    Send, %Keys%
}
SendEvent(ByRef Keys)
{
    SendEvent, %Keys%
}
SendInput(ByRef Keys)
{
    SendInput, %Keys%
}
SendPlay(ByRef Keys)
{
    SendPlay, %Keys%
}
SendRaw(ByRef Keys)
{
    SendRaw, %Keys%
}
SendMessage(ByRef Msg, ByRef wParam := "", ByRef lParam := "", ByRef Control := "", ByRef WinTitle := "", ByRef WinText := "", ByRef ExcludeTitle := "", ByRef ExcludeText := "", Timeout := "")
{
    SendMessage, Msg , %wParam%, %lParam%, %Control%, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%, %Timeout%
    Return ErrorLevel
}
SetBatchLines(ByRef LineCount)
{
    prev := A_BatchLines
    SetBatchLines, %LineCount%
    Return prev
}

SetTimer(ByRef Label := "", ByRef PeriodOnOffDelete := "", ByRef Priority := "")
{
    SetTimer, %Label%, %PeriodOnOffDelete%, %Priority%
}
SetWorkingDir(ByRef DirName)
{
    prev := A_WorkingDir
    SetWorkingDir, %DirName%
    Return prev
}
Sleep(ByRef Delay)
{
    Sleep, %Delay%
}
SplitPath(ByRef InputVar)
{
    SplitPath, InputVar, OutFileName, OutDir, OutExtension, OutNameNoExt, OutDrive
    Return {FileName: OutFileName, Dir: OutDir, Ext: OutExtension, NameNoExt: OutNameNoExt, Drive: OutDrive}
}
StringCaseSense(ByRef OnOffLocale)
{
    prev := A_StringCaseSense
    StringCaseSense, %OnOffLocale%
    Return prev
}

ToolTip(ByRef Text := "", ByRef X := "", ByRef Y := "", ByRef WhichToolTip := "")
{
    ToolTip, % _cmdsAsFuncsToString(Text), %X%, %Y%, %WhichToolTip%
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

WinGet(ByRef Cmd := "", ByRef WinTitle := "", ByRef WinText := "", ByRef ExcludeTitle := "", ByRef ExcludeText := "")
{
    WinGet, OutputVar, %Cmd%, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
    If (Cmd.EqualsIgnoreCase("List"))
    {
        result := []
        result.Reserve(OutputVar)
        Loop, %OutputVar%
        {
            result.Add(OutputVar%A_Index%)
        }
        Return result
    }
    Else If (Cmd.Contains("ControlList"))
    {
        Return OutputVar.Split("`n")
    }
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
WinSet(ByRef Cmd, ByRef Value, ByRef WinTitle := "", ByRef WinText := "", ByRef ExcludeTitle := "", ByRef ExcludeText := "")
{
    WinSet, %Cmd%, %Value%, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
}
WinSetAlwaysOnTop(ByRef OnOffToggle := "Toggle", ByRef WinTitle := "", ByRef WinText := "", ByRef ExcludeTitle := "", ByRef ExcludeText := "")
{
    WinSet, AlwaysOnTop, %OnOffToggle%, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
}