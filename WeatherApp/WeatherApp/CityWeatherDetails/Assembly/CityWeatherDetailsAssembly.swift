//
//  CityWeatherDetailsAssembly.swift
//  WeatherApp
//
//  Created by User on 02.04.2021.
//

import Foundation

import UIKit

final class CityWeatherDetailsAssembly: NSObject {
    @IBOutlet weak var viewController: UIViewController!
    
   
    override func awakeFromNib() {
        super.awakeFromNib()
        
        guard let view = self.viewController as? CityWeatherViewController else { return }
        let networkRequest = NetworkManagerImplemetation()
        let coreDataManager = PersistanceContainer.shared
        
        let presenter = CityWeatherDetailsProtocolImplementation(view: view, networkManager: networkRequest, coreDataManager: coreDataManager)
        
        view.presenterProtocol = presenter
    }
}
