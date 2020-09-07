

       // DatFmt used to ensure that *USA is the default for all date fields

       Ctl-Opt  DatFmt(*USA) ;

       Dcl-F  WhatDayDsp Workstn;

        /COPY lab11,DATEPROTOS

       Dcl-S  WorkDay    Zoned(1);
       Dcl-S  WorkDate   Date;

        EXFMT Input;

       Dow not *IN03;

         // DayOfWeek is not an RPGLE function, it is a user defined function


         Result1 = 'That''s a ' + DayName(DateIn);
         Result2 = DateWords(DateIn);

         *IN90 = *ON;
         WRITE INPUT;
         ExFmt OUTPUT;
         *IN90 = *Off;

         If not *IN03;
           Clear Result1;
           Clear Result2;
           Clear DateIn;
           exfmt INPUT;
         ENDIF;
       EndDo;

       // User pressed F3 so set LR and exit

       *InLR = *On;
       Return;
 
