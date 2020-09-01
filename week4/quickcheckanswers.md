# Week 4 Quick Check Questions
### Fill in the Blank and True/False
1. RPGLE built-in function names start with: **_'%'_**
2. The CL command to set a program to DEBUG mode so you can set breakpoints is **_STRDBG_**
3. The CL command MonMsg is used to monitor your chat with other users. **_FALSE_**
4. CHGUSRPRF is the CL command to allow you to setup initial program for your ACS.
  **_FALSE_**, We use CHGPRF to change our initial program, CHGUSRPRF is for administrators

### Short Answer Questions
1. How to get today's Date in RPGLE programs? ```%DATE()```
2. Write RPGLE statement to calculate the days left to the end of the summer term(Aug. 14). 
  ```%DATE(D'2020-08-14' : %DATE() : *DAYS)```
3. Write 3 items of user's info that is stored in user profile.
  * Initial Program
  * Initial Menu
  * Password
4. If a user cannot login due to the wrong initial program of the user profile. How the user should fix it?
  On the sign on screen, they can enter ```*NONE``` for the initial program
