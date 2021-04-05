//
//  LoadingScreenPresenter.swift
//  WeatherApp
//
//  Created by User on 01.04.2021.
//

import Foundation
import UIKit
import CoreData

protocol LoadingScreenViewprotocol {
    func updateCitiesWeather()
    func presentNetworkAlert(alert: UIAlertController)
}

protocol LoadingScreenPresenterProtocol {
    func updateListOfCities ()
    func loadFavoritesWeatherInformation()
    func presentNextVC(cityWeather: [WeatherForecast])
    func generateNetworkError()
    func sortCities(weatherArray: [WeatherForecast]) -> [WeatherForecast]
}

final class LoadingScreenPresenterProtocolImplementation: LoadingScreenPresenterProtocol {
    
    var view: LoadingScreenViewprotocol!
    var networkManager: NetworkManagerProtocol!
    var listOFCities: ListOfCitiesProtocol!
    var coreDataManager: CoreDataManagerProtocol!
    var viewControllerTransitionDelegate: ViewControllerTransitionDelegateProtocol!
    
    init(view: LoadingScreenViewprotocol, networkManager: NetworkManagerProtocol, listOfCities: ListOfCitiesProtocol, coreDataManager: CoreDataManagerProtocol, viewControllerTransitionDelegate: ViewControllerTransitionDelegateProtocol) {
        self.view = view
        self.networkManager = networkManager
        self.listOFCities = listOfCities
        self.coreDataManager = coreDataManager
        self.viewControllerTransitionDelegate = viewControllerTransitionDelegate
    }
    
    func updateListOfCities() {
        let context = coreDataManager.container.viewContext
        let fetchRequest = Cities.fetchRequest() as NSFetchRequest<Cities>
        
        let listOfCitiesInCoreData = try? context.fetch(fetchRequest)
        
        if listOfCitiesInCoreData?.count == 0 {
            let listOfCities = ListOfCities()
            
            listOfCities.listOfCities.forEach { (city) in
                let newElement = Cities(context: context)
                newElement.name = city.name
                newElement.lat = city.lat
                newElement.lon = city.lon
                newElement.favorite = city.favorite
            }
            coreDataManager.saveContext()
        }
    }
    
    func loadFavoritesWeatherInformation() {
        
        let context = coreDataManager.container.viewContext
        let fetchRequest = Cities.fetchRequest() as NSFetchRequest<Cities>
        fetchRequest.predicate = NSPredicate(format: "favorite == %@", NSNumber(value: true))
        
        let listOfFavoriteCities = try? context.fetch(fetchRequest)
        
        if listOfFavoriteCities == nil { return }
        
        networkManager.loadWeather(listOfCities: listOfFavoriteCities!) { [weak self] (weatherForecasts) in
            if weatherForecasts == nil {
                self?.generateNetworkError()
            } else {
                
                let sortedWeatherForecat = self?.sortCities(weatherArray: weatherForecasts!)
                
                self?.presentNextVC(cityWeather: sortedWeatherForecat!)
            }
            
            
        }
    }
    
    func presentNextVC(cityWeather: [WeatherForecast]) {

        let viewController = self.view as! LoadingScreenViewController
        let targetVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "citiesList") as CitiesWeatherListViewController
        targetVC.cityWeatherList = cityWeather
        
        targetVC.transitioningDelegate = viewControllerTransitionDelegate
        targetVC.modalPresentationStyle = .fullScreen
        
        viewController.present(targetVC, animated: true, completion: nil)
    }
    
    func generateNetworkError() {
        let alert = UIAlertController(title: "Ошибка сети", message: "Отсутствует подключение к интернету, либо сервер недоступен", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: nil))
        view.presentNetworkAlert(alert: alert)
    }
    
    func sortCities(weatherArray: [WeatherForecast]) -> [WeatherForecast] {
        let sorted = weatherArray.sorted { ($0.geoObject?.locality?.name?.lowercased())! < ($1.geoObject?.locality?.name?.lowercased())!  }
        
        return sorted
    }
    
}
