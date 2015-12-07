/************************************************************
 *
 *   fallSafe.swift
 *   Super Aid - Group 8
 *
 *   Authors:
 *   Jerry Chen
 *   Gary Atwal
 *   John Xiang
 *   Victor Yun
 *
 *   Version 1.0
 *   - created back button on navigation bar
 *   - Added ability to retrieve acceleration and rotation data in XYZ axis
 *   - Wrote function stubs for detecting falls
 *
 *
 *   version 2.0
 *   - detects fall by acceleration
 *
 *   version 3.0
 *   - added send notification function
 *   - added delayed monitor on accelerometer and gyroscope
 *
 ************************************************************/

import UIKit
import CoreMotion

class fallsafe: UIViewController {
    
    //Variables
    var curMaxAccX: Double = 0.0
    var curMaxAccY: Double = 0.0
    var curMaxAccZ: Double = 0.0
    var curMaxRotX: Double = 0.0
    var curMaxRotY: Double = 0.0
    var curMaxRotZ: Double = 0.0
    var motionManager = CMMotionManager()
    
    var vecSumAcc: [Double] = []
    var vecSumRot: [Double] = []
    
    let g = 9.80665 //gravity
    let lowerFallThresholdAcc = 0.35 //acc tend to drop toward 0g when in a free fall state
    let upperFallThresholdAcc = 2.4 //acc goes up dramastically when impact after fall
    let upperFallThresholdGyro = 240.0 //phone spin in fast velocity when impact
    
    
    //FUnctions
    @IBAction func resetMaxVal(){
        curMaxAccX = 0
        curMaxAccY = 0
        curMaxAccZ = 0
        curMaxRotX = 0
        curMaxRotY = 0
        curMaxRotZ = 0
    }
    
    
    override func viewDidLoad() {
        
        self.resetMaxVal()
        //set update interval
        motionManager.accelerometerUpdateInterval = 0.1
        motionManager.gyroUpdateInterval = 0.1
        
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "callContacts:", name: "actionTwo", object: nil)
    }
    
    
    /*func outputAccelerationData(acceleration: CMAcceleration){
    if fabs(acceleration.x) > fabs(curMaxAccX){
    curMaxAccX = acceleration.x
    }
    
    if fabs(acceleration.y) > fabs(curMaxAccY){
    curMaxAccY = acceleration.y
    }
    
    if fabs(acceleration.z) > fabs(curMaxAccZ){
    curMaxAccZ = acceleration.z
    }
    
    }
    
    func outputRotationData(rotation: CMRotationRate){
    if fabs(rotation.x) > fabs(curMaxRotX){
    curMaxRotX = rotation.x
    }
    
    if fabs(rotation.y) > fabs(curMaxRotY){
    curMaxRotY = rotation.y
    }
    
    if fabs(rotation.z) > fabs(curMaxRotZ){
    curMaxRotZ = rotation.z
    }
    
    }*/
    
    func updateVecSumAcc(acceleration: CMAcceleration){
        if vecSumAcc.count == 20 {//store up to 2s
            //print(vecSumAcc.first)
            vecSumAcc.removeFirst()
        }
        vecSumAcc.append(sqrt(pow(acceleration.x,2) + pow(acceleration.y,2) + pow(acceleration.z,2)))
    }
    
    func updateVecSumRot(rotation: CMRotationRate){
        if vecSumRot.count == 20 {//store up to 2s
            // print(vecSumRot.last)
            
            vecSumRot.removeFirst()
        }
        vecSumRot.append(sqrt(pow(rotation.x,2) + pow(rotation.y,2) + pow(rotation.z,2)))
    }
    
    //detecting possible start of the fall
    func freeFallDetect() -> Bool{
        var fall = false
        if vecSumAcc.first < lowerFallThresholdAcc {//if the vecor sum of acceleration drop below the lower fall threshold
            fall = true
        }
        return fall
    }
    
    
    //detecting possible impact after free fall
    func impactDetect(historyAcc: [Double], historyRot: [Double]) -> Bool{
        var impact = false
        var i = 0
        
        while i < historyAcc.count && impact == false{
            if historyAcc[i] >= upperFallThresholdAcc{ //&& historyRot[i] >= upperFallThresholdGyro{
                impact = true
                print("yeaaaa")
                
            }
            i++
        }
        return impact
    }
    
    
    //check if fall occured
    func didFallOccur(){
        var fallOccur = false
        if freeFallDetect() == true && fallOccur == false{
            let historyAcc = vecSumAcc //create a copy of vecSumAcc
            print(historyAcc)
            let historyRot = vecSumRot //create a copy of vecSumRot
            fallOccur = impactDetect(historyAcc, historyRot: historyRot)
            if (fallOccur==true)
            {
                print("yes")
                sendNotification()
            }
        }
    }
    
    //helper function
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    //events that update itself every 0.1 second
    func scheduledTimerWithTimeInterval(){

        delay(2) { NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: ("didFallOccur"), userInfo: nil, repeats: true)} //check for fall every 0.1s}
    }
    
    // schedules a notificaiton via user selected method (ie. banner, alert)
    func sendNotification() {
        
        // check if permission is granted for notifications
        guard let settings = UIApplication.sharedApplication().currentUserNotificationSettings() else { return }
        if settings.types == .None {
            
            let ac = UIAlertController(title: "Alert not sent", message: "Permission to send notifications not granted", preferredStyle: .Alert)
            ac.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
            presentViewController(ac, animated: true, completion: nil)
            return
        }
        
        // initialize local notification object and set properties
        let notification = UILocalNotification()
        notification.category = "FirstCategory"
        notification.fireDate = NSDate(timeIntervalSinceNow: 2)
        notification.alertBody = "Fall Detected. Did you fall?"
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.userInfo = ["responsded": "true"]
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
    // function that calls the user's emergency contacts
    func callContacts(notification:NSNotification) {
        

    }
    
    // returns to main menu when back button pressed
    @IBAction func backPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}
