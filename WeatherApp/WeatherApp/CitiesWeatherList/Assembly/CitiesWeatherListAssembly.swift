//
//  CitiesWeatherListAssembly.swift
//  WeatherApp
//
//  Created by User on 01.04.2021.
//

import Foundation
import UIKit

final class CitiesWeatherListAssembly: NSObject {
    @IBOutlet weak var viewController: UIViewController!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        guard let view = self.viewController as? CitiesWeatherListViewController else { return }
        let networkRequest = NetworkManagerImplemetation()
        let coreDataManager = PersistanceContainer.shared
        let viewControllerTransitionDelegate = ViewControllerTransitionDelegate()
        
        let presenter = CitiesWeatherListIntputProtocolImplementation(view: view, networkManager: networkRequest, coreDataManager: coreDataManager, viewControllerTransitionDelegate: viewControllerTransitionDelegate)
        
        view.presenterProtocol = presenter
        
    }
}
