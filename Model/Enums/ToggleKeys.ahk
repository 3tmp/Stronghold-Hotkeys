class ToggleKeys extends _Enum
{
    static CapsLock := "CapsLock"
         , Tab := "Tab"
         , F1 := "F1"
         , F2 := "F2"
         , F3 := "F3"
         , F4 := "F4"
         , F5 := "F5"
         , F6 := "F6"
         , F7 := "F7"
         , F8 := "F8"
         , F9 := "F9"
         , F10 := "F10"
         , F11 := "F11"
         , F12 := "F12"
         , NumpadEnter := "NumpadEnter"
         , NumpadMult := "NumpadMult"
         , NumpadDiv := "NumpadDiv"
         , NumpadDot := "NumpadDot"

    ; Override _Enum.Values() for performance and sorting reasons
    Values()
    {
        Return [ToggleKeys.CapsLock, ToggleKeys.Tab, ToggleKeys.F1, ToggleKeys.F2, ToggleKeys.F3, ToggleKeys.F4
              , ToggleKeys.F5, ToggleKeys.F6, ToggleKeys.F7, ToggleKeys.F8, ToggleKeys.F9, ToggleKeys.F10, ToggleKeys.F11
              , ToggleKeys.F12, ToggleKeys.NumpadEnter, ToggleKeys.NumpadMult, ToggleKeys.NumpadDiv, ToggleKeys.NumpadDot]
    }
}