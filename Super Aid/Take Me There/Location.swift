/************************************************************
*
*   LocationTableViewViewController.swift
*   Super Aid - Group 8
*
*   Authors:
*   Victor Yun
*   References: Apple iOS Developers
*
*   Version 1.0
*   - Did not exist
*
*   Version 2.0
*   - Location class that contains relevant parameters
*   - Initializes parameters
*   - Uses NSCoding for data persistance
*
************************************************************/
import UIKit

class Location: NSObject, NSCoding{
    
    //MARK: PRoperties
    var name: String = ""
    var address: String = ""
    var city: String = ""
    var province: String = ""
    var zip: String = ""
    var photo: UIImage?
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("locations")
    
    //MARK: Types
    struct PropertyKey{
    
        //declare key strings for persistance store
        static let nameKey = "name"
        static let addressKey = "address"
        static let cityKey = "city"
        static let provinceKey = "province"
        static let zipKey = "zip"
        static let photoKey = "photo"

        
    }
    
    //MARK: Initialization
    
    init?(name: String, address: String, city: String, province: String, zip: String, photo: UIImage? )
    {
        //initialize properties
        self.name = name
        self.address = address
        self.city = city
        self.province = province
        self.zip = zip
        self.photo = photo
        
        super.init()
        
        //failed initialization cases
        if name.isEmpty || address.isEmpty || city.isEmpty || province.isEmpty || zip.isEmpty {
            return nil
        }
    }
    
    //MARK: NSCoding
    func encodeWithCoder(aCoder: NSCoder) {
        
        //encode values
        aCoder.encodeObject(name, forKey: PropertyKey.nameKey)
        aCoder.encodeObject(address, forKey: PropertyKey.addressKey)
        aCoder.encodeObject(city, forKey: PropertyKey.cityKey)
        aCoder.encodeObject(province, forKey: PropertyKey.provinceKey)
        aCoder.encodeObject(zip, forKey: PropertyKey.zipKey)
        aCoder.encodeObject(photo, forKey: PropertyKey.photoKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        //decode/ unarchives the info for an object, force type cast
        let name = aDecoder.decodeObjectForKey(PropertyKey.nameKey) as! String
        let address = aDecoder.decodeObjectForKey(PropertyKey.addressKey) as! String
        let city = aDecoder.decodeObjectForKey(PropertyKey.cityKey) as! String
        let province = aDecoder.decodeObjectForKey(PropertyKey.provinceKey) as! String
        let zip = aDecoder.decodeObjectForKey(PropertyKey.zipKey) as! String
        
        //conditional type cast
        let photo = aDecoder.decodeObjectForKey(PropertyKey.photoKey) as? UIImage

        // Must call designated initilizer.
        self.init(name: name, address: address, city: city, province: province, zip: zip, photo: photo)
    }
    
}
