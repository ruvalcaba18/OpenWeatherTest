//
//  WeatherModel.swift
//  OpenWeather
//
//  Created by The Coding Kid on 02/10/2024.
//

import Foundation

struct MainModel: Codable {
    let temp: Double
    let humidity: Int
}

struct WeatherDetail: Codable {
    let description: String
    let icon: String
}

struct Weather: Codable {
    let name: String
    let main: MainModel
    let weather: [WeatherDetail]
}

extension Weather {
    
    static var defaultWeather: Weather {
        Weather(
            name: "Unknown City",
            main: MainModel(temp: 0.0, humidity: 0),
            weather: [WeatherDetail(description: "Clear", icon: "01d")]
        )
    }
}
