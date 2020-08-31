# Week 5 Notes

**Note: Source code is in the week 6 directory**  
For lab 5 code, take a look at PAYPGM.rpgle, CONFIRM.dspf, and payrpt.prtf

### Printer files

Very simply, printer files specify a blueprint on how we would like our printer
files to appear when created.

#### Creating

1. Add a member to a desired source physical file and have its type be: .prtf.
2. When you open that file, report designer should appear.
   in. **The first record is alwaydss the absolute record**
4. Every other record is a relative record (relative to the absolute record).

_After designing all the records..._

5. When the absolute record and the relative records are complete, above the
   designer section, there is a report controls section, you want to select the
   design reports radio button.
6. Select new and give a name to the printer file
7. Select each record one at a time and click the add button for each. **Order matters!**
   This will place all the records you designed before all on one page.
8. Make any adjustments necessary
9. Finally, compile the code

#### Boiler plate printer file

Printer files often take the form:
1. Heading information (title, column headings). May be reused upon overflow.
2. Detail records. Reused many times.
3. Summary information (used once, bottom of the report)

### RPGLE Code



#### Keyed files in RPGLE

RPGLE requires that the record format name must be different than the table
name itself. This is the reason for the RENAME(...) call after the file name
declaration for SHIFTWEEK. SHIFTRATES is not a table, so RENAME() in not
needed.

```
// data file declarations
DCL-F SHIFTWEEK KEYED USAGE(*INPUT) RENAME(SHIFTWEEK:SHIFTWEEKR);
DCL-F SHIFTRATES DISK USAGE(*INPUT);
```

#### Overflow

Overflow happens when an RPGLE program reaches the end of a page when creating
a report. We must give this condition an indicator, we do this in the
declaration of the printer file itself:

```
DCL-F PAYRPT PRINTER OFLIND(*IN01);
```

This is saying that we want indicator 1 to specify when overflow is occurring.

##### Main Loop

The main do while loop has this condition:

```
DOW NOT %EOF(SHIFTWEEK);
  // ...
ENDDO;
```

It uses the built-in %EOF() function. Keep reading until the end of the file
has been reached.

Within the main loop of the application, you will see this code:

```
IF *IN01;
  WRITE TITLE;
  WRITE COLHDG;
  *IN01 = *OFF;
ENDIF;
```

When a new page starts while creating our report, indicator 1 will be on. In
our code, when we verify indicator 1 is on, we write our **heading information** again.

#### Printer file and data file operations

* READ - read a record and point to the next record
* WRITE - write a (printer/screen) record to a printer/display file

#### Half rounding

When an arithmetic expression needs to be rounded, we can use the half round
operator:

```
EVAL(H) hourlyrate = hourlyrate * 1.07;
```

EVAL(H) denotes the expression is to be half rounded (5+ round up, otherwise
down).

### File Overriding

File overriding basically says: "Every time this file is referenced in our
program, use this alternative file instead".

On the command line, type:

```
STRSQL
```

To start an interactive SQL statement

Then type the SQL statement:

```
CREATE VIEW NIGHTS AS
  SELECT *
    FROM SENECAPAY/SHIFTWEEK
    WHERE WORKSHIFT = '3'
```

Then override our data file with the view.

```
OVRDBF SHIFTWEEK NIGHTS
```

Now anytime SHIFTWEEK is referenced, it will use our view instead. This is a
great way to reuse an RPGLE program with a different data set without
recompiling the code. This is a major concept for lab 6.

You can use:

```
DSPOVR SHIFTWEEK
```

To prove that SHIFTWEEK is being overridden with NIGHTS.


To remove the override:

```
DLTOVR SHIFTWEEK
```