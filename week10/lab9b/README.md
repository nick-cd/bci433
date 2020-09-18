# Lab 9B Notes

### Sample snippets managing a cursor at each step

1. Declare the cursor
```
            EXEC SQL // inform precompiler that this is SQL
              DECLARE CustomerCusor CURSOR // CURSOR keyword indicates a cursor
              FOR
                SELECT *
                  FROM BCI433LIB/CUSTOMER
                  ORDER BY CUSTID;
```

2. Open the cursor
```
            EXEC SQL
              OPEN CustomerCursor;

            /* This is something procedurally executed and happens strategically at a
             * specific point in my program which may not work properly. Thus we must check
             * the SQL communications area
             */
            IF (SQLCODE <> 0) OR (SQLWN0 = 'W')
              EndOfFile = *ON;
            ENDIF;
```
**NOTE:** ENDOFFILE is a custom indicator variable declared like so:
> DCL-S ENDOFFILE IND;

Named indicator variables can make code easier to understand so long as they
are given a meaningful name.
We can use these named indicator variables anywhere in the program, very
similar to a boolean flag in c/c++.
In this particular case, ENDOFFILE is used to control how long we will stay in
our loop where we are to process the data.

3. Fetch rows (inside loop)
```
            DOW NOT(ENDOFFILE);
              // ...
              EXEC SQL
                FETCH NEXT
                FROM CustomerCursor
                INTO :CustId, :Name, :ShipCity, :ShipCityNull, :Discount, :DiscountNull;

              IF (SQLCODE <> 0) OR (SQLCODE = 'W')
                ENDOFFILE = *ON; // If there was a problem, I want to exit the loop
              ENDIF;
              // ...
            ENDDO;
```

4. Once you fetch a row from a cursor, you process the info in some way.

5. Free the temporary result table from memory.
```
            EXEC SQL
              CLOSE CustomerCursor;

            IF (SQLCODE <> 0) OR (SQLWN0 = 'W')
              /*
               * failed to close cursor
               * Handle in some way, such as informing the user (by showing it in a display
               * that something went wrong) or display an error in the report.
               */
            ENDIF;
```


### Code snippets used in the program
It's always a good idea to test select statements you write interactively  
(STRSQL to open the interactive menu).

After some testing, this is the select statement we have created,
```
SELECT custid, trim(FName) || ' ' || LName AS FullName, // triming to remove possible trailing whitespace
        city, purchase, pdate,
        'ontario' AS Province // we want the province of the customer to show which we use in the report (main routine logic)
    FROM BCI433LIB/ONTARIO
    WHERE Purchase > 400;

    UNION ALL // combines the tables without ordering, to help create the report

SELECT custid, trim(FName) || ' ' || LName AS FullName,
        city, purchase, pdate, 'Quebec' AS Province
    FROM BCI433LIB/QUEBEC
    WHERE Purcahse > 400;

    UNION ALL

SELECT custid, trim(FName) || ' ' || LName AS FullName,
        city, purchase, pdate, 'Manitobs' AS Province
    FROM BCI433LIB/Manitoba
    WHERE Purchase > 400;
```
**Note: The 400s that were hard coded in this test will be replaced with a variable to be more robust**

Procedure interface
```
            // Procedure interface
            // LowLimitIn passed to the program
            DCL-PI Main extPgm('PROVSQL'); // PROVSQL is the program name!
              LowLimitIn Packed(15:5);
            END-PI;
```
When you pass a number to a program from the command line, you need to declare  
it as 15 digits with 5 decimal positions. If you don't the program will crash.

**Data Structure to be used**

**The order of the fields in the data structure should match the order of the
col names in the SELECT statement.**
```
            DCL-DS CustomerRecord;
              CustID Char(6);
              FullName Char(31);
              City Char(20);
              Purchase Packed(7:2);
              PDate Date;
              Province Char(10);
            END-DS CustomerRecord;
```

We store the inputted number from the command line into another variable of a  
smaller type that's defined more realistically. We narrow/truncate the value.  
```
      C/Eject

       /Free
            LowLimit = LowLimitIn;

            //...
```

This subroutine uses a particular strategy of declaring the cursor and then 
immediately opening it
```
            BEGSR PREPAREFILES;

            EXEC SQL
              DECLARE ALLPROVCURSOR CURSOR
                FOR
                //...

            EXEC SQL
              OPEN ALLPROVCURSOR;

            // checking to see if there was a problem opening the cursor
            IF (SQLCODE <> 0) OR (SQLWN0 = 'W');
              ENDOFFILE = *ON;
            ENDIF;

            ENDSR;
```

Since the fields in CUSTOMERRECORD data structure were defined in the same   
order as the column names in the SELECT statement, we can just specify the data  
structure name itself and it will correctly fill in all the data members.

If the order of the fields in the data structure did not match the columns in  
the SELECT statement, we would have had to define each member individually.
```
            BEGSR GETROW;

            EXEC SQL
              FETCH NEXT
              FROM ALLPROVCURSOR
              INTO :CUSTOMERRECORD;

            IF SQLCODE <> 0 OR SQLCODE = 'W';
              ENDOFFILE = *ON;
            ENDIF;

            ENDSR;
```

In the main routine:
```
            DOW NOT (ENDOFFILE)
              //...
              IF IN01;
                // ...
              ENDIF;
              IF PROVINCEH = PROVINCE; // province is the same
                Write Detail;
              ELSE; // new province detected ...
                ProvinceH = Province;
                Write totals;
                write newprov;
                write detail;
              ENDIF;
```

Ending the program by cleaning up and obtaining some aggregated data.
```
            EXEC SQL
              CLOSE ALLPROVCURSOR;

              // ... approx. 28 more lines here
            ENDSR;
```
