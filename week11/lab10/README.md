# Lab 10 Notes

Get the complete code from the source files themselves

## DAYSRPG code

```RPGLE
        DCL-f DayDsp Workstn;

        // the '/' must be in column 7
        // src-pf -> source physical file name
        // member -> member within the specified source physical file. For this
        // application specifically, this will be DAYPROTO.
       /COPY <src-pf>,<member>

        EXFMT INPUT;
        DOW NOT(*IN03);
          // DayNumName is a user defined function
          DayName = DayNumName(DayIn);
          // ...
        ENDDO;
        *INLR = *ON;
        RETURN;
```

```DayNumName``` is a user defined function. Thus, the RPGLE compiler will have
no knowledge of it and flag it as a error. We need to let the RPGLE compiler
know that this is a valid name. We do this by including a prototype before the
call to the function. In our code, we copy a file's contents which includes the
prototypes. This is a better alternative than to copy the prototype manually
everywhere we use it.

### DAYPROTO

prototypes come in the form:

```RPGLE
DCL-PR name return-type(size);
  // parameters...
  name type(size);
END-PR;

```

This source file contains all (2 in this case) prototypes:

```RPGLE
        // The Prototype for DayNumName
        DCL-PR DayNumName Char(9); // 9 characters is the return type
          DayIn Packed(1); // Packed of size 1 is the paramter
        END-PR;

        // The Prototype for MonthNumName (used in lab 11)
        // Used to support a more sophisticated Day Name like
        // Sunday April 5, 2020
        DCL-PR MonthNumName Char(9);
          MonIn Packed(2);
        END-PR;
```

consider this **DAYPROTO** file to be analogous to a C header file

### DAYFUNCTS

```RPGLE
        Ctl-opt NoMain; // no need for *INLR = *ON
       /COPY <pf-src>,DAYPROTO // Get the prototype code

        DCL-PROC DayNumName EXPORT; // the user defined function
          DCL-PI *N Char(9); // Return type
            Number Packed(1); // What is the function accepts
          END-PI;
          DCL-S DayName Char(9); // Local variable

          // ... function logic ...

          Return DayName; // Return 9 Chars
        End-Proc; // End the procedure
```

#### Notes

* DCL-PROC -> Declare Procedure. statement that specifies that we plan to
define the function.
* DCL-PI -> Declare Procedure Interface. Actually recieving and returning data
* DCL-S -> Declare Standalone variable
  * When declared inside a function, the variable is local
  * When declared outside the function, the variable is global
* EXPORT -> Allows for the use of the procedure outside the module. If this was
omitted, it would have been private to the module.
* *N -> Place holder name used when we don't plan refer to something (a dummy
  name

##### Ctl-opt NoMain

This means that the following procedure defined in this source file will not
have a main routine and no logic cycle is in use. **Since there is no main
routine, YOU MUST COMPILE THIS FILE AS A MODULE**

The logic cycle provides a program with initialization, termination procedure
(when we had *INLR = *ON), and automatic input and output at specific points in
the logic cycle. All our programs we have made(Which were are procedural,
where the programmer controls how operations are to happen) had the logic
cycle supported. If we did not make procedural programs and thus, soley
use the logic cycle, it would be a non-procedural program.

### DAYFUNCTS2

A year later someone makes a better DAYFUNCTS function

```RPGLE
        Ctl-opt NoMain DatFmt(*USA);

          // ...

          DCL-DS DayData;
            *n Char(9) Inz('Monday'); // *n -> we're not going to give a name
            *n Char(9) Inz('Tuesday');
            *n Char(9) Inz('Wednesday');
            *n Char(9) Inz('Thursday');
            *n Char(9) Inz('Friday');
            *n Char(9) Inz('Saturday');
            *n Char(9) Inz('Sunday');

            DayArray Char(9) Dim(7) Pos(1); // array declaration
          END-DS;

          Return DayArray(number); // Return an element of the array
        End-Proc; // End Procedure

```

#### Array Solution Notes

* **This solution has a bug as it cannot handle a date > 7**

* DatFmt(*USA) All dates in this module use USA's format
* DayData is a data structure without the last line (last line declares it
  as an array).
* DayArray Char(9) Dim(7) Pos(1);
  * Char(9) -> Type and size of each element
  * Dim(7) -> Dimension, amount of elements in the array
  * Pos(1) -> Starting offset of the array (in this case, 1st byte of the array)
* We use DayArray (with a position number) to access the array.

### RUNLAB10

Automates the compilation, displaying (of function code), and executing of the
application using both versions of the DAYFUNCTS module.

since the implementation of DayNumName in DAYFUNCTS2 cannot handle input > 7,
this is an indicator to let the professor know that you have wrote
the array version and did not run the same program twice. The professor also
required that you display both DAYFUNCTS source before you run the program also
to prove that you wrote working code.

```RPGLE
        PGM

        // compile DAYFUNCTS and DAYSRPG as modules
        CRTRPGMOD  MODULE(DAYFUNCTS) SRCFILE(LAB10) SRCMBR(DAYFUNCTS)
        CRTRPGMOD  MODULE(DAYSRPG)   SRCFILE(LAB10) SRCMBR(DAYSRPG)

        // create the executable
        CRTPGM     WHATDAY MODULE(DAYSRPG DAYFUNCTS)

        // print message to screen
        SNDUSRMSG  MSG('Program using Select Statement Module DAYFUNCTS')

        // Display Program
        // Display modules in the program WHATDAY
        DSPPGM     PGM(WHATDAY) DETAIL(*MODULE)

        // Display Physical File member
        // Display source code of DAYFUNCTS
        DSPPFM     FILE(DM433D09/LAB10) MBR(DAYFUNCTS)

        // execute the newly compiled program
        CALL       WHATDAY 'SELECT SOLUTION'


        /*
         * One year later someone constructs a better performing DAYFUNCTS
         * module
         */

        // compile DAYFUNCTS2 module.
        // NOTE: DAYSRPG had no changes and thus we do not need to recompile it.
        CRTRPGMOD  MODULE(DAYFUNCTS2) SRCFILE(LAB10) SRCMBR(DAYFUNCTS2)

        // ...

        ENDPGM
```
