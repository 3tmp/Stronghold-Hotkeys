class AutoClickerKeys extends _Enum
{
    static MButton := "MButton"
         , XButton1 := "XButton1"
         , XButton2 := "XButton2"

    ; Override _Enum.Values() for performance and sorting reasons
    Values()
    {
        Return [AutoClickerKeys.MButton, AutoClickerKeys.XButton1, AutoClickerKeys.XButton2]
    }
}