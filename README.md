# BCI433
_This repository is meant to assist people currently taking the BCI433 course_

## Contents
* Downloading and Installing (see below)...  
  The original instructions we recieved in class are in the current directory (acs\_setup.pdf & rdi\_setup.pdf)
  * [IBM i Access Client Solutions (ACS)](#acs)
  * [IBM Rational Developer for i (RDi)](#rdi)
* Weekly Content
  * Lecture notes  
  These notes will summarize important topics mentioned in a lecture.
  * Lab Worksheet(s)
  * Lab Code
  * Demo Questions  
   In our demos, we were asked question(s) related to the topic for that week.  
   In the documents I provide, they will have example questions that you could be asked. These were questions I was asked myself.  
   This was the way they used to ensure students understood the material. **So be prepared!**

### Downloading and Installing Required Software
_This section was primarily made to make the process of installation of the software more convienient and easier to understand_  
_It's designed to be straight to the point_

##### <a name="acs"></a>ACS Download and Installation
1. Download "IBM i Access Client Solutions (5733XJ1) X86 X64" ISO image file from [ITS Downloads Page][downloads]
2. Either extract contents of archive (Which should be easy) **OR** [mount ISO file]((#mount)) possibly a little confusing
3. [Navigate to *_Application and run](#install) the installer
   
    <a name="mount"></a>**Mounting...**
    
    *Linux (Mounting as a Loop device):*
    ```
    $ sudo mount -o loop /path/to/IBM\ ACS.ISO /mnt  
    $ cd /mnt  
    $ sudo ./install_acs_*32|64*
    ```
    
    *Windows:* 
    
    >1. right-click and select mount (will appear as a DVD Drive)  
    >2. navigate to the **Windows_Application** directory  
    >3. select (double click) install_acs_*32/64*.js  
    
    
    *~~Not sure how to do this on MacOS:~~*
    
    - [ ] MacOS instructions for mounting 
   
   
   
   <a name = install></a>**Installing**
   
   In the extracted directory, navigate to the *_Application directory based on your OS.
   select the appropriate install_acs_* installer
   
   Linux:
   ```
   cd /path/to/extracted_dir/Linux_Application
   sudo ./install_acs_*
   ```
   
   MacOS:
   ```
   cd /path/to/extracted_dir/Mac_Application
   sudo ./install_acs_*
   ```
   
   Windows
   >1. navigate to Windows_Application
   >2. select install_acs_*.js

##### <a name="rdi"></a>RDi Download and Installation
1. Download these zip files from the [ITS Downloads Page][downloads]
    * Download "RDi V9.6 - Install 1"
    * Download "RDi V9.6 - Install 2" 
    * Download "RDi V9.6 - Activation"
2. Extract the zip files
    * Extracting the "RDI_V9.6_CORE_PRODUCT_INSTALL_1_E" zip archive gives a Disk1 directory
    * Extracting the "RDI_V9.6_CORE_PRODUCT_INSTALL_2_E" zip archive gives a Disk2 directory
    * Extracting the "RDI_RPG_COBOL_TOOLS_V9.6_AK_EMG" zip archive gives a jar file (Will be used in a future step)
3. Move the Disk1 and Disk2 directories (previously retreived via extracting the zip archives) into the same directory

   > dir/  
   >  |___ disk1/  
   >  \\___ disk2/  

4. Run the installer ~~The instructions given in the class are wrong at the part~~

   Linux:
   ```
   cd disk1/InstallerImage_linux_gtk_*
   sudo ./install
   ```

   MacOS:
   ```
   cd disk1/InstallerImage_macosx_cocoa_*
   sudo ./install
   ```

   Windows:
   > Navigate to disk1/InstallerImage_win32_win32_*
   > select install.exe
   
   ** The IBM installer manager should appear on the screen now **
   
 5. In the installer that shows up, select the install button for **IBM Rational Devloper for i**
 6. select next **2 times**
 7. select **I accept** to the licence agreement and select next
 8. select next **4 times**
 9. select install
 10. select next
 
 RDi should now be installed!

[downloads]: https://sonic.senecacollege.ca/download/download.php?area=iSeries