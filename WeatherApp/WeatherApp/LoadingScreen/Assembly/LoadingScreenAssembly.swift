//
//  LoadingScreenAssembly.swift
//  WeatherApp
//
//  Created by User on 01.04.2021.
//

import Foundation
import UIKit

final class LoadingScreenAssembly: NSObject {
    @IBOutlet weak var viewController: UIViewController!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        guard let view = self.viewController as? LoadingScreenViewController else { return }
        let networkRequest = NetworkManagerImplemetation()
        let listOfCities = ListOfCities()
        let coreDataManager = PersistanceContainer.shared
        let viewControllerTranstionDelegate = ViewControllerTransitionDelegate()
        
        let presenter = LoadingScreenPresenterProtocolImplementation(view: view, networkManager: networkRequest, listOfCities: listOfCities, coreDataManager: coreDataManager, viewControllerTransitionDelegate: viewControllerTranstionDelegate)
        
        view.presenterProtocol = presenter
        
    }
}
