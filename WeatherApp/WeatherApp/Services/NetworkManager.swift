//
//  NetworkManager.swift
//  WeatherApp
//
//  Created by User on 01.04.2021.
//

import Foundation
import Alamofire
import SVGKit


protocol NetworkManagerProtocol {
    func networkRequest (baseURL: String, path: String, parameters: Parameters, complition: @escaping (Data?) -> ())
    func loadWeather(listOfCities: [Cities], complition: @escaping ([WeatherForecast]?) -> ())
    func uploadPicture(photoName: String)
    func loadDetailedWeather(lattitude: Double, longitude: Double, complition: @escaping (DailyWeather?) -> ())
}

final class NetworkManagerImplemetation: NetworkManagerProtocol {
    
    var imagesCache = ImagesCache.shared
    
    internal func networkRequest(baseURL: String, path: String, parameters: Parameters, complition: @escaping (Data?) -> ()) {
        
        let header: HTTPHeaders = ["X-Yandex-API-Key": "40b15259-1536-42d5-a301-65dff2363c6d", "Content-Type": "application/raw"]
        
        AF.request(baseURL + path, method: .get, parameters: parameters, headers: header)
            .validate()
            .responseData { (response) in
                let data = response.data
                complition(data)
            }
    }
    
    func loadWeather(listOfCities: [Cities], complition: @escaping ([WeatherForecast]?) -> ()) {
        
        var citiesWeather: [WeatherForecast] = []
        
        let baseURL = "https://api.weather.yandex.ru"
        let path = "/v2/forecast"
        
        listOfCities.forEach { (citie) in
            let parameters: Parameters = [
                "X-Yandex-API-Key" : "40b15259-1536-42d5-a301-65dff2363c6d",
                "lat" : citie.lat,
                "lon" : citie.lon,
                "extra" : true,
                "lang" : "ru_RU"
            ]
            
            self.networkRequest(baseURL: baseURL, path: path, parameters: parameters) { (data) in
                if data != nil {
                    let cityWeather = try? JSONDecoder().decode(WeatherForecast.self, from: data!)
                    if cityWeather != nil {
                        self.uploadPicture(photoName: (cityWeather?.fact?.icon)!)
                        citiesWeather.append(cityWeather!)
                        if citiesWeather.count == listOfCities.count {
                            complition(citiesWeather)
                        }
                    } else {
                        complition(nil)
                    }
                }
            }
        } 
    }
    
    func loadDetailedWeather(lattitude: Double, longitude: Double, complition: @escaping (DailyWeather?) -> ()) {
        
        let baseURL = "https://api.weather.yandex.ru"
        let path = "/v2/forecast"
        
        let parameters: Parameters = [
            "X-Yandex-API-Key" : "40b15259-1536-42d5-a301-65dff2363c6d",
            "lat" : lattitude,
            "lon" : longitude,
            "extra" : true,
            "lang" : "ru_RU"
        ]
        
        self.networkRequest(baseURL: baseURL, path: path, parameters: parameters) { (data) in
            if data != nil {
                let cityWeather = try? JSONDecoder().decode(DailyWeather.self, from: data!)
                if cityWeather != nil {
                    self.uploadPicture(photoName: (cityWeather?.fact?.icon)!)
                    
                    cityWeather?.forecasts?.forEach({ (forecast) in
                        self.uploadPicture(photoName: (forecast.parts?.day?.icon)!)
                        forecast.hours?.forEach({ (hour) in
                            self.uploadPicture(photoName: (hour.icon)!)
                        })
                    })
                    complition(cityWeather!)
                } else {
                    complition(nil)
                }
            }
        }
    }
    
    internal func uploadPicture(photoName: String) {
        let picURL = "https://yastatic.net/weather/i/icons/blueye/color/svg/" + photoName + ".svg"
        if imagesCache.imagesCache[photoName] == nil {
            let svg = URL(string: picURL)
            let data = try? Data(contentsOf: svg!)
            let receivedimage: SVGKImage = SVGKImage(data: data)
            let image = receivedimage.uiImage
            
            imagesCache.imagesCache[photoName] = image
        } else {
            return
        }
    }
    
}
