//
//  PrevisionsRepository.swift
//  MVVM Weather
//
//  Created by Faissal Nabil on 28/08/2019.
//  Copyright © 2019 Macbook. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper


class PrevisionsRepository {
    
    func getPrevision(dateFormated: String, longitude: Double, latitude:Double, success: @escaping ([Prevision]) -> Void , failure: @escaping (String) -> Void) {
        
        let parameters: Parameters = ["_ll": String(format : "%f,%f", latitude, longitude), "_auth" : AppConstants.auth,
                                      "_c":AppConstants.key]
        
        var result : [Prevision] = []
        Alamofire.request(AppConstants.urlPrevision, parameters: parameters).responseJSON { response in
            debugPrint(response)
            
            switch response.result {
            case .success(let data):
                if let json = response.result.value as? Dictionary<String,AnyObject> {
                    print("JSON: \(json)")
                    
                    let sortedDict = json.sorted(by: { $0.key < $1.key })
                    
                    for (key, val) in sortedDict {
                        
                        if let prevObject = Mapper<Prevision>().map(JSONObject: val){
                            
                            prevObject.datePrevision = key
                            result.append(prevObject)
                        }
                        
                    }
                    success(result)
                }
            case .failure(let error):
                
                failure(error.localizedDescription)
            }
        }
    }
    
}
