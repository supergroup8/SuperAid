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
    @IBOutlet weak var endDate: UITextField!
    @IBOutlet weak var dose: UITextField!
    @IBOutlet weak var medType: UITextField!
    @IBOutlet weak var sun: UIButton!
    @IBOutlet weak var mon: UIButton!
    @IBOutlet weak var tue: UIButton!
    @IBOutlet weak var wed: UIButton!
    @IBOutlet weak var thu: UIButton!
    @IBOutlet weak var fri: UIButton!
    @IBOutlet weak var sat: UIButton!
    
    @IBOutlet weak var saveMedication: UIBarButtonItem!
    
    var medication: Medication?
    var days: [String] = []
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let buttons = [sun, mon, tue, wed, thu, fri, sat]
        setProperties(buttons)
        
        name.delegate = self
        endDate.delegate = self
        dose.delegate = self
        medType.delegate = self
        
        // set up views if editing an existing medication
        if let medication = medication {
            navigationItem.title = medication.name
            name.text = medication.name
            days = medication.daysToTake
            endDate.text = medication.endDate
            dose.text = medication.dose
            medType.text = medication.medType
            
            contain(days)
        }
        
        for var index = 0; index < buttons.count; index++ {
            buttons[index].addTarget(self, action: "clicked:", forControlEvents: UIControlEvents.TouchUpInside)
        }
        
        // enable save button when valid medication name
        checkValidMedication()
    }
    
    
    // MARK: UIButton
    
    // POST: Modifies button to have a background
    func setProperties(button: [UIButton!]) {
        
        for var index = 0; index < button.count; index++ {
            
            button[index].backgroundColor = UIColor.clearColor()
            button[index].layer.borderWidth = 1
            button[index].layer.borderColor = UIColor.blackColor().CGColor
        }
    }
    
    // resets properties when unselecting day of week
    func resetProperties(button: UIButton) {
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.blackColor().CGColor
    }
    
    // checks if array contains string for day of week and calls clicked function if contains
    func contain(dayOfWeek: [String]) {
        
        if days.contains("Sun") {
            clicked(sun)
        }
        if days.contains("Mon") {
            clicked(mon)
        }
        if days.contains("Tue") {
            clicked(tue)
        }
        if days.contains("Wed") {
            clicked(wed)
        }
        if days.contains("Thu") {
            clicked(thu)
        }
        if days.contains("Fri") {
            clicked(fri)
        }
        if days.contains("Sat") {
            clicked(sat)
        }
        
    }
    
    // changes button state when a UIButton is pressed
    func clicked(sender:UIButton) {
        
        if sender.selected == false {
            sender.layer.borderWidth = 2
            sender.layer.borderColor = UIColor.blueColor().CGColor
        } else if sender.selected == true {
            resetProperties(sender)
        }
        sender.selected = !sender.selected
    }
    
    
    // MARK: UITextFieldDelegate
    
    // disable save button while editing
    func textFieldDidBeginEditing(textField: UITextField) {
        
        saveMedication.enabled = false
    }
    
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        checkValidMedication()
        // navigationItem.title = textField.text
    }
    
    // disable save button if text field is empty or no days selected
    func checkValidMedication() {
        
        let nameText = name.text ?? ""
        let endText = endDate.text ?? ""
        let doseText = dose.text ?? ""
        let typeText = medType.text ?? ""
        var days: Bool = false
        
        // checks if buttons are selected
        if sun.selected == true {
            days = true
        } else if mon.selected == true {
            days = true
        } else if tue.selected == true {
            days = true
        } else if wed.selected == true {
            days = true
        } else if thu.selected == true {
            days = true
        } else if fri.selected == true {
            days = true
        } else if sat.selected == true {
            days = true
        } else {
            days = false
        }
        
        saveMedication.enabled = !nameText.isEmpty && !endText.isEmpty && !doseText.isEmpty && !typeText.isEmpty && days
    }
    
    // hides keyboard when return is pressed
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()

        return true
    }
    
    // hides keyboard when background is touched
    override func touchesBegan(touches: Set<UITouch>?, withEvent event: UIEvent?) {

        self.view.endEditing(true)
    }
    
    // MARK: Navigation

    // returns to medtracker menu
    @IBAction func cancel(sender: UIBarButtonItem) {
        
        let isPresentingInAddMedMode = presentingViewController is UINavigationController
        
        if isPresentingInAddMedMode {
            
            self.dismissViewControllerAnimated(true, completion: nil)
        } else {
            
            navigationController!.popViewControllerAnimated(true)
        }
    }
    
    // configures a view controller before it's presented
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if saveMedication === sender {
            let medName = name.text ?? ""
            let end = endDate.text ?? ""
            let dosage = dose.text ?? ""
            let type = medType.text ?? ""
            
            // appends title of day to days array
            if sun.selected == true {
               days.append(sun.currentTitle!)
            }
            if mon.selected == true {
                days.append(mon.currentTitle!)
            }
            if tue.selected == true {
                days.append(tue.currentTitle!)
            }
            if wed.selected == true {
                days.append(wed.currentTitle!)
            }
            if thu.selected == true {
                days.append(thu.currentTitle!)
            }
            if fri.selected == true {
                days.append(fri.currentTitle!)
            }
            if sat.selected == true {
                days.append(sat.currentTitle!)
            }
            
            let day = days ?? [""]
            
            // set medication to MedicationTableViewController after unwind segue
            medication = Medication(name: medName, days: day, end: end, dose: dosage, type: type)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
