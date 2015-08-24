; ======================================================================
;
;                     PBprotect - Enter License Data
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
ApplName = Enter License Tool

; Specify the application version.
ApplVersion = 1.0

; Specify the floating number format.
SetFormat, float, 0.2

; Calculate the application modification time.
FileGetTime, ModificationTime, EnterLicense.exe

; Format the application build date.
FormatTime, ApplBuildDate , %ModificationTime%, dd.MM.yyyy / HH:mm:ss

; Specify the application website.
ApplWebsite = http://pb-soft.com

; Specify the copyright text.
Copyright := "Copyright " . Chr(169) . " " . A_YYYY . " - PB-Soft"


; ======================================================================
; I N C L U D E   N E C E S S A R Y   F I L E S
; ======================================================================

; Include the product configuration file.
#Include %A_ScriptDir%\include\PBproduct.ahk

; Include the PBhashtype file.
#Include %A_ScriptDir%\include\PBhashtype.ahk


; ======================================================================
; C H E C K   T H E   C O N F I G U R A T I O N   F I L E
; ======================================================================

; Check if the main configuration file is available.
IfExist, %LicenseConfig%
{


  ; ====================================================================
  ; S P E C I F Y   T H E   G U I   O P T I O N S
  ; ====================================================================

  ; Specify the background color of the GUI.
  Gui, Color, A7BDD1

  ; Specify the GUI font.
  Gui, font, s10 c003366, MS sans serif
  Gui, font, s10 c003366, Verdana
  Gui, font, s10 c003366, Arial

  ; Specify the form field - RegUserName.
  Gui, Add, Text, x10 y10 w80 h24, Username:
  Gui, Add, Edit, x100 y10 w340 h24 vRegUserName
  Gui, Add, Button, x440 y10 w24 h24 gDeleteRegUserName, D
  Gui, Add, Button, x464 y10 w24 h24 gCopyRegUserName, C
  Gui, Add, Button, x488 y10 w24 h24 gPasteRegUserName, P

  ; Specify the form field - RegEmail.
  Gui, Add, Text, x10 y40 w80 h24, E-mail:
  Gui, Add, Edit, x100 y40 w340 h24 vRegEmail
  Gui, Add, Button, x440 y40 w24 h24 gDeleteRegEmail, D
  Gui, Add, Button, x464 y40 w24 h24 gCopyRegEmail, C
  Gui, Add, Button, x488 y40 w24 h24 gPasteRegEmail, P

  ; Specify the form field - License Key.
  Gui, Add, Text, x10 y70 w80 h24, License-Key:
  Gui, Add, Edit, x100 y70 w340 h24 vLicenseKey
  Gui, Add, Button, x440 y70 w24 h24 gDeleteLicenseKey, D
  Gui, Add, Button, x464 y70 w24 h24 gCopyLicenseKey, C
  Gui, Add, Button, x488 y70 w24 h24 gPasteLicenseKey, P

  ; Add the form button - SaveLicenseData.
  Gui, Add, Button, x10 y100 w246 h30 gSaveLicenseData, Save License Data

  ; Add the form button - CloseApplication.
  Gui, Add, Button, x266 y100 w246 h30 gCloseApplication, Close

  ; Display the GUI.
  Gui, Show, Center w522 h140, %RegApplName% %RegApplVersion% - Please enter the License Data - Hash: %DisplayHashType%


  ; ====================================================================
  ; R E A D   T H E   C O N F I G U R A T I O N
  ; ====================================================================

  ; Read the registration username.
  IniRead, RegUserName, %LicenseConfig%, Configuration, RegUserName, Unknown

  ; Read the registration e-mail address.
  IniRead, RegEmail, %LicenseConfig%, Configuration, RegEmail, Unknown

  ; Read the license key.
  IniRead, LicenseKey, %LicenseConfig%, Configuration, LicenseKey, Unknown


  ; ====================================================================
  ; I N S E R T   U S E R   D A T A
  ; ====================================================================

  ; Display the registration username.
  GuiControl,, RegUserName, %RegUserName%

  ; Display the registration e-mail address.
  GuiControl,, RegEmail, %RegEmail%

  ; Display the license key.
  GuiControl,, LicenseKey, %LicenseKey%


  ; ====================================================================
  ; S T A R T   L I C E N S E   K E Y   T I M E R
  ; ====================================================================

  ; Start the license key timer.
  SetTimer, GetLicenseKey, 500

  ; The main configuration file is not available.
} else {

  ; Display the clipboard message.
  MsgBox, 16, %ApplName% %ApplVersion% - Error, The configuration file was not found!

  ; Exit the application.
  ExitApp

} ; The main configuration file is not available.

Return


; ======================================================================
; L A B E L   T O   C L O S E   T H E   A P P L I C A T I O N
; ======================================================================

; Label - Close the application.
GuiClose:
CloseApplication:

; Disable the license key timer.
SetTimer, GetLicenseKey, Off

; Delete the clipboard content.
clipboard =

; Exit the application.
ExitApp


; ======================================================================
; L A B E L   T O   G E T   T H E   L I C E N S E   K E Y
; ======================================================================
GetLicenseKey:

  ; Specify the regex pattern.
  Pattern = ^[0-9a-fA-F]{%HashLength%}(00|20)[0-9]{6}$

  ; Search for the license string.
  Position := RegExMatch(clipboard, Pattern, Match)

  ; Check if a license string was found.
  if Position > 0
  {

    ; Insert the license key into the formfield.
    GuiControl,, LicenseKey, %Match%

    ; Delete the clipboard content.
    clipboard =

  } ; Check if a license string was found.

Return


; ======================================================================
; L A B E L   T O   S A V E   T H E   L I C E N S E   D A T A
; ======================================================================
SaveLicenseData:

  ; Submit the GUI variables.
  Gui, Submit, NoHide

  ; Trim the variables.
  RegUserName = %RegUserName%
  RegEmail = %RegEmail%
  LicenseKey = %LicenseKey%

  ; Check if the main configuration file is available.
  IfExist, %LicenseConfig%
  {

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

          ; Check if the license key field is not empty.
          if LicenseKey !=
          {

            ; Specify the regex pattern.
            Pattern = ^[0-9a-fA-F]{%HashLength%}(00|20)[0-9]{6}$

            ; Search for the license string.
            Position := RegExMatch(LicenseKey, Pattern)

            ; Check if the license key string is valid.
            if Position > 0
            {

              ; Display a question.
              MsgBox, 4, %ApplName% %ApplVersion% - Question, Do you really want to save the license data to the configuration file?`n`nAll existing license data will be overwritten!

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

              ; The license key string is not valid.
            } else {

              ; Display an error message.
              MsgBox, 16, %ApplName% %ApplVersion% - Error,The format of the license key is not valid!`n`nPlease enter a valid license key!

            } ; The license key string is not valid.

            ; The license key field is empty.
          } else {

            ; Display an error message.
            MsgBox, 16, %ApplName% %ApplVersion% - Error, No license key was specified!`n`nPlease enter a valid license key!

          } ; The license key field is empty.

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

    ; The main configuration file is not available.
  } else {

    ; Display an error message.
    MsgBox, 16, %ApplName% %ApplVersion% - Error, The configuration file was not found!

  } ; The main configuration file is not available.

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
