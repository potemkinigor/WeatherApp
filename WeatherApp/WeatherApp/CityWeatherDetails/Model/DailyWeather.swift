import Foundation

// MARK: - WeatherForecast
struct DailyWeather: Codable {

    let geoObject: DailyGeoObject?
    let fact: DailyFact?
    let forecasts: [Forecast]?

    enum CodingKeys: String, CodingKey {
        case geoObject = "geo_object"
        case fact, forecasts
    }
}

// MARK: - GeoObject
struct DailyGeoObject: Codable {
    let district, locality, province, country: Country?
}

// MARK: - Fact
struct DailyFact: Codable {
    
    let temp: Int?
    let icon: String?
}

// MARK: - Forecast
struct Forecast: Codable {
    let date: String?
    let dateTs, week: Int?
    let sunrise, sunset, riseBegin, setEnd: String?
    let moonCode: Int?
    let moonText: String?
    let parts: Parts?
    let hours: [Hour]?

    enum CodingKeys: String, CodingKey {
        case date
        case dateTs = "date_ts"
        case week, sunrise, sunset
        case riseBegin = "rise_begin"
        case setEnd = "set_end"
        case moonCode = "moon_code"
        case moonText = "moon_text"
        case parts, hours
    }
}

// MARK: - Parts
struct Parts: Codable {
    let dayShort, night, day, evening: Hour?
    let morning, nightShort: Hour?

    enum CodingKeys: String, CodingKey {
        case dayShort = "day_short"
        case night, day, evening, morning
        case nightShort = "night_short"
    }
}

// MARK: - Hour
struct Hour: Codable {
    let hour: String?
    let hourTs, temp: Int?
    let feelsLike: Int?
    let icon: String?
    let cloudness: Double?
    let precType: Int?
    let precStrength: Double?
    let isThunder: Bool?
    let windSpeed, windGust: Double?
    let pressureMm, pressurePa, humidity: Int?
    let uvIndex: Int?
    let soilTemp: Int?
    let soilMoisture, precMm: Double?
    let precPeriod, precProb: Int?
    let source: String?
    let tempMin, tempAvg, tempMax: Int?
    let polar: Bool?

    enum CodingKeys: String, CodingKey {
        case hour
        case hourTs = "hour_ts"
        case temp
        case feelsLike = "feels_like"
        case icon, cloudness
        case precType = "prec_type"
        case precStrength = "prec_strength"
        case isThunder = "is_thunder"
        case windSpeed = "wind_speed"
        case windGust = "wind_gust"
        case pressureMm = "pressure_mm"
        case pressurePa = "pressure_pa"
        case humidity
        case uvIndex = "uv_index"
        case soilTemp = "soil_temp"
        case soilMoisture = "soil_moisture"
        case precMm = "prec_mm"
        case precPeriod = "prec_period"
        case precProb = "prec_prob"
        case source = "_source"
        case tempMin = "temp_min"
        case tempAvg = "temp_avg"
        case tempMax = "temp_max"
        case polar
    }
}
