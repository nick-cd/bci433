       DCL-F SQLDSP WORKSTN;

       DCL-S  ShipCityNull BinDec (4:0);
       DCL-S  DiscountNull BinDec (4:0);
       DCL-S EndOfFile    IND;
       DCL-DS CustomerRecord;
               CustId    Char(5);
               Name      Char(15);
               ShipCity  Char(15);
               Discount  Packed(2:2);
       End-Ds CustomerRecord;
       EXSR PrepareFiles;
       EXSR GetRow;

       DOW NOT (ENDOFFILE);

         If ShipCityNull = -1;
           ShipCity = 'Unknown';
         EndIf;
         If DiscountNull = -1;
           *in99 = *on;
         Else;
           *in99 = *off;
         EndIf;
         Select;
           when SQLCode = 100;
             EXFMT Record3;
           when SQLCode <> 0 or SQLWN0 = 'W';
             EXFMT Record4;
           other;
             EXFMT Record2;
         ENDSL;

         EXSR GetRow;
         If *IN03 = *ON;
           ENDOFFILE = *ON;
         ENDIF;
        ENDDO;
        EXSR WrapUp;
        *INLR = *ON;
        Return;

        BEGSR  PrepareFiles;
        // S E T   U P   T H E   T E M P O R A R Y   R E S U L T  S T R U C T U
       EXEC SQL
              DECLARE CUSTCURSOR CURSOR
            FOR
            SELECT    CUSTID,
                      NAME,
                      SHIPCITY,
                      DISCOUNT
            FROM      BCI433LIB/CUSTOMER
            FOR READ ONLY;

        // A   T E M P O R A R Y   R E S U L T   T A B L E   I S   C R E A T E D
        EXEC SQL
             OPEN CUSTCURSOR;


             If SQLCODE <> 0 OR SQLWN0 = 'W';
                EndOfFile = *ON;
             EndIf;
        ENDSR;
           BEGSR     GETROW;
        EXEC SQL
             FETCH NEXT
             FROM  CUSTCURSOR
             INTO :CustID,
                  :Name,
                  :ShipCity :ShipCityNull,
                  :Discount :DiscountNull;


             If SQLCODE <> 0 OR SQLWN0 = 'W';
                EndOfFile = *ON;
             EndIf;

             ENDSR;
            BEGSR WRAPUP;
        EXEC SQL
             CLOSE ALLPROVCURSOR;


             If SQLCODE <> 0 OR SQLWN0 = 'W';
                EndOfFile = *ON;
             EndIf;
             ENDSR;

 
