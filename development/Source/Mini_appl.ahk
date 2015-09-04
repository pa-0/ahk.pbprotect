; ======================================================================
;
;                   PBprotect - Mini Test application
;
;                              Version 1.0
;
;               Copyright 2013 / PB-Soft / Patrick Biegel
;
;                            www.pb-soft.com
;
; ======================================================================
#Include %A_ScriptDir%\include\PBprotect.ahk

Result := 0
Result := CheckLicense()

if Result[1] > 0
  MsgBox, The license is valid!
