class EAutoClickerKeys extends _Enum
{
    static MButton := "MButton"
         , XButton1 := "XButton1"
         , XButton2 := "XButton2"

    ; Override _Enum.Values() for performance and sorting reasons
    Values()
    {
        Return [EAutoClickerKeys.MButton, EAutoClickerKeys.XButton1, EAutoClickerKeys.XButton2]
    }
}