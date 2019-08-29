//
//  PrevisionTableViewCell.swift
//  MVVM Weather
//
//  Created by Faissal Nabil on 27/08/2019.
//  Copyright © 2019 Macbook. All rights reserved.
//

import UIKit

class PrevisionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var timePrevisionLabel: UILabel!
    
    @IBOutlet weak var temperatureLabel: UILabel!
    var cellPrevision : Prevision?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureWithPrevision(prevision:Prevision)
    {
        self.cellPrevision = prevision
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        if let date = cellPrevision?.datePrevision {
            timePrevisionLabel.text = date
        }
        
        if let temp = cellPrevision?.temperature {
            let tempKelvin = temp as! Double
            temperatureLabel.text  = String(format: "%.0f°", tempKelvin - 273.15)
        }
        
    }
    
    
}
