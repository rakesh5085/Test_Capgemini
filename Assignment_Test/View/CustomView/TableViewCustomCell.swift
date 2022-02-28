//
//  TableViewCustomCell.swift
//

import UIKit

class TableViewCustomCell: UITableViewCell {

    @IBOutlet weak var lblSubName: UILabel!
    @IBOutlet weak var lblTItleName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
