# Reflection
1. Using a minimum of 300 words and a maximum of 350 words,
  describe the lab program you found to be the most interesting.
  Indicate what it does, what interested you about it, what you
  learned from doing it, what problems you encountered if any in
  solving it. (3%)

I believe lab 8 was the most interesting. I created an
application that retrieves and displays Toronto Blue Jay players
from the AMERICANLG table (BASEBALL20 library) that stores
players from various teams. Only the Blue Jays were needed,
ergo, a logical file was made to override AMERICANLG for ease of
retrieval. Upon starting the application, the user is shown a menu
that prompts for what players they want to display based on their
position. To display the result of the requested query, a subfile
was used (thus, I learned subfiles). A subfile facilitated writing
multiple records to a display file with the same record format
name. A subfile consists of a subfile record format containing a
settable amount of records (SPLSIZ) uniquely identified by a
record number. To write a subfile record, a standalone field
holding a record number indicates the record to write to. Another
record format is known as the control record format which
facilitated the displaying of the subfile after all rows were written
to the subfile record. Interestingly, the control record format
contains information specifying the behavior of the subfile.
Settings include: SFLDSPCTL and SFLDSP (shows control record
and subfile record respectively when set), SFLCLR (when set and
a WRITE to the control record is performed, the subfile is cleared),
SPLPAG (shows the specified amount of records at once, must
scroll to see others), and SPLSIZ which represents the total
amount of records in a subfile.
Attempting to write a record when the standalone record number
field exceeded SPLSIZ, the error...
> "The target for a numeric operation is too small to hold the result" 

will occur. I received this error as I neglected to override
AMERICANLG resulting in more rows being fetched than expected.

> "Attempt to write a duplicate record to..."  

occurred because it is required to clear the subfile record format
to write the records again.

> "Session or device error occurred in..." 

occurred as SFLDSPCTL and SFLDSP were off and thus, could not
be displayed. This was also caused by issuing EXFMT on the
subfile record. Only the control record can prompt (and write) to
the display.

Note: The information regarding subfiles was referencing
the official IBM documentation, see citations below.

# Research
#### Research the following information (2%)
1. What does TIMI stand for?  
Technology-independent machine interface
(“Overview of iSeries (OS/400) architecture”)

2. What are three variations of an RPGLE READ statement.
  * READC (“READC (Read Next Changed Record)”)
  * READE (“READE (Read Equal Key)”)
  * READP (“READP (Read Prior Record)”)

3. Name a chief architect of the system we are working on. Steve Will is the
chief architect of the system we are working on. (“Steve Will, IBM i Chief
Architect – What’s new in IBM i 7.2?”)D. On our system, what is the name given
for the structure of one source member being compiled into one executable
program where only dynamic binding is supported. Bound program  (created with
a CRTBND* command)
(“Using the CRTBNDRPG Command”)

4. What are three types of subfiles.
  * Load All Sub File
  * Expandable Sub File
  * Single Page Subfile  
(“IBM I Blog – Technical Tips and Updates”)

## Citations
"Overview of iSeries (OS/400) architecture" Iseries Architechture,
http://wiki.c2.com/?IseriesArchitecture.
Accessed 11 August 2020.

"Using Subfiles" IBM Knowledge Center,
https://www.ibm.com/support/knowledgecenter/en/ssw_ibm_i_72/rzasc/usesubfile.htm.
Accessed 11 August 2020

"READC (Read Next Changed Record)" IBM Knowledge Center,
https://www.ibm.com/support/knowledgecenter/en/ssw_ibm_i_72/rzasd/zzreadc.htm.
Accessed 11 August 2020

"READE (Read Equal Key)" IBM Knowledge Center,
https://www.ibm.com/support/knowledgecenter/en/ssw_ibm_i_72/rzasd/zzreade.htm.
Accessed 11 August 2020

"READP (Read Prior Record)" IBM Knowledge Center,
https://www.ibm.com/support/knowledgecenter/en/ssw_ibm_i_72/rzasd/zzreadp.htm.
Accessed 11 August 2020

Arbor Solutions. "Steve Will, IBM i Chief Architect – What’s new in IBM i 7.2?"
Arbor Solutions, 9 December 2020,
https://arbsol.com/steve-will-ibm-i-chief-architect-whats-new-in-ibm-i-7-2/,
Accessed 11 August 2020.

"Using the CRTBNDRPG Command" IBM Knowledge Center,
https://www.ibm.com/support/knowledgecenter/ssw_ibm_i_72/rzasc/bndrpg.htm.
Accessed 11 August 2020

"IBM I Blog – Technical Tips and Updates" Load All Subfile,
https://www.ibmiupdates.com/2015/11/load-all-subfile.html. 
Accessed 11 August 2020
