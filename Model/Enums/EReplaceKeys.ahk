class EReplaceKeys extends _Enum
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
        Return [EReplaceKeys.b, EReplaceKeys.c, EReplaceKeys.e, EReplaceKeys.f, EReplaceKeys.g, EReplaceKeys.h, EReplaceKeys.i
              , EReplaceKeys.j, EReplaceKeys.k, EReplaceKeys.l, EReplaceKeys.m, EReplaceKeys.n, EReplaceKeys.o, EReplaceKeys.p
              , EReplaceKeys.q, EReplaceKeys.r, EReplaceKeys.t, EReplaceKeys.u, EReplaceKeys.v, EReplaceKeys.x
              , EReplaceKeys.y, EReplaceKeys.z
              , EReplaceKeys.0, EReplaceKeys.1, EReplaceKeys.2, EReplaceKeys.3, EReplaceKeys.4
              , EReplaceKeys.5, EReplaceKeys.6, EReplaceKeys.7, EReplaceKeys.8, EReplaceKeys.9
              , EReplaceKeys.Numpad0, EReplaceKeys.Numpad1, EReplaceKeys.Numpad2, EReplaceKeys.Numpad3, EReplaceKeys.Numpad4
              , EReplaceKeys.Numpad5, EReplaceKeys.Numpad6, EReplaceKeys.Numpad7, EReplaceKeys.Numpad8, EReplaceKeys.Numpad9
              , EReplaceKeys.Plus, EReplaceKeys.Minus, EReplaceKeys.Dot, EReplaceKeys.Comma]
    }
}