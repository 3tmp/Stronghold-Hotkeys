GetLanguage()
{
    static l := GetLanguage()

    If (!IsSet(l))
    {
        l := _getSystemLanguage().StartsWith("de") ? _language_de() : _language_en()
    }
    Return l
}

_getSystemLanguage()
{
    Return WinApi_LCIDToLocaleName(A_Language)
}

_language_en()
{
    Return {"Tray_Title": "Stronghold Hotkeys v{}"
          , "Tray_Config": "Configure Settings"
          , "Tray_Website": "Open Website"
          , "Tray_About": "About"
          , "Tray_Exit": "Exit"
          , "Tray_Tip": "Stronghold v{}"
          , "Tray_About_MsgBoxTitle": "Stronghold - About v{}"
          , "Tray_About_MsgBoxBody": "A small helper program for Stronghold.`n`nPress and hold the configured mouse button for an auto clicker.`nIf enabled, the 'w' 'a' 's' 'd' keys can be used to navigate the map`n`n{} 2022 3tmp`n`nProject website: https://github.com/3tmp/Stronghold-Hotkeys"

          ; Gui
          , "Title": "Stronghold - Config v{}"
          , "TabTitle": ["General", "Autoclicker", "Map navigation", "Replace keys"]
          , "Cancel": "Cancel"
          , "Apply": "Apply"
          , "Ok": "Ok"
          , "GameGroups": ["Stronghold", "Crusader", "Stronghold or Crusader"]
          ; General
          , "G_Desc": "Welcome to the Stronghold Hotkeys. This app allows you to simplify many tideous tasks in Stronghold."
            ; TODO
          , "G_ToggleDesc": "This is the toggle key description"
          , "G_UpdatesDesc": "When should this app search online for an update?"
          , "G_UpdatesFrequency": ["On app startup", "Daily", "Weekly", "Monthly", "Never"]
          , "G_UpdateNow": "Check for updates now"
          ; Autoclicker
          , "AC_Desc": "This option enables to press and hold down the selected mouse button to send numerous left mouse clicks to the game.`nThis option takes effect in Stronghold and Crusader"
          , "AC_Enable": "Enable Autoclicker"
          , "AC_Text": "Send clicks as long as the following key gets pressed down"
          , "AC_Keys": ["Middle mouse button", "Side mouse button 1", "Side mouse button 2"]
          ; Map navigation
          , "MN_Desc": "This option enables to navigate the map with the 'w' 'a' 's' 'd' keys.`nThis option is also included in the <a href=""{}"">UCP</a>. It is recommended to use the UCP option over this.`nThis option intercepts the key presses and simulates the arrow keys, therefore it also disables the keys when typing any text (e.g. when saving the game). Use the toggle key to fast enable/disable this option."
          , "MN_Enable": "Enable Map navigation"
          , "MN_Text1": "Enable only when"
          , "MN_Text2": "is the active game"
          ; Replace keys
          ; TODO
          , "RK_Desc": "Some Description of replace keys"
          , "RK_Enable": "Enable Replace keys"
          , "RK_Text1": "Enable only when"
          , "RK_Text2": "is the active game"
          , "RK_LvHeader": ["Command", "Key"]
          , "RK_ApplyHk": "Apply Hotkey"
          , "RK_RemBinding": "Remove binding"
          , "RK_ResetHk": "Reset to default"
          , "RK_WarnInUse": "Hotkey is already in use"
          , "RK_WarnReserved": "'w', 'a', 's', 'd' are reserved for MapNavigation"
          , "RK_WarnInvCombo": "The typed key combo is invalid"
          , "RK_WarnEmpty": "The key combo must not be empty"
          , "RK_MbResetTitle": "Reset Hotkeys"
          , "RK_MbResetBody": "Reset the hotkey mapping to the default values?"
          , "RK_MbApplyErrTitle": "Error"
          , "RK_MbApplyErrEmpty": "You have to enter a key to set a new Hotkey"
          , "RK_MbApplyErrReserved": "'w', 'a', 's', 'd' Hotkeys are reserved for MapNavigation, choose a different one"
          , "RK_MbApplyErrInUse": "Hotkey is already in use, choose a different one"
          , "RK_MbApplyErrInv": "This is an invalid Hotkey combo, choose a different one"}
}

_language_de()
{
    Return {"Tray_Title": "Stronghold Hotkeys v{}"
          , "Tray_Config": "Einstellungen ändern"
          , "Tray_Website": "Website öffnen"
          , "Tray_About": "Über"
          , "Tray_Exit": "Beenden"
          , "Tray_Tip": "Stronghold v{}"
          , "Tray_About_MsgBoxTitle": "Stronghold - Über v{}"
          , "Tray_About_MsgBoxBody": "Ein kleines Hilfsprogramm für Stronghold.`n`nDrücke und halte die konfigurierte Maustaste um den Autoclicker zu aktivieren.`nFalls eingeschalten können die 'w' 'a' 's' 'd' Tasten verwendet werden um auf der Karte zu navigieren`n`n{} 2022 3tmp`n`nProjekt website: https://github.com/3tmp/Stronghold-Hotkeys"
          ; Gui
          , "Title": "Stronghold - Einst. v{}"
          , "TabTitle": ["Allgemein", "Autoclicker", "Kartennavigation", "Tasten tauschen"]
          , "Cancel": "Abbrechen"
          , "Apply": "Übernehmen"
          , "Ok": "Ok"
          , "GameGroups": ["Stronghold", "Crusader", "Stronghold oder Crusader"]
          ; General
          , "G_Desc": "Willkommen bei den Stronghold Hotkeys. Diese App vereinfacht viele mühsame Aufgaben in Stronghold."
          ; TODO
          , "G_ToggleDesc": "Das ist die Toggle Tasten Beschreibung"
          , "G_UpdatesDesc": "Wann soll die App online nach Updates suchen?"
          , "G_UpdatesFrequency": ["Beim Programmstart", "Täglich", "Wöchentlich", "Monatlich", "Nie"]
          , "G_UpdateNow": "Jetzt nach Updates suchen"
          ; Autoclicker
          , "AC_Desc": "Mit Hilfe dieser Option können beliebig viele Linksklicks an das Spiel gesendet werden während die gewählte Maustaste gedrückt wird.`nDiese Option wirkt sich auf Stronghold und Crusader aus"
          , "AC_Enable": "Autoclicker aktivieren"
          , "AC_Text": "Führe Linksklicks aus so lange wie die folgende Maustaste gedrückt wird"
          , "AC_Keys": ["Mittlere Maustaste", "Seitliche Maustaste 1", "Seitliche Maustaste 2"]
          ; Map navigation
          , "MN_Desc": "Mit Hilfe dieser Option kann die Karte mit den 'w' 'a' 's' 'd' Tasten navigiert werden.`nDiese Option ist ebenfalls im <a href=""{}"">UCP</a> enthalten. Es ist empfohlen die UCP Einstellung zu verwenden anstatt dieser.`nDa diese Option die gedrückten Tasten konsumiert und dafür Pfeiltastenklicks simuliert, kann mit diesen vier Tasten kein Text geschrieben werden (z.B. um das Spiel zu speichern). Verwende die Toggle Option um diese Einstellung schnell und temporär zu ändern."
          , "MN_Enable": "Kartennavigation aktivieren"
          , "MN_Text1": "Nur aktivieren, wenn"
          , "MN_Text2": "das aktive Spiel ist"
          ; Replace keys
          ; TODO
          , "RK_Desc": "Eine Beschreibung fürs Tasten tauschen"
          , "RK_Enable": "Tasten tauschen aktivieren"
          , "RK_Text1": "Nur aktivieren, wenn"
          , "RK_Text2": "das aktive Spiel ist"
          , "RK_LvHeader": ["Befehl", "Taste"]
          , "RK_ApplyHk": "Setze Hotkey"
          , "RK_RemBinding": "Entferne Hotkey"
          , "RK_ResetHk": "Auf Standard zurücksetzen"
          , "RK_WarnInUse": "Hotkey wird bereits verwendet"
          , "RK_WarnReserved": "'w', 'a', 's', 'd' sind für die Kartennavigation reserviert"
          , "RK_WarnInvCombo": "Die Tastenkombination ist ungültig"
          , "RK_WarnEmpty": "Die Tastenkombination darf nicht leer sein"
          , "RK_MbResetTitle": "Setzt Hotkeys zurück"
          , "RK_MbResetBody": "Alle Hotkeys auf die Standardwerte zurücksetzen?"
          , "RK_MbApplyErrTitle": "Error"
          , "RK_MbApplyErrEmpty": "Eine Taste klicken um einen neuen Hotkey zu setzen"
          , "RK_MbApplyErrReserved": "'w', 'a', 's', 'd' sind für die Kartennavigation reserviert, bitte eine andere wählen"
          , "RK_MbApplyErrInUse": "Die Tastenkombination wird bereits verwendet, bitte eine andere wählen"
          , "RK_MbApplyErrInv": "Die Tastenkombination ist ungültig, bitte eine andere wählen"}
}