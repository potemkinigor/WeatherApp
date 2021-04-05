//
//  WeatherByDays.swift
//  WeatherApp
//
//  Created by User on 02.04.2021.
//

import Foundation

protocol WeatherByDaysProtocol {
    var dayOfWeek: String { get set}
    var iconURL: String { get set}
    var temperatureDay: Int { get set }
    var temperatureNight: Int { get set }
}

final class WeatherByDays: WeatherByDaysProtocol {
    var dayOfWeek: String
    var iconURL: String
    var temperatureDay: Int
    var temperatureNight: Int
    
    init(dayOfWeek: String, iconURL: String, temperatureDay: Int, temperatureNight: Int) {
        self.dayOfWeek = dayOfWeek
        self.iconURL = iconURL
        self.temperatureDay = temperatureDay
        self.temperatureNight = temperatureNight
    }
}
