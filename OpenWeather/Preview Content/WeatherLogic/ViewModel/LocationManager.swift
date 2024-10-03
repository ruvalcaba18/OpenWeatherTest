//
//  LocationManager 2.swift
//  OpenWeather
//
//  Created by The Coding Kid on 02/10/2024.
//


import Foundation
import CoreLocation

final class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    private let locationManager = CLLocationManager()
    
    @Published var currentLocation: CLLocation?
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published var isPermissionDenied: Bool = false
    @Published var errorMessage: String? = ""
    
    override init() {
        
        super.init()
        
        locationManager.delegate = self
        checkLocationAuthorization()
        
    }
    
    func checkLocationAuthorization() {
        
        let status = locationManager.authorizationStatus
        authorizationStatus = status
        
        switch status {
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break;
        case .restricted, .denied:
            
            isPermissionDenied = true
            break;
            
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            break;
            
        @unknown default:
            break
        }
    }
    
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
        authorizationStatus = manager.authorizationStatus
        
        switch authorizationStatus {
            
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
            break;
            
        case .denied, .restricted:
            isPermissionDenied = true
            errorMessage = "Please turn on location services in your device settings"
            break;
            
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        currentLocation = locations.last
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        errorMessage = "Failed to find your user's location 😅"
        
    }
    
}
