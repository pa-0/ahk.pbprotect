; ======================================================================
;
;                   PBprotect - Product Configuration
;
;                              Version 1.0
;
;               Copyright 2013 / PB-Soft / Patrick Biegel
;
;                            www.pb-soft.com
;
; ======================================================================

; ======================================================================
;
;   Please specify the product name (application name).
;
; ======================================================================
RegApplName = Test Application


; ======================================================================
;
;   Please specify the product version (application version).
;
; ======================================================================
RegApplVersion = 1.0


; ======================================================================
;
;   Please specify the application filename.
;
; ======================================================================
RegApplFileName = Application.exe


; ======================================================================
;
;   Please specify the product specific salt string.
;
; ======================================================================
SaltString = f94_gTT9ew278vn90+w8yrnpo3yf-8hhnvjY-7_se8HSo


; ======================================================================
;
;   Please specify the path to the main configuration file.
;
; ======================================================================
LicenseConfig = %A_ScriptDir%\config\PBprotect.ini


; ======================================================================
;
;   Please specify which data should be used to lock the license. Each
;   value can be enabled (value = 1) or disabled (value = 0).
;
; ======================================================================
LT1 = 0    ; First IP address (IP version 4)
LT2 = 1    ; Computer hardware information (Processor architecture, identifier, level, revision)
LT3 = 1    ; Operating system information (Operating system 64Bit, Type, version, language)
LT4 = 0    ; Application path (Application directory and filename)
LT5 = 0    ; Windows computername
LT6 = 0    ; Windows username
LT7 = 1    ; Registered username and e-mail address


; ======================================================================
;
;   Please specify the hash type for the system ID and license string.
;
;   The following hash types are available:
;
;     1 - MD5     -->   32 chars
;     2 - MD2     -->   32 chars
;     3 - SHA1    -->   40 chars
;     4 - SHA256  -->   64 chars  -->  Windows Vista and higher
;     5 - SHA384  -->   96 chars  -->  Windows Vista and higher
;     6 - SHA512  -->  128 chars  -->  Windows Vista and higher
;
; ======================================================================
HashType = 4
