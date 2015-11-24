/************************************************************
*
*   LocationViewController.swift
*   Super Aid - Group 8
*
*   Authors:
*   Victor Yun
*   References: Apple iOS Developers
*
*   Version 1.0
*   - created back button on navigation bar
*   - Connects text fields; converts input into coordinates using forward geocoding
*   - Generates directions between a user inputted location and current location
*   - Connects with iPhone's Map app
*   
*   Version 2.0
*   - Updated code to be iOS 9.0+ compatable ****ONLY COMPATIBLE FOR IOS 9.0+ BECAUSE OF STACKVIEW****
*   - Revamped interface, added stack view
*   - Allow user to choose a picture from photo library
*   - Allows user to save and edit entries
*   - Unwind segue that connects to LocationTableViewController
*   - Safety checks for editting that will disable save and TakeMeThere button if necessary
*
*   Bugs
*   -SOMETIMES HAS TO RESTART BEFORE DETERMINING LOCATION WORKS; request to Apple servers do not complete for some reason, at times*
*   -Constraint issues with screen size
************************************************************/
import UIKit
import CoreLocation
import MapKit
import Contacts


class LocationViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {

    //MARK: Properties
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var addressText: UITextField!
    @IBOutlet weak var cityText: UITextField!
    @IBOutlet weak var provinceText: UITextField!
    @IBOutlet weak var zipText: UITextField!
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var takemethereButton: UIButton!
    
    var location: Location?
    var coords: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //delegate callbacks
        nameText.delegate = self
        addressText.delegate = self
        cityText.delegate = self
        provinceText.delegate = self
        zipText.delegate = self
        
        // Set up views if editing an existing Location.
        if let location = location {
            navigationItem.title = location.name
            nameText.text   = location.name
            addressText.text   = location.address
            cityText.text   = location.city
            provinceText.text   = location.province
            zipText.text   = location.zip
            photoImageView.image = location.photo
        }
        
        //enable save button only if text field is valid
        checkValidLocationName()
    }
    
    //MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()    //Hide the keyboard upon pressing return

        return true
        
    }
    
    // hides keyboard when background is touched
    override func touchesBegan(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        checkValidLocationName() //checks for valid input after editting

        navigationItem.title = textField.text //set navigation bar title
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        // Disable the Save and TakeMeThere button while editing.
        saveButton.enabled = false
        takemethereButton.enabled = false
    }
    
    //checks for valid input (not blank)
    func checkValidLocationName() {
        
        // Disable the Save and TakeMeThere button if the text field is empty.
        let nametext = nameText.text ?? ""
        let addresstext = addressText.text ?? ""
        let citytext = cityText.text ?? ""
        let provincetext = provinceText.text ?? ""
        let ziptext = zipText.text ?? ""
        
        saveButton.enabled = !nametext.isEmpty && !addresstext.isEmpty && !citytext.isEmpty && !provincetext.isEmpty && !ziptext.isEmpty
        
        takemethereButton.enabled = !nametext.isEmpty && !addresstext.isEmpty && !citytext.isEmpty && !provincetext.isEmpty && !ziptext.isEmpty

    }
    
    //MARK: UIImagePickerControllerDelegate
    
    //called when cancel button is pressed
    func imagePickerControllerDidCancel(picker: UIImagePickerController){
        
        dismissViewControllerAnimated(true, completion: nil) // Dismiss the picker if the user canceled.

    }
    
    //called when photo is selected
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
        
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage //use original version of image
        photoImageView.image = selectedImage //display the selected image.
        // Dismiss the picker.
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: Navigation
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        let isPresentingInAddLocationMode = presentingViewController is UINavigationController
        
        if isPresentingInAddLocationMode {
            dismissViewControllerAnimated(true, completion: nil)
        }
        
        else {
            navigationController!.popViewControllerAnimated(true)
        }
    }
   
    // configure a view controller before it's presented.
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if saveButton === sender {
            //create constants for text field and image
            let name = nameText.text ?? ""
            let address = addressText.text ?? ""
            let city = cityText.text ?? ""
            let province = provinceText.text ?? ""
            let zip = zipText.text ?? ""
            let photo = photoImageView.image
            
            // Set the location to be passed to LocationViewController after the unwind segue.
            location = Location(name: name, address: address, city: city, province: province, zip: zip, photo: photo)
        
        }
    }
    
    //MARK: Actions
    //tapping gesture on image view
    @IBAction func selectImageFromPhotoLibrary(sender: UITapGestureRecognizer) {
        
        // Hide the keyboard if typing in any textfield
        nameText.resignFirstResponder()
        addressText.resignFirstResponder()
        cityText.resignFirstResponder()
        provinceText.resignFirstResponder()
        zipText.resignFirstResponder()
        
        //view contoller that lets user choose photo  from library
        let imagePickerController = UIImagePickerController()
        
        //sets image picker's source to camera roll only
        imagePickerController.sourceType = .PhotoLibrary
        
        imagePickerController.delegate = self
        
        presentViewController(imagePickerController, animated: true, completion: nil)
    }
    
    //Instantiates a geoCoder class in order to submit a forward geocoding request to convert address string
    //into a coordinate
    @IBAction func TakeMeThere(sender: AnyObject) {
        
        let geoCoder = CLGeocoder()
        let addressString = "\(addressText.text) \(cityText.text) \(provinceText.text) \(zipText.text)"
        
        geoCoder.geocodeAddressString(addressString, completionHandler: {(placemarks: [CLPlacemark]?, error: NSError?) -> Void in
            
            if error != nil{
                print("Geocode failed with error: \(error!.localizedDescription)")
            } else if placemarks!.count > 0{
                let placemark = placemarks![0]
                let location = placemark.location
                self.coords = location!.coordinate
                
                self.showMap()
                
            }
        })

    }
   
    //Sets the appropriate locations and sets options to generating directions for walking
    //then launches the Map app.
    func showMap() {
        
        //let addressDict = [String(kABPersonAddressStreetKey): addressText.text!] *** deprecated in iOS 9 ***
        
        let addressDict = [String(CNPostalAddressStreetKey): addressText.text!]
        let place = MKPlacemark(coordinate: coords!,
            addressDictionary: addressDict)
        
        let mapItem = MKMapItem(placemark: place)
        
        let options = [MKLaunchOptionsDirectionsModeKey:
            MKLaunchOptionsDirectionsModeWalking]
        
        mapItem.openInMapsWithLaunchOptions(options)
    }

    



}

