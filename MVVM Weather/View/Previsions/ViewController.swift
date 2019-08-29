//
//  ViewController.swift
//  MVVM Weather
//
//  Created by Faissal Nabil on 27/08/2019.
//  Copyright © 2019 Macbook. All rights reserved.
//

import UIKit
import CoreLocation



class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var viewModel = PrevisionsViewModel()
    
    let locationManager = CLLocationManager()

    var detailvc : DetailsPrevisionViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "PrevisionTableViewCell", bundle: nil), forCellReuseIdentifier: "PrevisionTableViewCell")

        viewModel.delegate = self
        
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        self.detailvc =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailsPrevisionViewController") as? DetailsPrevisionViewController

}
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        self.viewModel.getPrevisions(longitude: locValue.longitude, latitude: locValue.latitude)
        self.getAddressFromLatLon(pdblLatitude: locValue.latitude, withLongitude: locValue.longitude)

    }
    
    func reloadTable() {
         self.tableView.reloadData()
    }
    
    func getAddressFromLatLon(pdblLatitude: Double, withLongitude pdblLongitude: Double) -> String {
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let ceo: CLGeocoder = CLGeocoder()
        var shortAdress : String = ""
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
                    
                    shortAdress = addressString
                }
        })
        return shortAdress
    }
    
}
extension ViewController: UITableViewDataSource, UITableViewDelegate, ViewModelDelegate{
    
    func showActivityLoader() {
        self.activityIndicator.startAnimating()
    }
    
    func hideActivityLoader() {
        self.activityIndicator.stopAnimating()
        self.activityIndicator.hidesWhenStopped = true
    }
    
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing : PrevisionTableViewCell.self)) as! PrevisionTableViewCell
        if viewModel.dataItems.count > 0 {
            let dataItems = viewModel.dataItems[indexPath.row]
            cell.configureWithPrevision(prevision: dataItems)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  self.viewModel.numberOfEntries
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
        self.detailvc?.configureWithPrevision(prevision: viewModel.dataItems[indexPath.row])
        self.navigationController?.pushViewController(self.detailvc!, animated: true)
    }
}


