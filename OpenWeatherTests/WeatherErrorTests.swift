//
//  WeatherErrorTests.swift
//  OpenWeatherTests
//
//  Created by The Coding Kid on 02/10/2024.
//

import XCTest
@testable import OpenWeather

final class WeatherErrorTests: XCTestCase {
    
    func testErrorDescriptions() {
        
        let invalidURLError = WeatherError.invalidURL
        XCTAssertEqual(invalidURLError.errorDescription, "The weather service is currently unavailable. Please try again later.")
        
        let networkError = WeatherError.networkError("No internet connection.")
        XCTAssertEqual(networkError.errorDescription, "No internet connection.")
        
        let decodingError = WeatherError.decodingError
        XCTAssertEqual(decodingError.errorDescription, "Failed to decode the weather data. Please try again.")
        
        let locationUnavailableError = WeatherError.locationUnavailable
        XCTAssertEqual(locationUnavailableError.errorDescription, "Could not determine your location.")
        
        let noInternetConnection = WeatherError.noInternetConnection
        XCTAssertEqual(noInternetConnection.errorDescription, "No internet connection available, Please check your connection.")
    }
    
    func testEquatableConformance() {
        
        XCTAssertEqual(WeatherError.invalidURL, WeatherError.invalidURL)
        
        XCTAssertEqual(WeatherError.networkError("No internet connection."), WeatherError.networkError("No internet connection."))
        
        XCTAssertNotEqual(WeatherError.networkError("No internet connection."), WeatherError.networkError("Timeout error."))
        
        XCTAssertEqual(WeatherError.decodingError, WeatherError.decodingError)
        
        XCTAssertEqual(WeatherError.locationUnavailable, WeatherError.locationUnavailable)
        XCTAssertEqual(WeatherError.noInternetConnection, WeatherError.noInternetConnection)
        
        XCTAssertNotEqual(WeatherError.invalidURL, WeatherError.decodingError)
    }
    
}
