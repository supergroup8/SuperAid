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
*   - Interacts with table vewi controller
*   - Contains outlets to the labels and image so that they can be updated
*
*   Bugs
*    -Constraint issues with screen size
************************************************************/

import UIKit

class LocationTableViewCell: UITableViewCell {
    //MARK: Properties
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var provinceLabel: UILabel!
    @IBOutlet weak var zipLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
