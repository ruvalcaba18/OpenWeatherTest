//
//  WeatherViewModelTest.swift
//  OpenWeatherTests
//
//  Created by The Coding Kid on 02/10/2024.
//

import XCTest
import Combine
import CoreLocation
@testable import OpenWeather

@MainActor final class WeatherViewModelTests: XCTestCase {
    
    var viewModel: WeatherViewModel!
    var cancellables: Set<AnyCancellable> = []

    override func setUp() {
        super.setUp()
        let weatherManager = WeatherManager()
        let locationManager = LocationManager()
        viewModel = WeatherViewModel(weatherManager: weatherManager, locationManager: locationManager)
    }

    override func tearDown() {
        viewModel = nil
        cancellables.removeAll()
        super.tearDown()
    }

    func testFetchWeatherWithValidCity() async throws {
        
        viewModel.searchQuery = "London"
        
        let expectation = XCTestExpectation(description: "Fetch weather for valid city")
        
        viewModel.$weather
            .dropFirst()
            .sink { weather in
                if let weather = weather {
                    XCTAssertEqual(weather.name, "London")
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        await viewModel.fetchWeather(for: "London")
        
        wait(for: [expectation], timeout: 5.0)
        
        XCTAssertTrue(viewModel.errorMessage.isEmpty)
        XCTAssertFalse(viewModel.isLoading)
    }

    func testFetchWeatherForInvalidCity() async {

        viewModel.searchQuery = "InvalidCityName1234"
        

        let expectation = XCTestExpectation(description: "Fetch weather for invalid city")
        

        viewModel.$errorMessage
            .dropFirst()
            .sink { errorMessage in
                if !errorMessage.isEmpty {
                    XCTAssertEqual(errorMessage, WeatherError.networkError("Invalid response from the server.").localizedDescription)
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        

        await viewModel.fetchWeather(for: "InvalidCityName1234")

        wait(for: [expectation], timeout: 5.0)
        
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.isLoading)
    }

   
}
