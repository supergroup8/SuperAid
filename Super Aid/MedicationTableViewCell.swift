/********************************************************************
 *                                                                  *
 *   ContactTableViewCell.swift                                     *
 *   Super Aid - Group 8                                            *
 *                                                                  *
 *   Authors:                                                       *
 *   John Xiang                                                     *
 *                                                                  *
 *   Version 1.0                                                    *
 *   - cell of the tableview for list of medicaiton                 *
 *                                                                  *
 ********************************************************************/
import UIKit

class MedicationTableViewCell: UITableViewCell {

    @IBOutlet weak var medName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
