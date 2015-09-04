; ======================================================================
;
;                   PBprotect - License Key Generator
;
;                              Version 1.0
;
;               Copyright 2013 / PB-Soft / Patrick Biegel
;
;                            www.pb-soft.com
;
; ======================================================================

; ======================================================================
; S P E C I F Y   T H E   A P P L I C A T I O N   S E T T I N G S
; ======================================================================

; Specify that only one instance of this application can run.
#SingleInstance

; Remove the standard tray menu.
Menu, tray, NoStandard

; Enable autotrim.
AutoTrim, On

; Set the script speed.
SetBatchLines, 20ms

; Set the working directory.
SetWorkingDir, %A_ScriptDir%

; Specify the application name.
ApplName = License Key Generator

; Specify the application version.
ApplVersion = 1.0

; Specify the floating number format.
SetFormat, float, 0.2

; Calculate the application modification time.
FileGetTime, ModificationTime, KeyGenerator.exe

; Format the application build date.
FormatTime, ApplBuildDate , %ModificationTime%, dd.MM.yyyy / HH:mm:ss

; Specify the application website.
ApplWebsite = http://pb-soft.com

; Specify the copyright text.
Copyright := "Copyright " . Chr(169) . " " . A_YYYY . " - PB-Soft"


; ======================================================================
; I N I T I A L I Z E   V A R I A B L E S
; ======================================================================

; Specify the default display mode for the system ID and license strings.
DisplayMode = 2


; ======================================================================
; I N C L U D E   N E C E S S A R Y   F I L E S
; ======================================================================

; Include the product configuration file.
#Include %A_ScriptDir%\include\PBproduct.ahk

; Include the PBidp file.
#Include %A_ScriptDir%\include\PBidp.ahk

; Include the PBhash file.
#Include %A_ScriptDir%\include\PBhash.ahk

; Include the PBhashtype file.
#Include %A_ScriptDir%\include\PBhashtype.ahk


; ======================================================================
; S P E C I F Y   T H E   G U I   O P T I O N S
; ======================================================================

; Specify the background color of the GUI.
Gui, Color, A7BDD1

; Specify the GUI font.
Gui, font, s10 c003366, MS sans serif
Gui, font, s10 c003366, Verdana
Gui, font, s10 c003366, Arial

; Specify the form field line - RegUserName.
Gui, Add, Text, x10 y10 w80 h24, Username:
Gui, Add, Edit, x100 y10 w340 h24 vRegUserName
Gui, Add, Button, x440 y10 w24 h24 gDeleteRegUserName, D
Gui, Add, Button, x464 y10 w24 h24 gCopyRegUserName, C
Gui, Add, Button, x488 y10 w24 h24 gPasteRegUserName, P

; Specify the form field line - RegEmail.
Gui, Add, Text, x10 y40 w80 h24, E-mail:
Gui, Add, Edit, x100 y40 w340 h24 vRegEmail
Gui, Add, Button, x440 y40 w24 h24 gDeleteRegEmail, D
Gui, Add, Button, x464 y40 w24 h24 gCopyRegEmail, C
Gui, Add, Button, x488 y40 w24 h24 gPasteRegEmail, P

; Specify the form field line - SystemID.
Gui, Add, Text, x10 y70 w80 h24, System ID:
Gui, Add, Edit, x100 y70 w340 h24 vSystemID
Gui, Add, Button, x440 y70 w24 h24 gDeleteSystemID, D
Gui, Add, Button, x464 y70 w24 h24 gCopySystemID, C
Gui, Add, Button, x488 y70 w24 h24 gPasteSystemID, P

; Specify the dropdown list - Duration.
Gui, Add, Text, x10 y100 w80 h24, Duration:
Gui, Add, DropDownList, x100 y100 w340 h24 vDuration R7, Unlimited|2 Days|7 Days||14 Days|30 Days|60 Days|365 Days|Expired
Gui, Add, Edit, x446 y100 w66 h24 vXDays Center, Days

; Specify the form field - License Key.
Gui, Add, Text, x10 y130 w80 h24, License-Key:
Gui, Add, Edit, x100 y130 w340 h24 vLicenseKey
Gui, Add, Button, x440 y130 w24 h24 gDeleteLicenseKey, D
Gui, Add, Button, x464 y130 w24 h24 gCopyLicenseKey, C
Gui, Add, Button, x488 y130 w24 h24 gPasteLicenseKey, P

; Add the form button - CreateSystemID.
Gui, Add, Button, x10 y160 w161 h30 gCreateSystemID, Create System ID

; Add the form button - CreateLicenseKey.
Gui, Add, Button, x181 y160 w160 h30 gCreateLicenseKey, Create License Key

; Add the form button - CloseApplication.
Gui, Add, Button, x351 y160 w161 h30 gCloseApplication, Close

; Display the GUI.
Gui, Show, Center w522 h200, %RegApplName% %RegApplVersion% - License Key Generator - Hash: %DisplayHashType%


; ======================================================================
; G E T   U S E R   D A T A
; ======================================================================

; Check if the main configuration file is available.
IfExist, %LicenseConfig%
{


  ; ====================================================================
  ; R E A D   T H E   C O N F I G U R A T I O N
  ; ====================================================================

  ; Read the registration username.
  IniRead, RegUserName, %LicenseConfig%, Configuration, RegUserName, Unknown

  ; Read the registration e-mail address.
  IniRead, RegEmail, %LicenseConfig%, Configuration, RegEmail, Unknown


  ; ====================================================================
  ; I N S E R T   U S E R   D A T A
  ; ====================================================================

  ; Display the registration username.
  GuiControl,, RegUserName, %RegUserName%

  ; Display the registration e-mail address.
  GuiControl,, RegEmail, %RegEmail%


  ; ====================================================================
  ; I N S E R T   T H E   S Y S T E M   I D
  ; ====================================================================

  ; Check if the username and e-mail address fields are not set to unknown.
  if (RegUserName != "" && RegUserName != "Unknown" && RegEmail != "" && RegEmail != "Unknown")
  {

    ; Create the system ID.
    gosub CreateSystemID

  } ; Check if the username and e-mail address fields are not set to unknown.
} ; Check if the main configuration file is available.


; ======================================================================
; S T A R T   S Y S T E M   I D   T I M E R
; ======================================================================

; Start the system ID timer.
SetTimer, GetSystemID, 500

Return


; ======================================================================
; L A B E L   T O   C L O S E   T H E   A P P L I C A T I O N
; ======================================================================

; Label - Close the application.
GuiClose:
CloseApplication:

; Disable the system ID timer.
SetTimer, GetSystemID, Off

; Delete the clipboard content.
clipboard =

; Exit the application.
ExitApp


; ======================================================================
; L A B E L   T O   G E T   T H E   S Y S T E M   I D
; ======================================================================
GetSystemID:

  ; Submit the GUI variable.
  Gui, Submit, NoHide

  ; Trim the variable.
  SystemID = %SystemID%

  ; Specify the regex pattern.
  Pattern = ^[0-9a-fA-F]{%HashLength%}$

  ; Search for the system ID string.
  Position := RegExMatch(clipboard, Pattern, Match)

  ; Check if a system ID string was found.
  if Position > 0
  {

    ; Check if a new system ID was found.
    if SystemID != %Match%
    {

      ; Insert the system ID into the formfield.
      GuiControl,, SystemID, %Match%

      ; Delete the clipboard content.
      clipboard =

    } ; Check if a new system ID was found.
  } ; Check if a system ID string was found.

Return


; ======================================================================
; L A B E L   T O   C R E A T E   A   S Y S T E M   I D
; ======================================================================
CreateSystemID:

  ; Submit the GUI variables.
  Gui, Submit, NoHide

  ; Trim the variables.
  RegUserName = %RegUserName%
  RegEmail = %RegEmail%

  ; Check if the username field is not empty.
  if (RegUserName != "" && RegUserName != "Unknown")
  {

    ; Check if the e-mail address field is not empty.
    if RegEmail !=
    {

      ; Check if the e-mail address match the pattern.
      Position := RegExMatch(RegEmail, "i)^([a-z0-9_%+-]+\.)*[a-z0-9_%+-]+@([a-z0-9-]+\.)*[a-z0-9-]+\.[a-z]{2,6}$")

      ; Check if the e-mail address is valid.
      if Position > 0
      {

        ; Create the system identification.
        SystemID := CreateID(RegUserName, RegEmail, SaltString, RegApplName, RegApplVersion, RegApplFileName, LT1, LT2, LT3, LT4, LT5, LT6, LT7, HashType, DisplayMode)

        ; Copy the system identification to the clipboard.
        clipboard = %SystemID%

        ; Check if the display mode is set to 1 (plain text output).
        if DisplayMode = 1
        {

          ; Display the plain text string.
          MsgBox, Plain text system ID string with lock type %LT1%-%LT2%-%LT3%-%LT4%-%LT5%-%LT6%-%LT7%:`n`n%SystemID%

          ; Set the display mode back to 2.
          DisplayMode = 2

          ; The display mode is set to 2 (hashed output).
        } else {

          ; Display the system identification.
          GuiControl,, SystemID, %SystemID%

        } ; The display mode is set to 2 (hashed output).

        ; The e-mail address is not valid.
      } else {

        ; Display an error message.
        MsgBox, 16, %ApplName% %ApplVersion% - Error, The format of the e-mail address is not valid!`n`nPlease enter a valid e-mail address!

      } ; The e-mail address is not valid.

      ; The e-mail address field is empty.
    } else {

      ; Display an error message.
      MsgBox, 16, %ApplName% %ApplVersion% - Error, The e-mail address field is empty!`n`nPlease enter a valid e-mail address!

    } ; The e-mail address field is empty.

    ; The username field is empty.
  } else {

    ; Display an error message.
    MsgBox, 16, %ApplName% %ApplVersion% - Error, The username field is empty!`n`nPlease enter a valid username!

  } ; The username field is empty.

Return


; ======================================================================
; L A B E L   T O   C R E A T E   A   L I C E N S E   K E Y
; ======================================================================
CreateLicenseKey:

  ; Submit the GUI variables.
  Gui, Submit, NoHide

  ; Trim the variables.
  RegUserName = %RegUserName%
  RegEmail = %RegEmail%
  SystemID = %SystemID%
  Duration = %Duration%
  XDays = %XDays%

  ; Check if the username field is not empty.
  if (RegUserName != "" && RegUserName != "Unknown")
  {

    ; Check if the e-mail address field is not empty.
    if RegEmail !=
    {

      ; Check if the e-mail address match the pattern.
      Position := RegExMatch(RegEmail, "i)^([a-z0-9_%+-]+\.)*[a-z0-9_%+-]+@([a-z0-9-]+\.)*[a-z0-9-]+\.[a-z]{2,6}$")

      ; Check if the e-mail address is valid.
      if Position > 0
      {

        ; Check if the system ID field is not empty.
        if SystemID !=
        {

          ; Specify the regex pattern.
          Pattern = ^[0-9a-fA-F]{%HashLength%}$

          ; Search for the system ID string.
          Position := RegExMatch(SystemID, Pattern)

          ; Check if the system ID string is valid.
          if Position > 0
          {

            ; Check if the special number of days content match the pattern.
            Position := RegExMatch(XDays, "^[0-9]+$")

            ; Check if the special number of days are valid.
            if Position > 0
            {

              ; Calculate the end date.
              EndDate = %A_NowUTC%
              EndDate += %XDays%, days
              EndDate := SubStr(EndDate, 1, 8)

              ; The special number of days were not specified or are not valid.
            } else {

              ; Check if the license is unlimited.
              if Duration = Unlimited
              {

                ; Specify the end date (unlimited)
                EndDate = 00000000

              }
              else if Duration = Expired
              {

                ; Calculate the expired date.
                EndDate = %A_NowUTC%
                EndDate += -10, days
                EndDate := SubStr(EndDate, 1, 8)

                ; Calculate the end date.
              } else {

                ; Get the number of days.
                StringReplace, Duration, Duration, %A_SPACE%Days, , All
                StringReplace, Duration, Duration, %A_SPACE%Day, , All

                ; Trim the duration string.
                Duration = %Duration%

                ; Calculate the end date.
                EndDate = %A_NowUTC%
                EndDate += %Duration%, days
                EndDate := SubStr(EndDate, 1, 8)
              }
            } ; The special number of days were not specified or are not valid.

            ; Creating the license key.
            LicenseKey := SubStr(SystemID, 3, -4) . SubStr(RegEmail, 2, -1) . EndDate . SubStr(RegApplName . RegUserName, 5) . SubStr(RegApplVersion, 1, -2)

            ; Check if the display mode is set to 1 (plain text output).
            if DisplayMode = 1
            {

              ; Create the plain text license key.
              LicenseKey := LicenseKey . " --> " . EndDate

              ; Copy the license key to the clipboard.
              clipboard = %LicenseKey%

              ; Display the plain text string.
              MsgBox, Plain text license key string with lock type %LT1%-%LT2%-%LT3%-%LT4%-%LT5%-%LT6%-%LT7%:`n`n%LicenseKey%

              ; Set the display mode back to 2.
              DisplayMode = 2

              ; The display mode is set to 2 (hashed output).
            } else {

              ; Create the hashed license key.
              LicenseKey := Crypt.Hash.StrHash(LicenseKey, HashType) . EndDate

              ; Copy the license key to the clipboard.
              clipboard = %LicenseKey%

              ; Display the license key.
              GuiControl,, LicenseKey, %LicenseKey%

              ; Check if the main configuration file is available.
              IfExist, %LicenseConfig%
              {

                ; Display a question.
                MsgBox, 4, %ApplName% %ApplVersion% - Question, Do you want to save the license data to the configuration file?

                ; Check if the yes button was pressed.
                IfMsgBox Yes
                {

                  ; Write the license data to the configuration file.
                  IniWrite, %A_Space%%RegUserName%, %LicenseConfig%, Configuration, RegUserName

                  ; Write the license data to the configuration file.
                  IniWrite, %A_Space%%RegEmail%, %LicenseConfig%, Configuration, RegEmail

                  ; Write the license data to the configuration file.
                  IniWrite, %A_Space%%LicenseKey%, %LicenseConfig%, Configuration, LicenseKey

                  ; Sleep some time.
                  Sleep, 1000

                  ; Read the new username.
                  IniRead, NewRegUserName, %LicenseConfig%, Configuration, RegUserName, Unknown

                  ; Check if the username was saved.
                  if NewRegUserName = %RegUserName%
                  {

                    ; Read the new e-mail address.
                    IniRead, NewRegEmail, %LicenseConfig%, Configuration, RegEmail, Unknown

                    ; Check if the e-mail address was saved.
                    if NewRegEmail = %RegEmail%
                    {

                      ; Read the new license key.
                      IniRead, NewLicenseKey, %LicenseConfig%, Configuration, LicenseKey, Unknown

                      ; Check if the license key was saved.
                      if NewLicenseKey = %LicenseKey%
                      {

                        ; Display the success message.
                        MsgBox, 64, %ApplName% %ApplVersion% - Success, The license data was successfully saved!

                        ; The license key could not be saved.
                      } else {

                        ; Display an error message.
                        MsgBox, 16, %ApplName% %ApplVersion% - Error, The license key could not be saved!

                      } ; The license key could not be saved.

                      ; The e-mail address could not be saved.
                    } else {

                      ; Display an error message.
                      MsgBox, 16, %ApplName% %ApplVersion% - Error, The e-mail address could not be saved!

                    } ; The e-mail address could not be saved.

                    ; The username could not be saved.
                  } else {

                    ; Display an error message.
                    MsgBox, 16, %ApplName% %ApplVersion% - Error, The username could not be saved!

                  } ; The username could not be saved.
                } ; The no button was pressed.
              } ; The main configuration file is not available.
            } ; The display mode is set to 2 (hashed output).

            ; The system ID string is not valid.
          } else {

            ; Display an error message.
            MsgBox, 16, %ApplName% %ApplVersion% - Error,The format of the system ID (%DisplayHashType%) is not valid!`n`nPlease enter a valid system ID!

          } ; The system ID string is not valid.

          ; The system ID field is empty.
        } else {

          ; Display an error message.
          MsgBox, 16, %ApplName% %ApplVersion% - Error, No system ID was specified!`n`nPlease enter a valid system ID!

        } ; The system ID field is empty.

        ; The e-mail address is not valid.
      } else {

        ; Display an error message.
        MsgBox, 16, %ApplName% %ApplVersion% - Error, The format of the e-mail address is not valid!`n`nPlease enter a valid e-mail address!

      } ; The e-mail address is not valid.

      ; The e-mail address field is empty.
    } else {

      ; Display an error message.
      MsgBox, 16, %ApplName% %ApplVersion% - Error, The e-mail address field is empty!`n`nPlease enter a valid e-mail address!

    } ; The e-mail address field is empty.

    ; The username field is empty.
  } else {

    ; Display an error message.
    MsgBox, 16, %ApplName% %ApplVersion% - Error, The username field is empty!`n`nPlease enter a valid username!

  } ; The username field is empty.

Return


; ======================================================================
; D E L E T E   U S E R N A M E
; ======================================================================
DeleteRegUserName:

  ; Delete the username from the form field.
  GuiControl,, RegUserName

Return


; ======================================================================
; D E L E T E   E - M A I L   A D D R E S S
; ======================================================================
DeleteRegEmail:

  ; Delete the e-mail address from the form field.
  GuiControl,, RegEmail

Return


; ======================================================================
; D E L E T E   S Y S T E M   I D
; ======================================================================
DeleteSystemID:

  ; Delete the system ID from the form field.
  GuiControl,, SystemID

Return


; ======================================================================
; D E L E T E   L I C E N S E   K E Y
; ======================================================================
DeleteLicenseKey:

  ; Delete the license key from the form field.
  GuiControl,, LicenseKey

Return


; ======================================================================
; C O P Y   U S E R N A M E   T O   C L I P B O A R D
; ======================================================================
CopyRegUserName:

  ; Submit the GUI variables.
  Gui, Submit, NoHide

  ; Trim the username.
  RegUserName = %RegUserName%

  ; Copy the username to the clipboard.
  clipboard = %RegUserName%

Return


; ======================================================================
; C O P Y   E - M A I L   A D D R E S S   T O   C L I P B O A R D
; ======================================================================
CopyRegEmail:

  ; Submit the GUI variables.
  Gui, Submit, NoHide

  ; Trim the e-mail address.
  RegEmail = %RegEmail%

  ; Copy the e-mail address to the clipboard.
  clipboard = %RegEmail%

Return


; ======================================================================
; C O P Y   S Y S T E M   I D   T O   C L I P B O A R D
; ======================================================================
CopySystemID:

  ; Submit the GUI variables.
  Gui, Submit, NoHide

  ; Trim the system ID.
  SystemID = %SystemID%

  ; Copy the system ID to the clipboard.
  clipboard = %SystemID%

Return


; ======================================================================
; C O P Y   L I C E N S E   K E Y   T O   C L I P B O A R D
; ======================================================================
CopyLicenseKey:

  ; Submit the GUI variables.
  Gui, Submit, NoHide

  ; Trim the license key.
  LicenseKey = %LicenseKey%

  ; Copy the license key to the clipboard.
  clipboard = %LicenseKey%

Return


; ======================================================================
; P A S T E   U S E R N A M E   F R O M   C L I P B O A R D
; ======================================================================
PasteRegUserName:

  ; Copy the username from the clipboard to the input field.
  GuiControl,, RegUserName, %clipboard%

Return


; ======================================================================
; P A S T E   E - M A I L   A D D R E S S   F R O M   C L I P B O A R D
; ======================================================================
PasteRegEmail:

  ; Copy the e-mail address from the clipboard to the input field.
  GuiControl,, RegEmail, %clipboard%

Return


; ======================================================================
; P A S T E   S Y S T E M   I D   F R O M   C L I P B O A R D
; ======================================================================
PasteSystemID:

  ; Copy the system ID from the clipboard to the input field.
  GuiControl,, SystemID, %clipboard%

Return


; ======================================================================
; P A S T E   L I C E N S E   K E Y   F R O M   C L I P B O A R D
; ======================================================================
PasteLicenseKey:

  ; Copy the license key from the clipboard to the input field.
  GuiControl,, LicenseKey, %clipboard%

Return


; ======================================================================
; S H O W   T H E   A P P L I C A T I O N   I N F O R M A T I O N
; ======================================================================

; Show information about the actual application version - CTRL + SHIFT + I.
^+i::

  ; Display an information message.
  MsgBox, 64, %ApplName% %ApplVersion% - Information, Application Name: %ApplName%`n`nApplication Version: %ApplVersion%`n`nApplication Build Date: %ApplBuildDate%`n`nWebsite: %ApplWebsite%`n`n%Copyright%

Return


; ======================================================================
; S H O W   P L A I N   T E X T   L I C E N S E   K E Y   S T R I N G
; ======================================================================

; Show the plain text license key string - CTRL + SHIFT + L.
^+l::

  ; Set the display mode to 1 (plain text output).
  DisplayMode = 1

  ; Create and display the license key string.
  Goto CreateLicenseKey

Return


; ======================================================================
; S H O W   P L A I N   T E X T   S Y S T E M   I D   S T R I N G
; ======================================================================

; Show the plain text system ID string - CTRL + SHIFT + S.
^+s::

  ; Set the display mode to 1 (plain text output).
  DisplayMode = 1

  ; Create and display the system ID string.
  Goto CreateSystemID

Return
