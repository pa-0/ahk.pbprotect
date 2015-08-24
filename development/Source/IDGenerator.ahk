; ======================================================================
;
;                    PBprotect - System ID Generator
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
ApplName = System ID Generator

; Specify the application version.
ApplVersion = 1.0

; Specify the floating number format.
SetFormat, float, 0.2

; Calculate the application modification time.
FileGetTime, ModificationTime, IDGenerator.exe

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

; Include the PBid file.
#Include %A_ScriptDir%\include\PBid.ahk

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

; Add the form button - CreateSystemID.
Gui, Add, Button, x10 y100 w246 h30 gCreateSystemID, Create System ID

; Add the form button - CloseApplication.
Gui, Add, Button, x266 y100 w246 h30 gCloseApplication, Close

; Display the GUI.
Gui, Show, Center w522 h140, %RegApplName% %RegApplVersion% - System ID Generator - Hash: %DisplayHashType%


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

Return


; ======================================================================
; L A B E L   T O   C L O S E   T H E   A P P L I C A T I O N
; ======================================================================

; Label - Close the application.
GuiClose:
CloseApplication:

; Delete the clipboard content.
clipboard =

; Exit the application.
ExitApp


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
        SystemID := CreateID(RegUserName, RegEmail, SaltString, RegApplName, RegApplVersion, RegApplFileName, LT1, LT2, LT3, LT4, LT5, LT6, LT7, HashType)

        ; Display the system identification.
        GuiControl,, SystemID, %SystemID%

        ; Copy the system identification to the clipboard.
        clipboard = %SystemID%

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
; S H O W   T H E   A P P L I C A T I O N   I N F O R M A T I O N
; ======================================================================

; Show information about the actual application version - CTRL + SHIFT + I.
^+i::

  ; Display an information message.
  MsgBox, 64, %ApplName% %ApplVersion% - Information, Application Name: %ApplName%`n`nApplication Version: %ApplVersion%`n`nApplication Build Date: %ApplBuildDate%`n`nWebsite: %ApplWebsite%`n`n%Copyright%

Return
