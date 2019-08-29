//
//  DetailsPrevisionViewController.swift
//  MVVM Weather
//
//  Created by Faissal Nabil on 28/08/2019.
//  Copyright © 2019 Macbook. All rights reserved.
//

import UIKit

class DetailsPrevisionViewController: UIViewController {
    
    @IBOutlet weak var temperatureValueLabel: UILabel!
    
    @IBOutlet weak var rainRiskLabel: UILabel!
    
    @IBOutlet weak var snowRiskLabel: UILabel!
    
    @IBOutlet weak var pressionValueLabel: UILabel!
    
    @IBOutlet weak var humidityValueLabel: UILabel!
    
    var prevision : Prevision?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func configureWithPrevision(prevision:Prevision)
    {
        self.prevision = prevision
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        self.temperatureValueLabel.text = self.prevision?.temperature?.stringValue
        self.rainRiskLabel.text = self.prevision?.rainRisk?.stringValue
        self.snowRiskLabel.text = self.prevision?.snowRisk?.description
        self.humidityValueLabel.text = self.prevision?.humidity?.stringValue
        self.pressionValueLabel.text = self.prevision?.pression?.stringValue
    }
}
