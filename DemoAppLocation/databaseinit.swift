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
                let sql_stmt = "CREATE TABLE user (user_id TEXT  PRIMARY KEY, user_name TEXT, user_email  TEXT, user_friendly_name TEXT, iso_language_code TEXT, country TEXT, location  TEXT, details  TEXT, URLs  TEXT, created_at TEXT, profile_image  TEXT, background_image  TEXT, likes  TEXT, dislikes TEXT, favs  TEXT, jives  TEXT, replies  TEXT, rejives  TEXT, shares  TEXT,followers  TEXT,followings  TEXT,status  TEXT,at  TEXT);CREATE TABLE notifications (no INTEGER PRIMARY KEY  AUTOINCREMENT  NOT NULL  UNIQUE , user_id TEXT  NOT NULL, note_id TEXT NOT NULL, created_at  TEXT , note_type  TEXT , note_content  TEXT , jive_or_msg_id  TEXT , original_user_id  TEXT , user_name  TEXT , p_user_name  TEXT , profile_image  TEXT ,  read_status INTEGER );CREATE TABLE following_channels (user_id TEXT  NOT NULL, channel_name TEXT NOT NULL collate nocase, isChannelFollowed  INTEGER NOT NULL,  PRIMARY KEY (user_id,channel_name));CREATE TABLE IF NOT EXISTS messages (user_id TEXT  NOT NULL, from_user_id TEXT NOT NULL, msg_content  TEXT, images  TEXT, created_at  TEXT NOT NULL, profile_img  TEXT, receiver  TEXT NOT NULL, server_msg_id  TEXT NOT NULL, stranger  TEXT NOT NULL, msg_url  TEXT , msg_iso_code  TEXT , msg_read_status  TEXT, userName_SenderTime TEXT,UserImage_SenderTime TEXT, PRIMARY KEY (user_id,server_msg_id));CREATE TABLE follow_peo (loginuser_id TEXT ,followuser_id TEXT ,followuser_friendly_name TEXT,followuser_name TEXT,image TEXT, detail TEXT,mute TEXT,PRIMARY KEY (loginuser_id,followuser_id));CREATE TABLE IF NOT EXISTS userImage (from_user_id TEXT PRIMARY KEY NOT NULL,userimgURL TEXT,userDirectryImg TEXT,username TEXT) "
                    
               
                
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
    func InsertNotification(getWCArray:NSArray) -> Int
    {
        delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        var resultReturn:Int = 0
        let contactDB = FMDatabase(path: delegate.databasePath as String)
        
        if contactDB.open() {
            
            for var i = 0 ; i < getWCArray.count ; i++
            {
                let getnote_id:String! = getWCArray.objectAtIndex(i).valueForKey("note_id") as! String
                 let getcreated_at:String! = getWCArray.objectAtIndex(i).valueForKey("created_at") as! String
                 let getnote_type:String! = getWCArray.objectAtIndex(i).valueForKey("note_type") as! String
                 let getnote_content:String! = getWCArray.objectAtIndex(i).valueForKey("note_content") as! String
                 let getjive_or_msg_id:String! = getWCArray.objectAtIndex(i).valueForKey("jive_or_msg_id") as! String
                 var getoriginal_user_id:String!
                if let getorignalid:AnyObject = getWCArray.objectAtIndex(i).valueForKey("original_user_id")
                {
                  getoriginal_user_id = getorignalid as! String
                }
                 var getuser_name:String!
                if let getusername:AnyObject = getWCArray.objectAtIndex(i).valueForKey("user_name")
                {
                    getuser_name = getusername as! String
                }
                var getp_user_name:String!
                if let getpusername:AnyObject = getWCArray.objectAtIndex(i).valueForKey("p_user_name")
                {
                    getp_user_name = getpusername as! String
                }
            
                 let user_friendly_name_Star  = getp_user_name.stringByReplacingOccurrencesOfString("'", withString:"*****==****==&&**")
              //  print(user_friendly_name_Star)
                 let getprofile_image:String! = getWCArray.objectAtIndex(i).valueForKey("profile_image") as! String
               
                let insertSQL = "INSERT INTO notifications (user_id, note_id, created_at, note_type, note_content, jive_or_msg_id, original_user_id, user_name, p_user_name, profile_image, read_status) VALUES ('\(delegate.appd_userid)', '\(getnote_id)', '\(getcreated_at)', '\(getnote_type)', '\(getnote_content)', '\(getjive_or_msg_id)', '\(getoriginal_user_id)', '\(getuser_name)', '\(user_friendly_name_Star)', '\(getprofile_image)', '0')"
                
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
            let querySQL = "SELECT note_id, created_at, note_type, note_content, jive_or_msg_id, original_user_id, user_name, p_user_name, profile_image FROM notifications WHERE note_type =\(getNoteType) and user_id =\(delegate.appd_userid) ORDER BY note_id DESC LIMIT 50"
           // print(querySQL)
            let results:FMResultSet? = contactDB.executeQuery(querySQL,
                withArgumentsInArray: nil)
            
            while ((results?.next()) == true) {
                // Get the column data for this record and put it into a custom Record object
               
                let note_id:AnyObject = (results?.stringForColumn("note_id"))!
                let created_at:AnyObject = (results?.stringForColumn("created_at"))!
                let note_type:AnyObject = (results?.stringForColumn("note_type"))!
                let note_content:AnyObject = (results?.stringForColumn("note_content"))!
                let jive_or_msg_id:AnyObject = (results?.stringForColumn("jive_or_msg_id"))!
                let original_user_id:AnyObject = (results?.stringForColumn("original_user_id"))!
                let user_name:AnyObject = (results?.stringForColumn("user_name"))!
                let p_user_name:AnyObject = (results?.stringForColumn("p_user_name"))!
                let profile_image:AnyObject = (results?.stringForColumn("profile_image"))!
                let user_friendly_name_Star  = p_user_name.stringByReplacingOccurrencesOfString("*****==****==&&**", withString:"'")
                
               var dict = [String: AnyObject]()
                dict["note_id"] = note_id
                dict["created_at"] = created_at
                dict["note_type"] = note_type
                dict["note_content"] = note_content
                dict["jive_or_msg_id"] = jive_or_msg_id
                dict["original_user_id"] = original_user_id
                dict["user_name"] = user_name
                dict["p_user_name"] = user_friendly_name_Star
                dict["profile_image"] = profile_image
             
                getResultArray.addObject(dict)
                
            }
            
            
        contactDB.close()
            
            // print(getResultArray)
        } else {
            print("Error: \(contactDB.lastErrorMessage())")
        }

     return getResultArray
    
    }
    
    
    func DeleteNotificationByNoteId(getNoteId:String) -> Int
    {
        delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        var resultReturn:Int = 0
        let contactDB = FMDatabase(path: delegate.databasePath as String)
        
        if contactDB.open() {
            
           
            
                
                let deleteSQL = "DELETE FROM notifications WHERE note_id =\(getNoteId)"
                //print(deleteSQL)
                let result = contactDB.executeUpdate(deleteSQL,
                    withArgumentsInArray: nil)
                
                if !result {
                    //status.text = "Failed to add contact"
                    resultReturn = 0
                    print("Error: \(contactDB.lastErrorMessage())")
                } else {
                    
                    resultReturn = 1
                    //  status.text = "Contact Added"
                    
                }
            
        } else {
            print("Error: \(contactDB.lastErrorMessage())")
        }
        
        return resultReturn
        
    }

    
    
    
    
    
    
    
    
    
    
    
    
    
    //MARK:- outer page
    //MARK:-  Messages
    //*******************************************
    func insertFromUserImage(getWCArray:NSArray)
    {
       // print("getWCArray value==\(getWCArray)")
        delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let contactDB = FMDatabase(path: delegate.databasePath as String)
        if contactDB.open() {
            for var i = 0 ; i < getWCArray.count ; i++
            {
                
                let profile_image:String! = getWCArray.objectAtIndex(i).valueForKey("profile_image") as! String
                let user_id:String! = getWCArray.objectAtIndex(i).valueForKey("user_id") as! String
                
                var user_friendly_name:String! = getWCArray.objectAtIndex(i).valueForKey("user_friendly_name") as! String
                user_friendly_name =  user_friendly_name.stringByReplacingOccurrencesOfString("'", withString:"''")
                

                let insertSQL = "INSERT OR REPLACE INTO userImage (from_user_id, userimgURL,username) VALUES ('\(user_id)', '\(profile_image)','\(user_friendly_name)')"
                
                let result = contactDB.executeUpdate(insertSQL,
                    withArgumentsInArray: nil)
                
                if !result {
                    //status.text = "Failed to add contact"
              
                    print("Error: \(contactDB.lastErrorMessage())")
                } else {
                    
                   
                    //  status.text = "Contact Added"
                    
                }
            }
        } else {
            print("Error: \(contactDB.lastErrorMessage())")
        }
        
        
        
    }
    func insertFromUserImage_TimelinePage(UserImage:String,var userFriendlyName:String,UserName:String,UserID:String)
    {
        // print("getWCArray value==\(getWCArray)")
        delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let contactDB = FMDatabase(path: delegate.databasePath as String)
        if contactDB.open() {
            
                
            
            
                
            
                userFriendlyName = userFriendlyName.stringByReplacingOccurrencesOfString("'", withString:"''")
                
            
                let insertSQL = "INSERT OR REPLACE INTO userImage (from_user_id, userimgURL,username) VALUES ('\(UserID)', '\(UserImage)','\(userFriendlyName)')"
                
                let result = contactDB.executeUpdate(insertSQL,
                    withArgumentsInArray: nil)
                
                if !result {
                    //status.text = "Failed to add contact"
                    
                    print("Error: \(contactDB.lastErrorMessage())")
                } else {
                    
                    
                    //  status.text = "Contact Added"
                    
                }
            
        } else {
            print("Error: \(contactDB.lastErrorMessage())")
        }
        
        
        
    }
    func InsertNewMessages(getWCArray:NSArray,getReceiver:String,stranger:String,status:String)
     {
    
        delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
       
        let contactDB = FMDatabase(path: delegate.databasePath as String)
        
        if contactDB.open() {
            
            
            // print(getWCArray.count)
            
            for var i = 0 ; i < getWCArray.count ; i++
            {
                let from_user_id:String! = getWCArray.objectAtIndex(i).valueForKey("from_user_id") as! String
                let details:String! = getWCArray.objectAtIndex(i).valueForKey("details") as! String
                
                let messageEncode:String = encodeString(details);
               // print(messageEncode)
                let created_at:String! = getWCArray.objectAtIndex(i).valueForKey("created_at") as! String
                let msg_id:String! = getWCArray.objectAtIndex(i).valueForKey("msg_id") as! String
                //var p_user_name:String! = getWCArray.objectAtIndex(i).valueForKey("p_user_name") as! String
                let URLs:String! = getWCArray.objectAtIndex(i).valueForKey("URLs") as! String
                let iso_language_code:String! = getWCArray.objectAtIndex(i).valueForKey("iso_language_code") as! String
                var stringOfImages:String! = ""
                let getArrayImage:NSArray = getWCArray.objectAtIndex(i).valueForKey("images") as! NSArray
               if(getArrayImage.count > 0)
                {
                    let getFIrstUrl:String! = getArrayImage.objectAtIndex(0) as! String
                    if(!getFIrstUrl.isEmpty)
                    {
                      stringOfImages = getFIrstUrl
                    }
                  
                }
                
                let insertSQL = "INSERT OR REPLACE INTO messages (user_id, from_user_id, msg_content, images, created_at, receiver, server_msg_id, stranger, msg_url, msg_iso_code, msg_read_status) VALUES ('\(delegate.appd_userid)','\(from_user_id)','\(messageEncode)','\(stringOfImages)','\(created_at)','\(getReceiver)','\(msg_id)','\(stranger)','\(URLs)','\(iso_language_code)','\(status)')"
                
                let result = contactDB.executeUpdate(insertSQL,
                    withArgumentsInArray: nil)
                
                if !result {
                    //status.text = "Failed to add contact"
                   
                    print("Error: \(contactDB.lastErrorMessage())")
                } else {
                    
                 
                    //  status.text = "Contact Added"
                    
                }
            }
        } else {
            print("Error: \(contactDB.lastErrorMessage())")
        }
        
     
      
    }
    func getallPeople(strangers:String) -> NSMutableArray
    {
        delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let getResultArray:NSMutableArray = NSMutableArray()
        let contactDB = FMDatabase(path: delegate.databasePath as String)
        
        if contactDB.open() {
            
            //SELECT U.user_friendly_name,U.profile_image, M.* FROM messages AS M left join UserBrief AS U ON M.from_user_id = U.user_id WHERE M.user_id = '3221128585'  AND M.stranger = '0' GROUP BY M.from_user_id ORDER BY MAX(M.created_at) DESC
            
            
            
            //(user_id TEXT  NOT NULL, from_user_id TEXT NOT NULL, msg_content  TEXT, images  TEXT, created_at  TEXT NOT NULL, profile_img  TEXT, receiver  TEXT NOT NULL, server_msg_id  TEXT NOT NULL, user_name  TEXT NOT NULL, stranger  TEXT NOT NULL, msg_url  TEXT , msg_iso_code  TEXT , msg_read_status  TEXT , PRIMARY KEY (user_id,server_msg_id)
            //let querySQL = "select CASE WHEN M.msg_read_status = 0 THEN count(M.msg_read_status) ELSE 0 END AS  msgcount,M.* , U.userimgURL,U.username  from messages as M left join userimage as U  on M.from_user_id = U.from_user_id where  M.user_id=\(delegate.appd_userid) and M.stranger=\(strangers) group by M.from_user_id ORDER BY MAX(M.created_at) DESC"
            let querySQL = "SELECT U.username,U.userimgURL, M.* FROM messages AS M left join userImage AS U ON M.from_user_id = U.from_user_id WHERE M.user_id = '\(delegate.appd_userid)'  AND M.stranger = '\(strangers)' GROUP BY M.from_user_id ORDER BY M.rowid DESC"
            
           // print(querySQL)
            
            let results:FMResultSet? = contactDB.executeQuery(querySQL,
                withArgumentsInArray: nil)
            
            while ((results?.next()) == true) {
                // Get the column data for this record and put it into a custom Record object
                
              
                let from_user_id:AnyObject = (results?.stringForColumn("from_user_id"))!
                
                let msg_content:AnyObject = (results?.stringForColumn("msg_content"))!
                let created_at:AnyObject = (results?.stringForColumn("created_at"))!
                
                 let DecodeMSG = msg_content.stringByReplacingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
                
                
                 var userimgURL:AnyObject!
                if let checkUserImage:AnyObject = results?.stringForColumn("userimgURL")
                {
                   userimgURL = checkUserImage
                }else
                {
                  userimgURL = results?.stringForColumn("UserImage_SenderTime")
                }
               // var userimgURL:AnyObject = (results?.stringForColumn("userimgURL"))!
                let receiver:AnyObject = (results?.stringForColumn("receiver"))!
                var user_name:AnyObject!
                if let checkuser_name:AnyObject = results?.stringForColumn("username")
                {
                    user_name = checkuser_name
                }else
                {
                
                  user_name =  results?.stringForColumn("userName_SenderTime")
                }
                
                //var user_name:AnyObject = (results?.stringForColumn("username"))!
                let msg_url:AnyObject = (results?.stringForColumn("msg_url"))!
                
                
               // print("user_name======\(user_name)")
                let user_friendly_name_Star  = user_name.stringByReplacingOccurrencesOfString("*****==****==&&**", withString:"'")
                
                var dict = [String: AnyObject]()
                
                //dict["msgcount"] = msgcount
                dict["from_user_id"] = from_user_id
                dict["msg_content"] = DecodeMSG
                dict["created_at"] = created_at
                dict["userimgURL"] = userimgURL
                
                dict["receiver"] = receiver
                dict["user_name"] = user_friendly_name_Star
                dict["msg_url"] = msg_url
               
                
                getResultArray.addObject(dict)
                
            }
            
            
            contactDB.close()
            
            
        } else {
            print("Error: \(contactDB.lastErrorMessage())")
        }
        
        return getResultArray
        

    }
    func getUnreadMessageStatus(strangers:String,fromUserID:String) -> Int
    {
        delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        var getResult:Int!
        let contactDB = FMDatabase(path: delegate.databasePath as String)
        
        if contactDB.open() {
            
          
            let querySQL = "SELECT Count(*) as msgcount FROM messages WHERE user_id = '\(delegate.appd_userid)' AND from_user_id = '\(fromUserID)' AND receiver = '0' AND msg_read_status = '0' AND stranger = '\(strangers)'"
            
           // print(querySQL)
            
            let results:FMResultSet? = contactDB.executeQuery(querySQL,
                withArgumentsInArray: nil)
            
            while ((results?.next()) == true) {
                // Get the column data for this record and put it into a custom Record object
                
                let msgcount:AnyObject = (results?.stringForColumn("msgcount"))!
              
                getResult = Int(msgcount as! String)//.toInt()
                
                
                
            }
            
            
            contactDB.close()
            
            
        } else {
            print("Error: \(contactDB.lastErrorMessage())")
        }
        
        return getResult
        
        
    }

    
      //MARK:- inner page
    func gechatById(getUsrid:String,strangers:String) -> NSArray
    {
        delegate = UIApplication.sharedApplication().delegate as! AppDelegate
       // let getResultArray:NSMutableArray = NSMutableArray()
        let contactDB = FMDatabase(path: delegate.databasePath as String)

       
        //var messages:[BHBMessage] = []
         var messages:[ChatBubbleCellData] = []
        
        
     //( , from_user_id, msg_content, images, created_at, receiver, server_msg_id, user_name, stranger, msg_url, msg_iso_code
        
        if contactDB.open() {
            let querySQL = "SELECT * FROM messages WHERE user_id =\(delegate.appd_userid) AND from_user_id=\(getUsrid) AND stranger=\(strangers) ORDER BY server_msg_id ASC"
            //ASC --> DESC limit 5, 5
          
           //  print(querySQL)
            let results:FMResultSet? = contactDB.executeQuery(querySQL,
                withArgumentsInArray: nil)
         
            while ((results?.next()) == true) {
                // Get the column data for this record and put it into a custom Record object
             
                let msg:AnyObject = (results?.stringForColumn("msg_content"))!
                
                
                let DecodeMSG = msg.stringByReplacingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
             
                
                let images_direc:AnyObject = (results?.stringForColumn("msg_url"))!
                let Create_at:AnyObject = (results?.stringForColumn("created_at"))!
                //print(Create_at)
                let receiver:AnyObject = (results?.stringForColumn("receiver"))!
                let images:AnyObject = (results?.stringForColumn("images"))!
                let server_id:AnyObject = (results?.stringForColumn("server_msg_id"))!
               
                //var role:Role = Role.Sender
                var role:ChatBubbleMessageType = ChatBubbleMessageType.YourMessage
                
                
                if(receiver as! String == "0")
                {
                  //role = Role.Receive
                  role = ChatBubbleMessageType.YourMessage
                    
                    
                }else
                {
                  //role = Role.Sender
                    role = ChatBubbleMessageType.MyMessage
                }
                
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                
                var messageDate = NSDate()
              if   let date = dateFormatter.dateFromString(Create_at as! String)
              {
                   messageDate  = date
                }
                
              
                
                let message = ChatBubbleMessage(text: DecodeMSG, date:Create_at as! String , type: role ,getmsg_images:images as! String,getimages_directry:images_direc as! String,getserver_msg_id:server_id as! String,getTimefINterval:messageDate)
                
                let ifHideDate: Bool
                
                if messages.count == 0 || messageDate.timeIntervalSinceDate(messages[messages.count-1].message.TheTimeInterval) > 60*60*12
                {
                    ifHideDate = false
                }
                else
                {
                    ifHideDate = true
                }

              
                let cellData = ChatBubbleCellData(message: message, hideDate: ifHideDate)
                messages.append(cellData)
               
            }
            
            
            contactDB.close()
            
            //print(getResultArray)
        } else {
            print("Error: \(contactDB.lastErrorMessage())")
        }
        
        return messages
        
    }
    
    /*func gechatById_Paging(getUsrid:String,strangers:String,Paging:Int) -> NSArray
    {
        delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        // let getResultArray:NSMutableArray = NSMutableArray()
        let contactDB = FMDatabase(path: delegate.databasePath as String)
        
        
        //var messages:[BHBMessage] = []
        var messages:[ChatBubbleCellData] = []
        
        
        //( , from_user_id, msg_content, images, created_at, receiver, server_msg_id, user_name, stranger, msg_url, msg_iso_code
        
        if contactDB.open() {
            let querySQL = "SELECT * FROM messages WHERE user_id =\(delegate.appd_userid) AND from_user_id=\(getUsrid) AND stranger=\(strangers) ORDER BY server_msg_id DESC limit \(Paging), 5"
            //ASC --> DESC limit 5, 5
            
            print(querySQL)
            let results:FMResultSet? = contactDB.executeQuery(querySQL,
                withArgumentsInArray: nil)
            
            while ((results?.next()) == true) {
                // Get the column data for this record and put it into a custom Record object
                
                let msg:AnyObject = (results?.stringForColumn("msg_content"))!
                
                
                let DecodeMSG = msg.stringByReplacingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
                
                
                let images_direc:AnyObject = (results?.stringForColumn("msg_url"))!
                let Create_at:AnyObject = (results?.stringForColumn("created_at"))!
                //print(Create_at)
                let receiver:AnyObject = (results?.stringForColumn("receiver"))!
                let images:AnyObject = (results?.stringForColumn("images"))!
                let server_id:AnyObject = (results?.stringForColumn("server_msg_id"))!
                
                //var role:Role = Role.Sender
                var role:ChatBubbleMessageType = ChatBubbleMessageType.YourMessage
                
                
                if(receiver as! String == "0")
                {
                    //role = Role.Receive
                    role = ChatBubbleMessageType.YourMessage
                    
                    
                }else
                {
                    //role = Role.Sender
                    role = ChatBubbleMessageType.MyMessage
                }
                
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                
                var messageDate = NSDate()
                if   let date = dateFormatter.dateFromString(Create_at as! String)
                {
                    messageDate  = date
                }
                
                
                
                let message = ChatBubbleMessage(text: DecodeMSG, date:Create_at as! String , type: role ,getmsg_images:images as! String,getimages_directry:images_direc as! String,getserver_msg_id:server_id as! String,getTimefINterval:messageDate)
                
                let ifHideDate: Bool
                
                if messages.count == 0 || messageDate.timeIntervalSinceDate(messages[messages.count-1].message.TheTimeInterval) > 60*60*12
                {
                    ifHideDate = false
                }
                else
                {
                    ifHideDate = true
                }
                
                
                let cellData = ChatBubbleCellData(message: message, hideDate: ifHideDate)
                messages.append(cellData)
                
            }
            
            
            contactDB.close()
            
            //print(getResultArray)
        } else {
            print("Error: \(contactDB.lastErrorMessage())")
        }
        
        return messages
        
    }
    */
    func InsertsenderMessage(from_user_id:String,msg:String,created_at:String,images:String,strangers:String,server_MsgID:String,var getUserName_SenderTime:String,getUserImage_swenderTime:String,directry_Image:String) -> Int
    {
        delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        var resultReturn:Int = 0
        let contactDB = FMDatabase(path: delegate.databasePath as String)
        
        if contactDB.open() {
          //login_user_id TEXT,from_user_id TEXT,msg TEXT,msg_images TEXT,Create_at TEXT,profile_image TEXT,receiver TEXT,server_msg_id TEXT,user_name TEXT
            getUserName_SenderTime =  getUserName_SenderTime.stringByReplacingOccurrencesOfString("'", withString:"''")
           
            
            //print(msg)
            let messageEncode:String = encodeString(msg);
            
                
                let insertSQL = "INSERT OR REPLACE INTO messages (user_id, from_user_id, msg_content, images, created_at, receiver, server_msg_id,stranger, msg_url, msg_read_status,userName_SenderTime,UserImage_SenderTime) VALUES ('\(delegate.appd_userid)', '\(from_user_id)', '\(messageEncode)', '\(images)', '\(created_at)', '1', '\(server_MsgID)','\(strangers)','\(directry_Image)','1','\(getUserName_SenderTime)','\(getUserImage_swenderTime)')"
               // print(insertSQL)
                let result = contactDB.executeUpdate(insertSQL,
                    withArgumentsInArray: nil)
                
                if !result {
                    //status.text = "Failed to add contact"
                    resultReturn = 0
                    print("Error: \(contactDB.lastErrorMessage())")
                } else {
                    
                    resultReturn = 1
                    //  status.text = "Contact Added"
                    
                }
            
        } else {
            print("Error: \(contactDB.lastErrorMessage())")
        }
        
        return resultReturn
        
    }
    
   
    
    
    func UpdateReadStatus(getUserID:String)
    {
        delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
       // var resultReturn:Int = 0
        let contactDB = FMDatabase(path: delegate.databasePath as String)
        
        if contactDB.open() {
            
            
            
            
            let deleteSQL = "UPDATE messages SET msg_read_status='1' WHERE user_id = '\(delegate.appd_userid)' AND from_user_id  = '\(getUserID)'"
            //print(deleteSQL)
            let result = contactDB.executeUpdate(deleteSQL,
                withArgumentsInArray: nil)
            
            if !result {
                //status.text = "Failed to add contact"
               // resultReturn = 0
                print("Error: \(contactDB.lastErrorMessage())")
            } else {
                
               // resultReturn = 1
                //  status.text = "Contact Added"
                
            }
            
        } else {
            print("Error: \(contactDB.lastErrorMessage())")
        }
        
        
    }
    
    
   

    func DeleteUserByUserID(getUserID:String,strangers:String)
    {
        delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
       // var resultReturn:Int = 0
        let contactDB = FMDatabase(path: delegate.databasePath as String)
        
        if contactDB.open() {
            
            
            
            
            let deleteSQL = "DELETE FROM messages WHERE user_id =\(delegate.appd_userid) and from_user_id =\(getUserID) and stranger=\(strangers)"
            //print(deleteSQL)
            let result = contactDB.executeUpdate(deleteSQL,
                withArgumentsInArray: nil)
            
            if !result {
                //status.text = "Failed to add contact"
               // resultReturn = 0
                print("Error: \(contactDB.lastErrorMessage())")
            } else {
                
               // resultReturn = 1
                //  status.text = "Contact Added"
                
            }
            
        } else {
            print("Error: \(contactDB.lastErrorMessage())")
        }
        
       
    }
    
    
    //Mark :- Insert Follwing channel 
    func InsertFollowChannel(channelName:String,followUnfollow:Int)
    {
        
        if(followUnfollow == 0)
        {
           followChannel(channelName)
        }else
        {
            UnfollowChannel(channelName)
        }
        
        
    }
    
    func  followChannel(channelName:String)
    {
        delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
       
        let contactDB = FMDatabase(path: delegate.databasePath as String)
        
        if contactDB.open() {
       
            let insertSQL = "INSERT OR REPLACE INTO following_channels (user_id, channel_name, isChannelFollowed) VALUES ('\(delegate.appd_userid)', '\(channelName)', '0')"
            
            let result = contactDB.executeUpdate(insertSQL,
                withArgumentsInArray: nil)
            
            if !result {
               
               
                print("Error: \(contactDB.lastErrorMessage())")
            } else {
                
               
                
            }
            
        } else {
            print("Error: \(contactDB.lastErrorMessage())")
        }

    }
    func  UnfollowChannel(channelName:String)
    {
        delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        
        let contactDB = FMDatabase(path: delegate.databasePath as String)
        
        if contactDB.open() {
            
            let insertSQL = "INSERT OR REPLACE INTO following_channels (user_id, channel_name, isChannelFollowed) VALUES ('\(delegate.appd_userid)', '\(channelName)', '1')"
            //print(insertSQL)
            let result = contactDB.executeUpdate(insertSQL,
                withArgumentsInArray: nil)
            
            if !result {
                
                
                print("Error: \(contactDB.lastErrorMessage())")
            } else {
                
                
                
            }
            
        } else {
            print("Error: \(contactDB.lastErrorMessage())")
        }

    }
    
    
    
    //Mark :- Insert Follwing People
    func InsertFollowPeople(peopleName:String,followUnfollow:Int,userid:String,peopleUsername:String,image:String,detail:String)
    {
        if(followUnfollow == 0)
        {
            followpeople(peopleName,peopleUserID: userid,peopleUsername:peopleUsername,image:image,detail:detail)
        }else
        {
            Unfollowpeople(peopleName,peopleUserID: userid)
        }
        
        
    }
    
    func followpeople(peopleName:String,peopleUserID:String,peopleUsername:String,image:String,detail:String)
    {
        delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        
        let contactDB = FMDatabase(path: delegate.databasePath as String)
        
       let peopleUsername_s = peopleUsername.stringByReplacingOccurrencesOfString("'", withString:"*****==****==&&**")
        let detail_s = detail.stringByReplacingOccurrencesOfString("'", withString:"''")
        let peopleName_s = peopleName.stringByReplacingOccurrencesOfString("'", withString:"''")
        if contactDB.open() {
           // follow_peo ,followuser_id TEXT NOT NULL  UNIQUE,followuser_friendly_name TEXT,followuser_name TEXT,image TEXT, detail TEXT)""
            let insertSQL = "INSERT OR REPLACE INTO follow_peo (loginuser_id, followuser_id, followuser_friendly_name,followuser_name,image,detail) VALUES ('\(delegate.appd_userid)', '\(peopleUserID)', '\(peopleName_s)', '\(peopleUsername_s)', '\(image)', '\(detail_s)')"
            
            let result = contactDB.executeUpdate(insertSQL,
                withArgumentsInArray: nil)
            
            if !result {
                
                
                print("Error: \(contactDB.lastErrorMessage())")
            } else {
                
                
                
            }
            
        } else {
            print("Error: \(contactDB.lastErrorMessage())")
        }
        
    }
    func Unfollowpeople(peopleName:String,peopleUserID:String)
    {
        delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
       // var resultReturn:Int = 0
        let contactDB = FMDatabase(path: delegate.databasePath as String)
        
        if contactDB.open() {
            
            
            
            
            let deleteSQL = "DELETE FROM follow_peo WHERE loginuser_id ='\(delegate.appd_userid)' and followuser_id ='\(peopleUserID)' "
            //print(deleteSQL)
            let result = contactDB.executeUpdate(deleteSQL,
                withArgumentsInArray: nil)
            
            if !result {
                //status.text = "Failed to add contact"
               // resultReturn = 0
                print("Error: \(contactDB.lastErrorMessage())")
            } else {
                
               // resultReturn = 1
                //  status.text = "Contact Added"
                
            }
            
        } else {
            print("Error: \(contactDB.lastErrorMessage())")
        }
        
    }

    func gepeopleByName(getPeopleText:String) -> NSMutableArray
    {
        
        var sliced:String! = ""
        if((getPeopleText.characters.count) > 0)
        {
            sliced = String(getPeopleText.characters.dropFirst())//dropFirst(getPeopleText)
        }else
        {
            sliced = ""
        }
        
        delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let getResultArray:NSMutableArray = NSMutableArray()
        let contactDB = FMDatabase(path: delegate.databasePath as String)
        
        if contactDB.open() {
            let querySQL = "SELECT followuser_name FROM follow_peo WHERE loginuser_id =\(delegate.appd_userid) and followuser_name LIKE '\(sliced)%'"
             //print(querySQL)
            let results:FMResultSet? = contactDB.executeQuery(querySQL,
                withArgumentsInArray: nil)
            /*
            follow_peo (no INTEGER PRIMARY KEY  AUTOINCREMENT  NOT NULL  UNIQUE , loginuser_id TEXT  NOT NULL,followuser_id TEXT NOT NULL  UNIQUE,followuser_name TEXT)"
            

            */
            while ((results?.next()) == true) {
                // Get the column data for this record and put it into a custom Record object
                
                let followuser_name:AnyObject = (results?.stringForColumn("followuser_name"))!
               
               // print(followuser_name)
                
                
                var dict = [String: AnyObject]()
                dict["followuser_name"] = followuser_name
                getResultArray.addObject(dict)
                
            }
            
            
            contactDB.close()
            
            //print(getResultArray)
        } else {
            print("Error: \(contactDB.lastErrorMessage())")
        }
        
        return getResultArray
        
    }
    
    func gepeopleCount() -> Int
    {
        
        var countOFTotal:Int!;
        
        delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let contactDB = FMDatabase(path: delegate.databasePath as String)
        
        if contactDB.open() {
            let querySQL = "SELECT Count(*) as getCount FROM follow_peo WHERE loginuser_id ='\(delegate.appd_userid)'"
            //print(querySQL)
            let results:FMResultSet? = contactDB.executeQuery(querySQL,
                withArgumentsInArray: nil)
           
            while ((results?.next()) == true) {
                // Get the column data for this record and put it into a custom Record object
                
                let getCount:AnyObject = (results?.stringForColumn("getCount"))!
                
                
                
                
               countOFTotal = Int(getCount as! String)//.toInt()
                
            }
            
            
            contactDB.close()
            
            //print(getResultArray)
        } else {
            print("Error: \(contactDB.lastErrorMessage())")
        }
        
        return countOFTotal
        
    }

    
    
    func insertfollowPeopleArray(getWCArray:NSArray)
    {
        
        delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        
        let contactDB = FMDatabase(path: delegate.databasePath as String)
        
        if contactDB.open() {
            
            
             //print(getWCArray.count)
            
            for var i = 0 ; i < getWCArray.count ; i++
            {
                let profile_image:String! = getWCArray.objectAtIndex(i).valueForKey("profile_image") as! String
                let bMute:String! = getWCArray.objectAtIndex(i).valueForKey("bMute") as! String
                var details:String! = getWCArray.objectAtIndex(i).valueForKey("details") as! String
                details = details.stringByReplacingOccurrencesOfString("'", withString:"''")
                
                var user_friendly_name:String! = getWCArray.objectAtIndex(i).valueForKey("user_friendly_name") as! String
               
                user_friendly_name  = user_friendly_name.stringByReplacingOccurrencesOfString("'", withString:"*****==****==&&**")
               // print("user_friendly_name==\(user_friendly_name)==")
                let user_id:String! = getWCArray.objectAtIndex(i).valueForKey("user_id") as! String
                var user_name:String! = getWCArray.objectAtIndex(i).valueForKey("user_name") as! String
              user_name = user_name.stringByReplacingOccurrencesOfString("'", withString:"''")
                
                
               let insertSQL = "INSERT OR REPLACE INTO follow_peo (loginuser_id, followuser_id, followuser_friendly_name,followuser_name,image,detail,mute) VALUES ('\(delegate.appd_userid)', '\(user_id)', '\(user_friendly_name)', '\(user_name)', '\(profile_image)', '\(details)','\(bMute)')"
                
                let result = contactDB.executeUpdate(insertSQL,
                    withArgumentsInArray: nil)
                
                
                
                self.insertFromUserImage_TimelinePage(profile_image, userFriendlyName: user_friendly_name, UserName: user_name, UserID: user_id)
                if !result {
                    //status.text = "Failed to add contact"
                    
                    print("Error: \(contactDB.lastErrorMessage())")
                } else {
                    
                    
                    //  status.text = "Contact Added"
                    
                }
            }
        } else {
            print("Error: \(contactDB.lastErrorMessage())")
        }
        
        
        
    }
    
    
    func UpdateStrange_FollowUnfollow(getUserID:String,stranger:String)
    {
        delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
       // let resultReturn:Int = 0
        let contactDB = FMDatabase(path: delegate.databasePath as String)
        
        if contactDB.open() {
            
            
            
            
            let deleteSQL = "UPDATE messages SET stranger='\(stranger)' WHERE user_id = '\(delegate.appd_userid)' AND from_user_id  = '\(getUserID)'"
            //print(deleteSQL)
            let result = contactDB.executeUpdate(deleteSQL,
                withArgumentsInArray: nil)
            
            if !result {
                //status.text = "Failed to add contact"
               // resultReturn = 0
                print("Error: \(contactDB.lastErrorMessage())")
            } else {
                
               // resultReturn = 1
                //  status.text = "Contact Added"
                
            }
            
        } else {
            print("Error: \(contactDB.lastErrorMessage())")
        }
        
        
    }

    //SELECT Count(*) FROM messages WHERE user_id = '3221128362' AND stranger = '0' AND receiver = '0' AND msg_read_status = '0'
    
    func getCountOFNewMEssages() -> String
    {
        
        var Count:String! = ""
        
        
        delegate = UIApplication.sharedApplication().delegate as! AppDelegate
       
        let contactDB = FMDatabase(path: delegate.databasePath as String)
        
        if contactDB.open() {
            let querySQL = "SELECT Count(*) as getCount FROM messages WHERE user_id = '\(delegate.appd_userid)' AND stranger = '0' AND receiver = '0' AND msg_read_status = '0'"
            //print(querySQL)
            let results:FMResultSet? = contactDB.executeQuery(querySQL,
                withArgumentsInArray: nil)
          
            while ((results?.next()) == true) {
                // Get the column data for this record and put it into a custom Record object
                
                let followuser_name:AnyObject = (results?.stringForColumn("getCount"))!
                
                
                Count = followuser_name as! String
        
            }
            
            
            contactDB.close()
            
            //print(getResultArray)
        } else {
            print("Error: \(contactDB.lastErrorMessage())")
        }
        
        return Count
        
    }


    func getFollowChannelName() -> NSMutableArray
    {
        
       // let sliced:String! = ""
        
        delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let getResultArray:NSMutableArray = NSMutableArray()
        let contactDB = FMDatabase(path: delegate.databasePath as String)
        
        if contactDB.open() {
            let querySQL = "SELECT channel_name FROM following_channels WHERE user_id =\(delegate.appd_userid) and isChannelFollowed ='0'"
            //print(querySQL)
            let results:FMResultSet? = contactDB.executeQuery(querySQL,
                withArgumentsInArray: nil)
            /*
            follow_peo (no INTEGER PRIMARY KEY  AUTOINCREMENT  NOT NULL  UNIQUE , loginuser_id TEXT  NOT NULL,followuser_id TEXT NOT NULL  UNIQUE,followuser_name TEXT)"
            
            
            */
            while ((results?.next()) == true) {
                // Get the column data for this record and put it into a custom Record object
                
                let chan_name_db:AnyObject = (results?.stringForColumn("channel_name"))!
                
                
                
                
                var dict = [String: AnyObject]()
                dict["chan_name"] = chan_name_db
                getResultArray.addObject(dict)
                
            }
            
            
            contactDB.close()
            
            //print(getResultArray)
        } else {
            print("Error: \(contactDB.lastErrorMessage())")
        }
        
        return getResultArray
        
    }
    func AllreadMEssage(stranger:String)
    {
        delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
       // var resultReturn:Int = 0
        let contactDB = FMDatabase(path: delegate.databasePath as String)
        
        if contactDB.open() {
            
            
            
            
            let deleteSQL = " UPDATE messages SET msg_read_status = '1' WHERE user_id = '\(delegate.appd_userid)' AND stranger = '\(stranger)'"
            //print(deleteSQL)
            let result = contactDB.executeUpdate(deleteSQL,
                withArgumentsInArray: nil)
            
            if !result {
                //status.text = "Failed to add contact"
                //resultReturn = 0
                print("Error: \(contactDB.lastErrorMessage())")
            } else {
                
               // resultReturn = 1
                //  status.text = "Contact Added"
                
            }
            
        } else {
            print("Error: \(contactDB.lastErrorMessage())")
        }
        
        
    }
   
    
    func UpdateChatDirectryLink(serverMsgID:String,DirectryLink:String)
    {
        delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        //var resultReturn:Int = 0
        let contactDB = FMDatabase(path: delegate.databasePath as String)
        
        if contactDB.open() {
            
            
            
            
            let deleteSQL = "UPDATE messages SET msg_url ='\(DirectryLink)' WHERE server_msg_id = '\(serverMsgID)'"
            //print(deleteSQL)
            let result = contactDB.executeUpdate(deleteSQL,
                withArgumentsInArray: nil)
            
            if !result {
                //status.text = "Failed to add contact"
                //resultReturn = 0
                print("Error: \(contactDB.lastErrorMessage())")
            } else {
                
                //resultReturn = 1
                //  status.text = "Contact Added"
                
            }
            
        } else {
            print("Error: \(contactDB.lastErrorMessage())")
        }
        
        
    }

    func DeleteMsgBYmsgid(getmsgId:String)-> Int
    {
        delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        var resultReturn:Int = 0
        let contactDB = FMDatabase(path: delegate.databasePath as String)
        
        if contactDB.open() {
            
            
            
            
            let deleteSQL = "DELETE FROM messages WHERE server_msg_id =\(getmsgId) "
            //print(deleteSQL)
            let result = contactDB.executeUpdate(deleteSQL,
                withArgumentsInArray: nil)
            
            if !result {
                //status.text = "Failed to add contact"
            resultReturn = 0
                print("Error: \(contactDB.lastErrorMessage())")
            } else {
                
                resultReturn = 1
                //  status.text = "Contact Added"
                
            }
            
        } else {
            print("Error: \(contactDB.lastErrorMessage())")
        }
        return resultReturn
        
    }
    
    func countOfMessagebymeToAnyUser(fromUserID:String)-> Int

    {
        
            delegate = UIApplication.sharedApplication().delegate as! AppDelegate
            var getResult:Int!
            let contactDB = FMDatabase(path: delegate.databasePath as String)
            
            if contactDB.open() {
                
                
                let querySQL = "SELECT Count(*) as msgcount FROM messages WHERE user_id = '\(delegate.appd_userid)' AND from_user_id = '\(fromUserID)' AND receiver = '1' "
              //receiver = '1' means me , my message check
                 //print(querySQL)
                
                let results:FMResultSet? = contactDB.executeQuery(querySQL,
                    withArgumentsInArray: nil)
                
                while ((results?.next()) == true) {
                    // Get the column data for this record and put it into a custom Record object
                    
                    let msgcount:AnyObject = (results?.stringForColumn("msgcount"))!
                    
                    getResult = Int(msgcount as! String)//.toInt()
                    
                    
                    
                }
                
                
                contactDB.close()
                
                
            } else {
                print("Error: \(contactDB.lastErrorMessage())")
            }
            
            return getResult
            
            
        
    }
    
    func encodeString(getText:String) -> String
    {
        
        
        let originalString = getText
        let customAllowedSet =  NSCharacterSet(charactersInString:"=\"#%/*()<>?,:;&.'!@\\^`{|}$[] \n£^+_~•€").invertedSet
        let escapedString:String! = originalString.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)
        
        
        
        
        return escapedString
        
    }
    func Check_channelName_ExistOrNot(getChannelname:String) -> Bool
    {
        
       
        var ISCheck:Bool = false;
        delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        //let getResultArray:NSMutableArray = NSMutableArray()
        let contactDB = FMDatabase(path: delegate.databasePath as String)
        
        if contactDB.open() {
            let querySQL = "SELECT channel_name FROM following_channels WHERE user_id ='\(delegate.appd_userid)' and isChannelFollowed ='0' and UPPER (channel_name) = UPPER('\(getChannelname.uppercaseString)')"
           // print(querySQL)
            let results:FMResultSet? = contactDB.executeQuery(querySQL,
                withArgumentsInArray: nil)
            
            while ((results?.next()) == true) {
                // Get the column data for this record and put it into a custom Record object
                
               // let chan_name_db:AnyObject = (results?.stringForColumn("channel_name"))!
                
              //print(chan_name_db)
                
                ISCheck = true
                
            }
            
            
            contactDB.close()
            
            //print(getResultArray)
        } else {
            //print("Error: \(contactDB.lastErrorMessage())")
            ISCheck = false
        }
        
        return ISCheck
        
    }
    
    func getUserNameByID(userID:String) -> String
    {
        delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        var getResult:String!
        let contactDB = FMDatabase(path: delegate.databasePath as String)
        
        if contactDB.open() {
            
            
            let querySQL = "SELECT username  FROM userImage WHERE from_user_id = '\(userID)'"
            
            // print(querySQL)
            
            let results:FMResultSet? = contactDB.executeQuery(querySQL,
                withArgumentsInArray: nil)
            
            while ((results?.next()) == true) {
                // Get the column data for this record and put it into a custom Record object
                
                let getusername:AnyObject = (results?.stringForColumn("username"))!
               // print(getusername)
                getResult = getusername as! String
                
                
                
            }
            
            
            contactDB.close()
            
            
        } else {
            print("Error: \(contactDB.lastErrorMessage())")
        }
        
        return getResult
        
        
    }
    
    
    func RemoveAllFollowingChannel()
    {
        delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        // var resultReturn:Int = 0
        let contactDB = FMDatabase(path: delegate.databasePath as String)
        
        if contactDB.open() {
            
            
            
            
            let deleteSQL = "UPDATE following_channels SET isChannelFollowed='1' WHERE user_id = '\(delegate.appd_userid)' "
            //print(deleteSQL)
            let result = contactDB.executeUpdate(deleteSQL,
                withArgumentsInArray: nil)
            
            if !result {
                //status.text = "Failed to add contact"
                // resultReturn = 0
                print("Error: \(contactDB.lastErrorMessage())")
            } else {
                
                // resultReturn = 1
                //  status.text = "Contact Added"
                
            }
            
        } else {
            print("Error: \(contactDB.lastErrorMessage())")
        }
        

        
}
    
}
