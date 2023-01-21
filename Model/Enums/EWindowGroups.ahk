class EWindowGroups extends _Enum
{
    static Stronghold := "Stronghold"
         , Crusader := "Crusader"
         , StrongholdAndCrusader := "StrongholdAndCrusader"

    ; Override _Enum.Values() for performance and sorting reasons
    Values()
    {
        Return [EWindowGroups.Stronghold, EWindowGroups.Crusader, EWindowGroups.StrongholdAndCrusader]
    }
}