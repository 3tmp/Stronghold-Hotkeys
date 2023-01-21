; Map navigation
; The map navigation hotkeys have to be defined like this, because otherwise the
; auto fire does not work correct
#If ShouldNavMap()

a::Left
s::Down
d::Right
w::Up

#If

; Determines if the Map should be navigated with the wasd keys
ShouldNavMap()
{
    global MapNavIsEnabled
         , MapNavIsToggleEnabled
         , MapNavWhereToEnable

    Return MapNavIsEnabled && MapNavIsToggleEnabled && WinActive("ahk_group " MapNavWhereToEnable)
}