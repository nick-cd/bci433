# Week 3 Lecture Notes

This lab has 2 parts.

- The first part (part A) has you create a display file and an interactive
  application (with little math logic) using the display file in RPGLE.
- The second part (part B) expects you to add logic to the RPGLE to
  actually perform the calculations.

The RPGLE code changes from the first part to the second part. Check the
RPGLE code to know what's needed for each part.

## DDS

> Data Description Specifications (DDS) – a
> traditional mean to describe data attributes
> (such as the names and lengths of records and
> fields) on the IBM® i operating system.

we used this in the first lab when we created a physical file

### Display Files

Used as a blueprint to describing how a screen should look.  Used for
interactive applications.

Resultant object information when compiled:

- type: `*FILE`
- attribute: `.dspf`

We create display files with **screen designer** in RDi. This is all documented
in lab 3.

#### Records

In the first lab we had one record in our DDS code. This was because it
was representing a database table.

When we create display files (and printer files in a future lab) we
may have more records.

Examples of some records in DDS:

```DDS
     A          R GETINCOME
```

Records may have record level keywords/functions like so:

```DDS
     A          R YOURTAX                   CF03(03 'Exit Program')
     A                                      OVERLAY
```

- CF03(03 'Exit Program') - F3 turns on indicator 3 (more
  on indicators below). The 'Exit Program' is for semantics is has no purpose
  other than readability.
- OVERLAY - This record can displays along with another record

In a record we can have:

- Named fields
- Constants

##### Fields

Example of a field

```DDS
     A            INCOMEAMT      8Y 0B  5 23
```

- INCOMEAMT - name of field
- 8Y - the '8' is referring to the length and 'Y' is the data type (meaning
  numeric type)
- 0B - the '0' is referring to the number of decimal positions and 'B' means
  its both an input and output field
- 5 23 - refers to the position in the display file

Fields can have keywords or functions. Here are the keywords and functions we
have on INCOMEAMT:

```DDS
     A            INCOMEAMT      8Y 0B  5 23
     A                                      EDTCDE(2)
     A  60                                  DSPATR(PR)
     A  98                                  DSPATR(PC)
```

- EDTCDE(2) - see formatting
- DSPATR(PR) - Protected, this field cannot change by the user when it's
  set to be on.
- DSPATR(PC) - Position Cursor, the cursor will be automatically moved to this
  field when the indicator is on.

##### Constants

_Constants_ are labels that cannot change throughout the execution
of the program using the display file.

Examples of constants:

```DDS
     A                                  1  3USER
     A                                  1 71DATE
     A                                  6 13'Married?'
```

- USER - user running the program
- DATE - today's date
- 'Married' - label

#### Formatting

Each field can have their format settings modified in the editing
section. Formatting functions available are:

- EDTCDE (Edit Code) - Used for formatting numeric fields, you are able to
  select from a bunch of predefined formatting options. Some common ones:
  - EDTCDE(1) - no leading zeros, has decimal point, has commas, empty if 0
  - EDTCDE(2) - same but if empty, it will display '0'
  - EDTCDE(Y) - Used to format the date to: MM/DD/YY
- EDTWRD (Edit Word) - Custom format

## RPGLE

> RPGLE - Report Program Generator Language Environment

In lab 2 we used fixed form RPGLE. From now on we will use free-form RPGLE
syntax.

### Referencing our display file

In this lab, we use RPGLE to create a program that references our display file
as what's called a **work station file (workstn)**.

We can reference a display file with the code:

```RPGLE
       dcl-f INCOMTDSP workstn;
```

### Syntax

#### Variables

Expressions with variables should be familiar:

```RPGLE
       var = expression;
```

##### Named fields

When we referenced our display file, it brought in all the named fields
specified in the DDS code as variables ready for use in our program.

When your done with a named field's value you can clear them:  

```RPGLE
       CLEAR named-field
```

##### Indicators

_Indicators_ are essentially boolean variables given to any name in the display
file. When that indicator is on, the action on the name takes place.

there are 99 indicators, numbered from 0-99 (\*_IN(0-99)_)

They hold the values _\*ON (1)_ which is true or _\*OFF (0)_ which is
false.

Example assignment expression:

```RPGLE
       *IN98 = *ON;
```

Assigning indicators

```DDS
     A            MARRIED        1   B  6 23VALUES('Y' 'N')
     A  60                                  DSPATR(PR)
     A  97                                  DSPATR(PC)
     // ...
     A  97                              6 35'Blank Marital Status'
```

- DSPATR(PR) - MARRIED will become protected when indicator 60 is on
- DSPATR(PC) - Cursor will position itself to the MARRIED field when Indicator
  97 is on
- 'Blank Marital Status' - The label will show when indicator 97 is on.

###### Mapping function keys to indicators

```DDS
     A          R YOURTAX                   CF03(03 'Exit Program')
```

This specifies that F3 will turn on indicator _\*IN03_. The program
uses this to determine when to exit the program.

#### Select Constructs

##### If statements

```RPGLE
       IF condition;
         // ...
       ELSEIF;
         // ...
       ELSE;
         // ...
       ENDIF;
```

##### Select when

```RPGLE
       SELECT
         WHEN condition;
           // code ...
         WHEN other-condition;
           // code ...
         OTHER; // default branch
           // code ...
       ENDSL;
```

#### Do while

```RPGLE
       DOW condition;
         // ...
       ENDDO;
```

#### Subroutines

_Subroutines_ are Blocks of logic that contain possibly
repeating code. Subroutines do not accept arguments.

Subroutines take the form:

```RPGLE
       BEGSR name;
         // code ...
       ENDSR;
```

You can call subroutines with:

```RPGLE
       EXSR name;
```

### User interaction

With the display file declared, we can write records (defined in the DDS code)
to a device file and if needed, prompt the user for input.

The `EXFMT` operation accepts a record name, writes the record to the
display device and prompts the user for input.

In the lab code (RPGLE), after referencing the display file (before loop), I
do:

```RPGLE
        EXFMT GetIcome; /*
                         * Prompt user for INCOMEAMT, MARRIED, STUEXPENSE,
                         * DONATIONS
                         */
```

Later in the code you see this (in the loop):

```RPGLE
       WRITE GETINCOME; // Redisplay - don't prompt
       EXFMT YourTax; // prompt for YourTax
```

This is how you would use overlay (displays GETINCOME record with the YOURTAX
record. This should work as long as fields in GETINCOME and YOURTAX do not
overlap in the DDS code.

Note: that YourTax displays calculated data
based on what the user has entered. We prompt to pause execution.

### Ending a program

A RPGLE program ends with these two lines:

```RPGLE
       *INLR = *ON;
       RETURN;
```

- \*INLR - stands for "Last Record Indicator"
- RETURN - return control to operating system.
