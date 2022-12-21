class CheckForUpdatesFrequency extends _Enum
{
    static startup := "startup"
         , day := "day"
         , week := "week"
         , month := "month"
         , never := "never"

    ; Override _Enum.Values() for performance and sorting reasons
    Values()
    {
        Return [CheckForUpdatesFrequency.startup, CheckForUpdatesFrequency.day, CheckForUpdatesFrequency.week
              , CheckForUpdatesFrequency.month, CheckForUpdatesFrequency.never]
    }
}