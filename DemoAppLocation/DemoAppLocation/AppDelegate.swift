//
//  AppDelegate.swift
//  DemoAppLocation
//
//  Created by $hivang on 06/09/16.
//  Copyright © 2016 Adiosft. All rights reserved.
//

import UIKit
import CoreLocation
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate , CLLocationManagerDelegate {

    var window: UIWindow?
     let geoCoder = CLGeocoder()
    var lat_device_second:String = ""  // every second update
    var long_device_second:String = ""
 let locationManager = CLLocationManager()
var currentLocation:CLLocation = CLLocation(latitude: 0, longitude: 0)
    var locationAuthorizationStatus:CLAuthorizationStatus!
    
    var locationName:String = ""
    var street:String = ""
    var city:String = ""
    var zip:String = ""
    var country:String = ""
      var distance:String = ""
    let aDataBase : databaseinit = databaseinit()
     var databasePath = NSString()
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil))
        let dirPaths =
        NSSearchPathForDirectoriesInDomains(.DocumentDirectory,
            .UserDomainMask, true)
        
        let docsDir = dirPaths[0]
        databasePath = (docsDir as NSString).stringByAppendingPathComponent("JiveMap.db")
        
        //   print(databasePath)
        aDataBase.InitDatabas()
        self.initLocationManager()
        return true
    }
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
       //you have travelled more than 50 meter
        let ac = UIAlertController(title: "Notification", message: "You have travelled more than 50 meter.", preferredStyle: .Alert)
        ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        self.window?.rootViewController?.presentViewController(ac, animated: true, completion: nil)
        
        
        
    }
    func initLocationManager() {
        
        
        
            self.locationManager.delegate = self
            self.locationManager.distanceFilter  = kCLDistanceFilterNone // Must move at least 1km
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            self.locationManager.requestWhenInUseAuthorization()
            self.locationManager.startUpdatingLocation()
            
    
        
        
    }
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError)
    {
        
      print(error.localizedDescription)
        
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
         print(locations)
        
        
        currentLocation = locations[0] ;
       lat_device_second = String(stringInterpolationSegment: currentLocation.coordinate.latitude)
        long_device_second = String(stringInterpolationSegment: currentLocation.coordinate.longitude)
        
        
       
      
        
        geoCoder.reverseGeocodeLocation(currentLocation, completionHandler: { (placemarks, error) -> Void in
            
            if error != nil {
                print("Reverse geocoder failed with error" + error!.localizedDescription)
                return
            }

            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]
            
            // Address dictionary
            print(placeMark.addressDictionary?.keys)
            
            // Location name
            if let locationName1 = placeMark.addressDictionary!["SubLocality"] as? NSString {
                print(locationName1)
                self.locationName = locationName1 as String
            }
            
            // Street address
            if let street1 = placeMark.addressDictionary!["Thoroughfare"] as? NSString {
                print(street1)
                 self.street = street1 as String
            }
            
            // City
            if let city1 = placeMark.addressDictionary!["City"] as? NSString {
                print(city1)
                  self.city = city1 as String
            }
            
            // Zip code
            if let zip1 = placeMark.addressDictionary!["ZIP"] as? NSString {
                print(zip1)
                self.zip = zip1 as String
            }
            
            // Country
            if let country1 = placeMark.addressDictionary!["Country"] as? NSString {
                print(country1)
                 self.country = country1 as String
            }
            
           
            if NSUserDefaults.standardUserDefaults().objectForKey("old") == nil {
                
               
                let mapAnnotations = NSUserDefaults.standardUserDefaults()
                
                let lat = String(stringInterpolationSegment: self.currentLocation.coordinate.latitude)
                let lon = String(stringInterpolationSegment: self.currentLocation.coordinate.longitude)
                let userLocation: NSDictionary = ["lat": lat, "long": lon]
                mapAnnotations.setObject(userLocation, forKey: "old") //the error is here
                mapAnnotations.synchronize()
                
           
            
            
            
            }else
            
            {
                
            
                
                let userLocation = NSUserDefaults.standardUserDefaults().objectForKey("old") as! NSDictionary
                
                let delegatelat_device_Compose_Screen = userLocation.objectForKey("lat") as! String
                let delegatelong_device_Compose_Screen = userLocation.objectForKey("long") as! String

                let myLocation = CLLocation(latitude: (delegatelat_device_Compose_Screen as NSString).doubleValue, longitude:(delegatelong_device_Compose_Screen as NSString).doubleValue)
                
                let distanceInMeters = myLocation.distanceFromLocation(self.currentLocation)
                
                  if distanceInMeters > 50
                  {
                
                    
                    let string = NSDate().description
                    let get = self.aDataBase.InsertNotification(string) as Int
                    if get == 1
                    {
                        let notification = UILocalNotification()
                        notification.alertBody = "You have travelled more than 50 meter."
                        notification.fireDate = NSDate() //Setup desired date/time here
                        UIApplication.sharedApplication().scheduleLocalNotification(notification)
                        let mapAnnotations = NSUserDefaults.standardUserDefaults()
                        
                        let lat = String(stringInterpolationSegment: self.currentLocation.coordinate.latitude)
                        let lon = String(stringInterpolationSegment: self.currentLocation.coordinate.longitude)
                        let userLocation: NSDictionary = ["lat": lat, "long": lon]
                        mapAnnotations.setObject(userLocation, forKey: "old") //the error is here
                        mapAnnotations.synchronize()

                    
                    
                    }
                    
                }
                let b:String = String(format:"%f", distanceInMeters)
                self.distance = b
            }
            
            NSNotificationCenter.defaultCenter().postNotificationName("CallPushNotifiaction", object: placeMark,
                userInfo: nil);
    })
    
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
//        CLGeocoder().reverseGeocodeLocation(currentLocation, completionHandler: {(placemarks, error) -> Void in
//          
//            
//            if error != nil {
//                print("Reverse geocoder failed with error" + error!.localizedDescription)
//                return
//            }
//            
//            if placemarks!.count > 0 {
//                let pm = placemarks![0] 
//                print(pm.locality)
//            }
//            else {
//               print("Problem with the data received from geocoder")
//            }
//        })
    }
    
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus)
    {
        switch status {
        case CLAuthorizationStatus.Restricted:
            print("Restricted Access to location")
        case CLAuthorizationStatus.Denied:
           print("User denied access to location")
        case CLAuthorizationStatus.NotDetermined:
           print("Status not determined")
        default:
             self.initLocationManager()
            print("Allowed to location Access")
            //shouldIAllow = true
        }
    }
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

