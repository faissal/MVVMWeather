//
//  PrevisionsViewModel.swift
//  MVVM Weather
//
//  Created by Faissal Nabil on 28/08/2019.
//  Copyright © 2019 Macbook. All rights reserved.
//

import Foundation

protocol ViewModelDelegate: class {
    func reloadTable()
    func showActivityLoader()
    func hideActivityLoader()
    
}

class PrevisionsViewModel {
    
    var dataItems:[Prevision] = []
    var repository: PrevisionsRepository?
    var numberOfEntries = 0
    
    weak var delegate: ViewModelDelegate?
    
    init() {
        repository = PrevisionsRepository()
    }
    
    func getPrevisions(longitude: Double, latitude: Double) {
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateFormated = formatter.string(from: date)
        
        delegate?.showActivityLoader()
        
        repository?.getPrevision(dateFormated: dateFormated, longitude: longitude, latitude: latitude, success: { (result) in
            self.dataItems = result
            self.numberOfEntries = self.dataItems.count
            self.delegate?.reloadTable()
            self.delegate?.hideActivityLoader()
        }, failure: { (error) in
            self.delegate?.hideActivityLoader()
        })
        
    }
}
