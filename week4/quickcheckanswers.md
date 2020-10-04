# Week 4 Quick Check Questions

## Fill in the Blank and True/False

1. RPGLE built-in function names start with: **_'%'_**
2. The CL command to set a program to DEBUG mode so you can set breakpoints is:
   **_STRDBG_**
3. We use the CL command MonMsg to check for your chat with other users.
   **_FALSE_**
4. CHGUSRPRF is the CL command to allow you to setup initial program for your
   ACS. **_FALSE_**, We use CHGPRF to change our initial program, CHGUSRPRF is
   for administrators

## Short Answer Questions

Step 1. How to get today's Date in RPGLE programs?

```RPGLE
%DATE()
```

Step 2. Write RPGLE statement to calculate the days left to the end of
the summer term(Aug. 14).

  ```RPGLE
  %DATE(D'2020-08-14' : %DATE() : *DAYS)
  ```

Step 3. Write 3 items of user's info that's stored in a user's profile.

* Initial Program
* Initial Menu
* Password

Step 4. If a user cannot login due to the wrong initial program of the
user profile. How the user should fix it?

On the sign on screen, they can enter ```*NONE``` for the initial program
