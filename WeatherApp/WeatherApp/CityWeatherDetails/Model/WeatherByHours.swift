//
//  WeatherByHours.swift
//  WeatherApp
//
//  Created by User on 02.04.2021.
//

import Foundation

protocol WeatherByHoursProtocol {
    var hour: String { get set}
    var iconURL: String { get set}
    var temperature: Int { get set }
}

final class WeatherByHours: WeatherByHoursProtocol {
    var hour: String
    var iconURL: String
    var temperature: Int
    
    init(hour: String, iconURL: String, temperature: Int) {
        self.hour = hour
        self.iconURL = iconURL
        self.temperature = temperature
    }
}
