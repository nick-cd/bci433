# Week 1 Content

> Please note that this README is a practical summary of the content for the
> week.
> The information I mention here, I found it to be helpful to know
> as the semester went on

Feel free to read through the first 12 slides of the pdf document for history
and features of IBM power systems.

Know that ACS (Access Client Solutions) contains a **5250 emulator**  that you
will use to sign in into the power system in Seneca (The 5050
emulator button within the general sub menu is the functionality
you will be using) and *RDi Rational Developer for i* is the IDE you
will be using to develop your applications (except for this lab where you
will be briefly shown how to use the command line editor)

## Function Keys

Useful Commands in a 5050 Session

* F1 -> Help (Put your cursor under something you are unsure about and press
  F1, a help menu should appear)  
* F3 -> Exit program/menu  
* F4 -> Prompt (Commands can take options, if you would like them, press
  F4 and a menu with all the options should appear)  
* F9 -> Retrieve executed command (same as pressing the UP arrow key in Linux)  
* F12 -> Cancel operation

There are more, but the instructions at the **bottom** of the screen
tell you all the valid function keys. Function keys that are ***NOT***
mentioned are ***invalid***

A lot of the time there are a lot of function keys and the instructions cannot
fit onto one screen, in this case, you
should see:

> F24=More keys

As a valid function key.

To type a function key that is greater that 12, you subtract 12 from the number
specified and press that function key while holding shift  

For example, to type F24, you would type: ```(SHIFT + F12)```

### Commands

Take the form action (verb) + noun  
Some common verbs you will be using:  

* WRK (Work)
* DSP (Display)
* CHG (Change)

### Objects

**Everything that has an identifier (name) or takes up storage space is an
object**

Common object types include:

* Library (*LIB) - stores and indexs objects
* File (*FILE)
* Program (*PGM)
* Module (*MODULE)

Other object types:

* *MSGQ
* *OUTQ

#### Library lists

> Is an ordered list of libraries with associated objects. The order of the
> list specifies the order of precendense with unqualified objects.

**QSYS library can contain other objects**

### SEU, the command line editor

Read slide 29 to learn the basics of the editor.  
I'm not going ot go over it here as you'll never use
outside of this first lab.
