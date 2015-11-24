/************************************************************
 *                                                          *
 *   alertMessages.swift                                    *
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

class alertMessages: UIViewController, UITextFieldDelegate {
    
    // Text fields
    @IBOutlet weak var default_: UITextField!
    @IBOutlet weak var msg1_: UITextField!
    @IBOutlet weak var y_msg: UITextField!
    @IBOutlet weak var n_msg: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeFields()
    }
    
    // set text field's delegates and sey keyboard types
    func initializeFields() {
        default_.delegate = self
        msg1_.delegate = self
        y_msg.delegate = self
        n_msg.delegate = self
        
        default_.keyboardType = UIKeyboardType.ASCIICapable
        msg1_.keyboardType = UIKeyboardType.ASCIICapable
        y_msg.keyboardType = UIKeyboardType.ASCIICapable
        n_msg.keyboardType = UIKeyboardType.ASCIICapable
    }

    // hides keyboard when return is pressed
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        default_.resignFirstResponder()
        msg1_.resignFirstResponder()
        y_msg.resignFirstResponder()
        n_msg.resignFirstResponder()
        return true;
    }
    
    // hides keyboard when background is touched
    override func touchesBegan(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        default_.resignFirstResponder()
        msg1_.resignFirstResponder()
        y_msg.resignFirstResponder()
        n_msg.resignFirstResponder()
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
