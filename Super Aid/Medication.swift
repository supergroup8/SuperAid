/******************************************************************************************************************
 *                                                                                                                *
 *   Medication.swift                                                                                             *
 *   Super Aid - Group 8                                                                                          *
 *                                                                                                                *
 *   Authors:                                                                                                     *
 *   John Xiang                                                                                                   *
 *   References: Apple iOS Developers                                                                             *
 *                                                                                                                *
 *   Version 1.0                                                                                                  *
 *   - Medication class for emergency contacts                                                                    *
 *   - allows initialization of a medication with name, start date, end date, dosage and med type                 *
 *   - data persistance through NSCoding                                                                          *
 *                                                                                                                *
 ******************************************************************************************************************/

import UIKit

class Medication: NSObject, NSCoding {
    
    // MARK: Properties
    var name: String = ""
    var daysToTake:[String] = []
    var endDate: String = ""
    var dose: String = ""
    var medType: String = ""
    
    
    // MARK: Archiving paths
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("medication")
    
    // MARK: Types
    struct PropertyKey {
        
        // declare key strings for pesistance store
        static let nameKey = "name"
        static let daysKey = "days"
        static let endKey = "end"
        static let doseKey = "dose"
        static let typeKey = "type"
    }
    
    // MARK: Initialization
    
    init?(name: String, days: [String], end: String, dose: String, type: String) {
        self.name = name
        self.daysToTake = days
        self.endDate = end
        self.dose = dose
        self.medType = type
        
        super.init()
        
        // failed initilization cases
        if name.isEmpty || daysToTake.isEmpty || endDate.isEmpty || dose.isEmpty || medType.isEmpty {
            
            return nil
        }
    }
    
    // MARK: NSCoding
    func encodeWithCoder(aCoder: NSCoder) {
        
        //encode values
        aCoder.encodeObject(name, forKey: PropertyKey.nameKey)
        aCoder.encodeObject(daysToTake, forKey: PropertyKey.daysKey)
        aCoder.encodeObject(endDate, forKey: PropertyKey.endKey)
        aCoder.encodeObject(dose, forKey: PropertyKey.doseKey)
        aCoder.encodeObject(medType, forKey: PropertyKey.typeKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        //decode/ unarchives the info for an object, force type cast
        let name = aDecoder.decodeObjectForKey(PropertyKey.nameKey) as! String
        let days = aDecoder.decodeObjectForKey(PropertyKey.daysKey) as! [String]
        let end = aDecoder.decodeObjectForKey(PropertyKey.endKey) as! String
        let dose = aDecoder.decodeObjectForKey(PropertyKey.doseKey) as! String
        let type = aDecoder.decodeObjectForKey(PropertyKey.typeKey) as! String
        
        
        // Must call designated initilizer.
        self.init(name: name, days: days, end: end, dose: dose, type: type)
    }
    
}