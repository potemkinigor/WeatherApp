//
//  CitiesWeatherListPresenter.swift
//  WeatherApp
//
//  Created by User on 01.04.2021.
//

import Foundation
import CoreData
import UIKit

protocol CitiesWeatherListViewProtocol {
    func updateFavorites(weather: [WeatherForecast])
    func presentNetworkAlert(alert: UIAlertController)
}

protocol CitiesWeatherListPresenterProtocol {
    func loadCurrentWeather()
    func searchCity(text: String)
    func removeFromFavorites(city: WeatherForecast)
    func addToFavorites(city: Cities)
    func showDetailsWindow(city: String, lattitude: Double, longitude: Double)
    func generateNetworkError()
    func sortCities(weatherArray: [WeatherForecast]) -> [WeatherForecast]
}

final class CitiesWeatherListIntputProtocolImplementation: CitiesWeatherListPresenterProtocol {
    var view: CitiesWeatherListViewProtocol!
    var networkManager: NetworkManagerProtocol!
    var coreDataManager: CoreDataManagerProtocol!
    var viewControllerTransitionDelegate: ViewControllerTransitionDelegateProtocol!
    
    init(view: CitiesWeatherListViewProtocol, networkManager: NetworkManagerProtocol, coreDataManager: CoreDataManagerProtocol, viewControllerTransitionDelegate: ViewControllerTransitionDelegateProtocol) {
        self.view = view
        self.networkManager = networkManager
        self.coreDataManager = coreDataManager
        self.viewControllerTransitionDelegate = viewControllerTransitionDelegate
    }
    
    func loadCurrentWeather() {
        let context = coreDataManager.container.viewContext
        let fetchRequest = Cities.fetchRequest() as NSFetchRequest<Cities>
        fetchRequest.predicate = NSPredicate(format: "favorite == %@", NSNumber(value: true))
        
        let listOfFavoriteCities = try? context.fetch(fetchRequest)
        
        if listOfFavoriteCities == nil { return }
        
        networkManager.loadWeather(listOfCities: listOfFavoriteCities!) { [weak self] (weatherForecasts) in
            if weatherForecasts == nil {
                self?.generateNetworkError()
            } else {
                let sortedWeather = self?.sortCities(weatherArray: weatherForecasts!)
                self?.view.updateFavorites(weather: sortedWeather!)
            }
        }
    }
    
    func searchCity(text: String) {
        let context = coreDataManager.container.viewContext
        let fetchRequest = Cities.fetchRequest() as NSFetchRequest<Cities>
        fetchRequest.predicate = NSPredicate(format: "name CONTAINS %@", text)
        
        let listOfCities = try? context.fetch(fetchRequest)
        
        let viewController = self.view as! CitiesWeatherListViewController
        let targetVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "searchCity") as SearchCityViewController
        targetVC.modalPresentationStyle = .popover
        
        if listOfCities != nil && listOfCities?.count != 0 {
            targetVC.listOfCities = listOfCities!
        } else {
            targetVC.errorMessage = "Города не найдены"
        }
        
        targetVC.parentVC = viewController
        
        viewController.searchBar.resignFirstResponder()
        viewController.searchBar.text = ""
        viewController.searchBar.showsCancelButton = false
        
        viewController.present(targetVC, animated: true, completion: nil)
    }
    
    func removeFromFavorites(city: WeatherForecast) {
        
        let lattitude = String((city.info?.lat!)!)
        let longitude = String((city.info?.lon!)!)
        
        let context = coreDataManager.container.viewContext
        let fetchRequest = Cities.fetchRequest() as NSFetchRequest<Cities>
      
        fetchRequest.predicate = NSPredicate(format: "lat == %@ and lon == %@", lattitude, longitude)
        
        let listOfCities = try? context.fetch(fetchRequest)
        
        if listOfCities != nil && listOfCities?.count != 0 {
            let city = listOfCities?.first
            city?.favorite = false
            
            coreDataManager.saveContext()
        }
    }
    
    func addToFavorites(city: Cities) {
        let cityName = city.name!
        
        let context = coreDataManager.container.viewContext
        let fetchRequest = Cities.fetchRequest() as NSFetchRequest<Cities>
      
        fetchRequest.predicate = NSPredicate(format: "name == %@", cityName)
        
        let listOfCities = try? context.fetch(fetchRequest)
        
        if listOfCities != nil && listOfCities?.count != 0 {
            let city = listOfCities?.first
            city?.favorite = true
            
            coreDataManager.saveContext()
        }
        
        self.loadCurrentWeather()
    }
    
    func showDetailsWindow(city: String, lattitude: Double, longitude: Double) {
        let viewController = self.view as! CitiesWeatherListViewController
        let targetVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "detailedCityWeather") as CityWeatherViewController
        targetVC.transitioningDelegate = viewControllerTransitionDelegate
        targetVC.modalPresentationStyle = .fullScreen
        
        targetVC.cityName = city
        targetVC.cityLattitude = lattitude
        targetVC.cityLongitude = longitude
        
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
