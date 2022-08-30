#NoEnv

global keepComments := true
global removeIndent := false
global resultFile := "Stronghold_compressed.ahk"

global mainPath := GetFullPathName(A_ScriptDir "\..\")
SetWorkingDir, % mainPath

If (!FileExist("Stronghold.ahk"))
{
    MsgBox,, Error, The Main file does not exist
    ExitApp
}

output := ""

For each, line in FileToLineArray(FileRead("Stronghold.ahk"))
{
    line := removeIndent ? Trim(line) : line

    If (!keepComments && StartsWith(Trim(line), ";") || Trim(line) == "")
    {
        Continue
    }
    Else If (InStr(line, "#Include "))
    {
        file := StrReplace(Trim(line), "#Include ")
        output .= CompressFile(file) "`r`n"
    }
    Else
    {
        output .= line "`r`n"
    }
}

output := StrReplace(output, "    ", A_Tab)

If (FileExist("Build\" resultFile))
{
    FileDelete("Build\" resultFile)
}
FileAppend("Build\" resultFile, output)

Msgbox,, Finish, Compiling the file finished

ExitApp


CompressFile(file)
{
    result := ""
    For each, line in FileToLineArray(FileRead(file))
    {
        line := removeIndent ? Trim(line) : line
        If (!keepComments && StartsWith(Trim(line), ";") || Trim(line) == "")
        {
            Continue
        }
        result .= line "`r`n"
    }
    Return result
}

StartsWith(ByRef var, ByRef string)
{
    Return SubStr(var, 1, StrLen(string)) == string
}

FileRead(filePath)
{
    FileRead, file, % filePath
    Return file
}

FileDelete(filePath)
{
    FileDelete, % filePath
}

FileAppend(filePath, string)
{
    FileAppend, % string, % filePath, UTF-8
}

FileToLineArray(file)
{
    Return StrSplit(file, "`n", "`r")
}

; Retrieves the full path and file name of the specified file.
GetFullPathName(fileName, longName := 0)
{
    ; 522 is 260 (MAX_PATH) plus null termination character and Unicode
    size := (VarSetCapacity(lpFilePath, longName ? longName * 2 : 522) // 2) - 1
    res := DllCall("Kernel32.dll\GetFullPathName", "Str", fileName, "UInt", size, "Str", lpFilePath, "Int", 0)
    Return res ? lpFilePath : ""
}
