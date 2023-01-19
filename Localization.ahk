GetLanguage()
{
    static l := GetLanguage()

    If (!IsSet(l))
    {
        l := GetSystemLanguage().StartsWith("de") ? _language_de() : _language_en()
    }
    Return l
}

GetSystemLanguage()
{
    Return WinApi_LCIDToLocaleName(A_Language)
}

_language_en()
{
    Return {"Key_Ctrl": "Ctrl"
          , "Key_Shift": "Shift"

          , "Tray_Title": "Stronghold Hotkeys v{}"
          , "Tray_Config": "Configure Settings"
          , "Tray_Website": "Open Website"
          , "Tray_About": "About"
          , "Tray_Exit": "Exit"
          , "Tray_Tip": "Stronghold v{}"
          , "Tray_About_MsgBoxTitle": "Stronghold - About v{}"
          , "Tray_About_MsgBoxBody": "A small helper program for Stronghold.`n`n{} 2022 - {} 3tmp`n`nProject website: {}"

          ; Update checking
          , "UpdateOk": "Ok"
          , "UpdateDownload": "Download"
          , "UpdateErrorTitle": "Error"
          , "UpdateErrorText": "Could not connect to the web server, please try again later"
          , "UpdateNoUpdateTitle": "No updates"
          , "UpdateNoUpdateText": "You are using the latest version: {}"
          , "UpdateAvailableText": "There is an update available for version {}`nYou have {}`n`nDo you want to download it?"
          , "UpdateAvailableTitle": "Update available"

          ; Gui
          , "Title": "Stronghold - Settings v{}"
          , "TabTitle": ["General", "Autoclicker", "Map navigation", "Replace keys"]
          , "Cancel": "Cancel"
          , "Apply": "Apply"
          , "Ok": "Ok"
          , "GameGroups": ["Stronghold", "Crusader", "Stronghold or Crusader"]
          ; General
          , "G_Desc": "Welcome to the Stronghold Hotkeys. This app allows you to simplify many tideous tasks in Stronghold."
            ; TODO
          , "G_ToggleDesc": "Toggle Key`nFor tasks like map navigation or key replacing, this program intercepts the keyboard key presses and prevents Stronghold from reading them. This is usually not a problem, because these keys are rarely used. The only reason where one really wants Stronghold to process the keys are when saving a game. (Or typing any other text)`nThe Toggle key acts as a fast solution as it allows to instantly stop (and start later on) the functions of this program and restore the default Stronghold logic."
          , "G_UpdatesDesc": "When should this app search online for an update?"
          , "G_UpdatesFrequency": ["On app startup", "Daily", "Weekly", "Monthly", "Never"]
          , "G_UpdateNow": "Check for updates now"
          ; Autoclicker
          , "AC_Desc": "This option enables to press and hold down the selected mouse button to send numerous left mouse clicks to the game.`nThis option takes effect in Stronghold and Crusader."
          , "AC_Enable": "Enable Autoclicker"
          , "AC_Text": "Send clicks as long as the following key gets pressed down"
          , "AC_Keys": ["Middle mouse button", "Side mouse button 1", "Side mouse button 2"]
          ; Map navigation
          , "MN_Desc": "This option enables to navigate the map with the 'w' 'a' 's' 'd' keys.`nThis option is also included in the <a href=""{}"">UCP</a>. It is recommended to use the UCP option over this.`nThis option intercepts the key presses and simulates the arrow keys, therefore it also disables the keys when typing any text (e.g. when saving the game).`nUse the <a id=""go-to-toggle-page"">toggle key</a> to fast enable/disable this option."
          , "MN_Enable": "Enable Map navigation"
          , "MN_Text1": "Enable only when"
          , "MN_Text2": "is the active game"
          ; Replace keys
          , "RK_Desc": "Set custom keys for commands in Stronghold, e.g. change game speed or open building menus.`nThis option intercepts the key presses, therefore it also disables the keys when typing any text (e.g. when saving the game).`nUse the <a id=""go-to-toggle-page"">toggle key</a> to fast enable/disable this option."
          , "RK_Enable": "Enable Replace keys"
          , "RK_Text1": "Enable only when"
          , "RK_Text2": "is the active game"
          , "RK_LvHeader": ["Command", "Key", "Original in Stronghold"]
          , "RK_Options": ["Decrease Gamespeed", "Go to Signpost", "Increase Gamespeed", "Open Barracks", "Open Engineers guild", "Open Granary", "Open Keep", "Open Market", "Open Mercenaries", "Open Tunnler guild", "Rotate clockwise", "Rotate counter clockwise", "Send Taunt message", "Pause", "Show/Hide UI Band", "Zoom in/out"]
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
          , "RK_MbApplyErrSameKey": "Same hotkey, choose a different one"
          , "RK_MbApplyErrInUse": "Hotkey is already in use, choose a different one"
          , "RK_MbApplyErrInv": "This is an invalid Hotkey combo, choose a different one"}
}

_language_de()
{
    Return {"Key_Ctrl": "Strg"
          , "Key_Shift": "Umschalt"

          , "Tray_Title": "Stronghold Hotkeys v{}"
          , "Tray_Config": "Einstellungen ändern"
          , "Tray_Website": "Website öffnen"
          , "Tray_About": "Über"
          , "Tray_Exit": "Beenden"
          , "Tray_Tip": "Stronghold v{}"
          , "Tray_About_MsgBoxTitle": "Stronghold - Über v{}"
          , "Tray_About_MsgBoxBody": "Ein kleines Hilfsprogramm für Stronghold.`n`n{} 2022 - {} 3tmp`n`nProjekt website: {}"

          ; Update checking
          , "UpdateOk": "Ok"
          , "UpdateDownload": "Download"
          , "UpdateErrorTitle": "Fehler"
          , "UpdateErrorText": "Es konnte keine Verbindung mit dem Updateserver hergestellt werden. Bitte später erneut versuchen"
          , "UpdateAvailableText": "Es ist ein Update auf die Version {} verfügbar`nInstallierte Version {}`n`nNeue Version herunterladen?"
          , "UpdateNoUpdateTitle": "Kein Update verfügbar"
          , "UpdateNoUpdateText": "Es ist bereits die neueste Version installiert: {}"
          , "UpdateAvailableTitle": "Update verfügbar"

          ; Gui
          , "Title": "Stronghold - Einstellungen v{}"
          , "TabTitle": ["Allgemein", "Autoclicker", "Kartennavigation", "Tasten tauschen"]
          , "Cancel": "Abbrechen"
          , "Apply": "Übernehmen"
          , "Ok": "Ok"
          , "GameGroups": ["Stronghold", "Crusader", "Stronghold oder Crusader"]
          ; General
          , "G_Desc": "Willkommen bei den Stronghold Hotkeys. Diese App vereinfacht viele mühsame Aufgaben in Stronghold."
          ; TODO
          , "G_ToggleDesc": "Toggle Taste`nUm Aufgaben wie Kartennavigation oder Tasten tauschen ausführen zu können, konsumiert dieses Programm die Tastenanschläge, bevor diese von Stronghold verarbeitet werden können. Normalerweise ist das kein Problem, da diese Tasten in Stronghold nicht verwendet werden. Der einzige Einsatzzweck für diese Tasten sind das Speichern des Spieles. (Oder wenn allgemein Text geschrieben wird)`nDie Toggle Taste stellt eine schnelle Lösung für dieses Problem bereit, da sie einen schnellen Wechsel der Modi (ein/aus) erlaubt. Wenn sie ausgeschaltet ist, dann funktioniert alles wie immer in Stronghold."
          , "G_UpdatesDesc": "Wann soll die App online nach Updates suchen?"
          , "G_UpdatesFrequency": ["Beim Start", "Täglich", "Wöchentlich", "Monatlich", "Nie"]
          , "G_UpdateNow": "Jetzt nach Updates suchen"
          ; Autoclicker
          , "AC_Desc": "Mit Hilfe dieser Option werden dauerhaft Linksklicks an das Spiel gesendet, solange die gewählte Maustaste gedrückt wird.`nDiese Option wirkt sich auf Stronghold und Crusader aus."
          , "AC_Enable": "Autoclicker aktivieren"
          , "AC_Text": "Führe Linksklicks aus so lange wie die folgende Maustaste gedrückt wird"
          , "AC_Keys": ["Mittlere Maustaste", "Seitliche Maustaste 1", "Seitliche Maustaste 2"]
          ; Map navigation
          , "MN_Desc": "Mit Hilfe dieser Option kann die Karte mit den 'w' 'a' 's' 'd' Tasten navigiert werden.`nDiese Option ist ebenfalls im <a href=""{}"">UCP</a> enthalten. Es ist empfohlen die UCP Einstellung zu verwenden anstatt dieser.`nDa diese Option die gedrückten Tasten konsumiert und dafür Pfeiltastenklicks simuliert, kann mit diesen vier Tasten kein Text geschrieben werden (z.B. um das Spiel zu speichern).`nVerwende die <a id=""go-to-toggle-page"">Toggle Taste</a> um diese Einstellung schnell und temporär zu ändern."
          , "MN_Enable": "Kartennavigation aktivieren"
          , "MN_Text1": "Nur aktivieren, wenn"
          , "MN_Text2": "das aktive Spiel ist"
          ; Replace keys
          , "RK_Desc": "Vergebe eigene Tasten für Befehle in Stronghold, wie z.B. Spielgeschwindigkeit ändern oder Gebäudemenüs öffnen.`nDa diese Option die gedrückten Tasten konsumiert, kann mit diesen Tasten kein Text geschrieben werden (z.B. um das Spiel zu speichern)`nVerwende die <a id=""go-to-toggle-page"">Toggle Taste</a> um diese Einstellung schnell und temporär zu ändern."
          , "RK_Enable": "Tasten tauschen aktivieren"
          , "RK_Text1": "Nur aktivieren, wenn"
          , "RK_Text2": "das aktive Spiel ist"
          , "RK_LvHeader": ["Befehl", "Taste", "Original in Stronghold"]
          , "RK_Options": ["Verringere Geschwindigkeit", "Zum Wegweiser springen", "Erhöhe Geschwindigkeit", "Öffne Ausbildungslager", "Öffne Baumeistergilde", "Öffne Kornspeicher", "Öffne Bergfried", "Öffne Marktplatz", "Öffne Söldnerposten", "Öffne Tunnelbauergilde", "Im Uhrzeigersinn drehen", "Gegen Uhrzeigersinn drehen", "Beschimpfung senden", "Pause", "UI Band anzeigen/ausblenden", "Heran/Wegzoomen"]
          , "RK_ApplyHk": "Setze Hotkey"
          , "RK_RemBinding": "Entferne Hotkey"
          , "RK_ResetHk": "Auf Standard zurücksetzen"
          , "RK_WarnInUse": "Hotkey wird bereits verwendet"
          , "RK_WarnReserved": "'w', 'a', 's', 'd' sind für die Kartennavigation reserviert"
          , "RK_WarnInvCombo": "Die Tastenkombination ist ungültig"
          , "RK_WarnEmpty": "Die Tastenkombination darf nicht leer sein"
          , "RK_MbResetTitle": "Setzt Hotkeys zurück"
          , "RK_MbResetBody": "Alle Hotkeys auf die Standardwerte zurücksetzen?"
          , "RK_MbApplyErrTitle": "Fehler"
          , "RK_MbApplyErrEmpty": "Eine Taste klicken um einen neuen Hotkey zu setzen"
          , "RK_MbApplyErrReserved": "'w', 'a', 's', 'd' sind für die Kartennavigation reserviert, bitte eine andere wählen"
          , "RK_MbApplyErrSameKey": "Gleiche Tastenkombination, bitte eine andere wählen"
          , "RK_MbApplyErrInUse": "Die Tastenkombination wird bereits verwendet, bitte eine andere wählen"
          , "RK_MbApplyErrInv": "Die Tastenkombination ist ungültig, bitte eine andere wählen"}
}