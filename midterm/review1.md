# Midterm Review 1

Write DDS Code to create an object that stores customer information. The object
should have the following attributes:

* A number that uniquely identifies the customer. The number should store 1
  digit in one byte. This is the primary key to the file.
* A name. The name should store 30 letters and or numbers.
* A date that stores the last contact date of the customer.
* An account balance to store how much money the customer has on account. The
  account balance should be able to store the number 99999.99 and store two
  digits in one byte.

## My Answer

```DDS
T.Name++++++RLen++TDp.. .. .Functions+++++++++++++++++++++++
                            UNIQUE
R CUSTOMERR                 TEXT('Customer info')
  CUSTNO    6     S         COLHDG('Customer' 'Number')
  CUSTNAME  30    A         COLHDG('Customer' 'Name')
  CUSTDATE        L         COLHDG('Customer' 'Date')
  ACCBAL    7     P 2       COLHDG('Account' 'Balance')
K CUSTNO
```
