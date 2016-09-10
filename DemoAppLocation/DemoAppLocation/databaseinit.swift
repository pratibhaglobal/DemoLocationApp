//
//  databaseinit.swift
//  Jive map
//
//  Created by Adisoft-macmini-3 on 28/10/15.
//  Copyright (c) 2015 Adisoft-macmini-3. All rights reserved.
//

import UIKit

class databaseinit {
   
    var aDataBase = 0
    
     
    var delegate: AppDelegate!
    func InitDatabas()
    {
     delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let filemgr = NSFileManager.defaultManager()
        let dirPaths =
        NSSearchPathForDirectoriesInDomains(.DocumentDirectory,
            .UserDomainMask, true)
        
        let docsDir = dirPaths[0]
        
      //  print(docsDir)
        //print("Path ========\(dirPaths)")
        
       
        
        delegate.databasePath = (docsDir as NSString).stringByAppendingPathComponent("JiveMap.db")
        
        if !filemgr.fileExistsAtPath(delegate.databasePath as String) {
            
            let contactDB = FMDatabase(path: delegate.databasePath as String)
            
            if contactDB == nil {
                print("Error: \(contactDB.lastErrorMessage())")
            }
           //following_channels channel_name TEXT NOT NULL collate nocase
            if contactDB.open() {
                let sql_stmt = "CREATE TABLE user (date TEXT); "
                    
               
                
                if !contactDB.executeStatements(sql_stmt) {
                    print("Error: \(contactDB.lastErrorMessage())")
                }
                contactDB.close()
            } else {
                print("Error: \(contactDB.lastErrorMessage())")
            }
        }
        

        
    
    }
    /*
    user_id TEXT  NOT NULL, note_id TEXT NOT NULL, created_at  TEXT NOT NULL, note_type  TEXT NOT NULL, note_content  TEXT NOT NULL, jive_or_msg_id  TEXT NOT NULL, original_user_id  TEXT NOT NULL, user_name  TEXT NOT NULL, p_user_name  TEXT NOT NULL, profile_image  TEXT NOT NULL,  read_status INTEGER NOT NULL
    
*/
    func InsertNotification(dates:NSString) -> Int
    {
        delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        var resultReturn:Int = 0
        let contactDB = FMDatabase(path: delegate.databasePath as String)
        
        if contactDB.open() {
            
            
                let insertSQL = "INSERT INTO user (date) VALUES ('\(dates)')"
            
            
            
            
            
                let result = contactDB.executeUpdate(insertSQL,
                    withArgumentsInArray: nil)
                
                if !result {
                    //status.text = "Failed to add contact"
                    resultReturn = 0
                    //print("Error: \(contactDB.lastErrorMessage())")
                } else {
                    
                    resultReturn = 1
                    //  status.text = "Contact Added"
                    
                
            }
        } else {
            print("Error: \(contactDB.lastErrorMessage())")
        }
        
        return resultReturn
        
    }
    
    func getNotification(getNoteType:String) -> NSMutableArray
    {
        delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let getResultArray:NSMutableArray = NSMutableArray()
        let contactDB = FMDatabase(path: delegate.databasePath as String)
        
        if contactDB.open() {
            let querySQL = "SELECT date FROM user"
            // print(querySQL)
            let results:FMResultSet? = contactDB.executeQuery(querySQL,
                withArgumentsInArray: nil)
            
            while ((results?.next()) == true) {
                // Get the column data for this record and put it into a custom Record object
                
                let note_id:AnyObject = (results?.stringForColumn("date"))!
                
                getResultArray.addObject(note_id)
                
            }
            
            
            contactDB.close()
            
            // print(getResultArray)
        } else {
            print("Error: \(contactDB.lastErrorMessage())")
        }
        
        return getResultArray
        
    }

    
}
