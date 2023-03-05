//
//  ReportTableViewCell.swift
//  MUPD-SOS
//
//  Created by Kinneret Kanik on 05/03/2023.
//

import UIKit

class ReportTableViewCell: UITableViewCell {

    @IBOutlet weak var sourceImage: UIImageView!
    
    @IBOutlet weak var emergencyType: UILabel!
    
    @IBOutlet weak var postedByLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
