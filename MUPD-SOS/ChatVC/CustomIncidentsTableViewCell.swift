//
//  CustomIncidentsTableViewCell.swift
//  MUPD-SOS
//

import UIKit

class CustomIncidentsTableViewCell: UITableViewCell {

    
    @IBOutlet weak var sourceImage: UIImageView!
    
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var reporter: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
