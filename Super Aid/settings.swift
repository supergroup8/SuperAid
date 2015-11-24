/************************************************************
 *                                                          *
 *   settings.swift                                         *
 *   Super Aid - Group 8                                    *
 *                                                          *
 *   Authors:                                               *
 *   John Xiang                                             *
 *                                                          *
 *   Version 1.0                                            *
 *   - text fields contain pre-set values                   *
 *   - text fields open correct keyboards                   *
 *   - keyboard hides after return/ background tap          *
 *                                                          *
 *   Bugs                                                   *
 *   - entered text does not save                           *
 *                                                          *
 ************************************************************/

import UIKit

class settings: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var first_n: UITextField!
    @IBOutlet weak var noResponse_n: UITextField!
    @IBOutlet weak var final_n: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeFields()
    }

    // set text field's delegates and keyboard type
    func initializeFields() {
        first_n.delegate = self
        noResponse_n.delegate = self
        final_n.delegate = self
        
        first_n.keyboardType = UIKeyboardType.NumberPad
        noResponse_n.keyboardType = UIKeyboardType.NumberPad
        final_n.keyboardType = UIKeyboardType.NumberPad
    }
    
    // hides keyboard when return is pressed
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        first_n.resignFirstResponder()
        noResponse_n.resignFirstResponder()
        final_n.resignFirstResponder()
        
        return true;
    }
    
    // hides keyboard when background is touched
    override func touchesBegan(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        first_n.resignFirstResponder()
        noResponse_n.resignFirstResponder()
        final_n.resignFirstResponder()
        
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
