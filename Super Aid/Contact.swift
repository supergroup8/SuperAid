/******************************************************************************************************************
 *                                                                                                                *
 *   Contacts.swift                                                                                               *
 *   Super Aid - Group 8                                                                                          *
 *                                                                                                                *
 *   Authors:                                                                                                     *
 *   John Xiang                                                                                                   *
 *   References: Apple iOS Developers                                                                             *
 *                                                                                                                *
 *   Version 1.0                                                                                                  *
 *   - Contacts class for emergency contacts                                                                      *
 *   - allows initialization of a contact with name, alert message, and phone number                              *
 *   - contains functions to retrieve name, alert message, and phone number                                       *
 *   - data persistance through NSCoding                                                                          *
 *                                                                                                                *
 ******************************************************************************************************************/

import UIKit

class Contact: NSObject, NSCoding {

    // MARK: Properties
    var name: String = ""
    var alertMessage: String = ""
    var number: String = ""
    
    
    // MARK: Archiving paths
     static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
     static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("contacts")
    
    // MARK: Types
    struct PropertyKey {
        
        // declare key strings for pesistance store
        static let nameKey = "name"
        static let messageKey = "message"
        static let numberKey = "number"
    }
    
    // MARK: Initialization
    
    init?(name: String, alertMessage: String, number: String) {
        self.name = name
        self.alertMessage = alertMessage
        self.number = number
        
        super.init()
        
        // failed initilization cases
        if name.isEmpty || number.isEmpty {
        
            return nil
        }
    }
    
    // MARK: NSCoding
    func encodeWithCoder(aCoder: NSCoder) {
        
        //encode values
        aCoder.encodeObject(name, forKey: PropertyKey.nameKey)
        aCoder.encodeObject(alertMessage, forKey: PropertyKey.messageKey)
        aCoder.encodeObject(number, forKey: PropertyKey.numberKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        //decode/ unarchives the info for an object, force type cast
        let name = aDecoder.decodeObjectForKey(PropertyKey.nameKey) as! String
        let message = aDecoder.decodeObjectForKey(PropertyKey.messageKey) as! String
        let number = aDecoder.decodeObjectForKey(PropertyKey.numberKey) as! String

        
        // Must call designated initilizer.
        self.init(name: name, alertMessage: message, number: number)
    }

}