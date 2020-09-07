# Lab 10 Notes

Get the complete code from the source files themselves

### DAYSRPG code

```
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
function is called. In our code, we copy a file's contents which includes the
prototypes. This is a better alternative than to just copy the prototype
everywhere it is used (as it may be used in many places).


### DAYPROTO

prototypes come in the form:
```
DCL-PR name return-type(size);
  // parameters...
  name type(size);
END-PR;

```

This source file contains all (2 in this case) prototypes:

```
        // The Prototype for DayNumName
        DCL-PR DayNumName Char(9); // 9 characters are going to be returned
          DayIn Packed(1); // Packed of size 1 will be passed as a paramter
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

```
        Ctl-opt NoMain; // no need for *INLR = *ON
       /COPY <pf-src>,DAYPROTO // Get the prototype code

        DCL-PROC DayNumName EXPORT; // the user defined function
          DCL-PI *N Char(9); // What is returned by the function
            Number Packed(1); // What is the function accepts
          END-PI;
          DCL-S DayName Char(9); // Local variable

          // ... function logic ...

          Return DayName; // 9 Chars to be returned by the user defined function
        End-Proc; // Terminate Procedure
```

#### Notes:
* DCL-PROC -> Declare Procedure. statement that specifies that we plan to
define the function.
* DCL-PI -> Declare Procedure Interface. Actually recieving and returning data
* DCL-S -> Declare Standalone variable
  * When declared inside a function, it is a local variable
  * When declared outside the function, it is a global variable
* EXPORT -> Allows the procedure to be called outside the module. If this was
omitted, only this module can call this procedure.
* *N -> Place holder name used when we don't plan refer to something (a dummy
  name

##### Ctl-opt NoMain;

This means that the following procedure defined in this source file will not
have a main routine and no logic cycle will be used. **Since there is no main
routine, IT MUST BE COMPILED AS A MODULE**

The logic cycle provides a program with initialization, termination procedure
(when we had *INLR = *ON), and automatic input and output at specific points in
the logic cycle. All of our programs we have made(all of which are procedural, 
where the programmer controls how operations are to be completed) had the logic 
cycle being supported. If we did not make procedural programs and thus, only
use the logic cycle, it would be considered a non-procedural program.

### DAYFUNCTS2

A year later someone makes a better DAYFUNCTS function

```
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
        End-Proc; // Terminate Procedure

```

#### Notes:

* **This solution is flawed as it cannot handle a date > 7**
* DatFmt(*USA) All dates in this module will be written in USA's format
* DayData is just a data structure without the last line (last line declares it
  as an array). 
* DayArray Char(9) Dim(7) Pos(1);
  * Char(9) -> Size and type of each element
  * Dim(7) -> Dimension, amount of elements in the array
  * Pos(1) -> Starting offset of the array (in this case, 1st byte of the array)
* We use DayArray (with a position number) to access the array.

### RUNLAB10

Automates the compilation, displaying (of function code), and executing of the
application using both versions of the DAYFUNCTS module.

since the implementation of DayNumName in DAYFUNCTS2 cannot handle input > 7,
this will be used as an indicator to let the professor know that you have wrote
the array version of the function correctly. The professor also required that
you display both DAYFUNCTS source before you run the program also to prove that
you wrote it correctly

```
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


        /* One year later someone constructs a better performing DAYFUNCTS module */

        // compile DAYFUNCTS2 module.
        // NOTE: DAYSRPG had no changes and thus does not need to be recompiled
        CRTRPGMOD  MODULE(DAYFUNCTS2) SRCFILE(LAB10) SRCMBR(DAYFUNCTS2)

        // ...

        ENDPGM
```
