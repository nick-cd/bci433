# Lab 8 Notes

There were two options for this lab:

* Challenge lab
* Variation lab

You were only expected to complete **one** of them (you had to choose between them).  
The challenge lab gave you the chance of getting 100% on the lab and the other  
variation lab only gave you the chance of getting a max mark of 75%.

I chose to do the challenge lab, who wouldn't want a challenge? Right?

In this lab, we had to create an application that queries Blue Jay players from
a table given some criteria and displays the result to the screen using a 
[subfile](https://www.ibm.com/support/knowledgecenter/en/ssw_ibm_i_72/rzasc/usesubfile.htm).

A subfile facilitated writing multiple records to a display file with the same 
record format name (similar to writing multiple records to one record format 
when dealing with a printer file). A subfile consists of two record formats:

* subfile-record format - used to write our data to (that is, transfer data 
  from the program to the subfile). It contains all the fields.
* control-record format - used to display the subfile after all rows were 
  written. That is it:
  > causes the physical read, write, or control operations of a subfile to take 
  > place 

  It controls the behaviour of the subfile as a whole. It also contains static data,
  such as the table columns on the result display.

Watch this [video](https://www.youtube.com/watch?v=sXZ_HH7Qx2k) for a nice 
intro to subfiles.

## DDS Code

A subfile is specified in the DDS code  
In screen designer, you'd just create a subfile record, drag and drop it in.  
This will automatically create the CTL1 (the control-record-format) and the  
SFL1 (the subfile-record format)

### The control record format

The main lines in the control record format are specifed here:
```
     A          R SFL1                      SFL // part of subfile-record format
     // ...
     A          R CTL1                      SFLCTL(SFL1)
     A  98                                  SFLDSPCTL
     A  98                                  SFLDSP
     A  98                                  SFLEND(*MORE)
     A                                      SFLPAG(14)
     A                                      SFLSIZ(100)
     A N98                                  SFLCLR
```

##### SFLCTL(SFL1)

Specifies that this control record is associated with the passed subfile-record name.

##### SFLDSPCTL & SFLDSP

Specifies that the control record and the subfile record should display when 
indicator 98 is on (in my case).

##### SFLEND(``*```MORE)

Toggles the display of _More_ at the bottom right of the screen.

##### SFLCLR

When then is on (in my case, when indicator 98 is off), when a write operation 
is done on the control record, the subfile is effectively cleared.

##### SFLPAG(14)

Specifies how many records are to be shown at a time on a page.

##### SFLSIZ(100)

Specifies the max amount of records that can be stored in the display file (how 
many records can be written to the subfile-format record).

### The Subfile record format

```
     A          R SFL1                      SFL
     A            HEIGHT    R        O  9 56REFFLD(AMERICANLG/HEIGHT +
     A                                      BASEBALL20/AMERICANLG)
     A            WEIGHT    R        O  9 65REFFLD(AMERICANLG/WEIGHT +
     A                                      BASEBALL20/AMERICANLG)
     A            BIRTHDATE R        O  9 43REFFLD(AMERICANLG/BIRTHDATE +
     A                                      BASEBALL20/AMERICANLG)
     A            HITSTHROWSR        O  9 36REFFLD(AMERICANLG/HITSTHROWS +
     A                                      BASEBALL20/AMERICANLG)
     A            FULLNAME      21   O  9  2
     A            POSNAME        9   O  9 25
```
HEIGHT, WEIGHT, BIRTHDATE, HITSTHROWS are all reference fields. They are 
referencing AMERICANLG table.

**How to reference fields**
* Find the table in BASEBALL20 library
* Right-click
* show in table -> fields
* drag and drog fields from the listing into screen designer

FULLNAME and POSNAME are named fields of length 21 and 9 respectivly.

### Logical file

The JAYS logical file (JAYS.lf) selects simply selects all the players on team 
3 (which is the Blue Jays). Recall:

> Logical files give us the ability to order by an index and can get selected 
> records. All done in a single object.

### Menu Display

The JAYSMENU display file (JAYSMENU.dspf) shows three options which the user 
can select by typing a 1, 2 or 3. If the user decides to input a incorrect 
value. They will be presented with an error message in reverse image:

```
     A  99                                  DSPATR(RI)
     A  99                                  ERRMSG('Value entered for field is +
     A                                              not valid.  Valid values +
     A                                              listed in messages help.')
     A
```

The ```ERRMSG``` function will show the error on the status line of the display 
rather than another label.

## CLLE code

* Ensures BASEBALL20 is in my library list
* Overrides the AMERICANLG table with my logical file (mentioned above)
* Calls my SQLRPGLE program

## SQLRPGLE code

**Declarations**
```
       DCL-F BBALLDSP WORKSTN SFILE(SFL1:RECNO);

       DCL-S RECNO ZONED(4:0);
```

Declares BBALLDSP (Subfile) as a display file to be used in this program (work 
station file). The ```SFILE(SFL1:RECNO)``` part is specifying that the 
standalone field, RECNO, will be used as the record number. This indicates to 
the run time which record should be written to.

It is required that RECNO must be 4 digits length with no precision.

**Showing the subfile to the screen**

```
       BEGSR SHOWRESULTS;
         EXSR FETCHCUR;
         DOW NOT(ENDOFFILE);
           RECNO = RECNO + 1;
           WRITE SFL1;
           EXSR FETCHCUR;
         ENDDO;
         EXFMT CTL1;
       ENDSR;
```

* ```RECNO = RECNO + 1``` - RECNO must be set correctly before writing to the 
  subfile record
* ```WRITE SFL1``` - Transfer data to the display file at the record specified 
  by the current value of RECNO
* ```EXFMT CTL1``` - when all the records are transferred to the display file 
  (with the subfile record), you perform an EXFMT operation on the control 
  record to transfer the data to the display device.

**Clearing the subfile record**

```
         *IN98 = *OFF;
         WRITE CTL1;
         *IN98 = *ON;
         RECNO = 0;
```
For my application, when indicator 98 is off, that effectively turns on SFLCLR 
mentioned before. When a write operation is done on the control record, all the 
contents of the subfile record are cleared.
