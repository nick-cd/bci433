       dcl-f   INCOMTDSP workstn; // INCOMTDSP is a workstation device file

       EXFMT GetIncome; // Prompt user
       DOW NOT (*IN03); // While the user DID NOT press F3
           IF INCOMEAMT = 0;
               *IN98 = *ON; // Turn on indicator associated with error message text constant
               EXFMT GetIncome;
               *IN98 = *OFF;// Turn off that same indicator after inputing a new value
               ITER;        // GO TO THE ENDDO FOR NEXT LOOP ITERATION
           ELSEIF MARRIED = ' ';
               // Similar logic to previous branch
               *IN97 = *ON;
               EXFMT GetIncome;
               *IN97 = *OFF;
               ITER;
           ELSE;

               // **Part B:** Ensuring the optional allowable deductions don't exceed the specified values
               IF STUEXPENSE > 4000;
                   STUEXPENSE = 4000;
               ENDIF;

               IF DONATIONS > 10000;
                   DONATIONS = 10000;
               ENDIF;
               ///////////////

               // Execute my subroutines
               EXSR GetDeductions;
               EXSR GetAdjustedIncomeAmount;
               EXSR GetTaxRate;
           ENDIF;

           EXSR GetDaysToPay;

           // **Part B:**
           // This logic determines whether or not the taxes and still due or overdue
           IF DAYSTOPAY < 0;
               *IN95 = *ON;
               *IN96 = *OFF;
           ELSE;
               *IN96 = *ON;
               *IN95 = *OFF;
           ENDIF;
           //////////////////  

           EXSR GetTaxAmt;

           // PROTECT FIRST SCREEN RECORD FIELDS
           // REDISPLAY FIRST SCREEN RECORD AND THEN OVERLAY SECOND RECORD
           *IN60 = *ON;      // Protect
           WRITE GetIncome;  // Redisplay
           EXFMT YourTax;    // Overlay; EXFMT b/c the user should be able to input Enter or F3
           *IN60 = *OFF;     // Stop protecting after inputting F3 or Enter key

           IF *IN03=*OFF;       // Same as IF NOT(*IN03)
               EXSR Clear;      // Clear all values before prompting the user for new information
               EXFMT GetIncome; // Prompt user for new data
           ENDIF;

       ENDDO;

       *INLR = *ON; // End program
       RETURN;      // Return control to the operating system

       // Subroutines
       BEGSR GetTaxRate;
           // **Part A:**
           // TAXRATE = 0.10;
           // **Part B:**
           IF MARRIED = 'Y';
               SELECT;
                   WHEN AINCOMEAMT > 600000;
                       TAXRATE = 0.37;
                   WHEN AINCOMEAMT > 400000;
                       TAXRATE = 0.35;
                   WHEN AINCOMEAMT > 315000;
                       TAXRATE = 0.32;
                   WHEN AINCOMEAMT > 165000;
                       TAXRATE = 0.24;
                   WHEN AINCOMEAMT > 77400;
                       TAXRATE = 0.22;
                   WHEN AINCOMEAMT > 19050;
                       TAXRATE = 0.12;
                   OTHER;
                       TAXRATE = 0.1;
               ENDSL;
           ELSE;
               SELECT;
                   WHEN AINCOMEAMT > 500000;
                       TAXRATE = 0.37;
                   WHEN AINCOMEAMT > 200000;
                       TAXRATE = 0.35;
                   WHEN AINCOMEAMT > 157500;
                       TAXRATE = 0.32;
                   WHEN AINCOMEAMT > 82500;
                       TAXRATE = 0.24;
                   WHEN AINCOMEAMT > 38700;
                       TAXRATE = 0.22;
                   WHEN AINCOMEAMT > 9525;
                       TAXRATE = 0.12;
                   OTHER;
                       TAXRATE = 0.1;
               ENDSL;
           ENDIF;
           /////////////////////
       ENDSR;

       // Determines the difference between the current day and June 1st of that year in days
       BEGSR GetDaysToPay;
           DAYSTOPAY = %DIFF(%DATE(%CHAR(%REM(%SUBDT(%DATE() : *YEARS) : 100))
               + %CHAR('0601') : *YMD0) : %DATE() : *DAYS);
       ENDSR;

       BEGSR GetTaxAmt;
           TAXAMT = (AINCOMEAMT * TAXRATE);
       ENDSR;

       BEGSR GetAdjustedIncomeAmount;
           AINCOMEAMT = INCOMEAMT - DEDUCTIONS;
       ENDSR;

       BEGSR GetDeductions;
           DEDUCTIONS = STUEXPENSE + DONATIONS;
       ENDSR;

       BEGSR Clear;
           CLEAR INCOMEAMT;
           CLEAR MARRIED;
           CLEAR STUEXPENSE;
           CLEAR DONATIONS;
           CLEAR DEDUCTIONS;
           CLEAR AINCOMEAMT;
           CLEAR TAXRATE;
           CLEAR TAXAMT;
           CLEAR DAYSTOPAY;
       ENDSR; 
