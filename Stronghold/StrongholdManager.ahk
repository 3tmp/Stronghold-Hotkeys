; Performs various functions in the game. Assumes that Stronghold is the foreground window
class StrongholdManager
{
    ; The window titles of the games that can directly be used with the Ahk window commands
    class WindowTitles
    {
        static Stronghold := "Stronghold ahk_class FFwinClass"
             , Crusader := "Crusader ahk_class FFwinClass"
             , StrongholdAndCrusader := "ahk_class FFwinClass"
    }

    class InstallPaths
    {
        ; Program Files Env Var = "ProgramFiles"
        static StrongholdSteam := EnvGet("ProgramFiles(x86)") "\Steam\steamapps\common\Stronghold\Stronghold.exe"
             , CrusaderSteam := EnvGet("ProgramFiles(x86)") "\Steam\steamapps\common\Stronghold Crusader Extreme\Stronghold Crusader.exe"
             , ExtremeSteam := EnvGet("ProgramFiles(x86)") "\Steam\steamapps\common\Stronghold Crusader Extreme\Stronghold_Crusader_Extreme.exe"
        ; TODO Add install paths for installation without steam
    }

    ; Perform a mouse click with the left mouse button at the current cursor position
    ClickAtCurrentMousePos()
    {
        static WM_LBUTTONDOWN := 0x201
             , WM_LBUTTONUP := 0x202
             , MK_LBUTTON := 0x0001
             , MK_NONE := 0x0000
             , sleepTime := 10

        MouseGetPos, x, y, hwnd
        this._performClick(WM_LBUTTONDOWN, WM_LBUTTONUP, MK_LBUTTON, MK_NONE, hwnd, x, y, sleepTime)
    }

    OpenGranary()
    {
        this._sendKeyWithCtrlModifier("g")
    }

    OpenEngineersGuild()
    {
        this._sendKeyWithCtrlModifier("i")
    }

    OpenKeep()
    {
        this._sendKeyWithCtrlModifier("h")
    }

    OpenTunnlerGuild()
    {
        this._sendKeyWithCtrlModifier("t")
    }

    OpenBarracks()
    {
        this._sendKeyWithCtrlModifier("b")
    }

    OpenMercenaries()
    {
        If (this._isCrusaderActive())
        {
            this._sendKeyWithCtrlModifier("n")
        }
    }

    OpenMarket()
    {
        this._sendKeyWithCtrlModifier("m")
    }

    ; Show/Hide the build menu (the one at the bottom of the screen)
    ToggleUI()
    {
        this._sendKey("Tab")
    }

    ToggleZoom()
    {
        this._sendKey("z")
    }

    GoToSignPost()
    {
        this._sendKey("s")
    }

    RotateScreenClockWise()
    {
        this._sendKey("c")
    }

    RotateScreenCounterClockWise()
    {
        this._sendKey("x")
    }

    ; Valid input: numbers 1 - 12, "random"
    SendTauntMessage(message := "random")
    {
        If (message = "random")
        {
            Random, message, 1, 12
        }

        If (message >= 1 && message <= 12)
        {
            this._sendKey("F" message)
        }
    }

    IncreaseGameSpeed()
    {
        this._sendKey("NumpadAdd")
    }

    DecreaseGameSpeed()
    {
        this._sendKey("NumpadSub")
    }

    TogglePause()
    {
        this._sendKey("p")
    }

    ; Private helper

    ; Returns true if Stronghold is the active game
    _isStrongholdActive()
    {
        Return WinActive(StrongholdManager.WindowTitles.Stronghold)
    }

    ; Returns true if Crusader or Extreme is the game
    _isCrusaderActive()
    {
        Return WinActive(StrongholdManager.WindowTitles.Crusader)
    }

    ; Returns true if Stronghold, Crusader or Extreme is the game
    _isAnyActive()
    {
        Return WinActive(StrongholdManager.WindowTitles.StrongholdAndCrusader)
    }

    ; Performs a click. Posts a window message with the given number to the target window
    _performClick(msgDown, msgUp, keysUp, keysDown, hwnd, x, y, sleep := 0)
    {
        ; lo-order word: x coordinate of the cursor
        ; hi-order word: y coordinate of the cursor
        lParam := (y << 16) | x

        PostMessage, msgDown, keysUp, lParam,, % "ahk_id" hwnd
        Sleep, % sleep
        PostMessage, msgUp, keysDown, lParam,, % "ahk_id" hwnd
        Sleep, % sleep
    }

    _sendKeyWithCtrlModifier(key)
    {
        this._send("{ctrl down}{" key "}{ctrl up}")
    }

    _sendKey(key)
    {
        this._send("{" key "}")
    }

    _send(keys)
    {
        SendEvent, % keys
    }
}