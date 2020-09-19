         DCL-F UPDREPORT  PRINTER OflInd(*IN01);                                                    
         DCL-F SALESTRANS DISK(*EXT) KEYED USAGE(*INPUT)                                            
               RENAME(SALESTRANS:SALESTRANR);                                                       
         // Keyed -> indexed file, able to retrieve a specific row                                  
         // by a primary key                                                                        
         // NOTE: SALESSTAF2 is in the collection and thus it must be                               
         // added to the library list before hand                                                   
         DCL-F SALESSTAF2 DISK(*EXT) KEYED                                                          
               USAGE(*UPDATE : *OUTPUT : *DELETE);                                                  
         // Data structure definitions                                                              
         DCL-DS FullKey ;                                                                           
               ADept    CHAR(3);                                                                    
               ASalesId CHAR(4);                                                                    
         END-DS FullKey;                                                                            
         // The next data structures make it easy to move data read                                 
         // from the transaction file to the master file                                            
         // NOTE: This will only work if the data types are in the                                  
         // same order                                                                              
                                                                                                    
         // Transaction fields                                                                      
         // Contains all the fields except for the TPHONE field                                     
         // as the TPHONE field must be converted to a decimal value                                
         DCL-DS SalesTransDS;                                                                       
               TDept;                                                                               
               TSalesId;                                                                            
               TFName;                                                                              
               TLName;                                                                              
               TCity;                                                                               
               TAddress;                                                                            
               TPCode;                                                                              
         End-Ds SalesTransDs;                                                                       
         // Master file fields                                                                      
         // Similar to the transaction data structure it does not contain                           
         // the phone field                                                                         
         DCL-DS SalesStaf2DS;                                                                       
               Dept;                                                                                
               SalesId;                                                                             
               FName;                                                                               
               LName;                                                                               
               City;                                                                                
               Address;                                                                             
               PCode;                                                                               
         End-Ds SalesStaf2Ds;                                                                       
                                                                                                    
                                                                                                    
                   WRITE   HEADING;                                                                 
                   // NOTE: use file name, not record format when reading                           
                   READ      SALESTRANS;                                                            
                   DOW       NOT %EOF;                                                              
                     // Put together the composite primary keys to create                           
                     // a unqiue key that could identify a specific record                          
                     // (that is, if the record exists)                                             
                     FULLKEY = TDept + TSalesId;                                                    
                                                                                                    
                     // Chain operation allows you                                                  
                     // go to the master file a retrieve a specific row                             
                     // based on the unique key                                                     
                     // %KDS -> Key data structure                                                  
                     CHAIN %KDS(FULLKEY) SALESSTAF2;                                                
                      SELECT;                                                                       
                        WHEN      %FOUND(SALESSTAF2);                                               
                        SELECT;                                                                     
                           WHEN      TCODE = 'C';                                                   
                              EXSR      CHGREC;                                                     
                           WHEN      TCODE = 'D';                                                   
                              EXSR      DELREC;                                                     
                           OTHER;                                                                   
                              EXSR      ERROR;                                                      
                        ENDSL;                                                                      
                        WHEN      NOT %FOUND(SALESSTAF2);                                           
                           IF        TCODE = 'A';                                                   
                              EXSR      ADDREC;                                                     
                           ELSE;                                                                    
                              EXSR      ERROR;                                                      
                           ENDIF;                                                                   
                        WHEN      %ERROR;                                                           
                              EXSR      ERROR;                                                      
                        ENDSL;                                                                      
                        // overflow ...                                                             
                        IF *IN01 = *ON;                                                             
                          WRITE HEADING;                                                            
                          *IN01 = *OFF;                                                             
                        ENDIF;                                                                      
                        // log activity into the update report                                      
                        WRITE    DETAIL;                                                            
                        // next record ...                                                          
                        READ      SALESTRANS;                                                       
                   ENDDO;                                                                           
                   *INLR = *ON;                                                                     
                   RETURN;                                                                          
         // NOTE: When you WRITE, UPDATE, DELETE                                                    
         // you use the record format name                                                          
         BEGSR  ADDREC;                                                                             
           SALESSTAF2DS = SALESTRANSDS;                                                             
           // convert to decimal type                                                               
           // 10 digit value                                                                        
           // No decimal positions (no precision)                                                   
           PHONE = %DEC(TPHONE:10:0);                                                               
           // put the new record in the master file                                                 
           WRITE SALESTFR;                                                                          
         ENDSR;                                                                                     
         BEGSR  CHGREC;                                                                             
           SALESSTAF2DS = SALESTRANSDS;                                                             
           PHONE = %DEC(TPHONE:10:0);                                                               
           UPDATE SALESTFR;                                                                         
         ENDSR;                                                                                     
         BEGSR  DELREC;                                                                             
           DELETE    SALESTFR;                                                                      
         ENDSR;                                                                                     
         BEGSR  ERROR;                                                                              
           TFNAME = 'UPDATE/DELETE/CHANGE';                                                         
           TLNAME = 'E R R O R';                                                                    
         ENDSR;                                                                                      
