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
        remind()
        // Do any additional setup after loading the view.
    }

    // MARK: Actions
    
    // return to main menu
    @IBAction func backPressed(sender: UIBarButtonItem) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func remind () {
        
        let medView = MedicationTableViewController()
        let medViewMedications = medView.loadMedications()
        let date = NSDate()
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let myComponents = myCalendar.components(.Weekday, fromDate: date)
        let weekDay = myComponents.weekday
        
        for var index = 0; index < medViewMedications!.count; index++ {
            
            print (medViewMedications![index].name)
            for var dateIndex = 0; dateIndex < medViewMedications![index].daysToTake.count; dateIndex++ {
                
                switch weekDay {
                    
                case 1: if medViewMedications![index].daysToTake[dateIndex] == "Sun" {
                    medView.scheduleNotification(medViewMedications![index])
                    }
                case 2: if medViewMedications![index].daysToTake[dateIndex] == "Mon" {
                    medView.scheduleNotification(medViewMedications![index])
                    }
                case 3: if medViewMedications![index].daysToTake[dateIndex] == "Tue" {
                    medView.scheduleNotification(medViewMedications![index])
                    }
                case 4: if medViewMedications![index].daysToTake[dateIndex] == "Wed" {
                    medView.scheduleNotification(medViewMedications![index])
                    }
                case 5: if medViewMedications![index].daysToTake[dateIndex] == "Thu" {
                    medView.scheduleNotification(medViewMedications![index])
                    }
                case 6: if medViewMedications![index].daysToTake[dateIndex] == "Fri" {
                    medView.scheduleNotification(medViewMedications![index])
                    }
                case 7: if medViewMedications![index].daysToTake[dateIndex] == "Sat" {
                    medView.scheduleNotification(medViewMedications![index])
                    }
                default: print("weekday not found")
                }
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
