GetLanguage()
{
    ; All german language codes end with "07"
    Return InStr(A_Language, "07", true, 3) ? _language_de() : _language_en()
}

_language_en()
{
    Return {"Tray_Title": "Stronghold Hotkeys v%1"
          , "Tray_Config": "Configure Settings"
          , "Tray_Website": "Open Website"
          , "Tray_About": "About"
          , "Tray_Exit": "Exit"
          , "Tray_Tip": "Stronghold v%1"
          , "Tray_About_MsgBoxTitle": "Stronghold - About v%1"
          , "Tray_About_MsgBoxBody": "A small helper program for Stronghold.`n`nPress and hold the configured mouse button for an auto clicker.`nIf enabled, the 'w' 'a' 's' 'd' keys can be used to navigate the map`n`n%1 2022 3tmp`n`nProject website: https://github.com/3tmp/Stronghold-Hotkeys"
          ; Gui
          , "Title": "Stronghold - Config v%1"
          , "TabTitle": "Autoclicker|Map navigation"
          , "Cancel": "Cancel"
          , "Apply": "Apply"
          ; Autoclicker
          , "AC_Desc": "This option enables to press and hold down the selected mouse button to send numerous left mouse clicks to the game.`nThis option takes effect in Stronghold and Crusader"
          , "AC_Enable": "Enable Autoclicker"
          , "AC_Text1": "Perform left clicks while the following button is pressed"
          , "AC_MButton": "Middle mouse button"
          , "AC_XButton1": "Side mouse button 1"
          , "AC_XButton2": "Side mouse button 2"
          ; Map navigation
          , "MN_Desc": "This option enables to navigate the map with the 'w' 'a' 's' 'd' keys.`nThis option is also included in the <a href=""%1"">UCP</a>. It is recommended to use the UCP option over this.`nThis option intercepts the key presses and simulates the arrow keys, therefore it also disables the keys when typing any text (e.g. when saving the game). Use the toggle key to fast enable/disable this option."
          , "MN_Enable": "Enable Map navigation"
          , "MN_Stronghold": "Stronghold"
          , "MN_Crusader": "Crusader"
          , "MN_StrongholdAndCrusader": "Stronghold or Crusader"
          , "MN_Text1": "Enable map navigation when"
          , "MN_Text2": "is the active game"
          , "MN_ToggleKey": "Toggle key"}
}

_language_de()
{
    Return {"Tray_Title": "Stronghold Hotkeys v%1"
          , "Tray_Config": "Einstellungen ändern"
          , "Tray_Website": "Website öffnen"
          , "Tray_About": "Über"
          , "Tray_Exit": "Beenden"
          , "Tray_Tip": "Stronghold v%1"
          , "Tray_About_MsgBoxTitle": "Stronghold - Über v%1"
          , "Tray_About_MsgBoxBody": "Ein kleines Hilfsprogramm für Stronghold.`n`nDrücke und halte die konfigurierte Maustaste um den Autoclicker zu aktivieren.`nFalls eingeschalten können die 'w' 'a' 's' 'd' Tasten verwendet werden um auf der Karte zu navigieren`n`n%1 2022 3tmp`n`nProjekt website: https://github.com/3tmp/Stronghold-Hotkeys"
          ; Gui
          , "Title": "Stronghold - Einst. v%1"
          , "TabTitle": "Autoclicker|Kartennavigation"
          , "Cancel": "Abbrechen"
          , "Apply": "Übernehmen"
          ; Autoclicker
          , "AC_Desc": "Mit Hilfe dieser Option können beliebig viele Linksklicks an das Spiel gesendet werden während die gewählte Maustaste gedrückt wird.`nDiese Option wirkt sich auf Stronghold und Crusader aus"
          , "AC_Enable": "Autoclicker aktivieren"
          , "AC_Text1": "Führe Linksklicks aus so lange wie die folgende Maustaste gedrückt wird"
          , "AC_MButton": "Mittlere Maustaste"
          , "AC_XButton1": "Seitliche Maustaste 1"
          , "AC_XButton2": "Seitliche Maustaste 2"
          ; Map navigation
          , "MN_Desc": "Mit Hilfe dieser Option kann die Karte mit den 'w' 'a' 's' 'd' Tasten navigiert werden.`nDiese Option ist ebenfalls im <a href=""%1"">UCP</a> enthalten. Es ist empfohlen die UCP Einstellung zu verwenden anstatt dieser.`nDa diese Option die gedrückten Tasten konsumiert und dafür Pfeiltastenklicks simuliert, kann mit diesen vier Tasten kein Text geschrieben werden (z.B. um das Spiel zu speichern). Verwende die Toggle Option um diese Einstellung schnell und temporär zu ändern."
          , "MN_Enable": "Kartennavigation aktivieren"
          , "MN_Stronghold": "Stronghold"
          , "MN_Crusader": "Crusader"
          , "MN_StrongholdAndCrusader": "Stronghold oder Crusader"
          , "MN_Text1": "Nur aktivieren, wenn"
          , "MN_Text2": "das aktive Spiel ist"
          , "MN_ToggleKey": "Toggle Taste"}
}