# Week 6 Notes

Lab 6 came in two parts. It had a part A and part B.

* Part A - we created a dynamically linked application
* Part B - we created a statically linked application

I discuss the difference between them below

## Part A

### Logical files

Logical files derive their data from a physical (data) file. We can create them
with:

* SQL, with the CREATE VIEW command
* DDS, by creating a member of type .lf

> views - solely selected records.
> index - records in a certain order.
>
> In SQL, you can't create an object that gives you both order and selected
> records. Logical files allow for this.
>
> Logical files gives us ability to order by an index and can get selected
> records. All done in a single object.

Creating logical files is simple. Here is an example of one used in this
application:

```RPGLE
     A          R SHIFTWEEK                 PFILE(SENECAPAY/SHIFTWEEK)
     A          K EMPNUM
     A          S WORKSHIFT                 COMP(EQ '1')
```

* R: record format.
  PFILE(...) -> specifies the data file to base itself off of
* K: key field, or index field.
  Field that we will order by. In this case the logical file will order by
  the employee number.
* S/O: select / omit.
  Specifies conditions on what data to include/restrict

#### Retrieve user profile

The ```RTVUSRPRF``` command can get information about a user

In this CLLE program, we use it to get a user's output queue and output queue
library:

```RPGLE
            /* Variables */
            DCL &OUTQ *CHAR 10
            DCL OUTQLIB *CHAR 10

            RTVUSRPRF OUTQ(&OUTQ) OUTQLIB(&OUTQLIB)
```

We use this information for other operations:

```RPGLE
            CLROUTQ &OUTQLIB/&OUTQ
```

This removes all user's spooled files. Typically in the work place you **WOULD
NOT DO THIS**. We told to do this as none of our work is that
important. Thus, doing this cleans up our output queue so that the
requested reports show at the end of this application, making it easier for
demoing.

### Application logic

We had to create a simple wrapper (called driver program) to our lab 5
application using CLLE. The wrapper program is text based, it sends
messages to the user and the user responds with some numeric value to specify
what option they would like to select.

The options given to the user were what employees they would like to see based
on their work shift. We query employees for their work shift by
creating logical files before hand for all possible workshifts. When the user
makes a selection in the program, we override the SHIFTWEEK data file
accordingly before running our lab 5 RPGLE application.

#### CL Programming

TODO: IF, THEN, ELSE examples

```RPGLE
```

```CLLE
```

#### Parameter Passing

When we use our RPGLE program, we have to pass it a parameter. We create what's
called a procedure interface in the RPGLE program to allow for this:

```RPGLE
           DCL-PI MAIN EXTPGM('PAYPGM'); // MAKE SURE THIS MATCHES YOUR
             SHIFTTYPE CHAR(30);         // PROGRAM NAME
           END-PI;
```

When we call our program in our CLLE driver program, we include the PARM
parameter:

```RPGLE
           CALL PAYPGM PARM(&SHIFTTYPE)
```

SHIFTTYPE is a variable:

```RPGLE
           DCL &SHIFTTYPE *CHAR 30
```

we use it to hold the required shift type as a string. We give the string to
our the RPGLE program when then writes it to the CONFIRM display file. So before
our call to the RPGLE program we have this statement:

```RPGLE
           CHGVAR &SHIFTTYPE 'NIGHT SHIFT'
```

Which assigns to the variable.

##### Why is the variable nessecary

This is a question you might have on your mind. For part A, it doesn't matter
whether you have it or not. For part B, you must have this variable hold the
string and pass the variable to the RPGLE program.

#### Override printer file

Before we call the RPGLE program we have a statement:

```RPGLE
           OVRPRTF FILE(PAYRPT) SPLFNAME(NIGHTSHIFT)
```

This is specifying when a new report with the name PAYRPT will use the
name _NIGHTSHIFT_ in this case.

#### Displaying the spooled file

After the RPGLE application is complete, it will create a spooled file based on
the printer file blueprint, PAYRPT. It will be under whatever name was
specified in the OVRPRTF statement as mentioned before. To display the
spooled file, we have the statement the somewhat like this:

```RPGLE
           DSPSPLF FILE(SHIFTWEEKS) SPLNBR(*LAST)
```

This displays the spooled file under the name _SHIFTWEEKS_. You might be
wondering why is the SPLNBR(*LAST) argument needed. we need this because of
the case where the user decides to create more than one report under the same
name (that is, select the same option twice in the CLLE driver program). When
there are more than one spooled file under the same name in a user's output
queue the DSPSPLF command wants to know which one. If you are not specific
enough, the DSPSPLF command will fail and the program will crash.

#### Displaying the created spooled file name

Near the end of the program (after the loop) we have the line:

```RPGLE
           WRKOUTQ &OUTQLIB/&OUTQ
```

This allows the user to interact with their output queue.

### Part B

This part involved making the following changes:

* ```CALLPRC``` instead of ```CALL```
* When compiling both the RPGLE program and the CLLE program you use the  
  ```CRTRPGMOD``` and ```CRTCLMOD``` commands respectively.
* On the command line (after compiling) go to the source phyical file (your  
  container) that has all your source code. (`WRKMBRPDM <source-physical-file>`)
* Execute the command: `CRTPGM PGM(PAYROLL) MODULE(RUNPAYPGM PAYPGM)`
  This combines the modules RUNPAYPGM and PAYPGM and created the program
  PAYROLL  
  **The module that is in control is always specified first**.
  Since RUNPAYPGM calls PAYPGM it should be the first argument to WRKMBRPDM.

This effectively creates an application this is now statically linked.

When demoing, you need to prove that your payroll program is statically linked
you must show its modules. You can do that with this command:

```RPGLE
DSPPGM PAYROLL DETAIL(*MODULE)
```

## Dynamic call Vs Static call

Dynamic call:
> Every time a ```CALL``` statement is ran, the linkage process occurs.

Static Call:
> Linkage done before run-time.

### Exta Notes

> The Check Object (CHKOBJ) command checks object existence and  verifies the
> user's authority for the object before trying to access it.  If the object
> exists and the user has the proper authority for  the object, no error
> messages display to the user.  

```RPGLE
CHKOBJ OBJ(BCI433LIB) OBJTYPE(*LIB) AUT(*CHANGE)
```

You would get the error:
> Not authorized to object BCI433LIB in QSYS.

with the message ID: **CPF9802**
