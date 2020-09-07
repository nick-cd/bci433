       //**************************************************************************
       //* THIS PROGRAM USES A CURSOR TO LOAD A TEMPORARY RESULT TABLE FROM 3
       //* SEPARATE TABLES, ONTARIO, QUEBEC AND MANITOBA. A NUMBER IS PASSED
       //* TO THE PROGRAM TO DETERMINE WHICH RECORDS ARE INLCUDED FROM THE 3 TABLES
       //**************************************************************************
           DCL-F PROVREPORT PRINTER OFLIND(*IN01) ;
           DCL-S ProvinceH    Char(10);
           DCL-S EndOfFile    IND;
           DCL-S TotalRecords PACKED(5:0) ;
             // LowLimit is passed to the program

           DCL-PI Main extpgm('PROVSQL');
             LowLimitIn PACKED(15:5);
           END-PI;

             // All Host Variables available under a single name

           DCL-DS CustomerRecord;
             CustId char(6);
             FullName char(31);
             City char(20);
             Purchase Packed(7:2);
             PDate Date;
             Province char(10);
        End-Ds CustomerRecord;
     C/EJECT
     C**************************************************************************
     C*                        ***   M A I N   R O U T I N E   ***
     C**************************************************************************
      /FREE
                LowLimit = LowLimitIn;
                EXSR PrepareFiles;
                Write ReportHdg;
                Write RColumns;
                EXSR GetRow;
                Write NewProv;
                ProvinceH = Province;
                DOW NOT EndOfFile;
                    IF *IN01 = *ON;
                        Write ReportHdg;
                        Write RColumns;
                       *IN01 = *OFF;
                    ENDIF;
                    // Province may change
                    IF ProvinceH = Province;
                      Write Detail;
                    ELSE;
                      ProvinceH = Province;
                      Write Totals;
                      TotalPurch = 0;
                      Write NewProv;
                      Write Detail;
                    ENDIF;

                    TotalPurch     = TotalPurch     + Purchase;
                    TotalRecords= TotalRecords + 1;
                    EXSR GetRow;
                ENDDO;
                Write Totals;
                EXSR   WRAPUP;
                Write UnderLimit;
                *INLR = *ON;
                RETURN;
        //**********************************************************************
        // O P E N F I L E S   S U B R O U T I N E
        //**********************************************************************
         BEGSR  PrepareFiles;
        // S E T   U P   T H E   T E M P O R A R Y   R E S U L T  STRUCTURE

         EXEC SQL
           DECLARE ALLPROVCURSOR CURSOR
             FOR
             SELECT custid, trim(fname) || ' ' || lname AS FULLNAME,
                    city, purchase, pdate,
                    'Ontario' AS PROVINCE
               FROM BCI433LIB/ONTARIO
               WHERE purchase > :LowLimit

             UNION ALL

             SELECT custid, trim(fname) || ' ' || lname AS FULLNAME,
                    city, purchase, pdate,
                    'Quebec' AS PROVINCE
               FROM BCI433LIB/QUEBEC
               WHERE purchase > :LowLimit

             UNION ALL

             SELECT custid, trim(fname) || ' ' || lname AS FULLNAME,
                    city, purchase, pdate,
                    'Manitoba' AS PROVINCE
               FROM BCI433LIB/MANITOBA
               WHERE purchase > :LowLimit
             FOR READ ONLY;

        // A   T E M P O R A R Y   R E S U L T   T A B L E   I S   C R E A T E D

            EXEC SQL
              OPEN ALLPROVCURSOR;

            IF (SQLCODE <> 0) OR (SQLWN0 = 'W');
              EndOfFile = *ON;
            ENDIF;

            ENDSR;
        //**********************************************************************
        //   G E T     R O W    S U B R O U T I N E
        //**********************************************************************
            BEGSR     GETROW;

            EXEC SQL
              FETCH NEXT
                FROM ALLPROVCURSOR
                INTO :CustomerRecord;


            IF (SQLCODE <> 0) OR (SQLWN0 = 'W');
              EndOfFile = *ON;
            ENDIF;


             ENDSR;
        //**********************************************************************
        // W R A P U P     S U B R O U T I N E
        //**********************************************************************
           BEGSR WRAPUP;

           EXEC SQL
             CLOSE ALLPROVCURSOR;

            If SQLCODE <> 0 OR SQLWN0 = 'W';
               EndOfFile = *ON;
            EndIf;


           EXEC SQL
             SELECT count(*) INTO :ONTTOTAL
               FROM BCI433LIB/ONTARIO
               WHERE purchase <= :LowLimit;

           IF (SQLCODE <> 0) OR (SQLWN0 = 'W');
             ONTTOTAL = -999;
           ENDIF;

           EXEC SQL
             SELECT count(*) INTO :QUETOTAL
               FROM BCI433LIB/QUEBEC
               WHERE purchase <= :LowLimit;

           IF (SQLCODE <> 0) OR (SQLWN0 = 'W');
             QUETOTAL = -999;
           ENDIF;

           EXEC SQL
             SELECT count(*) INTO :MANTOTAL
               FROM BCI433LIB/MANITOBA
               WHERE purchase <= :LowLimit;

           IF (SQLCODE <> 0) OR (SQLWN0 = 'W');
             MANTOTAL = -999;
           ENDIF;

          ENDSR;
 
