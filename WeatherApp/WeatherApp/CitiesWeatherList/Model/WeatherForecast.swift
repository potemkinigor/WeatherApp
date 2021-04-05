import Foundation

// MARK: - WeatherForecast
struct WeatherForecast: Codable {
    let geoObject: GeoObject?
    let fact: Fact?
    let info: Info?

    enum CodingKeys: String, CodingKey {
        case geoObject = "geo_object"
        case fact
        case info
    }
}

// MARK: - GeoObject
struct GeoObject: Codable {
    let district, locality, province, country: Country?
}

// MARK: - Country
struct Country: Codable {
    let id: Int?
    let name: String?
}

// MARK: - Fact
struct Fact: Codable {
    let temp: Int?
    let icon: String?
}

struct Info: Codable {
    let lat, lon: Double?
}

