# Lab 9A notes

This is code specific to lab 9a given in class. These sections in the actual lab
code may look different compared to this.

## Externally described data structure

```RPGLE
            DCL-DS CONTACTS20 EXT END-DS;
```

```RPGLE
            DCL-S INDLASTCDATE BINDEC(4:0);
            DCL-S INDNEXTCDATE BINDEC(4:0);
```

## Snippets of the SQLselect subroutine

```RPGLE
            EXEC SQL
              SELECT PHNLDC + PHNCIT DAYS,
                     PHNLDC, CSTPHN, PHNCOM, CSTSLN
                  INTO :NEXTCDATE :INDNEXTCDATE,
                       :PHNLDC :INDLASTCDATE,
                       :CSTPHN, :PHNCOM, :CSTSLN
                FROM BCI433LIB/CONTACTS20
                WHERE CSTNUM = :CSTNUM;


            SELECT;
              WHEN SQLSTATE = '00000';
                DUMMY = 0;
              WHEN SQLSTATE = '02000';
                /*
                 * Load HOST variables with impossible values to show that
                 * either sommething went wrong or no data exists
                 */
                CSTPHONE = 'Not Found';
                PHNLDC = D'9999-09-09';
                NEXTCDATE = D'9999-09-09';
                PHNCOM = *ALL'*'; // Set all Char space availiable to *'s
                CSTSLN = *ALL'*';
              WHEN %subst(SQLSTATE:1:2) = '01';
                CSTPHONE = 'warning';
                PHNLDC = D'9999-09-09';
                NEXTCDATE = D'9999-09-09';
                PHNCOM = *ALL'*'; // Set all Char space availiable to *'s
                CSTSLN = *ALL'*';
              OTHER;
                CSTPHONE = 'Error';
                PHNLDC = D'9999-09-09';
                NEXTCDATE = D'9999-09-09';
                PHNCOM = *ALL'*';
                CSTPHN = *ALL'*';
            ENDSL;

            IF INDLASTCDATE = -1;
              cstphn = 'Unknown Date';
              NEXTCDATE = D'9999-09-09';
              PHNLDC = D'9999-09-09';
            ENDIF;
```

### Snippets of Summaryinfo sub routine

```RPGLE
            BEGSR SUMMARYINFO;

            EXEC SQL
              SELECT COUNT(*) INTO :CONTACTT
                FROM BCI433LIB/CONTACTS20;

              IF (SQLCODE <> 0) OR (SQLWN0 = 'W');
                CONTACTT = -99999;
              ENDIF;
            // ...
```

When working with dates with group functions, it's error checking logic will be
a little different.

```RPGLE
            // ...

            IF (SQLCODE <> 0) OR ((SQLWN0 = 'W') AND (SQLWN2 <> 'W'));
              // handle ...
            ENDIF;

            // ...
```

SQLWN2 specifies that some of the values passed to a group were NULL.  
Since we expect some dates to be NULL, we have elected to ignore this warning
specifically.

SYSIBM/SYSDUMMY is a catalog table.

It has one row and column. Used to perform a calculation (possibly for  
testing) or query registers (ignoring the actual contents of the table).  
It's like the dual table in ORACLE SQL.

```RPGLE
            // ...

            SELECT USER, CURRENT TIMESTAMP, CURRENT SERVER
              INTO :USER, :TIMESTAMP, :SERVER
              FROM SYSIBM/SYSDUMMY1;

            ENDSR;
```

This a rare case where we can trust the result of the embedded SQL
statement and thus, do not check the SQL communications area. This is because
we should always recieve consistent results from registers.
