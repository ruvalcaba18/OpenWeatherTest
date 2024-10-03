//
//  WeatherManagerTests.swift
//  OpenWeatherTests
//
//  Created by The Coding Kid on 02/10/2024.
//

import XCTest
import CoreLocation

@testable import OpenWeather

final class WeatherManagerTests: XCTestCase {
    
    var weatherManager: WeatherManager!
    
    override func setUp() {
        super.setUp()
        weatherManager = WeatherManager()
    }
    
    override func tearDown() {
        weatherManager = nil
        super.tearDown()
    }
    
    func testGetWeatherForValidCity() async throws {
        
        let city = "London"
        
        do {
            let weather = try await weatherManager.getWeather(for: city)
            XCTAssertEqual(weather.name, "London")
            XCTAssertGreaterThan(weather.main.temp, -50)
        } catch {
            XCTFail("Fetching weather failed with error: \(error)")
        }
        
    }
    
    func testGetWeatherForInvalidCity() async throws {
        
        let city = "InvalidCityName1234"
        
        do {
            _ = try await weatherManager.getWeather(for: city)
            XCTFail("This request should fail for an invalid city.")
        } catch let error as WeatherError {
            XCTAssertEqual(error, .networkError("Invalid response from the server."))
        } catch {
            XCTFail("Unexpected error: \(error.localizedDescription)")
        }
    }
    
    func testGetWeatherForValidLocation() async throws {
        
        let location = CLLocation(latitude: 37.7749, longitude: -122.4194)
        
        do {
            let weather = try await weatherManager.getWeather(for: location)
            XCTAssertEqual(weather.name, "San Francisco")
            XCTAssertGreaterThan(weather.main.temp, -50)
        } catch {
            XCTFail("Fetching weather failed with error: \(error)")
        }
    }
    
    func testGetWeatherForInvalidLocation() async throws {
        
        let location = CLLocation(latitude: 1000, longitude: 1000)
        
        do {
            _ = try await weatherManager.getWeather(for: location)
            XCTFail("This request should fail for invalid coordinates.")
        } catch let error as WeatherError {
            XCTAssertEqual(error, .networkError("Invalid response from the server."))
        } catch {
            XCTFail("Unexpected error: \(error.localizedDescription)")
        }
    }
    
}
