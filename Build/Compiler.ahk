#NoEnv

global keepComments := true
global removeIndent := false
global resultFileAhk := "Stronghold.ahk"
global resultFileExe := "Stronghold.exe"
global buildMinimal := true
global resultFileExeMinimal := "Stronghold_minimal.exe"

global mainFileName := "Main.ahk"
global mainMinimalName := "Minimal_Autoclicker.ahk"
global mainPath := GetFullPathName(A_ScriptDir "\..\")
SetWorkingDir, % mainPath

If (!FileExist(mainFileName))
{
    MsgBox,, Error, The Main file does not exist
    ExitApp
}

output := ""

For each, line in FileToLineArray(FileRead(mainFileName))
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

If (FileExist("Build\" resultFileAhk))
{
    FileDelete("Build\" resultFileAhk)
}
FileAppend("Build\" resultFileAhk, output)

If (FileExist("Build\" resultFileExe))
{
    FileDelete("Build\" resultFileExe)
}
CompileWithAhk2Exe("Build\" resultFileAhk, resultFileExe)

If (buildMinimal)
{
    If (FileExist("Build\" resultFileExeMinimal))
    {
        FileDelete("Build\" resultFileExeMinimal)
    }
    CompileWithAhk2Exe(mainMinimalName, resultFileExeMinimal)
}

Msgbox,, Finish, Compiling the files finished

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

CompileWithAhk2Exe(file, result)
{
    SplitPath, A_AhkPath,, ahkDir
    ahk2Exe := """" ahkDir "\Compiler\Ahk2Exe.exe"""
    Run % ahk2Exe " /in """ A_WorkingDir "\" file """ /out """ A_WorkingDir "\Build\" result """ /compress 0"
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
GetFullPathName(fileName)
{
    static MAX_PATH := 260
    ; +1 for the null terminating character
    VarSetCapacity(lpFilePath, (MAX_PATH + 1) * 2)
    res := DllCall("Kernel32.dll\GetFullPathName", "Str", fileName, "UInt", MAX_PATH, "Str", lpFilePath, "Int", 0)
    Return lpFilePath
}
