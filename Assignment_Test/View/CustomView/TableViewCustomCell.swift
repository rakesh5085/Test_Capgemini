//  TableViewCustomCell.swift
//
//  Custom UITableViewCell class for displaying a title and subtitle in a table view.

import UIKit

class TableViewCustomCell: UITableViewCell {
    
    // IBOutlet properties for connecting the cell's UI elements to the custom class
    @IBOutlet weak var lblSubName: UILabel! // UILabel for displaying the subtitle
    @IBOutlet weak var lblTItleName: UILabel! // UILabel for displaying the title
    
    // awakeFromNib method is called when the cell is initialized from its nib file
    override func awakeFromNib() {
        super.awakeFromNib()
        // This is a good place to perform any additional setup required for the cell
    }
    
    // setSelected method is called when the user selects or deselects the cell
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
