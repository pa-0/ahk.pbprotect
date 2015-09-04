; ======================================================================
; I N C L U D E   N E C E S S A R Y   F I L E S
; ======================================================================

; Include the PBid file.
#Include %A_ScriptDir%\include\PBid.ahk

; Include the PBhash file.
#Include %A_ScriptDir%\include\PBhash.ahk


; ======================================================================
; F U N C T I O N   T O   C H E C K   T H E   L I C E N S E
; ======================================================================
CheckLicense() {


  ; ====================================================================
  ; I N C L U D E   P R O D U C T   C O N F I G U R A T I O N
  ; ====================================================================

  ; Include the product configuration file.
  #Include %A_ScriptDir%\include\PBproduct.ahk

  ; Include the PBhashtype file.
  #Include %A_ScriptDir%\include\PBhashtype.ahk

  ; Include the timeserver file.
  #Include %A_ScriptDir%\include\PBtimeserver.ahk


  ; ====================================================================
  ; S P E C I F Y   T H E   A P P L I C A T I O N   S E T T I N G S
  ; ====================================================================

  ; Enable autotrim.
  AutoTrim, On

  ; Set the script speed.
  SetBatchLines, -1

  ; Specify the floating number format.
  SetFormat, float, 0.3

  ; Set the working directory.
  SetWorkingDir, %A_ScriptDir%

  ; Specify the application name.
  ApplName = PBprotect License Validator

  ; Specify the application version.
  ApplVersion = 1.0


  ; ====================================================================
  ; I N I T I A L I Z E   V A R I A B L E S
  ; ====================================================================

  ; Initialize the start time.
  StartTime := A_TickCount

  ; Initialize the license key.
  LicenseKey := 0

  ; Initialize the time server number.
  TimeServerNumber := 0

  ; Initialize the server date.
  ServerDate = Unknown

  ; Initialize the valid license flag.
  ValidLicense := 0

  ; Calculate the date string from today.
  TodayDate := SubStr(A_NowUTC, 1, 8)


  ; ====================================================================
  ; R E A D   T H E   C O N F I G U R A T I O N
  ; ====================================================================

  ; Read the registration username.
  IniRead, RegUserName, %LicenseConfig%, Configuration, RegUserName, Unknown

  ; Read the registration e-mail address.
  IniRead, RegEmail, %LicenseConfig%, Configuration, RegEmail, Unknown

  ; Read the license key.
  IniRead, LicenseKey, %LicenseConfig%, Configuration, LicenseKey, Unknown

  ; Read the date key.
  IniRead, DateKey, %LicenseConfig%, Configuration, DateKey, Unknown


  ; ====================================================================
  ; C R E A T E   T H E   S H O R T   L I C E N S E   K E Y
  ; ====================================================================
  ShortLicenseKey := SubStr(LicenseKey, 1, -8)


  ; ====================================================================
  ; C R E A T E   T H E   S Y S T E M   I D
  ; ====================================================================

  ; Create the system identification.
  SystemID := CreateID(RegUserName, RegEmail, SaltString, RegApplName, RegApplVersion, A_ScriptName, LT1, LT2, LT3, LT4, LT5, LT6, LT7, HashType)


  ; ====================================================================
  ; C H E C K   I F   L I C E N S E   I S   U N L I M I T T E D
  ; ====================================================================

  ; Create the unlimited pattern.
  UnlimitedPattern := Crypt.Hash.StrHash(SubStr(SystemID, 3, -4) . SubStr(RegEmail, 2, -1) . "00000000" . SubStr(RegApplName . RegUserName, 5) . SubStr(RegApplVersion, 1, -2), HashType)

  ; Check if the license is unlimited.
  if UnlimitedPattern = %ShortLicenseKey%
  {

    ; Set the license flag (unlimited).
    ValidLicense = 2

    ; Specify the end date (unlimited).
    EndDate = Unlimited

    ; Specify the valid days.
    ValidDays = Unlimited

    ; The license is not unlimited.
  } else {


    ; ==================================================================
    ; C R E A T E   L I C E N S E   P A T T E R N
    ; ==================================================================
    VisibleDate := SubStr(LicenseKey, -7)

    ; Create the comparison license pattern.
    LicensePattern := Crypt.Hash.StrHash(SubStr(SystemID, 3, -4) . SubStr(RegEmail, 2, -1) . VisibleDate . SubStr(RegApplName . RegUserName, 5) . SubStr(RegApplVersion, 1, -2), HashType)


    ; ==================================================================
    ; C H E C K   I F   T H E   L I C E N S E   M A T C H E S
    ; ==================================================================

    ; Check if the license matches the comparison pattern.
    if LicensePattern = %ShortLicenseKey%
    {

      ; Specify the end date.
      EndDate = %VisibleDate%

      ; Calculate the valid days.
      ValidDays = %EndDate%

      ; Get the number of remaining days.
      EnvSub, ValidDays, %TodayDate%, days


      ; ================================================================
      ; C H E C K   R E M A I N I N G   D A Y S
      ; ================================================================

      ; Check if the license is not expired.
      if ValidDays > 0
      {


        ; ==============================================================
        ; C H E C K   T H E   D A T E   K E Y
        ; ==============================================================

        ; Create a date key string.
        DateKeyString := Crypt.Hash.StrHash(SubStr(SystemID, 6, -10) . SubStr(RegEmail, 1, -3) . SubStr(A_NowUTC, 1, 8) . SubStr(RegApplName . RegUserName, 3) . SubStr(RegApplVersion, 1, -1), HashType)

        ; Check if the date check does not have to be executed.
        if DateKey = %DateKeyString%
        {

          ; Set the license flag (limitted).
          ValidLicense = 1

          ; The date check has to be executed.
        } else {


          ; ============================================================
          ; C R E A T E   T E M P O R A R Y   D I R E C T O R Y
          ; ============================================================

          ; Check if the temporary directory exist.
          IfNotExist, %A_ScriptDir%\temp
          {

            ; Chreate the temporary directory.
            FileCreateDir, %A_ScriptDir%\temp
          }

          ; Specify the name of the date file.
          DateFile = %A_ScriptDir%\temp\date%A_MSec%


          ; ============================================================
          ; D O W N L O A D   I N T E R N E T   D A T E   F I L E
          ; ============================================================

          ; Loop through the timeservers.
          Loop, 9
          {

            ; Specify the actual time server.
            TimeServerUrl := TimeServer%A_Index%

            ; Set the time server number.
            TimeServerNumber = %A_Index%

            ; Download the actual date into a temporary file.
            UrlDownLoadToFile, %TimeServerUrl%, %DateFile%

            ; Check if there was no error downloading the file.
            If (ErrorLevel = 0) {


              ; ========================================================
              ; R E A D   T H E   I N T E R N E T   D A T E
              ; ========================================================

              ; Read the temporary file into a variable.
              FileRead, DateString, %DateFile%

              ; Check if there was no error reading the date file.
              if not ErrorLevel
              {

                ; Delete the date file.
                FileDelete, %DateFile%

                ; Search for the date.
                Position := RegExMatch(DateString, "[0-9]{2}-[0-9]{2}-[0-9]{2}", ServerDate)

                ; Check if a date was found.
                if Position > 0
                {

                  ; Remove the minus characters.
                  StringReplace, ServerDate, ServerDate, -, , All

                  ; Trim the date string.
                  ServerDate = %ServerDate%

                  ; Add the year part to the server date.
                  ServerDate := SubStr(A_YYYY, 1, 2) . ServerDate


                  ; ====================================================
                  ; C H E C K   T H E   L O C A L   D A T E
                  ; ====================================================

                  ; Check if the local computer date is correct.
                  if ServerDate = %TodayDate%
                  {

                    ; Write the date key to the configuration file.
                    IniWrite, %A_Space%%DateKeyString%, %LicenseConfig%, Configuration, DateKey

                    ; Specify the new date key.
                    DateKey = %DateKeyString%

                    ; Check if the license is not expired.
                    if TodayDate < %EndDate%
                    {

                      ; Set the license flag (limitted).
                      ValidLicense = 1

                      ; Break the loop.
                      break

                      ; The license is expired.
                    } else {

                      ; Copy the system identification to the clipboard.
                      clipboard = %SystemID%

                      ; Create the expired date.
                      ExpiredDate := DisplayDate(EndDate)

                      ; Display an error message.
                      MsgBox, 16, %ApplName% %ApplVersion% - Error, The license expired on %ExpiredDate%!

                      ; Exit application.
                      ExitApp

                    } ; The license is expired.

                    ; The local computer date is not correct.
                  } else {

                    ; Display an error message.
                    MsgBox, 16, %ApplName% %ApplVersion% - Error, The local computer date is not valid!`n`n- ServerDate: %ServerDate%`n- LocalDate: %TodayDate%

                    ; Exit application.
                    ExitApp

                  } ; The local computer date is not correct.
                } ; Check if a date was found.
              } ; Check if there was no error reading the date file.
            } ; Check if there was no error downloading the file.
          } ; Loop through the timeservers.

          ; Check if the license could not be verified.
          if ValidLicense = 0
          {

            ; Display an error message.
            MsgBox, 16, %ApplName% %ApplVersion% - Error, No timeservers are available, please check your Internet connection!

            ; Exit application.
            ExitApp

          } ; Check if the license could not be verified.
        } ; The date check has to be executed.

        ; The license is expired.
      } else {

        ; Copy the system identification to the clipboard.
        clipboard = %SystemID%

        ; Create the expired date.
        ExpiredDate := DisplayDate(EndDate)

        ; Display an error message.
        MsgBox, 16, %ApplName% %ApplVersion% - Error, The license expired on %ExpiredDate%!

        ; Exit application.
        ExitApp

      } ; The license is expired.

      ; The license is not valid (comparison failed).
    } else {

      ; Copy the system identification to the clipboard.
      clipboard = %SystemID%

      ; Display an error message.
      MsgBox, 16, %ApplName% %ApplVersion% - Error, The license is not valid!

      ; Exit application.
      ExitApp

    } ; The license is not valid (comparison failed).
  } ; The license is not unlimited.


  ; ====================================================================
  ; C A L C U L A T E   T H E   P R O C E S S I N G   T I M E
  ; ====================================================================

  ; Specify the end time.
  EndTime := A_TickCount

  ; Calculate the processing time in milliseconds.
  ProcessingTime := EndTime - StartTime


  ; ====================================================================
  ; C A L C U L A T E   T H E   D I S P L A Y   D A T E S
  ; ====================================================================

  ; Create the display date.
  TodayDate := DisplayDate(TodayDate)

  ; Check if the end date was set.
  if EndDate != Unlimited
  {

    ; Create the display date.
    EndDate := DisplayDate(EndDate)
  }

  ; Check if the server date was set.
  if ServerDate != Unknown
  {

    ; Create the display date.
    ServerDate := DisplayDate(ServerDate)
  }


  ; ====================================================================
  ; R E T U R N   F U N C T I O N   D A T A
  ; ====================================================================

  ; Specify the return parameters.
  a := ValidLicense
  b := RegUserName
  c := RegEmail
  d := SystemID
  e := LicenseKey
  f := HashType
  g := DisplayHashType
  h := HashLength
  i := ServerDate
  j := TodayDate
  k := EndDate
  l := ValidDays
  m := DateKey
  n := TimeServerNumber
  o := ProcessingTime

  ; Return the result data.
  Return [a, b, c, d, e, f, g, h, i, j, k, l, m, n, o]
}


; ======================================================================
; F U N C T I O N   T O   C R E A T E   D I S P L A Y   D A T E S
; ======================================================================
DisplayDate(InputDate) {

  ; Create the output date.
  OutputDate := SubStr(InputDate, 7, 2) . "." . SubStr(InputDate, 5, 2) . "." . SubStr(InputDate, 1, 4)

  ; Return the new date.
  Return OutputDate
}
