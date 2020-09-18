# Week 9 general notes

### Embedded SQL

We use an SQL precompiler directive to inform the compiler that what's comming 
up next is SQL.

Example:
```
EXEC SQL
  SQLSTATEMENT;
```

**NOTE:** Make sure the file/member that contains your source code is of type: 
SQLRPGLE. If the file type is RPGLE, the SQL precompiler directive will show up 
as an error. So don't forget!

##### More information
At compile time, the SQL precompiler that will look through all the code 
and every time it encounters a directive it knows there is a SQL statement that 
needs to be parsed. The SQL precompiler will translate that SQL statement into 
RPGLE code so that the RPGLE compiler is able to parse the code.

### Host variables

When we refer to an RPGLE variable inside of an SQL statement we refer to it as 
a host variable. Host variables have a colon(':') prepended to their name when 
they are used.

### Externalally described data structure

To support all the host variables(RPGLE variables) being brought in at compile 
time, we can declare a data structure based on a externally described table:
```
DCL-DS CUSTOMER EXT END-DS;
```
This one line of code at compile time will bring in all the fields in a table 
and define them properly. So you'll get the right field name, type, size.
Once we do this, we can refer to all the fields in the table referenced as host 
variables in our SQL statements.

###### Meanings

* DCL-DS -> declare data structure
* CUSTOMER -> external file name we want to reference
* EXT -> specifying that the name CUSTOMER is in a fact an externally described 
  file.
* END-DS -> End data structure.

### Indicator variables

Used in situations where we have the possibility of the retrieved value(s) from
a record could be null. If The value retrieved from a specific column happens
to be null, **The assignment cannot be done!** Thus, an indicator variable is
required to know when a null value was retrieved (and attempted to be stored in
our host variables)

We define standalone indicator variables for this.  
When defining an indicator variable, it must be of type binary and have decimal
size of 4 (no precision).
```
DCL-S SHIPCITYNULL BINDEC(4:0);
DCL-S DISCOUNTNULL BINDEC(4:0);
```
When an attempt is made to store a value of NULL into a host variable, the 
indicator variable was take on the value of -1 (0 otherwise).

###### Definition of NULL

**NULL means unknown value**

### Example of embedded SQL

Reminder: because we declared a CUSTOMER data structure, we get all the host 
variables defined ready to be used.
```
            EXEC SQL // SQL precompiler
              SELECT CUSTID, // all selected columns must be stored somewhere.
                     NAME,
                     SHIPCITY,
                     DISCOUNT
                INTO :CUSTID,
                     :NAME,
                     :SHIPCITY :SHIPCITYNULL, // Note: host vars and indicator vars are separated by spaces
                     :DISCOUNT :DISCOUNTNULL
                FROM BCI433LIB/CUSTOMER
                WHERE CUSTID = :CUSTID
```

The host variables are specified in the same order as the column names.

### SQL Communications Area

When you have an embedded SQL statement in an RPGLE program, you should always 
check for possible errors that could occur. We get feedback from a recently 
executed SQL statement from the SQL Communications Area. It provides fields 
that we can check that indicate what happened with the recently executed SQL 
statement.

Many things can go wrong with the execution of SQL statements.

#### SQLCODE
* < 0 - ERROR
* = 0 - SUCCESSFUL execution (may have a warning, and thus we should still 
  check for warnings).
* > 0 - SUCCESSFUL execution with a definite warning

examples:
* 100 - Row not found -> **very common and will be used in our code**
* 811 - Too many rows

#### SQLWN?
One digit follows SQLWN to specify will warning is being referred to. It could
be any digit from 0-9.

SQLWN0 is a catch all for all other SQL warn fields (that is, if any other
SQLWN? field has a value of 'W', then SQLWN0 with have a value of 'W' as well)

##### Sample code to check for error (SQLCODE and SQLWRN)
IF (SQLCODE <> 0) OR (SQLWN0 = 'W');
  EXSR SQLPROBLEM;
ENDIF;

#### SQLSTATE -> modern technique to get feedback

SQLSTATE returns 5 characters with the meanings:

* '00000' - SUCCESSFUL EXECUTION
* '02000' - ROW NOT FOUND
* '01???' - WARNING
* ANYTHING ELSE - some other ERROR

##### Example of SQLSTATE

```
            SELECT
              WHEN SQLSTATE = '00000';
                /*
                 * When SQLSTATE is all 0's, we want to get out of this SELECT
                 * routine. One technique is to do an assignment to a DUMMY 
                 * field.
                 */
                DUMMY = 1;
              WHEN SQLSTATE = '02000';
                EXSR ROWNOTFOUND;
              WHEN %SUBST(SQLSTATE:1:2) = '01'; // '01' as the first two digits
                EXSR WARNING;                   // denotes some kind of warning
              OTHER;
                EXSR SQLERROR;
              ENDSL;
```
Note: You don't check both SQLCODE and SQLSTATE, you'd just use one or the 
other.
