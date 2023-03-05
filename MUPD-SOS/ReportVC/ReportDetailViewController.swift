//
//  ReportDetailViewController.swift
//  MUPD-SOS
//
//  Created by Kinneret Kanik on 05/03/2023.
//

import UIKit

class ReportDetailViewController: UIViewController {
    
   // @IBOutlet weak var name: UILabel!
  //  @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var emergencyTitle: UILabel!
    
    @IBOutlet weak var postedBy: UILabel!
    
    @IBOutlet weak var timestamp: UILabel!
    
    @IBOutlet weak var message: UITextView!
    
    var selectedReport : Report!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        emergencyTitle.text = selectedReport.emergencyType
        postedBy.text = selectedReport.postedBy
        timestamp.text = selectedReport.timestamp
        message.text = selectedReport.message
        
        //name.text = selectedReport.id + " - " + selectedShape.name
        //image.image = UIImage(named: selectedShape.imageName)
    }
    
}
