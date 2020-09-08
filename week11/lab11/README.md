# Lab 11 Notes

**NOTE:** runlab11.clle was not a requirement, you are not allowed to use it to demo!
This file was just meant to convieniently recompile and run my code while I was working on it.

### Description
In this lab, We were expected to implement 2 external functions (or exported functions) ```DayName``` and ```DateWords```
* ```DayName``` returns the name of the week day based on the date passed to it (2020-08-11 -> Friday)  
  similar to ```DayNumName``` in **DAYFUNCTS2** in lab 10.
* ```DateWords``` returns the full date based on the date passed to it (2020-08-11 -> Friday August 11, 2020)  
  dates are entered in the form:  
  ```yyyy-mm-dd```

There were also other helper functions prototypes (some supplied by the professor while others are custom)
* ```DayOfWeek``` implementation supplied by professor (returns the number of the day of the week based on the date passed.
  For ex. 2020-08-11 -> 5 since this date is a Friday which is the 5 day of the week, starting on Monday)
* ```FindDay``` returns the day of the month based on the date passed
* ```MonthNumName``` returns the month based on the date passed
* ```FindYear``` returns the year from the date passed  
Look at the source files themselves to see how they are implemented

### Files
* Similar to lab 10, **DATEPROTOS** contains prototypes to be copied to the source files that call/define the functions.
* **DATEPROCS** will contain all the definitions for the functions.
* **WHATDAYRPG** will contain the main routine. Result1 will contain the return value of ```DayName``` and Result2 will contain the return value of ```DateWords```
* **WHATDAYDSP** display device file like other labs, **CHANGE IT TO DISPLAY YOUR NAME**

### Compiling and Running

**Note:** replace <user_name> with your user name
**Note:** replace <src-pf> with the source physical file with modules are located in

```
CRTRPGMOD  MODULE(<user_name>/DATEPROCS) SRCFILE(<user_name>/<src-pf>) SRCMBR(DATEPROCS)
CRTRPGMOD  MODULE(<user_name>/WHATDAYRPG) SRCFILE(<user_name>/<src-pf>) SRCMBR(WHATDAYRPG)

CRTPGM     PGM(<user_name>/WHATDAY) MODULE(<user_name>/WHATDAYRPG <user_name>/DATEPROCS)

CALL       WHATDAY
```
