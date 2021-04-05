//
//  CityWeatherDetails.swift
//  WeatherApp
//
//  Created by User on 02.04.2021.
//

import Foundation
import UIKit

protocol CityWeatherDetailsViewProtocol {
    func updateData(hoursData: [WeatherByHours], daysData: [WeatherByDays], cityName: String, temperature: Int, currentWeatherIconURL: String)
    func presentNetworkAlert(alert: UIAlertController)
}

protocol CityWeatherDetailsPresenterProtocol {
    func loadCityWeather(cityName: String, lattitude: Double, longitude: Double)
    func processDetailedData(cityDailyWeather: DailyWeather)
}

final class CityWeatherDetailsProtocolImplementation: CityWeatherDetailsPresenterProtocol {
    
    var view: CityWeatherDetailsViewProtocol!
    var networkManager: NetworkManagerProtocol!
    var coreDataManager: CoreDataManagerProtocol!
    
    init(view: CityWeatherDetailsViewProtocol, networkManager: NetworkManagerProtocol, coreDataManager: CoreDataManagerProtocol) {
        self.view = view
        self.networkManager = networkManager
        self.coreDataManager = coreDataManager
    }
    
    func loadCityWeather(cityName: String, lattitude: Double, longitude: Double) {
        networkManager.loadDetailedWeather(lattitude: lattitude, longitude: longitude) { [weak self] (dailyWeather) in
            if dailyWeather == nil {
                self?.generateNetworkError()
            } else {
                self?.processDetailedData(cityDailyWeather: dailyWeather!)
            }
        }
    }
    
    func processDetailedData(cityDailyWeather: DailyWeather) {
        var hoursData: [WeatherByHours] = []
        var daysData: [WeatherByDays] = []
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH"
        let currentHour = dateFormatter.string(from: Date())
        let currentHourInt = Int(currentHour)
         
        
        cityDailyWeather.forecasts![0].hours?.forEach({ (hour) in
            if Int(hour.hour!)! > currentHourInt! {
                hoursData.append(WeatherByHours(hour: hour.hour!, iconURL: hour.icon!, temperature: hour.temp!))
            }
        })
        
        let delta = cityDailyWeather.forecasts![1].hours!.count - 12 - hoursData.count
        
        if hoursData.count < 12 {
            for index in 0..<cityDailyWeather.forecasts![1].hours!.count - delta {
                hoursData.append(WeatherByHours(hour: cityDailyWeather.forecasts![1].hours![index].hour!, iconURL: cityDailyWeather.forecasts![1].hours![index].icon!, temperature: cityDailyWeather.forecasts![1].hours![index].temp!))
            }
        }
        
        for index in 1..<cityDailyWeather.forecasts!.count {
            let dayOfWeek = cityDailyWeather.forecasts![index].date!
            let iconURL = (cityDailyWeather.forecasts![index].parts?.day?.icon!)!
            let temperatureDay = (cityDailyWeather.forecasts![index].parts?.day?.tempAvg!)!
            let temperatureNight = (cityDailyWeather.forecasts![index].parts?.night?.tempAvg!)!
            
            daysData.append(WeatherByDays(dayOfWeek: dayOfWeek, iconURL: iconURL, temperatureDay: temperatureDay, temperatureNight: temperatureNight))
        }
        
        let cityName = cityDailyWeather.geoObject?.locality?.name
        let temperature = cityDailyWeather.fact?.temp
        let currentWeatherIconURL = cityDailyWeather.fact?.icon
        
        self.view.updateData(hoursData: hoursData, daysData: daysData, cityName: cityName!, temperature: temperature!, currentWeatherIconURL: currentWeatherIconURL!)
        
    }
    
    func generateNetworkError() {
        let alert = UIAlertController(title: "Ошибка сети", message: "Отсутствует подключение к интернету, либо сервер недоступен", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: nil))
        view.presentNetworkAlert(alert: alert)
    }
    
}


