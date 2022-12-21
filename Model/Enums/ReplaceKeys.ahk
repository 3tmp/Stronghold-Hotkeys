class ReplaceKeys extends _Enum
{
    static b := "b"
         , c := "c"
         , e := "e"
         , f := "f"
         , g := "g"
         , h := "h"
         , i := "i"
         , j := "j"
         , k := "k"
         , l := "l"
         , m := "m"
         , n := "n"
         , o := "o"
         , p := "p"
         , q := "q"
         , r := "r"
         , t := "t"
         , u := "u"
         , v := "v"
         , x := "x"
         , y := "y"
         , z := "z"
         , 0 := "0"
         , 1 := "1"
         , 2 := "2"
         , 3 := "3"
         , 4 := "4"
         , 5 := "5"
         , 6 := "6"
         , 7 := "7"
         , 8 := "8"
         , 9 := "9"
         , Numpad0 := "Numpad0"
         , Numpad1 := "Numpad1"
         , Numpad2 := "Numpad2"
         , Numpad3 := "Numpad3"
         , Numpad4 := "Numpad4"
         , Numpad5 := "Numpad5"
         , Numpad6 := "Numpad6"
         , Numpad7 := "Numpad7"
         , Numpad8 := "Numpad8"
         , Numpad9 := "Numpad9"
         , Plus := "+"
         , Minus := "-"
         , Dot := "."
         , Comma := ","

    ; Override _Enum.Values() for performance and sorting reasons
    Values()
    {
        Return [ReplaceKeys.b, ReplaceKeys.c, ReplaceKeys.e, ReplaceKeys.f, ReplaceKeys.g, ReplaceKeys.h, ReplaceKeys.i
              , ReplaceKeys.j, ReplaceKeys.k, ReplaceKeys.l, ReplaceKeys.m, ReplaceKeys.n, ReplaceKeys.o, ReplaceKeys.p
              , ReplaceKeys.q, ReplaceKeys.r, ReplaceKeys.t, ReplaceKeys.u, ReplaceKeys.v, ReplaceKeys.x
              , ReplaceKeys.y, ReplaceKeys.z
              , ReplaceKeys.0, ReplaceKeys.1, ReplaceKeys.2, ReplaceKeys.3, ReplaceKeys.4
              , ReplaceKeys.5, ReplaceKeys.6, ReplaceKeys.7, ReplaceKeys.8, ReplaceKeys.9
              , ReplaceKeys.Numpad0, ReplaceKeys.Numpad1, ReplaceKeys.Numpad2, ReplaceKeys.Numpad3, ReplaceKeys.Numpad4
              , ReplaceKeys.Numpad5, ReplaceKeys.Numpad6, ReplaceKeys.Numpad7, ReplaceKeys.Numpad8, ReplaceKeys.Numpad9
              , ReplaceKeys.Plus, ReplaceKeys.Minus, ReplaceKeys.Dot, ReplaceKeys.Comma]
    }
}