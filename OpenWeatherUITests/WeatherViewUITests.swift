//
//  WeatherViewUITests.swift
//  OpenWeatherUITests
//
//  Created by The Coding Kid on 02/10/2024.
//

import XCTest

final class WeatherViewUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    func testInitialState() throws {
        
        let fetchWeatherButton = app.buttons["fetchWeatherButton"]
        XCTAssertTrue(fetchWeatherButton.exists, "Fetch Weather Button should exist on screen.")
        
        let errorMessageView = app.staticTexts["errorMessageView"]
        XCTAssertTrue(errorMessageView.exists, "Error message view should be present.")
        
    }
    
    func testLoadingWeather() throws {
        
        let fetchWeatherButton = app.buttons["fetchWeatherButton"]
        XCTAssertTrue(fetchWeatherButton.exists, "Fetch Weather Button should exist on screen.")
        fetchWeatherButton.tap()
        
        let progressView = app.activityIndicators["weatherProgressView"]
        XCTAssertTrue(progressView.exists, "Progress view should appear while loading.")
    }
    
    func testSuccessfulWeatherLoad() throws {
        
        let fetchWeatherButton = app.buttons["fetchWeatherButton"]
        fetchWeatherButton.tap()

        let cityLabel = app.staticTexts["cityTitleView"]
        XCTAssertTrue(cityLabel.waitForExistence(timeout: 5), "City label should be visible after successful data load.")
        
        let temperatureLabel = app.staticTexts["temperatureLabel"]
        let humidityLabel = app.staticTexts["humidityLabel"]
        let descriptionLabel = app.staticTexts["descriptionLabel"]
        
        XCTAssertTrue(temperatureLabel.waitForExistence(timeout: 5), "City label should be visible after successful data load.")
        XCTAssertTrue(humidityLabel.waitForExistence(timeout: 5), "City label should be visible after successful data load.")
        XCTAssertTrue(descriptionLabel.waitForExistence(timeout: 5), "City label should be visible after successful data load.")
    }
}
