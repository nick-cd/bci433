# Week 3 Lecture Notes

This lab was split into 2 parts.

* The first part (part A) has you create a display file and an interactive 
  application (with little math logic) using the display file in RPGLE.
* The second part (part B) simply expects you to add logic to the RPGLE to 
  actually perform the calculations.

Only the RPGLE code changes from the first part to the second part. Check the 
RPGLE code to know which code is needed in which part.

## DDS

> Data Description Specifications (DDS) – a
> traditional mean to describe data attributes
> (such as the names and lengths of records and
> fields) on the IBM® i operating system.

This was used in the first lab when we created a physical file

### Display Files

Used as a blueprint to show how a screen is supposed to display to the user.  
Used for interactive applications.

When compiled it is:
* type: ```*FILE```
* attribute: ```.dspf```

We create display files with **screen designer** in RDi. This is all documented 
in lab 3.

#### Records

In the first lab we only had one record in our DDS code. This was because it
was representing a database table.  
When we create display files (and printer files in a future lab) we can have
multiple records.

Examples of some records in DDS:
```
     A          R GETINCOME
```

Records may have record level keywords/functions like so:
```
     A          R YOURTAX                   CF03(03 'Exit Program')
     A                                      OVERLAY
```
* CF03(03 'Exit Program') - says when F3 is pressed turn on indicator 3 (more
  on indicators below). The 'Exit Program' is for semantics is has no purpose
  other than readability.
* OVERLAY - This record can be displayed along with another record

In a record we can have:
* Named fields
* Constants

##### Fields

Example of a field
```
     A            INCOMEAMT      8Y 0B  5 23
```
* INCOMEAMT - name of field
* 8Y - the '8' is referring to the length and 'Y' is the data type (meaning
  numeric only)
* 0B - the '0' is referring to the number of decimal positions and 'B' means
  its both an input and output field
* 5 23 - refers to the position in the display file


Fields can have keywords or functions. Here are the keywords and functions we
have on INCOMEAMT:

```
     A            INCOMEAMT      8Y 0B  5 23
     A                                      EDTCDE(2)
     A  60                                  DSPATR(PR)
     A  98                                  DSPATR(PC)
```
* EDTCDE(2) - see formatting
* DSPATR(PR) - Protected, this field cannot be changed by the user when it's
  set to be on.
* DSPATR(PC) - Position Cursor, the cursor will be automatically moved to this
  field when the indicator is on.

##### Constants

Constants, very simply, are labels that cannot change throughout the execution
of the program using the display file.

Examples of constants:
```
     A                                  1  3USER
     A                                  1 71DATE
     A                                  6 13'Married?'
```
* USER - user running the program
* DATE - today's date
* 'Married' - label

#### Formatting

Each of these can be given formatting settings in the editing section when a
field is selected in screen designer. Formatting functions available are:

* EDTCDE (Edit Code) - Used for formatting numeric fields, you are able to
    select from a bunch of predefined formatting options. Some common ones:
  * EDTCDE(1) - no leading zeros, has decimal point, has commas, empty if 0
  * EDTCDE(2) - same but if empty, it will display '0'
  * EDTCDE(Y) - Used to format the date to: MM/DD/YY
* EDTWRD (Edit Word) - Custom format

## RPGLE

> RPGLE - Report Program Generator Language Environment

In lab 2 we used fixed form RPGLE. From now on we will use free-form RPGLE
syntax.

### Referencing our display file

In this lab, we use RPGLE to create a program that references our display file
as what's called a **work station file (workstn)**.

We can reference a display file with the code:

```
dcl-f INCOMTDSP workstn;
```

### Syntax

#### Variables

Expressions with variables should be very familiar:

```
var = expression;
```

##### Named fields

When we referenced our display file, it brought in all the named fields
specified in the DDS code as variables ready to be used in our program.

When your done with a named field's value you can clear them.  
Named fields can be cleared with:

```
CLEAR named-field
```

##### Indicators

Indicators are essentially boolean variables given to any name in the display 
file. When that indicator is on, the action on the name takes place.

They are numbered from 0-99 (*IN(0-99))

They can only hold the values *ON (1) which is true or *OFF (0) which is false.

Example assignment expression:

```
*IN98 = *ON;
```

Assigning indicators

```
     A            MARRIED        1   B  6 23VALUES('Y' 'N')
     A  60                                  DSPATR(PR)
     A  97                                  DSPATR(PC)
     // ...
     A  97                              6 35'Blank Marital Status'
```

* DSPATR(PR) - MARRIED will be protected when indicator 60 is on
* DSPATR(PC) - Cursor will be positioned to the MARRIED field when Indicator 97 
  is on
* 'Blank Marital Status' - The label will be shown only when indicator 97 is 
  on.

###### Mapping function keys to indicators

```
     A          R YOURTAX                   CF03(03 'Exit Program')
```

This specifies that *IN03 will be turned on when F3 is pressed. The program 
uses this to determine when to exit the program.

#### Multiple select constructs

##### If statements

```
IF condition;
  // ...
ELSEIF;
  // ...
ELSE;
  // ...
ENDIF;
```

##### Select when

```
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

```
DOW condition;
  // ...
ENDDO;
```

#### Subroutines

Subroutines are very similar to functions. Blocks of logic that contain  
possibly repeating code. Subroutines however, do not accept arguments.

Subroutines take the form:

```
BEGSR name;
  // code ...
ENDSR;
```

You can call subroutines with:

```
EXSR name;
```

### User interaction

With the display file declared, we can write records (defined in the DDS code)
to a device file and if needed, prompt the user for input.

The ```EXFMT``` operation accepts a record name, writes the record to the
display device and prompts the user for input.

In the lab code (RPGLE), after referencing the display file (before loop), I 
do:

```
EXFMT GetIcome; // Prompt user for INCOMEAMT, MARRIED, STUEXPENSE, DONATIONS
```

Later in the code you see this (in the loop):

```
WRITE GETINCOME; // Redisplay - don't prompt
EXFMT YourTax; // prompt for YourTax
```

This is how you would use overlay (displays GETINCOME record with the YOURTAX 
record. This should work as long as fields in GETINCOME and YOURTAX do not 
overlap in the DDS code.

Note: that YourTax does not accept any data it just displays calculated data 
based on what the user has entered. We just prompt to pause execution.

### Ending a program

A RPGLE program ends with these two lines:

```
*INLR = *ON;
RETURN;
```

* *INLR - stands for "Last Record Indicator"
* RETURN - return control to operating system.
