# Lab 9B example code

#### CSTCURSOR.sqlrpgle

Shows a bolier plate program to fetch all data from a multiple row select
statement. Thus, it is of similar form to the code created for the lab 9b 
assignment. Direct your attention to the how the subroutines were made. Your
program will be very similar in that regard. Explainations were already made
in the lab 9b source code's README file

#### CSTCURSOR2.sqlrpgle

This version does not properly close the cursor, which can cause the cursor not
being able to open on subsequent runs.

To be able to debug this you would do:

1. STRDBG _enter_  
   When you run the program while debugging you get more detailed messages in the job log that wouldn't normally show
2. CALL _prg_
   Run the program like normal
3. DSPJOBLOG _press enter_
4. F10
5. PAGE UP
   You would see the messages:
   ```
   Cursor ALLPROVCURSOR not open
   Cursor CUSTCURSOR already open or allocated
   ...
   ```
   The Problem should be very apparent now.
   (The wrong cursor was closed leaving the the one that was originally opened still opened after the program ends
   the first time, ultimatly causing the issue for subsequent runs).
6. ENDDBG
   Always remember to stop debugging, as staying in debug mode may prevent you from modifying production files

#### CSTCURSOR3.sqlrpgle

This version simply displays the fact that you can include an ORDER BY clause in
the DECLARE CURSOR statement.
