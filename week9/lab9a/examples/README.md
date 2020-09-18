# Lab 9 A Code examples

### CUSTLOOKUP

This program gives the illusion that it works. (That is, if we don't pay good
attention to the CustID shown). This program did not use the communications
area in this program. If you don't get feedback on your embedded sql statement,
you may proceed with eronious information thinking you got something that
working.

In the SQL communications area, we can check SQLCODE to see if the row was
found. If SQLCODE is equal to 100, the row was not found and should be reported
in some fashion to the user.

If null values were attempted to be stored in host variables. The associating 
indicator variables (the variables specified beside the host vars separated by 
a space) will be set to -1. This must be accounted for after the embedded SQL 
SELECT statement.

### CUSTLOOKUP2

This is the corrected version of the previous program which checks for feedback 
from the communications area. 

Specifically, it checks if SQLCODE is in fact equal to 100. Which may 
happen when this program is run.

This program also checks for and other errors that can occur as well as any 
warnings with the condition:
```
SQLCODE <> 0 or SQLWN0 = 'W'
```
* SQLCODE is not 0, then an error occurred.
* SQLWN0 is a catch all for all possible warnings.
