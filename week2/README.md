# Week 2 Notes

## Rational Developer for i

Rational Developer for i (RDi) is the modern way to interact with an IBM i
system.

Look at the lab to learn how to get set up.

The important thing to know is that, the left side panel is the remote systems
view where you manage connections and objects in those connections.

### Creating files in RDi

Right-click on a library list entry (may need to expand the library list in the
remote systems view) and hover over the new option, the source physical file
option should be there.

After that, right-click on the newly created physical file and an option to
create a new member should be there. You are able to create any member type you
like. This lab has you create a pf file.

### Adding Libraries

Adding libraries is a common operation. You will come across programs that
reference files in a library not in you library list.

Right click on the library list in the remote systems view and select  *Add
Library List Entry*. This entry exists for the session. Since this is the
case:

**adding a library to one session, (say your RDi session) WILL NOT add that
libraries in your other session(s) (say your ACS session that you may have open
alongside RDi)**

**Note:** placing a library at the start of list When you tell RDi to place a
new library entry at the start of the list, it will _place it after all system
libraries specified by a priveledged user_.

#### Adding libraries upon logging in

> Below your connection is Objects. Right click on this word and
> select Properties.

Select Initial library list, input the library and click the _"Add"_ button

You can also give it an initial command. Have this command:

```CLLE
CALL STRJOB
```

as your initial command, so you no longer need to remember to call it yourself.

## Simple RPGLE program

In this lab, you make a simple fixed-form RPGLE program to show you how to
fix the problem not having access to an external file (add the library that has
the file, see above).

To compile, you have right-clicked the member (in the remote systems view),
hover over compile and selected: `CRTBNDRG` The newly created object will be of
type: **pgm.rpgle*

We don't use this form of RPGLE, we use free form.

Note that the new compiled object will not appear in the remote systems view
upon compiling. To find it you need to refresh the remote systems view.

## Data Description Specification

Data Description Specification (DDS), describes properties
of records and fields (data) for files. In this lab we use DDS to
create a physical file (or a database table). CREATE TABLE in SQL.

Everything in DDS **is uppercase**

### Physical files

Physical files take the form:

1. Table attributes
2. Record name
3. Fields
4. PK declaration

#### Creating a physical file

In the editor for a pf file, you can press F4 to have RDi prompt you for values.
It's easier to use this than to type it yourself.

There are two commands used to create a physical file (that is, compile it):

* CRTPF and
* CHGPF

CRTPF (create physical file) - will fail if the compiled version of this file
exists
CHGPF (change physical file) - modifies an already compiled version of the file.

You will see these options when you right-click on the member and hover over
compile (choose the one with no prompting, ignore the other one). Upon
compiling, you will get a *file.pf-dta object.

##### Errors when compiling

When you get errors (or warnings…) you should see the list of them in the
bottom view. Clicking on one will highlight the line with the error message
above it. Pressing Ctrl + F5 will remove the error message from the editor.

#### Example of a physical file

Here's an example of a record definition in a physical file:

```DDS
     A                                      UNIQUE
     A          R STUDENTSR                 TEXT('STUDENTS REGISTER')
     // …
     A          K STUDENTNO
```

* R STUDENTSR - record name - _not relevant now_
* TEXT('STUDENTS REGISTER') - title
* K STUDENTNO - student number field as the primary key
* UNIQUE - enforces the primary key constraint

Example of a field in the table:

```DDS
     A            FEESOWED       7P 2       COLHDG('FEES' 'OWED')
```

* 7P
  * 7 - length
  * P - data type (in this case P means Packed decimal)
* 2 - decimal positions
* COLHDG('FEES' 'OWED') - String that appears in the prompt for this field (in
  UPDDTA)

Take a look at ```students.pf``` for a complete example

### Data Types

|type|description                          |
|----|-------------------------------------|
|P   |Packed Decimal (2 digits in one byte)|
|S   |Zoned Decimal (1 digit in one byte)  |
|A   |Character                            |
|L   |Date                                 |
|T   |Time                                 |
|Z   |Time Stamp                           |

### Adding data to a table

In ACS, we can add data using DFU (Data File Utility) with the:```UPDDTA```
command. Here are some notes on this command:

> Numeric fields should have valid numeric input. The decimal point doesn’t
> show, so when entering $94.99 you would enter 9499 and press the field exit
> key. If you enter 0 in a numeric field without pressing field exit you will
> probably get an entry error. The 0 needs to be right justified.

### Viewing data in a table

After adding data issue:

```RPGLE
RUNQRY *N Students
```

To view the data. (SELECT * FROM … in SQL).

To view the data in RDi, right-click on the *FILE.pf-dta file and hover over
*show in table* option and select fields.
