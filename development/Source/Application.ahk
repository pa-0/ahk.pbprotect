; ======================================================================
;
;                      PBprotect - Test application
;
;                              Version 1.0
;
;               Copyright 2013 / PB-Soft / Patrick Biegel
;
;                            www.pb-soft.com
;
; ======================================================================

; ======================================================================
; I N C L U D E   T H E   V A L I D A T O R   F I L E
; ======================================================================

; Include the PBprotect file.
#Include %A_ScriptDir%\include\PBprotect.ahk


; ======================================================================
; V A L I D A T E   T H E   L I C E N S E
; ======================================================================
Result := 0
Result := CheckLicense()


; ======================================================================
; G E T   V A L U E S   F R O M   R E S U L T   A R R A Y
; ======================================================================
ValidLicense := Result[1]
RegUserName := Result[2]
RegEmail := Result[3]
SystemID := Result[4]
LicenseKey := Result[5]
HashType := Result[6]
DisplayHashType := Result[7]
HashLength := Result[8]
ServerDate := Result[9]
TodayDate := Result[10]
EndDate := Result[11]
ValidDays := Result[12]
DateKey := Result[13]
TimeServerNumber := Result[14]
ProcessingTime := Result[15]


; ======================================================================
; R U N   T H E   A P P L I C A T I O N
; ======================================================================

; Check if the license is valid.
if Result[1] > 0
{

  ; Display a success message.
  MsgBox, 64, Test Application - Success, The license is valid!`n`nLicense valid: %ValidLicense%`n`nUsername: %RegUserName%`nE-mail address: %RegEmail%`n`nSystem ID:`n%SystemID%`n`nLicense key:`n%LicenseKey%`n`nHash number: %HashType%`nHash type: %DisplayHashType%`nHash length: %HashLength% chars`n`nServer date: %ServerDate%`nToday date: %TodayDate%`nEnd date: %EndDate%`n`nValid days: %ValidDays%`n`nDate key:`n%DateKey%`n`nTimeserver number: %TimeServerNumber%`n`nProcessing time: %ProcessingTime% milliseconds
}
