//
//  WeatherData.swift
//  DVTWeather App
//
//  Created by Lawrence Magerer on 25/02/2022.
//

import Foundation

struct WeatherData : Codable {
    let coord: Coord
    let weather: [Weather]?
    let main: Main?
    let base: String
    let visibility: Int
    let wind: Wind
    let clouds: Clouds
    let dt: Double
    let sys: Sys
    let timezone: Int
    let id: Int
    let name: String?
    let cod: Int
    
}

// MARK: Weather - Clouds
struct Clouds: Codable {
    let all: Int
}

// MARK: Weather - Coord
struct Coord: Codable {
    let lon: Double
    let lat: Double
}


// MARK: Weather Info
struct Weather: Codable {
    let id : Int
    let main: String
    let description: String
    let icon: String
}

// MARK: Weather Main
struct Main: Codable {
    
    let temp: Double
    let feelsLike: Double
    let tempMin: Double
    let tempMax: Double
    let pressure: Int
    let humidity: Int
    
    enum CodingKeys: String, CodingKey {
        case temp, humidity
        case pressure
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case feelsLike = "feels_like"
    }
}


// MARK: Weather - Sys
struct Sys: Codable {
    let type: Int?
    let id: Int?
    let country: String
    let sunrise: Int
    let sunset: Int
}

// MARK: Weather - Wind
struct Wind: Codable {
    let speed: Double
    let deg: Double?
}
