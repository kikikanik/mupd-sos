//
//  CustomIncidentsTableViewCell.swift
//  MUPD-SOS
//
//  Created by Kinneret Kanik on 03/04/2023.
//

import UIKit

class CustomIncidentsTableViewCell: UITableViewCell {

    
    @IBOutlet weak var sourceImage: UIImageView!
    
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var reporter: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
