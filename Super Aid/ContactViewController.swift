/***************************************************************************************
 *                                                                                     *
 *   ContactViewController.swift                                                       *
 *   Super Aid - Group 8                                                               *
 *                                                                                     *
 *   Authors:                                                                          *
 *   John Xiang                                                                        *
 *   References: Apple iOS Developers                                                  *
 *                                                                                     *
 *   Version 1.0                                                                       *
 *   - Editing contacts                                                                *
 *   - add contacts                                                                    *
 *   - disables save button if text fields do not contain required information         *
 *   - keyboard hides when pressing return or background                               *
 *                                                                                     *
 ***************************************************************************************/

import UIKit

class ContactViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate {
    
    // MARK: Properties
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var number: UITextField!
    @IBOutlet weak var alertMessage: UITextField!
    @IBOutlet weak var saveContact: UIBarButtonItem!
    
    var contact: Contact?

    override func viewDidLoad() {
        
        super.viewDidLoad()

        name.delegate = self
        
        // set up views if editing an existing contact
        if let contact = contact {
            navigationItem.title = contact.name
            name.text = contact.name
            alertMessage.text = contact.alertMessage
            number.text = contact.number
        }
        
        // enable save button when valid contact name 
        checkValidContact()
    }

    
    // MARK: UITextFieldDelegate
    
    // disable save button while editing
    func textFieldDidBeginEditing(textField: UITextField) {
        
        saveContact.enabled = false
    }
    
    
    func textFieldDidEndEditing(textField: UITextField) {
    
        checkValidContact()
        navigationItem.title = textField.text
    }
    
    // disable save button if text field is empty
    func checkValidContact() {
        
        let nameText = name.text ?? ""
        let numberText = number.text ?? ""
        saveContact.enabled = !nameText.isEmpty && !numberText.isEmpty
    }
    
    // hides keyboard when return is pressed
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        name.resignFirstResponder()
        number.resignFirstResponder()
        alertMessage.resignFirstResponder()
        
        return true;
    }
    
    // hides keyboard when background is touched
    override func touchesBegan(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        name.resignFirstResponder()
        number.resignFirstResponder()
        alertMessage.resignFirstResponder()
        
        self.view.endEditing(true)
    }
    
    // MARK: Navigation
    @IBAction func cancel(sender: UIBarButtonItem) {
        
        let isPresentingInAddContactMode = presentingViewController is UINavigationController
        
        if isPresentingInAddContactMode {
            dismissViewControllerAnimated(true, completion: nil)
        } else {
            navigationController!.popViewControllerAnimated(true)
        }
    }

    // configures a view controller before it's presented
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if saveContact === sender {
            let contactName = name.text ?? ""
            let phoneNumber = number.text ?? ""
            let message = alertMessage.text ?? ""
            
            // set contact to ContactTableViewController after unwind segue
            contact = Contact(name: contactName, alertMessage: message, number: phoneNumber)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
