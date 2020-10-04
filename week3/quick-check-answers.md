# Week 3 Quick Check Questions

## Fill in the blank and true/false

1. DDS (Data Description Specifications) is a traditional mean to describe
   **_data attributes_** on IBM i.
2. In QDDSSRC.*file.pf-src, you create, code and save a member name STUDDSPF
   with the DSPF type. That means you've created a display file – STUDDSPF.
   **_True_**
3. In DDS, we use EDTCODE to edit **_numeric fields_** fields in display
   or printer files.
4. In RPGLE, *INLR means **_Last Record Indicator_**
5. In the DDS code of Lab 3, we use the keyword (or function)
   **_Position Cursor (DSPATR(PC))_** to set up data validation to the field
   MARRIED ('Y' and 'N').
6. In the source code (LPEX) editor, free-format RPGLE code can be anywhere
   after column **_7_**
7. A Display file statement in an RPGLE program requires a
   **_DCL-F (Declare File)_** statement.

## Short answer questions

Step 1. What are the three types of a (named) field?

* Named
* Reference
* ~~Not sure what else goes here~~

Step 2. Name 4 files that we can create with DDS code?

* Printer files
* Display files
* Physical files

* Logical files

Step 3. In DDS, an indicator, e.g. 90, can apply to a named field or to the
field's attributes (e.g. 'Protected'). What are the different results?

* If applied to a named field, the field will display when the indicator
  is on
* If applied to an attribute, the field will have that attribute when the
  indicator is on.

Step 4. In RDi Screen Designer, a display file's field shows like 666,666,666.
What kinds of properties or keywords are on the field?

* 9 for length
* Y - numeric
* Edit code is 1 (```EDTCDE(1)```)

Step 5. What are the difference(s) between EXFMT and WRITE in RPGLE syntax?

* Write -> Displays screen record
* EXFMT -> Displays screen record and prompts for user input

Step 6. How to declare a externally-described display file STUDMARKS.*file.dspf
in RPGLE program?

`DCL-F STUDMARKS WORKSTN;`
