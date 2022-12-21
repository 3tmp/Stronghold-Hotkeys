class WindowGroups extends _Enum
{
    static Stronghold := "Stronghold"
         , Crusader := "Crusader"
         , StrongholdAndCrusader := "StrongholdAndCrusader"

    ; Override _Enum.Values() for performance and sorting reasons
    Values()
    {
        Return [WindowGroups.Stronghold, WindowGroups.Crusader, WindowGroups.StrongholdAndCrusader]
    }
}