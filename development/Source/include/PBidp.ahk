; ======================================================================
; F U N C T I O N   T O   C R E A T E   A   S Y S T E M   I D
; ======================================================================
; A mode can be specified to get the plain string or the hashed one.
;
;   Mode 1 = Plain string
;   Mode 2 = Hashed string
;
; ======================================================================
CreateID(RegUserName, RegEmail, SaltString, RegApplName, RegApplVersion, RegApplFileName, LT1, LT2, LT3, LT4, LT5, LT6, LT7, HashType, DisplayMode) {

  ; Initialize the output string.
  Output = %SaltString%

  ; Check lock type: Operating system information
  if LT3 = 1
  {

    ; Add the data to the output string.
    Output = %Output%-%A_Is64bitOS%-%A_OSType%-%A_OSVersion%-%A_Language%
  }

  ; Check lock type: Windows username
  if LT6 = 1
  {

    ; Add the data to the output string.
    Output = %A_UserName%-%Output%
  }

  ; Check lock type: First IP address
  if LT1 = 1
  {

    ; Add the data to the output string.
    Output = %Output%-%A_IPAddress1%
  }

  ; Check lock type: Application path and filename
  if LT4 = 1
  {

    ; Add the data to the output string.
    Output = %RegApplFileName%-%A_ScriptDir%-%Output%
  }

  ; Check lock type: Registered username and e-mail address
  if LT7 = 1
  {

    ; Add the data to the output string.
    Output = %Output%-%RegEmail%-%RegUserName%
  }

  ; Check lock type: Computer hardware information
  if LT2 = 1
  {

    ; Get different system information.
    EnvGet, E1, PROCESSOR_ARCHITECTURE
    EnvGet, E2, PROCESSOR_IDENTIFIER
    EnvGet, E3, PROCESSOR_LEVEL
    EnvGet, E4, PROCESSOR_REVISION

    ; Add the data to the output string.
    Output = %E1%-%E2%-%E3%-%E4%-%Output%
  }

  ; Check lock type: Windows computername
  if LT5 = 1
  {

    ; Add the data to the output string.
    Output = %Output%-%A_ComputerName%
  }

  ; Check if the output string should be hashed.
  if DisplayMode = 2
  {

    ; Create the hash of the output string.
    Output := Crypt.Hash.StrHash(Output, HashType)
  }

  ; Return the hashed output.
  Return Output
}
