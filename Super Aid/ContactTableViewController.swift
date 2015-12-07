/*************************************************************************************************************
 *                                                                                                           *
 *   ContactTableViewViewController.swift                                                                    *
 *   Super Aid - Group 8                                                                                     *
 *                                                                                                           *
 *   Authors:                                                                                                *
 *   John Xiang                                                                                              *
 *   References: Apple iOS Developers                                                                        *
 *                                                                                                           *
 *   Version 1.0                                                                                             *
 *   - text fields contain pre-set values                                                                    *
 *   - text fields open correct keyboards                                                                    *
 *   - keyboard hides after return/ background tap                                                           *
 *                                                                                                           *
 *                                                                                                           *
 *   Version 2.0                                                                                             *
 *   - renamed to ContactTableViewController.swift from emergencyContact.swift                               *
 *   - Data persistance after app restart/shutdown using NSCoding                                            *
 *   - Supports deleting and rearranging through Edit mode                                                   *
 *   - Updates cells with inputted data                                                                      *
 *   - Unwind segue that connects to ContactViewController's save button to add row to table                 *
 *   - Two segues to MedicatoinViewController depending if user pressed cell or add button                   *
 *   - Edit and add button                                                                                   *
 *                                                                                                           *
 *   Bugs                                                                                                    *
 *    -Newly added contact doesn't show on table view (invisible?)                                           *
 *    -Pressing on existing contact and pressing save causes contact name to turn invisible                  *
 *                                                                                                           *
 *************************************************************************************************************/

import UIKit
import MessageUI

class ContactTableViewController: UITableViewController, MFMessageComposeViewControllerDelegate {
    
    // MARK: Properties
    var contacts = [Contact]()

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        // load any saved contacts, otherwise load sample data
        if let savedContacts = loadContacts() {
            
            contacts += savedContacts
        } else {
            // load sample contacts
            loadSampleContacts()
        }
        
        // sendText()

    }
    
    func loadSampleContacts() {
        
        let c1 = Contact(name: "John", alertMessage: "Default", number: "000-000-0000")!
        let c2 = Contact(name: "Victor", alertMessage: "Default", number: "111-111-1111")!
        let c3 = Contact(name: "Jerry", alertMessage: "Default", number: "222-222-2222")!
        let c4 = Contact(name: "Gary", alertMessage: "Default", number: "333-333-3333")!
        
        contacts += [c1, c2, c3, c4]
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
    
        return contacts.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "ContactCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! ContactTableViewCell

        // fetches appropriate contact for data source layout
        let contact = contacts[indexPath.row]
        
        cell.contactName.text = contact.name

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
            contacts.removeAtIndex(indexPath.row)
            saveContacts()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }



    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }


    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

   
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if segue.identifier == "ShowDetail" {
            
            let contactDetailViewController = segue.destinationViewController as! ContactViewController
            
            if let selectedContactCell = sender as? ContactTableViewCell {
                
                let indexPath = tableView.indexPathForCell(selectedContactCell)!
                let selectedContact = contacts[indexPath.row]
                
                contactDetailViewController.contact = selectedContact
            }
        
        } else if segue.identifier == "AddItem" {
            // adding contact
        }
    }


    @IBAction func unwindToContactList(sender: UIStoryboardSegue) {
        
        if let sourceViewController = sender.sourceViewController as? ContactViewController, contact = sourceViewController.contact {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                
                // update existing contact
                contacts[selectedIndexPath.row] = contact
                tableView.reloadRowsAtIndexPaths([selectedIndexPath], withRowAnimation: .None)
                
            } else {

                // add new contact
                let newIndexPath = NSIndexPath(forRow: contacts.count, inSection: 0)
                contacts.append(contact)
                tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
            }
            
            // saves contact
            saveContacts()
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
    
    // sends text messages to user's emergeny contacts
    func sendText() {
        if MFMessageComposeViewController.canSendText() {
            
            let controller = MFMessageComposeViewController()
            // get user's device name (in the form user's iPhone)
            let deviceName = UIDevice.currentDevice().name
            // remove 's iPhone from the deviceName string
            let userName = deviceName.stringByReplacingOccurrencesOfString("'s iPhone", withString: "")
            controller.body = userName + " Has fallen. Please send help."
            // set recipients to contacts
            for var index = 0; index < contacts.count; index++ {
                controller.recipients?.append(contacts[index].number)
            }
            controller.messageComposeDelegate = self
            self.presentViewController(controller, animated: true, completion: nil)
        }
    }
    
    // MARK: MFMEssageComposeViewControllerDelegate
    
    // dismisses sms screen
    func messageComposeViewController(controller: MFMessageComposeViewController, didFinishWithResult result: MessageComposeResult) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
    }
    
    // MARK: NSCoding
    
    // saves contacts
    func saveContacts() {
        
        let isSucessfulSave = NSKeyedArchiver.archiveRootObject(contacts, toFile: Contact.ArchiveURL.path!)
        
        if !isSucessfulSave {
            print("Failed to save contacts")
        }
    }
    
    // load contacts
    func loadContacts() -> [Contact]? {
        
        return NSKeyedUnarchiver.unarchiveObjectWithFile(Contact.ArchiveURL.path!) as? [Contact]
    }
    
}
