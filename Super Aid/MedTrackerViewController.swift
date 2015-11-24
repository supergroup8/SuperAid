/************************************************************************
 *                                                                      *
 *   MedTrackerViewController.swift                                     *
 *   Super Aid - Group 8                                                *
 *                                                                      *
 *   Authors:                                                           *
 *   John Xiang                                                         *
 *                                                                      *
 *   Version 1.0                                                        *
 *   - View controller for MedTracker storyboard
 *   -
 *                                                                      *
 ************************************************************************/

import UIKit

class MedTrackerViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    // MARK: Actions
    
    // return to main menu
    @IBAction func backPressed(sender: UIBarButtonItem) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
