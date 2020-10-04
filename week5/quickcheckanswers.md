# Week 5 Quick Check Questions

## Fill in the blanks

1. The first record format in a printer file DDS code is an **_Absolute_**
   record.
2. A printer file is an object whose object type is **_*file_**
3. The constant in Palette that is solely available in Report Designer for
   Printer file (not for screen files) is: **_Page Number_**

## Short Answer Questions

Step 1. In RDi Report Designer, what is the easiest way to create a data
field in a record format from a db table's column?

Naviagate to the table in the remote systems view, right-click, show in table ->
fields. Then drag a field from the table into the display file to create
a data field (or reference field).

Step 2. What is the purpose to create the design report in RDi Report Designer?

Displays all our created record formats all at once, useful for ensuring
alignment between fields part of different record formats.

Step 3. The two physical files SHIFTWEEK and SHIFTRATES are in library
SENECAPAY. What you should do before compiling or running the RPGLE program?

Ensure that SENECAPAY is in library list

Step 4. Write a CL command to override a database file and give an explanation.

`OVRDBF __ORIG-DB-FILE__ __OVERRIDE-DB-FILE__`
When this statement is ran, *ORIG-DB-FILE* will replace *OVERRIDE-DB-FILE*
instead
