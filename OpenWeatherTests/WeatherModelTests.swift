//
//  WeatherModelTests.swift
//  OpenWeatherTests
//
//  Created by The Coding Kid on 02/10/2024.
//

import XCTest
@testable import OpenWeather

final class WeatherModelTests: XCTestCase {

    func testWeatherDecoding() throws {

          let json = """
          {
              "name": "San Francisco",
              "main": {
                  "temp": 18.5,
                  "humidity": 77
              },
              "weather": [
                  {
                      "description": "Cloudy",
                      "icon": "03d"
                  }
              ]
          }
          """.data(using: .utf8)!

          let decoder = JSONDecoder()
          let weather = try decoder.decode(Weather.self, from: json)
          
          XCTAssertEqual(weather.name, "San Francisco")
          XCTAssertEqual(weather.main.temp, 18.5)
          XCTAssertEqual(weather.main.humidity, 77)
          XCTAssertEqual(weather.weather.first?.description, "Cloudy")
          XCTAssertEqual(weather.weather.first?.icon, "03d")
      }
      
      func testDefaultWeather() {
          
          let defaultWeather = Weather.defaultWeather
          
          XCTAssertEqual(defaultWeather.name, "Unknown City")
          XCTAssertEqual(defaultWeather.main.temp, 0.0)
          XCTAssertEqual(defaultWeather.main.humidity, 0)
          XCTAssertEqual(defaultWeather.weather.first?.description, "Clear")
          XCTAssertEqual(defaultWeather.weather.first?.icon, "01d")
      }

}
