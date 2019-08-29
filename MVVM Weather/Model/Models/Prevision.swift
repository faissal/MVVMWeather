//
//  Prevision.swift
//  MVVM Weather
//
//  Created by Faissal Nabil on 27/08/2019.
//  Copyright © 2019 Macbook. All rights reserved.
//

import Foundation
import ObjectMapper

class Prevision: Mappable {

    var snowRisk : String?
    var temperature : NSNumber?
    var pression : NSNumber?
    var rainRisk : NSNumber?
    var humidity : NSNumber?
    var datePrevision : String?
    
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        
        snowRisk <- map["risque_neige"]
        temperature <- map["temperature.sol"]
        pression <- map["pression.niveau_de_la_mer"]
        rainRisk <- map["pluie"]
        humidity <- map["humidite.2m"]
        
    }
    
    
}

