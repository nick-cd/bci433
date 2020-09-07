         // **************************************************************************
        //  CUSTOMER20 READ BY NATIVE LANGUAGE (ILE RPG)
        //  CONTACTS20 ROW RETRIEVED WITH EMBEDDED SQL
        //  DETAIL REPORT LINE INCLUDES INFORMATION FROM CUSTOMER20 AND CONTACTS20
        //  SUMMARRY REPORT INFORMATION RETRIEVED WITH EMBEDDED SQL STATEMENTS

           DCL-F PHNREPORT PRINTER OFLIND(*IN01) ;
           DCL-F CUSTOMER20 DISK(*EXT) KEYED USAGE(*INPUT)
                 RENAME(CUSTOMER20:CUSTR);
           // data structure for host variables from CONTACTS20
           DCL-DS CONTACTS20 EXT END-DS;
           // Standalone fields for indicator variables
           DCL-S INDLASTCDATE BINDEC(4:0);
           DCL-S INDNEXTCDATE BINDEC(4:0);

           // DCL-S Dummy  Zoned(1); Not Needed for my design

        //**************************************************************************
        //*                        ***   M A I N   R O U T I N E   ***
        //**************************************************************************

                // Standard Technique when reading data files (database tables)
                // 1) prime read
                // 2) enter DOW NOT %EOF loop
                // 3) last line of the loop, read the same file again

                EXSR SummaryInfo;
                WRITE NEWPAGE;
                READ CUSTOMER20;
                DOW NOT %EOF;
                    // Collect contact information in this sub routine
                    EXSR SQLSelect;
                    IF *IN01 = *ON;
                       Write NEWPAGE;
                       *IN01 = *OFF;
                    ENDIF;
                    Write RPTLINE;
                   READ CUSTOMER20;
                ENDDO;
                Write SUMMARY;
                *INLR = *ON;
                RETURN;
        //**********************************************************************
        //   S Q L S E L E C T   S U B R O U T I N E
   //   //********************************************************************
         // Uses an embedded SQL statement to collect the contact information on the specific
         // customer currently being processed
   //    BEGSR    SQLSelect ;
   //    // A row from the contacts table that has the same customer number as t
   //    // read from the CUSTOMER20 file is retrieved to find out the last date
   //    // phone number, comments and the salesperson number.
   //

   //    // The call back interval is added to the last date called to determine
   //    // next date to call. The call back interval is in days which must be specified
         // (Hence the DAYS keyword after the addition expression).
         // The result of the expression will be stored in the NEXTCDATE host variable
         // unless PHNLDC is NULL is which case the result of the expression is NULL setting
         // the indicator variable to -1 (same thing when trying to load PHNLDC host variable).

         EXEC SQL
           SELECT PHNLDC + PHNCIT DAYS, PHNLDC, CSTPHN, PHNCOM, CSTSLN
               INTO :NEXTCDATE :INDNEXTCDATE,
                    :PHNLDC :INDLASTCDATE,
                    :CSTPHN, :PHNCOM, :CSTSLN
             FROM BCI433LIB/CONTACTS20
             WHERE CSTNUM = :CSTNUM; // CSTNUM was loaded when the CUSTOMER20 file is read


         SELECT;
           WHEN SQLSTATE = '00000'; // SUCCESS
             // Dummy = 0; Not needed for my design

             IF INDLASTCDATE = -1; // If the last call date is NULL
               CSTPHN = 'UNKNOWN DATE';
               NextCDate = D'9999-09-09';
               PHNLDC = D'9999-09-09';
             // Since we know what the oldest last call back date is, as we go through
             // all of the report lines we can compare it to the currently processing
             // record to see if  it's the same, if it is, we indicate it to the user to make
             // it easy to spot
             ELSEIF PHNLDC <> OLDESTDATE; // if last date called is not the oldest last date called
                 // change back to blanks if not the oldest date
                 HIGHLIGHT = '        ';
             ELSE;
                 HIGHLIGHT = '<-------';
             ENDIF;
           WHEN SQLSTATE = '02000'; // ROW NOT FOUND
             // Load host variables with ridiculous values
             // to indicate either something went wrong or
             // no data could be found
             CSTPHN = 'Not Found';
             PHNLDC = D'9999-09-09';
             NEXTCDATE = D'9999-09-09';
             PHNCOM = *ALL'*'; // Set all CHAR space availiable to *'s
             CSTSLN = *ALL'*';
           WHEN %SUBST(SQLSTATE:1:2) = '01'; // 01??? = Any Warning
             CSTPHN = 'Warning';
             PHNLDC = D'9999-09-09';
             NEXTCDATE = D'9999-09-09';
             PHNCOM = *ALL'*';
             CSTSLN = *ALL'*';
           OTHER; // Any Other Error
             CSTPHN = 'Error';
             PHNLDC = D'9999-09-09';
             NEXTCDATE = D'9999-09-09';
             PHNCOM = *ALL'*';
             CSTSLN = *ALL'*';
         ENDSL;

        ENDSR;
        //**********************************************************************
        // S U M M A R Y I N F O   S U B R O U T I N E
        //**********************************************************************
        // Retrieve information to be displayed within the summary of the report
        // This must be called before we write the record format(s) to the printer file
        BEGSR  SummaryInfo;
        //  D E T E R M I N E   T O T A L S   F O R   CONTACTS20 & CUSTOMER20

        // NOTE: CONTACTT, CUSTOMERT, UNKNOWNT, USER, TIMESTAMP, SERVER
        // are host variables or (RPGLE variables) defined in the printer file
        // which get brought in at compile time upon declaring the printer file at the beginning
        // of the program. We will load this variable with the result of the count(*) embedded
        // SQL SELECT statement
        EXEC SQL
          SELECT count(*) INTO :CONTACTT // Host variables always start with a colon
            FROM BCI433LIB/CONTACTS20;   // in SQL statements

        // For embedded SQL statements, if we use a qualified name for the CONTACTS20 data file
        // (our table), we don't need BCI433LIB in our library list

       // NEVER assume your embedded SQL statements work!
       // You always must check the communications area for feedback after each
       // embedded SQL statement!

       // Neglecting this check could allow you to preceed with erroneous information thinking
       // you got something that worked
       // Checking the SQL COMMUNICATIONS AREA ...
       IF (SQLCODE <> 0) OR (SQLWN0 = 'W');
         // Informing the user something went wrong ...
         // One way this can be done is to put a ridiculous value,
         // something that never could be true.
         // This way, when we look at the report we can easily determine
         // where something went wrong in our logic.
         CONTACTT = -99999;
       ENDIF;

       EXEC SQL
          SELECT count(*) INTO :CUSTOMERT
            FROM BCI433LIB/CUSTOMER20;

       IF (SQLCODE <> 0) OR (SQLWN0 = 'W');
         CUSTOMERT = -99999;
       ENDIF;

        // D E T E R M I N E   N U M B E R   O F   U N K N O W N   LAST   DATE CALLED

       EXEC SQL
        SELECT count(*) INTO :UNKNOWNT
          FROM BCI433LIB/CONTACTS20
          WHERE PHNLDC IS NULL; // The last call date is unknown if the last call
                                // date field in a record is NULL

       IF (SQLCODE <> 0) OR (SQLWN0 = 'W');
         UNKNOWNT = -99999;
       ENDIF;

        //  D E T E R M I N E   O L D E S T   &  M O S T   R E C E N T  L A S T
        //   C A L L B A C K   D A T E S
       // max and min functions can get you these results

       // min will give you the oldest date
       // max will give you the most recent date
       EXEC SQL
         SELECT min(PHNLDC), max(PHNLDC)
             INTO :OLDESTDATE, :MOSTRECENT
           FROM BCI433LIB/CONTACTS20;

         IF (SQLCODE <> 0) OR ((SQLWN0 = 'W') AND (SQLWN2 <> 'W'));
           OLDESTDATE = D'9999-09-09';
           MOSTRECENT = D'9999-09-09';
         ENDIF;

       // D E T E R M I N E   T H E   U S E R   S E R V E R   &   T I M E S T A M P

       // This embedded SQL statement retrieves the required information from the registers
       EXEC SQL
         SELECT user, current timestamp, current server
             INTO :USER, :TIMESTAMP, :SERVER // These host variables were defined in the printer
           FROM SYSIBM/SYSDUMMY1;            // file code and brought in at compile time upon
                                             // declaring the printer file at the beginning
                                             // of the program

       // This is the only time we can trust the result of the embedded SQL statement
       // and we do not need to check the SQL communications area.
       // This is because we should always recieve consistent results from registers.

       ENDSR; 
