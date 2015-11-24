/***************************************************************************************
 *                                                                                     *
 *   MedicationViewController.swift                                                    *
 *   Super Aid - Group 8                                                               *
 *                                                                                     *
 *   Authors:                                                                          *
 *   John Xiang                                                                        *
 *   References: Apple iOS Developers                                                  *
 *                                                                                     *
 *   Version 1.0                                                                       *
 *   - Editing medication                                                              *
 *   - add medication                                                                  *
 *   - disables save button if text fields do not contain required information         *
 *   - keyboard hides when pressing return or background                               *
 *                                                                                     *
 ***************************************************************************************/

import UIKit

class MedicationViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate {
    
    // MARK: Properties
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var startDate: UITextField!
    @IBOutlet weak var endDate: UITextField!
    @IBOutlet weak var dose: UITextField!
    @IBOutlet weak var medType: UITextField!
    @IBOutlet weak var saveMedication: UIBarButtonItem!
    
    var medication: Medication?
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        name.delegate = self
        
        // set up views if editing an existing medication
        if let medication = medication {
            navigationItem.title = medication.name
            name.text = medication.name
            startDate.text = medication.startDate
            endDate.text = medication.endDate
            dose.text = medication.dose
            medType.text = medication.medType
        }
        
        // enable save button when valid medication name
        checkValidMedication()
    }
    
    
    // MARK: UITextFieldDelegate
    
    // disable save button while editing
    func textFieldDidBeginEditing(textField: UITextField) {
        
        saveMedication.enabled = false
    }
    
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        checkValidMedication()
        navigationItem.title = textField.text
    }
    
    // disable save button if text field is empty
    func checkValidMedication() {
        
        let nameText = name.text ?? ""
        let startText = startDate.text ?? ""
        let endText = endDate.text ?? ""
        let doseText = dose.text ?? ""
        let typeText = medType.text ?? ""
        
        saveMedication.enabled = !nameText.isEmpty && !startText.isEmpty && !endText.isEmpty && !doseText.isEmpty && !typeText.isEmpty
    }
    
    // hides keyboard when return is pressed
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        name.resignFirstResponder()
        startDate.resignFirstResponder()
        endDate.resignFirstResponder()
        dose.resignFirstResponder()
        medType.resignFirstResponder()
        
        return true;
    }
    
    // hides keyboard when background is touched
    override func touchesBegan(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        name.resignFirstResponder()
        startDate.resignFirstResponder()
        endDate.resignFirstResponder()
        dose.resignFirstResponder()
        medType.resignFirstResponder()
        
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
        
        if saveMedication === sender {
            let medName = name.text ?? ""
            let start = startDate.text ?? ""
            let end = endDate.text ?? ""
            let dosage = dose.text ?? ""
            let type = medType.text ?? ""
            
            
            // set medication to MedicationTableViewController after unwind segue
            medication = Medication(name: medName, start: start, end: end, dose: dosage, type: type)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
