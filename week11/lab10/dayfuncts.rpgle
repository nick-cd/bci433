

        Ctl-Opt NoMain  ; // no need for *INLR = *ON

      // COPY THE PROTOTYPE HERE
      /COPY LAB10,DAYPROTO
       Dcl-Proc DayNumName  EXPORT; // the definition for the user defined function
                                    // EXPORT -> external linkage
         Dcl-Pi *N CHAR(9) ;  // char(9) -> what's returned
           Number  Packed(1); // what is to be recieved
         End-PI;

          DCL-s DayName Char(9); // local variable

                 SELECT;
                     WHEN NUMBER = 1;
                     DAYNAME = 'Monday';
                     WHEN NUMBER = 2;
                     DAYNAME = 'Tuesday';
                     WHEN NUMBER = 3;
                     DAYNAME = 'Wednesday';
                     WHEN NUMBER = 4;
                     DAYNAME = 'Thursday';
                     WHEN NUMBER = 5;
                     DAYNAME = 'FRIDAY';
                     WHEN NUMBER = 6;
                     DAYNAME = 'Saturday';
                     WHEN NUMBER = 7;
                     DAYNAME = 'Sunday';
                     OTHER;
                     DAYNAME = 'Unknown';
                 ENDSL;

                 Return Dayname;
        End-Proc; 
