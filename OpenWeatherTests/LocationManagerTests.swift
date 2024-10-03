//
//  LocationManagerTests.swift
//  OpenWeatherTests
//
//  Created by The Coding Kid on 02/10/2024.
//

import XCTest
import CoreLocation

@testable import OpenWeather

fileprivate final class MockCLLocationManager: CLLocationManager {
    
    var mockAuthorizationStatus: CLAuthorizationStatus = .notDetermined
    var mockLocations: [CLLocation] = []
    weak var mockDelegate: CLLocationManagerDelegate?
    
    override var delegate: CLLocationManagerDelegate? {
        
        get {
            
            return super.delegate
            
        }
        
        set {
            
            super.delegate = newValue
        }
    }
    
    override var authorizationStatus: CLAuthorizationStatus {
        
        return mockAuthorizationStatus
    }
    
    override func requestWhenInUseAuthorization() {
        
        mockAuthorizationStatus = .authorizedWhenInUse
        mockDelegate?.locationManagerDidChangeAuthorization?(self)
    }
    
    override func startUpdatingLocation() {
        
        if !mockLocations.isEmpty {
            
            mockDelegate?.locationManager?(self, didUpdateLocations: mockLocations)
        }
    }
    
    
}

final class LocationManagerTests: XCTestCase {
    
    var locationManager: LocationManager!
    fileprivate var mockLocationManager: MockCLLocationManager!
    
    override func setUp() {
        super.setUp()
        
        mockLocationManager = MockCLLocationManager()
        locationManager = LocationManager()
        
        mockLocationManager.mockDelegate = locationManager
    }
    
    override func tearDown() {
        
        locationManager = nil
        mockLocationManager = nil
        
        super.tearDown()
        
    }
    

    func testCheckLocationAuthorizationWhenAuthorized() {
        
        mockLocationManager.mockAuthorizationStatus = .authorizedWhenInUse
        locationManager.checkLocationAuthorization()
        
        XCTAssertEqual(locationManager.authorizationStatus, .authorizedWhenInUse)
        XCTAssertFalse(locationManager.isPermissionDenied)
    }
    
    func testDidUpdateLocations() {
        
        let mockLocation = CLLocation(latitude: 37.7749, longitude: -122.4194)
        mockLocationManager.mockLocations = [mockLocation]
        
        mockLocationManager.mockAuthorizationStatus = .authorizedWhenInUse
        locationManager.checkLocationAuthorization()
        
        mockLocationManager.startUpdatingLocation()
        
        XCTAssertEqual(locationManager.currentLocation?.coordinate.latitude, mockLocation.coordinate.latitude)
        XCTAssertEqual(locationManager.currentLocation?.coordinate.longitude, mockLocation.coordinate.longitude)
    }
    
    func testDidFailWithError() {
        
        let error = NSError(domain: "TestError", code: 1, userInfo: nil)
        
        locationManager.locationManager(mockLocationManager, didFailWithError: error)
        
        XCTAssertEqual(locationManager.errorMessage, "Failed to find user's location: The operation couldn’t be completed. (TestError error 1.)")
    }
}
