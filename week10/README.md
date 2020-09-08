# Week 10 Lecture Notes

### General Concepts

We can't use a ```SELECT ... INTO ...``` statement when we want to retrieve
multiple rows.  
SQL allows multiple rows to be retrieved with a **cursor**.

With a Cursor you must perform the following tasks:

1. Declare the Cursor - Similar to a ```DCL-F``` (declare file) statement
   This statement can be placed anywhere before the OPEN statement
2. Open the Cursor  
   This produces a temporary result table (that is, the ```SELECT``` statement
   specified in the DECLARE CURSOR statement is actually executed.
3. Fetch rows from the Cursor (in a loop)
   Every iteration we retrieve a row from the temporary result table
4. Optionally update, delete, or report on the most recently fetched row (in a 
   loop)
5. Close the cursor
   When finished processing all the rows in the temporary result table, the
   cursor must be close to free the temporary result table from memory.

Declare file (DCL-F) vs DECLARE CURSOR:  
> Unlike the DCL-F statement, A cursor declaration can specify row selection,
> derived columns, union and other data manipulations.

AND:
> When you use DCL-F, you cannot include the library name, you must ensure that
> the library is in your library at compile time. When you declare a cursor, you
> can have a qualified name so you don't need to worry about the library in your
> library list
