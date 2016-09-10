//
//  ViewController.swift
//  DemoAppLocation
//
//  Created by $hivang on 06/09/16.
//  Copyright © 2016 Adiosft. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
class ViewController: UIViewController , UITableViewDataSource , UITableViewDelegate {

    
    
    @IBOutlet var lblLat: UILabel!
    
    @IBOutlet var lblLong: UILabel!
    
    @IBOutlet var lblAddress: UILabel!
    
    @IBOutlet var lblDistance: UILabel!
    @IBOutlet var viewTab2: UIView!
     var delegate: AppDelegate!
    
    @IBOutlet var viewtab3: UIView!
    var getNotification:NSMutableArray!
    
    @IBOutlet var table: UITableView!
    let aDataBase : databaseinit = databaseinit()
    var annot:Bool!
    @IBOutlet var map: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewTab2.hidden = true
          self.viewtab3.hidden = true
         delegate = UIApplication.sharedApplication().delegate as! AppDelegate
         NSNotificationCenter.defaultCenter().addObserver(self, selector: "onMessageReceived:", name: "CallPushNotifiaction", object: nil)
          self.getNotification = NSMutableArray()
        
        self.annot = false
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    func onMessageReceived(place:CLPlacemark)
{
        self.lblLat.text = delegate.lat_device_second
      self.lblLong.text = delegate.long_device_second
      self.lblAddress.text = "\(delegate.locationName) \(delegate.street) \(delegate.city) \(delegate.country) \(delegate.zip)"
    
    print(delegate.distance)
    
       self.lblDistance.text = delegate.distance
    if self.annot == false{
    let latDelta:CLLocationDegrees = 0.01
    
    let longDelta:CLLocationDegrees = 0.01
    
    let theSpan:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta)
    let pointLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake((delegate.lat_device_second as NSString).doubleValue ,(delegate.long_device_second as NSString).doubleValue)
    
    let region:MKCoordinateRegion = MKCoordinateRegionMake(pointLocation, theSpan)
    self.map.setRegion(region, animated: true)
    
    let pinLocation : CLLocationCoordinate2D = pointLocation
    let objectAnnotation = MKPointAnnotation()
    objectAnnotation.coordinate = pinLocation
    objectAnnotation.title = "My Location"
    self.map.addAnnotation(objectAnnotation)
    self.annot = true
    }
    }
    
    
    @IBAction func tab1(sender: AnyObject) {
        
          self.viewTab2.hidden = true
        self.viewtab3.hidden = true
        
    }
    
    
    @IBAction func tab2(sender: AnyObject) {
        self.viewTab2.hidden = false
          self.viewtab3.hidden = true
    }
    
    
    @IBAction func tab3(sender: AnyObject) {
        self.getNotification = self.aDataBase.getNotification("")
        
        if self.getNotification.count > 0
        {
            print(self.getNotification)
            self.table.reloadData()
        }

          self.viewTab2.hidden = true
          self.viewtab3.hidden = false
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        
        //print("\(ary_mutable_tandingjive.count)")
        
        if self.getNotification.count > 0
        {
            
           
            return self.getNotification.count
        }
        return 0
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell4 = tableView.dequeueReusableCellWithIdentifier("TableViewCell", forIndexPath: indexPath) as! TableViewCell
        cell4.selectionStyle = UITableViewCellSelectionStyle.None
        
        cell4.lblnymber.text = "\(indexPath.row+1)"
        let Formatter = NSDateFormatter()
        Formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ" // the format of your string
        Formatter.timeZone = NSTimeZone.systemTimeZone()
        
       
        
        let datte:NSDate = Formatter.dateFromString(self.getNotification.objectAtIndex(indexPath.row) as! String)!
       
        Formatter.dateFormat = "MMM d, H:mm a"
        let ssst = Formatter.stringFromDate(datte)
        
        cell4.lblDay.text = ssst
        return cell4
        
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

