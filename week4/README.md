# Week 4 Lecture Notes

Note: We did not have to do part E,F, or G.

## Useful Commands in ACS

```
WRKOBJPDM <source physical file>
```

Will display all of the members of the source physical file

## Filters in RDi

Filters allow for easy access to specific files

Look at page 4 for in the lab instructions.

## CL Programming

We use CL programs as wrappers (or drivers) to interface with our RPGLE
programs.

#### Restrictions with the CLLE language

* Can only open five files per program.
* Can't update database files
* Can't create reports

#### Black screen of Death

In the lab, we were given a problem where the program would crash if we add an
existing library to our library list with the ADDLIBLE command.

The crashing screen is known as the *"Black Screen of Death"*

When the program crashes, you will receive these options on how to respond:
* R - for retry
* C - stop the program - usually what is chosen
* D - stop the program a give us a core dump as a report
* I - ignore the breaking statement and continue

You can also put your cursor on the error message that appears on the black
screen of death and press F1. Useful for debugging. The error message also
specifies what error code caused the crash. In our case it was CPF2103.

You'll see how to use this in the next section.

##### Monitor Message

The Monitor Message command is used to avoid the "Black screen of death" when a
command fails. We use Monitor Message to catch errors. We have to
specify a specific error, we do this with an error's uniquely identifying code.

In the startup.clle, there is the code:

```
ADDLIBLE BCI433LIB
MONMSG MSGID(CPF2103)
```

This statement is used to trap the possible error: ```CPF2103``` from the
_previous statement_ (ADDLIBLE). ```CPF2103``` is the error code for: "library
already
exists in the library list".

### User Profiles

Contains information about a user.

Some information stored in the user profile is:
* Password
* Initial program
* Initial Menu
* The Current Library
* User class
* Special Authorities
* Quota on storage space

Every user has a **user class** associated with them to provide access control
to system's resources. User classes have default **special
authorities**(SPCAUT) that can be *enforced if the priveledged user allows it
(have the QSECURITY system value >= 30)*. Special authorities are what provide
capabilities to specific users (or groups of specific users).

List of user classes with their default authorities

```
*SECOFR
  // Has all the special authorities which cannot be revoked
  *ALLOBJ *SAVSYS *JOBCTL *SERVICE *SPLCTL *SECADM *AUDIT *IOSYSCFG
*SECADM
  // authority named the samed as the user class ... lol
  *SECADM
*SYSOPR
  *SAVSYS *JOBCTL
*PGMR
*USER
```

Look at the *user-profiles.pdf* to learn more detail about what each special
authority does. You'll need it for the ```*SECADM``` and ```*JOBCTL``` special
authorities.

#### Setting initial program

Execute ```CHGPRF``` to change specific attributes of yourself.  
The attribute we are changing for this lab is the initial program to be run.

After doing part C in the lab (it walks you through how to create a simple
startup program in CLLE), when you change the initial program of yourself in
CHGPRF, that program will run everytime you login.

##### Overriding the initial program

You can override the initial program by specifying another program (or *NONE,
for no program) at the login screen where it prompts for
*"Program/procedure"*. This is useful if you have created a buggy program that
crashes.

#### Privileges options

Another command exists only for priveleged users (any user with the Security
Administor special suthority (*SECADM)). That command is: ```CHGUSRPRF```.

Using this command, they may grant or revoke special authorities.

Although not every user may execute every command, they may look at the options
all the documentation for it. They simply enter the command a type F4 to open
the prompt. If there is anything the user is curious about, they may press F1
(with thier cursor hovering over it) to learn more about it.

### Command set

You can invoke a command from RDi and give it a meaningful name.

In remote systems view:
1. Naviagate to commands (under your user name)
2. Right click on it and select new -> command set
3. In the menu that shows up, give it the command.  
  *For us, we wanted to clear the output queue so our command was:*
  ```CLROUTQ <user-name>```

4. Click next and give it a meaningful user name.  
  _"Clear my Output Queue" in our case_
5. Done! You've created a command that can now be executed by simply selecting
   the command (Which will be under commands) that has the meaningful name
   you've specified.
