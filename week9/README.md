# Week 9 general notes

## Embedded SQL

We use an SQL precompiler directive to inform the compiler that what's comming
up next is SQL.

Example:

```RPGLE
EXEC SQL
  SQLSTATEMENT;
```

**NOTE:** Make sure the file/member that contains your source code is of type:
SQLRPGLE. If the file type is RPGLE, the SQL precompiler directive will show up
as an error.

### More information

At compile time, the SQL precompiler that will look through all the code
and every time it encounters a directive it knows there is a SQL statement.
The SQL precompiler will translate that SQL statement into
RPGLE code so that the RPGLE compiler is able to parse the code.

## Host variables

When we refer to an RPGLE variable inside of an SQL statement we refer to it as
a host variable. Host variables have a colon(':') prepended to their name when
they are in use in an SQL statement.

### Externalally described data structure

To bring in all the host variables(RPGLE variables) in at compile
time, we can declare a data structure based on a externally described table:

```RPGLE
DCL-DS CUSTOMER EXT END-DS;
```

This one line of code at compile time will bring in all the fields in a table
and define them properly. You'll get the right field name, type, size.
Once we do this, we can refer to all the fields in the table referenced as host
variables in our SQL statements.

## Meanings

* DCL-DS -> declare data structure
* CUSTOMER -> external file name we want to reference
* EXT -> specifying that the name CUSTOMER is in a fact an externally described
  file.
* END-DS -> End data structure.

## Indicator variables

Used in situations where we have the possibility of the retrieved value(s) from
a record could be null. If The value retrieved from a specific column happens
to be null, **The assignment cannot happen** Thus, an indicator variable is
required to know when we get a null value (and attempted to assign to
our host variable(s))

We define standalone indicator variables for this.  
When defining an indicator variable, it must be of type binary and have decimal
size of 4 (no precision).

```RPGLE
DCL-S SHIPCITYNULL BINDEC(4:0);
DCL-S DISCOUNTNULL BINDEC(4:0);
```

When an attempt to store a value of NULL into a host variable, the
indicator variable was take on the value of -1 (0 otherwise).

### Definition of NULL

**NULL means unknown value**

### Example of embedded SQL

Reminder: because we declared a CUSTOMER data structure, we get all the host
variables defined ready to use.

```RPGLE
            EXEC SQL // SQL precompiler
              SELECT CUSTID, // all selected columns must have a corresponding
                     NAME,   // variable.
                     SHIPCITY,
                     DISCOUNT
                INTO :CUSTID,
                     :NAME,
                     :SHIPCITY :SHIPCITYNULL, // Note: the space between the
                     :DISCOUNT :DISCOUNTNULL  // host vars and indicator vars
                FROM BCI433LIB/CUSTOMER
                WHERE CUSTID = :CUSTID
```

The host variables are in the same order as the column names.

## SQL Communications Area

When you have an embedded SQL statement in an RPGLE program, you should always
check for possible errors that could occur. We get feedback from a recent
SQL statement from the SQL Communications Area. It provides fields
that we can check to find what happened with the recent SQL
statement that had executed.

A lot can go wrong with the execution of SQL statements.

### SQLCODE

* < 0 - ERROR
* = 0 - SUCCESSFUL execution (may have a warning, and thus we should still
  check for warnings).
* > 0 - SUCCESSFUL execution with a definite warning

examples:

* 100 - Row not found -> **common and used in the lab**
* 811 - More than one row (happends with a SELECT ... INTO ... statement)

### SQLWN

One digit follows SQLWN to specify the warning. It could be any digit from 0-9.

SQLWN0 is a catch all for all other SQL warn fields (that is, if any other
SQLWN? field has a value of 'W', then SQLWN0 with have a value of 'W' as well)

#### Sample code to check for error (SQLCODE and SQLWRN)

IF (SQLCODE <> 0) OR (SQLWN0 = 'W');
  EXSR SQLPROBLEM;
ENDIF;

### SQLSTATE -> modern technique to get feedback

SQLSTATE returns 5 characters with the meanings:

* '00000' - SUCCESSFUL EXECUTION
* '02000' - ROW NOT FOUND
* '01???' - WARNING
* ANYTHING ELSE - some other ERROR

#### Example of SQLSTATE

```RPGLE
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

Note: You don't check both SQLCODE and SQLSTATE, you would use one or the
other.
