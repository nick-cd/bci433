           // data file declarations
           DCL-F SHIFTWEEK KEYED USAGE(*INPUT) RENAME(SHIFTWEEK:SHIFTWEEKR);
           DCL-F SHIFTRATES DISK USAGE(*INPUT);

           // confirm is our work station file.
           // it represents a screen that will be displayed to the user
           DCL-F CONFIRM WORKSTN;

           // payrpt is our printer file
           // used as a blueprint to specify how we want our report to look
           DCL-F PAYRPT PRINTER OFLIND(*IN01);

           // stand alone field
           DCL-S HOURSOVER PACKED(3);

           /////////////////
           // **Part of LAB 6**
           // DCL-PI -> Declare Procedure Interface
           // EXTPGM -> external program
           DCL-PI MAIN EXTPGM('PAYPGM'); // **MAKE SURE THIS MATCHES YOUR PROGRAM NAME**
             SHIFTTYPE CHAR(30);
             // program parameter, since it has the same name as the fields
             // in the printer file(PAYRPT2.prtf) and display file(CONFIRM2.dspf),
             // the current value of this parameter will be used in those files
             // when displaying the shift type.
           END-PI;
           /////////////////

           // read SHIFTRATES data file to obtain the data on the various
           // rates
           READ SHIFTRATES;

           // print header information (that is, title and column heading
           // records within the PAYRPT printer file)
           WRITE TITLE;
           WRITE COLHDG;

           // retrieve the first employee record from the SHIFTWEEK data file
           READ SHIFTWEEK;

           // while we did not reach the end of the SHIFTWEEK data file (EOF)
           DOW NOT %EOF(SHIFTWEEK);
             EXSR PAYSR;

             // handling overflow...
             // once the printer reaches the end of a page, we print the
             // header information again
             IF *IN01;
               WRITE TITLE;
               WRITE COLHDG;
               *IN01 = *OFF;
             ENDIF;

             // print the currenly processing employee information to the page
             // in the form specified by the EMPDETAIL record
             WRITE EMPDETAIL;

             // retrieve next employee record from the SHIFTWEEK data file
             READ SHIFTWEEK;

           ENDDO;

           // display aggregated data (totals) at the bottom of the report...
           TOTWKPAY = TOTREGPAY + TOTOVTPAY;
           WRITE TOTALS;

           // display the various employee rates to the user as well as
           // the totals calculated after reading all the employee
           // information from the SHIFTWEEK data file.
           EXFMT INFO;

           // return control to the operating system
           *INLR = *ON;
           RETURN;

           // payroll calculations
           BEGSR PAYSR;
             // first adjustment
             SELECT;
               WHEN WORKSHIFT = '1';
                 HOURLYRATE = DAYRATE;
               WHEN WORKSHIFT = '2';
                 HOURLYRATE = AFTNRATE;
               WHEN WORKSHIFT = '3';
                 HOURLYRATE = NIGHTRATE;
             ENDSL;

             // second adjustment
             SELECT;
               WHEN PAYGRADE = 'A';
                 // EVAL(H) is for rounding
                 EVAL(H) HOURLYRATE = HOURLYRATE * 1.096;
               WHEN PAYGRADE = 'B';
                 EVAL(H) HOURLYRATE = HOURLYRATE * 1.072;
               WHEN PAYGRADE = 'C';
                 EVAL(H) HOURLYRATE = HOURLYRATE * 0.956;
             ENDSL;

             // overtime calculation...
             IF HRSWORKED <= 40;
               OVERPAY = 0;
               HOURSOVER = 0;
               EVAL(H) REGULARPAY = HRSWORKED * HOURLYRATE;
             ELSE;
               HOURSOVER = HRSWORKED - 40;

               // hourly rate is increased by 50% only for the overtime hours
               EVAL(H) OVERPAY = HOURSOVER * (1.5 * HOURLYRATE);
               EVAL(H) REGULARPAY = 40 * HOURLYRATE;
             ENDIF;

             // total pay for that week calculation
             WEEKLYPAY = REGULARPAY + OVERPAY;

             // increment total fields
             TOTREGPAY = REGULARPAY + TOTREGPAY;
             TOTOVTPAY = OVERPAY + TOTOVTPAY;
           ENDSR;
 
