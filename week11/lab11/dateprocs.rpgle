        Ctl-Opt NoMain DatFmt(*USA);

      /COPY LAB11,DATEPROTOS

       Dcl-Proc DayOfWeek EXPORT;
         Dcl-Pi *N Zoned(1);
           WorkDate Date;
         END-PI;

         // Any Sunday can be set to the date of ANY valid Sunday
         Dcl-S AnySunday Date INZ(D'04/02/1995');
         Dcl-S WorkNum Packed(7);
         Dcl-S WorkDay Zoned(1);

         WorkNum = %ABS(%DIFF(WorkDate:AnySunday:*D));
         WorkDay = %Rem(WorkNum:7);

         If WorkDay = 0;
           WorkDay = 7;
         ENDIF;

         Return WorkDay;

       END-PROC DayOfWeek;

       Dcl-Proc DayName EXPORT;
         Dcl-Pi *N CHAR(9) ;
           DateIn Date;
         End-PI;

         DCL-DS DayData;
           *n Char(9) Inz('Monday');
           *n Char(9) Inz('Tuesday');
           *n Char(9) Inz('Wednesday');
           *n Char(9) Inz('Thursday');
           *n Char(9) Inz('Friday');
           *n Char(9) Inz('Saturday');
           *n Char(9) Inz('Sunday');

           DayArray Char(9) Dim(7) Pos(1);

         END-DS;


                 Return DayArray(DayOfWeek(DateIn));
       END-PROC DayName;

       Dcl-Proc MonthNumName EXPORT;
         Dcl-Pi *N CHAR(9) ;
           DateIn Date;
         End-PI;

         DCL-DS MonData;
           *n Char(9) Inz('January');
           *n Char(9) Inz('February');
           *n Char(9) Inz('March');
           *n Char(9) Inz('April');
           *n Char(9) Inz('May');
           *n Char(9) Inz('June');
           *n Char(9) Inz('July');
           *n Char(9) Inz('August');
           *n Char(9) Inz('September');
           *n Char(9) Inz('October');
           *n Char(9) Inz('November');
           *n Char(9) Inz('December');

           MonArray Char(9) Dim(12) Pos(1);

         END-DS;

                 Return MonArray(%SUBDT(DateIn:*MONTHS));
       END-PROC MonthNumName;

       Dcl-Proc FindDay Export;
         Dcl-Pi *N Char(2);
           WorkDate  Date;
         End-Pi;

         Dcl-S day Zoned(2);

         day = %Subdt(WorkDate:*DAYS);

         If day < 10;
           Return '0' + %Char(day);
         Else;
           Return %Char(day);
         ENDIF;

       END-PROC FindDay;

       Dcl-Proc FindYear Export;
         Dcl-Pi *N Char(4);
           DateIn Date;
         END-PI;

         Dcl-S tmp Char(4);
         Dcl-S year Zoned(4);

         year = %Subdt(DateIn:*YEARS);
         tmp = %Char(year);

         If year < 10;
           tmp = '0' + tmp;
         ENDIF;

         If year < 100;
           tmp = '0' + tmp;
         ENDIF;

         If year < 1000;
           tmp = '0' + tmp;
         ENDIF;

         Return tmp;

       END-PROC FindYear;

       Dcl-Proc DateWords EXPORT;
         Dcl-Pi *N CHAR(28) ;
           WorkDate Date;
         End-PI;

         Return %TRIM(DayName(WorkDate)) + ' ' +
                %TRIM(MonthNumName(WorkDate)) + ' ' +
                FindDay(WorkDate) + ', ' +
                FindYear(WorkDate);
       END-PROC DateWords; 
