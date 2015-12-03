/************************************************************
 *                                                          *
 *   ViewController.swift                                   *
 *   Super Aid - Group 8                                    *
 *                                                          *
 *   Authors:                                               *
 *   John Xiang                                             *
 *                                                          *
 *   Version 1.0                                            *
 *   - forced portrait mode                                 *
 *   - linked fallSafe button to fallSafe_SB.storyboard     *
 *   - medTracker and TakeMeThere coming soon               *
 *                                                          *
 *                                                          *
 ************************************************************/

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var medTracker_: UIButton!
    @IBOutlet weak var takeMeThere_: UIButton!
    @IBOutlet weak var fallSafe_: UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        sendNotificationLockScreen()

    }
    
    func sendNotificationLockScreen() {
        
        guard let settings = UIApplication.sharedApplication().currentUserNotificationSettings() else { return }
        if settings.types == .None {
            
            let ac = UIAlertController(title: "Alert not sent", message: "Permission to send notifications not granted", preferredStyle: .Alert)
            ac.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
            presentViewController(ac, animated: true, completion: nil)
            return
        }
        
        let notification = UILocalNotification()
        notification.fireDate = NSDate(timeIntervalSinceNow: 2)
        notification.alertBody = "Fall Detected"
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.userInfo = ["responsded": "true"]
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
    
    // forces app to be in portrait mode
    override func shouldAutorotate() -> Bool {
        // checks left landscape and right landscape
        if (UIDevice.currentDevice().orientation == UIDeviceOrientation.LandscapeLeft || UIDevice.currentDevice().orientation == UIDeviceOrientation.LandscapeRight || UIDevice.currentDevice().orientation == UIDeviceOrientation.Unknown) {
            return false
        }
        else {
            return true
        }
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return [UIInterfaceOrientationMask.Portrait ,UIInterfaceOrientationMask.PortraitUpsideDown]
    }
    
    // function for when medTracker button is pressed
    @IBAction func medTrackerPressed(sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "MedTracker_SB", bundle: nil)
        let controller = storyboard.instantiateViewControllerWithIdentifier("InitialController") as UIViewController
        
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    // function for when takeMeThere button is pressed
    @IBAction func takeMeTherePressed(sender: UIButton) {

        let storyboard = UIStoryboard(name: "TakeMeThere_SB", bundle: nil)
        let controller = storyboard.instantiateViewControllerWithIdentifier("InitialController") as UIViewController
        
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    // function for when fallSafe button is pressed
    @IBAction func fallSafePressed(sender: UIButton) {
        
        // load new storyboard
        let storyboard = UIStoryboard(name: "Fallsafe_SB", bundle: nil)
        let controller = storyboard.instantiateViewControllerWithIdentifier("InitialController") as UIViewController
        
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}

