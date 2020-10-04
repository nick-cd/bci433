# Week 2 Quick Check Answers

## Fill in the blanks and True/False

1. In RDi or Eclipse, a perspective has (composed of): **_views_**
2. It's important that you protect your RDi workspace. So you keep it on
   your USB drive. This way makes you have a backup of your source code.
   **_True_**
3. The CL command WRKOBJ STUDENTS will show a list of STUDENTS objects that
   you have **_authority_** to use.
4. The CL command to show your library list **_DSPLIBL_**
5. The CL command to add BCI433LIB library to your library list **_ADDLIBL_**
6. The CL command to list all objects which have the same name as your user
   ID **_WRKOBJ user_name_**
7. What are the object types you see after you run the CL command in last
   question? ~~I don't have access to my account to verify this answer~~  
   **_OUTQ, MSGQ, USRPRF, LIB_**

## Short Answer Questions

Step 1. EDITCODES is a program in Library BCI433LIB. When running the program
(CALL EDITCODES), we got the message: “Program EDITCODES in Library *LIBL not
found”. What does it mean about BCI433LIB?

**_BCI433LIB was not our current library_**

Step 2. For the situation in last question, give three different solutions
to run the program.

* Change the current library to BCI433LIB and then CALL EDITCODES

   ```RPGLE
   CHGCURLIB BCI433LIB  
   CALL EDITCODES
   ```

* Call the program with a qualified name

   ```RPGLE
   CALL BCI433LIB/EDITCODES
   ```

* ~~Not sure what else~~

Step 3. Why you need to call the program STRJOB in ACS or RDi when doing
your labs?

This program will display your name along with your user ID on all spooled
file pages to ensure that you are indeed the one who created the spooled the
spooled file. Thus, if it's a compilation output, we can guareentee that
you wrote the code

Step 4. How and when library list created?

It's created when you sign on and it's deleted when you signoff.
The system administator decides what libraries are going to be in the list
upon signingin by changing the value of QSYSLIBL(contains initial system
libraries) and QUSRLIBL(contains initial user libraries) system values.

Step 5. In RDi, when you compile a program but the RDi has no response.
What has happened? Or what you should do to fix the problem?  

A previous (compiled) version of the object is in use (that is, a program
on ACS is running, locking the program object file itself and any other
files it's using). To fix the problem, end the program using the objects you
plan on replacing.

Step 6. What are the three different ways to show your spooled files,
e.g. a compiler listing?

* WRKSPLF then find the required spooled file
* DSPSPLF FILE(spooled file name here) SPLNBR(*LAST)
* On ACS, under the tool bar (File, Edit, View ...), there is a list
  of icons. Select the 8th icon from the left. This will show a new window
  with all your spooled files. Click on the one you want. **This is the
  preferred way to show a spooled file to a professor**

Step 7. What are the three different ways to show or query data in a
physical file?

* RUNQRY *N file_name
* Right click on a file with a *file.pf-dta extension in the Remote Systems
   window and select _Show in Table_ and select _Data_.
* ~~Not sure what else~~
