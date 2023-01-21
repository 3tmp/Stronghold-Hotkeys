class ECheckForUpdatesFrequency extends _Enum
{
    static startup := "startup"
         , day := "day"
         , week := "week"
         , month := "month"
         , never := "never"

    ; Override _Enum.Values() for performance and sorting reasons
    Values()
    {
        Return [ECheckForUpdatesFrequency.startup, ECheckForUpdatesFrequency.day, ECheckForUpdatesFrequency.week
              , ECheckForUpdatesFrequency.month, ECheckForUpdatesFrequency.never]
    }
}