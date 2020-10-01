# Syntax Reference

## CL commands and syntax

|Command|Parameter Keywords(s)|Command|Paramter keywords(s)|
|-------|---------------------|-------|--------------------|
|ADDLIBLE|LIB POSITION|RCVF|DEV RCDFMT OPNID WAIT|
|CALL|PGM PARM|RMVLIBLE|LIB|
|CALLPRC|PRC PARM RTNVAL|RTVJOBA|DATE USER|
|CHGCURLIB|CURLIB|RTVUSRPRF *CURRENT|RTNUSRPRF TEXT OUTQ OUTQLIB
|CLROUTQ||RTVSYSVAL|SYSVAL (QSRLNBR, QMODEL) RTNVAR|
|CHGVAR|VAR VALUE|RUNQRY *N|QRY QRYFILE OUTTYPE OUTFORM RCDSLT|
|DCLF|FILE RCDFMT OPNID|SELECT||
|DSPSPLF|SPLNBR(*LAST)|SNDRCVF|DEV RCDFMT OPNID WAIT|
|EDTLIBL||WHEN|COND THEN|
|ELSE|CMD|WRKOUTQ|OUTQ|
|ENDDO||WRKSPLF||
|ENDPGM|||
|ENDSELECT|||
|GOTO|CMDLBL|String Handling||
|GRTOJAUT|OBJ OBJTYPE ASPDEV USER AUT AUTLREFOBJ REFOBJTYPE REFASPDEV REPLACE|%SST(FIELDA offset length) &STRINGA *CAT &STRINGB &STRINGA *BCAT &STRINGB &STRINGA *TCAT &STRINGB
|IF|COND THEN|Indicators|&IN03
|MONMSG|MSGID CMPDTA EXEC|||
|PGM|PARM|||
|OTHERWISE|CMD|||
|OVRDBF|FILE TOFILE LVLCHK|||
|OVRPRTF|FILE SPLFNAME OVRFLW|||

## RPG Verbs, Functions and Special Values (Scrambled)

|RPG||RPG||RPG|Attribute|
|---|---|---|---|---|---|
|%EOF|File Name|UPDATE|Record name|RENAME(recordformat:newformat)||
|CHAIN|KeyFld File Name|*ENTRY||||
|DOU|Condition|PLIST|||
|DOW|Condition|PARM||%TRIM(fieldname) + otherfield||
|ENDDO||*IN03||||
|ENDIF||EXSR||SQL||
|ENDSL||BEGSR||Declare Cursor Cname FOR||
|EXFMT|Record name|ENDSR||||
|IF|Condition|*INLR = *ON||Seclect Into From||
|OTHER||||FETCH NEXT FROM INTO||
|READ|File Name|WRITE|Record name|SQLWN2 = 'w' null fields ignored||
|SELECT||WHEN|Condition|SQLWN0,SQLCODE||
|DCL-F|Printer||OFLIND(*IN01)|||
||Disk(*EXT)|Usage(*INPUT)|*OUTPUT *UPDATE ALIAS|DCL-PI FieldList END-PI|MAIN extpgm('N')|
||workstn|||||
||Rename|||D2 = D1 + %Days(Days);||
||Keyed|||||
|DCL-S|Fieldname|Packed(5:0)|Zoned(2:0)|DCL-DS FILENAME EXT END-DS;||
|||Char(30)|BinDec(4:0)|||
