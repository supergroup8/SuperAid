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
    
    var isFall: Bool = false
    var didUserMoveAfterFall: Bool = false
    
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
        motionManager.accelerometerUpdateInterval = 0.2
        motionManager.gyroUpdateInterval = 0.2
        
        //record data
        /*
        motionManager.startAccelerometerUpdatesToQueue(NSOperationQueue.currentQueue()!, withHandler: {(accelerometerData: CMAccelerometerData?, error: NSError?) -> Void
            in
            self.outputAccelerationData(accelerometerData!.acceleration)
            if(error != nil){
                print("\(error)")
            }
        })
        
        motionManager.startGyroUpdatesToQueue(NSOperationQueue.currentQueue()!, withHandler: {(gyroData: CMGyroData?, error: NSError?) -> Void
            in
            self.outputRotationData(gyroData!.rotationRate)
            if(error != nil){
                print("\(error)")
            }
        }) */
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    /*
    func outputAccelerationData(acceleration: CMAcceleration){
        accX?.text = "\(acceleration.x).2fg"
        if fabs(acceleration.x) > fabs(curMaxAccX){
            curMaxAccX = acceleration.x
        }
        
        accY?.text = "\(acceleration.y).2fg"
        if fabs(acceleration.y) > fabs(curMaxAccY){
            curMaxAccY = acceleration.y
        }
        
        accZ?.text = "\(acceleration.z).2fg"
        if fabs(acceleration.z) > fabs(curMaxAccZ){
            curMaxAccZ = acceleration.z
        }
        
        maxAccX?.text = "\(curMaxAccX).2f"
        maxAccY?.text = "\(curMaxAccY).2f"
        maxAccZ?.text = "\(curMaxAccZ).2f"
    }
    */
    
    /*
    func outputRotationData(rotation: CMRotationRate){
        rotX?.text = "\(rotation.x).2fr/s"
        if fabs(rotation.x) > fabs(curMaxRotX){
            curMaxRotX = rotation.x
        }
        
        rotY?.text = "\(rotation.y).2fr/s"
        if fabs(rotation.y) > fabs(curMaxRotY){
            curMaxRotY = rotation.y
        }
        
        rotZ?.text = "\rotation.z).2fr/s"
        if fabs(rotation.z) > fabs(curMaxRotZ){
            curMaxRotZ = rotation.z
        }
        
        maxRotX?.text = "\(curMaxRotX).2f"
        maxRotY?.text = "\(curMaxRotY).2f"
        maxRotZ?.text = "\(curMaxRotZ).2f"
        
        
    }
    */
    
    
    func updateVecSumAcc(){
        if vecSumAcc.count == 20 {//store up to 2s
            vecSumAcc.removeLast()
        }
        vecSumAcc.append(sqrt(pow(curMaxAccX,2) + pow(curMaxAccY,2) + pow(curMaxAccZ,2)))
    }
    
    func updateVecSumRot(){
        if vecSumRot.count == 20 {//store up to 2s
            vecSumRot.removeLast()
        }
        vecSumRot.append(sqrt(pow(curMaxRotX,2) + pow(curMaxRotY,2) + pow(curMaxRotZ,2)))
    }
    
    
    
    //detecting possible start of the fall
    func freeFallDetect() -> Bool{
        var fall = false
        if vecSumAcc.last < lowerFallThresholdAcc {//if the vecor sum of acceleration drop below the lower fall threshold
            fall = true
        }
        return fall
    }
    
    
    //detecting possible impact after free fall
    func impactDetect(historyAcc: [Double], historyRot: [Double]) -> Bool{
        var impact = false
        var i = 14
        
        while i < 18 && impact == false{
            if historyAcc[i] >= upperFallThresholdAcc && historyRot[i] >= upperFallThresholdGyro{
                impact = true
            }
            i++
        }
        return impact
    }
    
    
    //check if fall occured
    func didFallOccur() -> Bool{
        var fallOccur = false
        if freeFallDetect() == true{
            let historyAcc = vecSumAcc //create a copy of vecSumAcc
            let historyRot = vecSumRot //create a copy of vecSumRot
            fallOccur = impactDetect(historyAcc, historyRot: historyRot)
        }
        return fallOccur
    }
    
    
    //helper function
    func runAfterDelay(delay: NSTimeInterval, block: dispatch_block_t) {
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC)))
        dispatch_after(time, dispatch_get_main_queue(), block)
        
    }
    
    // outputAbsoluteAccelerationHistoryAndDetectFall
    // POST: appends the absolute acceleration (i.e. sqrt(accX^2 + accY^2 + accZ^2)) to
    //       absoluteAccelerationHistory array. If a fall is detected, set the member variable
    //       isFall to true, otherwise false.
    //
    //       If a fall is detected, and there is no movement for 5 seconds (default value in settings,
    //       can be changed, need a reference to this variable), send first notification to user and follow
    //       the flow diagram in figure 4 of the user manual.
    func outputAbsoluteAcccelerationHistoryAndDetectFall(acceleration: CMAcceleration){
        // absoluteAccelerationHistory.append(sqrt(acceleration.x^2 + acceleration.y^2 + acceleration.z^2))
        //      To make sure absoluteAccelerationHistory array does not grow to big, need to remove earlier
        //      data in the array that is not used in the analysis. Need to set a time interval (5 - 10s)
        //      for keeping data so that the array has a limited size.
        
        // Analyze absoluteAccelerationHistory to determine if a fall has occurred
        // Call helper function: didFallOccur(acceleration: absoluteAccelerationHistory)
        
        // if isFall == true, then wait for 5s (default value) to see if user responds by
        //                    calling a helper function didUserRespond()
        
        // if isFall == true && didUserMoveAfterFall == true, then reset these two boolean variables to
        // false because the user has not been hurt and is responding after the fall so there is no need
        // to send alerts.
        
        // if isFall == true && didUserMoveAfterFall == false, then send first notification to user and
        // follow the flow diagram in figure 4 of the user manaul. Need to link with alert messages,
        // notifications, GPS, and emergency contacts so that SMS alert messages can be sent to emergency
        // contacts with their current GPS location.
    }
    
    // didFallOccur -- Helper Function for outputAbsoluteAccelerationAndDetectFall
    // PRE: isFall == false
    // PARAMETER: only call this function with input parameter = absoluteAccelerationHistory
    // POST: isFall is set to true if a fall is detected and false otherwise
    func didFallOccur(acceleration: CMAcceleration){
        // Discussion:
        // Look at absoluteAccelerationHistory, to see if the user went from a rest position
        // (i.e. absoluteAcceleration ~ 0 for few consecutive indices) to free falling (i.e.
        // (absoluteAcceleration ~ 1 for a few consecutive indices) to hitting the floor (i.e.
        // (sudden deacceleration will give an absoluteAcceleration > 1 for a couple of consecutive
        // indices and then will = 0 if the phone is not moving once it impacted the ground.)
        
        // If above discussion is true, then set isFall = true otherwise false.
        
        // Note: need to consider other cases of falling down. The case in the above discussion is for when
        // a person falls from being still to free-falling and then being still again.
    }
    
    // didUserRespond -- Helper Function for outputAbsoluteAccelerationAndDetectFall
    // PRE: isFall == true
    // POST: didUserMoveAfterFall is true if user has motion activity after 5s of falling, otherwise false
    func didUserRespond(acceleration: CMAcceleration){
        // Need access to CMMotionActivity class's member variables:
        // Bool stationary
        // Bool walking
        // Bool running
        // Bool automotive
        
        // For 5 seconds (default value)
        //      if (!stationary || walking || running || automotive){ didUserMoveAfterFall = true; exit }
        //      else { didUserMoveAfterFall = false }
    }
     /*
    func scheduleNotification () {
        
        // checks if permission is granted for notification
        guard let settings = UIApplication.sharedApplication().currentUserNotificationSettings() else { return }
        
        if settings.types == .None {
            
            let ac = UIAlertController(title: "Notification failed to send", message: "Permission not granted. Please enable notificaiton permissions in the settings.", preferredStyle: .Alert)
            ac.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
            presentViewController(ac, animated: true, completion: nil)
            return
        }
        
        // create notification object
        let notification = UILocalNotification()
        let dateTime = NSDate()
        // initialize properties
        notification.fireDate = dateTime
        notification.alertBody = "Fall detected"
        notification.soundName = UILocalNotificationDefaultSoundName
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
        
    } */

    // returns to main menu when back button pressed
    @IBAction func backPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}
