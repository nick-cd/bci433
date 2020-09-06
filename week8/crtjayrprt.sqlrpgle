       DCL-F JAYSMENU WORKSTN;
       DCL-F BBALLDSP WORKSTN SFILE(SFL1:RECNO);

       DCL-S RECNO ZONED(4:0);

       DCL-S ENDOFFILE IND;

       DCL-DS PLAYERREC;
         FULLNAME CHAR(21);
         POSNAME CHAR(9);
         HITSTHROWS CHAR(4);
         BIRTHDATE DATE;
         HEIGHT CHAR(6);
         WEIGHT Zoned(3:0);
       END-DS;

       EXSR PREPAREFILES;

       EXFMT MENU;
       DOW NOT *IN03;

         SELECT;
           WHEN SELECTION = 1 OR SELECTION = 2 OR SELECTION = 3;
             EXSR CLEARCTL;
             EXSR OPENCUR;
             EXSR SHOWRESULTS;
             EXSR CLOSECUR;
             CLEAR SELECTION;
           OTHER;
             *IN99 = *ON;
         ENDSL;

         EXFMT MENU;
         *IN99 = *OFF;
       ENDDO;

       *INLR = *ON;
       RETURN;

       BEGSR PrepareFiles;
         EXEC SQL
           DECLARE entireteam CURSOR
             FOR
               SELECT trim(fname) || ' ' || trim(lname) AS FullName,
                   upper(position), hitsthrows, birthdate, height, weight
                 FROM BASEBALL20/AMERICANLG;

         EXEC SQL
           DECLARE pitchers CURSOR
             FOR
               SELECT trim(fname) || ' ' || trim(lname) AS FullName,
                   upper(position), hitsthrows, birthdate, height, weight
                 FROM BASEBALL20/AMERICANLG
                 WHERE lower(position) = 'p';

         EXEC SQL
           DECLARE inoutfield CURSOR
             FOR
               SELECT trim(fname) || ' ' || trim(lname) AS FullName,
                   upper(position), hitsthrows, birthdate, height, weight
                 FROM BASEBALL20/AMERICANLG
                 WHERE lower(position) = 'o' OR lower(position) = 'i';

       ENDSR;

       BEGSR OPENCUR;
         SELECT;
           WHEN SELECTION = 1;
             EXEC SQL
               OPEN entireteam;
           WHEN SELECTION = 2;
             EXEC SQL
               OPEN pitchers;
           WHEN SELECTION = 3;
             EXEC SQL
               OPEN inoutfield;
         ENDSL;
         IF (SQLCODE <> 0) OR (SQLWN0 = 'W');
           ENDOFFILE = *ON;
         ENDIF;
       ENDSR;

       BEGSR FETCHCUR;
         SELECT;
           WHEN SELECTION = 1;
             EXEC SQL
               FETCH NEXT
                 FROM entireteam
                 INTO :PLAYERREC;
           WHEN SELECTION = 2;
             EXEC SQL
               FETCH NEXT
                 FROM pitchers
                 INTO :PLAYERREC;
           WHEN SELECTION = 3;
             EXEC SQL
               FETCH NEXT
                 FROM inoutfield
                 INTO :PLAYERREC;
         ENDSL;
         IF (SQLCODE <> 0) OR ((SQLWN0 = 'W') AND (SQLWN1 <> 'W'));
           ENDOFFILE = *ON;
         ELSE;
           SELECT;
             WHEN POSNAME = 'P';
               POSNAME = 'Pitcher';
               PITCHERS = PITCHERS + 1;
             WHEN POSNAME = 'C';
               POSNAME = 'Catcher';
               CATCHERS = CATCHERS + 1;
             WHEN POSNAME = 'I';
               POSNAME = 'Infield';
               INFIELD = INFIELD + 1;
             WHEN POSNAME = 'O';
               POSNAME = 'Outfield';
               OUTFIELD = OUTFIELD + 1;
             OTHER;
               POSNAME = 'Other';
               OTHERS = OTHERS + 1;
           ENDSL;
         ENDIF;
       ENDSR;

       BEGSR SHOWRESULTS;
         EXSR FETCHCUR;
         DOW NOT(ENDOFFILE);
           RECNO = RECNO + 1;
           WRITE SFL1;
           EXSR FETCHCUR;
         ENDDO;
         EXFMT CTL1;
       ENDSR;

       BEGSR CLOSECUR;
         SELECT;
           WHEN SELECTION = 1;
             EXEC SQL
               CLOSE entireteam;
           WHEN SELECTION = 2;
             EXEC SQL
               CLOSE pitchers;
           WHEN SELECTION = 3;
             EXEC SQL
               CLOSE inoutfield;
         ENDSL;
         IF (SQLCODE <> 0) OR (SQLWN0 = 'W');
           ENDOFFILE = *ON;
         ENDIF;
       ENDSR;

       BEGSR CLEARCTL;
         *IN98 = *OFF;
         WRITE CTL1;
         *IN98 = *ON;
         RECNO = 0;

         ENDOFFILE = *OFF;

         CLEAR PITCHERS;
         CLEAR CATCHERS;
         CLEAR INFIELD;
         CLEAR OUTFIELD;
         CLEAR OTHERS;
       ENDSR; 
