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
    
    @IBOutlet weak var localisationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    var adress : String?
    
    var viewModel = PrevisionsViewModel()
    
    let locationManager = CLLocationManager()
    
    var detailvc : DetailsPrevisionViewController?
    
    fileprivate func initCurretDate() {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateFormated = formatter.string(from: date)
        dateLabel.text = dateFormated
    }
    
    fileprivate func initTableView() {
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "PrevisionTableViewCell", bundle: nil), forCellReuseIdentifier: "PrevisionTableViewCell")
        self.detailvc =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailsPrevisionViewController") as? DetailsPrevisionViewController
    }
    
    fileprivate func initLocationManager() {
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        initTableView()
        
        initCurretDate()
        
        initLocationManager()
        
        viewModel.delegate = self
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        self.viewModel.getPrevisions(longitude: locValue.longitude, latitude: locValue.latitude)
        self.viewModel.updateAdress(longitude: locValue.longitude, latitude: locValue.latitude)
        
    }
    
    func reloadTable() {
        self.tableView.reloadData()
    }
    
}
extension ViewController: UITableViewDataSource, UITableViewDelegate, ViewModelDelegate{
    
    func updateAdress(adr: String) {
        self.localisationLabel.text = adr
    }
    
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


