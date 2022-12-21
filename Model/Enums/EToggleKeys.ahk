class EToggleKeys extends _Enum
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
        Return [EToggleKeys.CapsLock, EToggleKeys.Tab, EToggleKeys.F1, EToggleKeys.F2, EToggleKeys.F3, EToggleKeys.F4
              , EToggleKeys.F5, EToggleKeys.F6, EToggleKeys.F7, EToggleKeys.F8, EToggleKeys.F9, EToggleKeys.F10, EToggleKeys.F11
              , EToggleKeys.F12, EToggleKeys.NumpadEnter, EToggleKeys.NumpadMult, EToggleKeys.NumpadDiv, EToggleKeys.NumpadDot]
    }
}