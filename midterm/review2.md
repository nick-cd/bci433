# Midterm Review 2

Your program uses a display file called MOVIEDSF with the following attributes:

```DDS
               Calculate Movie Tickets                          MM/DD/YY
                                                                hh:mm:ss
                  Number of adults: 999                         UUUUUUUUU
                Number of children: 999

                  Amount Owing: 66,666.66
F3=Exit
```

## RECORD1

|Record/Constant|Definition|Indicator Used|Purpose of Indicator or Keyword|
|---------------|----------|--------------|-------------------------------|
|HH/DD/YY|system constant|||
|hh:mm:ss|system constant|||
|Number of adults|||||
|adults|3S 0||||
|Number of children|||||
|Children|3S 0||||

## RECORD2

|Field/Constant|Definition|Indicator Used|Purpose of Indicator or Keyword|
|---|---|---|---|
||||OVERLAY|
|Amount Owing||||
|Amount|7S 2|||
|F3=Exit|CA03|*IN03|||

Write an RPG program that uses the above display file MOVIEDF with the record
format RECORD1. Movie ticket prices as follows:

* Adults: $11.00
* Children: $6.00

Your program should display record 1 for entry. When the operator presses
enter, the program will calculate the amount. Record1 should display and
Record 2 display for entry. When the operator presses enter again, Record1
displays for entry. Pressing F3 will end the cycle.

**Note**:

* You must use free form file declaration to declare the display file
* Be sure to comment your code.

### My Answer

```RPGLE
DCL-F MOVIESPF Workstn;
EXFMT RECORD1;

DOW NOT(*IN03);
  amount = adults + children;
  WRITE RECORD1;
  EXFMT RECORD2;
  IF NOT(*IN03);
    adult = 0;
    children = 0;
    EXFMT RECORD1;
  ENDIF;
ENDDO;
```
