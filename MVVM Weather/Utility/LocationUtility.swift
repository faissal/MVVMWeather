//
//  LocationUtility.swift
//  MVVM Weather
//
//  Created by Faissal Nabil on 29/08/2019.
//  Copyright © 2019 Macbook. All rights reserved.
//

import Foundation
import CoreLocation

class LocationUtility {
    
    func getAddressFromLatLon(pdblLatitude: Double, withLongitude pdblLongitude: Double, completionHandler: @escaping (String) -> Void ){
        
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = pdblLatitude
        center.longitude = pdblLongitude
        
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        
        ceo.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
                if (error != nil)
                {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                let pm = placemarks! as [CLPlacemark]
                if pm.count > 0 {
                    let pm = placemarks![0]
                    
                    var addressString : String = ""
                    
                    if pm.locality != nil {
                        addressString = addressString + pm.locality! + ", "
                    }
                    if pm.country != nil {
                        addressString = addressString + pm.country! + ", "
                    }
                    if pm.postalCode != nil {
                        addressString = addressString + pm.postalCode! + " "
                    }
                    completionHandler(addressString)
                }
        })
        
    }
}
