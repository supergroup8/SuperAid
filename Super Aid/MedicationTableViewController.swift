/*************************************************************************************************************
 *                                                                                                           *
 *   MedicationTableViewViewController.swift                                                                 *
 *   Super Aid - Group 8                                                                                     *
 *                                                                                                           *
 *   Authors:                                                                                                *
 *   John Xiang                                                                                              *
 *   References: Apple iOS Developers                                                                        *
 *                                                                                                           *
 *   Version 1.0                                                                                             *
 *   - Data persistance after app restart/shutdown using NSCoding                                            *
 *   - Supports deleting and rearranging through Edit mode                                                   *
 *   - Updates cells with inputted data                                                                      *
 *   - Unwind segue that connects to MedicationViewController's save button to add row to table              *
 *   - Two segues to LocationViewController depending if user pressed cell or add button                     *
 *   - Edit and add button                                                                                   *
 *                                                                                                           *
 *   Bugs                                                                                                    *
 *    -Newly added medicaiton doesn't show on table view (invisible?)                                        *
 *    -Pressing on existing medication and pressing save causes contact name to turn invisible               *
 *                                                                                                           *
 *************************************************************************************************************/

import UIKit

class MedicationTableViewController: UITableViewController {
    
    // MARK: Properties
    var medications = [Medication]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        // load any saved medication, otherwise load sample data
        if let savedMedications = loadMedications() {
            
            medications += savedMedications
        } else {
            // load sample medication
            loadSampleMedication()
        }
    }
    
    func loadSampleMedication() {
        
        let m1 = Medication(name: "Tyenol", days: ["Mon", "Wed", "Fri"], end: "30-12-2015", dose: "325 mg", type: "painkiller")!
        let m2 = Medication(name: "Altrovent", days: ["Tue", "Thu"], end: "01-01-2016", dose: "500 mg", type: "Respiratory Agent")!
        
        medications += [m1, m2]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return medications.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "MedCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! MedicationTableViewCell
        
        // fetches appropriate medication for data source layout
        let medication = medications[indexPath.row]
        
        cell.medName.text = medication.name
        
        return cell
    }
    
    
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            
            // Delete the row from the data source
            medications.removeAtIndex(indexPath.row)
            saveMedications()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    
 
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "ShowDetail" {
            
            let medicationDetailViewController = segue.destinationViewController as! MedicationViewController
            
            if let selectedMedicationCell = sender as? MedicationTableViewCell {
                
                let indexPath = tableView.indexPathForCell(selectedMedicationCell)!
                let selectedMedication = medications[indexPath.row]
                
                medicationDetailViewController.medication = selectedMedication
            }
            
        } else if segue.identifier == "AddItem" {
            // adding medication
        }
    }
    
    
    @IBAction func unwindToMedicationList(sender: UIStoryboardSegue) {
        
        if let sourceViewController = sender.sourceViewController as? MedicationViewController, medication = sourceViewController.medication {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                
                // update existing medication
                medications[selectedIndexPath.row] = medication
                tableView.reloadRowsAtIndexPaths([selectedIndexPath], withRowAnimation: .None)
                
            } else {
                
                // add new medication
                let newIndexPath = NSIndexPath(forRow: medications.count, inSection: 0)
                medications.append(medication)
                tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
            }
            
            // saves medication
            saveMedications()
        }
    }
    
    // MARK: Actions
    
    @IBAction func edit(sender: AnyObject) {
        
        // enable editing mode
        setEditing(!editing, animated: true)
    }
    
    @IBAction func back(sender: UIBarButtonItem) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // MARK: Notificaitons
    func scheduleNotification(medication: Medication) {
        
        /*let dateComponent:NSDateComponents = NSDateComponents()
        dateComponent.hour = 10
        dateComponent.minute = 00
        dateComponent.timeZone = NSTimeZone.systemTimeZone()
        
        let calendar:NSCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let date:NSDate = calendar.dateFromComponents(dateComponent)!*/
        
        let notification:UILocalNotification = UILocalNotification()
        notification.alertBody = "Reminder to take " + medication.name
        //notification.fireDate = date
        notification.fireDate = NSDate(timeIntervalSinceNow: 5)
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.userInfo = ["responsded": "true"]
        notification.repeatInterval = NSCalendarUnit.Weekday
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
    // MARK: NSCoding
    
    // saves medications
    func saveMedications() {
        
        let isSucessfulSave = NSKeyedArchiver.archiveRootObject(medications, toFile: Medication.ArchiveURL.path!)
        
        if !isSucessfulSave {
            // error saving
            print("Failed to save medications")
        }
    }
    
    // load medications
    func loadMedications() -> [Medication]? {
        
        return NSKeyedUnarchiver.unarchiveObjectWithFile(Medication.ArchiveURL.path!) as? [Medication]
    }

}
