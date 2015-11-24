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
*   - Created a table view to display saved locations
*   - Data persistance after app restart/shutdown using NSCoding
*   - Supports deleting and rearranging through Edit mode
*   - Updates cells with inputted data
*   - Unwind segue that connects to LocationViewController's save button to add row to table
*   - Two segues to LocationViewController depending if user pressed cell or add button
*   - Edit and add button
*
*   Bugs
*    -Constraint issues with screen size
*    -Entries sometimes get distorted
************************************************************/
import UIKit

class LocationTableViewController: UITableViewController {
    
    //MARK: Properties
    var locations = [Location]() //initializes with empty array of Location objects
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Load any saved locations, otherwise load sample data.
        if let savedLocations = loadLocations() {
            locations += savedLocations

        }
        else {
            loadSampleLocations()
        }

    }
    
    //load sample data into app
    func loadSampleLocations(){
        
        let photo1 = UIImage(named: "arena")!
        let location1 = Location(name: "Oracle Arena", address: "7000 Coliseum Way", city: "Oakland", province: "California", zip: "94621", photo: photo1)!
        
        let photo2 = UIImage(named: "bridge")!
        let location2 = Location(name: "Golden Gate Bridge", address: "Golden Gate Bridge", city: "San Francisco", province: "California", zip: "94133", photo: photo2)!
        
        let photo3 = UIImage(named: "berkeley")!
        let location3 = Location(name: "UC Berkeley", address: "University Dr", city: "Berkeley", province: "California", zip: "94720", photo: photo3)!
        
        locations += [location1, location2, location3] //add to array
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1 //show 1 section
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return locations.count //return number of rows equal to entries
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "LocationTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! LocationTableViewCell
        
        //fetches appropriate location for data source layout
        let location = locations[indexPath.row]
        
        //updates the cell's parameters
        cell.nameLabel.text = location.name
        cell.addressLabel.text = location.address
        cell.cityLabel.text = location.city
        cell.provinceLabel.text = location.province
        cell.zipLabel.text = location.zip
        cell.photoImageView.image = location.photo
        
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
            locations.removeAtIndex(indexPath.row)
            saveLocations() //save whenver deleted is performed
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
    
    //configure view controller depending on which segue is used
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        //cell is pressed (for editting or viewing)
        if segue.identifier == "ShowDetail" {
            
            //force downcast destination view controller
            let locationDetailViewController = segue.destinationViewController as! LocationViewController
            
            // Get the cell that generated this segue.
            if let selectedLocationCell = sender as? LocationTableViewCell {
                //fetch location object corrseponsing to selected cell
                let indexPath = tableView.indexPathForCell(selectedLocationCell)!
                let selectedLocation = locations[indexPath.row]
                locationDetailViewController.location = selectedLocation
            }
        }
            
        //add button is pressed
        else if segue.identifier == "AddItem" {
            print("Adding new location.")

            
        }
    }

    //interacts with LocationViewController's save button
    @IBAction func unwindToLocationList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.sourceViewController as? LocationViewController, location = sourceViewController.location {
            
            //checks  whether row was selected
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                
                // Update an existing location with edits
                locations[selectedIndexPath.row] = location
                tableView.reloadRowsAtIndexPaths([selectedIndexPath], withRowAnimation: .None)
            }
            
            else {
                // Add a new location to table view
                let newIndexPath = NSIndexPath(forRow: locations.count, inSection: 0) //compute location for new cell
                locations.append(location) //add location
                tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom) //add the row
            }
            
            saveLocations() //save whenever edit or add is performed
            
        }
    }
    
    //MARK: Actions
    
    @IBAction func editPressed(sender: UIBarButtonItem) {
        
        //enable editting mode for table view
        setEditing(!editing, animated: true)
    }
    
    @IBAction func backPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    //MARK: NSCoding
    func saveLocations() {
        
        //Archive location, Location.ArchiveURL.path is where to save
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(locations, toFile: Location.ArchiveURL.path!)
        
        if !isSuccessfulSave {
            print("Failed to save locations...")
        }
    }
    
    func loadLocations() -> [Location]?{
        
        //unarchive object stored at ArchiveUrl
        return NSKeyedUnarchiver.unarchiveObjectWithFile(Location.ArchiveURL.path!) as? [Location]

    }
}
